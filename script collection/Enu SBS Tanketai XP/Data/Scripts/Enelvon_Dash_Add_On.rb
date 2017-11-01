#==============================================================================
# ■ Dash Skill/Weapon 1.2 for RPG Tankentai Sideview Battle System
# Released up on 9.28.2008
#------------------------------------------------------------------------------
# Written by Enelvon Siolach
#==============================================================================
# This script makes all weapons and skills with the Dash element, default 23,
# have a dash strike through the enemy as their attack.
#==============================================================================
# ■ Release Notes
#------------------------------------------------------------------------------
# 1.0
# ● Original Release.
# 1.1
# ● Added support for the skill animation.
# 1.2
# ● Fixed a bug with the skill animation.
#==============================================================================
# ■ Installation Notes
#------------------------------------------------------------------------------
# Plug and play. Set the DASH_ELEMENT to the Element ID of Dash. Add
# Dash to your Dash skills/weapons, and you're done!
#==============================================================================

module N01
  # Element used to define a skill as a Dash skill
  DASH_SKILL = 24 # the skill will have the magic animation before the dash
  DASH_ATTACK = 25 # the skill will have same as the weapon dash animation.
  # For weapons, both elemets will have the same effect
  
  # Action Sequence
  DASH_ATTACK_ACTION = {
  "DASH_SKILL" => ["START_MAGIC_ANIM","24","JUMP_TO_TARGET","JUMP_AWAY","4","DASH_ATTACK","OBJ_ANIM_WEIGHT",
  "One Wpn Only","16","Can Collapse","COORD_RESET"],
  "DASH_ATTACK" => ["JUMP_TO_TARGET","JUMP_AWAY","4","DASH_ATTACK","OBJ_ANIM_WEIGHT","One Wpn Only","16","Can Collapse","COORD_RESET"],}
  ACTION.merge!(DASH_ATTACK_ACTION)
end


class RPG::Skill
  alias enelvon_dash_base_action base_action
  def base_action
    # If the Dash Element is checked on the skills tab in the database,
    # the Dash attack action sequence is used.
    if $data_skills[@id].element_set.include?(N01::DASH_SKILL)
      return "DASH_SKILL"
    elsif $data_skills[@id].element_set.include?(N01::DASH_ATTACK)
      return "DASH_ATTACK"
    end
    enelvon_dash_base_action
  end
end

class RPG::Weapon
  alias enelvon_dash_weapon_base_action base_action
  def base_action
    # If the Dash Element is checked on the weapons tab in the database,
    # the Dash attack action sequence is used.
    if $data_weapons[@id].element_set.include?(N01::DASH_SKILL) or
       $data_weapons[@id].element_set.include?(N01::DASH_ATTACK)
      return "DASH_ATTACK"
    end
    enelvon_dash_weapon_base_action
  end
end
