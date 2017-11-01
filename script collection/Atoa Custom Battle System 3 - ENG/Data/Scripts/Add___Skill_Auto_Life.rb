#==============================================================================
# Skill Auto-Life
# By Atoa
#==============================================================================
# This script adds the 'Auto-life' status
# wich allows a battler to revive automatically after an death
#
# Add this scripts bellow the script 'ACBS | Battle Main Code'
#==============================================================================

module Atoa
  # Do not remove or change this line
  Auto_Life_States = {}
  # Do not remove or change this line
  
  # Auto_Life_States[State ID] = [Fixed, Rate, Animation, End]
  #   State ID = ID of the auto-life state
  #   Fixed = Fixed value recovered when revive
  #   Rate = Rate value recovered when revive
  #   Animation = Animation ID shown when reviving, 0 for no animation
  #   End = true/false. if true, the actor is revived only on the turn end.
  Auto_Life_States[24] = [0, 10, 25, false]

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Auto Life'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :auto_life
  attr_accessor :auto_revive
  attr_accessor :revive_turn
  attr_accessor :revive_wait
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_autolife initialize
  def initialize
    initialize_autolife
    @revive_wait = 0
    @auto_revive = false
    @revive_turn = false
    @auto_life = nil
  end
  #--------------------------------------------------------------------------
  # * Add State
  #     state_id : state ID
  #     force    : forcefully added flag (used to deal with auto state)
  #--------------------------------------------------------------------------
  alias add_state_autolife add_state
  def add_state(state_id, force = false)
    if $data_states[state_id].zero_hp and $game_temp.in_battle
      for index in Auto_Life_States.keys
        next unless @states.include?(index) and Auto_Life_States[index] != nil
        @auto_life = Auto_Life_States[index].dup
      end
    end
    add_state_autolife(state_id, force)
  end
end
  
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias start_autolife start
  def start
    start_autolife
    for battler in $game_party.actors + $game_troop.enemies
      reset_auto_life(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Clear auto life info
  #--------------------------------------------------------------------------
  def reset_auto_life(battler)
    battler.auto_life = nil
    battler.auto_revive = false
    battler.revive_turn = nil
    battler.revive_wait = 0
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_autolife update
  def update
    update_autolife
    update_auto_life
  end
  #--------------------------------------------------------------------------
  # * Update Auto Life
  #--------------------------------------------------------------------------
  def update_auto_life
    for battler in $game_party.actors + $game_troop.enemies   
      battler.revive_wait = [battler.revive_wait - 1, 0].max
      next if battler.revive_wait > 0
      if battler.auto_revive
        battler.remove_state(1)
        base_hp = battler.auto_life[0]
        rate_hp = battler.maxhp * battler.auto_life[1] / 100
        battler.hp = base_hp + rate_hp
        @action_battlers.delete(battler) if @action_battlers.include?(battler)
        @active_battlers.delete(battler) if @active_battlers.include?(battler)
        reset_auto_life(battler)
      end
    end
    @status_window.refresh if status_need_refresh
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_autolife step5_part4
  def step5_part4(battler)
    step5_part4_autolife(battler)
    for revive in $game_party.actors + $game_troop.enemies
      if revive.dead? and revive.auto_life != nil and not revive.auto_life[3]
        revive.auto_revive = true
        revive.animation_id = revive.auto_life[2]
        revive.animation_hit = true
        revive.revive_wait = $data_animations[revive.animation_id].frame_max
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Turn Ending
  #--------------------------------------------------------------------------
  alias update_turn_ending_autolife update_turn_ending
  def update_turn_ending
    turn_ending_autolife
    for battler in $game_party.actors + $game_troop.enemies
      if battler.dead? and battler.auto_life != nil and battler.auto_life[3]
        battler.auto_revive = true
        battler.animation_id = battler.auto_life[2]
        battler.animation_hit = true
        battler.revive_wait = $data_animations[battler.animation_id].frame_max * 2
      end
    end
  end
end