#==============================================================================
# Add-On: Stationary Enemies
# Created by Kylock:  5/11/2008
#==============================================================================
# This Add-On allows you to created movementless enemies. Add in the array 
# below the enemies that you wish to not move during the battles. After,
# created a new weapon with the attack animation the enemies will have.
#==============================================================================

module K_STATIONARY_ENEMY
  ENEMY_ID = [36, 37, 38, 39] # List of movementless enemies
  WEAPON_ID = 34 # ID of the newly created weapon
  ELEMNT_ID = 20 # ID of the element used for movementless skills
end

module N01
  # Create a new sequence
  new_action_sequence = {
  "DONT_MOVE" => ["WPN_SWING_V","OBJ_ANIM_WEIGHT","Can Collapse","FLEE_RESET"],}
  # Unites the new sequence to the system
  ACTION.merge!(new_action_sequence)
end

class Game_Enemy < Game_Battler
  alias k_stationary_enemy_weapon weapon
  def weapon
    return K_STATIONARY_ENEMY::WEAPON_ID if K_STATIONARY_ENEMY::ENEMY_ID.include?(@enemy_id)
    k_stationary_enemy_weapon
  end 
end

class RPG::Weapon
  alias k_stationary_enemy_base_action base_action
  def base_action
    return "DONT_MOVE" if @id == K_STATIONARY_ENEMY::WEAPON_ID
    k_stationary_enemy_base_action
  end
end

class RPG::Skill
  alias k_stationary_enemy_skilk_base_action base_action
  def base_action
    return "DONT_MOVE" if $data_skills[@id].element_set.include?(K_STATIONARY_ENEMY::ELEMNT_ID)
    k_stationary_enemy_skilk_base_action
  end
end