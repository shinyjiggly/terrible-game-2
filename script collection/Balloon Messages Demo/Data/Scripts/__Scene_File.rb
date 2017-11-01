#==============================================================================
# ** Scene_File
#------------------------------------------------------------------------------
#  This is a superclass for the save screen and load screen.
#==============================================================================

class Scene_File < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     help_text : text string shown in the help sprite
  #--------------------------------------------------------------------------
  def initialize(help_text)
    @help_text = help_text
  end
  
  def setup
    # Select last file to be operated
    @file_index = $game_temp.last_file_index
    @savefile_windows = []
    # Make help sprite
    @sprites = [
      @help_window = Window_Help.new,
    ]
    # Make save file sprite      
    (0..3).each { |i| @savefile_windows.push(Window_SaveFile.new(i, make_filename(i))) }
    @sprites |= @savefile_windows
    @help_window.set_text(@help_text)
    @savefile_windows[@file_index].selected = true
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Call method: on_decision (defined by the subclasses)
      on_decision(make_filename(@file_index))
      $game_temp.last_file_index = @file_index
      return
    end
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Call method: on_cancel (defined by the subclasses)
      on_cancel
      return
    end
    # If the down directional button was pressed
    if Input.repeat?(Input::DOWN)
      # If the down directional button pressed down is not a repeat,
      # or cursor position is more in front than 3
      if Input.trigger?(Input::DOWN) or @file_index < 3
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Move cursor down
        @savefile_windows[@file_index].selected = false
        @file_index = (@file_index + 1) % 4
        @savefile_windows[@file_index].selected = true
        return
      end
    end
    # If the up directional button was pressed
    if Input.repeat?(Input::UP)
      # If the up directional button pressed down is not a repeat?
      # or cursor position is more in back than 0
      if Input.trigger?(Input::UP) or @file_index > 0
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Move cursor up
        @savefile_windows[@file_index].selected = false
        @file_index = (@file_index + 3) % 4
        @savefile_windows[@file_index].selected = true
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Make File Name
  #     file_index : save file index (0-3)
  #--------------------------------------------------------------------------
  def make_filename(file_index)
    return "Save#{file_index + 1}.rxdata"
  end
end
