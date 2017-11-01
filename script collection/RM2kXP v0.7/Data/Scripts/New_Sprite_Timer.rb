#==============================================================================
# ** Sprite_Timer
#==============================================================================

class Bitmap
  #--------------------------------------------------------------------------
  # * Draw Timer Function
  #--------------------------------------------------------------------------
  def draw_stimer(x, y, text)
    # Font is loaded from the Windowskin graphic
    font_image = RPG::Cache.system($game_system.windowskin_name)
    # Define character width and height
    char_width  = 8
    char_height = 16
    # Get each letter (0 to 9 and ":")
    text.length.times do |index|
      byte = text[index]
      letter = byte.chr
      if letter =~ /[0-9]/
        iX = 32 + letter.to_i * char_width
        iY = 32
      elsif letter == ":"
        iX = 32 + 10 * char_width
        iY = 32
      end
      if letter != ""
        rect = Rect.new(iX, iY, char_width, char_height)
        self.blt((index * char_width) + x, y, font_image, rect)
      end
    end
  end
end

class Sprite_Timer < Sprite
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    super
    self.bitmap = Bitmap.new(88, 48)
    self.x = 640 - self.bitmap.width
    self.y = -16
    self.z = 500
    update
  end
  #--------------------------------------------------------------------------
  # * Update sprites
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = $game_system.timer_working
    if $game_system.timer / Graphics.frame_rate != @total_sec
      self.bitmap.clear
      # Get time in seconds and minutes
      @total_sec = $game_system.timer / Graphics.frame_rate
      min = @total_sec / 60
      sec = @total_sec % 60
      # Draw time on screen
      text = sprintf("%02d:%02d", min, sec)
      self.bitmap.draw_stimer(0, 10, text)
      # Time zoom is set to 2.0
      self.zoom_x = 2.0
      self.zoom_y = 2.0
    end
  end
end
