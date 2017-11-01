#==============================================================================
# ** Scene_Title
#==============================================================================

class Scene_Title
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # If battle test
    if $BTEST
      battle_test
      return
    end
    # Load database
    $data_actors        = load_data("Data/Actors.rxdata")
    $data_classes       = load_data("Data/Classes.rxdata")
    $data_skills        = load_data("Data/Skills.rxdata")
    $data_items         = load_data("Data/Items.rxdata")
    $data_weapons       = load_data("Data/Weapons.rxdata")
    $data_armors        = load_data("Data/Armors.rxdata")
    $data_enemies       = load_data("Data/Enemies.rxdata")
    $data_troops        = load_data("Data/Troops.rxdata")
    $data_states        = load_data("Data/States.rxdata")
    $data_animations    = load_data("Data/Animations.rxdata")
    $data_tilesets      = load_data("Data/Tilesets.rxdata")
    $data_common_events = load_data("Data/CommonEvents.rxdata")
    $data_system        = load_data("Data/System.rxdata")
    # Make system object
    $game_system = Game_System.new
    # Make title graphic
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title($data_system.title_name)
    # Make command window
    s1 = Vocab::NEW_GAME
    s2 = Vocab::LOAD_GAME
    s3 = Vocab::EXIT_GAME
    @command_window = Window_Command.new(200, [s1, s2, s3])
    @command_window.x = 320 - @command_window.width / 2
    @command_window.y = 300
    # Continue enabled determinant
    @continue_enabled = false
    for i in 0..3
      if FileTest.exist?("Save#{i+1}.rxdata")
        @continue_enabled = true
      end
    end
    if not @continue_enabled
      @command_window.disable_item(1)
    end
    # Play title BGM
    $game_system.bgm_play($data_system.title_bgm)
    # Stop playing ME and BGS
    Audio.me_stop
    Audio.bgs_stop
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
    # Dispose of command window
    @command_window.dispose
    # Dispose of title graphic
    @sprite.bitmap.dispose
    @sprite.dispose
  end
end