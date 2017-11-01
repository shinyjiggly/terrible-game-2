#==============================================================================
# ** Tilemap (Extra Autotiles)
#------------------------------------------------------------------------------
# SephirothSpawn
# Version 1.1 a
# 2007-06-03
# SDK Compatible with Version 2.2 + : Parts I & II
#------------------------------------------------------------------------------
# * Description :
#
#   This script was designed to allow you to add more than 7 autotiles to your
#   maps. This is not the easiest script to work with, as you have to specify
#   which autotiles are on a certain tile based off position and layer. 
#
#   To use this you simply have to create your map as you normal would. Where
#   you would want to place your additional tiles. Pick autotiles that have
#   similar passbilities and other properties.
#
#   Then define your new map autotiles in the script editor and your new
#   autotile indexes.
#------------------------------------------------------------------------------
# * Requirements :
#
#   Tilemap 1.0
#------------------------------------------------------------------------------
# * Instructions :
#
#   Place The Script Below Scene_Debug and Above Main.
#------------------------------------------------------------------------------
# * Customization :
#
#   Defining Extra Tiles for your map
#    - Map_Autotiles = {map_id => {autotile_index => filename, ... }, ...}
#
#   Defining autotiles
#    - Autotile_Data = {map_id => Table, ... }
#
# * Creating your table
#
#   Start off by below Autotile_Data.default = nil, add :
#    - Autotile_Data[your_map_id] = Table.new(map_width, map_height, 3)
#
#   Now, where you want to change the autotile (based off index defined in
#   Map_Autotiles), use :
#    - Autotile_Data[your_map_id][x, y, layer] = extra_autotile_index
#==============================================================================


#==============================================================================
# ** Extra_Autotiles
#==============================================================================
  
module Extra_Autotiles
  #--------------------------------------------------------------------------
  # * Map Autotiles
  #
  #   Map_Autotiles = {map_id => {autotile_index => filename, ... }, ...}
  #--------------------------------------------------------------------------
  Map_Autotiles = {}
  Map_Autotiles.default = {}
  #--------------------------------------------------------------------------
  # * Map Data
  #
  #   Map_Autotiles = {map_id => Table.new, ...}
  #--------------------------------------------------------------------------
  Autotile_Data = {}
  Autotile_Data.default = nil
  #--------------------------------------------------------------------------
  # * Demo Purposes Only - Delete
  #--------------------------------------------------------------------------
  Map_Autotiles[1] = {
    7  => '023-Sa_Undulation01',
    8  => '048-Water01',
    9  => '062-CF_Lava01',
    10 => '074-CW_Water01',
  }
  #--------------------------------------------------------------------------
  # * Read Text Files - Do Not Modify anything but Directory
  #--------------------------------------------------------------------------
  Dir = 'Extra Autotiles/'
  load_data('Data/MapInfos.rxdata').each_key do |map_id|
    existing_files = []
    for i in 1..3
      filename = "#{Dir}Map_#{map_id}_layer_#{i}.txt"
      existing_files << i if FileTest.exist?(filename)
    end
    next if existing_files.empty?
    map = load_data(sprintf("Data/Map%03d.rxdata", map_id))
    Autotile_Data[map_id] = Table.new(map.width, map.height, 3)
    existing_files.each do |i|
      lines = IO.readlines("#{Dir}Map_#{map_id}_layer_#{i}.txt")
      for y in 0...lines.size
        line = lines[y]
        line.delete!("\n")
        line = line.split(' ')
        for x in 0...line.size
          Autotile_Data[map_id][x, y, i - 1] = line[x].to_i
        end
      end
    end
  end
end
  
#==============================================================================
# ** RPG::Tileset
#==============================================================================
  
class RPG::Tileset
  #--------------------------------------------------------------------------
  # * Extra Autotiles
  #--------------------------------------------------------------------------
  def extra_autotiles
    return Extra_Autotiles::Map_Autotiles[@id]
  end
  #--------------------------------------------------------------------------
  # * Extra Autotiles Data
  #--------------------------------------------------------------------------
  def extra_autotiles_data
    return Extra_Autotiles::Autotile_Data[@id]
  end
end

#==============================================================================
# ** Game_Map
#==============================================================================
  
class Game_Map
  #--------------------------------------------------------------------------
  # * Extra Autotiles
  #--------------------------------------------------------------------------
  def extra_autotiles
    return $data_tilesets[@map.tileset_id].extra_autotiles
  end
  #--------------------------------------------------------------------------
  # * Extra Autotiles Data
  #--------------------------------------------------------------------------
  def extra_autotiles_data
    return $data_tilesets[@map.tileset_id].extra_autotiles_data
  end
end
  
#==============================================================================
# ** Spriteset_Map
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias_method :seph_extraautotiles_ssmap_inittm, :initialize
  #--------------------------------------------------------------------------
  # * Tilemap Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Original Tilemap Initialization
    seph_extraautotiles_ssmap_inittm
    # Set Extra Autotile Data
    @tilemap.extra_autotiles = {}
    @tilemap.extra_autotiles_name = {}
    # Set Extra Autotiles
    $game_map.extra_autotiles.each do |index, filename|
      @tilemap.extra_autotiles[index] = RPG::Cache.autotile(filename)
      @tilemap.extra_autotiles_name[index] = filename
    end
    # Set Extra Autotiles Data
    @tilemap.extra_autotiles_data = $game_map.extra_autotiles_data
    # Frame update
    update
  end
end

#==============================================================================
# ** Tilemap
#==============================================================================

class Tilemap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :extra_autotiles
  attr_accessor :extra_autotiles_name
  attr_accessor :extra_autotiles_data
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias_method :seph_extraautotiles_tilemap_dat, :draw_autotile
  #--------------------------------------------------------------------------
  # * Draw Auto-Tile
  #--------------------------------------------------------------------------
  def draw_autotile(x, y, z, tile_id)
    # Set Original Autotile Name
    return if @autotiles_name[tile_id/48-1] == nil
    filename = @autotiles_name[tile_id / 48 - 1].dup
    # Attempts to Reconfigure Autotile ID
    unless @extra_autotiles_data.nil?
      # If Non-Table Autotile Data
      unless extra_autotiles_data.is_a?(Table)
        if Tilemap_Options::Print_Error_Logs
          p 'Extra Autotile Data not as a Table.'
        end
      # If Table
      else
        # Unless New Autotile ID is 0
        unless @extra_autotiles_data[x, y, z] == 0
          # Gets New Filename
          new = @extra_autotiles_name[@extra_autotiles_data[x, y, z]].dup
          # Sets New Filename
          @autotiles_name[tile_id / 48 - 1] = new
        end
      end
    end
    # Original Draw Auto-Tile
    seph_extraautotiles_tilemap_dat(x, y, z, tile_id)
    # Resets Filename
    @autotiles_name[tile_id / 48 - 1] = filename
  end
end   