#==============================================================================
# Add-On: Throw
# by Epinor Flamblade
# Based on the VX Add-Ons created by Mr. Bubble, Kylock and Atoa.
#==============================================================================
# With this script, you can set throw skills/weapons.
# They can be of 3 different types: throw spin (lika a boomerang), only spin
# (like a shuriken), or straight (like throwing daggers).
# To use this script, verify if your throw weapons have one of the 
# throw attributes.
#==============================================================================

module N01
  
  # Element for the weapon/skill that has the Throw Animation
  THROW_RETURN_WEAPON = 20
  THROW_SPIN_WEAPON = 21
  THROW_WEAPON = 22
  
  # Attack Animation
  THROW_ANIME = {
  "START_WEAPON_THROW_NORETURN" => ["m_a", 0, 0, 0, 18, 0, 0, 0, 0,false,"WPN_ROTATION"],
  "START_WEAPON_THROW_NOSPIN" => ["m_a", 0, 0, 0, 18, 0, 0, 0, 0,false,"WPN_HURLED"],
  "WPN_HURLED" => [45, 45, 8],}
  ANIME.merge!(THROW_ANIME)
  # Action Sequence
  THROW_ATTACK_ACTION = {
  "THROW_SPIN_ATTACK"=> ["BEFORE_MOVE","WPN_SWING_V","absorb1","WAIT(FIXED)",
  "START_WEAPON_THROW_NORETURN","12","OBJ_ANIM_WEAPON","Can Collapse",
  "COORD_RESET"],
  "THROW_ATTACK" => ["BEFORE_MOVE","absorb1","WAIT(FIXED)",
  "START_WEAPON_THROW_NOSPIN","12","OBJ_ANIM_WEAPON","Can Collapse",
  "COORD_RESET"],}
  ACTION.merge!(THROW_ATTACK_ACTION)
end

class RPG::Weapon
  alias throw_base_action base_action
  def base_action
    if $data_weapons[@id].element_set.include?(N01::THROW_RETURN_WEAPON)
      return "THROW_WEAPON"
    end
    if $data_weapons[@id].element_set.include?(N01::THROW_SPIN_WEAPON)
      return "THROW_SPIN_ATTACK"
    end
    if $data_weapons[@id].element_set.include?(N01::THROW_WEAPON)
      return "THROW_ATTACK"
    end
    throw_base_action
  end
end

class RPG::Skill
  alias throw_base_action base_action
  def base_action
    if $data_skills[@id].element_set.include?(N01::THROW_RETURN_WEAPON)
      return "THROW_WEAPON"
    end
    if $data_skills[@id].element_set.include?(N01::THROW_SPIN_WEAPON)
      return "THROW_SPIN_ATTACK"
    end
    if $data_skills[@id].element_set.include?(N01::THROW_WEAPON)
      return "THROW_ATTACK"
    end
    throw_base_action
  end
end
