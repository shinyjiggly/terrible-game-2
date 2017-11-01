class Game_Picture
  attr_accessor :displace_x, :displace_y
  
  alias mp_face_initialize initialize
  def initialize(number)
    mp_face_initialize(number)
    @displace_x = @displace_y = 0
  end
  
  alias mp_face_show show
  def show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    mp_face_show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    if PICTURE_ID_FACE.include?(@number)
      Window_Frame.new(@number)
      $game_temp.last_face_id = @number
    end
  end

  alias mp_face_erase erase
  def erase
    mp_face_erase
    unless Window_Frame[@number].nil?
      Window_Frame[@number].dispose
    end
  end
  
  alias mp_face_update update
  def update
    mp_face_update
    unless Window_Frame[@number].nil?
      window = Window_Frame[@number]
      window.x = self.x - PADDING_FRAME
      window.y = self.y - PADDING_FRAME
      window.opacity = @opacity * OPACITY_FRAME / 256
    end
  end
  
  def x
    return @x + @displace_x
  end
  
  def y
    return @y + @displace_y
  end
end