class Scene_Base
  def main
    setup
    # Execute transition
    Graphics.transition
    # Main loop
    while $scene == self
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
    end
    terminate
  end
  
  def setup
    @sprites = []
  end
  
  def terminate
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    for sprite in @sprites
      sprite.dispose
    end
  end
  
  def update
    for sprite in @sprites
      sprite.update
    end
  end
end