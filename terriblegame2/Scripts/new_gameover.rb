#===============================================================================
# Gameover Menu Script
# Sasuke89
#===============================================================================
=begin

class Scene_Gameover
def main
# Gameover Settings
# Make game over graphic
@sprite = Sprite.new
@sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
# Play game over ME
$game_system.me_play($data_system.gameover_me)
# Saving Settings

# Execute transition
Graphics.transition(120)
s1 = "Load file"
s2 = "Exit"
s3 = "Resume?"
@command_window = Window_Command.new(192, [s1, s2, s3])
@command_window.back_opacity = 160
@command_window.x = 320 - @command_window.width / 2
@command_window.y = 288
# Continue enabled determinant
# Check if at least one save file exists
# If enabled, make @continue_enabled true; if disabled, make it false
@continue_enabled = false
for i in 0..3
if FileTest.exist?("Save#{i+1}.rxdata")
@continue_enabled = true
end
end
# If continue is enabled, move cursor to "Continue"
# If disabled, display "Continue" text in gray
if @continue_enabled
@command_window.index = 1
else
@command_window.disable_item(1)
end
# Execute transition
Graphics.transition(120)

# Main loop
loop do
# Update game screen
Graphics.update
# Update input information
Input.update
# Frame update
update
# Abort loop if screen is changed
if $scene != self
break
end
end
# Prepare for transition
Graphics.freeze
# Dispose of command window
@command_window.dispose
end
#--------------------------------------------------------------------------
# * Frame Update
#--------------------------------------------------------------------------
def update
# Update command window
@command_window.update
# If C button was pressed
if Input.trigger?(Input::C)
# Branch by command window cursor position
case @command_window.index
when 0 # Continue
command_continue
when 1 # Shutdown
command_shutdown
when 2 # NEW!
command_resume
  
end
end
end
#--------------------------------------------------------------------------
# * Command: New Game
#--------------------------------------------------------------------------
def command_new_game
# Play decision SE
$game_system.se_play($data_system.decision_se)
# Stop BGM
Audio.bgm_stop
# Reset frame count for measuring play time
Graphics.frame_count = 0
# Make each type of game object
$game_temp = Game_Temp.new
$game_system = Game_System.new
$game_switches = Game_Switches.new
$game_variables = Game_Variables.new
$game_self_switches = Game_SelfSwitches.new
$game_screen = Game_Screen.new
$game_actors = Game_Actors.new
$game_party = Game_Party.new
$game_troop = Game_Troop.new
$game_map = Game_Map.new
$game_player = Game_Player.new
# Set up initial party
$game_party.setup_starting_members
# Set up initial map position
$game_map.setup($data_system.start_map_id)
# Move player to initial position
$game_player.moveto($data_system.start_x, $data_system.start_y)
# Refresh player
$game_player.refresh
# Run automatic change for BGM and BGS set with map
$game_map.autoplay
# Update map (run parallel process event)
$game_map.update
# Switch to map screen
$scene = Scene_Map.new
end
#--------------------------------------------------------------------------
# * Command: Continue
#--------------------------------------------------------------------------
def command_continue
# If continue is disabled
unless @continue_enabled
# Play buzzer SE
$game_system.se_play($data_system.buzzer_se)
return
end
# Play decision SE
$game_system.se_play($data_system.decision_se)
Audio.bgm_fade(1)
Audio.bgs_fade(1)
Audio.me_fade(200)
# Switch to load screen
$scene = Scene_Load.new
end
#--------------------------------------------------------------------------
# * Command: Shutdown
#--------------------------------------------------------------------------
def command_shutdown
# Play decision SE
$game_system.se_play($data_system.decision_se)
# Fade out BGM, BGS, and ME
Audio.bgm_fade(800)
Audio.bgs_fade(800)
Audio.me_fade(800)
# Shutdown
$scene = nil
end

#--------------------------------------------------------------------------
# * Command: Resume
#--------------------------------------------------------------------------
def command_resume
# Play decision SE
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

#--------------------------------------------------------------------------
# * Battle Test
#--------------------------------------------------------------------------
def battle_test
# Load database (for battle test)
$data_actors = load_data("Data/BT_Actors.rxdata")
$data_classes = load_data("Data/BT_Classes.rxdata")
$data_skills = load_data("Data/BT_Skills.rxdata")
$data_items = load_data("Data/BT_Items.rxdata")
$data_weapons = load_data("Data/BT_Weapons.rxdata")
$data_armors = load_data("Data/BT_Armors.rxdata")
$data_enemies = load_data("Data/BT_Enemies.rxdata")
$data_troops = load_data("Data/BT_Troops.rxdata")
$data_states = load_data("Data/BT_States.rxdata")
$data_animations = load_data("Data/BT_Animations.rxdata")
$data_tilesets = load_data("Data/BT_Tilesets.rxdata")
$data_common_events = load_data("Data/BT_CommonEvents.rxdata")
$data_system = load_data("Data/BT_System.rxdata")
# Reset frame count for measuring play time
Graphics.frame_count = 0
# Make each game object
$game_temp = Game_Temp.new
$game_system = Game_System.new
$game_switches = Game_Switches.new
$game_variables = Game_Variables.new
$game_self_switches = Game_SelfSwitches.new
$game_screen = Game_Screen.new
$game_actors = Game_Actors.new
$game_party = Game_Party.new
$game_troop = Game_Troop.new
$game_map = Game_Map.new
$game_player = Game_Player.new
# Set up party for battle test
$game_party.setup_battle_test_members
# Set troop ID, can escape flag, and battleback
$game_temp.battle_troop_id = $data_system.test_troop_id
$game_temp.battle_can_escape = true
$game_map.battleback_name = $data_system.battleback_name
# Play battle start SE
$game_system.se_play($data_system.battle_start_se)
# Play battle BGM
$game_system.bgm_play($game_system.battle_bgm)
# Switch to battle screen
$scene = Scene_Battle.new
end
end
=end