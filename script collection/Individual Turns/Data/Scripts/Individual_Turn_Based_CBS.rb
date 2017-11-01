#==============================================================================
# ●● Individual Turns Battle System
#------------------------------------------------------------------------------
# Trickster (tricksterguy@hotmail.com)
# Version 2.5
# Date 9/2/07
# Goto rmxp.org for updates/support/bug reports
#------------------------------------------------------------------------------
# This script transforms the Group Turns Based Battle System (aka DBS) 
# into a Individual Turns Battle System - Select Action and it is executed
# immediately
#==============================================================================
#--------------------------------------------------------------------------
# Begin SDK Log
#--------------------------------------------------------------------------
SDK.log('Individual Turns Battle System', 'Trickster', 2.5, '9/2/07')
#--------------------------------------------------------------------------
# Begin SDK Requirement Check
#--------------------------------------------------------------------------
SDK.check_requirements(2.3, [1, 2, 3, 4])
#--------------------------------------------------------------------------
# Begin SDK Enabled Check
#--------------------------------------------------------------------------
if SDK.enabled?('Individual Turns Battle System')
  
class Game_Battler
  #--------------------------------------------------------------------------
  # * Action Made?
  #--------------------------------------------------------------------------
  def action_made?
    return @current_action.action_made || !movable?
  end
end

class Game_BattleAction
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :action_made
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  alias_method :trick_itcbs_battleaction_clear, :clear
  def clear
    trick_itcbs_battleaction_clear
    @action_made = false
  end
end

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  def start_phase2
    # Shift to phase 2
    @phase = 2
    # If won, or if lost : end method
    return if judge
    # Battle Events Flag
    @battle_event = false
    # Set actor to non-selecting
    @actor_index = -1
    @active_battler = nil
    # Enable party command window
    @party_command_window.active = true
    @party_command_window.visible = true
    # Disable actor command window
    @actor_command_window.active = false
    @actor_command_window.visible = false
    # Clear main phase flag
    $game_temp.battle_main_phase = false
    # Turn Count
    $game_temp.battle_turn += 1
    # Set Battler As Unselectable
    @active_battler = nil
    @actor_index = -1
    # Get All Battlers
    make_action_orders
    # Search all battle event pages
    for index in 0...$data_troops[@troop_id].pages.size
      # Get event page
      page = $data_troops[@troop_id].pages[index]
      # If this page span is [turn]
      if page.span == 1
        # Clear action completed flags
        $game_temp.battle_event_flags[index] = false
      end
    end
    # Clear all party member actions
    $game_party.clear_actions
    # If impossible to input command
    unless $game_party.inputable?
      # Start main phase
      start_phase3
    end
  end
  #--------------------------------------------------------------------------
  # * Start Actor Command Phase
  #--------------------------------------------------------------------------
  def start_phase3
    # Shift to phase 3
    @phase = 3
    # If won, or if lost : end method
    return if judge
    # Set Battler As Unselectable
    @active_battler = nil
    @actor_index = -1
    # Clear main phase flag
    $game_temp.battle_main_phase = false
    # Go to command input for next actor
    phase3_next_actor
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  def phase3_next_actor
    # If Active Battler is defined
    if @active_battler != nil
      # Actor blink effect OFF
      @active_battler.blink = false
      # Return if Action Already Made
      if @active_battler.action_made?
        # Start Phase 4
        start_phase4
        # Return
        return
      end
    end
    # Begin
    until @action_battlers.empty?
      # Get next actor
      @active_battler = @action_battlers.shift
      # Return if Action Already Made
      if @active_battler.action_made? or not @active_battler.inputable?
        # Start Phase 4
        start_phase4
        # Return
        return
      end
      # If an Enemy
      if @active_battler.is_a?(Game_Enemy)
        # Make Enemy Action
        @active_battler.make_action
        # Start Phase 4
        start_phase4
      else
        # Get actor index
        @actor_index = @active_battler.index
        # Set Blink Status to true
        @active_battler.blink = true
        # Set up actor command window
        phase3_setup_command_window
      end
      # Return since battler is inputable
      return
    end
    # Go Back to Phase2
    start_phase2
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input of Previous Actor
  #--------------------------------------------------------------------------
  def phase3_prior_actor
    # Set Action To Wait
    @active_battler.current_action.kind = 0
    @active_battler.current_action.basic = 3
    # Reset Blink
    @active_battler.blink = false
    # Start Phase 4
    start_phase4
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : basic command)
  #--------------------------------------------------------------------------
  def update_phase3_basic_command
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.decision_se)
      # Go to command input for previous actor
      phase3_prior_actor
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Return if Disabled Command
      if phase3_basic_command_disabled?
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Set Action Made Flag
      @active_battler.current_action.action_made = true
      # Command Input
      phase3_basic_command_input
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Start Main Phase
  #--------------------------------------------------------------------------
  def start_phase4
    # Shift to phase 4
    @phase = 4
    # Enable party command window
    @party_command_window.active = false
    @party_command_window.visible = false
    # Disable actor command window
    @actor_command_window.active = false
    @actor_command_window.visible = false
    # Set main phase flag
    $game_temp.battle_main_phase = true
    # Shift to step 1
    @phase4_step = 1
  end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase step 1 : action preparation)
  #--------------------------------------------------------------------------
  def update_phase4_step1
    # Hide help window
    @help_window.visible = false
    # If Turns Battle Event hasn't occured
    unless @battle_event
      # Set Battle Event Flag
      @battle_event = true
      # If an action forcing battler doesn't exist
      if $game_temp.forcing_battler == nil
        # Set up battle event
        setup_battle_event
        # If battle event is running
        if $game_system.battle_interpreter.running?
          return
        end
      end
    end
    # If an action forcing battler exists
    if $game_temp.forcing_battler != nil
      # Add to head, or move
      @action_battlers.unshift(@active_battler)
      $game_temp.forcing_battler.current_action.action_made = true
      @active_battler = $game_temp.forcing_battler
      @action_battlers.delete(@active_battler)
    end
    # Determine win/loss
    if judge
      # If won, or if lost : end method
      return
    end
    # Initialize animation ID and common event ID
    @animation1_id = 0
    @animation2_id = 0
    @common_event_id = 0
    # If already removed from battle
    if @active_battler == nil or @active_battler.index == nil
      # Start Phase 3
      start_phase3
      return
    end
    # Slip damage
    if @active_battler.hp > 0 and @active_battler.slip_damage?
      @active_battler.slip_damage_effect
      @active_battler.damage_pop = true
    end
    # Natural removal of states
    @active_battler.remove_states_auto
    # Refresh status window
    @status_window.refresh
    # Shift to step 2
    @phase4_step = 2
  end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase)
  #--------------------------------------------------------------------------
  alias_method :trick_itcbs_battle_update_phase4, :update_phase4
  def update_phase4
    # Make a Copy of Last Phase
    last_phase = @phase4_step
    # Run Actions as usual
    trick_itcbs_battle_update_phase4
    # If current phase is less than last phase and current_phase is 1
    if last_phase != nil and @phase4_step < last_phase and @phase4_step == 1
      # Clear Action
      @active_battler.current_action.clear
      # If No more avialable battlers start phase 2 else phase 3
      @action_battlers.empty? ? start_phase2 : start_phase3
    end
  end
end
#--------------------------------------------------------------------------
# End SDK Enabled Check
#--------------------------------------------------------------------------
end