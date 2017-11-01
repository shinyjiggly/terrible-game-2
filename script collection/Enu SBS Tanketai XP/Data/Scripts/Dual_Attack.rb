#==============================================================================
# Add-On: Dual Attack
# by Kylock: 5/10/2008
#==============================================================================
# This Add-On creates a new animation sequence for the VX orginal skill 
# "Dual Attack".
#==============================================================================

module N01
  # Creates a new Sequence
  new_action_sequence = {
  "DUAL_ATTACK" => ["PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","WAIT(FIXED)","16",
                      "PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","Can Collapse","COORD_RESET"],}
  # Unites the new sequence to the system
  ACTION.merge!(new_action_sequence)
end

module RPG
  class Skill
    alias k_dual_attack_base_action base_action
    def base_action
      if @id == 105
        return "DUAL_ATTACK"
      end
      k_dual_attack_base_action
    end
  end
end