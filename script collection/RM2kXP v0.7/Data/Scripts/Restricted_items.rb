=begin
#==============================================================================
# Restricted use and apply items
# By gerkrt/gerrtunk
# Version: 1.1
#==============================================================================
 
This script adds a lost feature from old rpgmakers: the option to create item use
restrictions by actor or class. Also now dead actors cant be valid users of items.
 
Also adds a new feature: option to decide what actors can be the target of
a item and the option to view it visually when selecting the targets.
 
--------Use Restriction-----------
 
This system gives you the option to decide what actors can use a item.
 
Instructions:
 
Restricted_items = {1 => [2,6],2 => [1,2]}
 
If you wanted to add a use restriction for item 5 and that it can only be used
to actors 5 and 7:
 
Restricted_items = {1 => [2,6],2 => [1,2], 5=>[5,7] }
 
item_id => [actor_id, actor_id2, actor_idx]
 
Note that you can remove the examples:
 
Restricted_items = {5=>[5,7]}
 
Notes about the usage:
 
-The ids you add define only the actors that can use the items, the rest cant do that.
 
-Items that you dont add to the Restricted_items list will be treated like
normal ones(no restrictions)
 
Options(true= active, false= inactive):
 
Dead_cant_use: Imagine that you have a item restricted only for actor 1, who is dead.
With this option enabled the item cant be used in the main menu.
 
---------Apply Restriction----------
 
This system gives you the option to decide what actors can be the target of a item.
 
Instructions:
 
Restricted_aplication = {1 => [2,6],2 => [1,2]}
 
If you wanted to add an apply restriction for item 5 and that it can only be applied
to actors 5 and 7:

Restricted_aplication = {1 => [2,6],2 => [1,2], 5=>[5,7] }
 
item_id => [actor_id, actor_id2, actor_idx]
 
Note that you can remove the examples:
 
Restricted_aplication = {5=>[5,7]}
 
Notes about the usage:
 
-The ids you add define only the actors that can be target, the rest cant do that.
 
-All members items effects: The effect will be applied to all members except wich
cant be applied. If nobody can be target, the item cant be used.
 
-Single target effects: Only to that can.
 
-Items that you dont add to the Restricted_aplication list will be treated like
normal ones(no restrictions)
 
Options(true= active, false= inactive):
 
Use_is_Aplication: This make that use restictions and apply restrctions are the same.
This means that only an actor that can use an item can be target of it. If you active
it all the options defined in Restricted_aplication will be ignored.
 
Active_restricted_aplication: This is a compatibality option. The apply script
modifies a lot of things, so, is possible that it will be incompatible. Then you
might want to turn off this option, because you still want to use restricted
normal items. Note that you will lose all its functions.
 
Show_application_battle_grafic: Another compatibality option. This makes that the
actor name is printed in disabled color in the battle. If dont work or use another
system, desactive it.
 
Show_application_item_grafic: Another compatibality option. This makes that the
actor name is printed in disabled color in the item menu. If dont work or use another
system, desactive it.
 
----------Restrictions based on Classes-------
 
The method of adding is the same that in the others.Just add a Class_ before the variable
name to know what is. Anyway you must know that an
actor restriction have preference over clases restrictions. This means that a
actor that can use restricted item also can use that item with any class. If the
actor cant use the item then class rectictions are checked.
 
----------Tip for long lines-------------
 
After every , you can make a new line. Example:
 
Restricted_aplication = {1 => [2,6],2 => [1,2], 5=>[5,7],
7 => [2,6],9 => [1,2], 13=>[5,7]}
  
=end

module Wep
  #            {Item_id => [actor_id]}
  Restricted_items = {2 => [1]}
  Class_restricted_items = {2 => [1]}
  Active_restricted_aplication = true
  Use_is_Aplication = false
  Show_application_battle_grafic = true
  Show_application_item_grafic = true
  Restricted_aplication = {2 => [4,1]}
  Class_restricted_aplication = {2 => [2]}
  Dead_cant_use = true
end

# RESTRICTED APLICATION CODE
if Wep::Active_restricted_aplication

class Scene_Battle
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
    # Apply item effect
    for target in @target_battlers
      # Check restrictions
      if target.is_a?(Game_Actor) and
        $game_party.item_can_apply?(@active_battler.current_action.item_id, target.actor_id_reader)
        target.item_effect(@item)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : actor selection)
  #--------------------------------------------------------------------------
  def update_phase3_actor_select
    # Update actor arrow
    @actor_arrow.update
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # End actor selection
      end_actor_select
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      if not $game_party.item_can_apply?(@active_battler.current_action.item_id,
        $game_party.actors[@actor_arrow.index].actor_id_reader)
        # Play cancel SE
        $game_system.se_play($data_system.cancel_se)
        return
      end
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
      # Go to command input for next actor
      phase3_next_actor
    end
  end
end


class Game_Party
  #--------------------------------------------------------------------------
  # * Determine if Item is Apply
  #     item_id : item ID
  #     actor_id : target actor id
  #--------------------------------------------------------------------------
  def item_can_apply?(item_id, actor_id)
    # If this option is enabled, use restriction information for apply restrictions
    if Wep::Use_is_Aplication
      # Actor check
      if Wep::Restricted_items[item_id] != nil and Wep::Restricted_items[item_id][0] != nil
        if Wep::Restricted_items[item_id].include?(actor_id)
          return true
        else
          # Actor-Class check
          if Wep::Class_restricted_items[item_id] != nil and Wep::Class_restricted_items[item_id][0] != nil
            if Wep::Class_restricted_items[item_id].include?($game_actors[actor_id].class_id)
              return true
            else
              return false
            end
            # If normal item, all true
            return true
          end
          # If not class also, false.
          return false
        end
        # If normal item, all true
        return true
      end
  
      # Class only check
      if Wep::Class_restricted_items[item_id] != nil and Wep::Class_restricted_items[item_id][0] != nil
        if Wep::Class_restricted_items[item_id].include?($game_actors[actor_id].class_id)
          return true
        else
          return false
        end
        # If normal item, all true
        return true
      end
    end

    # Normal behavior
  
    # Actor check
    if Wep::Restricted_aplication[item_id] != nil and Wep::Restricted_aplication[item_id][0] != nil
      if Wep::Restricted_aplication[item_id].include?(actor_id)
        return true
      else
        # Actor-Class check
        if Wep::Class_restricted_aplication[item_id] != nil and Wep::Class_restricted_aplication[item_id][0] != nil
          if Wep::Class_restricted_aplication[item_id].include?($game_actors[actor_id].class_id)
            return true
          else
            return false
          end
          # If normal item, all true
          return true
        end
        # If not class also, false.  
        return false
      end
    end

    # Class check
    if Wep::Class_restricted_aplication[item_id] != nil and Wep::Class_restricted_aplication[item_id][0] != nil
      if Wep::Class_restricted_aplication[item_id].include?($game_actors[actor_id].class_id)
        return true
      else
        return false
      end
      # If normal item, all true
      return true
    end

    # If normal item, all true
    return true
  end
end

end

# CORE CODE

class Scene_Item  
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------
  def update_item
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to menu screen
      $scene = Scene_Menu.new(0)
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Get currently selected data on the item window
      @item = @item_window.item
      # If not a use item
      unless @item.is_a?(RPG::Item)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # If it can't be used
      unless $game_party.item_can_use?(@item.id)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # If effect scope is an ally
      if @item.scope >= 3
        # Activate target window
        @item_window.active = false
        @target_window.x = (@item_window.index + 1) % 2 * 208
        @target_window.visible = true
        @target_window.active = true
        # Set cursor position to effect scope (single / all)
        if @item.scope == 4 || @item.scope == 6
          @target_window.index = -1
        else
          @target_window.index = 0
        end
        if Wep::Show_application_item_grafic
          @target_window.refresh_disabled(@item_window.item.id)
        end
        # If effect scope is other than an ally
      else
        # If command event ID is valid
        if @item.common_event_id > 0
          # Command event call reservation
          $game_temp.common_event_id = @item.common_event_id
          # Play item use SE
          $game_system.se_play(@item.menu_se)
          # If consumable
          if @item.consumable
            # Decrease used items by 1
            $game_party.lose_item(@item.id, 1)
            # Draw item window item
            @item_window.draw_item(@item_window.index)
          end
          # Switch to map screen
          $scene = Scene_Map.new
          return
        end
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when target window is active)
  #--------------------------------------------------------------------------
  def update_target
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # If unable to use because items ran out
      unless $game_party.item_number(@item.id) == 0
        # Remake item window contents
        @item_window.refresh
      end
      # Erase target window
      @item_window.active = true
      @target_window.visible = false
      @target_window.active = false
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # If items are used up
      if $game_party.item_number(@item.id) == 0  
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # If target is all
      if @target_window.index == -1
        # If apply restriction system is active
        if Wep::Active_restricted_aplication
          # First check that at least one actor can take the effect
          for i in $game_party.actors
            if $game_party.item_can_apply?(@item.id, i.actor_id_reader)
              can_apply = true
            end
          end
          # If any can, escape
          if can_apply == nil
            # Play buzzer SE
            $game_system.se_play($data_system.buzzer_se)
            return
          end
          # Apply item effects to entire party
          used = false
          for i in $game_party.actors
            # Only apply effects to the actors that can
            if $game_party.item_can_apply?(@item.id, i.actor_id_reader)
              used |= i.item_effect(@item)
            end
          end

          # Normal behavior
        else
          # Apply item effects to entire party
          used = false
          for i in $game_party.actors
            used |= i.item_effect(@item)
          end
        end  
      end

      # If single target
      if @target_window.index >= 0
        # If apply restriction system is active
        if Wep::Active_restricted_aplication
          unless $game_party.item_can_apply?(@item.id, $game_party.actors[@target_window.index].actor_id_reader)
            # Play buzzer SE
            $game_system.se_play($data_system.buzzer_se)
            return
          end
          # Apply item use effects to target actor
          target = $game_party.actors[@target_window.index]
          used = target.item_effect(@item)
          # Normal behavior
        else
          # Apply item use effects to target actor
          target = $game_party.actors[@target_window.index]
          used = target.item_effect(@item)
        end
      end

      # If an item was used
      if used
        # Play item use SE
        $game_system.se_play(@item.menu_se)
        # If consumable
        if @item.consumable
          # Decrease used items by 1
          $game_party.lose_item(@item.id, 1)
          # Redraw item window item
          @item_window.draw_item(@item_window.index)
        end
        # Remake target window contents
        if Wep::Show_application_item_grafic
          @target_window.refresh_disabled(@item_window.item.id)
        else
          @target_window.refresh
        end
        # If all party members are dead
        if $game_party.all_dead?
          # Switch to game over screen
          $scene = Scene_Gameover.new
          return
        end
        # If common event ID is valid
        if @item.common_event_id > 0
          # Common event call reservation
          $game_temp.common_event_id = @item.common_event_id
          # Switch to map screen
          $scene = Scene_Map.new
          return
        end
      end
      # If item wasn't used
      unless used
        #p'nmo usado'
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
  end
end

class Scene_Battle
  def actor_id_restricted_item
    return @active_battler.actor_id_reader
  end
end

class Game_Actor < Game_Battler
  def actor_id_reader
    return @actor_id
  end
end

class Game_Party
  #--------------------------------------------------------------------------
  # * Determine if Item is Usable
  #     item_id : item ID actor id batalla? desde scnee?
  #--------------------------------------------------------------------------
  def item_can_use?(item_id)
    # Unusable if item quantity is 0
    return false if item_number(item_id) == 0
    # Restricted item in map menu
    # If itsnt normal, check for use restriction  
    if Wep::Restricted_items[item_id] != nil and
      Wep::Restricted_items[item_id][0] != nil and not $game_temp.in_battle
      # Check for dead option
      if Wep::Dead_cant_use
        # Check for at least one living valid actor
        for actor in $game_party.actors
          if Wep::Restricted_items[item_id].include?(actor.id) and actor.hp > 0
            return true
          end
        end
        # Check for class restrction if actor restriction fails
        if Wep::Class_restricted_items[item_id] != nil and
          Wep::Class_restricted_items[item_id][0] != nil and not $game_temp.in_battle
          # Check for dead option
          if Wep::Dead_cant_use
            # Check for at least one living valid actor
            for actor in $game_party.actors
              if Wep::Class_restricted_items[item_id].include?($game_actors[actor.id].class_id) and actor.hp > 0
                return true
              end
            end
            return false
          # If dont check for dead
          else
            # Check for at least one valid actor-class
            for actor in $game_party.actors
              if Wep::Class_restricted_items[item_id].include?($game_actors[actor.id].class_id)
                # At least one valid actor
                return true
              end
            end
            # It dont have valid actors in the party
            return false
          end
        end
        # If dont use class or class restriction failed
        return false
      # If dont check for dead
      else
        # Check for at least one valid actor
        for actor in $game_party.actors
          if Wep::Restricted_items[item_id].include?(actor.id)
            # At least one valid actor
            return true
          end
        end
        # It dont have valid actors in the party
        return false
      end
    end

    # Check for only class restriction
    if Wep::Class_restricted_items[item_id] != nil and
      Wep::Class_restricted_items[item_id][0] != nil and not $game_temp.in_battle
      # Check for dead option
      if Wep::Dead_cant_use
        # Check for at least one living valid actor
        for actor in $game_party.actors
          if Wep::Class_restricted_items[item_id].include?($game_actors[actor.id].class_id) and actor.hp > 0
            # At least one valid living actor
            return true
          end
        end
        return false if valid_actor_class == nil
      # If dont check for dead
      else
        # Check for at least one valid actor-class
        for actor in $game_party.actors
          if Wep::Class_restricted_items[item_id].include?($game_actors[actor.id].class_id)
            # At least one valid actor
            return true
          end
        end
        # It dont have valid actors in the party
        return false
      end
    end

    # All normal items are usable if not in batte
    return true if not $game_temp.in_battle
  
    # Get usable time
    occasion = $data_items[item_id].occasion
    # If in battle
    if $game_temp.in_battle
      # Check item use restriction
      if Wep::Restricted_items[item_id] != nil and Wep::Restricted_items[item_id][0] != nil
        # Check if usable in battle or not
        if occasion == 0 or occasion == 1
          # Check restrictions
          if Wep::Restricted_items[item_id].include?($scene.actor_id_restricted_item)
            return true
          else
            # Class restrictions(Actor+Class check)
            if Wep::Class_restricted_items[item_id] != nil and
              Wep::Class_restricted_items[item_id][0] != nil #and not $game_temp.in_battle
              # Check class restrictions
              if Wep::Class_restricted_items[item_id].include?($game_actors[$scene.actor_id_restricted_item].class_id)
                return true
              end
              return false
            end
          end
          # If not usable in battle
        else
          return false
        end
      end
 
      # Class restrictions if actor restriction dont exist
      if Wep::Class_restricted_items[item_id] != nil and 
        Wep::Class_restricted_items[item_id][0] != nil and $game_temp.in_battle
        # Check if usable in battle or not
        if occasion == 0 or occasion == 1
          # Check class restrictions
          if Wep::Class_restricted_items[item_id].include?($game_actors[$scene.actor_id_restricted_item].class_id)
            return true
          else
            return false
          end
          # If not usable in battle
        else
          return false
        end
      end
      # All normal items are usable  in battle based on their occasion
      # If useable time is 0 (normal) or 1 (only battle) it's usable
      return (occasion == 0 or occasion == 1)
    end
    # If useable time is 0 (normal) or 2 (only menu) it's usable
    return (occasion == 0 or occasion == 2)
  end
end


# SHOW BATTLE GRAPHICS CODE

if Wep::Show_application_battle_grafic

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start Actor Selection
  #--------------------------------------------------------------------------
  def start_actor_select
    # Make actor arrow
    @actor_arrow = Arrow_Actor.new(@spriteset.viewport2)
    @actor_arrow.index = @actor_index
    # Associate help window
    @actor_arrow.help_window = @help_window
    # Disable actor command window
    @actor_command_window.active = false
    @actor_command_window.visible = false
    if @active_battler.current_action.kind == 2
      @status_window.refresh_disabled(@active_battler)
    end
  end
  #--------------------------------------------------------------------------
  # * End Actor Selection
  #--------------------------------------------------------------------------
  def end_actor_select
    @status_window.refresh
    # Dispose of actor arrow
    @actor_arrow.dispose
    @actor_arrow = nil
  end
end

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh Disabled
  #--------------------------------------------------------------------------
  def refresh_disabled(active_battler)
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actor_x = i * 160 + 4
      if not $game_party.item_can_apply?(active_battler.current_action.item_id,
        $game_party.actors[i].actor_id_reader)
        self.contents.font.color = disabled_color
        self.contents.draw_text(actor_x, 0, 120, 32, actor.name)
      else
        draw_actor_name(actor, actor_x, 0)
      end
      draw_actor_hp(actor, actor_x, 32, 120)
      draw_actor_sp(actor, actor_x, 64, 120)
      if @level_up_flags[i]
        self.contents.font.color = normal_color
        self.contents.draw_text(actor_x, 96, 120, 32, Vocab::LEVEL_UP)
      else
        draw_actor_state(actor, actor_x, 96)
      end
    end
    self.contents.font.color = normal_color
  end
end

end


# SHOW ITEM GRAPHICS CODE


if Wep::Show_application_item_grafic

#==============================================================================
# ** Window_Target
#------------------------------------------------------------------------------
#  This window selects a use target for the actor on item and skill screens.
#==============================================================================

class Window_Target < Window_Selectable
  def initialize
    super(0, 0, 432, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z += 10
    @item_max = $game_party.actors.size
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh Disabled
  #--------------------------------------------------------------------------
  def refresh_disabled(item_id)
    self.contents.clear
    for i in 0...$game_party.actors.size
      x = 4+96
      y = i * 126
      actor = $game_party.actors[i]
      draw_actor_face(actor, x-6, y+96)
      if $game_party.item_can_apply?(item_id,$game_party.actors[i].actor_id_reader)
        draw_actor_name(actor, x, y)
        draw_actor_class(actor, x + 144, y)
        draw_actor_level(actor, x + 8, y + 32)
        draw_actor_state(actor, x + 8, y + 64)
        draw_actor_hp(actor, x + 152, y + 32)
        draw_actor_sp(actor, x + 152, y + 64)
      else
        self.contents.font.color = disabled_color
        self.contents.draw_text(x, y, 120, 32, actor.name)
        self.contents.draw_text(x + 144, y, 236, 32, actor.class_name)
        self.contents.draw_text(x + 8, y + 32, 32, 32, Vocab::LEVEL)
        self.contents.draw_text(x + 44, y + 32, 24, 32, actor.level.to_s)
        text = make_battler_state_text(actor, 120, true)
        self.contents.draw_text(x + 8, y + 64, 120, 32, text)
        self.contents.draw_text(x + 152, y + 32, 32, 32, $data_system.words.hp)
        self.contents.draw_text(x + 188, y + 32, 48, 32, actor.hp.to_s, 2)
        self.contents.draw_text(x + 236, y + 32, 12, 32, "/", 1)
        self.contents.draw_text(x + 248, y + 32, 48, 32, actor.maxhp.to_s, 0)
        self.contents.draw_text(x + 152, y + 64, 32, 32, $data_system.words.sp)
        self.contents.draw_text(x + 188, y + 64, 48, 32, actor.sp.to_s, 2)
        self.contents.draw_text(x + 236, y + 64, 12, 32, "/", 1)
        self.contents.draw_text(x + 248, y + 64, 48, 32, actor.maxsp.to_s, 0)
      end
    end
    self.contents.font.color = normal_color
  end
end

end
