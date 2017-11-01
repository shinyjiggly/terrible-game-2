#===============================================================================
#
#           HERETIC'S LOOP MAPS [XP]
#           Version - 1.0
#           Wednesday, March 25th, 2015
#
#===============================================================================
#
# ---  Requirements and Installation  ---
#
# *** REQUIRES HERETICS MODULAR PASSABLE SCRIPT ***
#
#  This script should be placed DIRECTLY below Heretic's Modular Passable
#  directly below Modular Collision Optimizer (recommended for performance) if
#  it is used, or directly below Modular Passable.
#
# -----  FEATURES  ------
#
# - Allows Maps to Loop like in RPG Maker VX and VX Ace
# - Can be turned on or off during gameplay
# - Allows for Panorama Tuning to adjust Panorama Speeds or Lock in place
# - Allows for Auto Scrolling of Panorama like in VX and VX Ace
# - Works with Fogs and Panoramas unlike other scripts
# - Compatible with Heretic's Cloud Altitude 2.2
# - Also compatible with Game Guy's Unlimited Fogs if you have Cloud Altitude
#
#
# -----  INSTRUCTIONS  ------
#
#  Install below Heretic's Modular Passable Script and above Main.  You'll
#  probably need to put it above other scripts that have Loop Map Compatability
#  such as the Caterpillar, NPCs on Event Tiles, Diagonal Stairs, Bush Passages
#  Hotfoot Tiles, and my Vehicles script.
#
#  Once installed, scroll down to the Config and set up your game as you
#  see fit.  The Config is intended for maps that you always expect to
#  have a Looping behavior.
#
#  - SDK (if installed)
#  - Heretic's Modular Passable (** Required **)
#  - Heretic's Modular Collision Optimizer (Optional)
#  - Heretic's Loop Maps (This Script)
#
#  Heretic's Modular Collision Optimizer can be exceptionally useful for
#  other scripters to be able to do things with Event Tiles in a manner
#  that is actually efficient enough that collisions with these types
#  of tiles do not affect performance.  This script is NOT intended
#  to be used for only increasing performances.  I have noticed much
#  better performance given the exceptionally high number of scripts
#  that are created in the collection.  Read the Documentation in
#  the Collision Optimizer script for more information.
#
#
# ------  MAP SIZE and SNAPPING SPRITES  -----
#
#  I recommend that you make your Map Sizes bigger than the default size!  If
#  you don't, you'll see Sprites get snapped to the opposite edge of the Map
#  because every character only gets ONE Sprite!  The larger your character
#  graphic is, the more noticable this becomes.  This is something you will
#  not want the people who play your games to ever observe as it looks very
#  glitchy.  You may want to FAIL on purpose just so you know what it looks
#  like when Sprites get "snapped", so you know what causes it and can learn
#  how to avoid it.  This is most noticable on Vertical Looping Maps when
#  the characters are taller than 32 pixels!  For testing, just use a really
#  big character, like the Horse and Carriage, and use the Minimum Map Size
#  so you can observe this glitch, and thereby avoid it ever happening!
#
#
#  -----  SCRIPT CALLS  -----
#
#  This script is actually pretty easy to use.  If you want to set a Map to
#  have a Looping property during gameplay, you can adjust it on the fly
#  by using a Script Call: $game_map.loop_type = N  The best results of
#  this script are set in the Config section, so you won't really need
#  to use these Script Calls during gameplay.
#
#  By default, 0 is a Non Looping Map, which is default for all maps, except
#  those specified in the Config.  Loop Type of 1 is a Vertical Loop.  A Loop
#  Type of 2 is a Horizontal Loop.  Loop Type of 3 is to Loop both Horizontal
#  and Vertical.
#
#  @>Script: $game_map.loop_type = 0 - No Loop
#  @>Script: $game_map.loop_type = 1 - Loop Vertical
#  @>Script: $game_map.loop_type = 2 - Loop Horizontal
#  @>Script: $game_map.loop_type = 3 - Loop Vertical and Horizontal
#
#  If you change the LOOP TYPE during gameplay, the Map will "snap" if the
#  screen is displaying over a Map Edge.  Changing the LOOP TYPE will usually
#  look the best to Players if you change it while away from Map Edges so
#  no "snapping" takes place.  You can disable this "snapping" by running
#  a script of $game_system.loop_snap = false, but as soon as the Player
#  tries to move in the direction of the Map Edge, the Map will just
#  "snap" anyway.
#
#  NOTE:  My Caterpillar Script has a feature to allow Characters to go off the
#         edge of maps.  This ONLY works if a Map is NOT Looping for the
#         direction allowed.  Thus, you can make a Map have a Vertical Loop
#         and still allow Characters to walk off the side edges of the Map.
#
#
#  -----  DETECTING LOOPS  -----
#
#  If you need to detect if a Map has Looped for some reason, you can check
#  with a script to $game_map.looped which will return nil until the Player
#  has caused the Map to Loop, at which time, will return the Direction of
#  the way the Map has Looped.  The value will be returned for ONE FRAME
#  of UPDATE, then it will automatically be reset back to nil.
#
#  In a Parallel Event, you can run this:
#
#  @>Conditional Branch: Script: $game_map.looped != nil
#  @>  (your Event Stuff goes here)
#  @>Branch End
#
#  
#  -----  PANORAMA SCROLL ADJUSTMENTS  -----
#
#  Some Panoramas do not tile properly, so it may be useful to "lock" these
#  styles of panoramas in place, either Horizontally or Vertically.  The 
#  ability to do this also allows you to alter the Panorama Scroll Speeds.
#
#  Due to the way the Math came out, you'll need to use a value of 4 for
#  you to "lock" a Panorama.  Numbers less than 4 will cause the Panorama
#  to move faster than the current map, and those greater than 4 will
#  make the Panorama scroll slower than the current map.  The default value
#  is 8.  Numbers greater than 8 scroll increasingly slowly, and numbers
#  that are less than 8 will move slower than the map, but faster than the
#  default Panorama Scroll Speed.  This can be useful when you want to make
#  something in the distance appear to be either much nearer or farther
#  away from the Player's plane.
#
#  $game_map.pan_scroll_x = 4 - Lock the X Panorama Scroll
#  $game_map.pan_scroll_y = 4 - Lock the Y Panorama Scroll
#  $game_map.pan_scroll_x = 8 - Default Panorama Scroll Speed
#  $game_map.pan_scroll_y = 8 - Default Panorama Scroll Speed
#  $game_map.pan_scroll_x = 16 - Very Slow Panorama X Scrolling (Distant)
#  $game_map.pan_scroll_y = 16 - Very Slow Panorama Y Scrolling (Distant)
#  $game_map.pan_scroll_x = 5 - Fast Panorama X Scrolling (Close Plane)
#  $game_map.pan_scroll_y = 5 - Fast Panorama Y Scrolling (Close Plane)
#  $game_map.pan_scroll_x = < 4 - Panorama X Scrolls faster than Map
#  $game_map.pan_scroll_y = < 4 - Panorama Y Scrolls faster than Map
#
#
#  -----  PANORAMA AUTO SCROLLING  -----
#
#  You can set a Panorama to Scroll automagically either by setting a value
#  in the Config section, or by making a Script Call.  To enter a Config
#  value for Auto Scrolling, X Scroll Speeds should be the 5th value and
#  likewise, the Y Scroll Speed is the 6th value.
#
#  Map Config: [map_id, loop_type, scroll_x_spd, scroll_y_spd, auto_x, auto_y]
#
#  $game_map.panorama_ax = 4   - Automatically Scroll Panorama X
#  $game_map.panorama_ax = 7.5 - Automatically Scroll Panorama Y
#
#  NOTE: Maps do NOT need to Loop for Panorama Scrolling or Adjustments
#
#
#  -----  KNOWN BUGS  ------
#
#  Loop maps does not appear to work with Pathfinders at this time.
#
#  DOWNHILL ICE DELUXE can cause an "Artifact Glitch" where the bottom
#  of sprites appears at the top of the screen.  You can avoid this Glitch
#  in Mapping Technique.  It only occurs if the Player steps onto Downhill
#  Ice at the very bottom of a Looping Map.  You can allow the Player to
#  slide infinitely, just block access from stepping on to the infinite
#  or looping ice at the very bottom of your map.
#
#
# ------  LOOP MAP CONFIG SECTION  ------
#  
#
# Map ID - Obvious
# Loop Type:
#   0 - No Looping (Normal Maps and Collisions
#   1 - Vertical Loop, no Horizontal
#   2 - Horizontal Loop, no Vertical
#   3 - Loop Horizontal and Vertical

#  -----  CONFIG  -----
#
# Edit these values to suit your game
#
#  Map Config: [map_id, loop_type, scroll_x, scroll_y, auto_x, auto_y]
#
#  NOTE: You don't need to put Names in for each entry
#
#  Example: [map_id = 1, loop_type = 3, nil, 16, -10.5, 14]
LOOP_MAPS = [ # Leave this character here!

  [map_id = 45, loop_type = 3], # Put commas if not the last set of []
  [map_id = 56, loop_type = 3, pan_scroll_x = 16, pan_scroll_y = 16, -9, 9],
  [map_id = 67, loop_type = 3],
  [48, 3, 10, 10, -8, 8]  # Labels aren't necessary, but useful, no COMMA here!
  
            ] # Leave this character here!

# Adjustment to Top Edge of Map (Default)
LOOP_TOP_OFFSET = 2  #64 pixels or 2 tiles
LOOP_SIDE_OFFSET = 3


#  -----  END CONFIG  -----

# Check for Modular Passable Script - REQUIRED - DO NOT EDIT
unless $Modular_Passable
  print "Fatal Error: Heretics Loop Maps script\n",
        "requires Heretics Modular Passable Script!\n\n",
        "Modular Passable is Not Available or is below this script.\n",
        "Modular Passable MUST be above this script.\n\n",
        "The Game will now Exit"
  exit
end

#==============================================================================
# ** Game_Map - Class
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables - Game_Map
  #--------------------------------------------------------------------------
  attr_reader    :loop_type        # 0:Off 1:Vertical 2:Horizontal 3:Both
  attr_accessor  :looped           # Returns Direction if Map Looped or nil
  attr_accessor  :fog_ox           # Fog Origin X
  attr_accessor  :fog_oy           # Fog Origin Y
  attr_accessor  :loop_snap        # If corrections to Display on value change
  attr_accessor  :loop_top_offset  # Adjusts Top Edge for larger Maps
  attr_accessor  :loop_side_offset # Adjusts Side Edges for larger Maps
  attr_accessor  :loop_pan_x       # Panorama Adjustment when Looping Horizontal
  attr_accessor  :loop_pan_y       # Panorama Adjustment when Looping Vertical
  attr_accessor  :pan_scroll_x     # Panorama Scroll Rate X Override
  attr_accessor  :pan_scroll_y     # Panorama Scroll Rate Y Override
  attr_accessor  :panorama_ax      # Panorama Auto Scroll X Speed
  attr_accessor  :panorama_ay      # Panorama Auto Scroll Y Speed
  attr_accessor  :pan_ax_counter   # Panorama Adjustment Counter
  attr_accessor  :pan_ay_counter   # Panorama Adjustment Counter
  #--------------------------------------------------------------------------
  # * Setup - Game_Map
  #     map_id : Map ID
  #--------------------------------------------------------------------------
  alias loop_map_setup setup unless $@
  def setup(map_id)
    # Set the Default Loop Type
    @loop_type = 0
    # Returns Direction of Loop for ONE FRAME of UPDATE when a Map has Looped
    @looped = nil
    # Panorama Adjustments for Looping
    @loop_pan_x = 0
    @loop_pan_y = 0
    # Top Loop / Side Offsets from Config
    @loop_top_offset = LOOP_TOP_OFFSET
    @loop_side_offset = LOOP_SIDE_OFFSET
    # Adjust Display Values on Loop Type Change (false due to Bugs, artifacts)
    @loop_snap = true
    # Default Found Loop Map in Config
    found_loop_map = false
    # If Config has Looping Map
    for loops in LOOP_MAPS
      # If Config is set for this Map ID
      if loops[0] == map_id
        # Found the Map
        found_loop_map = true
        # Set Loop Type based on Config
        @loop_type = loops[1]         
        # Panorama Scroll Speed Adjustments
        @pan_scroll_x = (loops[2]) ? loops[2] : nil
        @pan_scroll_y = (loops[3]) ? loops[3] : nil
        # Panorama Auto Scroll Speeds
        @panorama_ax = (loops[4]) ? loops[4] : 0
        @panorama_ay = (loops[5]) ? loops[5] : 0
      end
    end
    # Check Nonexistent Values or Missing Config
    @panorama_ax = 0 if @panorama_ax.nil?
    @panorama_ay = 0 if @panorama_ay.nil?
    # Panorama Adjustment Counters
    @pan_ax_counter = 0
    @pan_ay_counter = 0
    # Call Original or other Aliases of Setup
    loop_map_setup(map_id)
    # If Loop Map Config is not found
    if not found_loop_map
      # Clear these values
      @pan_scroll_x = nil
      @pan_scroll_y = nil
      @panorama_ax = 0
      @panorama_ay = 0
    end    
  end
  #--------------------------------------------------------------------------
  # * Loop_Type= (Setter Method) - Game_Map
  #  - Changes Map Loop Type and Display Values appropriately
  #--------------------------------------------------------------------------
  def loop_type=(i)
    # If Valid
    if [0,1,2,3].include?(i)
      # Change to New Value
      @loop_type = i
      # Update Display X
      if [0,1].include?(i) and @loop_snap and
         (@display_x < 0 or @display_x > (self.width - 20) * 128)
        # Shorthand for Player X
        x = $game_player.x
        # Max X
        mx = ($game_map.width - 20) * 128
        # Correct Center Screen X
        $game_map.display_x = [0, [x * 128 - Game_Player::CENTER_X,mx].min].max
        # If Map Scene
        if $scene.is_a?(Scene_Map)
          # Correct Map Positions of ALL Events (unless allowed Off Map)
          $game_map.force_event_loop_round_positions
          # Force an Update of ALL Sprite Positions
          $scene.force_sprites_position_update
          # Correct Panorama Positions
          $scene.panorama_update_loop_scroll
        end
      end
      # Update Display Y
      if [0,2].include?(i) and @loop_snap and
         (@display_y < 0 or @display_y > (self.height - 15) * 128)
        # Shorthand for Player Y
        y = $game_player.y
        # Max Y
        my = ($game_map.height - 15) * 128
        # Correct Center Screen
        $game_map.display_y = [0, [y * 128 - Game_Player::CENTER_Y,my].min].max
        # If Map Scene
        if $scene.is_a?(Scene_Map)
          # Correct Map Positions of ALL Events (unless allowed Off Map)
          $game_map.force_event_loop_round_positions
          # Force an Update of ALL Sprite Positions
          $scene.force_sprites_position_update
          # Correct Panorama Positions
          $scene.panorama_update_loop_scroll
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Loop? - Game_Map
  #--------------------------------------------------------------------------
  def loop?
    # True if Loop is 1, 2, or 3
    return (@loop_type > 0)
  end  
  #--------------------------------------------------------------------------
  # * Loop Horizontally? - Game_Map
  #--------------------------------------------------------------------------
  def loop_horizontal?
    return (@loop_type == 2 or @loop_type == 3)
  end
  #--------------------------------------------------------------------------
  # * Loop Vertically? - Game_Map
  #--------------------------------------------------------------------------
  def loop_vertical?
    return (@loop_type == 1 or @loop_type == 3)
  end
  #--------------------------------------------------------------------------
  # * Determine Valid Coordinates - Game_Map
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     d          : direction (0,2,4,6,8,10)
  #                  *  0,10 = determine if all directions are impassable
  #     self_event : Character calling $game_map.passable  
  #     result     : true or false passed as an arg by Aliases
  #  - Added all available arguments for other Aliases to alter result
  #  - Adjusts X and Y values for Looping Maps
  #--------------------------------------------------------------------------
  alias map_loop_valid? valid? unless $@  
  def valid?(x, y, d = nil, self_event = nil, result = nil)  
    # Fix X Value to Map Range if Map Loops Horizontally 
    x %= @map.width if loop_horizontal?
    # Fix Y Value to Map Range if Map Loops Vertically
    y %= @map.height if loop_vertical?
    # Call Original or other Aliases
    map_loop_valid?(x, y, d, self_event, result)
  end
  #--------------------------------------------------------------------------
  # * Passable? - Game_Map
  #  - Adjusts X and Y values for Looping Maps
  #--------------------------------------------------------------------------
  alias map_loop_passable? passable? unless $@
  def passable?(x, y, d, self_event = nil)
    # Fix X Value to Map Range if Map Loops Horizontally 
    x %= @map.width if loop_horizontal?
    # Fix Y Value to Map Range if Map Loops Vertically
    y %= @map.height if loop_vertical?
    # Call Original or other Aliases with updated X and Y
    map_loop_passable?(x, y, d, self_event)
  end
  #--------------------------------------------------------------------------
  # * Scroll Down - Game_Map
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias map_loop_scroll_down scroll_down unless $@
  def scroll_down(distance)
    # If Map Loops Vertically
    if loop_vertical?
      # Update Display with no Limiters
      @display_y += distance
    else
      # Call Original or other Aliases
      map_loop_scroll_down(distance)
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Left - Game_Map
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias map_loop_scroll_left scroll_left unless $@
  def scroll_left(distance)
    # If Map Loops Horizontal
    if loop_horizontal?
      # Update Display with no Limiters
      @display_x -= distance
    else
      # Call Original or other Aliases
      map_loop_scroll_left(distance)
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Right - Game_Map
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias map_loop_scroll_right scroll_right unless $@
  def scroll_right(distance)
    # If Map Loops Horizontal
    if loop_horizontal?
      # Update Display with no Limiters
      @display_x += distance
    else
      # Call Original or other Aliases
      map_loop_scroll_right(distance)
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Up - Game_Map
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias map_loop_scroll_up scroll_up unless $@
  def scroll_up(distance)
    # If Map Loops Vertically
    if loop_vertical?
      @display_y -= distance
    else
      # Call Original or other Aliases
      map_loop_scroll_up(distance)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Terrain Tag - Game_Map
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  alias loop_map_terrain_tag terrain_tag unless $@
  def terrain_tag(x, y)
    # Adjust X Value if Map Loops Horizontally
    x %= width if loop_horizontal?
    # Adjust Y Value if Map Loops Vertically
    y %= height if loop_vertical?
    # Call Original or other Aliases with any Adjusted Arguments
    return loop_map_terrain_tag(x, y)
  end
  #--------------------------------------------------------------------------
  # * Determine Thicket (Bush) - Game_Map
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  alias loop_map_bush? bush? unless $@
  def bush?(x, y)
    # Adjust X Value if Map Loops Horizontally
    x %= width if loop_horizontal?
    # Adjust Y Value if Map Loops Vertically
    y %= height if loop_vertical?
    # Call Original or other Aliases with any Adjusted Arguments
    return loop_map_bush?(x, y)
  end  
  #--------------------------------------------------------------------------
  # * Adjust X - Game_Map
  #     x : Real X of Character
  #--------------------------------------------------------------------------
  def adjust_x(x)
    # Display X in "tile values".
    dx = @display_x / 128.0
    # 20 represents the number of horizontal tiles in the screen.
    if loop_horizontal?
      # If Map Loop to the Right and Character close to Left Edge
      return x - dx + @map.width if x < dx - (width - 20) / 2
      # Top Map Edge Adjustment for Sprites at Bottom Edge of Maps
      e = $game_map.loop_side_offset
      # If Map Loop to the Left and Character close to Right Edge
      return x - dx - @map.width if dx < 0 + e and x > dx + (width + 20) / 2
    end
    return x - dx
  end
  #--------------------------------------------------------------------------
  # * Adjust Y - Game_Map
  #  - Limit is "Softened" by 2 tiles to allow proper rendering along 
  #    Map Edges so map sizes may need to be increased accordingly
  #     y : Real Y of Character
  #--------------------------------------------------------------------------
  def adjust_y(y)
    # Display Y in "tile values".
    dy = @display_y / 128.0
    # 15 represents the number of vertical tiles in the screen.
    if loop_vertical?
      # If Map Loops to the Bottom and Character close to Top Edge
      return y - dy + @map.height if y < dy - (height - 15) / 2
      # Top Map Edge Adjustment for Sprites at Bottom Edge of Maps
      t = $game_map.loop_top_offset
      # If Map Loops to the Top and Character close to Bottom Edge
      return y - dy - @map.height if dy < 0 + t and y > dy + (height + 15) / 2
    end
    return y - dy
  end
  #--------------------------------------------------------------------------
  # * Force Event Loop Round Positions - Game_Map
  #  - Called when Loop Type is changed to correct all map positions
  #--------------------------------------------------------------------------
  def force_event_loop_round_positions
    # For ALL Events
    for event in @events.values
      # Corrects Looping Map Positions
      event.force_loop_round_positions
    end
  end
end

#==============================================================================
# ** Sprite_Character - Class
#==============================================================================
class Sprite_Character < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Loop Force Position Update
  #  - Called when Loop Type is changed to correct all Sprite Screen Positions
  #--------------------------------------------------------------------------
  def loop_force_position_update
    # Set sprite coordinates
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z(@ch)
  end
end

#==============================================================================
# ** Spriteset_Map - Class
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Spriteset Force Position Update - Spriteset_Map
  #  - Called when Loop Type is changed to correct all Sprite Screen Positions
  #--------------------------------------------------------------------------
  def spriteset_force_position_update
    for sprite in @character_sprites
      # Force an Update now of all Sprite Locations due to a Loop Change
      sprite.loop_force_position_update
    end
  end
  #--------------------------------------------------------------------------
  # * Panorama Update Loop Scroll - Spriteset_Map
  #  - Updates Panorama Scrolling on either Looping or Non Looping Maps
  #--------------------------------------------------------------------------
  def panorama_update_loop_scroll
    # If Panorama Scroll X Value is adjusted
    if $game_map.pan_scroll_x
      # Adjust the Panorama X Position
      @panorama.ox = $game_map.display_x / $game_map.pan_scroll_x
    end
    # If Panorama Scroll Y Value is adjusted
    if $game_map.pan_scroll_y
      # Adjust the Panorama Y Position
      @panorama.oy = $game_map.display_y / $game_map.pan_scroll_y
    end
    # Shortcut
    p = @panorama
    # Clear Fog Looping Flags and adjust Auto Scrolling
    @panorama.ox += $game_map.loop_pan_x + $game_map.pan_ax_counter
    @panorama.oy += $game_map.loop_pan_y + $game_map.pan_ay_counter
    # If Panorama
    if @panorama_name != ""
      # Adjust Panorama Counters
      $game_map.pan_ax_counter += $game_map.panorama_ax / 8.0
      $game_map.pan_ay_counter += $game_map.panorama_ay / 8.0
      # Round Values based on size and zoom of Panorama
      $game_map.pan_ax_counter %= @panorama.bitmap.width * @panorama.zoom_x
      $game_map.pan_ay_counter %= @panorama.bitmap.height * @panorama.zoom_y
    end    
  end
  #--------------------------------------------------------------------------
  # * Update - Spriteset_Map
  #  - Adjusts Panorama Position on Looping Maps
  #  - Allows specific control over Panorama Scroll Rates
  #--------------------------------------------------------------------------  
  alias loop_map_sprite_map_update update unless $@
  def update
    # Call Original or other Aliases
    loop_map_sprite_map_update
    # Update Panorama Scrolling
    panorama_update_loop_scroll
  end
end

#==============================================================================
# ** Scene_Map
#==============================================================================
class Scene_Map
  #--------------------------------------------------------------------------
  # * Loop Spriteset - Scene_Map
  #  - Just returns the Spriteset Object
  #--------------------------------------------------------------------------
  def loop_spriteset
    return @spriteset
  end  
  #--------------------------------------------------------------------------
  # * Force Sprites Position Update - Scene_Map
  #  - Calls command in the Spriteset Object
  #  - Called when Loop Type is changed
  #--------------------------------------------------------------------------
  def force_sprites_position_update
    @spriteset.spriteset_force_position_update
  end
  #--------------------------------------------------------------------------
  # * Panorama Update Loop Scroll - Scene_Map
  #  - Causes Panorama Positions to Update
  #  - Called when Loop Type is changed
  #--------------------------------------------------------------------------
  def panorama_update_loop_scroll
    @spriteset.panorama_update_loop_scroll
  end
end

#==============================================================================
# ** Interpreter
#==============================================================================
class Interpreter
  #--------------------------------------------------------------------------
  # * Change Map Settings - Interpreter
  #--------------------------------------------------------------------------
  alias loop_map_change_map_settings_command_204 command_204 unless $@
  def command_204
    # Reset Background 2 when Background 1 is changed
    case @parameters[0]
    when 0  # panorama
      # Reset the Counters used for Scrolling
      $game_map.pan_ay_counter = 0
      $game_map.pan_ay_counter = 0
    end
    # Continue
    return loop_map_change_map_settings_command_204
  end
end

#==============================================================================
# ** Game_Character - Class
#==============================================================================
class Game_Character
  #--------------------------------------------------------------------------
  # * Make New XY - Game_Character
  #  - Makes New Coordinates for X and Y (4 Directional Movement)
  #     x      : x-coordinate
  #     y      : y-coordinate
  #     d      : direction (0,2,4,6,8)
  #     result : Array passed as an arg by Aliases 
  #
  #  NOTE: Must return an Array of New Map Coordinates [new_x, new_y]
  #    new_x, new_y = make_new_xy(x, y, d)  
  #  - This can be Aliased to alter New Coordinates based on other conditions
  #--------------------------------------------------------------------------
  alias map_loop_make_new_xy make_new_xy unless $@
  def make_new_xy(x, y, d, result = nil)
    # Get the New X and New Y Results of Make New XY
    new_x, new_y = map_loop_make_new_xy(x, y, d, result)
    # Fix X Value to Map Range if Map Loops Horizontally 
    new_x %= $game_map.width if $game_map.loop_horizontal?
    # Fix Y Value to Map Range if Map Loops Vertically
    new_y %= $game_map.height if $game_map.loop_vertical?
    # Return Loop Adjusted Values
    return [new_x, new_y]
  end
  #--------------------------------------------------------------------------
  # * Make New XY 8D - Game_Character
  #  - Make New Coordinates for X and Y (8 Directional Movement)
  #     x     : x-coordinate
  #     y     : y-coordinate
  #     d     : direction (0,1,2,3,4,6,7,8,9 no 5)
  #     result : Array passed as an arg by Aliases    
  #  - This method is not called, but is available if needed
  #
  #  Note: Bit Flipping with 10 - d works, 10 - 9 (up right) = 1 (down left)
  #  Note: Must return an Array of New Map Coordinates [new_x, new_y]
  #    new_x, new_y = make_new_xy_8d(x, y, d)
  #--------------------------------------------------------------------------
  alias map_loop_make_new_xy_8d make_new_xy_8d unless $@
  def make_new_xy_8d(x, y, d, result = nil)
    # Get the New X and New Y Results of Make New XY
    new_x, new_y = map_loop_make_new_xy_8d(x, y, d, result)
    # Fix X Value to Map Range if Map Loops Horizontally 
    new_x %= $game_map.width if $game_map.loop_horizontal?
    # Fix Y Value to Map Range if Map Loops Vertically
    new_y %= $game_map.height if $game_map.loop_vertical?
    # Return Loop Adjusted Values
    return [new_x, new_y]
  end
  #--------------------------------------------------------------------------
  # * Player Conditions? - Game_Character
  #  - Return true / false if conditions met
  #  - If New Location matches Player Position and Player not Through
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     d          : direction (0,2,4,6,8,10)
  #                  *  0,10 = determine if all directions are impassable
  #     new_x : Target X Coordinate
  #     new_y : Target Y Coordinate  
  #     result     : values other than nil by Aliases override checks here
  #--------------------------------------------------------------------------
  alias loop_map_player_conditions? player_conditions? unless $@
  def player_conditions?(x, y, d, new_x, new_y, result = nil)
    # Ignore other Results and check for Looping Maps
    if $game_map.loop?
      # Game Player Shorthand 
      p = $game_player
      # Adjust Player's X Location If map Loops Horizontal
      px = ($game_map.loop_horizontal?) ? p.x % $game_map.width : p.x
      # Adjust Player's Y Location If map Loops Vertical
      py = ($game_map.loop_vertical?) ? p.y % $game_map.height : p.y
      # If Coordinates match Player Location and Player Through is Off
      if px == new_x and py == new_y and not $game_player.through
        # Conditions are met
        return true
      end
    end
    # Call Original or other Aliases
    loop_map_player_conditions?(x, y, d, new_x, new_y, result)
  end  
  #--------------------------------------------------------------------------
  # * Passable? - Game_Character
  #  - Adjusts X and Y Argument Values for Looping Maps
  #--------------------------------------------------------------------------
  alias map_loop_character_passable? passable? unless $@
  def passable?(x, y, d)
    # Fix X Value to Map Range if Map Loops Horizontally 
    x %= $game_map.width if $game_map.loop_horizontal?
    # Fix Y Value to Map Range if Map Loops Vertically
    y %= $game_map.height if $game_map.loop_vertical?
    # Call Original or other Aliases with updated X and Y
    map_loop_character_passable?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * Make Events List - Game_Character
  #  - Similar to Make Passable List
  #  - Intended for use in Non Passable determining methods in other Scripts
  #  - Intended to be aliased where X and Y values can be adjusted as needed
  #  - Excludes other Arguments needed by Make Passable List
  #  - Used by other Scripts with Triggers when X or Y have no arguments to fix
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     results    : Array from other Aliases to override default results
  #--------------------------------------------------------------------------
  alias loop_map_make_events_list make_events_list unless $@
  def make_events_list(x, y, results = nil)
    # Determine Corrected Coordinates for Target
    x = ($game_map.loop_horizontal?) ? x % $game_map.width : x
    y = ($game_map.loop_vertical?) ? y % $game_map.height : y
    # Call Original or other Aliases with Adjusted Arguments
    loop_map_make_events_list(x, y, results)
  end
  #--------------------------------------------------------------------------
  # * Passable Conditions? - Game_Character
  #  - Return true / false if conditions met
  #  - Conditions for running Passability Checks on an Event
  #  - Typically an Event isnt checking itself, Through, and Coordinates match
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     d          : direction (0,2,4,6,8,10)
  #                  *  0,10 = determine if all directions are impassable
  #     new_x      : Target X Coordinate
  #     new_y      : Target Y Coordinate  
  #     event      : Iterated Event made by make_passable_list  
  #     result     : values other than nil by Aliases override checks here
  #--------------------------------------------------------------------------
  alias loop_map_passable_conditions? passable_conditions?
  def passable_conditions?(x, y, d, new_x, new_y, event, result = nil)
    # Ignore other results if Looping Maps
    if $game_map.loop?
      # Adjust Coordinates for Looping Maps
      ex = ($game_map.loop_horizontal?) ? event.x % $game_map.width : event.x
      ey = ($game_map.loop_vertical?) ? event.y % $game_map.height : event.y
      new_x = ($game_map.loop_horizontal?) ? new_x % $game_map.width : new_x
      new_y = ($game_map.loop_vertical?) ? new_y % $game_map.height : new_y
      # Check Adjusted Coordinates for Position Match, Through, and Self
      if ex == new_x and ey == new_y and not event.through and event != self
        # Check this Event
        return true
      end
    end
    # Call Original or other Aliases
    loop_map_passable_conditions?(x, y, d, new_x, new_y, event, result)
  end
  #--------------------------------------------------------------------------
  # * Other Passable? - Game_Character
  #  - Adjusts Arguments of Aliases for Looping Maps
  #  - Used by Heretic's Caterpillar 2.0
  #  - Use any additional conditions for denying Passable
  #     x, new_x : x-coordinate
  #     y, new_y : y-coordinate
  #--------------------------------------------------------------------------
  alias loop_map_other_passable? other_passable? unless $@
  def other_passable?(x, y, d, new_x, new_y, result = nil)
    # If Map Loops Horizontal
    if $game_map.loop_horizontal?
      # Adjust the X Arguments to pass to Original or other Aliases
      x %= $game_map.width
      new_x %= $game_map.width
    end
    # If Map Loops Vertical
    if $game_map.loop_vertical?
      # Adjust the Y Arguments to pass to Original or other Aliases
      y %= $game_map.height
      new_y %= $game_map.height
    end  
    # Call Original or other Aliases with Modified Arguments except Results
    loop_map_other_passable?(x, y, d, new_x, new_y, result)
  end
  #--------------------------------------------------------------------------
  # * MP Match Coordinates - Game_Character
  #  - Modular Passable
  #  - Adjusts Coordinates for Looping Maps without affecting Results
  #     x, tx      : x-coordinate and Target x-coordinate to Match
  #     y, ty      : y-coordinate and Target Y-coordinate to Match
  #--------------------------------------------------------------------------
  alias loop_map_mp_match_coordinates? mp_match_coordinates? unless $@
  def mp_match_coordinates?(x, y, tx, ty)
    # If Map Loops Horizontal
    if $game_map.loop_horizontal?
      # Adjust the X Arguments to pass to Original or other Aliases
      x %= $game_map.width
      tx %= $game_map.width
    end
    # If Map Loops Vertical
    if $game_map.loop_vertical?
      # Adjust the X Arguments to pass to Original or other Aliases
      y %= $game_map.height
      ty %= $game_map.height
    end    
    # Call Original or other Aliases with any Adjusted Coordinates
    loop_map_mp_match_coordinates?(x, y, tx, ty)
  end  
  #--------------------------------------------------------------------------
  # * Character Distance - Game_Character
  #  - Returns the X and Y Distance between self and another Character
  #  - Checks for Maps that Loop either Horizontal or Vertical
  #      target : Character (Player or Event)
  #--------------------------------------------------------------------------  
  def character_distance(target)
    # Determine Corrected Coordinates for Looping Maps
    x = ($game_map.loop_horizontal?) ? @x % $game_map.width : @x
    y = ($game_map.loop_vertical?) ? @y % $game_map.height : @y
    # Determine Corrected Coordinates for Target
    tx = ($game_map.loop_horizontal?) ? target.x % $game_map.width : target.x
    ty = ($game_map.loop_vertical?) ? target.y % $game_map.height : target.y
    # Get difference in target coordinates
    dx = x - tx
    dy = y - ty
    # If Map Loops Horizontal and Distance is more than Half the Map
    if $game_map.loop_horizontal? and dx.abs > $game_map.width / 2
      # Adjust X Distance for Horizontal Looping Map
      dx += (dx < 0) ? $game_map.width : -$game_map.width
    end
    # If Map Loops Vertical and Distance is more than Half the Map
    if $game_map.loop_vertical? and dy.abs > $game_map.height / 2
      # Adjust X Distance for Vertical Looping Map
      dy += (dy < 0) ? $game_map.height : -$game_map.height
    end
    # Return Difference X and Y values as Array
    return [dx, dy]
  end
  #--------------------------------------------------------------------------
  # * Turn Towards Player - Game_Character
  #--------------------------------------------------------------------------
  def turn_toward_player
    # Don't Turn if Direction Fix is ON
    return if @direction_fix
    # Determine Correct Distance to Target for Looping Maps
    sx, sy = character_distance($game_player)
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end    
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards player
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards player
      sy > 0 ? turn_up : turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Away from Player - Game_Character
  #--------------------------------------------------------------------------
  def turn_away_from_player
    # Don't Turn if Direction Fix is ON
    return if @direction_fix
    # Determine Correct Distance to Target for Looping Maps
    sx, sy = character_distance($game_player)
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end    
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left away from player
      sx > 0 ? turn_right : turn_left
    # If vertical distance is longer
    else
      # Turn up or down away from player
      sy > 0 ? turn_down : turn_up
    end
  end
  #--------------------------------------------------------------------------
  # * Move toward Player - Game_Character
  #--------------------------------------------------------------------------
  def move_toward_player
    # Determine Correct Distance to Target for Looping Maps
    sx, sy = character_distance($game_player)
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # Get absolute value of difference
    abs_sx = sx.abs
    abs_sy = sy.abs
    # If horizontal and vertical distances are equal
    if abs_sx == abs_sy
      # Increase one of them randomly by 1
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    # If horizontal distance is longer
    if abs_sx > abs_sy
      # Move towards player, prioritize left and right directions
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    # If vertical distance is longer
    else
      # Move towards player, prioritize up and down directions
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move away from Player
  #--------------------------------------------------------------------------
  def move_away_from_player
    # Determine Correct Distance to Target for Looping Maps
    sx, sy = character_distance($game_player)
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # Get absolute value of difference
    abs_sx = sx.abs
    abs_sy = sy.abs
    # If horizontal and vertical distances are equal
    if abs_sx == abs_sy
      # Increase one of them randomly by 1
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    # If horizontal distance is longer
    if abs_sx > abs_sy
      # Move away from player, prioritize left and right directions
      sx > 0 ? move_right : move_left
      if not moving? and sy != 0
        sy > 0 ? move_down : move_up
      end
    # If vertical distance is longer
    else
      # Move away from player, prioritize up and down directions
      sy > 0 ? move_down : move_up
      if not moving? and sx != 0
        sx > 0 ? move_right : move_left
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Make New XY Hash Conditions? - Game_Character
  #  - Determines if Event does not match the Stored Hash Keys
  #  - Used only if Modular Collision Optimizer is installed
  #--------------------------------------------------------------------------   
  def make_new_xy_hash_conditions?(x, y)
    # Correct Arguments for Looping Maps
    x = $game_map.loop_horizontal? ? x % $game_map.width : x
    y = $game_map.loop_vertical? ? y % $game_map.height : y
    # Evaluate the Conditions
    return (@map_hash_x != x or @map_hash_y != y) 
  end  
  #--------------------------------------------------------------------------
  # * Make New XY Hash Keys - Game_Character
  #  - Creates X and Y Hash Keys using Rounded X and Y Values
  #  - Used only if Modular Collision Optimizer is installed
  #--------------------------------------------------------------------------   
  def make_new_xy_hash_keys
    x = $game_map.loop_horizontal? ? @x.round % $game_map.width : @x.round
    y = $game_map.loop_vertical? ? @y.round % $game_map.height : @y.round
    return [x,y]
  end  
  #--------------------------------------------------------------------------
  # * Screen X - Game_Character
  #  - Get Screen X-Coordinates
  #--------------------------------------------------------------------------
  def screen_x
    # Adjust for Looping Maps and Ceil to prevent Screen Event Tearing
    return ($game_map.adjust_x(@real_x / 128.0) * 32 + 16).ceil
  end
  #--------------------------------------------------------------------------
  # * Screen Y - Game_Character
  #  - Get Screen Y-Coordinates
  #--------------------------------------------------------------------------
  def screen_y
    # Determine Jump Height
    height = (@jump_peak * @jump_peak - (@jump_count - @jump_peak).abs ** 2) / 2
    # Adjust for Looping Maps and Ceil to prevent Screen Event Tearing
    return ($game_map.adjust_y(@real_y / 128.0) * 32 + 32 - height).ceil
  end
  #--------------------------------------------------------------------------
  # * Screen Z - Game_Character
  #  - Get Screen Z-Coordinates
  #     height : character height
  #--------------------------------------------------------------------------
  alias loop_map_screen_z screen_z unless $@
  def screen_z(height = 0)
    z = loop_map_screen_z(height)
    # Correct Z Index If Map Loops Vertical
    return ($game_map.loop_vertical? and not @always_on_top) ? 
      z % ($game_map.height * 32.0) : z
  end 
end

#==============================================================================
# ** Game_Event - Class
#==============================================================================
class Game_Event
  #--------------------------------------------------------------------------
  # * Check Event Trigger Touch - Game_Event
  #  - Touch Event Starting Determinant (Event Touches Player)
  #--------------------------------------------------------------------------
  alias loop_map_check_event_trigger_touch check_event_trigger_touch unless $@
  def check_event_trigger_touch(x, y)
    # If event is running
    if $game_system.map_interpreter.running?
      return
    end
    # If trigger is [touch from event] and consistent with player coordinates
    if @trigger == 2 and 
       mp_match_coordinates?(x, y, $game_player.x, $game_player.y)
      # If starting determinant other than jumping is front event
      if not jumping? and not over_trigger?
        start
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Check Event Trigger Auto - Game_Event
  #  - Automatic Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    # If trigger is [touch from event] and consistent with player coordinates
    if @trigger == 2 and 
       mp_match_coordinates?(@x, @y, $game_player.x, $game_player.y)      
      # If starting determinant other than jumping is same position event
      if not jumping? and over_trigger?
        start
      end
    end
    # If trigger is [auto run]
    if @trigger == 3
      start
    end
  end
  #--------------------------------------------------------------------------
  # * Force Loop Round Positions - Game_Event
  #  - Called when Map Loop Type is changd to correct positions
  #  - Ignores Map Loop Properties when called
  #--------------------------------------------------------------------------
  def force_loop_round_positions
    # If not Allowed Off Map (Property of Heretic's Caterpillar or Other)
    if not (@through and @allowed_off_map)
      # Round X Coordinates
      @x %= $game_map.width
      # If Moving Horizontal
      d = (@real_x != @x * 128) ? @real_x - @x * 128 : 0
      # Correct Real X Coordinates to suit Animations
      if d.abs > $game_map.width * 64
        @real_x += (d < 0) ? $game_map.width * 128 : $game_map.width * -128
      else
        @real_x %= $game_map.width * 128
      end      
      # Round Y Coordinates
      @y %= $game_map.height
      # If Moving Vertical
      d = (@real_y != @y * 128) ? @real_y - @y * 128 : 0
      # Correct Real Y Coordinates to suit Animations
      if d.abs > $game_map.height * 64
        @real_y += (d < 0) ? $game_map.height * 128 : $game_map.height * -128
      else
        @real_y %= $game_map.height * 128
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Loop Round Coordinates - Game_Event
  #  - Corrects self position based on Looping Maps
  #--------------------------------------------------------------------------
  def loop_round_coordinates
    # If Map Loops Horizontally and Out of Map Range (No X Loop is Caterpillar)
    if $game_map.loop_horizontal? and not @no_x_loop_round and
       (@real_x < 0 or @real_x > $game_map.width * 128)
      # Correct Event's Position
      @x %= $game_map.width
      @real_x %= $game_map.width * 128
    end
    # If Map Loops Vertically and Out of Map Range (No Y Loop is Caterpillar)
    if $game_map.loop_vertical? and not @no_y_loop_round and
       (@real_y < 0 or @real_y > $game_map.height * 128)
      # Correct Event's Position
      @y %= $game_map.height
      @real_y %= $game_map.height * 128
    end    
  end
  #--------------------------------------------------------------------------
  # * Update - Game_Event
  #--------------------------------------------------------------------------
  alias loop_map_event_update update unless $@
  def update
    # Check for Looping Maps and adjust out of range coordinates
    loop_round_coordinates
    # Call Original or other Aliases
    loop_map_event_update
  end
end

#==============================================================================
# ** Game_Player
#==============================================================================
class Game_Player
  #----------------------------------------------------------------------------
  # * Check Event Trigger Here - Game_Player (FULL REDEFINITION)
  #  - Same Position Starting Determinant
  #  - Fully Redefines method Check Event Trigger Here
  #     triggers : Array of @trigger[0,1,2] Action Button, Player / Event Touch
  #----------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Create an Array of Events to check Triggers
    event_list = make_events_list(@x, @y)
    # Loop Events in List
    for event in event_list
      # If Coordinat Match and Triggers Arg is consistent with Event's Trigger
      if mp_match_coordinates?(@x, @y, event.x, event.y) and
         triggers.include?(event.trigger)
        # If starting determinant is same position event (other than jumping)
        if not event.jumping? and event.over_trigger?
          event.start
          result = true
        end
      end
    end
    return result
  end  
  #--------------------------------------------------------------------------
  # * Check Event Trigger There - Game_Player (FULL REDEFINITION)
  #  - Front Envent Starting Determinant
  #      triggers : [0,1,2] for Action Button, Player Touch, Event Touch
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Calculate front event coordinates
    new_x, new_y = make_new_xy(@x, @y, @direction)
    # Create an Array of Events to check Triggers
    event_list = make_events_list(new_x, new_y)
    # Loop Events in List
    for event in event_list
      # If event coordinates and triggers are consistent
      if mp_match_coordinates?(new_x, new_y, event.x, event.y) and
         triggers.include?(event.trigger)
        # If starting determinant is front event (other than jumping)
        if not event.jumping? and not event.over_trigger?
          event.start
          result = true
        end
      end
    end
    # If fitting event is not found
    if result == false
      # If front tile is a counter
      if $game_map.counter?(new_x, new_y)
        # Calculate 1 tile inside coordinates
        new_x, new_y = make_new_xy(new_x, new_y, @direction)
        # Create an Array of Events to check Triggers
        event_list = make_events_list(new_x, new_y)
        # Loop Events in List
        for event in event_list
          # If event coordinates and triggers are consistent
          if mp_match_coordinates?(new_x, new_y, event.x, event.y) and
             triggers.include?(event.trigger)
            # If starting determinant is front event (other than jumping)
            if not event.jumping? and not event.over_trigger?
              event.start
              result = true
            end
          end
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Check Event Trigger Touch - Game_Player
  #  - Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  alias map_loop_check_event_trigger_touch check_event_trigger_touch unless $@
  def check_event_trigger_touch(x, y)
    # Correct X and Y values for Looping Maps
    x = x % $game_map.width if $game_map.loop_horizontal?
    y = y % $game_map.height if $game_map.loop_vertical?
    # Use Corrected X and Y for Looping Maps to check Touch Triggers
    return map_loop_check_event_trigger_touch(x, y)
  end  
  #--------------------------------------------------------------------------
  # * Center - Game_Player
  #  - Positions Player
  #  - Set Map Display Position to Center of Screen
  #--------------------------------------------------------------------------
  alias loop_map_center center unless $@
  def center(x, y)
    # Call Original or other Aliases
    loop_map_center(x, y)    
    # Recenter Display Horizontally if Map Loops Horizontal
    $game_map.display_x = x * 128 - CENTER_X if $game_map.loop_horizontal?
    # Recenter Display Vertically if Map Loops Vertical
    $game_map.display_y = y * 128 - CENTER_Y if $game_map.loop_vertical?
  end
  #--------------------------------------------------------------------------
  # * Correct Loop Left - Game_Player
  #  - Corrects Player Coordinates, Fogs, and Panoramas on a Map Loop
  #--------------------------------------------------------------------------   
  def correct_loop_left(scroll_dist = 0)
    # Set Looped Property for Scripts to check Value for one frame
    $game_map.looped = 4    
    # Fix Player's Position
    @x %= $game_map.width
    @real_x %= $game_map.width * 128
    # Correct Map Display (Optional Arg for Corrections from other scripts)
    $game_map.display_x %= $game_map.width * 128
    $game_map.display_x += scroll_dist
    # Correct Fog Display
    $game_map.fog_ox -= $game_map.width * 32.0
    # If Game Guy's Unlimited Fogs with Heretic's Cloud Altitude
    if $scene.loop_spriteset.respond_to?(:get_all_multi_fogs)
      # Select each Fog in Spriteset Array
      for i in 1...$scene.loop_spriteset.get_all_multi_fogs.size
        # Shorthand for the Unlimited Fog Object
        fog = $scene.loop_spriteset.get_all_multi_fogs[i]
        # Adjust Fog Position for Loop Display
        fog.real_ox -= $game_map.width * 32.0
      end
    end
    # Panorama Scroll Speed Adjustment
    pscroll_x = ($game_map.pan_scroll_x) ? $game_map.pan_scroll_x / 8.0 : 1.0
    # Correct Panorama Display
    $game_map.loop_pan_x -= $game_map.width * 16.0 / pscroll_x
  end
  #--------------------------------------------------------------------------
  # * Correct Loop Right - Game_Player
  #  - Corrects Player Coordinates, Fogs, and Panoramas on a Map Loop
  #--------------------------------------------------------------------------   
  def correct_loop_right(scroll_dist = 0)
    # Set Looped Property for Scripts to check Value for one frame
    $game_map.looped = 6    
    # Fix Player's Position
    @x %= $game_map.width
    @real_x %= ($game_map.width * 128)
    # Correct Map Display (Optional Arg for Corrections from other scripts)
    $game_map.display_x %= $game_map.width * 128
    $game_map.display_x -= $game_map.width * 128 + scroll_dist
    # Correct Fog Display
    $game_map.fog_ox += $game_map.width * 32.0
    # If Game Guy's Unlimited Fogs with Heretic's Cloud Altitude
    if $scene.loop_spriteset.respond_to?(:get_all_multi_fogs)
      # Select each Fog in Spriteset Array
      for i in 1...$scene.loop_spriteset.get_all_multi_fogs.size
        # Shorthand for the Unlimited Fog Object
        fog = $scene.loop_spriteset.get_all_multi_fogs[i]
        # Adjust Fog Position for Loop Display
        fog.real_ox += $game_map.width * 32.0
      end
    end
    # Panorama Scroll Speed Adjustment
    pscroll_x = ($game_map.pan_scroll_x) ? $game_map.pan_scroll_x / 8.0 : 1.0
    # Correct Panorama Display
    $game_map.loop_pan_x += $game_map.width * 16 / pscroll_x
  end
  #--------------------------------------------------------------------------
  # * Correct Loop Up - Game_Player
  #  - Corrects Player Coordinates, Fogs, and Panoramas on a Map Loop
  #--------------------------------------------------------------------------   
  def correct_loop_up(scroll_dist = 0)
    # Set Looped Property for Scripts to check Value for one frame
    $game_map.looped = 8    
    # Fix Player's Position
    @y %= $game_map.height
    @real_y %= $game_map.height * 128
    # Correct Map Display (Optional Arg for Corrections from other scripts)
    $game_map.display_y %= $game_map.height * 128
    $game_map.display_y += scroll_dist
    # Correct Fog Display
    $game_map.fog_oy -= $game_map.height * 32.0
    # If Game Guy's Unlimited Fogs with Heretic's Cloud Altitude
    if $scene.loop_spriteset.respond_to?(:get_all_multi_fogs)
      # Select each Fog in Spriteset Array
      for i in 1...$scene.loop_spriteset.get_all_multi_fogs.size
        # Shorthand for the Unlimited Fog Object
        fog = $scene.loop_spriteset.get_all_multi_fogs[i]
        # Adjust Fog Position for Loop Display
        fog.real_oy -= $game_map.height * 32.0
      end
    end
    # Panorama Scroll Speed Adjustment
    pscroll_y = ($game_map.pan_scroll_y) ? $game_map.pan_scroll_y / 8.0 : 1.0
    # Correct Panorama Display
    $game_map.loop_pan_y -= $game_map.height * 16.0 / pscroll_y
  end
  #--------------------------------------------------------------------------
  # * Correct Loop Down - Game_Player
  #  - Corrects Player Coordinates, Fogs, and Panoramas on a Map Loop
  #--------------------------------------------------------------------------  
  def correct_loop_down(scroll_dist = 0)
    # Set Looped Property for Scripts to check Value for one frame
    $game_map.looped = 2    
    # Fix Player's Position
    @y %= $game_map.height
    @real_y %= $game_map.height * 128
    # Correct Map Display (Optional Arg for Corrections from other scripts)
    $game_map.display_y %= $game_map.height * 128
    $game_map.display_y -= $game_map.height * 128 + scroll_dist
    # Correct Fog Display
    $game_map.fog_oy += $game_map.height * 32.0
    # If Game Guy's Unlimited Fogs with Heretic's Cloud Altitude
    if $scene.loop_spriteset.respond_to?(:get_all_multi_fogs)
      # Select each Fog in Spriteset Array
      for i in 1...$scene.loop_spriteset.get_all_multi_fogs.size
        # Shorthand for the Unlimited Fog Object
        fog = $scene.loop_spriteset.get_all_multi_fogs[i]
        # Adjust Fog Position for Loop Display
        fog.real_oy += $game_map.height * 32.0
      end
    end
    # Panorama Scroll Speed Adjustment
    pscroll_y = ($game_map.pan_scroll_y) ? $game_map.pan_scroll_y / 8.0 : 1.0
    # Correct Panorama Display
    $game_map.loop_pan_y += $game_map.height * 16.0 / pscroll_y
  end
  #--------------------------------------------------------------------------
  # * Map Loop Position - Game_Player
  #  - Calls for Corrections when Player triggers a Map Loop
  #--------------------------------------------------------------------------  
  def map_loop_position
    # Set Looped Property for Scripts to check Value for ONE FRAME
    $game_map.looped = nil
    # Ignore Corrections if not on a Looping Map
    return unless $game_map.loop_type > 0 and (moving? or jumping?)
    # If Horizontal Map Loop
    if $game_map.loop_horizontal?
      # Correct Positions if outside Map Boundaries
      correct_loop_left if @real_x < 0
      correct_loop_right if @real_x > $game_map.width * 128
    end
    # If Horizontal Map Loop
    if $game_map.loop_vertical?
      # Correct Positions if outside Map Boundaries
      correct_loop_up if @real_y < 0
      correct_loop_down if @real_y > $game_map.height * 128
    end
  end
  #--------------------------------------------------------------------------
  # * Update - Game_Player
  #--------------------------------------------------------------------------
  alias map_loop_update update unless $@
  def update
    # Update Map Loop Positions
    map_loop_position    
    # Call Original or other Aliases
    map_loop_update
  end
end
