#====================================================
# Terrain battlebacks & Monster Areas by gameus
# This script is a Tons of AddOns part.
# Edit by Wecoc to connect battlebacks and troops on terrain_id
#====================================================

module GameGuy
  #====================================================
  # Terrain[TERRAIN_ID] = "battleback_name"
  #====================================================
  Terrain = []
#  Terrain[0] = '001-Grassland01'
  #====================================================
  # Tilesets[tile_id][terrain_id] = "battleback_name"
  #====================================================
  Tilesets = []
  Tilesets[1] = []
  Tilesets[1][1] = "002-Woods01" # tileset 1, terrain 1 (forest)
  Tilesets[1][4] = "030-Ship01" # tileset 1, terrain 4 (water)
  
  #====================================================
  # Troops_Area[tile_id][area_id] = [x, y, width, height, [troops], terrain_tag]
  #====================================================
  Troops = []
  Troops[1] = []
  Troops[1][1] = [0,0,20,15,[],0]
  Troops[1][2] = [0,0,20,15,[3,4],1]
  Troops[1][3] = [0,0,10,15,[5],4]
  Troops[1][4] = [10,0,10,15,[6],4]
end

#==============================================================================
# Game_Map
#==============================================================================

class Game_Map
  attr_accessor :map
  def battleback_name
    if GameGuy::Tilesets[@map.tileset_id] != nil &&
        GameGuy::Tilesets[@map.tileset_id][$game_player.terrain_tag] != nil
      return GameGuy::Tilesets[@map.tileset_id][$game_player.terrain_tag]
    elsif GameGuy::Terrain[$game_player.terrain_tag] != nil
      return GameGuy::Terrain[$game_player.terrain_tag]
    end
    return @battleback_name
  end
end

class Game_Player < Game_Character
  alias gg_upd_areas_player_lat update unless $@
  def update
    gg_upd_areas_player_lat
    areas = GameGuy::Troops[$game_map.map_id]
    return if areas == nil
    areas.each {|a|
      if a != nil
        if @x >= a[0] && @x <= a[0] + a[2] - 1
          if @y >= a[1] && @y <= a[3] + a[1] - 1
            if $game_player.terrain_tag == a[5]
              $game_map.map.encounter_list = a[4]
            end
          end
        end
      end}
  end
end