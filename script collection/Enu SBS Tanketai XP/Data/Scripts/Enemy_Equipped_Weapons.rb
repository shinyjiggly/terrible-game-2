#==============================================================================
# Add-On: Enemy's Weapon
#==============================================================================
# This Add-On allows you to add weapons to the enemies, this way, the weapon's
# animation will be used when the enemy attacks.
# All though it's possible to configurate this on the "SBL | Configuration"
# script, this mod was made to make the management of this feature easier.
#
# To add an weapon to an enemy, go to "case @enemy_id"
# and add the enemy's ID and the weapon's with this format:
#    when 33 #ID of the enemy
#      return 1 #ID of the weapon
#==============================================================================

#==============================================================================
# Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  alias enemy_weapon_n01 weapon
  def weapon
    case @enemy_id
    when 33     # ID of the Enemy
      return 1  # ID of the Weapon
    when 34
      return 21
   # Add more enemy's with weapons following the same pattern:
   # when X     # X = ID of the Enemy
   #   return Y # Y = ID of the Weapon
    end
    enemy_weapon_n01
  end 
end