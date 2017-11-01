#==============================================================================
# Add-On: Guns 1.1
# by Kylock
#------------------------------------------------------------------------------
# This Add-On allows you to use additional animations for guns. 
# To use this script, verify if your guns have the attribute with the same 
# ID as GUN_ELEMENT in the weapon's tab of your database.
#==============================================================================

module N01
  # Element for the weapon/skill that has the Gun Animation
  GUN_ELEMENT = 18
  
  # Attack Animation
  RANGED_ANIME = {
   "GUNSHOT" => ["sound", "se",  100, 100, "close1"],}
  ANIME.merge!(RANGED_ANIME)
  # Action Sequence
  RANGED_ATTACK_ACTION = {
    "GUN_ATTACK" => ["JUMP_AWAY","WPN_SWING_V","30","GUNSHOT","WPN_SWING_V",
        "OBJ_ANIM_WEIGHT","12","WPN_SWING_VL","OBJ_ANIM_L","One Wpn Only",
        "16","Can Collapse","JUMP_TO","COORD_RESET"],}
  ACTION.merge!(RANGED_ATTACK_ACTION)
end

class RPG::Weapon
  alias kylock_guns_base_action base_action
  def base_action
    # If the "Gun" attribute is marked on the weapon's element, 
    # the new attack sequence is used
    if $data_weapons[@id].element_set.include?(N01::GUN_ELEMENT)
      return "GUN_ATTACK"
    end
    kylock_guns_base_action
  end
end

class RPG::Skill
  alias kylock_sguns_base_action base_action
  def base_action
    # If the "Gun" attribute is marked on the weapon's element, 
    # the new attack sequence is used
    if $data_skills[@id].element_set.include?(N01::GUN_ELEMENT)
      return "GUN_ATTACK"
    end
    kylock_sguns_base_action
  end
end
