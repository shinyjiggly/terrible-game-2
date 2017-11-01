# ==============================================================================
# AUTOMATIC TRANSITIONS
# ------------------------------------------------------------------------------
# Modifies the Scene_Base class so that each type of scene searches the
# transition folder for a specific transition, selects it if found, selects
# the default transition otherwise. You may use a different transition for
# fade-in and fade-out.
# ------------------------------------------------------------------------------
# EXAMPLE: the Scene_Menu will search for Transitions/Menu.png and automatically
# use it if it exists.
# EXAMPLE 2: when exiting the menu, the Scene_Menu will search for
# Transitions/Menu-out.png and automatically use it if it exists.
# ------------------------------------------------------------------------------
# REQUIRES: Moonpearl's Scene_Base
# ==============================================================================

class Scene_Base
  def main
    setup
    str = type.to_s
    str.slice!("Scene_")
    # Execute transition
    if FileTest.exist?("Graphics/Transitions/#{str}.png")
      Graphics.transition(40, "Graphics/Transitions/" + str)
    else
      Graphics.transition
    end
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
    str = type.to_s
    str.slice!("Scene_")
    str += "-out"
    # Execute transition
    if FileTest.exist?("Graphics/Transitions/#{str}.png")
      Graphics.transition(40, "Graphics/Transitions/" + str)
      Graphics.freeze
    end
  end
end

# ==============================================================================
# AUTOMATIC WINDOWSKINS
# ------------------------------------------------------------------------------
# Modifies the Window_Base class so that each type of window searches the
# windowskin folder for a specific windowskin, selects it if found, selects
# the default windowskin otherwise.
# ------------------------------------------------------------------------------
# EXAMPLE: the Window_Menu will search for Windowskins/Menu.png and automatically
# use it if it exists.
# ==============================================================================

class Window_Base < Window
  def initialize(x, y, width, height)
    super()
  #--------------------------------------------------------------------------
    str = type.to_s
    str.slice!("Window_")
    @windowskin_name = FileTest.exist?("Graphics/Windowskins/#{str}.png") ? str : $game_system.windowskin_name
  #--------------------------------------------------------------------------
    self.windowskin = RPG::Cache.windowskin(@windowskin_name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.z = 100
  end
  
  def update
    super
  end
end