# Party Splitting  
# by RPG Advocate


  # --Configurables--

  # This determines what keys are used by the system.
  # Note:  Input::Z = the 'D' button, and
  #        Input::Z = the 'A' button on your keyboard.
  #
  SWITCH_PARTY = Input::Z   # Key to change parties on the map.
  FINISH_PARTY = Input::X   # Key to finalize parties on the splitting menu.

  
  # This sets up whether a window tells the player if you're controlling a
  # split party, and what button is used to toggle between the parties.
  #
  SHOW_PARTY_HELP_SPRITE  = true              # If true, shows the help window
  SHOW_PARTY_X            = 540               # X-position for help window
  SHOW_PARTY_Y            = 450               # Y-position for help window
  SHOW_PARTY_FONT         = "Arial"           # Font used in the window
  SHOW_PARTY_SIZE         = 16                # Font size used
  SHOW_PARTY_TEXT         = "D: Change Party" # Help window text
  

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :pswitch_forbidden        # switch forbidden
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ps_initialize initialize
  def initialize
    ps_initialize
    @pswitch_forbidden = false
  end
end



#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :full_party               # party member array
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ps_initialize initialize
  def initialize
    ps_initialize
    @full_party = []
    @team1_actors = []
    @team2_actors = []
    @team1_map_id = 0
    @team2_map_id = 0
    @team1_x = 0
    @team2_x = 0
    @team1_y = 0
    @team2_y = 0
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #     team1 : qty of members for party #1
  #     team2 : qty of members for party #2 
  #--------------------------------------------------------------------------
  def split(team1 = 0, team2 = 0)
    # Print warning and exit if party is already split
    if @full_party != []
      print("Warning: Party is already split.")
      return
    end
    # Print warning and exit if no members in party
    if @actors.size == 0
      print("No characters in party.  Cannot complete operation.")
      return
    end
    @full_party = @actors
    @team1_actors = team1
    @team2_actors = team2
    @actors = @team1_actors
    @team1_map_id = $game_map.map_id
    @team1_x = $game_player.x
    @team1_y = $game_player.y
    @team2_map_id = $game_map.map_id
    @team2_x = $game_player.x
    @team2_y = $game_player.y
    # Print warnings if parties are empty
    print("Warning: Team 1 is empty.") if @team1_actors == []
    print("Warning: Team 2 is empty.") if @team2_actors == []
  end
  #--------------------------------------------------------------------------
  # * Party Unify
  #--------------------------------------------------------------------------
  def unify
    # Display warnings
    if @team1_actors == [] && @team2_actors == []
      print("Warning: The party is not split.")
    end
    if @team1_actors.size + @team2_actors.size > 4
      print("Warning: Sum of party members in split party exceeds 4.")
    end
    
    @actors = []
    for actor in @team1_actors
      @actors.push(actor)
    end
    for actor in @team2_actors
      @actors.push(actor)
    end
    @team1_actors = []
    @team2_actors = []
    @team1_map_id = 0
    @team2_map_id = 0
    @team1_x = 0
    @team2_x = 0
    @team1_y = 0
    @team2_y = 0
    @full_party = []
  end
  #--------------------------------------------------------------------------
  # * Party Switch
  #--------------------------------------------------------------------------
  def switch
    if @full_party == []
      print("Warning: The party is not split.")
      return
    end
    if @actors == @team1_actors
      current_control = 1
    elsif @actors == @team2_actors
      current_control = 2
    else
      print("Warning: Party composition has changed since it was split.")
      unify
      return
    end
    if current_control == 1
      @team1_map_id = $game_map.map_id
      @team1_x = $game_player.x
      @team1_y = $game_player.y
      @actors = @team2_actors
      new_map_id = @team2_map_id
      new_x = @team2_x
      new_y = @team2_y
    end
    if current_control == 2
      @team2_map_id = $game_map.map_id
      @team2_x = $game_player.x
      @team2_y = $game_player.y
      @actors = @team1_actors
      new_map_id = @team1_map_id
      new_x = @team1_x
      new_y = @team1_y
    end
    $game_temp.player_new_map_id = new_map_id
    $game_temp.player_new_x = new_x
    $game_temp.player_new_y = new_y
    if $scene.is_a?(Scene_Map)
      Graphics.freeze
      $game_temp.transition_processing = true
      $game_temp.transition_name = ""
      $scene.transfer_player
    else
      print("This code must be called from the map")
    end
    $game_player.refresh
  end
end



#==============================================================================
# ** Window_PartySplitMain
#------------------------------------------------------------------------------
#  This window displays the split party windows on the party splitting screen.
#==============================================================================

class Window_PartySplitMain < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actors                   # actors array
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : X-Coordinate of Party Split Window
  #--------------------------------------------------------------------------
  def initialize(x)
    super(x, 64, 320, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actors = []
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor : actor
  #--------------------------------------------------------------------------
  def add_actor(actor)
    @actors.push(actor)
  end
  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor : actor
  #--------------------------------------------------------------------------
  def remove_actor(actor)
    @actors.delete(actor)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = @actors.size
    for j in 0...@actors.size
      x = 64
      y = j * 104
      actor = @actors[j]
      draw_actor_graphic(actor, x - 40, y + 52)
      draw_actor_name(actor, x, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x + 90, y + 32)
      draw_actor_hp(actor, x + 236, y + 32)
      draw_actor_sp(actor, x + 236, y + 64)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, @index * 104, self.width - 32, 96)
    end
  end
end



#==============================================================================
# ** Window_PartySplitMsg
#------------------------------------------------------------------------------
#  This message window is used to display text on the party splitting screen.
#==============================================================================

class Window_PartySplitMsg < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
  end
  #--------------------------------------------------------------------------
  # * Set party size message
  #     rs1 : required size for party #1
  #     rs2 : required size for party #2
  #--------------------------------------------------------------------------
  def set_message(rs1, rs2)
    if rs1 == 0 && rs2 == 0
      @message = "Please form two parties."
    elsif rs1 == rs2
      @message = "Please form two parties of " + rs1.to_s + "."
    else
      s1 = rs1.to_s
      s2 = rs2.to_s
      @message = "Please form one party of " + s1 + " and one party of " + s2 + "."
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(4, 0, 608, 32, @message)
  end
end



#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias ps_main main
  def main
    # Create Party Message window
    @change_sprite = Sprite.new
    @change_sprite.bitmap = Bitmap.new(100, 32)
    @change_sprite.x = SHOW_PARTY_X
    @change_sprite.y = SHOW_PARTY_Y
    @change_sprite.bitmap.clear
    # Perform the original call
    ps_main
    # Dispose of Party Message
    @change_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias ps_update update
  def update
    # If party is split, Party Message is available and switching not blocked
    if $game_party.full_party != [] && SHOW_PARTY_HELP_SPRITE &&
        !$game_system.pswitch_forbidden
      # Create and show Party Message
      @change_sprite = Sprite.new
      @change_sprite.bitmap = Bitmap.new(100, 32)
      @change_sprite.x = 540
      @change_sprite.y = 450
      @change_sprite.bitmap.clear
      @change_sprite.bitmap.font.name = SHOW_PARTY_FONT
      @change_sprite.bitmap.font.size = SHOW_PARTY_SIZE
      @change_sprite.bitmap.draw_text(0, 0, 100, 32, SHOW_PARTY_TEXT)
    else
      @change_sprite.bitmap.clear
    end
    # If Z button was pressed
    if Input.trigger?(SWITCH_PARTY) && !$game_system.pswitch_forbidden
      # Perform switch if party is split
      $game_party.switch if $game_party.full_party != []
    end    
    # The original call
    ps_update
  end
end  



#==============================================================================
# ** Scene_PartySplit
#------------------------------------------------------------------------------
#  This class performs party splitting processing.
#==============================================================================

class Scene_PartySplit
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     required_size1 : required size for party #1
  #     required_size2 : required size for party #2
  #     cancel_allowed : if cancel permitted
  #--------------------------------------------------------------------------
  def initialize(required_size1, required_size2, cancel_allowed)
    @rs1 = required_size1
    @rs2 = required_size2
    @cancel_allowed = cancel_allowed
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    warning = "Parties are not the proper size."
    @help_window = Window_PartySplitMsg.new
    @help_window.set_message(@rs1, @rs2)
    @help_window.visible = true
    @left_window = Window_PartySplitMain.new(0)
    @right_window = Window_PartySplitMain.new(320)
    @size_warning = Window_Base.new(100, 224, 400, 64)
    @size_warning.contents = Bitmap.new(368, 32)
    @size_warning.contents.draw_text(36, 0, 368, 32, warning)
    @size_warning.z = 3500
    @size_warning.visible = false
    @warning_frames = -1
    flag = false
    for actor in $game_party.actors
      if flag == false
        @left_window.add_actor(actor)
      end
      if flag == true
        @right_window.add_actor(actor)
      end
      if flag == false
        flag = true
        next
      end
      if flag == true
        flag = false
        next
      end
    end
    @help_window.refresh
    @left_window.refresh
    @right_window.refresh
    @left_window.index = 0
    @left_window.active = true
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @help_window.dispose
    @left_window.dispose
    @right_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if @warning_frames > 0
      @warning_frames -= 1
      if @warning_frames == 0
        @warning_frames = -1
        @size_warning.visible = false
      end
    return
    end
    @help_window.update
    @left_window.update
    @right_window.update
    if @left_window.active
      update_left
      return
    end
    if @right_window.active
      update_right
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when left window is active)
  #--------------------------------------------------------------------------
  def update_left
    if Input.trigger?(Input::B) && @cancel_allowed
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Map.new
    end
    if Input.trigger?(Input::C)
      if @left_window.actors.size > 1
        $game_system.se_play($data_system.decision_se)
        @right_window.add_actor(@left_window.actors[@left_window.index])
        @left_window.remove_actor(@left_window.actors[@left_window.index])
        @right_window.refresh
        @left_window.refresh
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
    if Input.trigger?(Input::X)
      check_size_error
      if @error == false
        finish
      end
    end
    if Input.trigger?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      if @left_window.index + 1 <= @right_window.actors.size
        @right_window.index = @left_window.index
      else
        @right_window.index = @right_window.actors.size - 1
      end
      @left_window.index = -1
      @left_window.active = false
      @right_window.active = true
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when right window is active)
  #--------------------------------------------------------------------------
  def update_right
    if Input.trigger?(Input::B) && @cancel_allowed
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Map.new
    end
    if Input.trigger?(Input::C)
      if @right_window.actors.size > 1
        $game_system.se_play($data_system.decision_se)
        @left_window.add_actor(@right_window.actors[@right_window.index])
        @right_window.remove_actor(@right_window.actors[@right_window.index])
        @right_window.refresh
        @left_window.refresh
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
    if Input.trigger?(Input::X)
      check_size_error
      if @error == false
        finish
      end
    end
    if Input.trigger?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      if @right_window.index + 1 <= @left_window.actors.size
        @left_window.index = @right_window.index
      else
        @left_window.index = @left_window.actors.size - 1
      end
      @right_window.index = -1
      @right_window.active = false
      @left_window.active = true
    end
  end
  #--------------------------------------------------------------------------
  # * Check party size for errors
  #--------------------------------------------------------------------------
  def check_size_error
    @error = true
    if @rs1 == 0 && @rs2 == 0
      @error = false
      return
    end
    if @left_window.actors.size == @rs1
      if @right_window.actors.size == @rs2
        @error = false
        return
      end
    end
    if @left_window.actors.size == @rs2
      if @right_window.actors.size == @rs1
        @error = false
        return
      end
    end
    if @error == true
      $game_system.se_play($data_system.buzzer_se)
      @size_warning.visible = true
      @warning_frames = 60
    end
  end
  #--------------------------------------------------------------------------
  # * Finish processing
  #--------------------------------------------------------------------------
  def finish
    $game_party.split(@left_window.actors, @right_window.actors)
    $scene = Scene_Map.new
  end
end