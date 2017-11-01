#==============================================================================
# Sideview Battle System Version 2.2xp
#==============================================================================
#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script["SBS Tankentai"] = true

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  def main
    fix_weapon_init
    start
    create_viewport
    process_transition
    update_battle
    terminate
    fix_weapon_end
  end
  #--------------------------------------------------------------------------
  def start
    @battle_start = true
    $game_temp.in_battle = true
    $game_temp.battle_turn = 0
    $game_temp.battle_event_flags.clear
    $game_temp.battle_abort = false
    $game_temp.battle_main_phase = false
    $game_temp.battleback_name = $game_map.battleback_name
    $game_temp.forcing_battler = nil
    $game_system.battle_interpreter.setup(nil, 0)
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    for enemy in $game_troop.enemies
      enemy.true_immortal = enemy.immortal
    end
  end
  #--------------------------------------------------------------------------
  def create_viewport
    s1 = $data_system.words.attack
    s2 = $data_system.words.skill
    s3 = $data_system.words.guard
    s4 = $data_system.words.item
    @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])
    @actor_command_window.y = 160
    @actor_command_window.back_opacity = 160
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @party_command_window = Window_PartyCommand.new
    @help_window = Window_Help.new
    @help_window.back_opacity = 160
    @help_window.visible = false
    @active_battler_window = Window_NameCommand.new(@active_battler, 240, 64)
    @active_battler_window.visible = false
    @status_window = Window_BattleStatus.new
    @message_window = Window_Message.new
    @spriteset = Spriteset_Battle.new
    @wait_count, @escape_ratio = 0, 50
  end
  #--------------------------------------------------------------------------
  def process_transition
    if $data_system.battle_transition == ""
      Graphics.transition(20)
    else
      Graphics.transition(40, "Graphics/Transitions/" + $data_system.battle_transition)
    end
    start_phase1
  end
  #--------------------------------------------------------------------------
  def update_battle
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
  end
  #--------------------------------------------------------------------------
  def terminate
    $game_map.refresh
    Graphics.freeze
    @actor_command_window.dispose
    @party_command_window.dispose
    @help_window.dispose
    @status_window.dispose
    @message_window.dispose
    @skill_window.dispose if @skill_window != nil
    @item_window.dispose if @item_window != nil
    @result_window.dispose if @result_window != nil
    @spriteset.dispose
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end
    $scene = nil if $BTEST and not $scene.is_a?(Scene_Gameover)
  end
  #--------------------------------------------------------------------------
  def fix_weapon_init
    for member in $game_party.actors
      if member.weapons[0] == nil and member.weapons[1] != nil
        weapon_to_equip = member.armor1_id
        member.equip(1, 0)
        member.equip(0, weapon_to_equip)
        member.two_swords_change = true
      end
    end  
  end
  #--------------------------------------------------------------------------
  def fix_weapon_end
    for member in $game_party.actors
      if member.two_swords_change
        weapon_to_re_equip = member.weapon_id
        member.equip(0, 0)
        member.equip(1, weapon_to_re_equip)
        member.two_swords_change = false
      end  
    end
  end
  #--------------------------------------------------------------------------
  def update_basic
    Graphics.update
    Input.update
    $game_system.update
    $game_screen.update
    @spriteset.update
  end  
  #--------------------------------------------------------------------------
  def update_effects
    for battler in $game_party.actors + $game_troop.enemies
      if battler.exist?
        battler_sprite = @spriteset.actor_sprites[battler.index] if battler.actor?
        battler_sprite = @spriteset.enemy_sprites[battler.index] if battler.is_a?(Game_Enemy)
        battler_sprite.effects_update
      end
    end
  end
  #--------------------------------------------------------------------------
  def wait(duration)
    for i in 0...duration
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  def pop_help(obj)
    @help_window.set_text(obj, 1)
    loop do
      update_basic
      break @help_window.visible = false if Input.trigger?(Input::C)
    end
  end
  #--------------------------------------------------------------------------
  alias start_phase1_n01 start_phase1 
  def start_phase1 
    for member in $game_party.actors + $game_troop.enemies
      member.dead_anim = member.dead? ? true : false
      @spriteset.set_stand_by_action(member.actor?, member.index) unless member.dead_anim
    end
    start_phase1_n01 
    $clear_enemies_actions = false
    if $preemptive
      pop_help(PREEMPTIVE_ALERT)
      $clear_enemies_actions = true
    end
    @battle_start = false unless $back_attack 
    return unless $back_attack 
    pop_help(BACK_ATTACK_ALERT)
    @battle_start = false
    $game_party.clear_actions
    start_phase4
  end
  #--------------------------------------------------------------------------
  alias start_phase4_n01 start_phase4
  def start_phase4
    start_phase4_n01
    @active_battler_window.visible = false
    if $clear_enemies_actions
      $clear_enemies_actions = false
      $game_troop.clear_actions
    end
  end
  #--------------------------------------------------------------------------
  def judge
    if $game_party.all_dead? or $game_party.actors.size == 0
      if $game_temp.battle_can_lose
        $game_system.bgm_play($game_temp.map_bgm)
        battle_end(2)
        return true
      end
      $game_temp.gameover = true
      return true
    end
    for enemy in $game_troop.enemies
      return false if enemy.exist?
    end
    process_victory
    return true
  end
  #--------------------------------------------------------------------------
  def update_phase2_escape
    enemies_agi = enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    enemies_agi /= [enemies_number, 1].max
    actors_agi = actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    actors_agi /= [actors_number, 1].max
    @success = rand(100) < @escape_ratio * actors_agi / enemies_agi
    @party_command_window.visible = false
    @party_command_window.active = false
    wait(2)
    if @success
      $game_system.se_play($data_system.escape_se)
      for actor in $game_party.actors
        unless actor.dead?
          @spriteset.set_action(true, actor.index, actor.run_success)
        end
      end
      pop_help(ESCAPE_SUCCESS)
      $game_system.bgm_play($game_temp.map_bgm)
      battle_end(1)
    else
      @escape_ratio += 5
      $game_party.clear_actions
      $game_system.se_play($data_system.escape_se)
      for actor in $game_party.actors
        unless actor.dead?
          @spriteset.set_action(true, actor.index,actor.run_ng)
        end
      end
      pop_help(ESCAPE_FAIL)
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  def process_victory
    for enemy in $game_troop.enemies
      break boss_wait = true if enemy.collapse_type == 3
    end
    wait(440) if boss_wait
    wait(WIN_WAIT) unless boss_wait
    for actor in $game_party.actors
      unless actor.restriction == 4
        @spriteset.set_action(true, actor.index,actor.win)
      end
    end
    start_phase5
  end
  #--------------------------------------------------------------------------
  def start_phase5
    @phase = 5
    $game_system.me_play($game_system.battle_end_me)
    $game_system.bgm_play($game_temp.map_bgm)
    treasures = []
    for enemy in $game_troop.enemies
      gold = gold.nil? ? enemy.gold : gold + enemy.gold
      treasures << treasure_drop(enemy) unless enemy.hidden
    end
    exp = gain_exp
    treasures = treasures.compact
    $game_party.gain_gold(gold)
    for item in treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    @result_window.add_multi_drops if $atoa_script['Multi Drop']
    @phase5_wait_count = 100
  end
  #--------------------------------------------------------------------------
  def treasure_drop(enemy)
    if rand(100) < enemy.treasure_prob
      treasure = $data_items[enemy.item_id] if enemy.item_id > 0
      treasure = $data_weapons[enemy.weapon_id] if enemy.weapon_id > 0
      treasure = $data_armors[enemy.armor_id] if enemy.armor_id > 0
    end
    return treasure
  end
  #--------------------------------------------------------------------------
  def gain_exp
    exp = exp_gained
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false
        last_level = actor.level
        actor.exp += exp
        if actor.level > last_level
          @status_window.level_up(i)
        end
      end
    end
    return exp
  end
  #--------------------------------------------------------------------------
  def exp_gained
    for enemy in $game_troop.enemies
      exp = exp.nil? ? enemy.exp : exp + enemy.exp
    end
    if EXP_SHARE
      actor_number = 0
      for actor in $game_party.actors
        actor_number += 1 unless actor.cant_get_exp?
      end
      exp = exp / [actor_number, 1].max
    end
    return exp
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase5 update_phase5
  def update_phase5
    @result_window.update
    acbs_update_phase5
  end
  #--------------------------------------------------------------------------
  alias phase3_next_actor_n01 phase3_next_actor
  def phase3_next_actor
    if @active_battler != nil && @active_battler.inputable?
      @spriteset.set_action(true, @actor_index, @active_battler.command_a)
    end
    @wait_count = 32 if @actor_index == $game_party.actors.size-1 
    phase3_next_actor_n01
    if @active_battler != nil && @active_battler.inputable?
      @spriteset.set_action(true, @actor_index,@active_battler.command_b)
    end  
  end  
  #--------------------------------------------------------------------------
  alias phase3_prior_actor_n01 phase3_prior_actor
  def phase3_prior_actor
    if @active_battler != nil && @active_battler.inputable?
      @active_battler.current_action.clear
      @spriteset.set_action(true, @actor_index,@active_battler.command_a)
    end
    phase3_prior_actor_n01
    if @active_battler != nil && @active_battler.inputable?
      @active_battler.current_action.clear
      @spriteset.set_action(true, @actor_index,@active_battler.command_b)
    end
  end
  #--------------------------------------------------------------------------
  alias start_phase2_n01 start_phase2
  def start_phase2
    @active_battler_window.visible = false
    start_phase2_n01
  end
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_n01 phase3_setup_command_window
  def phase3_setup_command_window
    phase3_setup_command_window_n01
    @actor_command_window.x = COMMAND_WINDOW_POSITION[0]
    @actor_command_window.y = COMMAND_WINDOW_POSITION[1]
    @actor_command_window.z = 2000
    @actor_command_window.index = 0
    @actor_command_window.back_opacity = COMMAND_OPACITY
    @active_battler_window.refresh(@active_battler)
    @active_battler_window.visible = true if BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_basic_command_scenebattle update_phase3_basic_command
  def update_phase3_basic_command
    if Input.trigger?(Input::C)
      case @actor_command_window.commands[@actor_command_window.index]
      when $data_system.words.attack
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        @actor_command_window.active = false
        @actor_command_window.visible = false
        start_enemy_select
        return
      when $data_system.words.item
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 2
        start_item_select
        return
      when $data_system.words.guard 
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 1
        phase3_next_actor
        return
      end
    end
    acbs_update_phase3_basic_command_scenebattle
  end
  #--------------------------------------------------------------------------
  def now_action(battler = @active_battler)
    return if battler.nil?
    @now_action = nil
    case battler.current_action.kind
    when 0
      @now_action = $data_weapons[battler.weapon_id] if battler.current_action.basic == 0
    when 1
      @now_action = $data_skills[battler.current_action.skill_id]
    when 2
      @now_action = $data_items[battler.current_action.item_id]
    end
  end
  #--------------------------------------------------------------------------
  def start_enemy_select
    now_action
    @enemy_arrow = Arrow_Enemy.new(@spriteset.viewport2)
    @enemy_arrow.help_window = @help_window
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @active_battler_window.visible = false
    @status_window.visible = true
  end
  #--------------------------------------------------------------------------
  alias start_actor_select_n01 start_actor_select
  def start_actor_select
    now_action
    start_actor_select_n01
    @status_window.visible = true
    @active_battler_window.visible = false
    @actor_arrow.input_right if @now_action.extension.include?("OTHERS")
  end
  #--------------------------------------------------------------------------
  alias update_phase3_actor_select_n01 update_phase3_actor_select
  def update_phase3_actor_select
    @actor_arrow.input_update_target if @now_action.extension.include?("OTHERS") and @actor_arrow.index == @active_battler.index
    update_phase3_actor_select_n01
  end
  #--------------------------------------------------------------------------
  alias update_phase3_n01 update_phase3
  def update_phase3
    if @enemy_arrow_all != nil
      update_phase3_select_all_enemies
      return
    elsif @actor_arrow_all != nil
      update_phase3_select_all_actors
      return
    elsif @battler_arrow_all != nil
      update_phase3_select_all_battlers
      return
    end
    update_phase3_n01
  end
  #--------------------------------------------------------------------------
  alias update_phase3_skill_select_n01 update_phase3_skill_select
  def update_phase3_skill_select
    @status_window.visible = false  if HIDE_WINDOW
    if Input.trigger?(Input::C)
      @skill = @skill_window.skill
      if @skill == nil or not @active_battler.skill_can_use?(@skill.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      @active_battler.current_action.skill_id = @skill.id
      @skill_window.visible = false
      if @skill.extension.include?("TARGETALL")
        $game_system.se_play($data_system.decision_se)
        start_select_all_battlers
        return
      end
      if (@skill.extension.include?("RANDOMTARGET") and @skill.scope <= 2) or @skill.scope == 2
        $game_system.se_play($data_system.decision_se)
        start_select_all_enemies
        return
      end
      if (@skill.extension.include?("RANDOMTARGET") and @skill.scope > 2) or @skill.scope == 4
        $game_system.se_play($data_system.decision_se)
        start_select_all_actors
        return
      end
    end
    update_phase3_skill_select_n01
  end
  #--------------------------------------------------------------------------
  alias update_phase3_item_select_n01 update_phase3_item_select
  def update_phase3_item_select
    @status_window.visible = false if HIDE_WINDOW
    if Input.trigger?(Input::C)
      @item = @item_window.item
      if @item == nil or not $game_party.item_can_use?(@item.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      @active_battler.current_action.item_id = @item.id
      @item_window.visible = false
      if @item.extension.include?("TARGETALL")
        $game_system.se_play($data_system.decision_se)
        start_select_all_battlers
        return
      end
      if @item.extension.include?("RANDOMTARGET") and @item.scope <= 2 or @item.scope == 2
        $game_system.se_play($data_system.decision_se)
        start_select_all_enemies
        return
      end
      if (@item.extension.include?("RANDOMTARGET") and @item.scope > 2) or @item.scope == 4
        $game_system.se_play($data_system.decision_se)
        start_select_all_actors
        return
      end
    end
    update_phase3_item_select_n01
  end
  #--------------------------------------------------------------------------
  def update_phase3_select_all_enemies
    @enemy_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_all_enemies
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      if @skill_window != nil
        end_skill_select
      end 
      if @item_window != nil
        end_item_select
      end
      end_select_all_enemies
      phase3_next_actor
      return
    end
  end
  #--------------------------------------------------------------------------
  def update_phase3_select_all_actors
    @actor_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_all_actors
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      if @skill_window != nil
        end_skill_select
      end 
      if @item_window != nil
        end_item_select
      end
      end_select_all_actors
      phase3_next_actor
      return
    end
  end      
  #--------------------------------------------------------------------------
  def update_phase3_select_all_battlers
    @battler_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_all_battlers
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      if @skill_window != nil
        end_skill_select
      end 
      if @item_window != nil
        end_item_select
      end
      end_select_all_battlers
      phase3_next_actor
      return
    end
  end      
  #--------------------------------------------------------------------------
  def start_select_all_enemies
    now_action
    @status_window.visible = true
    @active_battler_window.visible = false
    @enemy_arrow_all = Arrow_Enemy_All.new(@spriteset.viewport2)
  end
  #--------------------------------------------------------------------------
  def start_select_all_actors
    now_action
    @status_window.visible = true
    @active_battler_window.visible = false
    @actor_arrow_all = Arrow_Actor_All.new(@spriteset.viewport2)
  end
  #--------------------------------------------------------------------------
  def start_select_all_battlers
    now_action
    @status_window.visible = true
    @active_battler_window.visible = false 
    @battler_arrow_all = Arrow_Battler_All.new(@spriteset.viewport2)
  end
  #--------------------------------------------------------------------------
  def end_select_all_actors
    @actor_arrow_all.dispose_multi_arrow
    @actor_arrow_all = nil
    @active_battler_window.visible = true if @actor_command_window.index == 0 and BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  def end_select_all_enemies
    @enemy_arrow_all.dispose_multi_arrow
    @enemy_arrow_all = nil
    @active_battler_window.visible = true if @actor_command_window.index == 0 and BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  def end_select_all_battlers
    @battler_arrow_all.dispose_multi_arrow
    @battler_arrow_all = nil
    @active_battler_window.visible = true if @actor_command_window.index == 0 and BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  alias end_enemy_select_n01 end_enemy_select
  def end_enemy_select
    end_enemy_select_n01
    @active_battler_window.visible = true if @actor_command_window.index == 0 and BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  alias start_skill_select_n01 start_skill_select
  def start_skill_select
    start_skill_select_n01
    @status_window.visible = false if HIDE_WINDOW
    @active_battler_window.visible = false
  end
  #--------------------------------------------------------------------------
  alias end_skill_select_n01 end_skill_select
  def end_skill_select
    end_skill_select_n01
    @status_window.visible = true
    @active_battler_window.visible = true if BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  alias start_item_select_n01 start_item_select
  def start_item_select
    start_item_select_n01
    @status_window.visible = false if HIDE_WINDOW
    @active_battler_window.visible = false
  end
  #--------------------------------------------------------------------------
  alias end_item_select_n01 end_item_select
  def end_item_select
    end_item_select_n01
    @status_window.visible = true
    @active_battler_window.visible = true if BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  alias make_action_orders_n01 make_action_orders
  def make_action_orders
    make_action_orders_n01
    for battler in @action_battlers
      skill_id = battler.current_action.skill_id
      item_id = battler.current_action.item_id
      next if battler.current_action.kind == 0
      extension = $data_skills[skill_id].extension if skill_id != 0
      extension = $data_items[item_id].extension if item_id != 0
      battler.current_action.speed = 9999 if extension.include?("FAST")
      battler.current_action.speed = -1 if extension.include?("SLOW")
    end
    @action_battlers.sort! {|a,b|
      b.current_action.speed - a.current_action.speed }
    for enemy in $game_troop.enemies
      if enemy.action_time[0] != 1
        action_time = 0
        for i in 1...enemy.action_time[0]
          action_time += 1 if rand(100) < enemy.action_time[1]
        end
        enemy.act_time = action_time
        action_time.times do
          enemy_order_time(enemy)
          action_time -= 1
          break if action_time == 0
        end  
        enemy.adj_speed = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  def enemy_order_time(enemy)
    enemy.make_action_speed2(enemy.action_time[2])
    select_time = 0
    for member in @action_battlers
      select_time += 1
      break @action_battlers.push(enemy) if member.current_action.speed < enemy.adj_speed
      break @action_battlers.push(enemy) if select_time == @action_battlers.size
    end
  end  
  #--------------------------------------------------------------------------
  def update_phase4_step1
    return if @spriteset.effect?
    return @wait_count -= 1 if @wait_count > 0
    @help_window.visible = false
    return if judge
    if $game_temp.forcing_battler == nil
      setup_battle_event
       return if $game_system.battle_interpreter.running?
    end
    if $game_temp.forcing_battler != nil
      @action_battlers.delete($game_temp.forcing_battler)
      @action_battlers.unshift($game_temp.forcing_battler)
    end
    if @action_battlers.size == 0
      turn_ending
      start_phase2
      return
    end
    @animation1_id = 0
    @animation2_id = 0
    @common_event_id = 0
    @active_battler = @action_battlers.shift
    return if @active_battler.index == nil
    @active_battler.remove_states_auto
    @status_window.refresh
    @phase4_step = 2
  end
  #--------------------------------------------------------------------------
  def turn_ending
    for member in $game_party.actors + $game_troop.enemies
      member.current_action.clear
      next unless member.exist?
      member.slip_damage = false
      actor = member.actor?
      for state in member.battler_states
        member.remove_state(state.id) if state.extension.include?("ZEROTURNLIFT")
      end
      damage = 0
      for state in member.battler_states
        next unless state.extension.include?("SLIPDAMAGE")
        for ext in state.slip_extension
          if ext[0] == "hp"
            base_damage = ext[1] + member.maxhp * ext[2] / 100
            damage += base_damage + base_damage * (rand(5) - rand(5)) / 100
            slip_pop = ext[3]
            slip_dead = ext[4]
            slip_damage_flug = true
            member.slip_damage = true
          end
        end  
      end
      if member.slip_damage && member.exist? && !slip_damage_flug
        damage += member.apply_variance(member.maxhp / 10, 10)
        slip_dead = false
        slip_pop = true
        slip_damage_flug = true
        member.slip_damage = true
      end
      damage = member.hp - 1 if damage >= member.hp && slip_dead = false
      member.hp -= damage
      member.damage = damage if damage > 0
      member.perform_collapse if member.dead? && member.slip_damage
      @spriteset.set_damage_pop(actor, member.index, damage) if slip_pop
      @spriteset.set_stand_by_action(actor, member.index) if member.hp <= 0 and not member.dead_anim
      member.dead_anim = member.dead? ? true : false
    end
    @status_window.refresh
    wait(DMG_DURATION / 2) if slip_damage_flug
    slip_damage_flug = false
    for member in $game_party.actors + $game_troop.enemies
      next unless member.exist?
      actor = member.actor?
      damage = 0
      for state in member.battler_states
        next unless state.extension.include?("SLIPDAMAGE")
        for ext in state.slip_extension
          if ext[0] == "mp"
            base_damage = ext[1] + member.maxsp * ext[2] / 100
            damage += base_damage + base_damage * (rand(5) - rand(5)) / 100
            slip_pop = ext[3]
            slip_damage_flug = true
          end
        end
        member.sp_damage = true
        member.sp -= damage
        member.damage = damage if damage > 0
        @spriteset.set_damage_pop(actor, member.index, damage) if slip_pop
      end
    end
    @status_window.refresh
    wait(DMG_DURATION / 2) if slip_damage_flug
    for member in $game_party.actors + $game_troop.enemies
      next unless member.exist?
      actor = member.actor?
      damage = 0
      for state in member.battler_states
        next unless state.extension.include?("REGENERATION")
        for ext in state.slip_extension
          if ext[0] == "hp"
            base_damage = ext[1] + member.maxhp * ext[2] / 100
            damage += base_damage + base_damage * (rand(5) - rand(5)) / 100
            slip_pop = ext[3]
            slip_damage_flug = true
          end
        end
        member.hp -= damage
        member.damage = damage if damage < 0
        @spriteset.set_damage_pop(actor, member.index, damage) if slip_pop
      end   
    end
    @status_window.refresh
    wait(DMG_DURATION / 2) if slip_damage_flug
    for member in $game_party.actors + $game_troop.enemies
      next unless member.exist?
      actor = member.actor?
      damage = 0
      for state in member.battler_states
        next unless state.extension.include?("REGENERATION")
        for ext in state.slip_extension
          if ext[0] == "mp"
            base_damage = ext[1] + member.maxhp * ext[2] / 100
            damage += base_damage + base_damage * (rand(5) - rand(5)) / 100
            slip_pop = ext[3]
            slip_damage_flug = true
          end
        end
        member.sp_damage = true
        member.sp -= damage  
        member.damage = damage if damage < 0
        @spriteset.set_damage_pop(actor, member.index, damage) if slip_pop
      end
    end
    @status_window.refresh
    wait(DMG_DURATION / 2) if slip_damage_flug
  end
  #--------------------------------------------------------------------------
  alias update_phase4_step2_n01 update_phase4_step2
  def update_phase4_step2
    for member in $game_party.actors + $game_troop.enemies
      member.dead_anim = member.dead? ? true : false
    end
    if @active_battler.current_action.kind != 0
      obj = $data_skills[@active_battler.current_action.skill_id] if @active_battler.current_action.kind == 1
      obj = $data_items[@active_battler.current_action.item_id] if @active_battler.current_action.kind == 2
      @active_battler.white_flash = false if obj != nil &&obj.extension.include?("NOFLASH")
    end 
    @active_battler.active = true
    update_phase4_step2_n01
    if @active_battler != nil && @active_battler.derivation != 0
      @active_battler.current_action.kind = 1
      @active_battler.current_action.skill_id = @active_battler.derivation
      @action_battlers.unshift(@active_battler)
    end
    if @active_battler != nil && !@active_battler.actor? && @active_battler.act_time != 0
      @active_battler.make_action
      @active_battler.act_time -= 1
    end
    update_phase4_step6
  end
  #--------------------------------------------------------------------------
  alias update_phase4_step6_n01 update_phase4_step6
  def update_phase4_step6
    update_phase4_step6_n01
    @active_battler.active = false if @active_battler != nil
  end
  #--------------------------------------------------------------------------
  def make_basic_action_result
    if @active_battler.current_action.basic == 0
      execute_action_attack
      return
    end
    if @active_battler.current_action.basic == 1
      @help_window.set_text("#{@active_battler.name} defends", 1)
      @help_window.visible = true
      @active_battler.active = false
      @active_battler.defense_pose = true
      @spriteset.set_stand_by_action(@active_battler.actor?, @active_battler.index)
      wait(45)
      @help_window.visible = false
      return
    end
    if @active_battler.is_a?(Game_Enemy) and @active_battler.current_action.basic == 2
      @spriteset.set_action(false, @active_battler.index, @active_battler.run_success)
      $game_system.se_play($data_system.escape_se)
      @active_battler.escape
      pop_help("#{@active_battler.name} escaped...")
      return
    end
    if @active_battler.current_action.basic == 3
      @active_battler.active = false
      $game_temp.forcing_battler = nil
      @phase4_step = 1
      return
    end
  end
  #--------------------------------------------------------------------------
  def execute_action_attack
    if @active_battler.actor?
      if @active_battler.weapon_id == 0
        action = @active_battler.non_weapon 
        immortaling
      else  
        action = $data_weapons[@active_battler.weapon_id].base_action
        if $data_weapons[@active_battler.weapon_id].plus_state_set.include?(1)
          for member in $game_party.actors + $game_troop.enemies
            next if member.immortal
            next if member.dead?
            member.dying = true
          end
        else
          immortaling 
        end 
      end  
    else
      if @active_battler.weapon == 0
        action = @active_battler.base_action
        immortaling
      else
        action = $data_weapons[@active_battler.weapon].base_action
        if $data_weapons[@active_battler.weapon].plus_state_set.include?(1)
          for member in $game_party.actors + $game_troop.enemies
            next if member.immortal
            next if member.dead?
            member.dying = true
          end
        else
          immortaling 
        end
      end  
    end 
    target_decision
    @spriteset.set_action(@active_battler.actor?, @active_battler.index, action)
    playing_action
  end
  #--------------------------------------------------------------------------
  def make_attack_targets
    @target_battlers = []
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
    if @active_battler.actor?
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
    return @target_battlers
  end
  #--------------------------------------------------------------------------
  def make_skill_action_result
    skill = $data_skills[@active_battler.current_action.skill_id]
    if skill.plus_state_set.include?(1)
      for member in $game_party.actors + $game_troop.enemies
        next if member.immortal
        next if member.dead?
        member.dying = true
      end
    else
      immortaling 
    end
    return unless @active_battler.skill_can_use?(skill.id)
    target_decision(skill)
    @active_battler.consum_skill_cost(skill)
    @status_window.refresh
    @spriteset.set_action(@active_battler.actor?, @active_battler.index, skill.base_action)
    @help_window.set_text(skill.name, 1) unless skill.extension.include?("HELPHIDE")
    playing_action
    @common_event_id = skill.common_event_id
  end 
  #--------------------------------------------------------------------------
  def make_item_action_result
    item = $data_items[@active_battler.current_action.item_id]
    unless $game_party.item_can_use?(item.id)
      @phase4_step = 1
      return
    end
    if @item.consumable
      $game_party.lose_item(item.id, 1)
    end
    immortaling
    target_decision(item)
    @spriteset.set_action(@active_battler.actor?, @active_battler.index, item.base_action)
    @help_window.set_text(item.name, 1) unless item.extension.include?("HELPHIDE")
    playing_action
    @common_event_id = item.common_event_id
  end
  #--------------------------------------------------------------------------
  def target_decision(obj = nil)
    if obj != nil
      set_target_battlers(obj.scope)
      if obj.extension.include?("TARGETALL")
        @target_battlers = []
        if obj.scope != 5 or obj.scope != 6
          for target in $game_troop.enemies + $game_party.actors
            @target_battlers.push(target) if target.exist?
          end
        else
          for target in $game_troop.enemies + $game_party.actors
            @target_battlers.push(target) if target != nil && target.hp0?
          end
        end
      end
      @target_battlers.delete(@active_battler) if obj.extension.include?("OTHERS")
      if obj.extension.include?("RANDOMTARGET")
        randum_targets = @target_battlers.dup
        @target_battlers = [randum_targets[rand(randum_targets.size)]]
      end
    else
      @target_battlers = make_attack_targets
    end
    if @target_battlers.size == 0
      action = @active_battler.recover_action
      @spriteset.set_action(@active_battler.actor?, @active_battler.index, action)
    end
    @spriteset.set_target(@active_battler.actor?, @active_battler.index, @target_battlers)
  end   
  #--------------------------------------------------------------------------
  def playing_action
    loop do
      update_basic
      update_effects
      action = @active_battler.play
      next if action == 0
      @active_battler.play = 0
      if action[0] == "Individual"
        individual
      elsif action == "Can Collapse"
        unimmortaling
      elsif action == "Cancel Action"
        break action_end
      elsif action == "End"
        break action_end
      elsif action[0] == "OBJ_ANIM"
        damage_action(action[1])
      end
    end
  end
  #--------------------------------------------------------------------------
  def individual
    @individual_target = @target_battlers
    @stand_by_target = @target_battlers.dup
  end 
  #--------------------------------------------------------------------------
  def immortaling
    for member in $game_party.actors + $game_troop.enemies
      member.immortal = true unless member.dead?
    end  
  end  
  #--------------------------------------------------------------------------
  def unimmortaling
    return if @active_battler.individual
    for member in $game_party.actors + $game_troop.enemies
      member.immortal = false
      member.add_state(1) if member.dead?
      if member.dead? and not member.dead_anim
        member.perform_collapse
        @spriteset.set_stand_by_action(member.actor?, member.index)
      end
      member.dead_anim = member.dead? ? true : false
      next unless member.dead?
      resurrection(member)
    end
    update_basic
    @status_window.refresh
  end
  #--------------------------------------------------------------------------
  def resurrection(target)
    for state in target.battler_states
      for ext in state.extension
        name = ext.split('')
        next unless name[0] == "A"
        wait(25)
        name = name.join
        name.slice!("AUTOLIFE/")
        target.hp = target.maxhp * name.to_i / 100
        target.remove_state(1)
        target.remove_state(state.id)
        target.animation_id = RESURRECTION
        target.animation_hit = true
        target.anime_mirror = true if $back_attack
        @status_window.refresh
        wait($data_animations[RESURRECTION].frame_max * 2)
      end  
    end
  end
  #--------------------------------------------------------------------------
  def magic_reflection(target, obj)
    return if obj != nil and $data_skills[@active_battler.current_action.skill_id].int_f == 0
    for state in target.battler_states
      for ext in state.extension
        name = ext.split('')
        next unless name[0] == "M"
        if name[3] == "R"
          name = name.join
          name.slice!("MAGREFLECT/")
          target.animation_id = name.to_i
          target.animation_hit = true
          target.anime_mirror = true if $back_attack
          @reflection = true
        else
          name = name.join
          name.slice!("MAGNULL/")
          target.animation_id = name.to_i
          target.animation_hit = true
          target.anime_mirror = true if $back_attack
          @invalid = true
        end  
      end  
    end
  end
  #--------------------------------------------------------------------------
  def physics_reflection(target, obj)
    return if obj != nil && $data_skills[@active_battler.current_action.skill_id].str_f == 0
    for state in target.battler_states
      for ext in state.extension
        name = ext.split('')
        next unless name[0] == "P"
        if name[3] == "R"
          name = name.join
          name.slice!("PHYREFLECT/")
          target.animation_id = name.to_i
          target.animation_hit = true
          target.anime_mirror = true if $back_attack
          @reflection = true
        else
          name = name.join
          name.slice!("PHYNULL/")
          target.animation_id = name.to_i
          target.animation_hit = true
          target.anime_mirror = true if $back_attack
          @invalid = true
        end 
      end  
    end
  end
  #--------------------------------------------------------------------------
  def absorb_cost(target, obj)
    for state in target.battler_states
      if state.extension.include?("COSTABSORB")
        cost = @active_battler.calc_sp_cost(@active_battler, obj)
        return target.hp += cost if obj.extension.include?("HPCONSUME")
        return target.mp += cost
      end  
    end 
  end
  #--------------------------------------------------------------------------
  def absorb_attack(obj, target, index, actor)
    for ext in obj.extension
      return if target.evaded or target.missed or target.damage == 0 or target.damage == nil
      name = ext.split('')
      next unless name[3] == "G" and name[1] == "D" 
      name = name.join
      name.slice!("%DMGABSORB/")
      kind = "hp" unless target.sp_damage
      kind = "sp" if target.sp_damage
      absorb = target.damage * name.to_i / 100
      @wide_attack = true if obj.scope == 2 or obj.scope == 4 or obj.scope == 6 or obj.extension.include?("TARGETALL")
      if @wide_attack && @absorb == nil && @target_battlers.size != 1
        @absorb = absorb
        @absorb_target_size = @target_battlers.size - 2
      elsif @absorb != nil && @absorb_target_size > 0
        @absorb += absorb
        @absorb_target_size -= 1
      elsif @absorb != nil
        @absorb += absorb
        absorb_action = ["absorb", nil, kind, @absorb]
        @spriteset.set_damage_action(actor, index, absorb_action)
        @absorb = nil
        @absorb_target_size = nil
        @active_battler.perform_collapse
      else
        absorb_action = ["absorb", nil, kind, absorb]
        @spriteset.set_damage_action(actor, index, absorb_action)
        @active_battler.perform_collapse
      end  
    end
  end  
  #--------------------------------------------------------------------------
  def action_end
    @individual_target = nil
    @help_window.visible = false if @help_window != nil && @help_window.visible
    @active_battler.active = false
    unimmortaling
    for member in $game_troop.enemies
      member.non_dead = false if member.non_dead
    end
    if @active_battler.reflex != nil
      if @active_battler.current_action.kind == 1
        obj = $data_skills[@active_battler.current_action.skill_id]
        @active_battler.perfect_skill_effect(@active_battler, obj)
      elsif @active_battler.current_action.kind == 2
        obj = $data_items[@active_battler.current_action.item_id]
        @active_battler.item_effect(@active_battler, obj)
      else
        @active_battler.perfect_attack_effect(@active_battler)
      end
      pop_damage(@active_battler, obj, @active_battler.reflex)
      @active_battler.perform_collapse
      @active_battler.reflex = nil
      wait(COLLAPSE_WAIT)
    end
    if @active_battler.derivation != 0
      @active_battler.current_action.skill_id = @active_battler.derivation
      @active_battler.current_action.kind = 1
      @active_battler.derivation = 0
      @action_battlers.unshift(@active_battler)
    else
      @spriteset.set_stand_by_action(@active_battler.actor?, @active_battler.index)
      wait(ACTION_WAIT + 20)
    end
  end  
  #--------------------------------------------------------------------------
  def damage_action(action)
    @target_battlers = [@individual_target.shift] if @active_battler.individual
    if @active_battler.current_action.kind == 1
      obj = $data_skills[@active_battler.current_action.skill_id]
      for target in @target_battlers
        return if target == nil
        if obj.scope == 5 or obj.scope == 6
          return unless target.dead?
        else
          return if target.dead?
        end
        if target.hp == 0 && obj.scope != 5 && obj.scope != 6
          target.perfect_skill_effect(@active_battler, obj)
        elsif obj.extension.include?("NOEVADE")
          target.perfect_skill_effect(@active_battler, obj)
        else
          magic_reflection(target, obj) unless obj.extension.include?("IGNOREREFLECT")
          physics_reflection(target, obj) unless obj.extension.include?("IGNOREREFLECT")
          target.skill_effect(@active_battler, obj) unless @reflection or @invalid
        end
        pop_damage(target, obj, action) unless @reflection or @invalid
        absorb_cost(target, obj)
        @active_battler.reflex = action if @reflection
        @reflection = false
        @invalid = false
      end
    elsif @active_battler.current_action.kind == 2
      obj = $data_items[@active_battler.current_action.item_id]
      for target in @target_battlers
        return if target == nil 
        if obj.scope == 5 or obj.scope == 6
          return unless target.dead?
        else
          return if target.dead?
        end 
        target.revival = true if obj.scope == 5 or obj.scope == 6
        target.item_effect(obj)
        pop_damage(target, obj, action)
      end
    else 
      for target in @target_battlers
        return if target == nil or target.dead?
        physics_reflection(target, nil)
        target.perfect_attack_effect(@active_battler) if target.hp <= 0
        target.attack_effect(@active_battler) unless target.hp <= 0 unless @reflection or @invalid
        pop_damage(target, obj, action) unless @reflection or @invalid
        @active_battler.reflex = action if @reflection
        @reflection = false
        @invalid = false
      end
    end
    return if obj == nil
    target_decision(obj) if obj.extension.include?("RANDOMTARGET")
  end
  #--------------------------------------------------------------------------
  def pop_damage(target, obj, action)
    index = @active_battler.index
    actor = @active_battler.actor?
    if obj != nil && obj.extension.size != 0
      absorb_attack(obj, target, index, actor)
      action[2] = false if obj.extension.include?("NOOVERKILL")
    end
    @spriteset.set_damage_action(target.actor?, target.index, action)
    @status_window.refresh
  end
end  

#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias call_battle_n01 call_battle
  #--------------------------------------------------------------------------
  def call_battle
    $back_attack = $preemptive = false
    preemptive_or_back_attack
    call_battle_n01
  end
  #--------------------------------------------------------------------------
  def preemptive_or_back_attack  
    enemies_agi = 0
    for enemy in $game_troop.enemies
      enemies_agi += enemy.agi
    end
    enemies_agi /= [$game_troop.enemies.size, 1].max
    actors_agi = 0
    for actor in $game_party.actors
      actors_agi += actor.agi
    end
    actors_agi /= [$game_party.actors.size, 1].max
    preemptive_plus
    if actors_agi >= enemies_agi
      percent_preemptive = PREEMPTIVE_RATE * ($preemptive_plus ? 3 : 1)
      percent_back_attack = BACK_ATTACK_RATE / 2
    else
      percent_preemptive = (PREEMPTIVE_RATE / 2) * ($preemptive_plus ? 3 : 1)
      percent_back_attack = BACK_ATTACK_RATE
    end
    if rand(100) < percent_preemptive
      $preemptive = true
    elsif rand(100) < percent_back_attack
      $back_attack = true
    end
    special_back_attack_conditions
    special_preemptive_conditions
    $preemptive = false if $back_attack or !PREEMPTIVE
    $back_attack = false if !BACK_ATTACK
  end
  #--------------------------------------------------------------------------
  def special_back_attack_conditions
    for i in 0...BACK_ATTACK_SWITCH.size
      return $back_attack = true if $game_switches[BACK_ATTACK_SWITCH[i]]
    end
    for i in 0...NO_BACK_ATTACK_SWITCH.size
      return $back_attack = false if $game_switches[NON_BACK_ATTACK_SWITCH[i]]
    end
    for actor in $game_party.actors
      return $back_attack = false if NON_BACK_ATTACK_WEAPONS.include?(actor.weapon_id)
      return $back_attack = false if NON_BACK_ATTACK_ARMOR1.include?(actor.armor1_id)
      return $back_attack = false if NON_BACK_ATTACK_ARMOR2.include?(actor.armor2_id)
      return $back_attack = false if NON_BACK_ATTACK_ARMOR3.include?(actor.armor3_id)
      return $back_attack = false if NON_BACK_ATTACK_ARMOR4.include?(actor.armor4_id)
      for i in 0...NON_BACK_ATTACK_SKILLS.size
        return $back_attack = false if actor.skill_id_learn?(NON_BACK_ATTACK_SKILLS[i])
      end  
    end
  end
  #--------------------------------------------------------------------------
  def special_preemptive_conditions
    for i in 0...PREEMPTIVE_SWITCH.size
      return $preemptive = true if $game_switches[PREEMPTIVE_SWITCH[i]]
    end
    for i in 0...NO_PREEMPTIVE_SWITCH.size
      return $preemptive = false if $game_switches[NON_PREEMPTIVE_SWITCH[i]]
    end
  end
  #--------------------------------------------------------------------------
  def preemptive_plus
    $preemptive_plus = false
    for actor in $game_party.actors
     return $preemptive_plus = true if PREEMPTIVE_WEAPONS.include?(actor.weapon_id)
     return $preemptive_plus = true if PREEMPTIVE_ARMOR1.include?(actor.armor1_id)
     return $preemptive_plus = true if PREEMPTIVE_ARMOR2.include?(actor.armor2_id)
     return $preemptive_plus = true if PREEMPTIVE_ARMOR3.include?(actor.armor3_id)
     return $preemptive_plus = true if PREEMPTIVE_ARMOR4.include?(actor.armor4_id)
      for i in 0...PREEMPTIVE_SKILLS.size
        return $preemptive_plus = true if actor.skill_id_learn?(PREEMPTIVE_SKILLS[i])
      end  
    end
  end
end

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #--------------------------------------------------------------------------
  attr_reader   :viewport1                
  attr_reader   :viewport2               
  attr_accessor :actor_sprites
  attr_accessor :enemy_sprites
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport4 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 101
    @viewport3.z = 200
    @viewport4.z = 5000
    @battleback_sprite = Sprite.new(@viewport1)
    @battleback_sprite.mirror = true if $back_attack && BACK_ATTACK_BATTLE_BACK_MIRROR
    @enemy_sprites = []
    for enemy in $game_troop.enemies
      @enemy_sprites.push(Sprite_Battler.new(@viewport2, enemy))
    end
    @actor_sprites = []
    for i in 0...$game_party.actors.size
      @actor_sprites.push(Sprite_Battler.new(@viewport2, $game_party.actors[i]))
    end
    @weather = RPG::Weather.new(@viewport1)
    @picture_sprites = []
    for i in 51..100
      @picture_sprites.push(Sprite_Picture.new(@viewport3, $game_screen.pictures[i]))
    end
    @timer_sprite = Sprite_Timer.new
    update
  end
  #--------------------------------------------------------------------------
  def update
    if $game_party.actors.size > @actor_sprites.size
      for i in @actor_sprites.size...$game_party.actors.size
        @actor_sprites.push(Sprite_Battler.new(@viewport2, $game_party.actors[i]))
      end
    elsif @actor_sprites.size > $game_party.actors.size
      for i in 0...@actor_sprites.size
        @actor_sprites[i].dispose
      end
      @actor_sprites = []
      for i in 0...$game_party.actors.size
        @actor_sprites.push(Sprite_Battler.new(@viewport2, $game_party.actors[i]))
      end
    end
    for i in 0...$game_party.actors.size
      @actor_sprites[i].battler = $game_party.actors[i]
    end
    if @battleback_name != $game_temp.battleback_name
      @battleback_name = $game_temp.battleback_name
      if @battleback_sprite.bitmap != nil
        @battleback_sprite.bitmap.dispose
      end
      @battleback_sprite.bitmap = RPG::Cache.battleback(@battleback_name)
      @battleback_sprite.src_rect.set(0, 0, 640, 480)
    end
    for sprite in @enemy_sprites + @actor_sprites
      sprite.update
    end
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.update
    for sprite in @picture_sprites
      sprite.update
    end
    @timer_sprite.update
    @viewport1.tone = $game_screen.tone
    @viewport1.ox = $game_screen.shake
    @viewport2.tone = $game_screen.tone
    @viewport2.ox = $game_screen.shake
    @viewport4.color = $game_screen.flash_color
    @viewport1.update
    @viewport2.update
    @viewport4.update
  end
  #--------------------------------------------------------------------------
  def set_damage_action(actor, index, action)
    return if index.nil?
    @actor_sprites[index].damage_action(action) if actor
    @enemy_sprites[index].damage_action(action) unless actor
  end
  #--------------------------------------------------------------------------
  def set_damage_pop(actor, index, damage)
    return if index.nil?
    @actor_sprites[index].damage_pop if actor
    @enemy_sprites[index].damage_pop unless actor
  end
  #--------------------------------------------------------------------------
  def set_target(actor, index, target)
    return if index.nil?
    @actor_sprites[index].get_target(target) if actor
    @enemy_sprites[index].get_target(target) unless actor
  end
  #--------------------------------------------------------------------------
  def set_action(actor, index, kind)
    return if index.nil?
    @actor_sprites[index].start_action(kind) if actor
    @enemy_sprites[index].start_action(kind) unless actor
  end  
  #--------------------------------------------------------------------------
  def set_stand_by_action(actor, index)
    return if index.nil?
    @actor_sprites[index].push_stand_by if actor
    @enemy_sprites[index].push_stand_by unless actor
  end
end

#==============================================================================
# ■ Sprite_MoveAnime
#==============================================================================
class Sprite_MoveAnime < RPG::Sprite
  #--------------------------------------------------------------------------
  attr_accessor :battler
  attr_accessor :base_x
  attr_accessor :base_y
  #--------------------------------------------------------------------------
  def initialize(viewport,battler = nil)
    super(viewport)
    @battler = battler
    self.visible = false
    @base_x = 0
    @base_y = 0
    @move_x = 0
    @move_y = 0
    @moving_x = 0
    @moving_y = 0
    @orbit = 0
    @orbit_plus = 0
    @orbit_time = 0
    @through = false
    @finish = false
    @time = 0
    @angle = 0
    @angling = 0
  end
  #--------------------------------------------------------------------------
  def anime_action(id,mirror,distanse_x,distanse_y,type,speed,orbit,weapon,icon_index,icon_weapon)
    @time = speed
    @moving_x = distanse_x / speed
    @moving_y = distanse_y / speed
    @through = true if type == 1
    @orbit_plus = orbit
    @orbit_time = @time
    if weapon != ""
      action = ANIME[weapon].dup
      @angle = action[0]
      end_angle = action[1]
      time = action[2]
      @angling = (end_angle - @angle)/ time
      self.angle = @angle
      self.mirror = mirror
      if icon_weapon
        self.bitmap = RPG::Cache.icon(icon_index)
        self.ox = 12
        self.oy = 12
      else 
        self.bitmap = RPG::Cache.character(icon_index, 0)
        self.ox = self.bitmap.width / 2
        self.oy = self.bitmap.height / 2
      end  
      self.visible = true
      self.z = 1000
    end  
    self.x = @base_x + @move_x
    self.y = @base_y + @move_y + @orbit
    if id != 0 && !icon_weapon
      animation($data_animations[id],true)
    elsif id != 0 && icon_weapon
      loop_animation($data_animations[id])
    end
  end  
  #--------------------------------------------------------------------------  
  def action_reset
    @moving_x = @moving_y = @move_x = @move_y = @base_x = @base_y = @orbit = 0
    @orbit_time = @angling = @angle = 0    
    @through = self.visible = @finish = false
    dispose_animation
  end   
  #--------------------------------------------------------------------------
  def finish?
    return @finish
  end 
  #--------------------------------------------------------------------------
  def update
    super
    @time -= 1
    if @time >= 0
      @move_x += @moving_x
      @move_y += @moving_y
      if @time < @orbit_time / 2
        @orbit_plus = @orbit_plus * 5 / 4
      elsif @time == @orbit_time / 2
        @orbit_plus *= -1
      else
        @orbit_plus = @orbit_plus * 2 / 3
      end  
      @orbit += @orbit_plus
    end    
    @time = 100 if @time < 0 && @through
    @finish = true if @time < 0 && !@through
    self.x = @base_x + @move_x
    self.y = @base_y + @move_y + @orbit
    if self.x < -200 or self.x > 840 or self.y < -200 or self.y > 680
      @finish = true
    end
    if self.visible
      @angle += @angling
      self.angle = @angle
    end  
  end
end

#==============================================================================
# ■ Sprite_Weapon
#==============================================================================
class Sprite_Weapon < RPG::Sprite
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :battler
  #--------------------------------------------------------------------------
  def initialize(viewport,battler = nil)
    super(viewport)
    @battler = battler
    @action = []
    @move_x = 0
    @move_y = 0
    @move_z = 0
    @plus_x = 0
    @plus_y = 0
    @angle = 0
    @zoom_x = 1
    @zoom_y = 1
    @moving_x = 0
    @moving_y = 0
    @angling = 0
    @zooming_x = 1
    @zooming_y = 1
    @freeze = -1
    @mirroring = false
    @time = ANIME_PATTERN + 1
    weapon_graphics 
  end
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose if self.bitmap != nil
    super
  end
  #--------------------------------------------------------------------------
  def weapon_graphics(left = false)
    if @battler.actor?
      weapon = @battler.weapons[0] unless left
      weapon = @battler.weapons[1] if left
    else
      weapon = $data_weapons[@battler.weapon]
      @mirroring = true if @battler.action_mirror
    end
    return if weapon == nil
    if weapon.graphic == ""
      self.bitmap = RPG::Cache.icon(weapon.icon_name)
      @weapon_width = @weapon_height = 24
    else
      self.bitmap = RPG::Cache.icon(weapon.graphic)
      @weapon_width = self.bitmap.width
      @weapon_height = self.bitmap.height
    end
  end
  #--------------------------------------------------------------------------
  def freeze(action)
    @freeze = action
  end
  #--------------------------------------------------------------------------
  def weapon_action(action,loop)
    if action == ""
      self.visible = false
    elsif @weapon_id == 0
      self.visible = false
    else
      @action = ANIME[action]
      act0 = @action[0]
      act1 = @action[1]
      act2 = @action[2]
      act3 = @action[3]
      act4 = @action[4]
      act5 = @action[5]
      act6 = @action[6]
      act7 = @action[7]
      act8 = @action[8]
      act9 = @action[9]
      act10 = @action[10]
      if @mirroring
        act0 *= -1
        act3 *= -1
        act4 *= -1
        act9 *= -1
      end
      if $back_attack && BACK_ATTACK
        act0 *= -1
        act3 *= -1
        act4 *= -1
        act9 *= -1
      end
      time = ANIME_PATTERN 
      if act2
        self.z = @battler.position_z + 1
      else
        self.z = @battler.position_z - 1
      end
      if act6
        if self.mirror
          self.mirror = false
        else
          self.mirror = true
        end
      end
      if @mirroring
        if self.mirror
          self.mirror = false
        else
          self.mirror = true
        end
      end 
      if $back_attack && BACK_ATTACK
        if self.mirror
          self.mirror = false
        else
          self.mirror = true
        end
      end  
      @moving_x = act0 / time
      @moving_y = act1 / time
      @angle = act3
      self.angle = @angle
      @angling = (act4 - act3)/ time
      @angle += (act4 - act3) % time
      @zooming_x = (1 - act7) / time
      @zooming_y = (1 - act8) / time
      if self.mirror
        case act5
        when 1
          act5 = 2
        when 2
          act5 = 1
        when 3
          act5 = 4
        when 4
          act5 = 3
        end  
      end    
      case act5
      when 0
        self.ox = @weapon_width / 2
        self.oy = @weapon_height / 2
      when 1
        self.ox = 0
        self.oy = 0
      when 2
        self.ox = @weapon_width
        self.oy = 0
      when 3
        self.ox = 0
        self.oy = @weapon_height
      when 4
        self.ox = @weapon_width
        self.oy = @weapon_height
      end  
      @plus_x = act9
      @plus_y = act10
      @loop = true if loop == 0
      @angle -= @angling
      @zoom_x -= @zooming_x
      @zoom_y -= @zooming_y
      @move_x -= @moving_x
      @move_y -= @moving_y 
      @move_z = 1000 if act2
      if @freeze != -1
        for i in 0..@freeze + 1
          @angle += @angling
          @zoom_x += @zooming_x
          @zoom_y += @zooming_y
          @move_x += @moving_x
          @move_y += @moving_y 
        end
        @angling = 0
        @zooming_x = 0
        @zooming_y = 0
        @moving_x = 0
        @moving_y = 0
      end 
      self.visible = true
    end 
  end  
  #--------------------------------------------------------------------------
  def action_reset
    @moving_x = @moving_y = @move_x = @move_y = @plus_x = @plus_y = 0
    @angling = @zooming_x = @zooming_y = @angle = self.angle = @move_z = 0
    @zoom_x = @zoom_y = self.zoom_x = self.zoom_y = 1
    self.mirror = self.visible = @loop = false
    @freeze = -1
    @action = []
    @time = ANIME_PATTERN + 1
  end 
  #--------------------------------------------------------------------------
  def action_loop
    @angling *= -1
    @zooming_x *= -1
    @zooming_y *= -1
    @moving_x *= -1
    @moving_y *= -1
  end  
  #--------------------------------------------------------------------------
  def mirroring 
    return @mirroring = false if @mirroring
    @mirroring = true
  end  
  #--------------------------------------------------------------------------
  def action
    return if @time <= 0
    @time -= 1
    @angle += @angling
    @zoom_x += @zooming_x
    @zoom_y += @zooming_y
    @move_x += @moving_x
    @move_y += @moving_y 
    if @loop && @time == 0
      @time = ANIME_PATTERN + 1
      action_loop
    end 
  end  
  #--------------------------------------------------------------------------
  def update
    super
    self.angle = @angle
    self.zoom_x = @zoom_x
    self.zoom_y = @zoom_y
    self.x = @battler.position_x + @move_x + @plus_x
    self.y = @battler.position_y + @move_y + @plus_y
    self.z = @battler.position_z + @move_z - 1
  end
end

#==============================================================================
# Game_Party
#==============================================================================
class Game_Party
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    actor = $game_actors[actor_id]
    if @actors.size < MAX_MEMBER and not @actors.include?(actor)
      @actors.push(actor)
      $game_player.refresh
    end
  end
end

#==============================================================================
# ■ RPG::Weapon
#==============================================================================
class RPG::Weapon
  #--------------------------------------------------------------------------
  def magic?
    return false
  end
end

#==============================================================================
# ■ RPG::Skill
#==============================================================================
class RPG::Skill
  #--------------------------------------------------------------------------
  def magic?
    return @atk_f == 0 ? true : false
  end
end

#==============================================================================
# ■ RPG::Item
#==============================================================================
class RPG::Item
  #--------------------------------------------------------------------------
  def magic?
    return false
  end
end

#==============================================================================
# ■ RPG::Cache
#==============================================================================
module RPG::Cache
  def self.faces(filename, hue = 0)
    self.load_bitmap('Graphics/Faces/', filename, hue)
  end
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :sp_damage
  attr_accessor :collapse
  attr_accessor :move_x
  attr_accessor :move_y
  attr_accessor :move_z
  attr_accessor :jump
  attr_accessor :active
  attr_accessor :non_dead
  attr_accessor :slip_damage
  attr_accessor :derivation
  attr_accessor :individual
  attr_accessor :play
  attr_accessor :force_action
  attr_accessor :force_target
  attr_accessor :revival
  attr_accessor :reflex
  attr_accessor :absorb
  attr_accessor :anime_mirror
  attr_accessor :dying
  attr_accessor :state_animation_id
  attr_accessor :dead_anim
  attr_accessor :missed
  attr_accessor :evaded
  attr_accessor :true_immortal
  attr_accessor :defense_pose
  attr_reader   :base_position_x
  attr_reader   :base_position_y  
  attr_reader   :base_height  
  #--------------------------------------------------------------------------
  alias initialize_n01 initialize
  def initialize
    initialize_n01
    @move_x = @move_y = @move_z = @plus_y = @jump = @derivation = @act_time = 0
    @force_action = @force_target = @base_position_x = @base_position_y = 0
    @absorb = @play = @now_state = @state_frame = @state_animation_id = 0
    @active = @non_dead = @individual = @slip_damage = @revival = false
    @collapse = @sp_damage = @anime_mirror = @dying = false
    @evaded = @missed = false
    @anim_states = []
  end 
  #--------------------------------------------------------------------------
  def state_id
    return @states[@states.size - 1]
  end
  #--------------------------------------------------------------------------
  def in_danger
    return @hp <= self.maxhp / 4
  end
  #--------------------------------------------------------------------------
  def battler_states
    bat_states = []
    for i in self.states
      bat_states.push($data_states[i])
    end
    return bat_states
  end
  #--------------------------------------------------------------------------
  def apply_variance(damage, variance)
    if damage != 0
      amp = [damage.abs * variance / 100, 0].max
      damage += rand(amp+1) + rand(amp+1) - amp
    end
    return damage
  end
  #--------------------------------------------------------------------------
  def state_animation_id
    return 0 if @states.empty?
    return 0 if @states.include?(1)
    @state_frame -= 1 if @state_frame > 0
    return @state_animation_id if @state_frame > 0
    if @anim_states.empty?
      for state in @states
        @anim_states << state if $data_states[state].animation_id > 0
      end
    end
    now_state = @anim_states.shift
    return 0 if now_state.nil?
    @state_animation_id = $data_states[now_state].animation_id
    return 0 if $data_animations[@state_animation_id].nil?
    @state_frame = $data_animations[@state_animation_id].frame_max * STATE_CYCLE_TIME * 2
    return @state_animation_id
  end
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    skill = $data_skills[skill_id]
    if skill.extension.include?("CONSUMEHP")
      return false if calc_sp_cost(self, skill) >= self.hp
    else  
      return false if calc_sp_cost(self, skill) > self.sp
    end
    return false if dead?
    return false if skill.atk_f == 0 and self.restriction == 1
    occasion = skill.occasion
    return (occasion == 0 or occasion == 1) if $game_temp.in_battle
    return (occasion == 0 or occasion == 2)
  end  
  #--------------------------------------------------------------------------
  def calc_sp_cost(user, skill)
    cost = skill.sp_cost
    if skill.extension.include?("%COSTMAX")
      return user.maxhp * cost / 100 if skill.extension.include?("CONSUMEHP")
      return user.maxsp * cost / 100
    elsif skill.extension.include?("%COSTNOW")
      return user.hp * cost / 100 if skill.extension.include?("CONSUMEHP")
      return user.sp * cost / 100
    end
    return cost
  end 
  #--------------------------------------------------------------------------
  def consum_skill_cost(skill)
    return false unless skill_can_use?(skill.id)
    cost = calc_sp_cost(self, skill)
    return self.hp -= cost if skill.extension.include?("CONSUMEHP")
    return self.sp -= cost
  end 
  #--------------------------------------------------------------------------
  def attack_effect(attacker)
    self.critical = @evaded = @missed = false
    hit_result = (rand(100) < attacker.hit)
    set_attack_result(attacker) if hit_result
    weapon = attacker.actor? ? $data_weapons[attacker.weapon_id] : nil
    if hit_result
      set_attack_state_change(attacker)
    else
      self.critical = false
      @missed = true
    end
    self.damage = POP_EVA if @evaded
    self.damage = POP_MISS if @missed
    return true
  end
  #--------------------------------------------------------------------------
  def perfect_attack_effect(attacker)
    self.critical = @evaded = @missed = false
    set_attack_result(attacker)
    weapon = attacker.actor? ? $data_weapons[attacker.weapon_id] : nil
    set_attack_state_change(attacker)
    return true
  end
  #--------------------------------------------------------------------------
  def set_attack_result(attacker)
    set_attack_damage_value(attacker)
    if self.damage > 0
      self.damage /= 2 if self.guarding?
      set_attack_critical(attacker)
      set_critical_damage(attacker) if self.critical
    end
    apply_variance(15) if self.damage.abs > 0
    set_attack_hit_value(attacker)
  end
  #--------------------------------------------------------------------------
  def set_attack_damage_value(attacker)
    case DAMAGE_ALGORITHM_TYPE
    when 0
      atk = [attacker.atk - (self.pdef / 2), 0].max
      str = [20 + attacker.str, 0].max
    when 1
      atk = [attacker.atk - ((attacker.atk * self.pdef) / 1000), 0].max
      str = [20 + attacker.str, 0].max
    when 2
      atk = 20
      str = [(attacker.str * 4) - (self.dex * 2) , 0].max
    when 3
      atk = [(10 + attacker.atk) - (self.pdef / 2), 0].max
      str = [(20 + attacker.str) - (self.dex / 2), 0].max
    end
    self.damage = atk * str / 20
    self.damage = 1 if self.damage == 0 and (rand(100) > 40)
    self.damage *= elements_correct(attacker.element_set)
    self.damage /= 100
  end
  #--------------------------------------------------------------------------
  def apply_variance(variance)
    amp = [self.damage.abs * variance / 100, 1].max
    self.damage += rand(amp + 1) + rand(amp + 1) - amp
  end
  #--------------------------------------------------------------------------
  def set_attack_hit_value(attacker)
    atk_hit = DAMAGE_ALGORITHM_TYPE > 1 ? attacker.agi : attacker.dex
    eva = (8 * self.agi / atk_hit) + self.eva
    hit = self.damage < 0 ? 100 : 100 - eva
    hit = self.cant_evade? ? 100 : hit
    hit_result = (rand(100) < hit)
    @evaded = true unless hit_result
  end
  #--------------------------------------------------------------------------
  def set_attack_critical(attacker)
    atk_crt = DAMAGE_ALGORITHM_TYPE > 1 ? attacker.agi : attacker.dex
    self.critical = rand(100) < 5 * atk_crt / self.agi
  end
  #--------------------------------------------------------------------------
  def set_critical_damage(attacker)
    self.damage += self.damage
  end
  #--------------------------------------------------------------------------
  def set_attack_state_change(attacker)
    remove_states_shock
    effective = apply_damage(attacker)
    @state_changed = false
    states_plus(attacker.plus_state_set)
    states_minus(attacker.minus_state_set)
    return effective
  end
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    self.critical = @evaded = @missed = false
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      return false
    end
    effective = false
    effective |= skill.common_event_id > 0
    hit = skill.hit
    hit *= set_skill_hit(user, skill)
    hit_result = (rand(100) < hit)
    effective |= hit < 100
    effective |= set_skill_result(user, skill, effective) if hit_result
    if hit_result
      effective |= set_skill_state_change(user, skill, effective)
    else
      @missed = true unless @evaded
    end
    self.damage = nil unless $game_temp.in_battle
    self.damage = POP_EVA if @evaded
    self.damage = POP_MISS if @missed
    return effective
  end
  #--------------------------------------------------------------------------
  def perfect_skill_effect(user, skill)
    self.critical = @evaded = @missed = false
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      return false
    end
    effective = false
    effective |= skill.common_event_id > 0
    effective |= set_skill_result(user, skill, effective)
    effective |= set_skill_state_change(user, skill, effective)
    self.damage = nil unless $game_temp.in_battle
    return effective
  end
  #--------------------------------------------------------------------------
  def set_skill_hit(user, skill)
    if skill.magic?
      return 1
    else
      return user.hit / 100
    end
  end
  #--------------------------------------------------------------------------
  def set_skill_result(user, skill, effective)
    set_skill_damage_value(user, skill)
    if self.damage > 0 
      self.damage /= 2 if self.guarding?
    end
    apply_variance(skill.variance) if skill.variance > 0 and self.damage.abs > 0
    effective |= set_skill_hit_value(user, skill, effective)
    return effective
  end
  #--------------------------------------------------------------------------
  def set_skill_damage_value(user, skill)
    power = set_skill_power(user, skill)
    if power > 0
      case DAMAGE_ALGORITHM_TYPE
      when 0,3
        power -= (self.pdef * skill.pdef_f) / 200
        power -= (self.mdef * skill.mdef_f) / 200
      when 1
        power -= (power * (self.pdef * skill.pdef_f)) / 100000
        power -= (power * (self.mdef * skill.mdef_f)) / 100000
      when 2
        power -= ((self.dex * 2 * skill.pdef_f) / 100)
        power -= ((self.int * 1 * skill.mdef_f) / 100)
      end
      power = [power, 0].max
    end
    rate = set_skill_rate(user, skill) unless DAMAGE_ALGORITHM_TYPE == 2
    rate = [rate, 0].max
    self.damage = power * rate / 20
    self.damage *= elements_correct(skill.element_set)
    self.damage /= 100
  end
  #--------------------------------------------------------------------------
  def set_skill_power(user, skill)
    case DAMAGE_ALGORITHM_TYPE
    when 0,1,3
      power = skill.power + ((user.atk * skill.atk_f) / 100)
    when 2
      user_str = (user.str * 4 * skill.str_f / 100)
      user_int = (user.int * 2 * skill.int_f / 100)
      if skill.power > 0
        power = skill.power + user_str + user_int
      else
        power = skill.power - user_str - user_int
      end
    end
    return power
  end
  #--------------------------------------------------------------------------
  def set_skill_rate(user, skill)
    case DAMAGE_ALGORITHM_TYPE
    when 0,1,2
      rate = 20
    when 3
      rate = 40
      rate -= (self.dex / 2 * skill.pdef_f / 200)
      rate -= ((self.dex + self.int)/ 4 * skill.mdef_f / 200)
    end
    rate += (user.str * skill.str_f / 100)
    rate += (user.dex * skill.dex_f / 100)
    rate += (user.agi * skill.agi_f / 100)
    rate += (user.int * skill.int_f / 100)
    return rate
  end
  #--------------------------------------------------------------------------
  def set_skill_hit_value(user, skill, effective)
    atk_hit = DAMAGE_ALGORITHM_TYPE > 1 ? user.agi : user.dex
    eva = 8 * self.agi / atk_hit + self.eva
    hit = self.damage < 0 ? 100 : 100 - eva * skill.eva_f / 100
    hit = self.cant_evade? ? 100 : hit
    hit_result = (rand(100) < hit)
    @evaded = true unless hit_result
    effective |= hit < 100
    return effective
  end
  #--------------------------------------------------------------------------
  def set_skill_state_change(user, skill, effective = false)
    if skill.power != 0 and not skill.magic?
      remove_states_shock
      effective = true
    end
    effective |= apply_damage(user)
    @state_changed = false
    effective |= states_plus(skill.plus_state_set)
    effective |= states_minus(skill.minus_state_set)
    if skill.power == 0
      self.damage = ""
      @missed = true unless @state_changed
    end
    return effective
  end
  #--------------------------------------------------------------------------
  def apply_damage(user)
    return true if @evaded or @missed or not self.damage.is_a?(Numeric)
    if self.sp_damage
      last_sp = self.sp 
      self.sp -= self.damage
      effective = self.sp != last_sp
    else
      last_hp = self.hp 
      self.hp -= self.damage
      effective = self.hp != last_hp
    end
    return effective
  end
  #--------------------------------------------------------------------------
  def item_effect(item)
    self.critical = @evaded = @missed = false
    if ((item.scope == 3 or item.scope == 4) and self.hp == 0) or
       ((item.scope == 5 or item.scope == 6) and self.hp >= 1)
      return false
    end
    effective = false
    effective |= item.common_event_id > 0
    hit_result = (rand(100) < item.hit)
    @missed = true unless hit_result
    effective |= item.hit < 100
    if hit_result == true
      effective |= make_item_damage_value(item)
    else
      @missed = true
    end
    self.damage = nil unless $game_temp.in_battle
    self.damage = POP_MISS if @missed
    return effective
  end
  #--------------------------------------------------------------------------
  def perfect_item_effect(item)
    self.critical = @evaded = @missed = false
    if ((item.scope == 3 or item.scope == 4) and self.hp == 0) or
       ((item.scope == 5 or item.scope == 6) and self.hp >= 1)
      return false
    end
    effective = false
    effective |= item.common_event_id > 0
    effective |= item.hit < 100
    effective |= make_item_damage_value(item)
    self.damage = nil unless $game_temp.in_battle
    self.damage = POP_MISS if @missed
    return effective
  end
  #--------------------------------------------------------------------------
  def make_item_damage_value(item)
    recover_hp = maxhp * item.recover_hp_rate / 100 + item.recover_hp
    recover_sp = maxsp * item.recover_sp_rate / 100 + item.recover_sp
    if recover_hp < 0
      recover_hp += self.pdef * item.pdef_f / 20
      recover_hp += self.mdef * item.mdef_f / 20
      recover_hp = [recover_hp, 0].min
    end
    recover_hp *= elements_correct(item.element_set)
    recover_hp /= 100
    recover_sp *= elements_correct(item.element_set)
    recover_sp /= 100
    if item.variance > 0 and recover_hp.abs > 0
      amp = [recover_hp.abs * item.variance / 100, 1].max
      recover_hp += rand(amp+1) + rand(amp+1) - amp
    end
    if item.variance > 0 and recover_sp.abs > 0
      amp = [recover_sp.abs * item.variance / 100, 1].max
      recover_sp += rand(amp+1) + rand(amp+1) - amp
    end
    recover_hp /= 2 if recover_hp < 0 and self.guarding?
    self.damage = -recover_hp 
    last_hp = self.hp
    last_sp = self.sp
    self.hp += recover_hp
    self.sp += recover_sp
    effective |= self.hp != last_hp
    effective |= self.sp != last_sp
    @state_changed = false
    effective |= states_plus(item.plus_state_set)
    effective |= states_minus(item.minus_state_set)
    if item.parameter_type > 0 and item.parameter_points != 0
      case item.parameter_type
      when 1
        @maxhp_plus += item.parameter_points
      when 2
        @maxsp_plus += item.parameter_points
      when 3
        @str_plus += item.parameter_points
      when 4
        @dex_plus += item.parameter_points
      when 5
        @agi_plus += item.parameter_points
      when 6
        @int_plus += item.parameter_points
      end
      effective = true
    end
    if item.recover_hp_rate == 0 and item.recover_hp == 0
      self.damage = ""
      if item.recover_sp_rate == 0 and item.recover_sp == 0 and
         (item.parameter_type == 0 or item.parameter_points == 0)
        unless @state_changed
          @missed = true
        end
      end
    end
    return effective
  end
  #--------------------------------------------------------------------------
  alias skill_effect_n01 skill_effect
  def skill_effect(user, skill)
    now_hp = self.hp
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      return false
    end
    effective = skill_effect_n01(user, skill)
    return if effective == false
    check_extension(skill)
    if @ratio_maxdamage != nil
      self.damage = self.maxhp * @ratio_maxdamage / 100 unless @sp_damage
      self.damage = self.maxsp * @ratio_maxdamage / 100 if @sp_damage
    end
    if @ratio_nowdamage != nil
      self.damage = self.hp * @ratio_nowdamage / 100 unless @sp_damage
      self.damage = self.sp * @ratio_nowdamage / 100 if @sp_damage
    end
    if @cost_damage
      cost = calc_sp_cost(user, skill)
      if skill.extension.include?("CONSUMEHP")
        self.damage = self.damage * cost / user.maxhp
      else
        self.damage = self.damage * cost / user.maxsp
      end  
    end 
    self.damage = self.damage * user.hp / user.maxhp if @nowhp_damage
    self.damage = self.damage * user.sp / user.maxsp if @nowsp_damage
    if @sp_damage 
      self.hp = now_hp
      self.sp -= self.damage
    elsif @extension
      self.hp = now_hp
      self.hp -= self.damage
    end
    return true
  end
  #--------------------------------------------------------------------------
  alias perfect_skill_effect_n01 perfect_skill_effect
  def perfect_skill_effect(user, skill)
    now_hp = self.hp
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      return false
    end
    effective = perfect_skill_effect_n01(user, skill)
    return if effective == false
    check_extension(skill)
    if @ratio_maxdamage != nil
      self.damage = self.maxhp * @ratio_maxdamage / 100 unless @sp_damage
      self.damage = self.maxsp * @ratio_maxdamage / 100 if @sp_damage
    end
    if @ratio_nowdamage != nil
      self.damage = self.hp * @ratio_nowdamage / 100 unless @sp_damage
      self.damage = self.sp * @ratio_nowdamage / 100 if @sp_damage
    end
    if @cost_damage
      cost = calc_sp_cost(user, skill)
      if skill.extension.include?("CONSUMEHP")
        self.damage = self.damage * cost / user.maxhp
      else
        self.damage = self.damage * cost / user.maxsp
      end  
    end 
    self.damage = self.damage * user.hp / user.maxhp if @nowhp_damage
    self.damage = self.damage * user.sp / user.maxsp if @nowsp_damage
    if @sp_damage 
      self.hp = now_hp
      self.sp -= self.damage
    elsif @extension
      self.hp = now_hp
      self.hp -= self.damage
    end
    return true
  end
  #--------------------------------------------------------------------------
  def check_extension(skill)
    @extension = false
    @sp_damage = false
    @cost_damage = false
    @nowhp_damage = false
    @nowsp_damage = false
    @ratio_maxdamage = nil
    @ratio_nowdamage = nil
    for ext in skill.extension
      break if self.damage == "Errou!" or self.damage == "" or self.damage == 0
      if ext == "SPDAMAGE"
        next @sp_damage = true
      elsif ext == "COSTPOWER"  
        @extension = true
        next @cost_damage = true 
      elsif ext == "HPNOWPOWER"
        @extension = true
        next @nowhp_damage = true 
      elsif ext == "MPNOWPOWER"
        @extension = true
        next @nowsp_damage = true
      else
        name = ext.split('')
        if name[7] == "M"
          name = name.join
          name.slice!("%DAMAGEMAX/")
          @extension = true
          next @ratio_maxdamage = name.to_i
        elsif name[7] == "N"
          name = name.join
          name.slice!("%DAMAGENOW/")
          @extension = true
          next @ratio_nowdamage = name.to_i
        end  
      end
    end  
  end
  #--------------------------------------------------------------------------
  def change_base_position(x, y)
    @base_position_x = x
    @base_position_y = y
  end
  #--------------------------------------------------------------------------
  def reset_coordinate
    @move_x = @move_y = @move_z = @jump = @derivation = 0
    @active = @non_dead = @individual = false    
  end
end  

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  attr_reader   :armor5_id
  attr_reader   :armor6_id
  attr_reader   :armor7_id
  attr_accessor :actor_height
  attr_accessor :two_swords_change
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def actor?
    return true
  end
  #--------------------------------------------------------------------------
  def weapons
    return [$data_weapons[@weapon_id]]
  end
  #--------------------------------------------------------------------------
  def armors
    result = []
    result << $data_armors[@armor1_id]
    result << $data_armors[@armor2_id]
    result << $data_armors[@armor3_id]
    result << $data_armors[@armor4_id]
    return result
  end
  #--------------------------------------------------------------------------
  def equips
    return weapons + armors
  end
  #--------------------------------------------------------------------------
  def skill_id_learn?(skill_id)
    return @skills.include?(skill_id)
  end
  #-------------------------------------------------------------------------- 
  def exp=(exp)
    @exp = [exp, 0].max
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      for j in $data_classes[@class_id].learnings
        if j.level == @level
          learn_skill(j.skill_id)
        end
      end
    end
    while @exp < @exp_list[@level]
      @level -= 1
    end
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #-------------------------------------------------------------------------- 
  def base_atk
    n = 0
    for item in weapons.compact do n += item.atk end
    n = UNARMED_ATTACK if weapons[0] == nil and weapons[1] == nil 
    return n
  end
  #-------------------------------------------------------------------------- 
  def base_pdef
    n = 0
    for item in equips.compact do n += item.pdef end
    return n
  end
  #-------------------------------------------------------------------------- 
  def base_mdef
    n = 0
    for item in equips.compact do n += item.mdef end
    return n
  end
  #-------------------------------------------------------------------------- 
  def base_eva
    n = 0
    for item in armors.compact do n += item.eva end
    return n
  end
  #-------------------------------------------------------------------------- 
  def graphic_change(character_name)
    @character_name = character_name
  end
  #--------------------------------------------------------------------------
  def perform_collapse
    $game_system.se_play($data_system.actor_collapse_se) if $game_temp.in_battle and dead? 
  end
  #--------------------------------------------------------------------------
  def base_position
    base = ACTOR_POSITION[self.index]
    @base_position_x = base[0]
    @base_position_y = base[1]
    @base_position_x = 640 - base[0] if $back_attack and BACK_ATTACK_MIRROR
  end
  #--------------------------------------------------------------------------
  def actor_height
    @base_height = 0 if CURSOR_TYPE != 1 
    @base_height = 72 if CURSOR_TYPE == 1
    return @base_height
  end
  #--------------------------------------------------------------------------
  def position_x
    return 0 if self.index == nil
    return @base_position_x + @move_x
  end
  #--------------------------------------------------------------------------
  def position_y
    return 0 if self.index == nil
    return @base_position_y + @move_y + @jump
  end
  #--------------------------------------------------------------------------
  def position_z
    return 0 if self.index == nil
    return position_y + @move_z - @jump + 200
  end  
end

#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :adj_speed
  attr_accessor :act_time
  #--------------------------------------------------------------------------
  def actor?
    return false
  end
  #--------------------------------------------------------------------------
  def make_action_speed2(adj)
    @adj_speed = @current_action.speed if @adj_speed == nil
    @adj_speed = @adj_speed * adj / 100
  end
  #--------------------------------------------------------------------------
  def perform_collapse
    @force_action = ["N01collapse"] if $game_temp.in_battle and dead?
  end
  #--------------------------------------------------------------------------
  def element_set2
    return []
  end
  #--------------------------------------------------------------------------
  def base_position
    return if self.index == nil
    bitmap = Bitmap.new("Graphics/Battlers/" + @battler_name) if !self.anime_on
    bitmap = Bitmap.new("Graphics/Characters/" + @battler_name) if self.anime_on && WALK_ANIME
    bitmap = Bitmap.new("Graphics/Characters/" + @battler_name + "_1") if self.anime_on && !WALK_ANIME
    height = bitmap.height
    @base_position_x = self.screen_x + self.position_plus[0]
    @base_position_y = self.screen_y + self.position_plus[1] - height / 3 + 32
    @base_position_x = 640 - self.screen_x - self.position_plus[0] if $back_attack and BACK_ATTACK_MIRROR
    @base_height = 0 if CURSOR_TYPE == 0
    @base_height = height / 3 + 64 if CURSOR_TYPE == 1 if !self.anime_on
    @base_height = height /12 + 64 if CURSOR_TYPE == 1 if self.anime_on
    @base_height = -(height / 3) if CURSOR_TYPE == 2 if !self.anime_on
    @base_height = -(height /12) if CURSOR_TYPE == 2 if self.anime_on
    bitmap.dispose 
  end
  #--------------------------------------------------------------------------
  def enemy_height
    return @base_height
  end
  #--------------------------------------------------------------------------
  def position_x
    return @base_position_x - @move_x
  end
  #--------------------------------------------------------------------------
  def position_y
    return @base_position_y + @move_y + @jump
  end
  #--------------------------------------------------------------------------
  def position_z
    return position_y + @move_z - @jump + 200
  end
end

#==============================================================================
# Arrow_Base
#==============================================================================
class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def update_multi_arrow
    return if @arrows == nil or @arrows == []
    for i in 0...@arrows.size
      @blink_count = (@blink_count + 1) % 40 
      if @blink_count < 20
        @arrows[i].src_rect.set(128, 96, 32, 32) if @arrows[i] != nil
      else
        @arrows[i].src_rect.set(160, 96, 32, 32) if @arrows[i] != nil
      end
    end
  end
  #--------------------------------------------------------------------------
  def dispose_multi_arrow
    for i in 0...@arrows.size
      @arrows[i].dispose if @arrows[i] != nil
    end
  end
end

#==============================================================================
# Arrow_Enemy_All
#==============================================================================
class Arrow_Enemy_All < Arrow_Base
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    @arrows = []
    for battler in $game_troop.enemies
      if battler.exist?
        @arrows[battler.index] = Arrow_Enemy.new(viewport)
        @arrows[battler.index].index = battler.index
      end
    end
  end
  #--------------------------------------------------------------------------
  def update_multi_arrow
    super
    for i in 0...@arrows.size
      enemy = $game_troop.enemies[i] 
      if enemy  != nil && @arrows[i] != nil && @arrows[i].enemy != nil
        @arrows[i].x = @arrows[i].enemy.position_x + CURSOR_POSITION[0]
        @arrows[i].y = @arrows[i].enemy.position_y + CURSOR_POSITION[1] + enemy.enemy_height
      end
    end
  end
end

#==============================================================================
# Arrow_Actor_All
#==============================================================================
class Arrow_Actor_All < Arrow_Base
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    @arrows = []
    for battler in $game_party.actors
      if battler.exist?
        @arrows[battler.index] = Arrow_Actor.new(viewport)
        @arrows[battler.index].index = battler.index
      end
    end
  end
  #--------------------------------------------------------------------------
  def update_multi_arrow
    super
    for i in 0...@arrows.size
      actor = $game_party.actors[i]
      if actor  != nil && @arrows[i] != nil && @arrows[i].actor != nil
        @arrows[i].x = @arrows[i].actor.position_x + CURSOR_POSITION[0]
        @arrows[i].y = @arrows[i].actor.position_y + CURSOR_POSITION[1] + actor.actor_height
      end
    end
  end
end

#==============================================================================
# Arrow_Battler_All
#==============================================================================
class Arrow_Battler_All < Arrow_Base
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    @arrows = []
    s = 0
    for battler in $game_party.actors + $game_troop.enemies
      @arrows[s] = Arrow_Actor.new(viewport) if battler.actor?
      @arrows[s] = Arrow_Enemy.new(viewport) if battler.is_a?(Game_Enemy)
      @arrows[s].index = battler.index
      s += 1
    end
  end
  #--------------------------------------------------------------------------
  def update_multi_arrow
    super
    s = 0
    for i in 0...@arrows.size
      if @arrows[i].is_a?(Arrow_Actor)
        actor = $game_party.actors[i] 
        if @arrows[i].actor != nil
          @arrows[i].x = @arrows[i].actor.position_x + CURSOR_POSITION[0]
          @arrows[i].y = @arrows[i].actor.position_y + CURSOR_POSITION[1] + actor.actor_height
          s += 1
        end
      elsif @arrows[i].is_a?(Arrow_Enemy)
        enemy = $game_troop.enemies[i - s]
        if @arrows[i].enemy != nil or @arrows[i] != nil
          @arrows[i].x = @arrows[i].enemy.position_x + CURSOR_POSITION[0]
          @arrows[i].y = @arrows[i].enemy.position_y + CURSOR_POSITION[1] + enemy.enemy_height
        end
      end
    end
  end
end

#==============================================================================
# ■ Arrow_Enemy
#==============================================================================
class Arrow_Enemy < Arrow_Base
  #--------------------------------------------------------------------------
  def update
    super
    $game_troop.enemies.size.times do
      break if self.enemy.exist?
      @index += 1
      @index %= $game_troop.enemies.size
    end
    if Input.repeat?(Input::RIGHT)
      cursor_up if $back_attack
      cursor_down unless $back_attack
    end
    if Input.repeat?(Input::LEFT)
      cursor_up unless $back_attack
      cursor_down if $back_attack
    end
    if Input.repeat?(Input::UP)
      cursor_down
    end
    if Input.repeat?(Input::DOWN)
      cursor_up
    end
    if self.enemy != nil
      self.x = self.enemy.position_x + CURSOR_POSITION[0]
      self.y = self.enemy.position_y + CURSOR_POSITION[1] + enemy.enemy_height
    end
  end
  #--------------------------------------------------------------------------
  def cursor_up
    $game_system.se_play($data_system.cursor_se)
    $game_troop.enemies.size.times do
      @index += $game_troop.enemies.size - 1
      @index %= $game_troop.enemies.size
      break if self.enemy.exist?
    end
  end
  #--------------------------------------------------------------------------
  def cursor_down
    $game_system.se_play($data_system.cursor_se)
    $game_troop.enemies.size.times do
      @index += 1
      @index %= $game_troop.enemies.size
      break if self.enemy.exist?
    end
  end
end

#==============================================================================
# ■ Arrow_Actor
#==============================================================================
class Arrow_Actor < Arrow_Base
  #--------------------------------------------------------------------------
  def update
    super
    if Input.repeat?(Input::RIGHT)
      cursor_up if $back_attack
      cursor_down unless $back_attack
    end
    if Input.repeat?(Input::LEFT)
      cursor_up unless $back_attack
      cursor_down if $back_attack
    end
    if Input.repeat?(Input::UP)
      cursor_up
    end
    if Input.repeat?(Input::DOWN)
      cursor_down
    end
    if self.actor != nil
      self.x = self.actor.position_x + CURSOR_POSITION[0]
      self.y = self.actor.position_y + CURSOR_POSITION[1] + actor.actor_height
    end
  end
  #--------------------------------------------------------------------------
  def cursor_up
    $game_system.se_play($data_system.cursor_se)
    @index += $game_party.actors.size - 1
    @index %= $game_party.actors.size
  end
  #--------------------------------------------------------------------------
  def cursor_down
    $game_system.se_play($data_system.cursor_se)
    @index += 1
    @index %= $game_party.actors.size
  end
  #--------------------------------------------------------------------------
  def input_right
    @index += 1
    @index %= $game_party.actors.size
  end
  #--------------------------------------------------------------------------
  def input_update_target
    if Input.repeat?(Input::RIGHT)
      if @index == self.actor.index     
        cursor_up if $back_attack
        cursor_down unless $back_attack
      end
    end
    if Input.repeat?(Input::LEFT)
      if @index == self.actor.index
        cursor_up unless $back_attack
        cursor_down if $back_attack
      end
    end
    if Input.repeat?(Input::UP)
      cursor_up if @index == self.actor.index
    end
    if Input.repeat?(Input::DOWN)
      cursor_down if @index == self.actor.index
    end
    if self.actor != nil
      self.x = self.actor.screen_x
      self.y = self.actor.screen_y
    end
  end
end

#==============================================================================
# ■ Game_Troop
#==============================================================================
class Game_Troop
  def clear_actions
    for enemies in @enemies
      enemies.current_action.clear
    end
  end
end

#==============================================================================
# ■ Window_Command
#==============================================================================
class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  attr_accessor :commands
end

#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def draw_actor_state(actor, x, y, width = 0)
    status_icon = []
    for i in actor.states
      if $data_states[i].rating >= 1
        begin
          status_icon.push(RPG::Cache.icon($data_states[i].name + "_st"))
          break if status_icon.size > (Icon_max - 1)
        rescue
        end
      end
    end
    for icon in status_icon
      self.contents.blt(x + X_Adjust, y + Y_Adjust + 4, icon, Rect.new(0, 0, Icon_X, Icon_Y), 255)
      x += Icon_X + 2
    end
  end
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type)
    case type
    when 0
      parameter_name = $data_system.words.atk
      parameter_value = actor.atk
    when 1
      parameter_name = $data_system.words.pdef
      parameter_value = actor.pdef
    when 2
      parameter_name = $data_system.words.mdef
      parameter_value = actor.mdef
    when 3
      parameter_name = $data_system.words.str
      parameter_value = actor.str
    when 4
      parameter_name = (DAMAGE_ALGORITHM_TYPE == 0 ? STAT_VIT : $data_system.words.dex)
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = STAT_EVA
      parameter_value = actor.eva
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 120, y, 36, 32, parameter_value.to_s, 2)
  end
end

#==============================================================================
# ■ Window_Help
#==============================================================================
class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 2000 if $game_temp.in_battle
    self.back_opacity = HELP_OPACITY if $game_temp.in_battle
  end
  #--------------------------------------------------------------------------
  def set_text_update(text, align = 0)
    self.contents.clear
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 0, self.width - 40, 32, text, align)
    @text = text
    @align = align
    @actor = nil
    self.visible = true
  end
  #--------------------------------------------------------------------------
  def set_enemy(enemy)
    text = enemy.name
    set_text_update(text, 1)
    text_width = self.contents.text_size(text).width
    x = (text_width + self.width)/2
    status_icon = []
    for i in enemy.states
      if $data_states[i].rating >= 1
        begin
          status_icon.push(RPG::Cache.icon($data_states[i].name + "_st"))
          break if status_icon.size > (Icon_max - 1)
        rescue
        end
      end
    end
    for icon in status_icon
      self.contents.blt(x + X_Adjust, y + Y_Adjust + 4, icon, Rect.new(0, 0, Icon_X, Icon_Y), 255)
      x += Icon_X + 2
    end
  end
end

#==============================================================================
# ■ Window_Skill
#==============================================================================
class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 128, 640, 352)
    @actor = actor
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 320
      self.height = 160
      self.z = 2100
      self.back_opacity = MENU_OPACITY
    end
  end
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    cost = @actor.calc_sp_cost(@actor, skill)
    self.contents.draw_text(x + 232, y, 48, 32, cost.to_s, 2)
  end
end

#==============================================================================
# ■ Window_Item
#==============================================================================
class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 640, 416)
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 320
      self.height = 160
      self.z = 2100
      self.back_opacity = MENU_OPACITY
    end
  end
end

#==============================================================================
# ■ Window_PartyCommand
#==============================================================================
class Window_PartyCommand < Window_Selectable
  #--------------------------------------------------------------------------
  alias initialize_n01 initialize
  #--------------------------------------------------------------------------
  def initialize
    initialize_n01
    self.z = 2000
  end
end

#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    super(0, 320, 640, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    @level_up_flags = []
    for i in 0...$game_party.actors.size
      @level_up_flags.push(false)
    end
    self.z = 2000
    self.opacity = STATUS_OPACITY
    refresh
  end
  #--------------------------------------------------------------------------
  def update
    super
  end
end

#==============================================================================
# ■ Window_NameCommand
#==============================================================================
class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  def initialize(exp, gold, treasures)
    @exp = exp
    @gold = gold
    @treasures = treasures
    super(160, 0, 320, @treasures.size * 32 + 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.y = 160 - height / 2
    self.back_opacity = 160
    self.z = 2000
    self.visible = false
    refresh
  end
end

#==============================================================================
# ■ Window_NameCommand
#==============================================================================
class Window_NameCommand < Window_Base
  #--------------------------------------------------------------------------
  def initialize(actor, x, y)
    super(x, y, 160, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = Font.default_name
    self.z = 2000
    self.back_opacity = COMMAND_OPACITY
    refresh(actor)
  end
  #--------------------------------------------------------------------------
  def refresh(actor)
    self.contents.clear
    self.contents.font.color = normal_color
    self.contents.draw_text(0, 0, 128, 32, actor.name, 1) if actor != nil
  end
end

#==============================================================================
# ■ RPG::Sprite 
#==============================================================================
class RPG::Sprite < ::Sprite
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @_whiten_duration = 0
    @_appear_duration = 0
    @_escape_duration = 0
    @_collapse_duration = 0
    @_damage_duration = 0
    @_animation_duration = 0
    @_blink = false
    @_damage_durations = []
    @time = 0
  end
  #--------------------------------------------------------------------------
  def appear
  end
  #--------------------------------------------------------------------------
  def escape
  end
  #--------------------------------------------------------------------------
  def collapse
  end
  #--------------------------------------------------------------------------
  def damage(value, critical, sp_damage = nil)
    dispose_damage(0...@_damage_durations.size)
    @_damage_sprites = []
    if value.is_a?(Numeric)
      damage_string = value.abs.to_s
    else
      damage_string = value.to_s
    end
    @damage_size = 1 if !MULTI_POP
    @damage_size = damage_string.size if MULTI_POP
    for i in 0...@damage_size
      letter = damage_string[i..i] if MULTI_POP
      letter = damage_string if !MULTI_POP
      bitmap = Bitmap.new(160, 48)
      bitmap.font.name = DAMAGE_FONT
      bitmap.font.size = DMG_F_SIZE
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_text(-1, 12-1,160, 36, letter, 1)
      bitmap.draw_text(+1, 12-1,160, 36, letter, 1)
      bitmap.draw_text(-1, 12+1,160, 36, letter, 1)
      bitmap.draw_text(+1, 12+1,160, 36, letter, 1)
      if value.is_a?(Numeric) and value < 0
        bitmap.font.color.set(HP_REC_COLOR[0],HP_REC_COLOR[1],HP_REC_COLOR[2]) if !sp_damage
        bitmap.font.color.set(SP_REC_COLOR[0],SP_REC_COLOR[1],SP_REC_COLOR[2]) if sp_damage
      else
        bitmap.font.color.set(HP_DMG_COLOR[0],HP_DMG_COLOR[1],HP_DMG_COLOR[2]) if !sp_damage
        bitmap.font.color.set(SP_DMG_COLOR[0],SP_DMG_COLOR[1],SP_DMG_COLOR[2]) if sp_damage
        bitmap.font.color.set(CRT_DMG_COLOR[0],CRT_DMG_COLOR[1],CRT_DMG_COLOR[2]) if critical 
      end
      bitmap.draw_text(0, 12,160, 36, letter, 1)
      if critical and CRITIC_TEXT and i == 0
        x_pop = (MULTI_POP ? (damage_string.size - 1) * (DMG_SPACE / 2) : 0)
        bitmap.font.size = ((DMG_F_SIZE * 2) / 3).to_i
        bitmap.font.color.set(0, 0, 0)
        bitmap.draw_text(-1 + x_pop, -1, 160, 20, POP_CRI, 1)
        bitmap.draw_text(+1 + x_pop, -1, 160, 20, POP_CRI, 1)
        bitmap.draw_text(-1 + x_pop, +1, 160, 20, POP_CRI, 1)
        bitmap.draw_text(+1 + x_pop, +1, 160, 20, POP_CRI, 1)
        bitmap.font.color.set(CRT_TXT_COLOR[0],CRT_TXT_COLOR[1],CRT_TXT_COLOR[2]) if critical 
        bitmap.draw_text(0 + x_pop, 0, 160, 20, POP_CRI, 1)
      end
      if critical and CRITIC_FLASH
        $game_screen.start_flash(Color.new(255, 255, 255, 255),10)
      end
      @_damage_sprites[i] = ::Sprite.new(self.viewport)
      @_damage_sprites[i].bitmap = bitmap
      @_damage_sprites[i].ox = 80
      @_damage_sprites[i].oy = 20
      @_damage_sprites[i].x = self.x + i * DMG_SPACE
      @_damage_sprites[i].y = self.y - self.oy / 2
      @_damage_sprites[i].z = DMG_DURATION + 3000 + i * 2
    end
  end
  #--------------------------------------------------------------------------
  def dispose
    dispose_damage(0...@_damage_durations.size)
    dispose_animation
    dispose_loop_animation
    if @damage_sprites != nil
      for damage_sprite in @damage_sprites
        damage_sprite.dispose
      end
    end
    super
  end
  #--------------------------------------------------------------------------
  def update
    super
    @damage_sprites   = [] if @damage_sprites.nil?
    @damage_durations = [] if @damage_durations.nil?
    if @_damage_sprites != nil
      for sprite in @_damage_sprites 
        if sprite != nil and sprite.visible
          x = DMG_X_MOVE
          y = DMG_Y_MOVE
          d = sprite.z - 3000
          m = self.mirror
          @damage_sprites.push(Sprite_Damage.new(sprite, x, y, d, m))
          sprite.visible = false
        end
      end
    end
    for damage_sprite in @damage_sprites
      damage_sprite.update
    end
    for i in 0...@damage_sprites.size
      @damage_sprites[i] = nil if @damage_sprites[i].disposed?
    end
    @damage_sprites.compact!
    if @_whiten_duration > 0
      @_whiten_duration -= 1
      self.color.alpha = 128 - (16 - @_whiten_duration) * 10
    end
    if @_animation != nil and (Graphics.frame_count % 2 == 0)
      @_animation_duration -= 1
      update_animation
    end
    if @_loop_animation != nil and (Graphics.frame_count % 2 == 0)
      update_loop_animation
      @_loop_animation_index += 1
      @_loop_animation_index %= @_loop_animation.frame_max
    end
    if @_blink
      @_blink_count = (@_blink_count + 1) % 32
      if @_blink_count < 16
        alpha = (16 - @_blink_count) * 6
      else
        alpha = (@_blink_count - 16) * 6
      end
      self.color.set(255, 255, 255, alpha)
    end
    @@_animations.clear
  end
  #--------------------------------------------------------------------------
  def dispose_damage(index)
    return if @_damage_sprites == nil
    if @_damage_sprites[index].is_a?(::Sprite) and @_damage_sprites[index].bitmap != nil
      @_damage_sprites[index].bitmap.dispose
      @_damage_sprites[index].dispose
      @_damage_durations[index] = 0
    end
  end
  #--------------------------------------------------------------------------
  def dispose_animation
    if @_animation_sprites != nil
      sprite = @_animation_sprites[0]
      if sprite != nil
        @@_reference_count[sprite.bitmap] -= 1
        if @@_reference_count[sprite.bitmap] == 0
          sprite.bitmap.dispose
        end
      end
      for sprite in @_animation_sprites
        sprite.dispose
      end
      @_animation_sprites = nil
      @_animation = nil
    end
    @mirror = false
  end
  #--------------------------------------------------------------------------
  def animation_mirror(mirror_effect)
    @mirror = mirror_effect
  end
  #--------------------------------------------------------------------------
  def animation_set_sprites(sprites, cell_data, position)
    for i in 0..15
      sprite = sprites[i]
      pattern = cell_data[i, 0]
      if sprite == nil or pattern == nil or pattern == -1
        sprite.visible = false if sprite != nil
        next
      end
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
      if position == 3
        if self.viewport != nil
          sprite.x = self.viewport.rect.width / 2
          sprite.y = self.viewport.rect.height - 160
        else
          sprite.x = 320
          sprite.y = 240
        end
      else
        sprite.x = self.x - self.ox + self.src_rect.width / 2
        sprite.y = self.y - self.oy + self.src_rect.height / 2
        sprite.y -= self.src_rect.height / 4 if position == 0
        sprite.y += self.src_rect.height / 4 if position == 2
      end
      sprite.x += cell_data[i, 1]
      sprite.y += cell_data[i, 2]
      sprite.z = 2000
      if @mirror
        sprite.ox = 88
      else
        sprite.ox = 104
      end
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.angle = cell_data[i, 4]
      sprite.mirror = (cell_data[i, 5] == 1)
      if @mirror
        if sprite.mirror
          sprite.mirror = false
        else  
          sprite.mirror = true
        end
      end
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
end

#==============================================================================
# ■ Sprite_Damage
#==============================================================================
class Sprite_Damage < Sprite
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize(sprite, init_x_speed, init_y_speed, duration, mirror)
    super(nil)
    self.bitmap = sprite.bitmap.dup unless sprite.bitmap.nil?
    self.opacity = 255
    self.x = sprite.x
    self.y = sprite.y
    self.z = 3000
    self.ox = sprite.ox
    self.oy = sprite.oy
    @damage_mirror = mirror
    @now_x_speed = init_x_speed
    @now_y_speed = init_y_speed
    @potential_x_energy = 0.0
    @potential_y_energy = 0.0
    @duration = duration
  end
  #--------------------------------------------------------------------------
  def update
    @duration -= 1
    return unless @duration <= DMG_DURATION
    super
    n = self.oy + @now_y_speed
    if n <= 0
      @now_y_speed *= -1
      @now_y_speed /=  2
      @now_x_speed /=  2
    end
    self.oy  = [n, 0].max
    @potential_y_energy += DMG_GRAVITY
    speed = @potential_y_energy.floor
    @now_y_speed        -= speed
    @potential_y_energy -= speed
    @potential_x_energy += @now_x_speed if @damage_mirror if POP_MOVE
    @potential_x_energy -= @now_x_speed if !@damage_mirror if POP_MOVE
    speed = @potential_x_energy.floor
    self.ox             += speed
    @potential_x_energy -= speed
    case @duration
    when 1..10
      self.opacity -= 25
    when 0
      self.dispose
    end
  end
end