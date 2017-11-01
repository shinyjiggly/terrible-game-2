#==============================================================================
# ** Window_Back
#==============================================================================

class Window_Back < Window_Base 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(-32, -32, 640+64, 480+64)
    self.opacity = 0
    self.z = 0
    self.contents = Bitmap.new(width, height) # (width - 32, height - 32)
    # Create the back bitmap
    bitmap = RPG::Cache.system($game_system.windowskin_name)
    self.contents.stretch_blt(Rect.new(0, 0, 640+32, 480+32), bitmap, Rect.new(0, 32, 16, 16))
  end
end

#==============================================================================
# ** Window_Gold
#==============================================================================

class Window_Gold < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(plus=0) # simple plus width system
    super(0, 0, 180+plus, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh(plus)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(plus=0)
    self.contents.clear
    cx = contents.text_size($data_system.words.gold).width
    self.contents.draw_text(24+plus, 0, 120-cx-2, 32, $game_party.gold.to_s, 2, 0)
    self.contents.draw_text(144+plus-cx, 0, cx, 32, $data_system.words.gold, 2, 1)
  end
end

#==============================================================================
# ** Window_MenuStatus
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 460, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_face(actor, x+30, y + 96)
      draw_actor_name(actor, x+42, y)
      draw_actor_class(actor, x+244, y)
      draw_actor_level(actor, x+42, y+32)
      draw_actor_state(actor, x + 115, y + 32)
      draw_actor_exp(actor, x+42, y + 64)
      draw_actor_hp(actor, x + 226, y + 32)
      draw_actor_sp(actor, x + 226, y + 64)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rect
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(-6, (@index * 116)-6, self.width - 20, 110)
    end
  end
end

#==============================================================================
# ** Window_Item
#==============================================================================

class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 640, 416)
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 64
      self.height = 256
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if item.is_a?(RPG::Item) and
       $game_party.item_can_use?(item.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.draw_icon(x, y + 4, 24, 24, item.icon_name, opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, "x", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end

#==============================================================================
# ** Window_Skill
#==============================================================================

class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 128, 640, 352)
    @actor = actor
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 64
      self.height = 256
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    opacity = 255
    if not skill.icon_name.include?("2k_")
      opacity = self.contents.font.color == normal_color ? 255 : 128
    end
    self.contents.draw_icon(x, y + 4, 24, 24, skill.icon_name, opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    self.contents.draw_text(x + 232, y, 48, 32, skill.sp_cost.to_s, 2)
  end
end

#==============================================================================
# ** Window_SkillStatus
#==============================================================================

class Window_SkillStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_level(@actor, 100, 0)
    draw_actor_state(@actor, 180, 0)
    draw_actor_hp(@actor, 284, 0)
    draw_actor_sp(@actor, 460, 0)
  end
end

#==============================================================================
# ** Window_Target
#==============================================================================

class Window_Target < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 432, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z += 10
    @item_max = $game_party.actors.size
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...$game_party.actors.size
      x = 4+96
      y = i * 126
      actor = $game_party.actors[i]
      draw_actor_face(actor, x-6, y+96)
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      draw_actor_level(actor, x + 8, y + 32)
      draw_actor_state(actor, x + 8, y + 64)
      draw_actor_hp(actor, x + 152, y + 32)
      draw_actor_sp(actor, x + 152, y + 64)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rect
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index <= -2
      self.cursor_rect.set(-6, (@index + 10) * 126, self.width - 24, 96)
    elsif @index == -1
      self.cursor_rect.set(-6, -6, self.width - 24, (@item_max * 126) - 32 + 12)
    else
      self.cursor_rect.set(-6, (@index * 126)- 6, self.width - 24, 96 + 12)
    end
  end
end

#==============================================================================
# ** Window_EquipLeft
#==============================================================================

class Window_EquipLeft < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_level(@actor, 4, 32)
    draw_actor_parameter(@actor, 4, 64, 0)
    draw_actor_parameter(@actor, 4, 96, 1)
    if @new_atk != nil 
      if @new_atk > @actor.atk
        self.contents.draw_text(200, 64, 36, 32, @new_atk.to_s, 2, 2)
      elsif @new_atk < @actor.atk
        self.contents.draw_text(200, 64, 36, 32, @new_atk.to_s, 2, 3)
      else
        self.contents.draw_text(200, 64, 36, 32, @new_atk.to_s, 2, 0)
      end
    end
    if @new_pdef != nil
      if @new_pdef > @actor.pdef
        self.contents.draw_text(200, 96, 36, 32, @new_pdef.to_s, 2, 2)
      elsif @new_pdef < @actor.pdef
        self.contents.draw_text(200, 96, 36, 32, @new_pdef.to_s, 2, 3)
      else
        self.contents.draw_text(200, 96, 36, 32, @new_pdef.to_s, 2, 0)
      end
    end
    if @new_mdef != nil
      # (do something)
    end
  end
end

#==============================================================================
# ** Window_EquipItem
#==============================================================================

class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    self.contents.font.color = normal_color
    self.contents.draw_icon(x, y + 4, 24, 24, item.icon_name)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, "x", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end

#==============================================================================
# ** Window_SaveFile
#==============================================================================

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     file_index : save file index (0-3)
  #     filename   : file name
  #     position   : window position
  #--------------------------------------------------------------------------
  def initialize(file_index, filename, position)
    y = 72 + position * 128
    super(0, y, 640, 128)
    self.contents = Bitmap.new(width - 32, height - 32)
    @file_index = file_index
    @filename = "Save#{@file_index + 1}.rxdata"
    @time_stamp = Time.at(0)
    @file_exist = FileTest.exist?(@filename)
    if @file_exist
      file = File.open(@filename, "r")
      @time_stamp = file.mtime
      @characters = Marshal.load(file)
      @frame_count = Marshal.load(file)
      @game_system = Marshal.load(file)
      @game_switches = Marshal.load(file)
      @game_variables = Marshal.load(file)
      
      @total_sec = @frame_count / Graphics.frame_rate
      file.close
    end
    refresh
    @selected = false
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    # Draw file number
    name = "File #{@file_index + 1}"
    # If save file exists
    if @file_exist
      self.contents.draw_text(4, 0, 600, 32, name, 0, 0)
      @name_width = contents.text_size(name).width
      # Draw character
      for i in 0...@characters.size
        bitmap = RPG::Cache.picture(@characters[i][0])
        cw = bitmap.width
        ch = bitmap.height
        src_rect = Rect.new(0, 0, cw, ch)
        x = 120 + (i * (cw+10))
        self.contents.blt(x, 0, bitmap, src_rect)
      end
      # Draw play time
#      hour = @total_sec / 60 / 60
#      min = @total_sec / 60 % 60
#      sec = @total_sec % 60
#      time_string = sprintf("%02d:%02d:%02d", hour, min, sec)
#     self.contents.draw_text(4, 8, 600, 32, time_string, 0)
      # Draw timestamp
      time_string1 = @time_stamp.strftime("%Y/%m/%d")
      time_string2 = @time_stamp.strftime("%H:%M")
      self.contents.draw_text(4, 40, 600, 32, time_string1)
      self.contents.draw_text(4, 62, 600, 32, time_string2)
    else
      self.contents.draw_text(4, 0, 600, 32, name, 0, 3)
      @name_width = contents.text_size(name).width
    end
  end
end

#==============================================================================
# ** Window_End
#==============================================================================

class Window_End < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(150, 150, 360, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    cx = contents.text_size($data_system.words.gold).width
    self.contents.draw_text(10, 0, 320, 32, Vocab::QUIT_ASK, 0, 0)
  end
end