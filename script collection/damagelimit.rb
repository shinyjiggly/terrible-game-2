#==============================================================================
# Add-On: Damage Limit Version 1.1
# by Atoa
#==============================================================================
# This Add-On allows you to set an max limite for the amount of damage caused
# by an action, like in Final Fantasy series, where max damage was 9999.
# You can set skill, weapons or even set this feature for an enemy or actor. 
# To set this to enemies, skills or weapons, just add their IDs in the "module N01"
# just like in the examples.
#
# With character, the process is different, make an Script Call and add this
# line to it:
# $game_actors[ID].damage_limit = X
# 
# ID = actor ID
# X = Limit value
#
#==============================================================================

module N01
  # Do not remove these lines
  Skill_Limit = []
  Weapon_Limit = []
  Enemy_Limit = []
  # Do not remove these lines
  
  # Base damage Limit
  Base_Limit = 9999
  
  # Damage Limit for Skills
  # Skill_Limit[Skill_ID] = Limit_Value
  Skill_Limit[60] = 99999
  Skill_Limit[64] = 99999
  Skill_Limit[68] = 99999
  Skill_Limit[72] = 99999
  Skill_Limit[76] = 99999
  Skill_Limit[86] = 99999
  
  # Damage Limit for Weapons
  # Weapon_Limit[Weapon_ID] = Limit_Value
  Weapon_Limit[4] = 99999
  Weapon_Limit[8] = 99999
  Weapon_Limit[12] = 99999
  Weapon_Limit[16] = 99999
  Weapon_Limit[20] = 99999
  Weapon_Limit[24] = 99999
  Weapon_Limit[28] = 99999
  Weapon_Limit[32] = 99999
  
  # Damage Limit for Enemies
  # Enemy_Limit[Enemy_ID] = Limit_Value
  Enemy_Limit[31] = 99999
  Enemy_Limit[32] = 99999

end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS Damage Limit'] = true

#==============================================================================
# ■ Game_System
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :memorize_kind
  attr_accessor :memorize_basic
  attr_accessor :memorize_id
  #--------------------------------------------------------------------------
  alias attack_effect_max_dmg attack_effect
  def attack_effect(attacker)
    @dmg_limit_hp = self.hp
    @dmg_limit_sp = self.sp
    effective = attack_effect_max_dmg(attacker)
    if self.damage.is_a?(Numeric)
      weapon = attacker.actor? ?  attacker.weapons[0] : nil
      set_damage_limit(attacker, weapon)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  alias perfect_attack_effect_max_dmg perfect_attack_effect
  def perfect_attack_effect(attacker)
    @dmg_limit_hp = self.hp
    @dmg_limit_sp = self.sp
    effective = perfect_attack_effect_max_dmg(attacker)
    if self.damage.is_a?(Numeric)
      weapon = attacker.actor? ?  attacker.weapons[0] : nil
      set_damage_limit(attacker, weapon)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  alias perfect_skill_effect_max_dmg perfect_skill_effect
  def perfect_skill_effect(user, skill)
    @dmg_limit_hp = self.hp
    @dmg_limit_sp = self.sp
    effective = skill_effect_max_dmg(user, skill)
    if self.damage.is_a?(Numeric)
      set_damage_limit(user, skill)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  alias skill_effect_max_dmg skill_effect
  def skill_effect(user, skill)
    @dmg_limit_hp = self.hp
    @dmg_limit_sp = self.sp
    effective = skill_effect_max_dmg(user, skill)
    if self.damage.is_a?(Numeric)
      set_damage_limit(user, skill)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  def set_damage_limit(user, action)
    if user.actor? and action != nil and not action.magic?
      for weapon in user.weapons
        base_weapon = weapon.nil? ? user.damage_limit : weapon.damage_limit
        weapon_limit = weapon_limit.nil? ? base_weapon : weapon_limit
        weapon_limit = base_weapon > weapon_limit ? base_weapon : weapon_limit
      end
      base_limt = (user.damage_limit >= weapon_limit ? user.damage_limit : weapon_limit)
    else
      base_limt = user.damage_limit
    end
    if action != nil
      dmg_limit = (base_limt >= action.damage_limit ? base_limt : action.damage_limit)
    else
      dmg_limit = base_limt
    end
    self.damage = [[self.damage, -dmg_limit].max, dmg_limit].min 
    self.hp = @dmg_limit_hp - self.damage unless self.sp_damage
    self.sp = @dmg_limit_sp - self.damage if self.sp_damage
  end
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  attr_reader   :damage_limit
  #--------------------------------------------------------------------------
  def damage_limit
    return @damage_limit.nil? ? @damage_limit = Base_Limit : @damage_limit
  end
  #--------------------------------------------------------------------------
  def damage_limit=(dmg)
    @damage_limit = dmg
  end
end

#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def damage_limit
    return Enemy_Limit[@enemy_id] if Enemy_Limit[@enemy_id] != nil
    return Base_Limit
  end
  #--------------------------------------------------------------------------
end
 
#==============================================================================
# ■ RPG::Skill
#==============================================================================
class RPG::Skill
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def damage_limit
    return Skill_Limit[@id] if Skill_Limit[@id] != nil
    return Base_Limit
  end
  #--------------------------------------------------------------------------
end

#==============================================================================
# ■ RPG::Weapon
#==============================================================================
class RPG::Weapon
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def damage_limit
    return Weapon_Limit[@id] if Weapon_Limit[@id] != nil
    return Base_Limit
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  alias make_basic_action_result_max_dmg make_basic_action_result
  def make_basic_action_result
    memorize_action
    make_basic_action_result_max_dmg
    recover_action
  end
  #--------------------------------------------------------------------------
  alias make_skill_action_result_max_dmg make_skill_action_result
  def make_skill_action_result
    memorize_action
    make_skill_action_result_max_dmg
    recover_action
  end
  #--------------------------------------------------------------------------
  def memorize_action
    for target in @target_battlers
      target.memorize_basic = target.current_action.basic
      target.memorize_kind = target.current_action.kind
      target.memorize_id = target.current_action.skill_id if target.current_action.kind == 1
      target.memorize_id = target.current_action.item_id if target.current_action.kind == 2
    end
  end
  #--------------------------------------------------------------------------
  def recover_action
    for target in @target_battlers
      unless target.dead?
        target.current_action.basic = target.memorize_basic
        target.current_action.kind = target.memorize_kind
        target.current_action.skill_id = target.memorize_id if target.current_action.kind == 1
        target.current_action.item_id = target.memorize_id if target.current_action.kind == 2
      end
    end
  end
end
