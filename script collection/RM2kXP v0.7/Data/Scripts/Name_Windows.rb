#==============================================================================
# ** Window_NameEdit
#==============================================================================

class Window_NameEdit < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor    : actor
  #     max_char : maximum number of characters
  #--------------------------------------------------------------------------
  def initialize(actor, max_char)
    super(128+96, 64, 294, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    @name = actor.name
    @max_char = max_char
    name_array = @name.split(//)[0...@max_char]
    @name = ""
    for i in 0...name_array.size
      @name += name_array[i]
    end
    @default_name = @name
    @index = name_array.size
    refresh
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    name_array = @name.split(//)
    for i in 0...@max_char
      c = name_array[i]
      if c == nil
        c = "＿" # ＿ character is a large _
      end
      x = 4 + i * 28
      # Draw letter
      self.contents.draw_text(x, 0, 28, 32, c, 1)
    end
    # draw_actor_graphic(@actor, 320 - @max_char * 14 - 40, 80)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    x = 4 + @index * 28
    self.cursor_rect.set(x, 0, 28, 32)
  end
end

#==============================================================================
# ** Window_NameFace
#==============================================================================

class Window_NameFace < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor    : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(128-32, 0, 96+32, 96+32)
    self.contents = Bitmap.new(width-32, height-32)
    draw_actor_face(actor, 96, 96)
  end
end

#==============================================================================
# ** Window_NameInput
#==============================================================================

class Window_NameInput < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(128-32, 128, 390+32, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @index = 0
    refresh
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...90
      x = 24 + i / 5 / 9 * 180 + i % 5 * 32
      y = i / 5 % 9 * 32
      self.contents.draw_text(x, y, 32, 32, CHARACTER_TABLE[i], 1)
    end
    self.contents.draw_text(288, 288, 64, 32, Vocab::NAMEINPUT_OK, 1) # < OK >
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rect
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index >= 90
      self.cursor_rect.set(288, 288, 64, 32)
    else
      x = 24 + @index / 5 / 9 * 180 + @index % 5 * 32
      y = @index / 5 % 9 * 32
      self.cursor_rect.set(x, y, 32, 32)
    end
  end
end