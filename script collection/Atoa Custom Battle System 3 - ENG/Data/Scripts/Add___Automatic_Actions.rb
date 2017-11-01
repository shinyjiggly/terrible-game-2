#==============================================================================
# Automatic Actions
# By Atoa
#==============================================================================
# This script allows you to set enemies and actors with automatic actions
#
# You can set various different strategies and change them with Script Calls
# 
# IMPORTANT: If you using the 'Atoa ATB' or 'Atoa CTB', put this script bellow them
#==============================================================================

module Atoa
  # Do not remove these lines
  Battle_Strategy = {}
  Enemy_Strategy = {}
  Enemy_Skills = {}
  # Do not remove these lines
  
  
  #----------------------------------------------------------------------
  # Default Strategies:
  # These strategy are always added to all actors and enemies (but remember
  # that they need to be activated to have any effect.
  #  Battle_Strategy[Name] = [Config]
  #  Name = Strategy Name
  #  Config = Strategy settings. Must be an array with numeric values that
  #    define the settings of the actions.
  #    You can add varios actions on the same setting.
  #   Battle_Strategy[Name]= [[Priority, Type, Condition, Target, Action ID],
  #                           [Priority, Type, Condition, Target, Action ID]]
  #
  # Priority = Action priority, numeric value. The higher is the vaule, the
  #            higher is the chance of this action being used, compared
  #            with other valid actions. 
  # Type = Type of the Action
  #   0 = Nothin
  #   2 = Defend
  #   1 = Attack
  #   3 = Skill
  #   4 = Item
  # Condition = Condition for use
  #   0 = None
  #   1 = Actor in Danger (HP rate lower than 'Danger_Value')
  #   2 = Actor not in Danger (HP rate higher than 'Danger_Value')
  #   3 = Actor with less than half HP
  #   4 = Actor with more than half HP
  #   5 = Actor with full HP
  #   6 = Actor with less than 25% SP
  #   7 = Actor with more than 25% SP
  #   8 = Actor with less than half SP
  #   9 = Actor with more than half SP
  #   10 = Actor with full SP
  #   11 = Actor with state (use only for actions that remove states)
  #   12 = Actor without state (use only for actions that cause states)
  #   13 = Ally in Danger (HP rate lower than 'Danger_Value')
  #   14 = Ally not in Danger (HP rate higher than 'Danger_Value')
  #   15 = Ally with less than half HP
  #   16 = Ally with more than half HP
  #   17 = Ally with full HP
  #   18 = Ally with less than 25% SP
  #   19 = Ally with more than 25% SP
  #   20 = Ally with less than half SP
  #   21 = Ally with more than half SP
  #   22 = Ally with full SP
  #   23 = Ally with state (use only for actions that remove states)
  #   24 = Ally without state (use only for actions that cause states)
  #   25 = Enemy in Danger (HP rate lower than 'Danger_Value')
  #   26 = Enemy not in Danger (HP rate higher than 'Danger_Value')
  #   27 = Enemy with less than half HP
  #   28 = Enemy with more than half HP
  #   29 = Enemy with HP full
  #   30 = Enemy with less than 25% SP
  #   31 = Enemy with more than 25% SP
  #   32 = Enemy with less than half SP
  #   33 = Enemy with more than half SP
  #   34 = Enemy with SP full
  #   35 = Enemy with state (use only for actions that remove states)
  #   36 = Enemy without state (use only for actions that cause states)
  # Target = Criteria for target selection. It also depends on the value in 'Condition'
  #     Ex.: If Condition = 38 (Enemy with state)
  #     and Target = 2 (target with lower HP), the targert chosen will be
  #     the one with less HP, *between* the ones with the state
  #   0 = Random
  #   1 = User (only actions that target allies)
  #   2 = Target with lower HP
  #   3 = Target with higher HP
  #   4 = Target with lower HP
  #   5 = Target with hogher SP
  # Action ID = Action ID, valid only if Type = 3 OR 4.
  #   Don't need to be added if action is 'Nothing', 'Attack' or 'Defend'
  #   If not added for skills or items, the action selected is random.
  #   If the action is an 'Skill' or 'Item', you can add the action ID or
  #   an specifi string.
  #     Numeric Value = if it's an numeric value, the action selected will be
  #                     the one with ID equal this value
  #     Specific values for skills:
  #       'MostOff' = use the attack action more powerful avaliable
  #       'LessOff' = use the attack action less powerful avaliable
  #       'MostHeal' = use the healing action more powerful avaliable
  #       'LessHeal' = use the healing action less powerful avaliable
  #       'MostSpOff' = use the attack action avaliable that cost more sp
  #       'LessSpOff' = use the attack action avaliable that cost less sp
  #       'MostSpHeal' = use the healing action avaliable that cost more sp
  #       'LessSpHelal' = use the healing action avaliable that cost less sp
  #     Specific values for items:
  #       'MostHeal' = use the healing action more powerful avaliable
  #       'LessHeal' = use the healing action less powerful avaliable


  # Example Strategies:
  Battle_Strategy['Attacker'] = [[4, 2, 0, 0], [7, 2, 25, 2], [9, 1, 1, 0],
                                 [2, 3, 0, 0]]
  # Strategy focused on physical attacks
  #  [4, 2, 0, 0] = normal attack without conditions, priority 4
  #  [7, 2, 25, 2] = normal attack on target with lower hp, if any enemy has less
  #               than 25% HP, priority 7
  #  [9, 1, 1, 0] = defend if actor is in danger, priority 9
  #  [2, 3, 0, 0] = random skill without condition, priority 2
  
  Battle_Strategy['Healer'] = [[1, 2, 0, 0], [15, 3, 13, 2, 'MostHeal'],
                              [20, 3, 1, 1, 'MostHeal'], [12, 3, 11, 1, 4], 
                              [10, 3, 23, 0, 4], [9, 1, 1, 0]]
  # Estratégia voltada à cura dos Allys
  #  [1, 2, 0, 0] = normal attack without conditions, priority 1
  #  [15, 3, 13, 2, 'MostHeal'] = more powerful healing skill avaliable on the ally
  #               with less hp if an ally have less than 25% hp, priority 15.
  #  [20, 3, 1, 1, 'MostHeal'] = more powerful healing skill avaliable on the user
  #               with less hp if an he have less than 25% hp, priority 20.
  #  [12, 3, 11, 1, 4] = skill 'Esuna' on the user if he is under any effect healed
  #                by it, priority 12.
  #  [10, 3, 23, 0, 4] = skill 'Esuna' on ally if he is under any effect healed
  #                by it, priority 10.
  #  [9, 1, 1, 0] = defend if actor is in danger, priority 9
  
  Battle_Strategy['Poisoner'] = [[4, 2, 0, 0], [25, 3, 36, 0, 69], [9, 1, 1, 0]]
  # Estratégia voltata para ataques físicos, e ataque de veneno
  #  [4, 2, 0, 0] = normal attack without conditions, priority 4
  #  [7, 3, 36, 0, 69] = skill 'Poison Edge' on target without the effects caused
  #                by it, priority 7
  #  [9, 1, 1, 0] = defend if actor is in danger, priority 9
  
  Battle_Strategy['Magic'] = [[5, 3, 9, 0, 'MostOff'], [5, 3, 8, 0, 'LessSpOff'],
                            [15, 3, 13, 2, 'MostHeal'], [1, 2, 6, 0], [9, 1, 1, 0]]
  # Estratégia voltata para magias
  #  [5, 3, 9, 0, 'MostOff'] = most powerfull attack skill if user SP is higher
  #                than half, priority 5.
  #  [5, 3, 8, 0, 'LessSpOff'] = attack skill that cost less SP if user SP is lower
  #                than half, priority 5.
  #  [15, 3, 13, 2, 'MostHeal'] = more powerful healing skill avaliable on the ally
  #               with less hp if an ally have less than 25% hp, priority 15.
  #  [1, 2, 6, 0] = normal attack if user SP is lower than 25%, priority 1
  #  [9, 1, 1, 0] = defend if actor is in danger, priority 9

  #----------------------------------------------------------------------
  # Adding new strategies for the actors:
  #
  # Besides the default strategies, it's possible to add new strategies
  # for actors with 'Script Calls'
  # $game_actors[ID].add_strategy(Name, [Config])
  #   ID = Actor ID
  #   Name = Strategy Name
  #   Config = Strategy setting, set the same way as the default strategies

  #----------------------------------------------------------------------
  # Activating the automatic mode for actors:
  # Use an 'Script Call':
  #   $game_actors[ID].active_strategy(Name)
  #     ID = Actor ID
  #     Name = Strategy Name, must be an strategy already added to the actor,
  #        otherwise, nothing will happen
  #
  # Desativating the automatic mode:
  #   $game_actors[ID].clear_strategy
  #     ID = Actor ID
  
  #----------------------------------------------------------------------
  # Activating the automatic mode:
  # For enemies you don't need to add an strategy for them previously.
  # But them can only use one of the default strategy:
  #   Enemy_Strategy[ID] = 'Strategy'
  #     ID = Enemy
  #     Strategy = Strategy Name, must be an valid strategy set on 'Battle_Strategy'
  #
  # You can also activate an Srategy for an enemy during battle with an 'Script Call'
  #   $game_troop.enemies[INDEX].active_strategy('Strategy')
  #     INDEX = Enemy index on the enemy troop
  #     Strategy = Strategy Name, must be an valid strategy set on 'Battle_Strategy'
  # 
  Enemy_Strategy[15] = 'Poisoner'
 
  # The skills avaliable for enemies during the automatic mode don't depend
  # on the database settings. Instead, list here the skills avaliables
  Enemy_Skills[15] = [69]
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Auto Actions'] = true

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
  attr_accessor :strategy
  attr_accessor :auto_actions
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_autoaction initialize
  def initialize
    initialize_autoaction
    @strategy = ''
    @auto_actions = {}
  end
  #--------------------------------------------------------------------------
  # * Get automatic battler flag
  #--------------------------------------------------------------------------
  def auto_battler?
    return @auto_actions.include?(@strategy)
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_autoaction setup
  def setup(actor_id)
    setup_autoaction(actor_id)
    set_default_strategy
  end
  #--------------------------------------------------------------------------
  # * Set default strategy
  #--------------------------------------------------------------------------
  def set_default_strategy
    for strategy in Battle_Strategy.keys
      @auto_actions[strategy] = Battle_Strategy[strategy]
    end
  end
  #--------------------------------------------------------------------------
  # * Add strategy
  #     name     : strategy name
  #     strategy : strategy settings
  #--------------------------------------------------------------------------
  def add_strategy(name, strategy)
    @auto_actions[name] = strategy
  end
  #--------------------------------------------------------------------------
  # Ativar Estratégia
  #     name : strategy name
  #--------------------------------------------------------------------------
  def active_strategy(name)
    @strategy = name if @auto_actions[name] != nil
  end
  #--------------------------------------------------------------------------
  # Clear strategy
  #--------------------------------------------------------------------------
  def clear_strategy
    @strategy = ''
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     troop_id     : troop ID
  #     member_index : troop member index
  #     enemy_id     : enemy ID
  #--------------------------------------------------------------------------
  alias initialize_autoaction_enemy initialize
  def initialize(troop_id, member_index, enemy_id = nil)
    initialize_autoaction_enemy(troop_id, member_index, enemy_id)
    if Enemy_Strategy[@enemy_id] != nil and Battle_Strategy[Enemy_Strategy[@enemy_id]] != nil
      strategy = Enemy_Strategy[@enemy_id]
      @auto_actions = {strategy => Battle_Strategy[strategy]}
      @strategy = strategy
    end
  end
  #--------------------------------------------------------------------------
  # Ativar Estratégia
  #     name : strategy name
  #--------------------------------------------------------------------------
  def active_strategy(name)
    if Battle_Strategy[name] != nil
      @auto_actions = {name => Battle_Strategy[name]}
      @strategy = name
    end
  end
  #--------------------------------------------------------------------------
  # * Get skills
  #--------------------------------------------------------------------------
  def skills
    return Enemy_Skills[@enemy_id].nil? ? [] : Enemy_Skills[@enemy_id]
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start battler turn (ATB only)
  #     battler : battler
  #--------------------------------------------------------------------------
  alias battler_turn_autoaction battler_turn if $atoa_script["Atoa ATB"] or $atoa_script["Atoa CTB"]
  def battler_turn(battler)
    if battler.actor? and battler.auto_battler?
      battler.turn_count += 1
      set_automaitc_actions(battler)
      @action_battlers << battler
      @action_battlers.compact!
      return
    end
    battler_turn_autoaction(battler)
  end
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_autoaction phase3_setup_command_window
  def phase3_setup_command_window
    if $atoa_script['Atoa CTB'] and @active_battler.auto_battler?
      set_automaitc_actions(@active_battler)
      phase3_next_actor
      return
    end
    phase3_setup_command_window_autoaction
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  alias phase3_next_actor_autoaction phase3_next_actor
  def phase3_next_actor
    if $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB'] 
      phase3_next_actor_autoaction
    else
      begin
        @active_battler.blink = false if @active_battler != nil
        return start_phase4 if @actor_index == $game_party.actors.size-1
        @actor_index += 1
        @active_battler = $game_party.actors[@actor_index]
        @active_battler.blink = true
      end until @active_battler.inputable? and not @active_battler.auto_battler?
      phase3_setup_command_window
    end
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input of Previous Actor
  #--------------------------------------------------------------------------
  alias phase3_prior_actor_autoaction phase3_prior_actor
  def phase3_prior_actor
    if $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB'] 
      phase3_prior_actor_autoaction
    else
      begin
        @active_battler.blink = false if @active_battler != nil
        return start_phase2 if @actor_index == 0
        @actor_index -= 1
        @active_battler = $game_party.actors[@actor_index]
        @active_battler.blink = true
      end until @active_battler.inputable? and not @active_battler.auto_battler?
      phase3_setup_command_window
    end
  end
  #--------------------------------------------------------------------------
  # * Start Main Phase
  #--------------------------------------------------------------------------
  alias start_phase4_autoaction start_phase4
  def start_phase4
    start_phase4_autoaction
    for battler in $game_party.actors + $game_troop.enemies
      set_automaitc_actions(battler) if battler.auto_battler?
    end
  end
  #--------------------------------------------------------------------------
  # * Set enemy action
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_enemy_action_autoaction set_enemy_action if $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
  def set_enemy_action(battler)
    set_enemy_action_autoaction(battler)
    set_automaitc_actions(battler) if battler.auto_battler?
  end  
  #--------------------------------------------------------------------------
  # * Set automatic actions
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_automaitc_actions(battler)
    @strategy = battler.auto_actions[battler.strategy]
    @auto_actions = []
    for strategy in @strategy
      next unless set_valid_condition(battler, strategy)
      action = set_action_info(battler, strategy)
      targets = set_targets_auto(battler, strategy)
      @auto_actions << [strategy[0], action, targets]
    end
    if @auto_actions.empty?
      battler.current_action.kind = 0
      battler.current_action.basic = 1
      battler.current_action.skill_id = 0
      battler.current_action.item_id = 0
      target = battler.actor? ? $game_troop.random_target_enemy : $game_party.random_target_actor
      battler.current_action.target_index = target.index
    else
      actions = []
      for action in @auto_actions
        ([action[0], 1].max).times do
          actions << action
        end
      end
      action = actions[rand(actions.size)]
      skill_id = action[1][2]
      item_id = action[1][3]
      battler.current_action.kind = (skill_id == 0 and item_id == 0) ? 0 : action[1][0]
      battler.current_action.basic = action[1][1]
      battler.current_action.skill_id = skill_id
      battler.current_action.item_id = item_id
      if action[2].first.is_a?(Game_Battler)
        battler.current_action.target_index = action[2].first.index
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set targets
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_targets_auto(battler, strategy)
    action = batter_set_action(battler, strategy)
    return [] if action.nil?
    return set_valid_targets(battler, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set action
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def batter_set_action(battler, strategy)
    case strategy[1]
    when 0,1 then return nil
    when 2 then return battler.weapons[0].nil? ? 'Attack' : battler.weapons[0]
    when 3,4 then return set_action(battler, strategy)
    end
  end
  #--------------------------------------------------------------------------
  # * Set valid targets
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def set_valid_targets(battler, strategy, action)
    if action == 'Attack'
      if battler.restriction == 3
        target = battler.actor? ? $game_party.random_target_actor : $game_troop.random_target_enemy
      elsif battler.restriction == 2
        target = battler.actor? ? $game_troop.random_target_enemy : $game_party.random_target_actor
      else
        target = target_single_enemy(battler, strategy, action)
      end
      return battler.target_battlers = [target]
    end
    @targets = []
    if for_all_battlers(action)
      @targets = []
      for member in $game_troop.enemies + $game_party.actors
        @targets << member if member.exist?
        @targets << member if member.dead? and member.actor? and [5,6].include?(action.scope)
      end
    elsif for_allies(action)
      @targets = []
      if action.scope == 3 and not check_include(action, 'TARGET/ALLALLIES')
        @targets = [target_single_ally(battler, strategy, action)]
      elsif action.scope == 4 or check_include(action, 'TARGET/ALLALLIES')
        targets = battler.actor? ? $game_party.actors : $game_troop.enemies
        for member in targets
          @targets << member if member.exist?
        end
      elsif action.scope == 5
        targets = battler.actor? ? $game_party.actors : $game_troop.enemies
        for member in targets
          @targets << member if member.dead?
        end
        @targets = [@targets[rand(@targets.size)]]
      elsif action.scope == 6
        targets = battler.actor? ? $game_party.actors : $game_troop.enemies
        for member in targets
          @targets << member
        end
      end
    elsif for_enemies(action)
      @targets = []
      if action.scope == 1 and not check_include(action, 'TARGET/ALLENEMIES')
        @targets = [target_single_enemy(battler, strategy, action)]
      elsif action.scope == 2 or check_include(action, 'TARGET/ALLENEMIES')
        targets = battler.actor? ? $game_troop.enemies : $game_party.actors
        for member in targets
          @targets << member if member.exist?
        end
      end
    elsif for_self(action)
      @targets = [battler]
    end
    return @targets
  end
  #--------------------------------------------------------------------------
  # * Check action for allies
  #     action : action
  #--------------------------------------------------------------------------
  def for_allies(action)
    return [3,4,5,6].include?(action.scope)
  end
  #--------------------------------------------------------------------------
  # * Check action for user
  #     action : action
  #--------------------------------------------------------------------------
  def for_self(action)
    return action.scope == 7
  end
  #--------------------------------------------------------------------------
  # * Check action for enemies
  #     action : action
  #--------------------------------------------------------------------------
  def for_enemies(action)
    return [1,2].include?(action.scope)
  end
  #--------------------------------------------------------------------------
  # * Check action for all battlers
  #     action : action
  #--------------------------------------------------------------------------
  def for_all_battlers(action)
    return check_include(action, 'TARGET/ALLBATTLERS')
  end
  #--------------------------------------------------------------------------
  # * Set single target
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_single_ally(battler, strategy, action)
    case strategy[2]
    when 1,2,3,4,5,6,7,8,9,10,11,12 then return battler
    when 13 then return target_ally_2(battler, strategy, action)
    when 14 then return target_ally_3(battler, strategy, action)
    when 15 then return target_ally_4(battler, strategy, action)
    when 16 then return target_ally_5(battler, strategy, action)
    when 17 then return target_ally_6(battler, strategy, action)
    when 18 then return target_ally_7(battler, strategy, action)
    when 19 then return target_ally_8(battler, strategy, action)
    when 20 then return target_ally_9(battler, strategy, action)
    when 21 then return target_ally_10(battler, strategy, action)
    when 22 then return target_ally_11(battler, strategy, action)
    when 23 then return target_ally_12(battler, strategy, action)
    when 24 then return target_ally_13(battler, strategy, action)
    else return target_ally_1(battler, strategy, action)
    end
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 1)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_1(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist?
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 2)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_2(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.in_danger?
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 3)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_3(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and not target.in_danger?
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 4)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_4(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.hp <= (target.maxhp / 2)
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 5)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_5(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.hp > (target.maxhp / 2)
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 6)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_6(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.hp == target.maxhp
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 7)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_7(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.sp <= (target.maxsp / 4)
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 8)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_8(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and not target.sp > (target.maxsp / 2)
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 9)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_9(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.sp <= (target.maxsp / 2)
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 10)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_10(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.sp <= (target.maxsp / 2)
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 11)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_11(battler, strategy, action)
    actors = []
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      actors << target if target.exist? and target.sp == target.maxsp
    end
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 12)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_12(battler, strategy, action)
    return target_ally_1(battler) if action == 'attack'
    actors = []
    for state in action.minus_state_set
      targets = battler.actor? ? $game_party.actors : $game_troop.enemies
      for target in targets
        actors << target if target.exist? and target.states.include?(state)
      end
    end
    actors.uniq!
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single ally target (pattern 13)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_ally_13(battler, strategy, action)
    return target_ally_1(battler) if action == 'attack'
    actors = []
    for state in action.plus_state_set
      targets = battler.actor? ? $game_party.actors : $game_troop.enemies
      for target in targets
        actors << target if target.exist? and not target.states.include?(state)
      end
    end
    actors.uniq!
    return set_priority_target(battler, actors, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_single_enemy(battler, strategy, action)
    case strategy[2]
    when 25 then return target_enemy_2(battler, strategy, action)
    when 26 then return target_enemy_3(battler, strategy, action)
    when 27 then return target_enemy_4(battler, strategy, action)
    when 28 then return target_enemy_5(battler, strategy, action)
    when 29 then return target_enemy_6(battler, strategy, action)
    when 30 then return target_enemy_7(battler, strategy, action)
    when 31 then return target_enemy_8(battler, strategy, action)
    when 32 then return target_enemy_9(battler, strategy, action)
    when 33 then return target_enemy_10(battler, strategy, action)
    when 34 then return target_enemy_11(battler, strategy, action)
    when 35 then return target_enemy_12(battler, strategy, action)
    when 36 then return target_enemy_13(battler, strategy, action)
    else return target_enemy_1(battler, strategy, action)
    end
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 1)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_1(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist?
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 2)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_2(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.in_danger?
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 3)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_3(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and not target.in_danger?
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 4)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_4(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.hp <= (target.maxhp / 2)
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 5)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_5(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.hp > (target.maxhp / 2)
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 6)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_6(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.hp == target.maxhp
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 7)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_7(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.sp <= (target.maxsp / 4)
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 8)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_8(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and not target.sp > (target.maxsp / 2)
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern9)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_9(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.sp <= (target.maxsp / 2)
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 10)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_10(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.sp <= (target.maxsp / 2)
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 11)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_11(battler, strategy, action)
    enemies = []
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      enemies << target if target.exist? and target.sp == target.maxsp
    end
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 12)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_12(battler, strategy, action)
    return target_enemy_1(battler) if action == 'attack'
    enemies = []
    for state in action.minus_state_set
      targets = battler.actor? ? $game_troop.enemies : $game_party.actors
      for target in targets
        enemies << target if target.exist? and target.states.include?(state)
      end
    end
    enemies.uniq!
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set single enemy target (pattern 13)
  #     battler  : battler
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def target_enemy_13(battler, strategy, action)
    return target_enemy_1(battler) if action == 'attack'
    enemies = []
    for state in action.plus_state_set
      targets = battler.actor? ? $game_troop.enemies : $game_party.actors
      for target in targets
        enemies << target if target.exist? and not target.states.include?(state)
      end
    end
    enemies.uniq!
    return set_priority_target(battler, enemies, strategy, action)
  end
  #--------------------------------------------------------------------------
  # * Set action info
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def set_action_info(battler, strategy)
    case strategy[1]
    when 0,1,2 then kind = 0
    when 3 then kind = 1
    when 4 then kind = 2
    end
    case strategy[1]
    when 0 then basic = 3
    when 1 then basic = 1
    when 2,3,4 then basic = 0
    end
    case strategy[1]
    when 0,1,2,4 then skill_id = 0
    when 3
      skill = set_action(battler, strategy)
      skill_id = skill.nil? ? 0 : skill.id
    end
    case strategy[1]
    when 0,1,2,3 then item_id = 0
    when 4
      item = set_action(battler, strategy)
      item_id = item.nil? ? 0 : item.id
    end
    return [kind, basic, skill_id, item_id]
  end
  #--------------------------------------------------------------------------
  # * Set priority target
  #     battler  : battler
  #     targets  : targets
  #     strategy : strategy
  #     action   : action
  #--------------------------------------------------------------------------
  def set_priority_target(battler, targets, strategy, action)
    case strategy[3]
    when 0 then target = targets[rand(targets.size)]
    when 1
      target = (action != nil and action.scope > 1) ? battler : targets[rand(targets.size)]
    when 2
      targets.sort! {|a, b| a.hp  <=> b.hp}
      target = targets.first
    when 3
      targets.sort! {|a, b| b.hp  <=> a.hp}
      target = targets.first
    when 4
      targets.sort! {|a, b| a.sp  <=> b.sp}
      target = targets.first
    when 5
      targets.sort! {|a, b| b.sp  <=> a.sp}
      target = targets.first
    end
    return target
  end
  #--------------------------------------------------------------------------
  # * Set valid condition
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def set_valid_condition(battler, strategy)
    case strategy[2]
    when 0 then return true
    when 1 then return condition_1(battler)
    when 2 then return condition_2(battler)
    when 3 then return condition_3(battler)
    when 4 then return condition_4(battler)
    when 5 then return condition_5(battler)
    when 6 then return condition_6(battler)
    when 7 then return condition_7(battler)
    when 8 then return condition_8(battler)
    when 9 then return condition_9(battler)
    when 10 then return condition_10(battler)
    when 11 then return condition_11(battler, strategy)
    when 12 then return condition_12(battler, strategy)
    when 13 then return condition_13(battler)
    when 14 then return condition_14(battler)
    when 15 then return condition_15(battler)
    when 16 then return condition_16(battler)
    when 17 then return condition_17(battler)
    when 18 then return condition_18(battler)
    when 19 then return condition_19(battler)
    when 20 then return condition_20(battler)
    when 21 then return condition_21(battler)
    when 22 then return condition_22(battler)
    when 23 then return condition_23(battler, strategy)
    when 24 then return condition_24(battler, strategy)
    when 25 then return condition_25(battler)
    when 26 then return condition_26(battler)
    when 27 then return condition_27(battler)
    when 28 then return condition_28(battler)
    when 29 then return condition_29(battler)
    when 30 then return condition_30(battler)
    when 31 then return condition_31(battler)
    when 32 then return condition_32(battler)
    when 33 then return condition_33(battler)
    when 34 then return condition_34(battler)
    when 35 then return condition_35(battler, strategy)
    when 36 then return condition_36(battler, strategy)
    end
  end
  #--------------------------------------------------------------------------
  # * Condition 1
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_1(battler)
    return battler.in_danger?
  end
  #--------------------------------------------------------------------------
  # * Condition 2
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_2(battler)
    return !battler.in_danger?
  end
  #--------------------------------------------------------------------------
  # * Condition 3
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_3(battler)
    return battler.hp <= (battler.maxhp / 2)
  end
  #--------------------------------------------------------------------------
  # * Condition 4
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_4(battler)
    return battler.hp > (battler.maxhp / 2)
  end
  #--------------------------------------------------------------------------
  # * Condition 5
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_5(battler)
    return battler.hp == battler.maxhp
  end
  #--------------------------------------------------------------------------
  # * Condition 6
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_6(battler)
    return battler.sp <= (battler.maxsp / 4)
  end
  #--------------------------------------------------------------------------
  # * Condition 7
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_7(battler)
    return battler.sp > (battler.maxsp / 4)
  end
  #--------------------------------------------------------------------------
  # * Condition 8
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_8(battler)
    return battler.sp <= (battler.maxsp / 2)
  end
  #--------------------------------------------------------------------------
  # * Condition 9
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_9(battler)
    return battler.sp > (battler.maxsp / 2)
  end
  #--------------------------------------------------------------------------
  # * Condition 10
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_10(battler)
    return battler.sp == battler.maxsp
  end  
  #--------------------------------------------------------------------------
  # * Condition 11
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_11(battler, strategy)
    return false if [0,1].include?(strategy[1])
    return false if strategy[1] == 2 and battler.weapons.empty?
    action = strategy[1] == 2 ? weapons[0] : set_action(battler, strategy)
    return false if action.nil?
    for state in action.minus_state_set
      return true if battler.states.include?(state)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 12
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_12(battler, strategy)
    return false if [0,1].include?(strategy[1])
    return false if strategy[1] == 2 and battler.weapons.empty?
    action = strategy[1] == 2 ? weapons[0] : set_action(battler, strategy)
    return false if action.nil?
    for state in action.plus_state_set
      return true if not battler.states.include?(state)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 13
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_13(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.in_danger?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 14
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_14(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target
      return true if !actor.in_danger?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 15
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_15(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.hp <= (target.maxhp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 16
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_16(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.hp > (target.maxhp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 17
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_17(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.hp == target.maxhp
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 18
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_18(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.sp <= (target.maxsp / 4)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 19
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_19(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.sp > (target.maxsp / 4)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 20
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_20(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.sp <= (target.maxshp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 21
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_21(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.sp > (target.maxsp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 22
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_22(battler)
    targets = battler.actor? ? $game_party.actors : $game_troop.enemies
    for target in targets
      next if battler == target or target.dead?
      return true if target.sp == target.maxsp
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 23
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_23(battler, strategy)
    return false if [0,1].include?(strategy[1])
    return false if strategy[1] == 2 and battler.weapons.empty?
    action = strategy[1] == 2 ? weapons[0] : set_action(battler, strategy)
    return false if action.nil?
    for state in action.minus_state_set
      targets = battler.actor? ? $game_party.actors : $game_troop.enemies
      for target in targets
        next if battler == target
        return true if target.states.include?(state)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 24
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_24(battler, strategy)
    return false if [0,1].include?(strategy[1])
    return false if strategy[1] == 2 and battler.weapons.empty?
    action = strategy[1] == 2 ? weapons[0] : set_action(battler, strategy)
    return false if action.nil?
    for state in action.plus_state_set
      targets = battler.actor? ? $game_party.actors : $game_troop.enemies
      for target in targets
        next if battler == target
        return true if not target.states.include?(state)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 25
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_25(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.in_danger?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 26
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_26(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if !enemy.in_danger?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 27
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_27(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.hp <= (target.maxhp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 28
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_28(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.hp > (target.maxhp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 29
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_29(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.hp == target.maxhp
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 30
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_30(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.sp <= (target.maxsp / 4)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 31
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_31(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.sp > (target.maxsp / 4)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 32
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_32(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.sp <= (target.maxshp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 33
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_33(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.sp > (target.maxsp / 2)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 34
  #     battler  : battler
  #--------------------------------------------------------------------------
  def condition_34(battler)
    targets = battler.actor? ? $game_troop.enemies : $game_party.actors
    for target in targets
      next unless target.exist?
      return true if target.sp == target.maxsp
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 35
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_35(battler, strategy)
    return false if [0,1,2,4].include?(strategy[1])
    action = set_action(battler, strategy)
    return false if action.nil?
    for state in action.minus_state_set
      targets = battler.actor? ? $game_troop.enemies : $game_party.actors
      for target in targets
        next unless target.exist?
        return true if target.states.include?(state)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Condition 36
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def condition_36(battler, strategy)
    return false if [0,1,2,4].include?(strategy[1])
    action = set_action(battler, strategy)
    return false if action.nil?
    for state in action.plus_state_set
      targets = battler.actor? ? $game_troop.enemies : $game_party.actors
      for target in targets
        next unless target.exist?
        return true if not target.states.include?(state)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Set action
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def set_action(battler, strategy)
    if strategy[1] == 3
      case strategy[4]
      when nil,0 then return set_random_skill(battler)
      when Numeric then return set_skill_id(battler, strategy)
      when 'MostOff' then return set_strongest_skill(battler)
      when 'LessOff' then return set_weakest_skill(battler)
      when 'MostHeal' then return set_strongest_heal(battler)
      when 'LessHeal' then return set_weakest_heal(battler)
      when 'MostSpOff' then return set_most_sp_skill(battler)
      when 'LessSpOff' then return set_less_sp_skill(battler)
      when 'MostSpHeal' then return set_most_sp_heal(battler)
      when 'LessSpHelal' then return set_less_sp_heal(battler)
      end
    else
      case strategy[4]
      when nil then return set_random_item(battler)
      when Numeric then return set_item_id(battler, strategy)
      when 'MostHeal' then return set_strongest_item(battler, strategy)
      when 'LessHeal' then return set_weakest_item(battler, strategy)
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Set Skill ID
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def set_skill_id(battler, strategy)
    return nil unless battler.skill_can_use?(strategy[4])
    return $data_skills[strategy[4]]
  end
  #--------------------------------------------------------------------------
  # * Select random skill
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_random_skill(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id]
    end
    @auto_skill = battler_skills[rand(battler_skills.size)]
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skilll
  end
  #--------------------------------------------------------------------------
  # * Select strongest skill
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_strongest_skill(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power > 0
    end
    battler_skills.sort!{|a, b| (b.power + b.atk_f + b.int_f + b.str_f) <=> 
                                (a.power + a.atk_f + a.int_f + a.str_f)}
    battler_skills.size.times do 
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select weakest skill
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_weakest_skill(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power > 0
    end
    battler_skills.sort!{|a, b| (a.power + a.atk_f + a.int_f + a.str_f) <=> 
                                (b.power + b.atk_f + b.int_f + b.str_f)}
    battler_skills.size.times do
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select strongest heal
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_strongest_heal(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power < 0
    end
    battler_skills.sort!{|a, b| (b.power.abs + b.atk_f + b.int_f + b.str_f) <=> 
                                (a.power.abs + a.atk_f + a.int_f + a.str_f)}
    battler_skills.size.times do 
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select weakest heal
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_weakest_heal(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power < 0
    end
    battler_skills.sort!{|a, b| (a.power.abs + a.atk_f + a.int_f + a.str_f) <=> 
                                (b.power.abs + b.atk_f + b.int_f + b.str_f)}
    battler_skills.size.times do
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select higher cost skill
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_most_sp_skill(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power > 0
    end
    battler_skills.compact!
    battler_skills.sort!{|a, b|  battler.calc_sp_cost(b) <=> battler.calc_sp_cost(a)}
    battler_skills.size.times do
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select lower cost skill
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_less_sp_skill(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power > 0
    end
    battler_skills.compact!
    battler_skills.sort!{|a, b|  battler.calc_sp_cost(a) <=> battler.calc_sp_cost(b)}
    battler_skills.size.times do
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select higher cost heal
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_most_sp_heal(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power < 0
    end
    battler_skills.compact!
    battler_skills.sort!{|a, b|  battler.calc_sp_cost(b) <=> battler.calc_sp_cost(a)}
    battler_skills.size.times do
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Select lower cost heal
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_less_sp_heal(battler)
    battler_skills = []
    @auto_skill = nil
    for skill_id in battler.skills
      battler_skills << $data_skills[skill_id] if $data_skills[skill_id].power < 0
    end
    battler_skills.compact!
    battler_skills.sort!{|a, b|  battler.calc_sp_cost(a) <=> battler.calc_sp_cost(b)}
    battler_skills.size.times do
      @auto_skill = battler_skills.shift
      break if battler.skill_can_use?(@auto_skill.id)
    end
    return nil if @auto_skill.nil? or @auto_skill == 0 or not battler.skill_can_use?(@auto_skill.id)
    return @auto_skill
  end
  #--------------------------------------------------------------------------
  # * Set Item ID
  #     battler  : battler
  #     strategy : strategy
  #--------------------------------------------------------------------------
  def set_item_id(battler, strategy)
    return nil unless $game_party.item_can_use?(strategy[4])
    return $data_items[strategy[4]]
  end
  #--------------------------------------------------------------------------
  # * Select strongest item
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_strongest_item(battler)
    return nil unless battler.actor?
    battler_items = []
    @auto_item = nil
    for i in 1...$data_items.size
      next unless $game_party.item_number(i) > 0 and healing_item($data_items[i])
      battler_items < $data_items[i]
    end
    if [1,2,3,4,5,13,14,15,16,17].include?(strategy[2])
      battler_items.sort!{|a, b| (b.recover_hp_rate + b.recover_hp) <=> 
                                 (a.recover_hp_rate + a.recover_hp)}
    elsif [6,7,8,9,10,18,19,20,21,22].include?(strategy[2])
      battler_items.sort!{|a, b| (b.recover_sp_rate + b.recover_sp) <=> 
                                 (a.recover_sp_rate + a.recover_sp)}
    else
      battler_items.sort!{|a, b| b.minus_state_set <=> a.minus_state_set}
    end
    battler_items.size.times do
      @auto_item = battler_items.shift
      break if $game_party.item_can_use?(@auto_item.id)
    end
    return nil if @auto_item.nil? or @auto_item == 0 or not $game_party.item_can_use?(@auto_item.id)
    return @auto_item
  end
  #--------------------------------------------------------------------------
  # * Select random item
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_random_item(battler)
    return nil unless battler.actor?
    battler_items = []
    @auto_item = nil
    for i in 1...$data_items.size
      next unless $game_party.item_number(i) > 0 and healing_item($data_items[i])
      battler_items < $data_items[i]
    end
    @auto_item = battler_items[rand(battler_items.size)]
    return nil if @auto_item.nil? or @auto_item == 0 or not $game_party.item_can_use?(@auto_item.id)
    return @auto_item
  end
  #--------------------------------------------------------------------------
  # * Select weakest item
  #     battler  : battler
  #--------------------------------------------------------------------------
  def set_weakest_item(battler)
    return nil unless battler.actor?
    battler_items = []
    @auto_item = nil
    for i in 1...$data_items.size
      next unless $game_party.item_number(i) > 0 and healing_item($data_items[i])
      battler_items < $data_items[i]
    end
    if [1,2,3,4,5,13,14,15,16,17].include?(strategy[2])
      battler_items.sort!{|a, b| ((a.recover_hp_rate * 50) + a.recover_hp) <=> 
                                 ((b.recover_hp_rate * 50) + b.recover_hp)}
    elsif [6,7,8,9,10,18,19,20,21,22].include?(strategy[2])
      battler_items.sort!{|a, b| ((a.recover_sp_rate * 50) + a.recover_sp) <=> 
                                 ((b.recover_sp_rate * 50) + b.recover_sp)}
    else
      battler_items.sort!{|a, b| a.minus_state_set <=> b.minus_state_set}
    end
    battler_items.size.times do 
      @auto_item = battler_items.shift
      break if $game_party.item_can_use?(@auto_item.id)
    end
    return nil if @auto_item.nil? or @auto_item == 0 or not $game_party.item_can_use?(@auto_item.id)
    return @auto_item
  end
  #--------------------------------------------------------------------------
  # * Get Heal item flag
  #    item : Item
  #--------------------------------------------------------------------------
  def healing_item(item)
    return (item.recover_sp_rate > 0 or item.recover_sp > 0 or
           item.recover_hp_rate > 0 or item.recover_hp > 0)
  end
end