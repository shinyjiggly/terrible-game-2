#==============================================================================
# Add-On: Double Attack
# Criado por Kylock em 10/05/2008
#==============================================================================
# This Add-On creates a new animation sequence for the VX orginal skill 
# "Double Attack".
#==============================================================================

module N01
  # Creates a new Sequence
  new_action_sequence = {
  "DOUBLE_ATTACK" => ["PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","WAIT(FIXED)","16",
                      "PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","Can Collapse","COORD_RESET"],}
  # Unites the new sequence to the system
  ACTION.merge!(new_action_sequence)
end

module RPG
  class Skill
    alias k_double_attack_base_action base_action
    def base_action
      if @id == 106 
        return "DOUBLE_ATTACK"
      end
      k_double_attack_base_action
    end
    alias k_double_attack_extension extension
    def extension
      if @id == 106
        return ["RANDOMTARGET"]
      end
      k_double_attack_extension
    end
  end
end