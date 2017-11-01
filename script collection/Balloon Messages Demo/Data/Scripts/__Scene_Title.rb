#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs title screen processing.
#==============================================================================

class Scene_Title < Scene_Base
  def setup
    # If battle test
    if $BTEST
      battle_test
      return
    end
    RPG.load_database
    # Make system object
    $game_system = Game_System.new
    RPG.make_game_objects
    # Make title graphic
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title($data_system.title_name)
    # Play title BGM
    $game_system.bgm_play($data_system.title_bgm)
    # Stop playing ME and BGS
    Audio.me_stop
    Audio.bgs_stop
    # Make command sprite
    s1 = "New Game"
    s2 = "Continue"
    s3 = "Shutdown"
    
    @sprites = [ @command_window = Window_Command.new(192, [s1, s2, s3]) ]
    @command_window.back_opacity = 160
    @command_window.x = 320 - @command_window.width / 2
    @command_window.y = 288
    # Continue enabled determinant
    # Check if at least one save file exists
    # If enabled, make @continue_enabled true; if disabled, make it false
    @continue_enabled = false
    for i in 0..3
      if FileTest.exist?("Save#{i+1}.rxdata")
        @continue_enabled = true
      end
    end
    # If continue is enabled, move cursor to "Continue"
    # If disabled, display "Continue" text in gray
    if @continue_enabled
      @command_window.index = 1
    else
      @command_window.disable_item(1)
    end
  end
  
  def terminate
    super
    # Dispose of title graphic
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by command sprite cursor position
      case @command_window.index
      when 0  # New game
        command_new_game
      when 1  # Continue
        command_continue
      when 2  # Shutdown
        command_shutdown
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Command: New Game
  #--------------------------------------------------------------------------
  def command_new_game
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Stop BGM
    Audio.bgm_stop
    # Reset frame count for measuring play time
    Graphics.frame_count = 0
    RPG.make_game_objects
    # Set up initial party
    $game_party.setup_starting_members
    # Set up initial map position
    $game_map.setup($data_system.start_map_id)
    # Move player to initial position
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    # Refresh player
    $game_player.refresh
    # Run automatic change for BGM and BGS set with map
    $game_map.autoplay
    # Update map (run parallel process event)
    $game_map.update
    # Switch to map screen
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # * Command: Continue
  #--------------------------------------------------------------------------
  def command_continue
    # If continue is disabled
    unless @continue_enabled
      # Play buzzer SE
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Switch to load screen
    $scene = Scene_Load.new
  end
  #--------------------------------------------------------------------------
  # * Command: Shutdown
  #--------------------------------------------------------------------------
  def command_shutdown
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Fade out BGM, BGS, and ME
    Audio.bgm_fade(800)
    Audio.bgs_fade(800)
    Audio.me_fade(800)
    # Shutdown
    $scene = nil
  end
  #--------------------------------------------------------------------------
  # * Battle Test
  #--------------------------------------------------------------------------
  def battle_test
    # Load database (for battle test)
    $data_actors        = load_data("Data/BT_Actors.rxdata")
    $data_classes       = load_data("Data/BT_Classes.rxdata")
    $data_skills        = load_data("Data/BT_Skills.rxdata")
    $data_items         = load_data("Data/BT_Items.rxdata")
    $data_weapons       = load_data("Data/BT_Weapons.rxdata")
    $data_armors        = load_data("Data/BT_Armors.rxdata")
    $data_enemies       = load_data("Data/BT_Enemies.rxdata")
    $data_troops        = load_data("Data/BT_Troops.rxdata")
    $data_states        = load_data("Data/BT_States.rxdata")
    $data_animations    = load_data("Data/BT_Animations.rxdata")
    $data_tilesets      = load_data("Data/BT_Tilesets.rxdata")
    $data_common_events = load_data("Data/BT_CommonEvents.rxdata")
    $data_system        = load_data("Data/BT_System.rxdata")
    # Reset frame count for measuring play time
    Graphics.frame_count = 0
    RPG.make_game_objects
    # Set up party for battle test
    $game_party.setup_battle_test_members
    # Set troop ID, can escape flag, and battleback
    $game_temp.battle_troop_id = $data_system.test_troop_id
    $game_temp.battle_can_escape = true
    $game_map.battleback_name = $data_system.battleback_name
    # Play battle start SE
    $game_system.se_play($data_system.battle_start_se)
    # Play battle BGM
    $game_system.bgm_play($game_system.battle_bgm)
    # Switch to battle screen
    $scene = Scene_Battle.new
  end
end
