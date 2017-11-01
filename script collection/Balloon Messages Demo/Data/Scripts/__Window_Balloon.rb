class Window_Balloon < Window_Message
  include Balloonskin
  
  attr_accessor :message_proc
  attr_reader :terminated
  
  def initialize
    balloonskin_initialize
    super
    self.windowskin = nil
    self.opacity = OPACITY_BALLOON
  end
  
  def update
    super
    update_position
    if @sprite_wait.visible = $game_temp.message_window_showing
      if @wait_count == 0
        @wait_rect_index += 1
        @wait_rect_index %= 4
        @sprite_wait.src_rect = @wait_rect[@wait_rect_index]
        @wait_count = FRAMES_BALLOON_WAIT
      end
      @wait_count -= 1
    end
    if f = FRAMES_BALLOON_BLINK[@balloonskin_name]
      if @blink_count == 0
        @blink_count = f
      end
      @border.color.alpha = (f - (2 * @blink_count - f).abs) * 128 / f
      @blink_count -= 1
    end
  end
  
  def update_position
    down = @event.real_y / 4 - 32 - $game_map.display_y / 4 <= self.y
    self.y = @event.real_y / 4 + 32 - $game_map.display_y / 4
    if @event.real_y / 4 - 32 - $game_map.display_y / 4 > self.height
      self.y -= self.height + 64
      if down
        render_balloonskin
      end
    else
      unless down
        render_balloonskin
      end
    end
    self.x = [ [@event.real_x / 4 - self.width / 2 + 16 - $game_map.display_x / 4, 0].max, 640 - self.width].min
    #@skin.x = @border.x = self.x
    #@skin.y = @border.y = self.y
  end
  
  def set_message(text)
    if $game_variables[VAR_EVENT_ID_ANCHOR] == 0
      @event = $game_player
    else
      @event = $game_map.events[$game_variables[VAR_EVENT_ID_ANCHOR]]
    end
    #$game_temp.choice_max
    text = parse_text(text)
    lines = text.split("\n")
    
    if CUT_LINES_IN_TWO
      old_lines = lines
      lines = []
      for line in old_lines
        if line.size <= MAX_CHARACTERS_PER_LINE
          lines << line
        else
          n = line[0, MAX_CHARACTERS_PER_LINE].reverse.index(" ")
          n = MAX_CHARACTERS_PER_LINE - (n.nil? ? 0 : n)
          p = line[MAX_CHARACTERS_PER_LINE, line.size - MAX_CHARACTERS_PER_LINE].index(" ")
          p = line.size - n if p == nil
          if MAX_CHARACTERS_PER_LINE - n > p
            n = MAX_CHARACTERS_PER_LINE + p
          end
          lines << line[0, n]
          lines << line[n, line.size - n].lstrip
        end
      end
      text = lines.join("\n")
    end
    
    bitmap = Balloon_Bitmap.new(640, 480)
    size = 0
    lines.each do |str|
      size = [size, bitmap.text_size(str).width + PADDING_RIGHT].max # * FONT_BALLOON_TEXT.size / Font.default_size
    end
    bitmap.dispose
    self.width = 32 + size
    self.height = 32 + (Font.default_size - FONT_BALLOON_TEXT.size) * 2 + SPACING_BALLOON_TEXT * lines.size
    self.contents = Balloon_Bitmap.new(size, height - 32)
    self.balloonskin_name = sprintf("%03d", $game_variables[VAR_BALLOONSKIN])
    bitmap = RPG::Cache.balloonskin(@balloonskin_name)
    w = bitmap.width >> 3
    h = bitmap.height / 3
    # Round up width and height to avoid gaps in balloonskin
    if self.width % w != 0
      self.width = (self.width / w + 1) * w
    end
    if self.height % h != 0
      self.height = (self.height / h + 1) * h
    end
    # Displace content
    self.ox = (-self.width + 32 + self.contents.width) / 2
    self.oy = (-self.height + 32 + self.contents.height) / 2

    #self.balloonskin = RPG::Cache.balloonskin(@balloonskin_name)
    update_position
    render_balloonskin
    $game_temp.message_text = text
    
    @contents_showing = true
    $game_temp.message_window_showing = true
    #reset_window
    refresh
    Graphics.frame_reset
    self.visible = true
    self.contents_opacity = 0
    #if @input_number_window != nil
    #  @input_number_window.contents_opacity = 0
    #end
    @fade_in = true
    
    $game_temp.message_text = nil
  end
  
  def parse_text(text)
    # Control text processing
    begin
      last_text = text.clone
      text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
    end until text == last_text
    text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
      $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
    end
#--------------------------------------------------------------------------
    text.gsub!(/\\[Ff]\[([ \w\=\+\-\*\/\$\(\)\!\.\,\'\:\%\@]+)\]/) { eval $1 }
#--------------------------------------------------------------------------
    # Change "\\\\" to "\000" for convenience
    text.gsub!(/\\\\/) { "\000" }
    # Change "\\C" to "\001" and "\\G" to "\002"
    text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
    text.gsub!(/\\[Gg]/) { "\002" }
    return text
  end
  
  def terminate_message
    $game_temp.message_proc = self.message_proc
    super
    @terminated = true
#    self.dispose
    $game_temp.message_proc = nil
  end
  
  def normal_color
    return Color.new(0, 0, 0)
  end

  #--------------------------------------------------------------------------
  # * Get Text Color
  #     n : text color number (0-7)
  #--------------------------------------------------------------------------
  def text_color(n)
    case n
    when 0
      return Color.new(0, 0, 0, 255)
    when 1
      return Color.new(64, 64, 128, 255)
    when 2
      return Color.new(128, 64, 64, 255)
    when 3
      return Color.new(64, 128, 64, 255)
    when 4
      return Color.new(64, 128, 128, 255)
    when 5
      return Color.new(128, 64, 128, 255)
    when 6
      return Color.new(128, 128, 64, 255)
    when 7
      return Color.new(96, 96, 96, 255)
    else
      normal_color
    end
  end
end