#==============================================================================
# ** Tilemap (Basic)
#------------------------------------------------------------------------------
# SephirothSpawn
# Version 1.0 a
# 2007-05-30
# SDK Compatible with Version 2.2 + : Parts I & II
#------------------------------------------------------------------------------
# * Credits :
#
#   Thanks to Trickster for conversion formula for Hexidecimal to rgb.
#   Thanks to trebor777 for helping with the priority bug from the 0.9 version.
#------------------------------------------------------------------------------
# * Description :
#
#   This script was designed to re-write the default RMXP Hidden Tileset class.
#   The script has added many features and a new "Tilemap Settings" class,
#   that can be unique if you create mini-maps using this system.
#------------------------------------------------------------------------------
# * Instructions :
#
#   Place The Script Below Scene_Debug and Above Main.
#------------------------------------------------------------------------------
# * Syntax :
#
#   Get Autotile Tile Bitmap
#    - RPG::Cache.autotile_tile(autotile_filename, tile_id[, hue[, frame_id]])
#
#      autotile_filename : Filename of autotile
#      tile_id : ID of tile (Found from RPG::Map.data)
#      hue (Optional) : Hue for tile
#      frame_id (Optional) : Frame of tile (for animated autotiles)
#
# * Tilemap Syntax
#
#   Readable Attributes :
#    - layers : Array of Sprites (or Planes)
#
#   Readable/Writable Attributes :
#    - tileset (No long required) : Bitmap for Tileset
#    - tileset_name : Name of Bitmap
#    - autotiles (No long required) : Array of Autotile Bitmaps
#    - autotiles_name : Array of Autotile Filenames
#    - map_data : 3D Table of Tile ID Data
#    - flash_data : 3D Table of Tile Flash Data 
#                   (Should match tilemap_settings.flash_data)
#    - priorities : 3D Table of Tile Priorities
#    - Visible : Tilemap Visible Flag
#    - ox, oy : Tilemap layer offsets
#    - tilemap_settings : Unique Special Settings Object (See Below)
#    - refresh_autotiles : Refresh Autotiles on frame reset flag
#
# * Special Tilemap Settings
#
#   To make special settings easier to control for your game map and any other
#   special tilemap sprites you wish to create, a special class was created
#   to hold these settings. For your game tilemap, a Tilemap_Settings object
#   was created in $game_map ($game_map.tilemap_settings). It is advised to 
#   modify $game_map.tilemap_settings.flash_data instead of tilemap.flash_data.
#
#   Readable/Writeable Attributes :
#    - map : RPG::Map (Not required, but for additions)
#    - is_a_plane : Boolean whether layers are Sprites or Planes
#    - tone : Tone for all layers
#    - hue : Hue for all layers
#    - zoom_x, zoom_y : Zoom factor for all layers
#    - tilesize : Tilesize displayed on map
#    - flash_data : 3D Table of flash_data
#==============================================================================


#==============================================================================
# ** Tilemap_Options
#==============================================================================

module Tilemap_Options
  #--------------------------------------------------------------------------
  # * Tilemap Options
  #
  #
  #   Print Error Reports when not enough information set to tilemap
  #    - Print_Error_Logs          = true or false
  #
  #   Number of autotiles to refresh at edge of viewport
  #   Number of Frames Before Redrawing Animated Autotiles
  #    - Animated_Autotiles_Frames = 16
  #
  #    - Viewport_Padding          = n
  #
  #   When maps are switch, automatically set 
  #   $game_map.tileset_settings.flash_data (Recommended : False unless using
  #   flash_data)
  #    - Autoset_Flash_data        = true or false
  #
  #   Duration Between Flash Data Flashes
  #    - Flash_Duration            = n
  #
  #   Color of bitmap (Recommended to use low opacity value)
  #    - Flash_Bitmap_C            = Color.new(255, 255, 255, 50)
  #
  #   Update Flashtiles Default Setting
  #   Explanation : In the Flash Data Addition, because of lag, you may wish
  #   to toggle whether flash tiles flash or not. This is the default state.
  #    - Default_Update_Flashtiles = false
  #--------------------------------------------------------------------------
  Print_Error_Logs          = true
  Animated_Autotiles_Frames = 16
  Autoset_Flash_data        = true
  Viewport_Padding          = 2
  Flash_Duration            = 40
  Flash_Bitmap_C            = Color.new(255, 255, 255, 50)
  Default_Update_Flashtiles = false
end

#==============================================================================
# ** RPG::Cache
#==============================================================================

module RPG::Cache
  #--------------------------------------------------------------------------
  # * Auto-Tiles
  #
  #   Auto-Tile 48 : First Auto-Tile, Constructed of tiles 27, 28, 33, 34
  #--------------------------------------------------------------------------
  Autotiles = [
    [[27, 28, 33, 34], [ 5, 28, 33, 34], [27,  6, 33, 34], [ 5,  6, 33, 34],
     [27, 28, 33, 12], [ 5, 28, 33, 12], [27,  6, 33, 12], [ 5,  6, 33, 12]],
    [[27, 28, 11, 34], [ 5, 28, 11, 34], [27,  6, 11, 34], [ 5,  6, 11, 34],
     [27, 28, 11, 12], [ 5, 28, 11, 12], [27,  6, 11, 12], [ 5,  6, 11, 12]],
    [[25, 26, 31, 32], [25,  6, 31, 32], [25, 26, 31, 12], [25,  6, 31, 12],
     [15, 16, 21, 22], [15, 16, 21, 12], [15, 16, 11, 22], [15, 16, 11, 12]],
    [[29, 30, 35, 36], [29, 30, 11, 36], [ 5, 30, 35, 36], [ 5, 30, 11, 36],
     [39, 40, 45, 46], [ 5, 40, 45, 46], [39,  6, 45, 46], [ 5,  6, 45, 46]],
    [[25, 30, 31, 36], [15, 16, 45, 46], [13, 14, 19, 20], [13, 14, 19, 12],
     [17, 18, 23, 24], [17, 18, 11, 24], [41, 42, 47, 48], [ 5, 42, 47, 48]],
    [[37, 38, 43, 44], [37,  6, 43, 44], [13, 18, 19, 24], [13, 14, 43, 44],
     [37, 42, 43, 48], [17, 18, 47, 48], [13, 18, 43, 48], [ 1,  2,  7,  8]]
  ]
  #--------------------------------------------------------------------------
  # * Autotile Cache
  #
  #   @autotile_cache = { 
  #     filename => { [autotile_id, frame_id, hue] => bitmap, ... },
  #     ...
  #    }
  #--------------------------------------------------------------------------
  @autotile_cache = {}
  #--------------------------------------------------------------------------
  # * Autotile Tile
  #--------------------------------------------------------------------------
  def self.autotile_tile(filename, tile_id, hue = 0, frame_id = nil)
    # Gets Autotile Bitmap
    autotile = self.autotile(filename)
    # Configures Frame ID if not specified
    if frame_id.nil?
      # Animated Tiles
      frames = autotile.width / 96
      # Configures Animation Offset
      fc = Graphics.frame_count / Tilemap_Options::Animated_Autotiles_Frames
      frame_id = (fc) % frames * 96
    end
    # Creates list if already not created
    @autotile_cache[filename] = {} unless @autotile_cache.has_key?(filename)
    # Gets Key
    key = [tile_id, frame_id, hue]
    # If Key Not Found
    unless @autotile_cache[filename].has_key?(key)
      # Reconfigure Tile ID
      tile_id %= 48
      # Creates Bitmap
      bitmap = Bitmap.new(32, 32)
      # Collects Auto-Tile Tile Layout
      tiles = Autotiles[tile_id / 8][tile_id % 8]
      # Draws Auto-Tile Rects
      for i in 0...4
        tile_position = tiles[i] - 1
        src_rect = Rect.new(tile_position % 6 * 16 + frame_id, 
          tile_position / 6 * 16, 16, 16)
        bitmap.blt(i % 2 * 16, i / 2 * 16, autotile, src_rect)
      end
      # Saves Autotile to Cache
      @autotile_cache[filename][key] = bitmap
      # Change Hue
      @autotile_cache[filename][key].hue_change(hue)
    end
    # Return Autotile
    return @autotile_cache[filename][key]
  end
end

#==============================================================================
# ** Tilemap_Settings
#==============================================================================

class Tilemap_Settings
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :map
  attr_accessor :is_a_plane
  attr_accessor :tone
  attr_accessor :hue
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :tile_size
  attr_accessor :flash_data
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(map = nil)
    # Set Instance Variables
    @map, @is_a_plane, @tone, @hue, @zoom_x, @zoom_y, @tile_size, 
      @flash_data = map, false, nil, 0, 1.0, 1.0, 32, nil
  end
end

#==============================================================================
# ** Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :tilemap_settings
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias_method :seph_tilemap_gmap_init, :initialize
  alias_method :seph_tilemap_gmap_stld, :setup
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Original Initialization
    seph_tilemap_gmap_init
    # Create Tilemap Settings
    @tilemap_settings = Tilemap_Settings.new
  end
  #--------------------------------------------------------------------------
  # * Load Map Data
  #--------------------------------------------------------------------------
  def setup(map_id)
    # Original Load Map Data
    seph_tilemap_gmap_stld(map_id)
    # Reset Tilemap Flash Data
    if Tilemap_Options::Autoset_Flash_data
      @tilemap_settings.flash_data = Table.new(@map.width, @map.height)
    end
    @tilemap_settings.map = @map
  end
end

#==============================================================================
# ** Spriteset_Map
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias_method :seph_tilemap_ssmap_inittm, :initialize
  #--------------------------------------------------------------------------
  # * Tilemap Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Original Tilemap Initialization
    seph_tilemap_ssmap_inittm
    # Set Tilemap Settings
    @tilemap.tileset_name = $game_map.tileset_name
    for i in 0..6
      @tilemap.autotiles_name[i] = $game_map.autotile_names[i]
    end
    @tilemap.tilemap_settings = $game_map.tilemap_settings
    # Setup Flash Data
    @tilemap.flash_data = $game_map.tilemap_settings.flash_data
    # Run Tilemap Setup
    @tilemap.setup
  end
end

#==============================================================================
# ** Tilemap
#==============================================================================

class Tilemap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :layers
  attr_accessor :tileset
  attr_accessor :tileset_name
  attr_accessor :autotiles
  attr_accessor :autotiles_name
  attr_accessor :map_data
  attr_accessor :flash_data
  attr_accessor :priorities
  attr_accessor :visible
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :tilemap_settings
  attr_accessor :refresh_autotiles
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport)
    # Saves Viewport
    @viewport = viewport
    # Creates Blank Instance Variables
    @layers            = []    # Refers to Array of Sprites or Planes
    @tileset           = nil   # Refers to Tileset Bitmap
    @tileset_name      = ''    # Refers to Tileset Filename
    @autotiles         = []    # Refers to Array of Autotile Bitmaps
    @autotiles_name    = []    # Refers to Array of Autotile Filenames
    @map_data          = nil   # Refers to 3D Array Of Tile Settings
    @flash_data        = nil   # Refers to 3D Array of Tile Flashdata
    @priorities        = nil   # Refers to Tileset Priorities
    @visible           = true  # Refers to Tilest Visibleness
    @ox                = 0     # Bitmap Offsets          
    @oy                = 0     # Bitmap Offsets
    @tilemap_settings  = nil   # Special Tilemap Settings
    @dispose           = false # Disposed Flag
    @refresh_autotiles = true  # Refresh Autotile Flag
  end
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup
    # Print Error if Tilemap Settings not Found
    if Tilemap_Options::Print_Error_Logs
      if @tilemap_settings.nil?
        p 'Tilemap Settings have not been set. System will not crash.'
      end
      if @map_data.nil?
        p 'Map Data has not been set. System will crash.'
      end
    end
    # Creates Layers
    @layers = []
    for l in 0...3
      layer = @tilemap_settings.nil? || !@tilemap_settings.is_a_plane ?
        Sprite.new(@viewport) : Plane.new(@viewport)
      layer.bitmap = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
      layer.z = l * 150
      layer.zoom_x = @tilemap_settings.nil? ? 1.0 : @tilemap_settings.zoom_x
      layer.zoom_y = @tilemap_settings.nil? ? 1.0 : @tilemap_settings.zoom_y
      unless @tilemap_settings.nil? || @tilemap_settings.tone.nil?
        layer.tone = @tilemap_settings.tone
      end
      @layers << layer
    end
    # Update Flags
    @refresh_data = nil
    @zoom_x   = @tilemap_settings.nil? ? 1.0 : @tilemap_settings.zoom_x
    @zoom_y   = @tilemap_settings.nil? ? 1.0 : @tilemap_settings.zoom_y
    @tone     = @tilemap_settings.nil? ? nil : @tilemap_settings.tone
    @hue      = @tilemap_settings.nil? ? 0   : @tilemap_settings.hue
    @tilesize = @tilemap_settings.nil? ? 32  : @tilemap_settings.tile_size
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # Dispose Layers (Sprites)
    @layers.each { |layer| layer.dispose }
    # Set Disposed Flag to True
    @disposed = true
  end
  #--------------------------------------------------------------------------
  # * Disposed?
  #--------------------------------------------------------------------------
  def disposed?
    return @disposed
  end
  #--------------------------------------------------------------------------
  # * Viewport
  #--------------------------------------------------------------------------
  def viewport
    return @viewport
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Set Refreshed Flag to On
    needs_refresh = true
    # If Map Data, Tilesize or HueChanges
    if @map_data != @refresh_data || (@tilemap_settings != false && 
       @hue != @tilemap_settings.hue) || (@tilemap_settings != false && 
       @tilesize != @tilemap_settings.tile_size)
      # Refresh Bitmaps
      refresh
      # Turns Refresh Flag to OFF
      needs_refresh = false
    end
    # Zoom X, Zoom Y, and Tone Changes
    unless @tilemap_settings.nil?
      if @zoom_x != @tilemap_settings.zoom_x
        @zoom_x = @tilemap_settings.zoom_x
        @layers.each {|layer| layer.zoom_x = @zoom_x}
      end
      if @zoom_y != @tilemap_settings.zoom_y
        @zoom_y = @tilemap_settings.zoom_y
        @layers.each {|layer| layer.zoom_y = @zoom_y}
      end
      if @tone != @tilemap_settings.tone
        @tone = @tilemap_settings.tone.nil? ? 
          Tone.new(0, 0, 0, 0) : @tilemap_settings.tone
        @layers.each {|layer| layer.tone = @tone}
      end
    end
    # Update layer Position offsets
    for layer in @layers
      layer.ox = @ox
      layer.oy = @oy
    end
    # If Refresh Autotiles, Needs Refreshed & Autotile Reset Frame
    if @refresh_autotiles && needs_refresh && 
       Graphics.frame_count % Tilemap_Options::Animated_Autotiles_Frames == 0
      # Refresh Autotiles
      refresh_autotiles
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Saves Map Data & Tilesize
    @refresh_data = @map_data
    @hue      = @tilemap_settings.nil? ? 0  : @tilemap_settings.hue
    @tilesize = @tilemap_settings.nil? ? 32 : @tilemap_settings.tile_size
    # Passes Through Layers
    for z in 0...@map_data.zsize
      # Passes Through X Coordinates
      for x in 0...@map_data.xsize
        # Passes Through Z Coordinates
        for y in 0...@map_data.ysize
          # Collects Tile ID
          id = @map_data[x, y, z]
          # Skip if 0 tile
          next if id == 0
          # Passes Through All Priorities
          for p in 0..5
            # Skip If Priority Doesn't Match
            next unless p == @priorities[id]
            # Cap Priority to Layer 3
            p = 2 if p > 2
            # Draw Tile
            id < 384 ? draw_autotile(x, y, p, id) : draw_tile(x, y, p, id)
          end
        end
      end
    end
  end    
  #--------------------------------------------------------------------------
  # * Refresh Auto-Tiles
  #--------------------------------------------------------------------------
  def refresh_autotiles
    # Auto-Tile Locations
    autotile_locations = Table.new(@map_data.xsize, @map_data.ysize, 
      @map_data.zsize)
    # Get X Tiles
    x1 = [@ox / @tilesize - Tilemap_Options::Viewport_Padding, 0].max
    x2 = [@viewport.rect.width / @tilesize + 
          Tilemap_Options::Viewport_Padding, @map_data.xsize].min
    # Get Y Tiles
    y1 = [@oy / @tilesize - Tilemap_Options::Viewport_Padding, 0].max
    y2 = [@viewport.rect.height / @tilesize + 
          Tilemap_Options::Viewport_Padding, @map_data.ysize].min
    # Passes Through Layers
    for z in 0...@map_data.zsize
      # Passes Through X Coordinates
      for x in x1...x2
        # Passes Through Y Coordinates
        for y in y1...y2
          # Collects Tile ID
          id = @map_data[x, y, z]
          # Skip if 0 tile
          next if id == 0
          # Skip If Non-Animated Tile
          next unless @autotiles[id / 48 - 1].width / 96 > 1 if id < 384
          # Passes Through All Priorities
          for p in 0..5
            # Skip If Priority Doesn't Match
            next unless p == @priorities[id]
            # Cap Priority to Layer 3
            p = 2 if p > 2
            # If Autotile
            if id < 384
              # Draw Auto-Tile
              draw_autotile(x, y, p, id)
              # Draw Higher Tiles
              for l in 0...@map_data.zsize
                id_l = @map_data[x, y, l]
                draw_tile(x, y, p, id_l)
              end
              # Save Autotile Location
              autotile_locations[x, y, z] = 1
            # If Normal Tile
            else
              # If Autotile Drawn
              if autotile_locations[x, y, z] == 1
                # Redraw Normal Tile
                draw_tile(x, y, p, id)
                # Draw Higher Tiles
                for l in 0...@map_data.zsize
                  id_l = @map_data[x, y, l]
                  draw_tile(x, y, p, id_l)
                end
              end
            end
          end
        end
      end
    end
  end      
  #--------------------------------------------------------------------------
  # * Draw Tile
  #--------------------------------------------------------------------------
  def draw_tile(x, y, z, id)
    # Gets Tile Bitmap
    return if @tileset_name == ''
    bitmap = RPG::Cache.tile(@tileset_name, id, @hue)
    # Calculates Tile Coordinates
    x *= @tilesize
    y *= @tilesize
    # Draw Tile
    if @tilesize == 32
      @layers[z].bitmap.blt(x, y, bitmap, Rect.new(0, 0, 32, 32))
    else
      rect = Rect.new(x, y, @tilesize, @tilesize)
      @layers[z].bitmap.stretch_blt(rect, bitmap, Rect.new(0, 0, 32, 32))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Auto-Tile
  #--------------------------------------------------------------------------
  def draw_autotile(x, y, z, tile_id)
    # Gets Autotile Filename
    filename = @autotiles_name[tile_id / 48 - 1]
    # Reconfigure Tile ID
    tile_id %= 48
    # Gets Generated Autotile Bitmap Section
    bitmap = RPG::Cache.autotile_tile(filename, tile_id, @hue)
    # Calculates Tile Coordinates
    x *= @tilesize
    y *= @tilesize
    # If Normal Tile
    if @tilesize == 32
      @layers[z].bitmap.blt(x, y, bitmap, Rect.new(0, 0, 32, 32))
    # If Altered Dimensions
    else
      dest_rect = Rect.new(x, y, @tilesize, @tilesize)
      @layers[z].bitmap.stretch_blt(dest_rect, bitmap, Rect.new(0, 0, 32, 32))
    end
  end
  #--------------------------------------------------------------------------
  # * Collect Bitmap
  #--------------------------------------------------------------------------
  def bitmap
    # Creates New Blank Bitmap
    bitmap = Bitmap.new(@layers[0].bitmap.width, @layers[0].bitmap.height)
    # Passes Through All Layers
    for layer in @layers
      bitmap.blt(0, 0, layer.bitmap, 
        Rect.new(0, 0, bitmap.width, bitmap.height))
    end
    # Return Bitmap
    return bitmap
  end
end