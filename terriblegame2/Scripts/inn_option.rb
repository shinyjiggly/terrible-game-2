#==============================================================================
# ** Game over to inn
#------------------------------------------------------------------------------
# Slanter
# Version 1
# 2007-03-23
#------------------------------------------------------------------------------
# * Description:  Allows you to have a game over to a specific location, and
#                 you can also set the current inn location by talking to an
#                 NPC.
#==============================================================================
=begin
Inn change location:
$gameover_to_inn.set(map_id, map_x, map_y, gold_sub, hp_pct, sp_pct, direction)

Change Map ID:
$gameover_to_inn.map_id = ID

Change X Coord:
$gameover_to_inn.map_x = VALUE

Change X Coord:
$gameover_to_inn.map_y = VALUE

Change Gold subtraction:
$gameover_to_inn.gold_sub = VALUE

Change HP multiplier:
$gameover_to_inn.hp_pct = VALUE

Change SP multiplier:
$gameover_to_inn.sp_pct = VALUE

Change Direction:
$gameover_to_inn.direction = VALUE
=end
#--------------------------------------------------------------------------
# * SDK Log Script
#--------------------------------------------------------------------------
#SDK.log('GameOverToInn', 'Slanter', "1", '2007-03-23')

#--------------------------------------------------------------------------
# Begin SDK Enabled Test
#--------------------------------------------------------------------------
#if SDK.state('GameOverToInn') == true

#==============================================================================
# ** Gameover_To_Inn: Stores variables for game over location
#==============================================================================
class Gameover_To_Inn
#--------------------------------------------------------------------------
  attr_accessor :map_id
  attr_accessor :map_x
  attr_accessor :map_y
  attr_accessor :gold_sub
  attr_accessor :hp_pct
  attr_accessor :sp_pct
  attr_accessor :direction
#--------------------------------------------------------------------------
# * Initialize variables
#--------------------------------------------------------------------------
  def initialize
    @map_id    = 1
    @map_x     = 7
    @map_y     = 10
    @gold_sub  = 0
    @hp_pct    = 0.5
    @sp_pct    = 0.5
    @direction = 1
  end
 
  def set(map_id   = 1, map_x   = 0, map_y     = 0,
          gold_sub = 0, hp_pct = 0.5, sp_pct   = 0.5,
          direction = 1)
    if (sp_pct > 1)
      sp_pct/=100
    end
    if (hp_pct > 1)
      hp_pct/=100
    end
    @map_id    = map_id
    @map_x     = map_x
    @map_y     = map_y
    @gold_sub  = gold_sub
    @hp_pct    = hp_pct
    @sp_pct    = sp_pct
    @direction = direction
  end
end
=begin
#==============================================================================
# ** Scene_Gameover
#==============================================================================
class Scene_Gameover
#--------------------------------------------------------------------------
# * Update: Fixes it so that it will send you to your location, instead of title
#--------------------------------------------------------------------------
  def update
    if Input.trigger?(Input::C)
      $game_temp.gameover = false
      $game_map.setup($gameover_to_inn.map_id)
      $game_player.moveto($gameover_to_inn.map_x, $gameover_to_inn.map_y)
      case $gameover_to_inn.direction
      when 2
        $game_player.turn_down
      when 4
        $game_player.turn_left
      when 6
        $game_player.turn_right
      when 8
        $game_player.turn_up
      end
      $scene=Scene_Map.new
      $game_map.refresh
      
      $game_party.lose_gold($gameover_to_inn.gold_sub)
      char = $game_party.actors
      for i in 0..char.size-1
        id = char[i].id
        $game_actors[id].hp = ($game_actors[id].maxhp * $gameover_to_inn.hp_pct).round
        $game_actors[id].sp = ($game_actors[id].maxsp * $gameover_to_inn.sp_pct).round
        $game_actors[id].exp = 0 - $game_actors[id].exp
      end
    end
  end
end
=end
#================================
# ** Scene_Title
#================================
class Scene_Title
alias slanter_gameovertoinn_scntitle_cmdnewgame command_new_game
def command_new_game
   slanter_gameovertoinn_scntitle_cmdnewgame
   $gameover_to_inn = Gameover_To_Inn.new
end
end

#================================
# ** Scene_Save
#================================
class Scene_Save
alias slanter_gameovertoinn_scnsave_writesavedata write_save_data
def write_save_data(file)
   slanter_gameovertoinn_scnsave_writesavedata(file)
   Marshal.dump($gameover_to_inn, file)
end
end

#================================
# ** Scene_Load
#================================
class Scene_Load
alias slanter_gameovertoinn_scnload_readsavedata read_save_data
def read_save_data(file)
   slanter_gameovertoinn_scnload_readsavedata(file)
   $gameover_to_inn = Marshal.load(file)
end
end
#--------------------------------------------------------------------------
# End SDK Enabled Test
#--------------------------------------------------------------------------
#end