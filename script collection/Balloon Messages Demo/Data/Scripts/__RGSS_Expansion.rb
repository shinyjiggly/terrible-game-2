class Game_Temp
  attr_accessor :last_face_id
  
  alias mp_face_initialize initialize
  def initialize
    mp_face_initialize
    @last_face_id = PICTURE_ID_FACE.first
  end
end

class Scene_Map
  attr_reader :message_window
end