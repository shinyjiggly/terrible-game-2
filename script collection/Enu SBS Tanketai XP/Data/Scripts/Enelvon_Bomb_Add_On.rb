#==============================================================================
# ■ Bomb Weapons 1.0 for RPG Tankentai Sideview Battle System
# 8.23.2008
#------------------------------------------------------------------------------
# Written by Enelvon Siolach
#==============================================================================
# This script makes all weapons with the Bomb element (default Element ID #23)
# have an animation where they throw a bomb at the foe.
#==============================================================================
# ■ Release Notes
#------------------------------------------------------------------------------
# 1.0
# ● Original Release.
#==============================================================================
# ■ Installation Notes
#------------------------------------------------------------------------------
# Plug and play. Set the BOMB_ELEMENT to the Element ID of Sworddash. Add
# BOMB to your Bomb weapons and give them an explosion animation from the
# Database, and you're done!
#==============================================================================

module N01
  # Element used to define a skill as a Bomb skill
  BOMB_ELEMENT = 23
  
  # Action Sequence
  BOMB_ATTACK_ACTION = {
  "BOMB_THROW" => ["BEFORE_MOVE","WPN_SWING_OVER","absorb1","WAIT(FIXED)",
  "START_WEAPON_THROW","12","OBJ_ANIM_WEIGHT","Can Collapse",
  "COORD_RESET"],}
  ACTION.merge!(BOMB_ATTACK_ACTION)
end

class RPG::Skill
  alias enelvon_bomb_base_action base_action
  def base_action
    # If the Bomb Element is checked on the skills tab in the database,
    # the Bomb attack action sequence is used.
    if $data_skills[@id].element_set.include?(N01::BOMB_ELEMENT)
      return "BOMB_THROW"
    end
    enelvon_bomb_base_action
  end
end

class RPG::Weapon
  alias enelvon_bomb_weapon_base_action base_action
  def base_action
    # If the Bomb Element is checked on the skills tab in the database,
    # the Bomb attack action sequence is used.
    if $data_weapons[@id].element_set.include?(N01::BOMB_ELEMENT)
      return "BOMB_THROW"
    end
    enelvon_bomb_weapon_base_action
  end
end

