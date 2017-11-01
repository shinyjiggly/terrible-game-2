module RPG
  module Cache
    def self.balloonskin(filename)
      self.load_bitmap("Graphics/Balloonskins/", filename)
    end
  end
end

class Bitmap
  def trim(start_x, start_y, w, mask)
    x = 0
    y = 0
    for i in 0...mask.size
      if mask[i]
        self.set_pixel(start_x + x, start_y + y, Color::TRANSPARENT)
      end
      x += 1
      if x == w
        x = 0
        y += 1
      end
    end
    return self
  end
end

class Color
  TRANSPARENT = Color.new(0, 0, 0, 0)
end

class Balloon_Bitmap < Bitmap
  def initialize(width, height)
    super(width, height)
    self.font = FONT_BALLOON_TEXT
  end
  
  def draw_text(x, y, width, height, text, align = 0)
    y = y / 32 * SPACING_BALLOON_TEXT
    super(x, y, width, height, text, align)
  end
end

#Interpreter

class Interpreter
  alias mp_balloon_setup setup
  def setup(list, event_id)
    mp_balloon_setup(list, event_id)
    $game_variables[VAR_CURRENT_EVENT_ID] = event_id unless event_id == 0
  end
  
  alias mp_balloon_initialize initialize
  def initialize(depth = 0, main = false)
    mp_balloon_initialize(depth, main)
    @balloon_windows = []
  end
  
  alias mp_balloon_update update
  def update
    mp_balloon_update
    for window in @balloon_windows.clone
      window.update
      if window.terminated
        window.dispose
        @balloon_windows.delete(window)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Show Text
  #--------------------------------------------------------------------------
  alias mp_balloon_command_101 command_101
  def command_101
    return false if @message_waiting
    if $game_switches[SW_ENABLE_BALLOONS]
      # Set message end waiting flag and callback
      #@message_waiting = true
      @message_waiting = !$game_switches[SW_MESSAGE_SKIP]
      window = Window_Balloon.new
      window.message_proc = Proc.new { @message_waiting = false }
      @balloon_windows << window
      # Set message text on first line
      text = @list[@index].parameters[0] + "\n"
      line_count = 1
      # Loop
      loop do
        # If next event command text is on the second line or after
        if @list[@index+1].code == 401
          # Add the second line or after to message_text
          text += @list[@index+1].parameters[0] + "\n"
          line_count += 1
        # If event command is not on the second line or after
        else
          window.set_message(text)
          return true
        end
        @index += 1
      end
    end
    return mp_balloon_command_101
  end
end
