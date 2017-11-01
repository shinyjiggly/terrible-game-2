#==============================================================================
# ** Scene_File
#==============================================================================

class Scene_File
  #--------------------------------------------------------------------------
  SAVEFILE_MAX = 16
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make help window
    @help_window = Window_Help.new
    @help_window.set_text(@help_text)
    # Make back window
    @back_window = Window_Back.new
    # Make save file window
    @savefile_windows = []
    @cursor_displace = 0
    for i in 0..2
      @savefile_windows.push(Window_SaveFile.new(i, make_filename(i), i))
    end
    # Select last file to be operated
    @file_index = $game_temp.last_file_index #0
    @savefile_windows[@file_index].selected = true
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @help_window.dispose
    @back_window.dispose
    for i in @savefile_windows
      i.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update windows
    @help_window.update
    for i in @savefile_windows
      i.update
    end
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
      # or cursor position is more in front than SAVEFILE_MAX - 1
      if Input.trigger?(Input::DOWN) or @file_index < SAVEFILE_MAX - 1
        if @file_index == SAVEFILE_MAX - 1
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Displace the cursor down
        @cursor_displace += 1
        if @cursor_displace == 3
          @cursor_displace = 2
          for i in @savefile_windows
            i.dispose
          end
          @savefile_windows = []
          for i in 0..2
            f = i - 1 + @file_index
            name = make_filename(f)
            @savefile_windows.push(Window_SaveFile.new(f, name, i))
            @savefile_windows[i].selected = false
          end
        end
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Select the file index
        @file_index = (@file_index + 1)
        if @file_index == SAVEFILE_MAX
          @file_index = SAVEFILE_MAX - 1
        end
        for i in 0..2
          @savefile_windows[i].selected = false
        end
        @savefile_windows[@cursor_displace].selected = true
        return
      end
    end
    # If the up directional button was pressed
    if Input.repeat?(Input::UP)
      # If the up directional button pressed down is not a repeat,
      # or cursor position is more in back than 0
      if Input.trigger?(Input::UP) or @file_index > 0
        if @file_index == 0
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Displace the cursor up
        @cursor_displace -= 1
        if @cursor_displace == -1
          @cursor_displace = 0
          for i in @savefile_windows
            i.dispose
          end
          @savefile_windows = []
          for i in 0..2
            f = i - 1 + @file_index
            name = make_filename(f)
            @savefile_windows.push(Window_SaveFile.new(f, name, i))
            @savefile_windows[i].selected = false
          end
        end
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Select the file index
        @file_index = (@file_index - 1)
        if @file_index == -1
          @file_index = 0
        end
        for i in 0..2
          @savefile_windows[i].selected = false
        end
        @savefile_windows[@cursor_displace].selected = true
        return
      end
    end
  end
end

#==============================================================================
# Scene_Save
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(Vocab::SAVE_ASK)
  end
  #--------------------------------------------------------------------------
  # * Decision Processing
  #--------------------------------------------------------------------------
  def on_decision(filename)
    # Play save SE
    $game_system.se_play($data_system.save_se)
    # Write save data
    file = File.open(filename, "wb")
    write_save_data(file)
    file.close
    # If called from event
    if $game_temp.save_calling
      # Clear save call flag
      $game_temp.save_calling = false
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
    # Switch to menu screen
    $scene = Scene_Menu.new(3)
  end
  #--------------------------------------------------------------------------
  # * Cancel Processing
  #--------------------------------------------------------------------------
  def on_cancel
    # Play cancel SE
    $game_system.se_play($data_system.cancel_se)
    # If called from event
    if $game_temp.save_calling
      # Clear save call flag
      $game_temp.save_calling = false
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
    # Switch to menu screen
    $scene = Scene_Menu.new(3)
  end
end

#==============================================================================
# ** Scene_Load
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Remake temporary object
    $game_temp = Game_Temp.new
    # Timestamp selects new file
    $game_temp.last_file_index = 0
    latest_time = Time.at(0)
    for i in 0..3
      filename = make_filename(i)
      if FileTest.exist?(filename)
        file = File.open(filename, "r")
        if file.mtime > latest_time
          latest_time = file.mtime
          $game_temp.last_file_index = i
        end
        file.close
      end
    end
    super(Vocab::LOAD_ASK)
  end
end