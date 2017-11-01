#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  This class performs status screen processing.
#==============================================================================

class Scene_Status < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, equip_index = 0)
    @actor_index = actor_index
  end
  
  def setup
    # Get actor
    @actor = $game_party.actors[@actor_index]
    # Make status sprite
    @sprites = [ @status_window = Window_Status.new(@actor) ]
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to menu screen
      $scene = Scene_Menu.new(3)
      return
    end
    # If R button was pressed
    if Input.trigger?(Input::R)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To next actor
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      # Switch to different status screen
      $scene = Scene_Status.new(@actor_index)
      return
    end
    # If L button was pressed
    if Input.trigger?(Input::L)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To previous actor
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      # Switch to different status screen
      $scene = Scene_Status.new(@actor_index)
      return
    end
  end
end
