#---------------------------------------
#   Focus Radius
#       by shinyjiggly
#---------------------------------------
#
# What this does:
#
# this script makes events that are a certain distance away 
# from the player lower in opacity. 
# This certain distance can be controlled in real-time.
#
#----------------------------------------------------
=begin
class Game_Event < Game_Character

  alias refresh_opacity refresh
  def refresh_opacity
    
    #radmin= the minimum radius
    
    if $game_switches[5] or x_distance^2 + y_distance^2 < radmin^2 or 
      #if the switch is on or it's close enough
      @opacity = @page.graphic.opacity #
      else
      
      
      end
    
    
  fuck this
  
  end
  
end
=end