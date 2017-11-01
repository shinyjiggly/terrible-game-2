module Balloonskin
  TOP = 1
  BOTTOM = 2
  LEFT = 4
  RIGHT = 8
  TOP_LEFT = 16
  TOP_RIGHT = 32
  BOTTOM_LEFT = 64
  BOTTOM_RIGHT = 128
  COLOR_TRANSPARENT = Color.new(0, 0, 0, 0)
  
  @masks = {}
  @width = {}
  @height = {}
  
  class << self
    attr_reader :width
    attr_reader :height
    
    def compile(balloonskin_name)
      # Load bitmap
      @bitmap = RPG::Cache.balloonskin(balloonskin_name)
      # Compute cell width and height
      w = @width[balloonskin_name] = @bitmap.width >> 3
      h = @height[balloonskin_name] = @bitmap.height / 3
      # Compute cells
      cells = []
      for i in 0...4
        a = []
        for j in 0...3
          a << Rect.new(i * w, j * h, w, h)
        end
        cells << a
      end
      # Compute masks
      masks = []
      masks << make_mask(cells[0][0], [[0, 0]])
      masks << make_mask(cells[1][0], [[0, 0], [w - 1, 0]])
      masks << make_mask(cells[2][0], [[0, 0], [w - 1, 0]])
      masks << make_mask(cells[3][0], [[w - 1, 0]])
      masks << make_mask(cells[0][1], [[0, 0], [0, h - 1]])
      masks << make_mask(cells[1][1], [[0, 0], [w - 1, 0], [0, h - 1], [w - 1, h - 1]])
      masks << make_mask(cells[2][1], [[0, 0], [w - 1, 0], [0, h - 1], [w - 1, h - 1]])
      masks << make_mask(cells[3][1], [[w - 1, 0], [w - 1, h - 1]])
      masks << make_mask(cells[0][2], [[0, h - 1]])
      masks << make_mask(cells[1][2], [[0, h - 1], [w - 1, h - 1]])
      masks << make_mask(cells[2][2], [[0, h - 1], [w - 1, h - 1]])
      masks << make_mask(cells[3][2], [[w - 1, h - 1]])
      return @masks[balloonskin_name] = masks
    end
    
    def make_mask(cell, to_process)
      start_x = cell.x
      start_y = cell.y
      w = cell.width
      w1 = cell.width - 1
      h1 = cell.height - 1
      processed = Bitmask.new(w * cell.height)
      mask = Bitmask.new(w * cell.height)
      max = 0
      until to_process.empty?
        x, y = to_process.shift
        i = y * w + x
        max = [max, i].max
        if @bitmap.get_pixel(start_x + x, start_y + y).alpha < 192
          if x != 0
            to_process << [x - 1, y] if not processed[i - 1] and not to_process.include?([x - 1, y])
          end  
          if x != w1
            to_process << [x + 1, y] if not processed[i + 1] and not to_process.include?([x + 1, y])
          end  
          if y != 0
            to_process << [x, y - 1] if not processed[i - w] and not to_process.include?([x, y - 1])
          end  
          if y != h1
            to_process << [x, y + 1] if not processed[i + w] and not to_process.include?([x, y + 1])
          end
          mask[i] = true
        end
        processed[i] = true
      end
      mask.resize(max)
      return mask
    end
    
    def mask(balloonskin_name, n)
      if @masks[balloonskin_name].nil?
        compile(balloonskin_name)
      end
      return @masks[balloonskin_name][n]
    end
  end

  if PRECOMPILE_BALLOONSKINS
    for entry in Dir.entries("Graphics/Balloonskins")
      next if entry == "." or entry == ".."
      self.compile(entry.split(".").first)
      # Update graphics to prevent script hanging error
      Graphics.update
    end
  end
  
  def balloonskin_initialize
    # Make viewport
    viewport = Viewport.new(0, 0, 640, 480)
    # Make skin sprite
    @skin = Sprite.new(viewport)
    # Make border sprite
    @border = Sprite.new(viewport)
    @border.color = Color.new(255, 255, 255, 0)
    # Make waiting sprite
    @sprite_wait = Sprite.new(viewport)
    @sprite_wait.visible = false
    @wait_count = 0
    @blink_count = 0
  end
  
  def balloonskin_name=(name)
    @balloonskin_name = name
    bitmap = RPG::Cache.balloonskin(name)
    @sprite_wait.bitmap = bitmap
    @wait_rect = [
      Rect.new(bitmap.width * 7 / 8, 0, bitmap.width / 16, bitmap.height / 6),
      Rect.new(bitmap.width * 15 / 16, 0, bitmap.width / 16, bitmap.height / 6),
      Rect.new(bitmap.width * 7 / 8, bitmap.height / 6, bitmap.width / 16, bitmap.height / 6),
      Rect.new(bitmap.width * 15 / 16, bitmap.height / 6, bitmap.width / 16, bitmap.height / 6)
    ]
    @wait_rect_index = 3
  end
  
  def render_balloonskin
    # Load skin bitmap
    bitmap = RPG::Cache.balloonskin(@balloonskin_name)
    # Compute cell width and height
    w = bitmap.width >> 3
    h = bitmap.height / 3
    # Compute cells
    cells = []
    for i in 0...4
      a = []
      for j in 0...3
        a << Rect.new(i * w, j * h, w, h)
      end
      cells << a
    end
    # Dispose graphics if previously rendered
    @skin.bitmap.dispose if @skin.bitmap
    @border.bitmap.dispose if @border.bitmap
    # Adjust position
    @skin.oy = @border.oy = h
    # Make skin bitmap
    @skin.bitmap = Bitmap.new(self.width, self.height + 2 * h)
    @skin.bitmap.stretch_blt(@skin.bitmap.rect, bitmap, Rect.new(4 * w, 0, 3 * w, 3 * h))
    # Clear outside corners
    @skin.bitmap.fill_rect(0, 0, w, h, Color::TRANSPARENT)
    @skin.bitmap.fill_rect(self.width - w, 0, w, h, Color::TRANSPARENT)
    @skin.bitmap.fill_rect(0, self.height + h, w, h, Color::TRANSPARENT)
    @skin.bitmap.fill_rect(self.width - w, self.height + h, w, h, Color::TRANSPARENT)
    # Make border bitmap
    @border.bitmap = Bitmap.new(self.width, self.height + 2 * h)
    # Draw upper-left corner
    @skin.bitmap.trim(0, h, w, mask(0))
    @border.bitmap.blt(0, h, bitmap, cells[0][0])
    # Draw upper-right corner
    @skin.bitmap.trim(self.width - w, h, w, mask(3))
    @border.bitmap.blt(self.width - w, h, bitmap, cells[3][0])
    # Draw lower-left corner
    @skin.bitmap.trim(0, self.height, w, mask(8))
    @border.bitmap.blt(0, self.height, bitmap, cells[0][2])
    # Draw lower-right corner
    @skin.bitmap.trim(self.width - w, self.height, w, mask(11))
    @border.bitmap.blt(self.width - w, self.height, bitmap, cells[3][2])
    # Draw left side
    for i in 2..self.height / h - 1
      y = i * h
      @skin.bitmap.trim(0, y, w, mask(4))
      @border.bitmap.blt(0, y, bitmap, cells[0][1])
    end
    # Draw right side
    x = self.width - w
    for i in 2..self.height / h - 1
      y = i * h
      @skin.bitmap.trim(x, y, w, mask(7))
      @border.bitmap.blt(x, y, bitmap, cells[3][1])
    end
    # Compute where to put the tail
    for i in 1..self.width / w - 2
      x_quote = i
      if @event.real_x / 4 - $game_map.display_x / 4 < self.x + i * w
        break
      end
    end
    # Draw lower side
    y = self.height
    for i in 1..self.width / w - 2
      x = i * w
      if @event.real_y / 4 - 32 - $game_map.display_y / 4 > self.y
        if i == x_quote
          @skin.bitmap.trim(x, y, w, mask(10))
          @border.bitmap.blt(x, y, bitmap, cells[2][2])
          @skin.bitmap.trim(x, y + h, w, mask(5))
          @border.bitmap.blt(x, y + h, bitmap, cells[1][1])
          next
        end
      end
      @skin.bitmap.trim(x, y, w, mask(9))
      @border.bitmap.blt(x, y, bitmap, cells[1][2])
      @skin.bitmap.fill_rect(x, y + h, w, h, Color::TRANSPARENT)
    end
    # Draw upper side
    y = h
    for i in 1..self.width / w - 2
      x = i * w
      if @event.real_y / 4 - 32 - $game_map.display_y / 4 < self.y
        if i == x_quote
          @skin.bitmap.trim(x, y, w, mask(2))
          @border.bitmap.blt(x, y, bitmap, cells[2][0])
          @skin.bitmap.trim(x, 0, w, mask(6))
          @border.bitmap.blt(x, 0, bitmap, cells[2][1])
          next
        end
      end
      @skin.bitmap.trim(x, y, w, mask(1))
      @border.bitmap.blt(x, y, bitmap, cells[1][0])
      @skin.bitmap.fill_rect(x, 0, w, h, Color::TRANSPARENT)
    end
  end
  
  def mask(n)
    return Balloonskin.mask(@balloonskin_name, n)
  end
  
  def dispose
    @skin.bitmap.dispose
    @skin.dispose
    @border.bitmap.dispose
    @border.dispose
    @sprite_wait.dispose
    super
  end
  
  def x=(x)
    @sprite_wait.x = x + self.width - 32
    @skin.x = @border.x = super(x)
  end
  
  def y=(y)
    @sprite_wait.y = y + self.height - 32
    @skin.y = @border.y = super(y)
  end
  
  def z=(z)
    @skin.z = @border.z = @sprite_wait.z = super(z)
  end
  
  def opacity=(opacity)
    @skin.opacity = @border.opacity = super(opacity)
  end
  
  def back_opacity=(opacity)
    @skin.opacity = super(opacity)
  end
end