=begin
===============================================================================
Target Anyone Scope
Version 1.02
9/4/2013
By KK20
===============================================================================
 -[ Introduction ]-
 This small script allows the player to make single target scopes reverse its
 intended target. In other words, you can now choose to Heal a monster or one
 of your allies.
 
 -[ Instructions ]-
 1.) Scroll down to the configurations and locate Constant TARGET_ANYONE_TAG.
     Change the string associated with it if you like.
 2.) Create a new element in the Database. Name this new element the same as you
     have TARGET_ANYONE_TAG assigned to.
 3.) Apply this new element to skills or items that you wish to have this
     effect.
 
     ~ NOTE: The effect will only work if you set the scope to "One Enemy"
             or "One Ally".

 -[ Compatibility ]-
 * This script was made with the default battle system in mind. Custom battle
   scripts will most likely not work with this script without edits.
 * Not tested with SDK
 * Changes made to Game_Actor, Game_Battler, and Scene_Battle
 
===============================================================================
Credits:
KK20 - Writing this script
Charlie Fleed - For the idea
Heretic86 - Requesting and bug fixing/finding
===============================================================================
=end

#===========#
# Configure #
#===========#

# The element ID's name that allows the user to target any one battler
TARGET_ANYONE_TAG = "Target Any"

#===============#
# End Configure #
#===============#

#-------------------------------------------------------------------------
# Class Game Actor
#-------------------------------------------------------------------------
class Game_Actor < Game_Battler
  attr_accessor :changed_scope
  
  alias call_init_again initialize
  def initialize(actor_id)
    @changed_scope = false
    call_init_again(actor_id)
  end
  
  def clear
    super
    @changed_scope = false
    @target_type = nil
  end  
  
end

#-------------------------------------------------------------------------
# Class Game Battler
#-------------------------------------------------------------------------
class Game_Battler
  #--------------------------------------------------------------------------
  # * Calculating Element Correction
  #     element_set : element
  #--------------------------------------------------------------------------
  def elements_correct(element_set)
    element_set = element_set.clone
    # Remove any Excluded Elements from the element_set arg array
    for i in element_set
      if i == $data_system.elements.index(TARGET_ANYONE_TAG)        
        element_set.delete(i)
      end
    end      
    # If not an element
    if element_set == []
      # Return 100
      return 100
    end
    # Return the weakest object among the elements given
    # * "element_rate" method is defined by Game_Actor and Game_Enemy classes,
    #    which inherit from this class.
    weakest = -100
    for i in element_set
      # Element with the Highest Rate means it is the Weakest          
      weakest = [weakest, self.element_rate(i)].max
    end
    return weakest
  end
end

#-------------------------------------------------------------------------
# Class Scene Battle
#-------------------------------------------------------------------------
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : skill selection)
  #--------------------------------------------------------------------------
  def update_phase3_skill_select
    # Make skill window visible
    @skill_window.visible = true
    # Update skill window
    @skill_window.update
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # End skill selection
      end_skill_select
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Get currently selected data on the skill window
      @skill = @skill_window.skill
      # If it can't be used
      if @skill == nil or not @active_battler.skill_can_use?(@skill.id)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Set action
      @active_battler.current_action.skill_id = @skill.id
      # Make skill window invisible
      @skill_window.visible = false
      # If effect scope is single enemy or single ally and can target anyone
      if @skill.element_set.include?($data_system.elements.index(TARGET_ANYONE_TAG)) and
      (@skill.scope == 1 or @skill.scope == 3)
        # Define starting position of the arrow
        @orig_scope = @skill.scope
        start_enemy_select if @skill.scope == 1
        start_actor_select if @skill.scope == 3
        @any_target = true
      elsif @skill.scope == 1  
        # Start enemy selection
        start_enemy_select
      # If effect scope is single ally
      elsif @skill.scope == 3 or @skill.scope == 5
        # Start actor selection
        start_actor_select
      # If effect scope is not single
      else
        # End skill selection
        end_skill_select
        # Go to command input for next actor
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : item selection)
  #--------------------------------------------------------------------------
  def update_phase3_item_select
    # Make item window visible
    @item_window.visible = true
    # Update item window
    @item_window.update
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # End item selection
      end_item_select
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Get currently selected data on the item window
      @item = @item_window.item
      # If it can't be used
      unless $game_party.item_can_use?(@item.id)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Set action
      @active_battler.current_action.item_id = @item.id
      # Make item window invisible
      @item_window.visible = false
      # If effect scope is single enemy or single ally and can target anyone
      if @item.element_set.include?($data_system.elements.index(TARGET_ANYONE_TAG)) and
      (@item.scope == 1 or @item.scope == 3)
        # Define starting position of the arrow
        @orig_scope = @item.scope
        start_enemy_select if @item.scope == 1
        start_actor_select if @item.scope == 3
        @any_target = true
      # If effect scope is single enemy
      elsif @item.scope == 1  
        # Start enemy selection
        start_enemy_select
      # If effect scope is single ally
      elsif @item.scope == 3 or @item.scope == 5
        # Start actor selection
        start_actor_select
      # If effect scope is not single
      else
        # End item selection
        end_item_select
        # Go to command input for next actor
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Updat (actor command phase : enemy selection)
  #--------------------------------------------------------------------------
  def update_phase3_enemy_select
    # Update enemy arrow
    @enemy_arrow.update
    # If this skill/item can target anyone
    if @any_target == true
      # If player pressed the key to change targets
      if Input.trigger?(Input::DOWN)
        # Play decision SE
        $game_system.se_play($data_system.cursor_se)
        # Initialize actor select, end enemy select
        end_enemy_select
        start_actor_select
        @active_battler.changed_scope = !@active_battler.changed_scope
        # Stop processing
        return
      end
    end
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # End enemy selection
      end_enemy_select
      @active_battler.changed_scope = false      
      @any_target = false
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Set action
      @active_battler.current_action.target_index = @enemy_arrow.index
      # End enemy selection
      end_enemy_select
      # If skill window is showing
      if @skill_window != nil
        # End skill selection
        end_skill_select
      end
      # If item window is showing
      if @item_window != nil
        # End item selection
        end_item_select
      end
      @any_target = false
      # Go to command input for next actor
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : actor selection)
  #--------------------------------------------------------------------------
  def update_phase3_actor_select
    # Update actor arrow
    @actor_arrow.update
    # If this skill/item can target anyone
    if @any_target == true
      # If player pressed the key to change targets
      if Input.trigger?(Input::UP)
        # Play decision SE
        $game_system.se_play($data_system.cursor_se)
        # Initialize actor select, end enemy select
        end_actor_select
        start_enemy_select
        @active_battler.changed_scope = !@active_battler.changed_scope
        # Stop processing
        return
      end
    end
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # End actor selection
      end_actor_select
      @active_battler.changed_scope = false      
      @any_target = false
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Set action
      @active_battler.current_action.target_index = @actor_arrow.index
      # End actor selection
      end_actor_select
      # If skill window is showing
      if @skill_window != nil
        # End skill selection
        end_skill_select
      end
      # If item window is showing
      if @item_window != nil
        # End item selection
        end_item_select
      end
      @any_target = false
      # Go to command input for next actor
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # * Set Targeted Battler for Skill or Item
  #     scope : effect scope for skill or item
  #--------------------------------------------------------------------------
  alias modded_scopes_change_targets set_target_battlers
  def set_target_battlers(scope)
    # If the actor has changed the scope of the skill/item
    if @active_battler.is_a?(Game_Actor) and @active_battler.changed_scope
      # Reset the variable
      @active_battler.changed_scope = false
      # Determine targets
      case scope
      when 1 # single ally
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_party.smooth_target_actor(index))
      when 3 # single enemy
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index))
      end
    else
      # Call original method
      modded_scopes_change_targets(scope)
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:lose 2:escape)
  #--------------------------------------------------------------------------
  alias reset_changed_scopes battle_end
  def battle_end(result)
    # Reset all the actors' changed_scope variable
    for actor in $game_party.actors
      actor.changed_scope = false
    end
    # Call alias
    reset_changed_scopes(result)
  end
end