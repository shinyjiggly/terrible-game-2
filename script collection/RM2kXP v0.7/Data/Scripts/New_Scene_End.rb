#==============================================================================
# ** Scene_End
#==============================================================================

class Scene_End
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make ask window
    @end_window = Window_End.new
    # Make back window
    @back_window = Window_Back.new
    # Make command window
    s1 = Vocab::QUIT_ASK_Y # Yes
    s2 = Vocab::QUIT_ASK_N # No
    @command_window = Window_Command.new(100, [s1,s2])
    @command_window.x = 275
    @command_window.y = 280 - @command_window.height / 2
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame Update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of window
    @command_window.dispose
    @end_window.dispose
    @back_window.dispose
    # If switching to title screen
    if $scene.is_a?(Scene_Title)
      # Fade out screen
      Graphics.transition
      Graphics.freeze
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update command window
    @command_window.update
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to menu screen
      $scene = Scene_Menu.new(4)
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by command window cursor position
      case @command_window.index
      when 0  # Yes
        command_to_title
      when 1  # No
        command_cancel
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Process When Choosing [Yes] (to title) Command
  #--------------------------------------------------------------------------
  def command_to_title
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Fade out BGM, BGS, and ME
    Audio.bgm_fade(800)
    Audio.bgs_fade(800)
    Audio.me_fade(800)
    # Switch to title screen
    $scene = Scene_Title.new
  end
  #--------------------------------------------------------------------------
  # * Process When Choosing [No] (to menu) Command
  #--------------------------------------------------------------------------
  def command_cancel
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Switch to menu screen
    $scene = Scene_Menu.new(4)
  end
end
