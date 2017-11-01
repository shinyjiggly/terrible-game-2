#==============================================================================
# Skill Reflect
# By Atoa
#==============================================================================
# The battler with the effect of reflect status will have all magical skills
# targeted on him reflected to the uses.
# All skills with the status 'Atk_f' = 0 are considered Magics.
#
# This script must be above all other skills scripts.
#==============================================================================

module Atoa
  # Do not remove these lines
  Reflection_State = {}
  Ignore_Reflect_Magics = {}
  # Do not remove these lines
  
  # If true, actions reflected alway return to the user
  # If false, actions reflected will be targeted on the opposite party
  Reflect_Bounce_User = true
  
  # Skills that ignores Reflect effect.Habilidades que ignoram o efeito Refletir.
  # Ignore_Reflect_Magics[Skill_ID] = [States]
  #   Skill_ID = ID of the skills
  #   States = IDs of the reflect states ignored
  
  # Reflection_State[state_id] = {type =>[user_dmg, target_dmg, reflect_rate, anim_id]}
  #  state_id = ID of the state
  #  type = type of damage reflected
  #  user_dmg = % of damage recived by action user
  #  target_dmg = % of damage recived by targets
  #  reflect_rate = reflection success rate
  #  amim_id = animation id shown when reflect
  Reflection_State[17] = {'Magic' => [50, 0, 100, 103]}
  Reflection_State[18] = {'Physic' => [50, 0, 100, 104]}
  Reflection_State[19] = {'Magic' => [0, 0, 100, 105]}
  Reflection_State[20] = {'Physic' => [0, 0, 100, 106]}
  Reflection_State[25] = {'Magic' => [50, 50, 50, 103], 'Physic' => [50, 50, 50, 104]}
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Reflect'] = true

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
  attr_accessor :reflected
  attr_accessor :reflects
  attr_accessor :reflection
  attr_accessor :reflect_set
  attr_accessor :old_targets
  attr_accessor :new_targets
  attr_accessor :reflect_times
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_skillreflect initialize
  def initialize
    initialize_skillreflect
    @reflect_times = 1
    @old_targets = []
    @new_targets = []
  end
  #--------------------------------------------------------------------------
  # * Check Reflection
  #     action : action
  #--------------------------------------------------------------------------
  def check_reflection(action = nil)
    for reflect in Reflection_State.keys
      if @states.include?(reflect) and reflected_action(action, Reflection_State[reflect])
        reflection = Reflection_State[reflect].dup
        return reflection if action_magic(action) and (rand(100) <= reflection['Magic'][2])
        return reflection if action_physical(action)and (rand(100) <= reflection['Physic'][2])
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Reflected action flag
  #     action : action
  #--------------------------------------------------------------------------
  def reflected_action(action, reflect)
    return true if action_magic(action) and reflect.include?('Magic')
    return true if action_physical(action) and reflect.include?('Physic')
    return false
  end
  #--------------------------------------------------------------------------
  # * Magic action flag
  #     action : action
  #--------------------------------------------------------------------------
  def action_magic(action)
    return true if action.is_a?(RPG::Skill) and action.magic?
    return false
  end
  #--------------------------------------------------------------------------
  # * Physical action flag
  #     action : action
  #--------------------------------------------------------------------------
  def action_physical(action)
    return true if action.is_a?(RPG::Skill) and not action.magic?
    return true if action.nil?
    return false
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_skillreflect set_damage
  def set_damage(user, action = nil)
    set_damage_skillreflect(user, action)
    if self.reflects != nil and user.target_damage[self].numeric?
      self.reflection = 0
      self.reflection = self.reflects['Magic'][1] if action_magic(action)
      self.reflection = self.reflects['Physic'][1] if action_physical(action)
      user.target_damage[self] = (user.target_damage[self] * self.reflection) / 100
      user.target_damage[self] = '' if user.target_damage[self] == 0
    elsif self.reflected != nil and user.target_damage[self].numeric?
      self.reflection = 0
      self.reflection = self.reflected['Magic'][0] if action_magic(action)
      self.reflection = self.reflected['Physic'][0] if action_physical(action)
      user.target_damage[self] = (user.target_damage[self] * self.reflection) / 100
      user.target_damage[self] = '' if user.target_damage[self] == 0
    end
    user.target_damage[self] *= self.reflect_times if user.target_damage[self] != nil and
                                                      user.target_damage[self].numeric?
    self.reflect_times = 1    
  end
  #--------------------------------------------------------------------------
  # * State Change (+) Application
  #     plus_state_set  : State Change (+)
  #--------------------------------------------------------------------------
  alias states_plus_skillreflect states_plus
  def states_plus(plus_state_set)
    if (self.reflects != nil and self.reflection == 0) or
       (self.reflected != nil and self.reflection == 0)
      @state_changed = true
      return true
    end
    return states_plus_skillreflect(plus_state_set)
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
  alias start_skillreflection start
  def start
    start_skillreflection
    reset_all_reflect
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_skillreflect terminate
  def terminate
    terminate_skillreflect
    reset_all_reflect
  end
  #--------------------------------------------------------------------------
  # * Make Basic Action Result
  #     battler : battler
  #--------------------------------------------------------------------------
  alias make_basic_action_result_skillreflection make_basic_action_result
  def make_basic_action_result(battler)
    battler.new_targets.clear
    reset_reflection
    set_reflect_targets(battler)
    set_reflect_times(battler)
    make_basic_action_result_skillreflection(battler)
  end
  #--------------------------------------------------------------------------
  # * Make Skill Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  alias make_skill_action_result_skillreflection make_skill_action_result
  def make_skill_action_result(battler)
    battler.new_targets.clear
    for target in $game_troop.enemies + $game_party.actors
      target.reflection = 0
      target.reflect_times = 1
    end
    set_reflect_targets(battler, battler.current_skill)
    set_reflect_times(battler)
    make_skill_action_result_skillreflection(battler)
  end
  #--------------------------------------------------------------------------
  # * Clear reflection values
  #--------------------------------------------------------------------------
  def reset_reflection
    for target in $game_troop.enemies + $game_party.actors
      target.reflection = 0
      target.reflect_times = 1
    end
  end
  #--------------------------------------------------------------------------
  # * Set reflection targets
  #     battler : battler
  #     action  : action
  #--------------------------------------------------------------------------
  def set_reflect_targets(battler, action = nil)
    for target in battler.target_battlers
      reflection = target.check_reflection(action)
      if reflection != nil and not ignore_reflect(battler, target)
        target.reflects = reflection
        if oposite_side(battler, target) or Reflect_Bounce_User
          battler.reflected = target.check_reflection(action)
          battler.new_targets << battler
        else
          if battler.actor?
            enemy = $game_troop.random_target_enemy
            enemy.reflected = target.check_reflection(action)
            battler.new_targets << enemy
          else
            actor = $game_party.random_target_actor
            actor.reflected = target.check_reflection(action)
            battler.new_targets << actor
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set reflect times
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_reflect_times(battler)
    for target in battler.new_targets
      if battler.target_battlers.include?(target)
        target.reflect_times += 1
      else
        battler.target_battlers << target
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get reflect igonore
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  def ignore_reflect(battler, target)
    if Ignore_Reflect_Magics[battler.current_action.skill_id] != nil
      for state in target.states
        return true if Ignore_Reflect_Magics[battler.current_action.skill_id].include?(state)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Set Battle Animation
  #     battler   : battler
  #     wait_base : base wait time
  #--------------------------------------------------------------------------
  alias set_action_anim_skillreflection set_action_anim
  def set_action_anim(battler, wait_base)
    now_action(battler)
    set_action_anim_skillreflection(battler, wait_base)
    for target in battler.target_battlers
      if target.reflects != nil and not battler.reflect_set[target]
        action = battler.now_action.is_a?(RPG::Skill) ? battler.now_action : nil
        target.animation_id = 0 if target.reflection == 0
        target.animation_id = set_reflect_anim(battler, target)
        set_reflect_anim(target, target.reflects['Magic'][3]) if battler.action_magic(skill)
        set_reflect_anim(target, target.reflects['Magic'][3]) if battler.action_physical(skill)
        battler.reflect_set[target] = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set reflection animation
  #     target  : target
  #     ref     : reflection value
  #--------------------------------------------------------------------------
  def set_reflect_anim(target, ref)
    if ref.is_a?(Array)
      dir = target.direction
      target.animation_id = dir == 2 ? ref[0] : dir == 4 ? ref[1] : dir == 6 ? ref[2] : ref[3]
    else
      target.animation_id = ref
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part3_skillreflection step4_part3
  def step4_part3(battler)
    reset_reflect(battler)
    step4_part3_skillreflection(battler)
  end
  #--------------------------------------------------------------------------
  # * Clear targets reflection values
  #    battler : battler
  #--------------------------------------------------------------------------
  def reset_reflect(battler)
    for target in battler.target_battlers
      target.reflect_set = {}
      target.reflects = nil
      target.reflected = nil
      target.reflection = 0
      target.reflect_times = 1
    end
    for target in battler.new_targets
      battler.target_battlers.delete(target)
    end
    battler.old_targets.clear
    battler.new_targets.clear
  end
  #--------------------------------------------------------------------------
  # * Clear all reflection values
  #--------------------------------------------------------------------------
  def reset_all_reflect
    for battler in $game_troop.enemies + $game_party.actors
      battler.reflect_set = {}
      battler.reflects = nil
      battler.reflected = nil
      battler.reflection = 0
      battler.reflect_times = 1
      battler.old_targets = []
      battler.new_targets = []
    end
  end
end