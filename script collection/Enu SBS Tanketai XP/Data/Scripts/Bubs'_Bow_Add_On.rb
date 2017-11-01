#==============================================================================
# ■ Bow Attack Animation Sequence for RPG Tankentai SBS
#     1.3.09
#------------------------------------------------------------------------------
#  Script by Mr. Bubble with basis from Kylock's Bow Addon
#==============================================================================
#   Adds a new bow animation which allows for a much smoother arrow animation
# compared to Kylock's Bow Addon.  This script is designed not to have conflicts
# with Kylock's Bow Addon in case you want to use both.
#
#   Updated for proper arrow animation in mirrored back attacks.
#==============================================================================
# ■ How to Install
#------------------------------------------------------------------------------
# - Requires Animation 102 from the demo placed in the same ID in your project.
# - Requires "woodarrow.png" in .Graphics\Characters.
#==============================================================================

module N01
  # Weapon element that grants a bow animation.
  BOW_WEAPON_ELEMENT = 17
  
  # Attack Animation Actions
  BOW_ANIME = {
    "DRAW_POSE"   => [ 0,  1,  1,   2,   0,  -1,   0, true,"" ],
    "DRAW_BOW"    => ["anime",  102,  0, false, false, false],
    "ARROW_ANGLE" => [ 30, 60,  11],
    "SHOOT_ARROW" => ["m_a", 0,  0,   0, 15,  -10,  0, 0, 0,false,"ARROW_ANGLE"],
    
    # Back attack single-actions.
    "SHOOT_ARROW(BA)" => ["m_a", 0,  0,   0, 15,  -10,  0, 0, 0,false,"ARROW_ANGLE(BA)"],
    "ARROW_ANGLE(BA)" => [ 325, 305,  11],
    }
  ANIME.merge!(BOW_ANIME)
  # Action Sequence
  BOW_ATTACK_ACTION = {
    # Normal sequence
    "NEW_BOW_ATTACK" => ["BEFORE_MOVE","DRAW_BOW", "DRAW_POSE", "5", 
                        "SHOOT_ARROW", "12","OBJ_ANIM","16",
                        "Can Collapse","FLEE_RESET"],
                        
    # Back attack sequence
    "NEW_BOW_ATTACK(BA)" => ["BEFORE_MOVE","DRAW_BOW", "DRAW_POSE", "5", 
                        "SHOOT_ARROW(BA)", "12","OBJ_ANIM","16",
                        "Can Collapse","FLEE_RESET"],
}
  ACTION.merge!(BOW_ATTACK_ACTION)
end

class RPG::Weapon
  alias bubs_bow_base_action base_action
  def base_action
    # If "Bow" Element is checked on the weapons tab in the database,
    #  the new ranged attack action sequence is used.
    if $data_weapons[@id].element_set.include?(N01::BOW_WEAPON_ELEMENT) and $back_attack
      return "NEW_BOW_ATTACK(BA)" # Back attack
    elsif $data_weapons[@id].element_set.include?(N01::BOW_WEAPON_ELEMENT)
      return "NEW_BOW_ATTACK" # Normal
    end
    bubs_bow_base_action
  end
  alias bubs_bow_flying_graphic flying_graphic
  def flying_graphic
    if $data_weapons[@id].element_set.include?(N01::BOW_WEAPON_ELEMENT)
      return "woodarrow"
    end
    bubs_bow_flying_graphic
  end
end

class RPG::Skill
  alias bubs_bow_base_action base_action
  def base_action
    # If "Bow" Element is checked on the weapons tab in the database,
    #  the new ranged attack action sequence is used.
    if $data_skills[@id].element_set.include?(N01::BOW_WEAPON_ELEMENT) and $back_attack
      return "NEW_BOW_ATTACK(BA)" # Back attack
    elsif $data_skills[@id].element_set.include?(N01::BOW_WEAPON_ELEMENT)
      return "NEW_BOW_ATTACK" # Normal
    end
    bubs_bow_base_action
  end
  alias bubs_bow_flying_graphic flying_graphic
  def flying_graphic
    if $data_skills[@id].element_set.include?(N01::BOW_WEAPON_ELEMENT)
      return "woodarrow"
    end
    bubs_bow_flying_graphic
  end
end
