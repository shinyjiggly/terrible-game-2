#==============================================================================
# ** FontZ
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.1
#    03-16-2016 (mm/dd/yyyy)
#    RGSS / RPGMaker XP
#==============================================================================
#
#  INTRODUCTION:
#
#  This little add-on  is yet another supplemental script  you can find that
#  lets people add the classic outline and shadow font effects.   Along with
#  those,  it also  allows you  to have underlined text  and text that has a
#  strikethru line.
#
#
#------------------------------------------------------------------------------
#
#  SETTING UP FONTZ:
#
#  To install, just paste this script below Scene_Debug and above Main. Once
#  that is done, adjust the configurable values within the 'FontZ' module as
#  you see fit.
#
#  The color used by the shadow effect  is a dark gray,  while a medium gray
#  that mimicks the /c[7] text color code is used for underlines.   Outlines
#  are drawn a solid black, and the strikethru effect is drawn red.
#
#
#------------------------------------------------------------------------------
#
#  USAGE:
#
#  The commands used by FontZ to apply the new font effects mimic those used
#  by default.  In this, there is almost no learning curve.  Just as you use
#             self.contents.font.bold = true
#  to apply 'boldface' text effects  to your  drawn text,  you can  also use 
#             self.contents.font.shadow = true
#  to apply the new 'shadow' text effect.
#
#  Each font effect  is described below  and includes  additional notes  for 
#  additional information.
#
#
#  *  -  *  -   *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *
#
#  +--------------------+  -------------------------------------------------
#  | SHADOW EFFECT      |   This feature is normally used to draw a darkened
#  +--------------------+   shadow two pixels to the bottom left of the ori-
#                           ginal text.   When in use,  it takes little more
#                           than  twice as long  as the  default 'draw text'
#                           command. Slowdown for menus is barely noticable.
#
#  GENERAL SYNTAX
#  self.contents.font.shadow = (true/false)
#  *  This turns the shadow effect  on or off.   The syntax shown  is how it
#     would be used within a typically coded Window class.
#
#
#  COLOR EFFECT
#  self.contents.font.shadow_color = Color.new(rr,gg,bb,aa)
#  self.contents.font.shadow_color = nil
#  *  This allows you to change the current color for the  shadow being ren-
#     dered, or lets you restore the default color by setting it to nil.  As
#     seen in the first example, it uses the Color.new command.
#
#
#                              *     *     *
#
#  +--------------------+  -------------------------------------------------
#  | OUTLINE EFFECT     |  This feature  is typically used  to draw  a solid
#  +--------------------+  black outline around the desired text. When it is
#                          in use,  it takes roughly five times  as long  to 
#                          draw text as the default command. This is because
#                          it redraws the text four more times to create the
#                          desired effect,  nearly half  the length  of time
#                          taken by the MACL command (ver MACL 2.3).
#
#  GENERAL SYNTAX
#  self.contents.font.outline = (true/false)
#  *  This turns the outline effect  on or off.   The syntax shown is how it
#     would be used within a typically coded Window class.#
#
#
#  COLOR EFFECT
#  self.contents.font.outline_color = Color.new(rr,gg,bb,aa)
#  self.contents.font.outline_color = nil
#  *  This allows you to change the current color for the outline being ren-
#     dered, or lets you restore the default color by setting it to nil.  As
#     seen in the first example, it uses the Color.new command.
#
#
#                              *     *     *
#
#  +--------------------+  -------------------------------------------------
#  | UNDERLINE EFFECT   |  This feature allows you to draw a solid gray line
#  +--------------------+  under the desired text. It may even have a shadow
#                          or outline drawn around  it to match that  of the
#                          text it is drawn below.  When in use, it may take
#                          twice as long as the default 'draw text' command,
#                          so slowdown on menus is barely noticable.
#
#  GENERAL SYNTAX
#  self.contents.font.underline = (true/false)
#  *  This turns the underline effect on or off.  The syntax shown is how it 
#     would be used within a typically coded Window class.
#
#
#  COLOR EFFECT
#  self.contents.font.underline_color = Color.new(rr,gg,bb,aa)
#  self.contents.font.underline_color = nil
#  *  This allows you  to change  the current color  for the underline being
#     drawn, or lets you restore the default color by setting it to nil.  As
#     seen in the first example, it uses the Color.new command.
#  *  If the underline drawn has a shadow and/or border effect, these colors
#     are the same as those of the text,  and is controlled by their related
#     outline_color and shadow_color commands.
#
#
#  FULL WIDTH EFFECT
#  self.contents.font.underline_full = (true/false)
#  *  This turns the full underline effect on or off.   Normally, the under-
#     line effect only draws under the text itself, but if the effect is on,
#     the underline will be drawn  the whole width defined  in the draw_text
#     command.
#
#
#  HIEARCHY (FULL WIDTH vs NORMAL)
#  *  If text is set to both underline and underline_full,  the text will be
#     drawn with the underline_full effect.  The underline_full setting will
#     supercede the normal underline effect.
#
#
#  ADDITIONAL EFFECTS
#  self.contents.font.underline_effects = (true/false)
#  *  This enables or disables whether shadow/outline effects are applied to
#     the rendered underline.   The colors used by  the shadows and outlines
#     are the same as those of the text rendered. The syntax shown is how it 
#     would be used within a typically coded Window class.
#
#
#
#
#
#                              *     *     *
#
#  +--------------------+  -------------------------------------------------
#  | STRIKE THRU EFFECT |  This feature permits you  to draw  a line through
#  +--------------------+  the text drawn.   Unline the underline effect, it
#                          doesn't include a shaded or outlined effect.  And
#                          when in use,  it may take twice as long to create
#                          twice as long as the default 'draw text' command.
#
#  GENERAL SYNTAX
#  self.contents.font.strikethru = (true/false)
#  *  This turns the strikethru effect on or off. The syntax shown is how it
#     would be used within a typically coded Window class.
#
#
#  COLOR EFFECT
#  self.contents.font.strikethru_color = Color.new(rr,gg,bb,aa)
#  self.contents.font.strikethru_color = nil
#  *  This allows you  to change  the current color  for the strikethru line
#     drawn, or lets you restore the default color by setting it to nil.  As
#     seen in the first example, it uses the Color.new command.
#
#
#  FULL WIDTH EFFECT
#  self.contents.font.strikethru_full = (true/false)
#  *  This turns the full strikethru effect on or off. Normally, the strike-
#     thru effect only draws through the text itself,  but if its turned on,
#     the line will be drawn through the whole width defined in the draw_text
#     command.
#
#
#  HIEARCHY (FULL WIDTH vs NORMAL)
#  *  If text is set to both strikethru & strikethru full,  the text will be
#     drawn with the strikethru_full effect.   The strikethru_full value will
#     supercede the normal strikethru effect.
#
#
#------------------------------------------------------------------------------
#
#  DETECTING FONTZ:
#
#  You might want to create a script  that has an option  to use an enhanced
#  font such as shadow or outline if a compatible font script  (such as this
#  one) is installed.  But you may want to put in a safeguard so your script
#  doesn't crash if the custom font script is unavailable. That is what this
#  little addendum is all about.
#
#  The below "if...end" block of code shows how  to perform a check  to see
#  if a new shadow font style is available in the Font class before turning
#  on the font shadow feature.
#
#  The actual check looks for a method (or def) named  'shadow='  within the
#  custom Font script,  and will only run the command to turn shadow text on
#  if the method exists.
#
#            # Allow if shadow method exists in font class
#            if Font.method_defined? :shadow=
#              self.contents.font.shadow = true
#            end
#  
#  You may find the 'method_defined?' command to be a fast and effective way
#  to autodetect other scripts for your own needs. To ensure that the inclu-
#  sion of custom font styles in a script  doesn't crash a game  if the font
#  script isn't available, the usefulness of this method becomes apparent.
#
#
#==============================================================================
#
#  TERMS OF USE:
#
#  Free for use, even in commercial games.  Only due credit is required.
#
#
#==============================================================================




#==============================================================================
# ** FontZ
#------------------------------------------------------------------------------
#  The configuration module that holds the default colors to the font effects.
#==============================================================================

module FontZ
  
  # Defined here are default colors for the font effects
  # used by the system.
  #
    Shadow_Color      = Color.new( 96, 96, 96,255)  # Dark Gray   (default)
    Outline_Color     = Color.new(  0,  0,  0,255)  # Solid Black (default)
    Underline_Color   = Color.new(192,192,192,255)  # Medium Gray (default)
    Strikethru_Color  = Color.new(255,  0,  0,255)  # Solid Red   (default)
  
end




#==============================================================================
# ** Font
#------------------------------------------------------------------------------
#  The font class. Font is a property of the Bitmap class.
#==============================================================================

class Font
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :shadow                   # Shadow text flag
  attr_reader   :outline                  # Outline text flag
  attr_reader   :underline                # Underline text flag
  attr_reader   :underline_full           # Full Width Underline flag
  attr_reader   :underline_effects        # Underline Shadow/Outline flag
  attr_reader   :strikethru               # Strikethru text flag
  attr_reader   :strikethru_full          # Full Width Strikethru flag
  attr_reader   :shadow_color             # Color of text shadow
  attr_reader   :outline_color            # Color of text outline
  attr_reader   :underline_color          # Underline color
  attr_reader   :strikethru_color         # Strikethru color
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  if @fontz_font_class_stack.nil?
    alias FontZ_initialize initialize
    @fontz_font_class_stack = true
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(*args)
    # Perform the original call
    FontZ_initialize(*args)
    # Adds the new font values with default values
    @shadow             = false
    @outline            = false
    @underline          = false
    @underline_full     = false
    @underline_effects  = false
    @strikethru         = false
    @strikethru_full    = false
    @shadow_color       = FontZ::Shadow_Color
    @outline_color      = FontZ::Outline_Color
    @underline_color    = FontZ::Underline_Color
    @strikethru_color   = FontZ::Strikethru_Color
  end
  #-------------------------------------------------------------------------
  # * Set Shadow
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def shadow=(flag=false)
    @shadow = flag
  end
  #-------------------------------------------------------------------------
  # * Set Shadow Color
  #     color_value : valid Color argument, nil returns to default
  #-------------------------------------------------------------------------
  def shadow_color=(color_value=nil)
    return @shadow_color = FontZ::Shadow_Color if color_value.nil?
    @shadow_color = color_value
  end
  #-------------------------------------------------------------------------
  # * Set Outline
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def outline=(flag=false)
    @outline = flag
  end  
  #-------------------------------------------------------------------------
  # * Set Outline Color
  #     color_value : valid Color argument, nil returns to default
  #-------------------------------------------------------------------------
  def outline_color=(color_value=nil)
    return outline_color = FontZ::Outline_Color if color_value.nil?
    outline_color = color_value
  end
  #-------------------------------------------------------------------------
  # * Set Underline
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def underline=(flag=false)
    @underline = flag
  end
  #-------------------------------------------------------------------------
  # * Set Full Underline
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def underline_full=(flag=false)
    @underline_full = flag
  end
  #-------------------------------------------------------------------------
  # * Set Underline Effects
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def underline_effects=(flag)
    @underline_effects = flag
  end
  #-------------------------------------------------------------------------
  # * Set Underline Color
  #     color_value : valid Color argument, nil returns to default
  #-------------------------------------------------------------------------
  def underline_color=(color_value=nil)
    return @underline_color = FontZ::Underline_Color if color_value.nil?
    @underline_color = color_value
  end
  #-------------------------------------------------------------------------
  # * Set Strikethru
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def strikethru=(flag=false)
    @strikethru = flag
  end
  #-------------------------------------------------------------------------
  # * Set Full Strikethru
  #     flag : boolean (true/false)
  #-------------------------------------------------------------------------
  def strikethru_full=(flag=false)
    @strikethru_full = flag
  end
  #-------------------------------------------------------------------------
  # * Set Strikethru Color
  #     color_value : valid Color argument, nil returns to default
  #-------------------------------------------------------------------------
  def strikethru_color=(color_value)
    return @strikethru_color = FontZ::Strikethru_Color if color_value.nil?
    @strikethru_color = color_value
  end  
end



#==============================================================================
# ** Bitmap
#------------------------------------------------------------------------------
#  The bitmap class. Bitmaps are expressions of so-called graphics.  Sprites
#  (Sprite) and other objects must be used to display bitmaps on the screen.
#==============================================================================

class Bitmap
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  if @fontz_bitmap_class_stack.nil?
    alias revised_draw_text draw_text
    @fontz_bitmap_class_stack = true
  end
  #--------------------------------------------------------------------------
  # * Draw Text
  #    args  : list of all arguments passed, including non-default additions
  #--------------------------------------------------------------------------
  def draw_text(*args)
    # Reformat arguments for use (handles rectangles and nil alignments)
    args_2      = reformat_arguments(*args)
    x,y,w,h,t,a = args_2[0],args_2[1],args_2[2],args_2[3],args_2[4],args_2[5]
    # Pre draw_text effects
    draw_text_pre_effects(x, y, w, h, t, a)
    # The original call (uses original arguments)
    revised_draw_text(*args)
    # Post draw_text effects
    draw_text_post_effects(x, y, w, h, t, a)
  end
  #--------------------------------------------------------------------------
  # * Reformat Text Arguments
  #    args  : list of all arguments passed and returns all used by add-ons
  #--------------------------------------------------------------------------
  def reformat_arguments(*args)
    # If the arguments include a rectangle for text positioning
    if args[0].is_a?(Rect)
      x,y,w,h     = args[0].x,  args[0].y,  args[0].width,  args[0].height
      t,a         = args[1],    args[2]
    # Otherwise, non rectangle usage
    else
      x,y,w,h,t,a = args[0], args[1], args[2], args[3], args[4], args[5]
    end
    # if alignment value not passed within the arguments
    a = 0 if a.nil?
    # Return revised (slightly cleaner)
    return [x,y,w,h,t,a]
  end
  #--------------------------------------------------------------------------
  # * Effects drawn before original draw_text used
  #    x : x-position
  #    y : y-position
  #    x : width
  #    h : height
  #    a : align
  #--------------------------------------------------------------------------
  def draw_text_pre_effects(x, y, w, h, t, a)
    underline_text(x, y, w, h, t, a)  if self.font.underline       == true or
                                         self.font.underline_full  == true
    shadow_text(x, y, w, h, t, a)     if self.font.shadow          == true
    outline_text(x, y, w, h, t, a)    if self.font.outline         == true
  end
  #--------------------------------------------------------------------------
  # * Effects drawn after original draw_text used
  #    x : x-position
  #    y : y-position
  #    x : width
  #    h : height
  #    a : align
  #--------------------------------------------------------------------------
  def draw_text_post_effects(x, y, w, h, t, a)
    strikethru_text(x, y, w, h, t, a) if self.font.strikethru       == true or
                                         self.font.strikethru_full  == true
  end
  #--------------------------------------------------------------------------
  # * Draw Shadowed Text
  #    x : x-position
  #    y : y-position
  #    x : width
  #    h : height
  #    a : align
  #--------------------------------------------------------------------------
  def shadow_text(x, y, w, h, t, a)
    # Record the original color and set shadow color
    orig_color      = font.color.dup
    self.font.color = self.font.shadow_color
    revised_draw_text(x + 2, y + 2, w, h, t, a)
    # Restore original color
    self.font.color = orig_color
  end
  #--------------------------------------------------------------------------
  # * Draw Outlined Text
  #    x : x-position
  #    y : y-position
  #    x : width
  #    h : height
  #    a : align
  #--------------------------------------------------------------------------
  def outline_text(x, y, w, h, t, a)
    # Record the original color and set outline color
    orig_color      = font.color.dup
    self.font.color = self.font.outline_color
    # Draw from all four sides
    for i in [-1, 1]
      for j in [-1, 1]
        revised_draw_text(x + i, y + j, w, h, t, a)
      end
    end      
    # Restore original color
    self.font.color = orig_color
  end
  #--------------------------------------------------------------------------
  # * Draw Underline
  #    x : x-position
  #    y : y-position
  #    x : width
  #    h : height
  #    a : align
  #--------------------------------------------------------------------------
  def underline_text(x, y, w, h, t, a)
    # set underline width by default
    new_width = w
    # unless underline is full text width
    unless font.underline_full
      # Get current width of text alone
      new_width = text_size(t).width
      # Alter underline's x based on alignment other than left
      unless a==0
        x += a == 1 ? w / 2 - new_width / 2 : w - new_width
      end
    end
    # Set underline height
    new_y = 1 + y + h / 2 + font.size / 3
    # Draw underline (and draw effect on underline if applicable
    if self.font.underline_effects == true
      if self.font.shadow   == true
        fill_rect(x+2, new_y+2, new_width,   1, self.font.shadow_color)
      end
      if self.font.outline  == true
        fill_rect(x-1, new_y-1, new_width+2, 3, self.font.outline_color)
      end
    end
    fill_rect(x,   new_y,   new_width,   1, self.font.underline_color)
  end
  #--------------------------------------------------------------------------
  # * Draw Strikethru
  #    x : x-position
  #    y : y-position
  #    x : width
  #    h : height
  #    a : align
  #--------------------------------------------------------------------------
  def strikethru_text(x, y, w, h, t, a)
    # set strikethru width by default
    new_width = w
    # unless underline is full text width
    unless font.strikethru_full
      # Get current width of text alone
      new_width = text_size(t).width
      # Alter underline's x based on alignment other than left
      unless a==0
        x += a == 1 ? w / 2 - new_width / 2 : w - new_width
      end
    end
    # set strikethru height
    new_y = y + h / 2
    # draw underline
    fill_rect(x, new_y, new_width, 1, self.font.strikethru_color)
  end   
end
