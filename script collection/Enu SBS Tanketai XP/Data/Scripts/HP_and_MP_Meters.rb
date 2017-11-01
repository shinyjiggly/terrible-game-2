#==============================================================================
# Add-On: HP/SP/EXP Meter
# by Atoa
#==============================================================================
# Adds HP/SP/EXP Meters
# Remove this Add-On if you wish to use custom HP/SP/EXP bars
# This Add-On must be always bellow 'ACBS | Battle Windows'
# if you are using it
#==============================================================================

module Atoa
  HP_Meter  = 'HPMeter'  # Name of the HP meter graphic file
  SP_Meter  = 'SPMeter'  # Name of the SP meter graphic file
  EXP_Meter = 'EXPMeter' # Name of the EXP meter graphic file
  
  # Bars position adjust
  #                [x, y]
  HP_Pos_Adjust  = [0, 0]
  SP_Pos_Adjust  = [0, 0]
  EXP_Pos_Adjust = [0, 0]
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
  alias draw_actor_hp_bar draw_actor_hp
  def draw_actor_hp(actor, x, y, width = 144)
    bar_x = HP_Pos_Adjust[0] + x
    bar_y = HP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin(HP_Meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect)    
    @line   = (actor.hp == actor.maxhp ? 2 : 1)
    @amount = 100 * actor.hp / actor.maxhp
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect2)
    draw_actor_hp_bar(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  alias draw_actor_sp_bar draw_actor_sp
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