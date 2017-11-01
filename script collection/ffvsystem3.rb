#--------------------------------------------------------------------------
# * FF V System III
#   system by Fomar0153
# This section is about stat bonuses use these as
# examples so you can add your own remember 
# you can have ones like HP + 500 rather than just
# percentages.
#--------------------------------------------------------------------------
class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    n = $data_actors[@actor_id].parameters[0, @level]
    job = get_job
    n = ((n * (100 + job['HP']))/100)
    for i in 0...@active_abilities.size - 1
      if @active_abilities[i] == 'HP + 10%'
        n = ((n * 110)/100)
      end
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    n = $data_actors[@actor_id].parameters[1, @level]
    job = get_job
    n = ((n * (100 + job['SP']))/100)
    for i in 0...@active_abilities.size - 1
      if @active_abilities[i] == 'SP + 10%'
        n = ((n * 110)/100)
      end
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    n = $data_actors[@actor_id].parameters[2, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.str_plus : 0
    n += armor1 != nil ? armor1.str_plus : 0
    n += armor2 != nil ? armor2.str_plus : 0
    n += armor3 != nil ? armor3.str_plus : 0
    n += armor4 != nil ? armor4.str_plus : 0
    job = get_job
    n = ((n * (100 + job['STR']))/100)
    for i in 0...@active_abilities.size - 1
      if @active_abilities[i] == 'STR + 10%'
        n = ((n * 110)/100)
      end
    end
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    n = $data_actors[@actor_id].parameters[3, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.dex_plus : 0
    n += armor1 != nil ? armor1.dex_plus : 0
    n += armor2 != nil ? armor2.dex_plus : 0
    n += armor3 != nil ? armor3.dex_plus : 0
    n += armor4 != nil ? armor4.dex_plus : 0
    job = get_job
    n = ((n * (100 + job['DEX']))/100)
    for i in 0...@active_abilities.size - 1
      if @active_abilities[i] == 'DEX + 10%'
        n = ((n * 110)/100)
      end
    end
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    n = $data_actors[@actor_id].parameters[4, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.agi_plus : 0
    n += armor1 != nil ? armor1.agi_plus : 0
    n += armor2 != nil ? armor2.agi_plus : 0
    n += armor3 != nil ? armor3.agi_plus : 0
    n += armor4 != nil ? armor4.agi_plus : 0
    job = get_job
    n = ((n * (100 + job['AGI']))/100)
    for i in 0...@active_abilities.size - 1
      if @active_abilities[i] == 'AGI + 10%'
        n = ((n * 110)/100)
      end
    end
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    n = $data_actors[@actor_id].parameters[5, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.int_plus : 0
    n += armor1 != nil ? armor1.int_plus : 0
    n += armor2 != nil ? armor2.int_plus : 0
    n += armor3 != nil ? armor3.int_plus : 0
    n += armor4 != nil ? armor4.int_plus : 0
    job = get_job
    n = ((n * (100 + job['INT']))/100)
    for i in 0...@active_abilities.size - 1
      if @active_abilities[i] == 'INT + 10%'
        n = ((n * 110)/100)
      end
    end
    return [[n, 1].max, 999].min
  end
  
end


#--------------------------------------------------------------------------
# * FF V System IV
#   system by Fomar0153
# This section is about the battle commands, you
# will need to script them yourselves.
#--------------------------------------------------------------------------
class Scene_Battle
  #--------------------------------------------------------------------------
  # * This is your main concern in this section
  #--------------------------------------------------------------------------
  def command_does(command)
      case command
        when "Skill"
          # Play decision SE
          $game_system.se_play($data_system.decision_se)
          # Set action
          @active_battler.current_action.kind = 1
          # Start skill selection
          start_skill_select
        when "Ice-Skill"
          # Play decision SE
          $game_system.se_play($data_system.decision_se)
          # Set action
          @active_battler.current_action.kind = 1
          # Start skill selection
          start_skill_select(2)
        when "Defend"
          # Play decision SE
          $game_system.se_play($data_system.decision_se)
          # Set action
          @active_battler.current_action.kind = 0
          @active_battler.current_action.basic = 1
          # Go to command input for next actor
          phase3_next_actor
          
          #Place other commands here
        end
        return
      end
  #--------------------------------------------------------------------------
  # * Start Skill Selection
  #--------------------------------------------------------------------------
  def start_skill_select(element = 0)
    # Make skill window
    @skill_window = Window_Skill.new(@active_battler, element)
    # Associate help window
    @skill_window.help_window = @help_window
    # Disable actor command window
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : basic command)
  #--------------------------------------------------------------------------
  def update_phase3_basic_command
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Go to command input for previous actor
      phase3_prior_actor
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by actor command window cursor position
      x = @actor_command_window.index
      case @actor_command_window.index
      when 0  # attack
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Set action
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        # Start enemy selection
        start_enemy_select
      when 1
          command = @active_battler.first_command
          command_does(command)
      when 2
          command = @active_battler.second_command
          command_does(command)
        
      when 3  # item
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Set action
        @active_battler.current_action.kind = 2
        # Start item selection
        start_item_select
      end
      return
    end
  end
      
  #--------------------------------------------------------------------------
  # * A new method that draws the right commands
  #--------------------------------------------------------------------------
  def draw_command_window(actor_pos = 0)
    actor = $game_party.actors[actor_pos]
    s1 = $data_system.words.attack
    s2 = actor.first_command
    s3 = actor.second_command
    s4 = $data_system.words.item
    @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])
  end
  
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Initialize each kind of temporary battle data
    $game_temp.in_battle = true
    $game_temp.battle_turn = 0
    $game_temp.battle_event_flags.clear
    $game_temp.battle_abort = false
    $game_temp.battle_main_phase = false
    $game_temp.battleback_name = $game_map.battleback_name
    $game_temp.forcing_battler = nil
    # Initialize battle event interpreter
    $game_system.battle_interpreter.setup(nil, 0)
    # Prepare troop
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    # Make actor command window
    @actor_command_window = draw_command_window(0)
    @actor_command_window.y = 160
    @actor_command_window.back_opacity = 160
    @actor_command_window.active = false
    @actor_command_window.visible = false
    # Make other windows
    @party_command_window = Window_PartyCommand.new
    @help_window = Window_Help.new
    @help_window.back_opacity = 160
    @help_window.visible = false
    @status_window = Window_BattleStatus.new
    @message_window = Window_Message.new
    # Make sprite set
    @spriteset = Spriteset_Battle.new
    # Initialize wait count
    @wait_count = 0
    # Execute transition
    if $data_system.battle_transition == ""
      Graphics.transition(20)
    else
      Graphics.transition(40, "Graphics/Transitions/" +
        $data_system.battle_transition)
    end
    # Start pre-battle phase
    start_phase1
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
    # Refresh map
    $game_map.refresh
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @actor_command_window.dispose
    @party_command_window.dispose
    @help_window.dispose
    @status_window.dispose
    @message_window.dispose
    if @skill_window != nil
      @skill_window.dispose
    end
    if @item_window != nil
      @item_window.dispose
    end
    if @result_window != nil
      @result_window.dispose
    end
    # Dispose of sprite set
    @spriteset.dispose
    # If switching to title screen
    if $scene.is_a?(Scene_Title)
      # Fade out screen
      Graphics.transition
      Graphics.freeze
    end
    # If switching from battle test to any screen other than game over screen
    if $BTEST and not $scene.is_a?(Scene_Gameover)
      $scene = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    # Disable party command window
    @party_command_window.active = false
    @party_command_window.visible = false
    # Enable actor command window
    @actor_command_window.dispose
    @actor_command_window = draw_command_window(@actor_index)
    @actor_command_window.y = 160
    @actor_command_window.back_opacity = 160
    @actor_command_window.active = true
    @actor_command_window.visible = true
    # Set actor command window position
    @actor_command_window.x = @actor_index * 160
    # Set index to 0
    @actor_command_window.index = 0
  end

end