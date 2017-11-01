#==============================================================================
# Encounter step rate command
# By gerkrt/gerrtunk
# Version: 1
# Date: 4/1/2011
#==============================================================================
 
=begin
 
---------INTRODUCTION----------
 
This script adds a lost feature from old rpgmakers: the change combat rate
command. It also lets you restart it.
 
--------INSTRUCTIONS------------
 
modify_step_count(new_step_count, map_id): This lets you change the basic value
of step counts calculation. You have to pass first the new steps value.
If you dont pass a map id value it will use the map where you are.
 
restart_step_count(map id): This restarts the actual step count, putting it
in a similar initital value. If you dont pass a map id value it will use the
map where you are.
 
-Note that the script tries to save the actual steps of the player and add
that in the new step count. You can anulate that calling the restart method
before modifing it.
 
-The information is saved when you save the game and its permanent.
 
----------EXAMPLES--------------
 
modify_step_count (56)   --> This changues the steps count of the actual map
to 56.
 
modify_step_count (5, 34)  --> This changues the map 5 to 34 steps count.
 
=end
 
 
class Interpreter
  #--------------------------------------------------------------------------
  # * Restart Encounter Count
  # alias gameplayer method and check map id
  #--------------------------------------------------------------------------
  # If you want to not save the actual steps, use it
  def restart_step_count(map_id=-1)
    # If the map id is -1, mark of actual default map, use actual map_id
    if map_id == -1
      map = $game_map.map_id
    # If not, changue the id specified
    else
      map = map_id
    end
   
    # Call the real method
    $game_player.restart_step_count(map)
  end
 
  #--------------------------------------------------------------------------
  # * Modify Step Count
  #  add or update a new step count in list and call apply in gameplayer
  #--------------------------------------------------------------------------
  def modify_step_count(value, map_id=-1)
   
    # If the map id is -1, mark of actual default map, use actual map_id
    if map_id == -1
      map = $game_map.map_id
    # If not, changue the id specified
    else
      map = map_id
    end
   
    # Add or update value.
    $game_system.moded_steps_counts[map] = value
   
    # Apply it
    $game_player.apply_step_count(value, map)
 
  end
 
end
 
 
class Game_System
  attr_accessor :moded_steps_counts      # List of new steps counts pushed
  alias gs_init_wep_msc initialize unless $@
  def initialize
    @moded_steps_counts = []
    gs_init_wep_msc
  end
end
 
 
class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # * Restart Encounter Count
  #--------------------------------------------------------------------------
  def restart_step_count(map)
    # If exist a modified rate use it
    if $game_system.moded_steps_counts[map] != nil
      n = $game_system.moded_steps_counts[map]
    # If not use bd one. It needs to load it.
    else
      bdmap = load_data(sprintf("Data/Map%03d.rxdata", map))
      n = bdmap.encounter_step
    end
    @encounter_count = rand(n) + rand(n) + 1
  end
 
  #--------------------------------------------------------------------------
  # * Apply Step Count
  #--------------------------------------------------------------------------
  def apply_step_count(value, map)
    # First calculate the number of steps using base map/moded array - actual
    # If exist a modified rate use it
    if $game_system.moded_steps_counts[map] != nil
      n = $game_system.moded_steps_counts[map]
     
    # If not use bd one
    else
      bdmap = load_data(sprintf("Data/Map%03d.rxdata", map))
      n = bdmap.encounter_step
    end
   
    # Rest it, and make that cant be negative.
    c = (@encounter_count - n).abs
   
    # Create the new count adding the actual steps
    @encounter_count = rand(n) + rand(n) + 1 + c
    # Make sure that its at less 0
    @encounter_count.abs
  end
 
  #--------------------------------------------------------------------------
  # * Make Encounter Count
  # moded to check for moded steps rates
  # no es reseteja cuan surts del mapa x ho pot ser x una altre cosa
  #--------------------------------------------------------------------------
  def make_encounter_count
    # Image of two dice rolling
    if $game_map.map_id != 0
     
      # If exist a modified rate use it
      if $game_system.moded_steps_counts[$game_map.map_id] != nil
        n = $game_system.moded_steps_counts[$game_map.map_id]
      # If not use bd one
      else
        n = $game_map.encounter_step
      end
      #p 'encounter fet, n', n
      @encounter_count = rand(n) + rand(n) + 1
    end
  end  
end