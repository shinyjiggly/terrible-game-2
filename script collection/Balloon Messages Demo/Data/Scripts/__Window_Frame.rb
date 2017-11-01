class Window_Frame < Window_Base
  @@objects = {}
  
  class << self
    def [](id)
      return @@objects[id]
    end
  end
  
  def initialize(picture_id)
    if not @@objects[picture_id].nil?
      @@objects[picture_id].dispose
    end
    @@objects[picture_id] = self
    @picture_id = picture_id
    picture = $game_screen.pictures[@picture_id]
    super(picture.x, picture.y, WIDTH_FRAME + 2 * PADDING_FRAME,
      HEIGHT_FRAME + 2 * PADDING_FRAME)
    self.z = 100
  end
  
  def dispose
    @@objects.delete(@picture_id)
    super
  end
end