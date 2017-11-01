#==============================================================================
# ** Weapon Attacks by Skill or Item
#------------------------------------------------------------------------------
#  Author: Wecoc
#==============================================================================

module SpecialWeapons
    # ID Weapon => [ID Skill, sp cost?]
  SKILLS =  {1 => [7, true],
             2 => [8, false],
            }
    # ID Weapon => [ID Item, item cost?]
  ITEMS =   {3 => [1, true],
            }
end
         
#==============================================================================
# ** Scene_Battle : Attack edit
#==============================================================================

class Scene_Battle
  def make_basic_action_result
    # If attack
    if @active_battler.current_action.basic == 0
      skill_hash = SpecialWeapons::SKILLS
      item_hash = SpecialWeapons::ITEMS
      # Skill attack
      if skill_hash.keys.include?(@active_battler.weapon_id)
        @skill = $data_skills[skill_hash[@active_battler.weapon_id][0]]
        sp_cost = skill_hash[@active_battler.weapon_id][1]
        if sp_cost
          @active_battler.sp -= @skill.sp_cost
          @status_window.refresh
        end
        @animation1_id = @skill.animation1_id
        @animation2_id = @skill.animation2_id
        @common_event_id = @skill.common_event_id
        set_target_battlers(@skill.scope)
        for target in @target_battlers
          target.skill_effect(@active_battler, @skill)
        end
      # Item attack
      elsif item_hash.keys.include?(@active_battler.weapon_id)
        @item = $data_items[item_hash[@active_battler.weapon_id][0]]
        item_cost = item_hash[@active_battler.weapon_id][1]
        if @item.consumable and item_cost
          $game_party.lose_item(@item.id, 1)
        end
        @animation1_id = @item.animation1_id
        @animation2_id = @item.animation2_id
        @common_event_id = @item.common_event_id
        index = @active_battler.current_action.target_index
        target = $game_party.smooth_target_actor(index)
        set_target_battlers(@item.scope)
        for target in @target_battlers
          target.item_effect(@item)
        end
      # Default attack
      else
        @animation1_id = @active_battler.animation1_id
        @animation2_id = @active_battler.animation2_id
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
        @target_battlers = [target]
        for target in @target_battlers
          target.attack_effect(@active_battler)
        end
        return
      end
    end
    # If guard
    if @active_battler.current_action.basic == 1
      @help_window.set_text($data_system.words.guard, 1)
      return
    end
    # If escape
    if @active_battler.is_a?(Game_Enemy) and
      @active_battler.current_action.basic == 2
      @help_window.set_text("Escape", 1)
      @active_battler.escape
      return
    end
    # If doing nothing
    if @active_battler.current_action.basic == 3
      $game_temp.forcing_battler = nil
      @phase4_step = 1
      return
    end
  end
end

#==============================================================================
# ** Scene_Battle : Disable Attack & Guard
#==============================================================================

class Scene_Battle
 
  WEAPON_ATTACK = false # If true, the actor won't attack without weapon
  SHIELD_GUARD = false  # If true, the actor won't defend without shield
 
  alias phase3_setup_disabled phase3_setup_command_window unless $@
  def phase3_setup_command_window
    phase3_setup_disabled
    @disabled_attack = false
    @actor_command_window.enable_item(0)
    @disabled_guard = false
    @actor_command_window.enable_item(2)
    actor = $game_party.actors[@actor_index]
    skill_hash = SpecialWeapons::SKILLS
    item_hash = SpecialWeapons::ITEMS
    if WEAPON_ATTACK
      if actor.weapon_id == 0
        @disabled_attack = true
        @actor_command_window.disable_item(0)
      end
    end
    if SHIELD_GUARD
      if actor.armor1_id == 0
        @disabled_guard = true
        @actor_command_window.disable_item(2)
      end
    end
    if skill_hash.keys.include?(actor.weapon_id)
      if skill_hash[actor.weapon_id][1] == true # sp cost
        skill = $data_skills[skill_hash[actor.weapon_id][0]]
        if skill.sp_cost > actor.sp
          @disabled_attack = true
          @actor_command_window.disable_item(0)
        end
      end
    end
    if item_hash.keys.include?(actor.weapon_id)
      if skill_hash[actor.weapon_id][1] == true # item cost
        item_id = skill_hash[actor.weapon_id][0]
        if $game_party.item_number(item_id) == 0
          @disabled_attack = true
          @actor_command_window.disable_item(0)
        end
      end
    end
  end
 
  def update_phase3_basic_command
    # If B button was pressed
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      phase3_prior_actor
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      case @actor_command_window.index
      when 0  # attack
        if @disabled_attack
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        start_enemy_select
      when 1  # skill
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 1
        start_skill_select
      when 2  # guard
        if @disabled_guard
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 1
        phase3_next_actor
      when 3  # item
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 2
        start_item_select
      end
      return
    end
  end
end

class Window_Command < Window_Selectable
  def enable_item(index)
    draw_item(index, normal_color)
  end
end