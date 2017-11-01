#====================================================================#
#  #*****************#           Allow you animate battlers graphics #    
#  #*** By Falcao ***#           during the battle process           #          
#  #*****************#                                               #
#         RMVX                   Intrucciones: Copy and paste the    #
# makerpalace.onlinegoo.com      script to your project              #  
#====================================================================#
 
 
module Falcao
 
# Animate actor battlers change true or false  
IncludeActors = false
 
end
 
class Game_Battler
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  alias falcaoB_zoom_ini initialize
  def initialize
    falcaoB_zoom_ini
    @zoom_x = 1.0
    @zoom_y = 1.0
    @zoom_time = 0
    @actor_breath = 0
  end
  def zoom(x,y)
    self.zoom_x = x
    self.zoom_y = y
  end
 
  def zoom_plus(x,y)
    self.zoom_x += x
    self.zoom_y += y
  end
  def zoom_less(x,y)
    self.zoom_x -= x
    self.zoom_y -= y
  end
 
  def breath
    @zoom_time += 1
    x = 0.002; y = 0.002
    if @zoom_time <= 50
     zoom_plus(x,y)
    end
    if @zoom_time >= 50
      zoom_less(x,y)
      if self.zoom_x <= 1
        zoom(1,1); @zoom_time = 0
      end
    end
  end
 
  def breath_slow
    @zoom_time += 1
    if @zoom_time <= 50
     zoom_plus(0.001,0.001)
    end
    if @zoom_time >= 50
      zoom_less(0.001,0.001)
      if self.zoom_x <= 1
        zoom(1,1); @zoom_time = 0
      end
    end
  end
 
  def breath_actors
    @actor_breath += 5
    if @actor_breath <= 30
     zoom_plus(0.004,0.004)
    end
    if @actor_breath >= 30
      zoom_less(0.004,0.004)
      if self.zoom_x <= 1
        zoom(1,1); @actor_breath = 0
      end
    end
  end
end
 
class Sprite_Battler < RPG::Sprite
  alias falcaoBattler_zoom_update update
  def update
     falcaoBattler_zoom_update
     if @zoom_x != @battler.zoom_x or
       @zoom_y != @battler.zoom_y
       @zoom_x = @battler.zoom_x
       @zoom_y = @battler.zoom_y      
       self.zoom_x = @battler.zoom_x
       self.zoom_y = @battler.zoom_y
     end
     if @height <= 200
      @battler.breath
    elsif @height > 200
      @battler.breath_slow
    end
    if @battler.is_a?(Game_Actor)
      if Falcao::IncludeActors == true
         @battler.breath_actors
       else
       @battler.zoom(1,1)
      end
    end
  end
end