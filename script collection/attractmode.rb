#≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
# ** Team Scriptastic's Attract Mode                             [RPG Maker XP]
#    Version 1.10
#------------------------------------------------------------------------------
#  This script adds an "attract mode" feature.  If you let the game idle on the
#  title screen for a few seconds, it loads a predesignated map.  With some
#  decent eventing, you could have it play out whatever scene you like.
#  Pressing any button returns you to the title screen.
#==============================================================================
# * Version History
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   Version 1.00 ------------------------------------------------- (2009-07-??)
#     - Initial Version
#     - Author: Glitchfinder
#    Version 1.10 ------------------------------------------------ (2009-07-??)
#      - Script modified for ease of use
#      - Author: theory
#==============================================================================
# * Instructions
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Place this script above Main, and below the default scripts. (I realize this
#  is obvious to most, but some people don't get it.)
#
#  There is a Scriptastic class immediately following this header. Just change
#  the settings found there to your liking.  This script is very simple to use.
#  Note that map is specified by ID.  This is the number displayed on the
#  status bar of RPG Maker XP while editing a map, to the left of the map name.
#  For example, 001: MAP001 (20x15)
#  1 would be the ID of this map, although 001 could technically be used.
#  This number can also be found in the title of the Map Properties window.
#==============================================================================
# * Contact
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Glitchfinder, the author of this script, may be contacted through his
#  website, found at http://www.glitchkey.com
#
#  You may also find Glitchfinder at http://www.hbgames.org
#==============================================================================
# * Usage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  This script may be used with the following terms and conditions:
#
#    1. This script is free to use in any noncommercial project. If you wish to
#       use this script in a commercial (paid) project, please contact
#       Glitchfinder at his website.
#    2. This script may only be hosted at the following domains:
#         http://www.glitchkey.com
#         http://www.hbgames.org
#    3. If you wish to host this script elsewhere, please contact Glitchfinder.
#    4. If you wish to translate this script, please contact Glitchfinder. He
#       will need the web address that you plan to host the script at, as well
#       as the language this script is being translated to.
#    5. This header must remain intact at all times.
#    6. Glitchfinder remains the sole owner of this code. He may modify or
#       revoke this license at any time, for any reason.
#    7. Any code derived from code within this script is owned by Glitchfinder,
#       and you must have his permission to publish, host, or distribute his
#       code.
#    8. This license applies to all code derived from the code within this
#       script.
#    9. If you use this script within your project, you must include visible
#       credit to Glitchfinder and theory, within reason.
#≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
 
class Scriptastic
  def initialize
    @attract_mode_map = 1  # Which map to start on
    @attract_start_x  = 9  # Which tile, horizontally, to start on
    @attract_start_y  = 7  # Which tile, vertically, to start on
    @attract_wait     = 10 # How many seconds to wait
  end
  attr_accessor :attract_mode_map
  attr_accessor :attract_start_x
  attr_accessor :attract_start_y
  attr_accessor :attract_wait
end
 
$scriptastic = Scriptastic.new if $scriptastic == nil
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles the map. It includes scrolling and passable determining
#  functions. Refer to "$game_map" for the instance of this class.
#==============================================================================
 
class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :attract_mode             # tileset file name
  #--------------------------------------------------------------------------
  # * Alias Methods
  #--------------------------------------------------------------------------
  alias scriptastic_attract_mode_game_map_initialize initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    scriptastic_attract_mode_game_map_initialize
    @attract_mode = false
  end
end
 
#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs title screen processing.
#==============================================================================
 
class Scene_Title
  #--------------------------------------------------------------------------
  # * Alias Methods
  #--------------------------------------------------------------------------
  alias scriptastic_attract_mode_scene_title_main main
  alias scriptastic_attract_mode_scene_title_update update
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @attract_wait = $scriptastic.attract_wait * Graphics.frame_rate
    scriptastic_attract_mode_scene_title_main
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    scriptastic_attract_mode_scene_title_update
    if @attract_wait <= 0
      begin_attract_mode
    else
      @attract_wait -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * Command: Begin Attract Mode
  #--------------------------------------------------------------------------
  def begin_attract_mode
    # Make each type of game object
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    # Set up initial party
    $game_party.setup_starting_members
    # Set up initial map position
    $game_map.setup($scriptastic.attract_mode_map)
    # Set attract mode to on
    $game_map.attract_mode = true
    # Move player to initial position
    $game_player.moveto($scriptastic.attract_start_x,
                        $scriptastic.attract_start_y)
    # Refresh player
    $game_player.refresh
    # Run automatic change for BGM and BGS set with map
    $game_map.autoplay
    # Update map (run parallel process event)
    $game_map.update
    # Switch to map screen
    $scene = Scene_Map.new
  end
end
 
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================
 
class Scene_Map
  #--------------------------------------------------------------------------
  # * Alias Methods
  #--------------------------------------------------------------------------
  alias scriptastic_attract_mode_scene_map_update update
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if ((Input.trigger?(Input::A) || Input.trigger?(Input::B) ||
      Input.trigger?(Input::C) || Input.trigger?(Input::X) ||
      Input.trigger?(Input::Y) || Input.trigger?(Input::Z) ||
      Input.trigger?(Input::L) || Input.trigger?(Input::R) ||
      Input.trigger?(Input::DOWN) || Input.trigger?(Input::LEFT) ||
      Input.trigger?(Input::RIGHT) || Input.trigger?(Input::UP) ||
      Input.trigger?(Input::F5) || Input.trigger?(Input::F6) ||
      Input.trigger?(Input::F7) || Input.trigger?(Input::F8) ||
      Input.trigger?(Input::F9) || Input.trigger?(Input::SHIFT) ||
      Input.trigger?(Input::CTRL) || Input.trigger?(Input::ALT) ||
      Input.dir8 != 0) && $game_map.attract_mode == true)
      $game_player.straighten
      $game_map.attract_mode = false
      $scene = Scene_Title.new
    end
    scriptastic_attract_mode_scene_map_update
  end
end