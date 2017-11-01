#==============================================================================
# Add-On: Triple Attack
# Criado por Kylock em 10/05/2008
#==============================================================================
# This Add-On creates a new animation sequence for the VX orginal skill 
# "Triple Attack".
#==============================================================================

module N01
  # Creates a new Sequence
  new_action_sequence = {
  "TRIPLE_ATTACK" => ["PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","WAIT(FIXED)","16",
                      "PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","WAIT(FIXED)","16",
                      "PREV_STEP_ATTACK","WPN_SWING_VL","OBJ_ANIM_WEAPON","Can Collapse","COORD_RESET"],}
  # Unites the new sequence to the system
  ACTION.merge!(new_action_sequence)
end

module RPG
  class Skill
    alias k_triple_attack_base_action base_action
    def base_action
      if @id == 107
        return "TRIPLE_ATTACK"
      end
      k_triple_attack_base_action
    end
    alias k_triple_attack_extension extension
    def extension
      if @id == 107
        return ["RANDOMTARGET"]
      end
      k_triple_attack_extension
    end
  end
end