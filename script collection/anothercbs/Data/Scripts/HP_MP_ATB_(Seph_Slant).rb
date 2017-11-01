#===========================================================================
# *** HP/MP/ATB/LimitBreak bar Slanted Style Compatible with RTAB ***
# *** Version 2.1
#---------------------------------------------------------------------------
# by Clive 
# based on Cogwheel's Bars and Sephiroth Spawn's Slanted Bars.
#---------------------------------------------------------------------------
# ----- GREAT THANKS to DerVVulfman for solving the lag problem
#------This is a plug and play script so it should work without any problem!
#=============================================================================

# If using with Limit Break, must paste BELOW the Limit Break script as it re-
# writes the 'Gauge drawing' system.  Will cause an error if not properly put.

# If used with Trickster's STEAL SCRIPT version 6 R1 (revision 1), then the
# height of RTAB's AT Bar (Draw Actor ATG) may not be smaller than 5 pixels 
# due to a float-to-float error.  A height of 6 pixels is the smallest.


#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get the current EXP
  #--------------------------------------------------------------------------
  def now_exp
    return @exp - @exp_list[@level]
  end
  #--------------------------------------------------------------------------
  # * Get the next level's EXP
  #--------------------------------------------------------------------------
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
end


#==============================================================================
# ** Window_Base 
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window  
  
  #==========================================================================
  # * Draw Slant Bar(by SephirothSpawn)
  #==========================================================================
  def draw_slant_bar(x, y, min, max, width = 152, height = 6,
      bar_color = Color.new(150, 0, 0, 255),
      end_color = Color.new(255, 255, 60, 255))
    # Draw Border
    for i in 0..height
      self.contents.fill_rect(x + i, y + height - i, width + 1, 1, Color.new(50, 50, 50, 255))
    end
    # Draw Background
    for i in 1..(height - 1)
      r = 100 * (height - i) / height + 0 * i / height
      g = 100 * (height - i) / height + 0 * i / height
      b = 100 * (height - i) / height + 0 * i / height
      a = 255 * (height - i) / height + 255 * i / height
      self.contents.fill_rect(x + i, y + height - i, width, 1, Color.new(r, b, g, a))
    end
    # Draws Bar
    for i in 1..( (min.to_f / max.to_f) * width - 1)
      for j in 1..(height - 1)
        r = bar_color.red * (width - i) / width + end_color.red * i / width
        g = bar_color.green * (width - i) / width + end_color.green * i / width
        b = bar_color.blue * (width - i) / width + end_color.blue * i / width
        a = bar_color.alpha * (width - i) / width + end_color.alpha * i / width
        self.contents.fill_rect(x + i + j, y + height - j, 1, 1, Color.new(r, g, b, a))
      end
    end
  end
  
  #==========================================================================
  # * Draw HP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #==========================================================================
  alias :draw_actor_hp_hpsp :draw_actor_hp
  def draw_actor_hp(actor, x, y, width = 144)   
    draw_slant_bar(x, y + 12, actor.hp, actor.maxhp, width, 6, 
      bar_color = Color.new(150, 0, 0, 255), 
      end_color = Color.new(255, 255, 60, 255))
    draw_actor_hp_hpsp(actor, x, y, width)
   end
  #==========================================================================
  # * Draw SP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #==========================================================================
  alias :draw_actor_sp_hpsp :draw_actor_sp
  def draw_actor_sp(actor, x, y, width = 144)
    draw_slant_bar(x, y + 12, actor.sp, actor.maxsp, width, 6,
      bar_color = Color.new(0, 0, 155, 255), 
      end_color = Color.new(255, 255, 255, 255))
    draw_actor_sp_hpsp(actor, x, y, width)
  end
  #==========================================================================
  # * Draw EXP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #==========================================================================
  alias raz_bars_base_exp draw_actor_exp  
  def draw_actor_exp(actor, x, y)
    if actor.level == 99
      draw_slant_bar(x, y + 18, 1, 1, 190, 6, bar_color = Color.new(0, 100, 0, 255), end_color = Color.new(0, 255, 0, 255))
    else
      draw_slant_bar(x, y + 18, actor.now_exp, actor.next_exp, 190, 6, bar_color = Color.new(0, 100, 0, 255), end_color = Color.new(255, 255, 255, 255))
    end
    raz_bars_base_exp(actor, x, y)
  end
  #==========================================================================
  # * Draw Parameter
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : parameter type (0-6)
  #==========================================================================
  alias raz_bars_base_parameter draw_actor_parameter  
  def draw_actor_parameter(actor, x, y, type)
    case type
    when 0
      para_color1 = Color.new(100,0,0)
      para_color2 = Color.new(255,0,0)
      para_begin = actor.atk
    when 1
      para_color1 = Color.new(100,100,0)
      para_color2 = Color.new(255,255,0)
      para_begin = actor.pdef
    when 2
      para_color1 = Color.new(100,0,100)
      para_color2 = Color.new(255,0,255)
      para_begin = actor.mdef
    when 3
      para_color1 = Color.new(50,0,100)
      para_color2 = Color.new(50,0,255)
      para_begin = actor.str
    when 4
      para_color1 = Color.new(0,100,0)
      para_color2 = Color.new(0,255,0)
      para_begin = actor.dex
    when 5
      para_color1 = Color.new(50,0,50)
      para_color2 = Color.new(255,0,255)
      para_begin = actor.agi
    when 6
      para_color1 = Color.new(0,100,100)
      para_color2 = Color.new(0,255,255)
      para_begin = actor.int
    end
    draw_slant_bar(x, y + 18, para_begin, 999, 155, 4, bar_color = para_color1,
      end_color = para_color2)
    raz_bars_base_parameter(actor, x, y, type)
  end
  #=========================================================================
  # * Draw Actor ATG
  #     actor : Actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #=========================================================================
  def draw_actor_atg(actor, x, y, width = 144, height = 6)
    if @at_gauge == nil
      # plus_x:     revised x-coordinate
      # rate_x:     revised X-coordinate as (%)
      # plus_y:     revised y-coordinate
      # plus_width: revised width
      # rate_width: revised width as (%)
      # height:     Vertical width
      # align1: Type 1 ( 0: left justify  1: center justify 2: right justify )
      # align2: Type 2 ( 0: Upper stuffing 1: Central arranging  2:Lower stuffing )
      # align3: Gauge type 0:Left justify 1: Right justify
      @plus_x = 0
      @rate_x = 0
      @plus_y = 16
      @plus_width = 0
      @rate_width = 100
      @width = @plus_width + width * @rate_width / 100
      @height = 6
      @align1 = 0
      @align2 = 1
      @align3 = 0
      # Gradation settings:  grade1: Empty gauge   grade2:Actual gauge
      # (0:On side gradation   1:Vertically gradation    2: Slantedly gradation）
      grade1 = 1
      grade2 = 0
      # Color setting. color1: Outermost framework, color2: Medium framework
      # color3: Empty framework dark color, color4: Empty framework light/write color
      color1 = Color.new(0, 0, 0)
      color2 = Color.new(255, 255, 192)
      color3 = Color.new(0, 0, 0, 192)
      color4 = Color.new(0, 0, 64, 192)
      # Color setting of gauge
      # Usually color setting of the time
      color5 = Color.new(0, 64, 80)
      color6 = Color.new(255, 255, 255)#(0, 128, 160)
      # When gauge is MAX, color setting
      color7 = Color.new(80, 0, 0)
      color8 = Color.new(255, 255,255) #(240,0,0)
      # Color setting at time of cooperation skill use
      color9 = Color.new(80, 64, 32)
      color10 = Color.new(255, 255, 255) #(240, 192, 96)
      # Color setting at time of skill permanent residence
      color11 = Color.new(80, 0, 64)
      color12 = Color.new(255,255, 255) #(240, 0, 192)
      # Drawing of gauge
      gauge_rect_at(@width, @height, @align3, color1, color2, color3, color4,
          color5, color6, color7, color8, color9, color10, color11, color12,
          grade1, grade2)
    end
    # Variable at substituting the width of the gauge which is drawn
    if actor.rtp == 0
      at = (width + @plus_width) * actor.atp * @rate_width / 10000
    else
      at = (width + @plus_width) * actor.rt * @rate_width / actor.rtp / 100
    end
    # AT Width Check
    if at > width
      at = width
    end
    # Revision such as the left stuffing central posture of gauge
    case @align1
    when 1
      x += (@rect_width - width) / 2
    when 2
      x += @rect_width - width
    end
    case @align2
    when 1
      y -= @height / 2
    when 2
      y -= @height
    end
    # Draw Border
    for i in 0..height
      self.contents.fill_rect(x + 1.5 + i, y + 12 + height - i, width - 2 , 3,
        Color.new(50, 50, 50, 255))
    end
    # Draw Background
    for i in 1..(height - 1)
      r = 100 * (height - i) / height + 0 * i / height
      g = 100 * (height - i) / height + 0 * i / height
      b = 100 * (height - i) / height + 0 * i / height
      a = 255 * (height - i) / height + 255 * i / height
      self.contents.fill_rect(x + 1.5 + i, y + 12 + height - i, width - 3, 3, 
        Color.new(r, b, g, a))
    end
    # Rect_X control
    if @align3 == 0
      rect_x = 0
    else
      x += @width - at - 1
      rect_x = @width - at - 1
    end

    # Color setting of gauge
    if at == width 
    #Gauge drawing at the time of MAX
      for i in 0..height
        self.contents.blt(x + i + @plus_x + @width * @rate_x / 100, y -i + 
        @plus_y, @at_gauge, Rect.new(rect_x, @height * 2, at, @height))
      end
    else
      if actor.rtp == 0
        for i in 0..height
          # Usually gauge drawing of the time
          self.contents.blt(x + i + @plus_x + @width * @rate_x / 100, y- i + 
            @plus_y, @at_gauge,Rect.new(rect_x, @height, at, @height))
        end
      else
        if actor.spell == true
          for i in 0..height
            #Gauge drawing at time of cooperation skill use
            self.contents.blt(x + i + @plus_x + @width * @rate_x / 100, y - i + 
              @plus_y, @at_gauge, Rect.new(rect_x, @height * 3, at, @height))
          end
        else
          for i in 0..height              
            # Gauge drawing at time of skill permanent residence
            self.contents.blt(x + i + @plus_x + @width * @rate_x / 100, y - i +
              @plus_y, @at_gauge, Rect.new(rect_x, @height * 4, at, @height))
          end
        end
      end
    end
  end
end
