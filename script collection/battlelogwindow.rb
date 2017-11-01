#==============================================================================
# Battle log window
# By gerkrt/gerrtunk
# Version: 1
# License: MIT, credits
# Date: 24/01/2011
# IMPORTANT NOTE: to acces the more actualitzed or corrected version of this
# script check here: http://usuarios.multimania.es/kisap/english_list.html
#==============================================================================
 
=begin
 
------INTRODUCTION------
 
This window shows a new window and in battle that displays a list of the last
actions executed.
You can configure witdh, lines heigh, x and y and all the vocabulary used.
 
-----INSTRUCTIONS-------
 
The vocabulary is pretty self explanatory. Thet are the variables called Voc and
they dot whay you see. Note that a . is added always at the end of a phrase.
 
Lines height is the max lines of the log window.
 
Battle window X and Y control these positions. You can changue they at your will
for aesthetichs or improve interface.
 
Finall You can modifiy the Battle witdht window if you think that it takes too
space or you need more.
 
=end
 
module Wep
 
  Lines_height = 6
 
  BattleWindow_Width = 220
  Wep::BattleWindow_X = 0
  Wep::BattleWindow_Y = 96
 
  VocStart = 'Battle starts!'
  VocMiss = ' missed'
  VocAtk = ' attacked'
  VocDies = ' fall'
  VocWin = 'You win!'
  VocLose = 'You lose!'
  VocEscape = 'You escaped!'
  VocEscapeFails = 'You failed to escape'
  VocMag = ' cast '
  VocItem = ' use '
  VocDef = ' defended'
  VocNothing = ' does nothing'
 
end
 
 
 
 
 
class Game_Battler
    #--------------------------------------------------------------------------
  # * Change HP
  #     hp : new HP
  # moded to add log line in battle if dead
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = [[hp, maxhp].min, 0].max
    # Add log line if in battle and dead
    if self.dead? and $game_temp.in_battle
      $scene.log_add_line(Wep::VocDies, self)
    end
    # add or exclude incapacitation
    for i in 1...$data_states.size
      if $data_states[i].zero_hp
        if self.dead?
          add_state(i)
        else
          remove_state(i)
        end
      end
    end
  end
 
end
 
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose)
  #--------------------------------------------------------------------------
  def battle_end(result)
   
    case result
      when 0; @log_window.add_special_line(Wep::VocWin)
      when 1; @log_window.add_special_line(Wep::VocLose)
    end
 
    # Clear in battle flag
    $game_temp.in_battle = false
    # Clear entire party actions flag
    $game_party.clear_actions
    # Remove battle states
    for actor in $game_party.actors
      actor.remove_states_battle
    end
    # Clear enemies
    $game_troop.enemies.clear
    # Call battle callback
    if $game_temp.battle_proc != nil
      $game_temp.battle_proc.call(result)
      $game_temp.battle_proc = nil
    end
    # Switch to map screen
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # * Make Skill Action Results
  #--------------------------------------------------------------------------
  def make_skill_action_result
    # Get skill
    @skill = $data_skills[@active_battler.current_action.skill_id]
    # If not a forcing action
    unless @active_battler.current_action.forcing
      # If unable to use due to SP running out
      unless @active_battler.skill_can_use?(@skill.id)
        # Clear battler being forced into action
        $game_temp.forcing_battler = nil
        # Shift to step 1
        @phase4_step = 1
        return
      end
    end
    # Use up SP
    @active_battler.sp -= @skill.sp_cost
    # Refresh status window
    @status_window.refresh
    # Show skill name on help window
    @help_window.set_text(@skill.name, 1)
    # Set animation ID
    @animation1_id = @skill.animation1_id
    @animation2_id = @skill.animation2_id
    # Set command event ID
    @common_event_id = @skill.common_event_id
    # Set target battlers
    set_target_battlers(@skill.scope)
    # Add log line
    $scene.log_add_line(Wep::VocMag, @active_battler, @skill.name)
    # Apply skill effect
    for target in @target_battlers
      target.skill_effect(@active_battler, @skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Make Item Action Results
  #--------------------------------------------------------------------------
  def make_item_action_result
    # Get item
    @item = $data_items[@active_battler.current_action.item_id]
    # If unable to use due to items running out
    unless $game_party.item_can_use?(@item.id)
      # Shift to step 1
      @phase4_step = 1
      return
    end
    # If consumable
    if @item.consumable
      # Decrease used item by 1
      $game_party.lose_item(@item.id, 1)
    end
    # Display item name on help window
    @help_window.set_text(@item.name, 1)
    # Set animation ID
    @animation1_id = @item.animation1_id
    @animation2_id = @item.animation2_id
    # Set common event ID
    @common_event_id = @item.common_event_id
    # Decide on target
    index = @active_battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    # Set targeted battlers
    set_target_battlers(@item.scope)
    # Add log line
    $scene.log_add_line(Wep::VocItem, @active_battler, @item.name)
    # Apply item effect
    for target in @target_battlers
      target.item_effect(@item)
    end
  end
  #--------------------------------------------------------------------------
  # * Make Basic Action Results
  #--------------------------------------------------------------------------
  def make_basic_action_result
    # If attack
    if @active_battler.current_action.basic == 0
      # Add log line
      $scene.log_add_line(Wep::VocAtk, @active_battler)
      # Set anaimation ID
      @animation1_id = @active_battler.animation1_id
      @animation2_id = @active_battler.animation2_id
      # If action battler is enemy
      if @active_battler.is_a?(Game_Enemy)
        if @active_battler.restriction == 3
          target = $game_troop.random_target_enemy
        elsif @active_battler.restriction == 2
          target = $game_party.random_target_actor
        else
          index = @active_battler.current_action.target_index
          target = $game_party.smooth_target_actor(index)
        end
      end
      # If action battler is actor
      if @active_battler.is_a?(Game_Actor)
        if @active_battler.restriction == 3
          target = $game_party.random_target_actor
        elsif @active_battler.restriction == 2
          target = $game_troop.random_target_enemy
        else
          index = @active_battler.current_action.target_index
          target = $game_troop.smooth_target_enemy(index)
        end
      end
      # Set array of targeted battlers
      @target_battlers = [target]
      # Apply normal attack results
      for target in @target_battlers
        target.attack_effect(@active_battler)
      end
      return
    end
    # If guard
    if @active_battler.current_action.basic == 1
      # Display "Guard" in help window
      # Add log line
      $scene.log_add_line(Wep::VocDef, @active_battler)
      @help_window.set_text($data_system.words.guard, 1)
      return
    end
    # If escape
    if @active_battler.is_a?(Game_Enemy) and
       @active_battler.current_action.basic == 2
      # Add log line
      # @log_window.add_special_line(Wep::VocEscaping)
 
      # Display "Escape" in help window
      @help_window.set_text("Escape", 1)
      # Escape
      @active_battler.escape
      return
    end
    # If doing nothing
    if @active_battler.current_action.basic == 3
      # Add log line
      $scene.log_add_line(Wep::VocNothing, @active_battler)
      # Clear battler being forced into action
      $game_temp.forcing_battler = nil
      # Shift to step 1
      @phase4_step = 1
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: escape)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    # Calculate enemy agility average
    enemies_agi = 0
    enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    if enemies_number > 0
      enemies_agi /= enemies_number
    end
    # Calculate actor agility average
    actors_agi = 0
    actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    if actors_number > 0
      actors_agi /= actors_number
    end
    # Determine if escape is successful
    success = rand(100) < 50 * actors_agi / enemies_agi
    # If escape is successful
    if success
      # Add log line
      @log_window.add_special_line(Wep::VocEscape)
      # Play escape SE
      $game_system.se_play($data_system.escape_se)
      # Return to BGM before battle started
      $game_system.bgm_play($game_temp.map_bgm)
      # Battle ends
      battle_end(1)
    # If escape is failure
    else
      # Add log line
      @log_window.add_special_line(Wep::VocEscapeFails)
      # Clear all party member actions
      $game_party.clear_actions
      # Start main phase
      start_phase4
    end
  end
end
 
#==============================================================================
# ** Scene_Battle (part 1)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================
 
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  # moded to use
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
    s1 = $data_system.words.attack
    s2 = $data_system.words.skill
    s3 = $data_system.words.guard
    s4 = $data_system.words.item
    @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])
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
   
    @log_window = Window_BattleLog.new(@troop_id)
    @log_window.add_special_line(Wep::VocStart)
   
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
 
    @log_window.dispose
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
  # * Frame Update
  # moded to use
  #--------------------------------------------------------------------------
  def update
    # If battle event is running
    if $game_system.battle_interpreter.running?
      # Update interpreter
      $game_system.battle_interpreter.update
      # If a battler which is forcing actions doesn't exist
      if $game_temp.forcing_battler == nil
        # If battle event has finished running
        unless $game_system.battle_interpreter.running?
          # Rerun battle event set up if battle continues
          unless judge
            setup_battle_event
          end
        end
        # If not after battle phase
        if @phase != 5
          # Refresh status window
          @status_window.refresh
        end
      end
    end
    # Update system (timer) and screen
    $game_system.update
    $game_screen.update
    # If timer has reached 0
    if $game_system.timer_working and $game_system.timer == 0
      # Abort battle
      $game_temp.battle_abort = true
    end
    # Update windows
    @help_window.update
    @party_command_window.update
    @actor_command_window.update
    @log_window.update
    @status_window.update
    @message_window.update
    # Update sprite set
    @spriteset.update
    # If transition is processing
    if $game_temp.transition_processing
      # Clear transition processing flag
      $game_temp.transition_processing = false
      # Execute transition
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
        $game_temp.transition_name)
      end
    end
    # If message window is showing
    if $game_temp.message_window_showing
      return
    end
    # If effect is showing
    if @spriteset.effect?
      return
    end
    # If game over
    if $game_temp.gameover
      # Switch to game over screen
      $scene = Scene_Gameover.new
      return
    end
    # If returning to title screen
    if $game_temp.to_title
      # Switch to title screen
      $scene = Scene_Title.new
      return
    end
    # If battle is aborted
    if $game_temp.battle_abort
      # Return to BGM used before battle started
      $game_system.bgm_play($game_temp.map_bgm)
      # Battle ends
      battle_end(1)
      return
    end
    # If waiting
    if @wait_count > 0
      # Decrease wait count
      @wait_count -= 1
      return
    end
    # If battler forcing an action doesn't exist,
    # and battle event is running
    if $game_temp.forcing_battler == nil and
       $game_system.battle_interpreter.running?
      return
    end
    # Branch according to phase
    case @phase
    when 1  # pre-battle phase
      update_phase1
    when 2  # party command phase
      update_phase2
    when 3  # actor command phase
      update_phase3
    when 4  # main phase
      update_phase4
    when 5  # after battle phase
      update_phase5
    end
  end
 
 
  # Chequea turno, linea, posa . final,etc
  def log_add_line(line, origin, extra='')
    complete = origin.name + line + extra + '.'
 
    @log_window.add_line(complete)
    @log_window.refresh
  end
 
end
 
#==============================================================================
# ** Window_BattleLog
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================
 
class Window_BattleLog < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  def initialize(troop_id)
    @small_list = []
    @troop_id = troop_id
    #Wep::Lines_height.times {@list.push('')}
    Wep::Lines_height.times {@small_list.push('')}
    # until this, no contents
    super(Wep::BattleWindow_X, Wep::BattleWindow_Y, Wep::BattleWindow_Width, Wep::Lines_height * 32 + 32)
    self.z = 99
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
 
 
  def end_log
    if Wep::Battle_Ends[@troop_id] != nil
      @list.push Wep::Battle_Ends[@troop_id]
    else
      @list.push Wep::Default_End
    end
 
    @list.push Wep:Battle_Ends[troop_id]
  end
 
  def refresh
    self.contents = Bitmap.new(width - 32, height - 32)
    for i in 0...@small_list.size
      self.contents.draw_text(0, i * 32, Wep::BattleWindow_Width-32, 32, @small_list[i], 1)
    end
 
  end
 
  def add_line(line)
    # Add to the start and move
    @small_list.unshift(line)
    # Remove last element
    @small_list.pop
  end
 
  def add_special_line(line)
    # Add to the start and move
    @small_list.unshift(line)
    # Remove last element
    @small_list.pop
    refresh
  end
 
end
 