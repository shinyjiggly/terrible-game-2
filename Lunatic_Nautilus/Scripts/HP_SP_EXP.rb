#==============================================================================
# Add-On: HP/SP/EXP Meter
# by Atoa
# edited by shinyjiggly/lavendersiren
#==============================================================================
# Adds HP/SP/EXP Meters
# Remove this Add-On if you wish to use custom HP/SP/EXP bars
# This Add-On must be always bellow 'ACBS | Battle Windows'
# if you are using it
#note: the edits are unfinished and currently only affect the hp bar.
#they will be applied to the sp bar eventually.
#==============================================================================

module Atoa
  HP_Meter  = 'HPMeterfancy'  # Name of the HP meter graphic file
  HP_Meter2  = 'HPMeter2'  # Name of the vertical HP meter graphic file
  SP_Meter  = 'SPMeter'  # Name of the SP meter graphic file
  EXP_Meter = 'EXPMeter' # Name of the EXP meter graphic file
  MP_Meter = 'MPMeter'
  
  
  # Bars position adjust
  #                [x, y]
  HP_Pos_Adjust  = [-28, -140]
  SP_Pos_Adjust  = [-6, -122]
  EXP_Pos_Adjust = [20, 0]
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  def now_exp
    return @exp - @exp_list[@level]
  end
  #--------------------------------------------------------------------------
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
end

#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  
  #this is over here because putting it up higher in the script just gave errors.
  #kinda nooby with ruby here so bear with me.
  #ideally this should be able to be changed elsewhere or something
  
  alias draw_actor_hp_bar draw_actor_hp
  the_setup = true
  if the_setup == true
    def draw_actor_hp(actor, x, y, width = 144) 
	#is defining the same thing differently even a good idea? it doesn't particularly strike me as being so. idk.
      bar_x = HP_Pos_Adjust[0] + x
      bar_y = HP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
      @skin = RPG::Cache.windowskin(HP_Meter)
      @width  = @skin.width
      @height = @skin.height / 3
      src_rect = Rect.new(0, 0, @width, @height) #edit
      self.contents.blt(bar_x, bar_y, @skin, src_rect)    
      @line   = (actor.hp == actor.maxhp ? 2 : 1)
      @amount = 100 * actor.hp / actor.maxhp
      src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
      self.contents.blt(bar_x, bar_y, @skin, src_rect2)
      draw_actor_hp_bar(actor, x, y, width)
    end
  else #vertical version
    def draw_actor_hp(actor, x, y, width = 144) #draws the numbers
      #global positions of the bars
      bar_x = HP_Pos_Adjust[0] + x + (Font.default_size * 2 /3) 
      #parens thing makes sure it's in the right spot on the menu
      bar_y = HP_Pos_Adjust[1] + y 
      @skin = RPG::Cache.windowskin(HP_Meter2)#the windowskin used
      @width  = @skin.width / 3 #splits it into 3 parts
      @height = @skin.height #basic height
      #these are presumibly used to get a measure for how large to make the bars
      
      src_rect = Rect.new(0, 0, @width, @height) #bar background setup
      #x coords, y coords, image used, rectangle to draw
      self.contents.blt(bar_x, bar_y, @skin, src_rect) #base rectangle for back
      
      @line   = (actor.hp == actor.maxhp ? 2 : 1) #which line is it using
      @amount = 100 * actor.hp / actor.maxhp #percent of hp remaining
      
      #selects the proper bar, selects the y
      src_rect2 = Rect.new(@line * @width , 0 , @width , @height * @amount / 100) #the action rectangle
      self.contents.blt(bar_x, bar_y , @skin, src_rect2) #bacon lettuce tomato 
      #x coord, y coord, bitmap, rectangle
      #important note: this thing drains the bar the wrong way, even when I've attempted to flip the bar.
	  #that winds up only flipping the graphics
      draw_actor_hp_bar(actor, x, y, width) 
    end
    end
  #--------------------------------------------------------------------------
  alias draw_actor_sp_bar draw_actor_sp
  if the_setup == false
  def draw_actor_sp(actor, x, y, width = 144)
    bar_x = SP_Pos_Adjust[0] + x
    bar_y = SP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin(SP_Meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect)    
    @line   = (actor.sp == actor.maxsp ? 2 : 1)
    @amount = (actor.maxsp == 0 ? 0 : 100 * actor.sp / actor.maxsp)
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect2)
    draw_actor_sp_bar(actor, x, y, width)
  end
    else #vertical version
    def draw_actor_sp(actor, x, y, width = 144) #draws the numbers
      #global positions of the bars
      bar_x = SP_Pos_Adjust[0] + x + (Font.default_size * 2 /3) 
      #parens thing makes sure it's in the right spot on the menu
      bar_y = SP_Pos_Adjust[1] + y 
      @skin = RPG::Cache.windowskin(MP_Meter)#the windowskin used
      @width  = @skin.width / 3 #splits it into 3 parts
      @height = @skin.height #basic height
      #these are presumibly used to get a measure for how large to make the bars
      
      src_rect = Rect.new(0, 0, @width, @height) #bar background setup
      #x coords, y coords, image used, rectangle to draw
      self.contents.blt(bar_x, bar_y, @skin, src_rect) #base rectangle for back
      
      @line   = (actor.sp == actor.maxsp ? 2 : 1) #which line is it using
      @amount = 100 * actor.sp / actor.maxsp #percent of mp remaining
      
      #selects the proper bar, selects the y
      src_rect2 = Rect.new(@line * @width , 0 , @width , @height * @amount / 100) #the action rectangle
      self.contents.blt(bar_x, bar_y , @skin, src_rect2) #bacon lettuce tomato 

      draw_actor_sp_bar(actor, x, y, width) 
    end
    end
  #--------------------------------------------------------------------------
  alias draw_actor_exp_bar draw_actor_exp
  def draw_actor_exp(actor, x, y)
    bar_x = EXP_Pos_Adjust[0] + x
    bar_y = EXP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin(EXP_Meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect)    
    @line   = (actor.now_exp == actor.next_exp ? 2 : 1)
    @amount = (actor.next_exp == 0 ? 0 : 100 * actor.now_exp / actor.next_exp)
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect2)
    draw_actor_exp_bar(actor, x, y)
  end
end