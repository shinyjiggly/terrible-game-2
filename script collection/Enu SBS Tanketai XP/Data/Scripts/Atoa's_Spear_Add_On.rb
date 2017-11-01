#==============================================================================
# Add-On: Spear
# by Atoa
#------------------------------------------------------------------------------
# This script allows you to use additional animations for piercing weapons. 
# To use this script, verify if your piercing weapons have the attribute with the same 
# ID as SPEAR_ELEMENT in the weapon's tab of your database.
#==============================================================================

module N01
  # Element for the weapon/skill that has the Spear Animation
  SPEAR_ELEMENT = 19
  
  # Attack Animation
  SPEAR_ANIME = {
    "SPEAR_SWING" => [ 0, 1, 1, 2, 0, -1, 2,true,"PIERCE"],
    "SPEAR_SWINGL"=> [ 0, 1, 1, 2, 0, -1, 2,true,"PIERCEL"],
    "PIERCE"      => [-32, 0,false,45, 45, 1,false, 1, 1,-4, -6,false],
    "PIERCEL"     => [ -16, 0,false,45, 45, 1,false, 1, 1, -32, -6, true],}
  ANIME.merge!(SPEAR_ANIME)
  # Action Sequence
  SPEAR_ATTACK_ACTION = {
    "SPEAR_ATTACK"=> ["PREV_MOVING_TARGET","SPEAR_SWING","OBJ_ANIM_WEIGHT",
                      "12","SPEAR_SWINGL","OBJ_ANIM_L","Two Wpn Only","16",
                      "Can Collapse","FLEE_RESET"],}
  ACTION.merge!(SPEAR_ATTACK_ACTION)
end

class RPG::Weapon
  alias atoa_spear_base_action base_action
  def base_action
    # If the "Spear" attribute is marked on the weapon's element, 
    # the new attack sequence is used
    if $data_weapons[@id].element_set.include?(N01::SPEAR_ELEMENT)
      return "SPEAR_ATTACK"
    end
    atoa_spear_base_action
  end
end

class RPG::Skill
  alias atoa_spear_base_action base_action
  def base_action
    # If the "Spear" attribute is marked on the weapon's element, 
    # the new attack sequence is used
    if $data_skills[@id].element_set.include?(N01::SPEAR_ELEMENT)
      return "SPEAR_ATTACK"
    end
    atoa_spear_base_action
  end
end
