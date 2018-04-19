#_________________________________________________
# MOG_Scroll Panorama V1.4            
#_________________________________________________
# By Moghunter  
# http://www.atelier-rgss.com
#_________________________________________________
# Movimenta os panoramas na horizontal e na vertical.
# Fade Mode.
# Movimentos aleatórios.
#_________________________________________________
module MOG
# ID variable that defines the speed horizontally.
VARPANO_X = 8
# ID variable that defines the speed vertically.
VARPANO_Y = 9 
# Switch ID that activates the Fade Mode.
PANO_FADE_MODE_SWITCHE_ID = 4 #SWITCH ID 
# Speed ​​Fade.
PANO_FADE_SPEED = 3 

# Switch ID that activates the Random Mode.
# The picture moves in random directions.
PAN_RAND_MOVE_SWITCHE_ID = 5  #SWITCH ID 
# Time to change direction.
PAN_RAND_TIME = 2  #SWITCH ID 
# Switche ID that leaves the FOG with low priority.
FOG_Z_SWITCH_ID = 16
#
FOG_MOTION_SWITCH_ID = 17
end

#===============================================================================
# Game_Map
#===============================================================================
class Game_Map
  attr_reader   :pan_ox                  
  attr_reader   :pan_oy 
  attr_accessor :panorama_opacity
#--------------------------------------------------------------------------
# Setup
#--------------------------------------------------------------------------  
alias mog10_setup setup  
def setup(map_id)
  @pan_ox = 0
  @pan_oy = 0   
  @opa_loop = 0
  @pan_rand_scroll_x = 0
  @pan_rand_scroll_y = 0
  @rand_time_x = 0
  @rand_time_y = 0
  @panorama_opacity = 0
  mog10_setup(map_id)
end
#--------------------------------------------------------------------------
# Update
#--------------------------------------------------------------------------
alias mog10_update update
def update
  if $game_switches[MOG::PANO_FADE_MODE_SWITCHE_ID] == true
    if @opa_loop == 0
    @panorama_opacity -= MOG::PANO_FADE_SPEED
    elsif @opa_loop == 1
    @panorama_opacity += MOG::PANO_FADE_SPEED 
    end
    if @panorama_opacity < 1
    @opa_loop = 1
    elsif @panorama_opacity > 254
    @opa_loop = 0  
    end
  else
  @panorama_opacity = 255 
  end
  if $game_switches[MOG::PAN_RAND_MOVE_SWITCHE_ID] == true 
      @rand_time_x += 1
      @rand_time_y += 1
    if @rand_time_x > 40 * MOG::PAN_RAND_TIME
    @rand_time_x = 0
      case rand(2)
      when 0
        @pan_rand_scroll_x = 0 
      when 1
        @pan_rand_scroll_x = 1
      end
    end
    if @rand_time_y > 40 * MOG::PAN_RAND_TIME
    @rand_time_y = 0
      case rand(2)
      when 0
        @pan_rand_scroll_y = 0 
      when 1
        @pan_rand_scroll_y = 1 
      end
    end
    if @pan_rand_scroll_x == 0 
      @pan_ox -= $game_variables[MOG::VARPANO_X] 
    else 
      @pan_ox += $game_variables[MOG::VARPANO_X]   
    end 
    if @pan_rand_scroll_y == 0 
      @pan_oy -= $game_variables[MOG::VARPANO_Y]  
    else @pan_rand_scroll_y == 1
      @pan_oy += $game_variables[MOG::VARPANO_Y]     
    end   
  else
    @pan_ox -= $game_variables[MOG::VARPANO_X] 
    @pan_oy -= $game_variables[MOG::VARPANO_Y]
  end
mog10_update
end
end

#===============================================================================
# Spriteset_Map
#===============================================================================
class Spriteset_Map
#--------------------------------------------------------------------------
# Update
#--------------------------------------------------------------------------  
  alias mog10_update update
  def update
    mog10_update
    @panorama.ox = $game_map.display_x / 8 + $game_map.pan_ox
    @panorama.oy = $game_map.display_y / 8 + $game_map.pan_oy
    @panorama.opacity = $game_map.panorama_opacity
    if $game_switches[MOG::FOG_Z_SWITCH_ID] == true 
        @fog.z = -500 
    else
        @fog.z = 3000
    end        
    if $game_switches[MOG::FOG_MOTION_SWITCH_ID] == true
        @fog.ox = $game_map.display_x / 3 + $game_map.fog_ox
        @fog.oy = $game_map.display_y / 3 + $game_map.fog_oy        
    else
        @fog.ox = $game_map.display_x / 4 + $game_map.fog_ox
        @fog.oy = $game_map.display_y / 4 + $game_map.fog_oy        
    end    
  end  
end

$mog_rgss_scroll_panorama = true
