class Rect
  #--------------------------------------------------------------------------
  # * Strict Conversion to Array
  #--------------------------------------------------------------------------
  def to_ary
    return x, y, width, height
  end
  alias bounds to_ary
end

  
class Bitmap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :sfont
  #--------------------------------------------------------------------------
  # * Draw Text
  #--------------------------------------------------------------------------
  alias_method :trick_sfont_bitmap_draw_text, :draw_text
  def draw_text(*args)
    if self.sfont == nil
      trick_sfont_bitmap_draw_text(*args)
    else
      align = 0
      case args.size
      when 2
        rect, text = args
        x, y, width, height = rect
      when 3
        rect, text, align = args
        x, y, width, height = rect
      when 5
        x, y, width, height, text = args
      when 6
        x, y, width, height, text, align = args
      end
      bitmap = sfont.render(text)
      if align == 1
        x += (width - bitmap.width) / 2
      elsif align == 2
        x += width - bitmap.width
      end
      y += (height - bitmap.height) / 2
      blt(x, y, bitmap, bitmap.rect)
    end
  end
end