#==============================================================================
# Damage Limit
# by Atoa
#==============================================================================
# This Add-On allows you to set an max limite for the amount of damage caused
# by an action, like in Final Fantasy series, where max damage was 9999.
# You can set skill, weapons or even set this feature for an enemy or actor. 
# To set this to enemies, skills or weapons, just add their IDs in the 'module Atoa'
# just like in the examples.
#
# With character, the process is different, make an Script Call and add this
# line to it:
# $game_actors[ID].damage_limit = X
# 
# ID = actor ID
# X = Limit value
#==============================================================================

module Atoa
  # Do not remove these lines
  Damage_Limit = {'Skill' => {}, 'Item' => {}, 'Weapon' => {}, 'Enemy' => {}}
  # Do not remove these lines
  
  # Base damage Limit
  Base_Limit = 9999
  
  # Damage Limit for Skills
  # Damage_Limit['Skill'][Skill_ID] = Limit_Value
  Damage_Limit['Skill'][60] = 99999
  Damage_Limit['Skill'][64] = 99999
  Damage_Limit['Skill'][68] = 99999
  Damage_Limit['Skill'][72] = 99999
  Damage_Limit['Skill'][76] = 99999
  Damage_Limit['Skill'][86] = 99999
  
  # Damage Limit for Weapons
  # Damage_Limit['Weapon'][Weapon_ID] = Limit_Value
  Damage_Limit['Weapon'][4] = 99999
  Damage_Limit['Weapon'][8] = 99999
  Damage_Limit['Weapon'][12] = 99999
  Damage_Limit['Weapon'][16] = 99999
  Damage_Limit['Weapon'][20] = 99999
  Damage_Limit['Weapon'][24] = 99999
  Damage_Limit['Weapon'][28] = 99999
  Damage_Limit['Weapon'][32] = 99999
  
  # Damage Limit for Enemies
  # Damage_Limit['Enemy'][Enemy_ID] = Limit_Value
  Damage_Limit['Enemy'][31] = 99999
  Damage_Limit['Enemy'][32] = 99999
  
  # Damage Limit for Items
  # Damage_Limit['Item'][Enemy_ID] = Limit_Value
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :damage_limit
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_dmg_limit setup
  def setup(actor_id)
    setup_dmg_limit(actor_id)
    @damage_limit = Base_Limit
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
  # * Get Damage Limit
  #--------------------------------------------------------------------------
  def damage_limit
    return Damage_Limit['Enemy'][@enemy_id] if Damage_Limit['Enemy'][@enemy_id] != nil
    return Base_Limit
  end
end
 
#==============================================================================
# ** RPG::Weapon
#------------------------------------------------------------------------------
# Class that manage weapons
#==============================================================================

class RPG::Weapon
  #--------------------------------------------------------------------------
  # * Get Damage Limit
  #--------------------------------------------------------------------------
  def damage_limit
    return Damage_Limit['Weapon'][@id] if Damage_Limit['Weapon'][@id] != nil
    return Base_Limit
  end
end

#==============================================================================
# ** RPG::Skill
#------------------------------------------------------------------------------
# Class that manage skills
#==============================================================================

class RPG::Skill
  #--------------------------------------------------------------------------
  # * Get Damage Limit
  #--------------------------------------------------------------------------
  def damage_limit
    return Damage_Limit['Skill'][@id] if Damage_Limit['Skill'][@id] != nil
    return Base_Limit
  end
end

#==============================================================================
# ** RPG::Item
#------------------------------------------------------------------------------
# Class that manage items
#==============================================================================

class RPG::Item
  #--------------------------------------------------------------------------
  # * Get Damage Limit
  #--------------------------------------------------------------------------
  def damage_limit
    return Damage_Limit['Item'][@id] if Damage_Limit['Item'][@id] != nil
    return Base_Limit
  end
end