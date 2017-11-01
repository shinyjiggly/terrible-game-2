#==============================================================================
# Atoa Custom Battle System / Battle Camera / GW Animated Battlebacks Patch
# GW Animated Battlebacks by Gabriel Winchester
#
# Tha battleback script must be added bellow the battle main code,
# and above the Battle Camera, the patch must be bellow the Battle Camera
#
# The script can be found at: (in Brazillian Portuguese)
# http://www.santuariorpgmaker.com/forum/index.php?topic=6336
#==============================================================================

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within
#  the Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Zoom Update
  #--------------------------------------------------------------------------
  alias gw_bb_zoom_update zoom_update
  def zoom_update
    gw_bb_zoom_update
    if @animbb != nil
      @animbb.zoom_x = @zoom_value
      @animbb.zoom_y = @zoom_value
      @animbb.x = @zoom_adj_x - ($game_temp.center_adj_x / 2)
      @animbb.y = @zoom_adj_y - ($game_temp.center_adj_y / 2)
    end
    if @upperbb != nil
      @upperbb.zoom_x = @zoom_value
      @upperbb.zoom_y = @zoom_value
      @upperbb.x = @zoom_adj_x - ($game_temp.center_adj_x / 2)
      @upperbb.y = @zoom_adj_y - ($game_temp.center_adj_y / 2)
    end
  end
end