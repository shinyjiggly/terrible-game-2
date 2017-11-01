#==============================================================================
# ** Draw_text colors (2k style text) Bitmap AddOn
#==============================================================================

class Bitmap
  alias origin_text draw_text unless $@
  #--------------------------------------------------------------------------
  # * New draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    # fontfix gets the actual font color
    @fontfix = self.font.color.clone
    case args.size
    when 2 # (rect, str)
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      str = args[1]
      align = 0
      colorindex = self.font.color
    when 3 # (rect, str, align)
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      str = args[1]
      align = args[2]
      colorindex = self.font.color
    when 4 # (rect, str, align, colorindex)
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      str = args[1]
      align = args[2]
      colorindex = args[3]
    when 5 # (x, y, w, h, str)
      x = args[0]
      y = args[1]
      w = args[2]
      h = args[3]
      str = args[4]
      align = 0
      colorindex = self.font.color
    when 6 # (x, y, w, h, str, align)
      x = args[0]
      y = args[1]
      w = args[2]
      h = args[3]
      str = args[4]
      align = args[5]
      colorindex = self.font.color
    when 7 # (x, y, w, h, str, align, colorindex)
      x = args[0]
      y = args[1]
      w = args[2]
      h = args[3]
      str = args[4]
      align = args[5]
      colorindex = args[6]
    end
    # colorindex should be an index, if it's a Window_Base color it will return
    # to it's index.
    if colorindex.is_a?(Color) 
      array = [colorindex.red,colorindex.green,colorindex.blue,colorindex.alpha]
      case array
      when [255, 255, 255, 255] # default normal_color
        colorindex = 0
      when [192, 224, 255, 255] # default system_color
        colorindex = 1
      when [255, 255, 255, 128] # default disabled_color
        colorindex = 3
      when [255, 255, 64, 255] # default crisis_color
        colorindex = 4
      when [255, 64, 0, 255] # default knockout_color
        colorindex = 5
      else
        colorindex = 0
      end
    end
    # colordb is the invisible windowkin sprite where colors are taken
    @colordb = Sprite.new
    @colordb.bitmap = RPG::Cache.system($game_system.windowskin_name)
    @colordb.visible = false
    if colorindex >= 0 and colorindex <= 9 # First Row of colors
      color1 = @colordb.bitmap.get_pixel(0+colorindex*16,48)
      color2 = @colordb.bitmap.get_pixel(0+colorindex*16,54)
      color3 = @colordb.bitmap.get_pixel(0+colorindex*16,56)
      color4 = @colordb.bitmap.get_pixel(0+colorindex*16,58)
      color5 = @colordb.bitmap.get_pixel(0+colorindex*16,60)
      color6 = @colordb.bitmap.get_pixel(0+colorindex*16,61)
      color7 = @colordb.bitmap.get_pixel(0+colorindex*16,62)
      color8 = @colordb.bitmap.get_pixel(0+colorindex*16,63)
      color9 = @colordb.bitmap.get_pixel(24,36) # Shadow color
    else # Second Row of colors
      color1 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,48+16)
      color2 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,54+16)
      color3 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,56+16)
      color4 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,58+16)
      color5 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,60+16)
      color6 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,61+16)
      color7 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,62+16)
      color8 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,63+16)
      color9 = @colordb.bitmap.get_pixel(24,36) # Shadow color
    end
    # If the Shadow color is not transparent, it's the first to be shown
    if color9.alpha != 0
      font.color = color9
      origin_text(x+1,y+1,w,h,str,align)
      origin_text(x+2,y+2,w,h,str,align)
    end
    # Text is drawn by layers of color
    font.color = color8
    origin_text(x,y,w,h,str,align)
    font.color = color7
    origin_text(x,y+3,w,24,str,align)
    font.color = color6
    origin_text(x,y+3,w,22,str,align)  
    font.color = color5
    origin_text(x,y+3,w,20,str,align)
    font.color = color4
    origin_text(x,y+3,w,19,str,align)
    font.color = color3
    origin_text(x,y+3,w,18,str,align)
    font.color = color2
    origin_text(x,y+3,w,16,str,align)
    font.color = color1
    origin_text(x,y+3,w,12,str,align)
    # fontfix returns the font color to avoid losing it
    font.color = @fontfix
  end
  
  #--------------------------------------------------------------------------
  # * Old draw_text
  #--------------------------------------------------------------------------
  def draw_xp_text(*args)
    origin_text(*args)
  end
  
  #--------------------------------------------------------------------------
  # * Draw Icon
  #--------------------------------------------------------------------------
  def draw_icon(*args)
    # fontfix gets the actual font color
    @fontfix = self.font.color.clone
    case args.size
    when 2 # (rect, icon)
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      icon = args[1]
      opacity = 255
      colorindex = self.font.color
    when 3 # (rect, icon, opacity)
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      icon = args[1]
      opacity = args[2]
      colorindex = self.font.color
    when 4 # (rect, icon, opacity, colorindex)
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      icon = args[1]
      opacity = args[2]
      colorindex = args[3]
    when 5 # (x, y, w, h, icon)
      x = args[0]
      y = args[1]
      w = args[2]
      h = args[3]
      icon = args[4]
      opacity = 255
      colorindex = self.font.color
    when 6 # (x, y, w, h, icon, opacity)
      x = args[0]
      y = args[1]
      w = args[2]
      h = args[3]
      icon = args[4]
      opacity = args[5]
      colorindex = self.font.color
    when 7 # (x, y, w, h, icon, opacity, colorindex)
      x = args[0]
      y = args[1]
      w = args[2]
      h = args[3]
      icon = args[4]
      opacity = args[5]
      colorindex = args[6]
    end
    # Return if icon does not exist
    return if icon == nil
    # If icon name doesnt include "2k_", it draws the default XP icon
    if not icon.include?("2k_")
      bitmap = RPG::Cache.icon(icon)
      blt(x, y, bitmap, Rect.new(0, 0, w, h), opacity)
      return
    end
    # If icon name includes "2k_", the icon will be drawn similar as new draw text
    # imitating the 2k icon style
    
    # colorindex should be an index, if it's a Window_Base color it will return
    # to it's index.
    if colorindex.is_a?(Color)
      array = [colorindex.red,colorindex.green,colorindex.blue,colorindex.alpha]
      case array
      when [255, 255, 255, 255] # default normal_color
        colorindex = 0
      when [192, 224, 255, 255] # default system_color
        colorindex = 1
      when [255, 255, 255, 128] # default disabled_color
        colorindex = 3
      when [255, 255, 64, 255] # default crisis_color
        colorindex = 4
      when [255, 64, 0, 255] # default knockout_color
        colorindex = 5
      else
        colorindex = 0
      end
    end
    # colordb is the invisible windowkin sprite where colors are taken
    @colordb = Sprite.new
    @colordb.bitmap = RPG::Cache.system($game_system.windowskin_name)
    @colordb.visible = false
    if colorindex >= 0 and colorindex <= 9 # First Row of colors
      color1 = @colordb.bitmap.get_pixel(0+colorindex*16,48)
      color2 = @colordb.bitmap.get_pixel(0+colorindex*16,54)
      color3 = @colordb.bitmap.get_pixel(0+colorindex*16,56)
      color4 = @colordb.bitmap.get_pixel(0+colorindex*16,58)
      color5 = @colordb.bitmap.get_pixel(0+colorindex*16,60)
      color6 = @colordb.bitmap.get_pixel(0+colorindex*16,61)
      color7 = @colordb.bitmap.get_pixel(0+colorindex*16,62)
      color9 = @colordb.bitmap.get_pixel(24,36) # Shadow color
    else # Second Row of colors
      color1 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,48+16)
      color2 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,54+16)
      color3 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,56+16)
      color4 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,58+16)
      color5 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,60+16)
      color6 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,61+16)
      color7 = @colordb.bitmap.get_pixel(0+(colorindex-10)*16,62+16)
      color9 = @colordb.bitmap.get_pixel(24,36) # Shadow color
    end
    # Gets the icon bitmap using cache
    icon_bitmap = RPG::Cache.icon(icon)
    # The trasparency of the result icon will depend on the darkness of the icon
    # (measured with the red channel to simplify it)
    # If a pixel of the icon is completely black this pixel will not be shown,
    # while if it's completely white it will be shown at maximum opacity.
    
    # If the Shadow color is not transparent, it's the first to be shown
    if color9.alpha != 0
      for i in 0..w
        for j in 0..h
          # colorbitmap is the color of the pixel icon_bitmap in i,j position
          colorbitmap = icon_bitmap.get_pixel(i,j)
          # If the pixel of the icon is black, the script skips it to the next
          next if colorbitmap.red == 0
          # Shadow pixel is drawn in i+2, j+2
          set_pixel(x+i+2,y+j+2,Color.new(color9.red, color9.green,
          color9.blue, colorbitmap.red))
          # Shadow pixel is drawn in i+1, j+1 using colorbitmapB
          colorbitmapB = get_pixel(x+i+1,y+j+1)
          set_pixel(x+i+1,y+j+1,Color.new(color9.red, color9.green,
          color9.blue, colorbitmap.red+colorbitmapB.alpha))
          # Shadow pixel is drawn in i+2, j+1 using colorbitmapB
          colorbitmapB = get_pixel(x+i+2,y+j+1)
          set_pixel(x+i+2,y+j+1,Color.new(color9.red, color9.green,
          color9.blue, colorbitmap.red+colorbitmapB.alpha))
          # Shadow pixel is drawn in i+1, j+2 using colorbitmapB
          colorbitmapB = get_pixel(x+i+1,y+j+2)
          set_pixel(x+i+1,y+j+2,Color.new(color9.red, color9.green,
          color9.blue, colorbitmap.red+colorbitmapB.alpha))
        end
      end
    end
    # backsprite is an invisible sprite used to draw the icon with each pixel
    # opacities without losing the shadow pixels drawn before
    backsprite = Sprite.new
    backsprite.bitmap = Bitmap.new(w, h)
    backsprite.visible = false
    for i in 0..w
      # color1
      for j in 0..10
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color1.red, color1.green,
        color1.blue, colorbitmap.red))
      end
      # color2
      for j in 10..14
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color2.red, color2.green,
        color2.blue, colorbitmap.red))
      end
      # color3
      for j in 14..16
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color3.red, color3.green,
        color3.blue, colorbitmap.red))
      end
      # color4
      for j in 16..17
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color4.red, color4.green,
        color4.blue, colorbitmap.red))
      end
      # color5
      for j in 17..18
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color5.red, color5.green,
        color5.blue, colorbitmap.red))
      end
      # color6
      for j in 18..20
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color6.red, color6.green,
        color6.blue, colorbitmap.red))
      end
      # color7
      for j in 20..24
        colorbitmap = icon_bitmap.get_pixel(i,j)
        next if colorbitmap.red == 0
        backsprite.bitmap.set_pixel(i,j,Color.new(color7.red, color7.green,
        color7.blue, colorbitmap.red))
      end
    end
    # Finally the icon is drawed. For that, the pixel result is calculated
    # using the shadow color and the backsprite color
    for i in 0..w
      for j in 0..h
        color1 = get_pixel(x+i, y+j)
        color2 = backsprite.bitmap.get_pixel(i, j)
        next if color2.alpha == 0
        a1 = color1.alpha
        a2 = color2.alpha
        new_color = Color.new(
        [(color1.red   * a1 + color2.red   * a2) / 255,   color2.red].min,
        [(color1.green * a1 + color2.green * a2) / 255, color2.green].min,
        [(color1.blue  * a1 + color2.blue  * a2) / 255,  color2.blue].min,
        [(color1.alpha * a1 + color2.alpha * a2) / 255, color2.alpha].max)
        set_pixel(x+i, y+j, new_color)
      end
    end
    # fontfix returns the font color to avoid losing it
    font.color = @fontfix
  end
end