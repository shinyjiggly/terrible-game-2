#==============================================================================
# ** Equipment, Item & Skill Requirements (EIS)
#------------------------------------------------------------------------------
# SephirothSpawn
# Version 0.9 a
# 2006-10-30
#------------------------------------------------------------------------------
# * Description :
#
#   This script was designed to give you 18 new requirements to equip weapons
#   and armors, use items in battle (determined by active battler) or use
#   skills. To Learn more about the types of requirements, refer to the
#   Requirement Explanations below EIS_Requirements module.
#------------------------------------------------------------------------------
# * Instructions :
#
#   Place The Script Below the SDK and Above Main.
#   To Setup requirements, refer to customization.
#------------------------------------------------------------------------------
# * Customization :
#
#   Refer to ** Requirement Explanations
#------------------------------------------------------------------------------
# * Syntax :
#
#   Test If Skill Passes Requirements
#    - EIS_Requirements::Skills.can_use?(actor, skill_id)
#
#   Test If Item Passes Requirements
#    - EIS_Requirements::Items.can_use?(actor, item_id)
#
#   Test If Weapon Can Be Equipped
#    - EIS_Requirements::Equipment::Weapons.can_equip?(actor, weapon_id)
#
#   Test If Armor Can Be Equipped
#    - EIS_Requirements::Equipment::Armors.can_equip?(actor, armor_id)
#==============================================================================

 
#==============================================================================
# ** EIS_Requirements
#==============================================================================

module EIS_Requirements
  
  #===========================================================================
  # ** Options
  #===========================================================================
  Show_Req_Skill_Button = Input::X
  #===========================================================================
  # ** Requirement Explanations
  #
  # * Actor Requirements
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You Must
  #                  Be One of the Required Actors
  #    Setup : Actor = { object_id => [actor_id, ...], ... }
  #
  # * Class Requirements
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You Must
  #                  Be One of the Required Classes
  #    Setup : Class = { object_id => [class_id, ...], ... }
  #
  # * Skill Requirements (ALL)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You Must
  #                  Have All Skills from the list
  #    Setup : Skill_All = { object_id => [skill_id, ...], ... }
  #
  # * Skill Requirements (ONE)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You Must
  #                  Have One Skills from the list
  #    Setup : Skill_One = { object_id => [skill_id, ...], ... }
  #
  # * Weapon Requirements
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You
  #                  Must Have specific weapon equipped.
  #    Setup : Weapon = { object_id => [weapon_id, ...], ... }
  #
  # * Armor Requirements (ALL)
  #    Description : To Use A Skill, Item (In Battle)or Equipment, You 
  #                  Must Have All Armors Equipped
  #    Setup : Armor_All = { object_id => [armor_id, ...], ... }
  #
  # * Armor Requirements (ONE)
  #    Description : To Use A Skill, Item (In Battle)or Equipment, You 
  #                  Must Have One armros Equipped from the list
  #    Setup : Armor_One = { object_id => [armor_id, ...], ... }
  #
  # * Level Requirements
  #    Description : To Use A Skill, Item (In Battle) or Equipment, Your 
  #                  Level Must Be Equal to, Less Than, Less Than or Equal
  #                  To, Greater Than, or Greater Than Or Equal A Value.
  #    Setup : Level = {object_id => [level, '<operator>'], ... }
  #
  # * Stat Requirements (ALL)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, All Your
  #                  Stats Must Be Equal to, Less Than, Less Than or Equal
  #                  To, Greater Than, or Greater Than Or Equal A Value for
  #                  each stat.
  #    Setup : Stat_All = {object_id => {stat_name => [n, '<operator>'], ... }
  #
  # * Stat Requirements (One)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, One of
  #                  Your Stats Must Be Equal to, Less Than, Less Than or
  #                  Equal To, Greater Than, or Greater Than Or Equal A
  #                  Value for a stat.
  #    Setup : Stat_One = {object_id => {stat_name => [n, '<operator>'], ... }
  #
  # * State Requirements (Have ALL)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You must
  #                  have all required states.
  #    Setup : State_Have_All = {object_id => [state_id, ...], ... }
  #
  # * State Requirements (Have One)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You must
  #                  have one required states.
  #    Setup : State_Have_One = {object_id => [state_id, ...], ... }
  #
  # * State Requirements (Don't Have ALL)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You must
  #                  not have any required states.
  #    Setup : State_Dont_All = {object_id => [state_id, ...], ... }
  #
  # * State Requirements (Don't Have One)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, You must
  #                  not have one required states.
  #    Setup : State_Dont_One = {object_id => [state_id, ...], ... }
  #
  # * Game Switch Requirements (ALL)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, All
  #                  switches must be in the appropiate state.
  #    Setup : Switch_All = {object_id => {switch_id => state, ...}, ... }
  #
  # * Game Switch Requirements (One)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, a
  #                  switch must be in the appropiate state.
  #    Setup : Switch_One = {object_id => [switch_id, state], ... }
  #
  # * Game Variable Requirements (ALL)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, All
  #                  Variables Must Be Equal to, Less Than, Less Than or Equal
  #                  To, Greater Than, or Greater Than Or Equal A Value.
  #    Setup : Variable_All = {object_id => {variable_id => 
  #                            [n, '<operator>'], ... }, ... }
  #
  # * Game Variable Requirements (One)
  #    Description : To Use A Skill, Item (In Battle) or Equipment, one
  #                  Variable Must Be Equal to, Less Than, Less Than or Equal
  #                  To, Greater Than, or Greater Than Or Equal A Value.
  #    Setup : Variable_All = {object_id => {variable_id => 
  #                            [n, '<operator>'], ... }, ... }
  #
  # ** Stat Names :
  #      'maxhp', 'maxsp', 'hp', 'sp', 'str', 'dex', 'agi', 'int'
  #      'atk', 'pdef', 'mdef', 'eva'
  #
  # ** Operators :
  #      Less Than or Equal To    : '<='
  #      Less Than                : '<'
  #      Equal To                 : '=='
  #      Greater Than             : '>'
  #      Greater Than or Equal To : '>='
  #
  # ** Any Time Replacing the object_id with 0, will act as a default for
  #    any non-defined objects of that type.
  #===========================================================================

  #===========================================================================
  # ** Equipment
  #===========================================================================
  
  module Equipment
    #========================================================================
    # ** Weapons
    #========================================================================
  
    module Weapons
      #---------------------------------------------------------------------
      # * Requirements
      #---------------------------------------------------------------------
      Actor          = {}
      Class          = {}
      Skill_All      = {}
      Skill_One      = {}
      Armor_All      = {}
      Armor_One      = {}
      Level          = {}
      Stat_All       = {}
      Stat_One       = {}
      State_Have_All = {}
      State_Have_One = {}
      State_Dont_All = {}
      State_Dont_One = {}
      Switch_All     = {}
      Switch_One     = {}
      Variable_All   = {}
      Variable_One   = {}
      # Leave This Constant Alone
      Weapon         = {}
      #---------------------------------------------------------------------
      # * Can Equip? Test
      #---------------------------------------------------------------------
      def self.can_equip?(actor, object_id = 0)
        # If 0, Return True (Unequipping)
        return true if object_id == 0
        # Return False If Weapon Doesn't Exist
        return false if $data_weapons[object_id].nil?
        # Return Test For All Requirements
        return EIS_Requirements.can_use?(actor, object_id, self)
      end
    end
    
    #========================================================================
    # ** Armors
    #========================================================================
  
    module Armors
      #---------------------------------------------------------------------
      # * Requirements
      #---------------------------------------------------------------------
      Actor          = {}
      Class          = {}
      Skill_All      = {}
      Skill_One      = {}
      Weapon         = {}
      Armor_All      = {}
      Armor_One      = {}
      Level          = {}
      Stat_All       = {}
      Stat_One       = {}
      State_Have_All = {}
      State_Have_One = {}
      State_Dont_All = {}
      State_Dont_One = {}
      Switch_All     = {}
      Switch_One     = {}
      Variable_All   = {}
      Variable_One   = {}
      #---------------------------------------------------------------------
      # * Can Equip? Test
      #---------------------------------------------------------------------
      def self.can_equip?(actor, object_id = 0)
        # If 0, Return True (Unequipping)
        return true if object_id == 0
        # Return False If Armor Doesn't Exist
        return false if $data_armors[object_id].nil?
        # Return Test For All Requirements
        return EIS_Requirements.can_use?(actor, object_id, self)
      end
    end
  end
  
  #========================================================================
  # ** Items
  #========================================================================

  module Items
    #---------------------------------------------------------------------
    # * Requirements
    #---------------------------------------------------------------------
    Actor          = {}
    Class          = {}
    Skill_All      = {}
    Skill_One      = {}
    Weapon         = {}
    Armor_All      = {}
    Armor_One      = {}
    Level          = {}
    Stat_All       = {}
    Stat_One       = {}
    State_Have_All = {}
    State_Have_One = {}
    State_Dont_All = {}
    State_Dont_One = {}
    Switch_All     = {}
    Switch_One     = {}
    Variable_All   = {}
    Variable_One   = {}
    #---------------------------------------------------------------------
    # * Can Use? Test
    #---------------------------------------------------------------------
    def self.can_use?(actor, object_id = 0)
      # Return False If Item Doesn't Exist
      return false if $data_items[object_id].nil?
      # Return Test For All Requirements
      return EIS_Requirements.can_use?(actor, object_id, self)
    end
  end
  
  #========================================================================
  # ** Skills
  #========================================================================

  module Skills
    #---------------------------------------------------------------------
    # * Requirements
    #---------------------------------------------------------------------
    Actor          = {}
    Class          = {}
    Skill_All      = {}
    Skill_One      = {}
    Weapon         = {1 => [25]}
    Armor_All      = {}
    Armor_One      = {}
    Level          = {}
    Stat_All       = {}
    Stat_One       = {}
    State_Have_All = {}
    State_Have_One = {}
    State_Dont_All = {}
    State_Dont_One = {}
    Switch_All     = {}
    Switch_One     = {}
    Variable_All   = {}
    Variable_One   = {}
    #---------------------------------------------------------------------
    # * Can Use? Test
    #---------------------------------------------------------------------
    def self.can_use?(actor, object_id = 0)
      # Return False If Skills Doesn't Exist
      return false if $data_skills[object_id].nil?
      # Return Test For All Requirements
      return EIS_Requirements.can_use?(actor, object_id, self)
    end
  end

  #--------------------------------------------------------------------------
  # * Requirements Test
  #--------------------------------------------------------------------------
  def self.can_use?(actor, object_id, sub_module)
    # Actor Test
    if (c = sub_module::Actor).has_key?(object_id)
      return false unless self.is_actor?(actor.id, c[object_id])
    elsif c.has_key?(0)
      return false unless self.is_actor?(actor.id, c[0])
    end
    # Class Test
    if (c = sub_module::Class).has_key?(object_id)
      return false unless self.is_class?(actor.class_id, c[object_id])
    elsif c.has_key?(0)
      return false unless self.is_class?(actor.class_id, c[0])
    end
    # All Skills Test
    if (c = sub_module::Skill_All).has_key?(object_id)
      return false unless self.has_all_skills?(actor.skills, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_all_skills?(actor.skills, c[0])
    end
    # One Skill Test
    if (c = sub_module::Skill_One).has_key?(object_id)
      return false unless self.has_one_skill?(actor.skills, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_one_skill?(actor.skills, c[0])
    end
    # Weapon Test
    if (c = sub_module::Weapon).has_key?(object_id)
      return false unless self.has_weapon?(actor.weapon_id, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_weapon?(actor.weapon_id, c[0])
    end
    # Armor All Test
    if (c = sub_module::Armor_All).has_key?(object_id)
      return false unless self.has_all_armors?(actor, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_all_armors?(actor, c[0])
    end
    # Armor One Test
    if (c = sub_module::Armor_One).has_key?(object_id)
      return false unless self.has_one_armor?(actor, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_one_armor?(actor, c[0])
    end
    # Level Test
    if (c = sub_module::Level).has_key?(object_id)
      return false unless self.is_level?(actor.level, c[object_id])
    elsif c.has_key?(0)
      return false unless self.is_level?(actor.level, c[0])
    end
    # All Stats Test
    if (c = sub_module::Stat_All).has_key?(object_id)
      return false unless self.has_all_stats?(actor, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_all_stats?(actor, c[0])
    end
    # One Stat Test
    if (c = sub_module::Stat_One).has_key?(object_id)
      return false unless self.has_one_stat?(actor, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_one_stat?(actor, c[0])
    end
    # Has All States Test
    if (c = sub_module::State_Have_All).has_key?(object_id)
      return false unless self.has_all_states?(actor.states, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_all_states?(actor.states, c[0])
    end
    # Has One State Test
    if (c = sub_module::State_Have_One).has_key?(object_id)
      return false unless self.has_one_state?(actor.states, c[object_id])
    elsif c.has_key?(0)
      return false unless self.has_one_state?(actor.states, c[0])
    end
    # Doesn't Have Any States Test
    if (c = sub_module::State_Dont_All).has_key?(object_id)
      return false unless self.not_have_any_states?(actor.states, c[object_id])
    elsif c.has_key?(0)
      return false unless self.not_have_any_states?(actor.states, c[0])
    end
    # Doesn't Have One State Test
    if (c = sub_module::State_Dont_One).has_key?(object_id)
      return false unless self.not_have_one_states?(actor.states, c[object_id])
    elsif c.has_key?(0)
      return false unless self.not_have_one_states?(actor.states, c[0])
    end
    # All Switches Test
    if (c = sub_module::Switch_All).has_key?(object_id)
      return false unless self.all_switches?(c[object_id])
    elsif c.has_key?(0)
      return false unless self.all_switches?(c[0])
    end
    # One Switch Test
    if (c = sub_module::Switch_One).has_key?(object_id)
      return false unless self.one_switch?(c[object_id])
    elsif c.has_key?(0)
      return false unless self.one_switch?(c[0])
    end
    # All Variables Test
    if (c = sub_module::Variable_All).has_key?(object_id)
      return false unless self.all_variables?(c[object_id])
    elsif c.has_key?(0)
      return false unless self.all_variables?(c[0])
    end
    # One Variable Test
    if (c = sub_module::Variable_One).has_key?(object_id)
      return false unless self.one_variables?(c[object_id])
    elsif c.has_key?(0)
      return false unless self.one_variables?(c[0])
    end
    # Passes All Test
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Actor
  #--------------------------------------------------------------------------
  def self.is_actor?(actor_id, list = [])
    return list.include?(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Class
  #--------------------------------------------------------------------------
  def self.is_class?(class_id, list = [])
    return list.include?(class_id)
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Skills All
  #--------------------------------------------------------------------------
  def self.has_all_skills?(skills, list = [])
    for skill_id in list
      return false unless skills.include?(skill_id)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Skills One
  #--------------------------------------------------------------------------
  def self.has_one_skill?(skills, list = [])
    for skill_id in list
      return true if skills.include?(skill_id)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Weapon
  #--------------------------------------------------------------------------
  def self.has_weapon?(weapon_id, list = [])
    for id in list
      return true if weapon_id == id
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Armors All
  #--------------------------------------------------------------------------
  def self.has_all_armors?(actor, list = [])
    armors = [1, 2, 3, 4].collect! { |x| eval "actor.armor#{x}_id" }
    for armor_id in list
      return false unless armors.include?(armor_id)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Armors One
  #--------------------------------------------------------------------------
  def self.has_one_armor?(actor, list = [])
    armors = [1, 2, 3, 4].collect! { |x| eval "actor.armor#{x}_id" }
    for armor_id in list
      return true if armors.include?(armor_id)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Level
  #--------------------------------------------------------------------------
  def self.is_level?(level, parameters)
    return eval "level #{parameters[1]} #{parameters[0]}"
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Stats All
  #--------------------------------------------------------------------------
  def self.has_all_stats?(actor, list = {})
    list.each do |stat_name, parameters|
      unless eval "actor.#{stat_name} #{parameters[1]} #{parameters[0]}"
        return false 
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Stats One
  #--------------------------------------------------------------------------
  def self.has_one_stat?(actor, list = {})
    list.each do |stat_name, parameters|
      if eval "actor.#{stat_name} #{parameters[1]} #{parameters[0]}"
        return true 
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Has States All
  #--------------------------------------------------------------------------
  def self.has_all_states?(states, list = [])
    for state_id in list
      return false unless states.include?(state_id)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Has States One
  #--------------------------------------------------------------------------
  def self.has_one_state?(states, list = [])
    for state_id in list
      return true if states.include?(state_id)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Not Have States All
  #--------------------------------------------------------------------------
  def self.not_have_any_states?(states, list = [])
    for state_id in list
      return false if states.include?(state_id)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Not Have States One
  #--------------------------------------------------------------------------
  def self.not_have_one_state?(states, list = [])
    for state_id in list
      return true unless states.include?(state_id)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Switches All
  #--------------------------------------------------------------------------
  def self.all_switches?(list = {})
    list.each do |switch_id, state|
      return false unless $game_switches[switch_id] == state
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Switches One
  #--------------------------------------------------------------------------
  def self.one_switch?(list = {})
    list.each do |switch_id, state|
      return true if $game_switches[switch_id] == state
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Variables All
  #--------------------------------------------------------------------------
  def self.all_variables?(list = {})
    list.each do |variable_id, parameters|
      unless eval ("$game_variables[#{variable_id}] #{parameters[1]} " +
                   "#{parameters[0]}")
        return false 
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Requirements Test : Variables One
  #--------------------------------------------------------------------------
  def self.one_variables?(list = {})
    list.each do |variable_id, parameters|
      if eval ("$game_variables[#{variable_id}] #{parameters[1]} " +
                   "#{parameters[0]}")
        return true 
      end
    end
    return true
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias seph_eisreqs_gmpty_icu? item_can_use?
  #--------------------------------------------------------------------------
  # * Determine if Item is Usable
  #--------------------------------------------------------------------------
  def item_can_use?(item_id)
    # If Can Normally Use
    if seph_eisreqs_gmpty_icu?(item_id)
      # If In Battle
      if $game_temp.in_battle
        # Retrieves Current Actor Using Item
        actor = $scene.active_battler
        # Return EIS Requirements Results
        return EIS_Requirements::Items.can_use?(actor, item_id)
      end
      return true
    end
    # Return Cannot
    return false
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias seph_eisreqs_gmactr_equippable? equippable?
  alias seph_eisreqs_gmactr_scu?        skill_can_use?
  #--------------------------------------------------------------------------
  # * Determine if Equippable
  #--------------------------------------------------------------------------
  def equippable?(item)
    # If Weapon
    if item.is_a?(RPG::Weapon)
      unless EIS_Requirements::Equipment::Weapons.can_equip?(self, item.id)
        return false
      end
    # If Armor
    elsif item.is_a?(RPG::Armor)
      unless EIS_Requirements::Equipment::Armors.can_equip?(self, item.id)
        return false
      end
    end
    # Return Original Test
    return seph_eisreqs_gmactr_equippable?(item)
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill can be Used
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    # If Passes EIS Requirements
    if EIS_Requirements::Skills.can_use?(self, skill_id)
      # Return Original Test
      return seph_eisreqs_gmactr_scu?(skill_id)
    end
    # Return Cannot Use
    return false
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================

class Scene_Battle
  attr_reader :active_battler
end