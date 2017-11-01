# Jaber's Super-Simple Message System v1.11
class Message_Data
 
  attr_accessor :pos, :face, :face_pos, :name, :name_pos, :offset, :battle_pos,
            :battle_offset, :opacity, :back_opacity, :face_offset, :last_data,
            :small_name
 
  def initialize
    @pos = 2
    @face = nil
    @face_pos = 4
    @name = nil
    @name_pos = 8
    @offset = 16
    @battle_pos = 8
    @battle_offset = 16
    @opacity = 255
    @back_opacity = 160
    @face_offset = 12
    @last_data = [@pos, @face, @face_pos, @name, @name_pos]
    @small_name = true
  end
 
  def get_data
    return [@pos, @face, @face_pos, @name, @name_pos]
  end
 
end
 
class Game_System
 
  attr_accessor :message_settings
 
  alias jaber_init initialize unless method_defined?(:jaber_init)
  def initialize
    jaber_init
    $message = nil
  end
 
end
 
class Scene_Save < Scene_File
 
  alias jaber_write_save write_save_data unless method_defined?(:jaber_write_save)
  def write_save_data(file)
    $game_system.message_settings = $message
    jaber_write_save(file)
  end
 
end
 
class Window_Message < Window_Selectable
 
  alias jaber_init initialize unless method_defined?(:jaber_init)
  def initialize
    jaber_init
    @face_window = Window_Face.new
    if $message == nil
      if $game_system.message_settings != nil
        $message = $game_system.message_settings
      else
        $message = Message_Data.new
      end
    end
  end
 
  alias jaber_dispose dispose unless method_defined?(:jaber_dispose)
  def dispose
    @face_window.dispose
    jaber_dispose
  end
 
  def reset_window
    pos = $game_temp.in_battle ? $message.battle_pos : $message.pos
    off = $game_temp.in_battle ? $message.battle_offset : $message.offset
    self.x = 0 if [1,4,7].include?(pos)
    self.x = 80 if [2,5,8].include?(pos)
    self.x = 160 if [3,6,9].include?(pos)
    self.y = 0 + off if [7,8,9].include?(pos)
    self.y = 160 if [4,5,6].include?(pos)
    self.y = 320 - off if [1,2,3].include?(pos)
    self.x += pos == 4 ? off : pos == 6 ? -off : 0
    self.back_opacity = $message.back_opacity
    self.opacity = $message.opacity
    @face_window.opacity = self.opacity
    @face_window.back_opacity = self.back_opacity
    case $message.face_pos
    when 1
      @face_window.x = self.x
      @face_window.y = self.y + self.height
    when 2
      @face_window.x = (self.x + (self.width / 2)) - (@face_window.width / 2)
      @face_window.y = self.y + self.height
    when 3
      @face_window.x = (self.x + self.width) - @face_window.width
      @face_window.y = self.y + self.height
    when 4
      @face_window.x = self.x - @face_window.width
      @face_window.y = self.y
    when 5 # darling!
      @face_window.x = self.x + (self.width / 2) - (@face_window.width / 2)
      @face_window.y = self.y
    when 6
      @face_window.x = self.x + self.width
      @face_window.y = self.y
    when 7
      @face_window.x = self.x
      @face_window.y = self.y - @face_window.height
    when 8
      @face_window.x = (self.x + (self.width / 2)) - (@face_window.width / 2)
      @face_window.y = self.y - @face_window.height
    when 9
      @face_window.x = (self.x + self.width) - @face_window.width
      @face_window.y = self.y - @face_window.height
    end
    @face_window.update_name
    if $message.name == nil and $message.face == nil
      @face_window.visible = false
    else
      @face_window.visible = true
    end
    if @face_window.need_update
      @face_window.contents_opacity = 0 if @face_window.face != $message.face or @face_window.face == nil
      @face_window.update_face
    end
  end
 
  alias jaber_update update unless method_defined?(:jaber_update)
  def update
    @face_window.opacity = self.opacity
    @face_window.back_opacity = self.back_opacity
    @face_window.contents_opacity += 24 if @face_window.contents_opacity < 255
    @face_window.visible = false if $game_temp.message_text == nil and @face_window.showing
    @face_window.update
    jaber_update
  end
 
end
 
class Window_Face < Window_Base # Hey, that rhymes! Sort of!
 
  attr_accessor :face, :name
 
  def initialize
    @name_window = Window_Name.new
    super(0,0,160,160)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 9998
    self.opacity = 0
    self.back_opacity = 0
    self.contents_opacity = 0
    self.visible = false
    @name = nil
    @face = nil
    @name_pos = nil
    @face_offset = nil
  end
 
  def need_update
    if $message.last_data != $message.get_data
      $message.last_data = $message.get_data.dup
      @name = nil
      @face = nil
      return true
    end
    return (@face != $message.face or @name != $message.name or @face_offset != $message.face_offset or @name_pos != $message.name_pos)
  end
 
  def update_face
    @face = $message.face
    @name = $message.name
    @face_offset = $message.face_offset
    @name_pos = $message.name_pos
    self.contents.clear
    if $message.face == nil and $message.name != nil and $message.small_name == true
      self.visible = false
      align = [7,4,1].include?($message.name_pos) ? 0 : [8,5,2].include?($message.name_pos) ? 1 : 2
      @name_window.update($message.name.to_s, align)
      @name_window.visible = true
    else
      @visible = true
      @name_window.visible = false
      if $message.face != nil
        bitmap = RPG::Cache.picture($message.face) rescue bitmap = nil
        self.contents.blt((self.contents.width - bitmap.width) / 2, ((self.contents.height - bitmap.height) / 2) + $message.face_offset, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height)) if bitmap != nil
      end
      if $message.name != nil
        align = [7,4,1].include?($message.name_pos) ? 0 : [8,5,2].include?($message.name_pos) ? 1 : 2
        y = [7,8,9].include?($message.name_pos) ? 0 : [4,5,6].include?($message.name_pos) ? (self.contents.height / 2) - 12 : self.contents.height - 24
        self.contents.draw_text(0, y, self.contents.width, 24, $message.name.to_s, align)
      end
    end
  end
 
  def visible=(bool)
    @name_window.visible = false unless bool
    super(bool)
  end
 
  def update
    update_name
    super
  end
 
  def update_name
    @name_window.x = self.x
    @name_window.y = self.y
    if [4,5,6].include?($message.face_pos)
      @name_window.y += 80 - (@name_window.height / 2) if [4,5,6].include?($message.name_pos)
      @name_window.y += 160 - @name_window.height if [1,2,3].include?($message.name_pos)
    end
    @name_window.y += 160 - @name_window.height if [7,8,9].include?($message.face_pos)
  end
 
  def opacity=(val)
    @name_window.opacity = val
    super(val)
  end
 
  def back_opacity=(val)
    @name_window.back_opacity = val
    super(val)
  end
 
  def contents_opacity=(val)
    @name_window.contents_opacity = val
    super(val)
  end
 
  def dispose
    @name_window.dispose
    super
  end
 
  def showing
    return (self.visible or @name_window.visible)
  end
 
end
 
class Window_Name < Window_Base
 
  def initialize
    super(0,0,160,64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 9998
    self.opacity = 0
  end
 
  def update(name, align)
    self.contents.clear
    self.contents.draw_text(0, 0, self.contents.width, 24, name, align)
    super()
  end
 
end