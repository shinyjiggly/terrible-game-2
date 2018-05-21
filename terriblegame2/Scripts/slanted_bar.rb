#-------------------------
# Slanted HP Bar
# by SephirothSpawn
#--------------------------

class Window_Base < Window  
  #--------------------------------------------------------------------------
  # * Draw Slant Bar
  #--------------------------------------------------------------------------
  def draw_slant_bar(x, y, min, max, width = 152, height = 6,
      bar_color = Color.new(150, 0, 0, 255), end_color = Color.new(255, 255, 60, 255))
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
    for i in 1..( (min / max.to_f) * width - 1)
      for j in 1..(height - 1)
        r = bar_color.red * (width - i) / width + end_color.red * i / width
        g = bar_color.green * (width - i) / width + end_color.green * i / width
        b = bar_color.blue * (width - i) / width + end_color.blue * i / width
        a = bar_color.alpha * (width - i) / width + end_color.alpha * i / width
        self.contents.fill_rect(x + i + j, y + height - j, 1, 1, Color.new(r, g, b, a))
      end
    end
  end
end