#==============================================================================
# Add-On: Enemy Animated Battlers
#==============================================================================
# This Add-On allows the usage of animated graphics for the enemies, just like
# the characters.
#
# You must add the Enemy's ID to ENEMY_ID = []
#
# You might need to readjust the Enemy's position or it's shadow's
# So that graphics stay perfectly alligned
# this can be done here or on the "SBL | Configuration" script
# You will need a graphic with the same name on the Graphics/Battler folder
# and on the Graphics/Characters folder.
#==============================================================================

module ENEMY_ANIME_BATTLERS
  ENEMY_ID = [1,33,34] # IDs of the enemies that will have animated sprites
end

class Game_Enemy < Game_Battler
  #==============================================================================
  # Enemy's Position Readjustment
  #==============================================================================
  alias position_plus_animb_n01 position_plus
  def position_plus
    case @enemy_id
    when 1
      return [0, 0]
#   when ID_do_Inimigo  # ID of the enemy
#     return [ X, Y ]   # Adjustment of the enemy's position
    end
    position_plus_animb_n01
  end
  
  #==============================================================================
  # Enemy's Shadow's Graphic Change
  #==============================================================================
  alias shadow_animb_n01 shadow
  def shadow
    case @enemy_id
    when 33, 34
      return "shadow00"
#   when ID_do_Inimigo   # ID of the enemy
#     return "shadow00"  # New graphic for the enemy's shaodw 
    end
    shadow_animb_n01
  end 
  
  #==============================================================================
  # Readjustment of the Enemy's Shadow Position
  #==============================================================================
  alias shadow_plus_animb_n01 shadow_plus
  def shadow_plus
    case @enemy_id
    when 1, 33, 34
      return [ 0, 8]
#   when ID_do_Inimigo  # ID of the enemy 
#     return [ X, Y ]   # Adjustment of the shadow's position
    end
    shadow_plus_animb_n01
  end 
  
#==============================================================================
# End of the Editable Part
#==============================================================================
  alias anime_on_animb_n01 anime_on
  def anime_on
    return true if ENEMY_ANIME_BATTLERS::ENEMY_ID.include?(@enemy_id)
    anime_on_animb_n01
  end
  alias action_mirror_animb_n01 action_mirror
  def action_mirror
    return true if ENEMY_ANIME_BATTLERS::ENEMY_ID.include?(@enemy_id)
    action_mirror_animb_n01
  end
end