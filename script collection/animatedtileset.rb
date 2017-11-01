#==============================================================================
# Autor : kingartur2
# Date : 24 / 01 / 2010
# Version : 1.0
#==============================================================================
=begin
Instructions:
to insert in the briefcase Tileset of the tilesets with the name of the principal tileset with near "_numero_del_frame."
This way if a tileset for example calls "example" his following will be :
  esempio_1 esempio_2 esempio_3 esempio_4...
The script will look for alone the files therefore if you for example have a series that reaches 4 and 2 misses us, for the script it will be as if you/they will be ended and therefore effetuerÃ : base - 1 - 2 - base...
=end
#==============================================================================
module FileTest
  def self.tileset?(string)
    RPG::Cache.tileset(string) rescue return false
    return true
  end
end

class Spriteset_Map
  alias init initialize
  alias up update

  def initialize
    @frame = 0
    @aspetta = 10
    init
  end

  def update
    up
    if @aspetta > 0
      @aspetta -= 1
    end
    if @aspetta == 0
      @aspetta = 10
      if @frame == 0
        @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
        @frame += 1
      else
        string = $game_map.tileset_name + "_" + @frame.to_s
        if FileTest.tileset?(string)
          @tilemap.tileset = RPG::Cache.tileset(string)
          @frame += 1
        else
          @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
          @frame = 1
        end
      end
    end
  end
end