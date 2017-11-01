#==============================================================================
# ** Anti Event Lag System
#------------------------------------------------------------------------------
# Zeriab
# Version 1.2b
# 2008-09-12 (Year-Month-Day)
#------------------------------------------------------------------------------
# * Requirements :
#   
#   If you have the SDK : Version 2.0+, Part I, II
#   Does not require the SDK
#------------------------------------------------------------------------------
# * Version History :
#
#   Version 0.8 -------------------------------------------------- (2007-09-03)
#    - First release
#
#   Version 0.81 ------------------------------------------------- (2007-09-05)
#    - Overwrote Game_Map's passable? method for faster collision detection
#
#   Version 0.9 -------------------------------------------------- (2007-09-12)
#    - Support for the Non-SDK patch
#    - Support for defining whether an event will always be updated or never
#      be updated by defining name patterns.
#
#   Version 1.0 -------------------------------------------------- (2007-09-24)
#   - Fixed compatibility issue with Blizzard's Caterpillar script
#   - Overwrote more methods scanning for events on a specific tile
#   - Support for defining whether an event will always be updated or never
#      be updated by specifying the event's id and map_id
#   - Some structural changes.
#   - Integrated the Non-SDK patch into the main script
#
#   Version 1.05 ------------------------------------------------- (2007-11-18)
#   - Fixed bug where sprites might not be disposed when changing scene.
#
#   Version 1.1 -------------------------------------------------- (2008-04-10)
#   - Added declaration to which common events to update
#
#   Version 1.15 ------------------------------------------------- (2008-06-19)
#   - Added automatic detection of which common events to update (optional)
#
#   Version 1.2 -------------------------------------------------- (2008-07-04)
#   - Fixed a case where an event could be registered twice causing transparent
#      events to look less transparent.
#
#   Version 1.2b ------------------------------------------------- (2008-09-12)
#   - Fixed a stack error problem caused when pressing F12.
#------------------------------------------------------------------------------
# * Description :
#
#   This script was designed to reduce lag by changing the data structure of 
#   the events in the Game_Map class and update the functionality accordingly
#   A goal of this script is not to change the normal event behavior, so
#   implementing it into a project should not effect previous events. It might
#   effect custom scripts.
#------------------------------------------------------------------------------
# * License :
#
#   Copyright (C) 2007, 2008  Zeriab
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser Public License for more details.
#
#   For the full license see <http://www.gnu.org/licenses/> 
#   The GNU General Public License: http://www.gnu.org/licenses/gpl.txt
#   The GNU Lesser General Public License: http://www.gnu.org/licenses/lgpl.txt
#------------------------------------------------------------------------------
# * Compatibility :
#
#   This is SDK compliant. It is written for SDK version 2.3.
#   It requires SDK 2.0+ if you are using the SDK
#   The Non-SDK patch is integrated so you can run it without the SDK
#   
#   The following methods has been overwritten:
#    * Game_Character.passable?
#    * Game_Map.passable?
#    * Game_Map.update_events
#    * Game_Player.check_event_trigger_here
#    * Game_Player.check_event_trigger_there
#    * Game_Player.check_event_trigger_touch
#    * Spriteset_Map.init_characters
#    * Spriteset_Map.update_character_sprites
#
#   The following methods have been aliased
#    * Game_Event.jump
#    * Game_Event.moveto
#    * Game_Event.move_down
#    * Game_Event.move_left
#    * Game_Event.move_right
#    * Game_Event.move_up
#    * Game_Event.move_lower_left
#    * Game_Event.move_lower_right
#    * Game_Event.move_upper_left
#    * Game_Event.move_upper_right
#    * Game_Map.setup
#------------------------------------------------------------------------------
# * Instructions :
#
#   Place this script just below the SDK if you are using the SDK.
#   Place this script just below the default if using the Non-SDK Patch
#   
#   default scripts
#   (SDK)
#   Zeriab's Anti Event Lag System
#   (custom scripts)
#   main
#
#   ~ Game_Map ~
#   There are 4 constants you can change at will in the top of the
#   Game_Map class: (You don't have to ;))
#   
#   ALWAYS_UPDATE ~ The default is false
#   -------------------------------
#   You can set this to true if you want all events to be update always
#   This a slower option, but events behave like they do without the script.
#   You will still benifit from the faster collision detection and fewer sprites
#   This has higher priority than the event specific features. I.e never_update
#
#   BUFFER_SIZE ~ The default is 2
#   -------------------------
#   You can increase or decrease the buffer size by altering this value.
#   The greater this value the greater area around the visible area is updated
#   at the price of potential more lag.
#   The lower this value the smaller area around the visible area is update
#   with the potential of less lag.
#   Too low a value may get the sprites to sort of 'freeze' in the outskirts
#   of the screen.
#   Bigger sprites requires bigger buffer to prevent this.
#   
#   TILES_VERTICAL ~ The default is 15
#   -----------------------------
#   Specifies how many tiles there are vertical
#   I included the option to change this value if you want to alter
#   the size of the game window.
#   If you for example want 800x600 I suggest changing this value to 20
#
#   TILES_HORIZONTAL ~ The default is 20
#   -------------------------------
#   Specifies how many tiles there are horizontal
#   I included the option to change this value if you want to alter
#   the size of the game window.
#   If you for example want 800x600 I suggest changing this value to 27
#   
#   LIMIT_COMMON_EVENTS - The default is true
#   -----------------------------
#   You can see this to false if you want all common events updated.
#   This constant only has an effect during the upstart of the program. Changing
#   it during the game will have no effect.
#   If it is set to false you can safely ignore the following three constants
#
#   SPECIFY_COMMON_EVENTS_MANUALLY - The default is false
#   -----------------------------
#   Specifies whether you want to enter which common events should be updated
#   manually. If this is set to false you can safely ignore 
#   COMMON_EVENTS_TO_UPDATE while COMMON_EVENT_FILEPATH is of importance.
#   Vice-versa is COMMON_EVENTS_TO_UPDATE important and COMMON_EVENT_FILEPATH
#   safe to ignore if SPECIFY_COMMON_EVENTS_MANUALLY is set to true.
#   If this is set to false which common events to update will be atomatically
#   detected.
#   As a general rule of thumb: Only change this to true if you have problems
#   with the automatic detection or you want to prevent certain common events
#   with autorun or parallel process as trigger.
#
#   COMMON_EVENTS_TO_UPDATE
#   -----------------------------
#   This constant is an array of common event ids. Only the common events with
#   the ids specified in the array will be updated. The ids are the numbers
#   shown in the database with any leading 0s removed. In general only common
#   events which have autorun or parallel process needs to be updated.
#   It will have no effect if SPECIFY_COMMON_EVENTS_MANUALLY is false
#   Let's say we want the common events 005, 009 and 020 to be updated. First we
#   will remove the leading 0s and get 5, 9 and 20. Next we will put them in the
#   array and get as end result:
#
#     COMMON_EVENTS_TO_UPDATE = [5, 9, 20]
#
#   If we had put [005, 009, 020] as the array we would have gotten an error
#   when starting the game. 
#   If we now want to update common event 045 we would add 45 to the array:
#
#     COMMON_EVENTS_TO_UPDATE = [5, 9, 20, 45]
#
#
#   COMMON_EVENT_FILEPATH - The default is 'Data/CommonEvents.rxdata'
#   -----------------------------
#   Specifies the relative file path (To the directory of where the Game.exe is)
#   to where the common events are stored.
#   Only change this if you have changed the name or place of the
#   CommonEvents.rxdata file.
#   It will have no effect if SPECIFY_COMMON_EVENTS_MANUALLY is true
#
#
#   ~ Game_Event ~
#   Next we come to the Constants in Game_Event. They are given above the
#   Game_Map code. They have been split from the other Game_Event code for
#   Easier access:
#
#   SPECIAL_UPDATE_IDS
#   ------------------
#   This constant contains a hash where you can specify how specific events
#   should be updated. Special update ids has priority over name patterns.
#   The keys are all a 2-elements array. [Map_ID, Event_ID]
#   The value is either an 'A' for always update or 'N' for never update.
#   Here is an example:
#
#     SPECIAL_UPDATE_IDS = {[1,1]=>'A',
#                           [1,2]=>'N'}
#   
#   Notice the first line [1,1]=>'A'
#   It means that the event with id 1 on map 1 will always be updated.
#
#   Notice the first line [1,2]=>'N'
#   It means that the event with id 2 on map 1 will never be updated.
#   Let's say we wanted the event with id 5 on map 3 to always be updated.
#   This can be achieved by adding [5,3]=>'A' to the hash:
#
#     SPECIAL_UPDATE_IDS = {[1,1]=>'A',
#                           [1,2]=>'N',
#                           [5,3]=>'A'}
#
#
#   NEVER_UPDATE_NAME_PATTERNS
#   --------------------------
#   Here you can specify any number of patterns which will be checked when a
#   new map is loaded. Any events which matches at least one of the patterns
#   given here will never be updated.
#   A pattern is assumed to be either a String or a RegExp. In the case of a
#   String name.include?(string) is used. Otherwise the =~ operator is used
#   Note: The never_update feature has higher priority than the always_update.
#   If an event's name matches both a always update pattern and a never_update
#   pattern it will never update.
#
#   ALWAYS_UPDATE_NAME_PATTERNS
#   ---------------------------
#   Here you can specify any number of patterns which will be checked when a
#   new map is loaded. Any events which matches at least one of the patterns
#   given here will always be updated.
#   Note: The always_update feature has lower priority than the never_update.
#   If an event's name matches both a always update pattern and a never_update
#   pattern it will never update.
#==============================================================================

if Module.constants.include?('SDK')
  #----------------------------------------------------------------------------
  # * SDK Log Script
  #----------------------------------------------------------------------------
  SDK.log('Anti Event Lag System', 'Zeriab', 1.2, '2008-06-25')
  SDK.check_requirements(2.0)
end

#------------------------------------------------------------------------------
# * Begin SDK Enable Test
#------------------------------------------------------------------------------
if !Module.constants.include?('SDK') || SDK.enabled?('Anti Event Lag System')

#==============================================================================
# ** Constants for the anti lag script
#==============================================================================

class Game_Map
  ALWAYS_UPDATE = false
  BUFFER_SIZE = 2
  TILES_VERTICAL = 15
  TILES_HORIZONTAL = 20
  LIMIT_COMMON_EVENTS = true
  SPECIFY_COMMON_EVENTS_MANUALLY = false
  # If you want to specify which common events to update
  COMMON_EVENTS_TO_UPDATE = []
  # If you want the script to automatically read the common events and find
  # out which to update. Must be the path to the CommonEvents.rxdata
  COMMON_EVENT_FILEPATH = 'Data/CommonEvents.rxdata'
end

class Game_Event
  SPECIAL_UPDATE_IDS = {}
  NEVER_UPDATE_NAME_PATTERNS = ['[N]'] # [N] in the event name => not updated
  ALWAYS_UPDATE_NAME_PATTERNS = ['[A]'] # [A] in the event name => always updated 
end

#==============================================================================
# ** Automatic configuration generation
#==============================================================================
class Game_Map
  if LIMIT_COMMON_EVENTS && !SPECIFY_COMMON_EVENTS_MANUALLY
    # Find the common events which needs to be updated
    COMMON_EVENTS_TO_UPDATE = []
    # Load the common events
    common_events = load_data(COMMON_EVENT_FILEPATH)
    # Go through the common events
    for common_event in common_events.compact
      # Check if there is a need for the common event to update
      if common_event.trigger > 0
        # C
        COMMON_EVENTS_TO_UPDATE << common_event.id
      end
    end
  end
end

#==============================================================================
# ** Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :event_map
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias_method :zeriab_antilag_gmmap_setup,   :setup
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup(*args)
    # Makes an event map as a hash
    @event_map = {}
    # Original Setup
    zeriab_antilag_gmmap_setup(*args)
    # Go through each event
    for event in @events.values
      # Check how the event should be updated
      event.check_update
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Events ~ Overwritten to only updating visible and special events
  #--------------------------------------------------------------------------
  def update_events
    # Runs through the events
    for event in @events.values
      # checks if the event is visible or needs to be updated
      if ALWAYS_UPDATE || event.need_update?
        event.update
      end
    end
  end
  
  # Only overwrite this method if common events should be limited
  if LIMIT_COMMON_EVENTS
    #--------------------------------------------------------------------------
    # * Update Common Events ~ Updates only the necessary common events
    #--------------------------------------------------------------------------
    def update_common_events
      for i in COMMON_EVENTS_TO_UPDATE
        @common_events[i].update
      end
    end
  end
    
  #--------------------------------------------------------------------------
  # * Called when an event has been moved with it's old x and y coordinate
  #   Used to update its position in the event_map
  #--------------------------------------------------------------------------
  def move_event(old_x,old_y,event)
    # Checks if the event has moved to a new position.
    return if old_x == event.x && old_y == event.y
    # Removes the event from its old position
    remove_event(old_x, old_y, event)
    # Adds the event to its new position
    add_event(event.x,event.y,event)
    # Gets the spriteset from Scene_Map
    spriteset = $scene.instance_eval('@spriteset')
    # Checks that it actually is a Spriteset_Map.
    if spriteset.is_a?(Spriteset_Map) && spriteset.respond_to?(:update_event)
      # Tells the spriteset to update the event to its new position
      spriteset.update_event(old_x,old_y,event)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Adds an event to the event_map at the given x and y coordinate
  #--------------------------------------------------------------------------
  def add_event(x,y,event)
    # Checks if there are not any events on the specific tile
    if @event_map[[x,y]].nil?
      # Sets the position on the map to be an array containing the given
      # event. (In case there are placed additional events on this tile)
      @event_map[[x,y]] = [event]
    else
      # Adds the event to the array of events on the specific tile
      @event_map[[x,y]] << event
    end
  end
  
  #--------------------------------------------------------------------------
  # * Removes an event from the event_map with the given x and y coordinate
  #--------------------------------------------------------------------------
  def remove_event(x,y,event)
    # Checks if there actually are an event on the given coordinates
    return if @event_map[[x,y]].nil?
    # Checks whether or not there are more events than the given event on
    # with the given coordinates
    if @event_map[[x,y]].size > 1
      # Deletes the events from the array of events
      @event_map[[x,y]].delete(event)
    else
      # Deletes the key along with the corresponding value from the hashmap
      # since there are no other events on the tile.
      @event_map.delete([x,y])
    end
  end
  
  #--------------------------------------------------------------------------
  # * Gets min_x, max_x, min_y and max_y including the buffer-size
  # Returns min_x, max_x, min_y, max_y  (tile-coordinates)
  # Returns a Rect if 'true' is given as the argument
  #--------------------------------------------------------------------------  
  def get_tile_area(rect = false)
    # Gets the upper left x and y tile-coordinate
    x = $game_map.display_x / 128
    y = $game_map.display_y / 128
    # Computes the min and max coordinates when considering the buffer-size
    min_x = x - BUFFER_SIZE
    min_y = y - BUFFER_SIZE
    max_x = x + TILES_HORIZONTAL + BUFFER_SIZE
    max_y = y + TILES_VERTICAL + BUFFER_SIZE
    # Makes sure the min and max coordinates are within the map
    if min_x < 0
      min_x = 0
    end
    if max_x >= $game_map.width
      max_x = $game_map.width - 1
    end
    if min_y < 0
      min_y = 0
    end
    if max_y >= $game_map.height
      max_y = $game_map.height - 1
    end
    # Checks if the return should be a Rect
    if rect
      # Returns the result as a Rect
      return Rect.new(min_x, min_y, max_x - min_x, max_y - min_y)
    else
      # Returns the result as the min and max coordinates
      return min_x, max_x, min_y, max_y
    end
  end
  
  #--------------------------------------------------------------------------
  # * Checks if the tile with the given x and y coordinate is visible.
  #   Takes the buffer size into account.
  #--------------------------------------------------------------------------
  def visible?(x,y)
    min_x = $game_map.display_x / 128
    min_y = $game_map.display_y / 128
    if x >= min_x - BUFFER_SIZE && x <= min_x + BUFFER_SIZE + TILES_HORIZONTAL &&
       y >= min_y - BUFFER_SIZE && y <= min_y + BUFFER_SIZE + TILES_VERTICAL
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # * Get Designated Position Event ID
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  def check_event(x, y)
    # Retrives the events on the specified tile
    events = event_map[[x,y]]
    unless events.nil?
      # Loop through events on tile
      for event in events
        if event.x == x and event.y == y
          return event.id
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Passable
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     d          : direction (0,2,4,6,8,10)
  #                  *  0,10 = determine if all directions are impassable
  #     self_event : Self (If event is determined passable)
  #--------------------------------------------------------------------------
  def passable?(x, y, d, self_event = nil)
    # If coordinates given are outside of the map
    unless valid?(x, y)
      # impassable
      return false
    end
    # Change direction (0,2,4,6,8,10) to obstacle bit (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f
    # Retrives the events on the specified tile
    events = event_map[[x,y]]
    unless events.nil?
      # Loop through events on tile
      for event in events
        # If tiles other than self are consistent with coordinates
        if event.tile_id >= 0 and event != self_event and not event.through
          # If obstacle bit is set
          if @passages[event.tile_id] & bit != 0
            # impassable
            return false
          # If obstacle bit is set in all directions
          elsif @passages[event.tile_id] & 0x0f == 0x0f
            # impassable
            return false
          # If priorities other than that are 0
          elsif @priorities[event.tile_id] == 0
            # passable
            return true
          end
        end
      end
    end
    # Loop searches in order from top of layer
    for i in [2, 1, 0]
      # Get tile ID
      tile_id = data[x, y, i]
      # Tile ID acquistion failure
      if tile_id == nil
        # impassable
        return false
      # If obstacle bit is set
      elsif @passages[tile_id] & bit != 0
        # impassable
        return false
      # If obstacle bit is set in all directions
      elsif @passages[tile_id] & 0x0f == 0x0f
        # impassable
        return false
      # If priorities other than that are 0
      elsif @priorities[tile_id] == 0
        # passable
        return true
      end
    end
    # passable
    return true
  end
end


#==============================================================================
# ** Game_Character
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # * Determine if Passable (Overwrite)
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,2,4,6,8)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    # Get new coordinates
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    # If coordinates are outside of map
    unless $game_map.valid?(new_x, new_y)
      # impassable
      return false
    end
    # If through is ON
    if @through
      # passable
      return true
    end
    # If unable to leave first move tile in designated direction
    unless $game_map.passable?(x, y, d, self)
      # impassable
      return false
    end
    # If unable to enter move tile in designated direction
    unless $game_map.passable?(new_x, new_y, 10 - d)
      # impassable
      return false
    end
    # If player coordinates are consistent with move destination
    if $game_player.x == new_x and $game_player.y == new_y
      # If through is OFF
      unless $game_player.through
        # If your own graphic is the character
        if @character_name != ""
          # impassable
          return false
        end
      end
    end
    # Checks for events on the new position
    events = $game_map.event_map[[new_x,new_y]]
    if events.nil?
      # passable
      return true
    end
    # Loop all events on the tile
    for event in events
      # If event coordinates are consistent with move destination
      if event.x == new_x and event.y == new_y
        # If through is OFF
        unless event.through
          # If self is event
          if self != $game_player
            # impassable
            return false
          end
          # With self as the player and partner graphic as character
          if event.character_name != ""
            # impassable
            return false
          end
        end
      end
    end
    # passable
    return true
  end
end

#==============================================================================
# ** Game_Event
#==============================================================================

class Game_Event
  # The method to alias and overwrite
  AX = [:jump, :moveto, :move_down, :move_left, :move_right, :move_up,
    :move_lower_left, :move_lower_right, :move_upper_left, :move_upper_right]
  for method in AX
    # Aliases the old method
    new_method_as_string = 'zeriab_antilag_gmtev_' + method.to_s
    new_method = new_method_as_string.to_sym
    next if self.method_defined?(new_method)
    alias_method(new_method, method)
    
    # Overwrites the old method
PROG = <<FIN
    def #{method}(*args)
      old_x = @x
      old_y = @y
      #{new_method}(*args)
      unless old_x == @x && old_y == @y
        $game_map.move_event(old_x, old_y, self)
      end
    end
FIN
    # Evaluates the method definition
    eval(PROG)
  end
  
  #--------------------------------------------------------------------------
  # * Always_update property (is false by default) priority under never_update
  #--------------------------------------------------------------------------
  attr_writer :always_update
  def always_update
    @always_update = false  if @always_update.nil?
    return @always_update
  end
  
  #--------------------------------------------------------------------------
  # * Never_update property (is false by default) priority over always_update
  #--------------------------------------------------------------------------
  attr_writer :never_update
  def never_update
    @never_update = false  if @never_update.nil?
    return @never_update
  end
  
  #--------------------------------------------------------------------------
  # * Need Update method. Fast checks here.
  #--------------------------------------------------------------------------
  def need_update?
    return false if never_update
    return true if always_update
    return true if $game_map.visible?(x, y)
    return true if @move_type == 3
    return @trigger == 3 || @trigger == 4
  end
  
  #--------------------------------------------------------------------------
  # * Checks how the event should be updated.
  #--------------------------------------------------------------------------
  def check_update
    name = @event.name
    # Checks if the event is never to be updated. (For decoration)
    for pattern in NEVER_UPDATE_NAME_PATTERNS
      if (pattern.is_a?(String) && name.include?(pattern)) ||
        !(pattern =~ name).nil? 
        self.never_update = true
      end
    end
    # Checks if the event is to be always updated.
    for pattern in ALWAYS_UPDATE_NAME_PATTERNS
      if (pattern.is_a?(String) && name.include?(pattern)) ||
        !(pattern =~ name).nil? 
        self.always_update = true
      end
    end
    # Checks for special update for the particular id (overrules the patterns)
    special_update = SPECIAL_UPDATE_IDS[[@map_id,@id]]
    unless special_update.nil?
      # Checks if it never should be updated
      if special_update.downcase == 'n'
        self.never_update = true
        self.always_update = false
      # Checks if it always should be updated
      elsif special_update.downcase == 'a'
        self.always_update = true
        self.never_update = false
      end
    end
  end
end

#==============================================================================
# ** Game_Event
#==============================================================================

class Game_Player
  #--------------------------------------------------------------------------
  # * Same Position Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Retrives the events on the specified tile
    events = $game_map.event_map[[@x,@y]]
    unless events.nil?
      # Loop through events on tile
      for event in events
        # If event triggers are consistent
        if triggers.include?(event.trigger)
          # If starting determinant is same position event (other than jumping)
          if not event.jumping? and event.over_trigger?
            event.start
            result = true
          end
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Front Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Calculate front event coordinates
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    # Retrives the events on the specified tile
    events = $game_map.event_map[[new_x,new_y]]
    unless events.nil?
      # Loop through events on tile
      for event in events
        # If event triggers are consistent
        if triggers.include?(event.trigger)
          # If starting determinant is front event (other than jumping)
          if not event.jumping? and not event.over_trigger?
            event.start
            result = true
          end
        end
      end
    end
    # If fitting event is not found
    if result == false
      # If front tile is a counter
      if $game_map.counter?(new_x, new_y)
        # Calculate 1 tile inside coordinates
        new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
        new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
        # Retrives the events on the specified tile
        events = $game_map.event_map[[new_x,new_y]]
        unless events.nil?
          # Loop through events on tile
          for event in events
            # If event triggers are consistent
            if triggers.include?(event.trigger)
              # If starting determinant is front event (other than jumping)
              if not event.jumping? and not event.over_trigger?
                event.start
                result = true
              end
            end
          end
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Retrives the events on the specified tile
    events = $game_map.event_map[[x,y]]
    unless events.nil?
      # Loop through events on tile
      for event in events
        # If event coordinates and triggers are consistent
        if [1,2].include?(event.trigger)
          # If starting determinant is front event (other than jumping)
          if not event.jumping? and not event.over_trigger?
            event.start
            result = true
          end
        end
      end
    end
    return result
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
# Overwrites init_characters and update_character_sprites
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Initializes Character Sprites (Overwrite)
  #--------------------------------------------------------------------------
  def init_characters
    # Creates the array used for holding the hero sprite.
    # Is here for compatibility reasons.
    @character_sprites = []
    # Refreshes the characters in the spritemap
    refresh_characters
    # Refreshes the character sprites
    refresh_character_sprites
  end
  
  #--------------------------------------------------------------------------
  # * Refreshes the characters.
  #--------------------------------------------------------------------------
  def refresh_characters
    # Make character sprites
    @character_event_sprites = []
    @character_spritemap = {}
    # Gets the tile area to search for events
    min_x, max_x, min_y, max_y = $game_map.get_tile_area
    # Goes through all the visible tiles and adds the sprites on those tiles
    for x in min_x..max_x
      for y in min_y..max_y
        add_sprites(x,y)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Refreshes the character sprites.
  #--------------------------------------------------------------------------
  def refresh_character_sprites
    # Gets the character sprites
    @character_event_sprites = @character_spritemap.values.flatten
    #### Note: I do not think character sprites have to be sorted, but here it
    ####       is if you for some reason need them sorted.
    #@character_event_sprites.sort! {|a,b| a.character.id <=> b.character.id}
    # Updates the last screen x and y to the current x and y
    @last_screen_x = $game_map.display_x / 128
    @last_screen_y = $game_map.display_y / 128
    # The sprites have just been refresh, no need to do this every frame.
    @need_refresh = false
  end
  
  #--------------------------------------------------------------------------
  # * Updates Character Sprites
  #--------------------------------------------------------------------------
  def update_character_sprites
    # Checks if the player has moved
    unless @last_screen_x == $game_map.display_x / 128 &&
           @last_screen_y == $game_map.display_y / 128
      # Gets the difference in the x and y coordinate
      diff_x = @last_screen_x - $game_map.display_x / 128
      diff_y = @last_screen_y - $game_map.display_y / 128
      # Checks if the player has moved more than one tile. (Supports 8-way)
      if diff_x.abs > 1 || diff_y.abs > 1
        # The player has moved more than one tile.
        # This section could be extended if some of the previous visible area
        # still is visible and only update the the the new areas as well as
        # the parts of the old area that is now out of side.
        # For ease and because this should be a rare situation I have decided
        # to simple remove all sprites and start over for the new area.
        @character_event_sprites.each {|sprite| sprite.dispose}
        # Initialized the sprites for the new area
        init_characters
      else
        # Updates the buffer
        update_buffer(diff_x, diff_y)
      end
      # Refresh the character sprites. (To which should be updated)
      refresh_character_sprites
    else
      # Refreshed the character sprites if it is needed
      refresh_character_sprites if @need_refresh
    end
    # Updates the sprites.
    @character_event_sprites.each {|sprite| sprite.update}
    # Updates the hero sprite. Is here to increase compatibility with other
    # scripts using this array. Most caterpillar scripts for example
    @character_sprites.each {|sprite| sprite.update}
  end
  
  #--------------------------------------------------------------------------
  # * Updates Character Sprites
  #--------------------------------------------------------------------------
  def update_buffer(diff_x, diff_y)
    # Gets the tile area to search for events
    min_x, max_x, min_y, max_y = $game_map.get_tile_area
    # For change in x-coordinate
    if diff_x > 0 # Left
      # Removes any sprites outside of the buffer
      unless max_x >= $game_map.width - 1
        for y in min_y..max_y
          dispose_sprites(max_x+1, y)  
        end
      end
      # Adds any new sprites comming into the buffer
      for y in min_y..max_y
        add_sprites(min_x, y)  if @character_spritemap[[min_x,y]].nil?
      end
    elsif diff_x < 0 # Right
      # Removes any sprites outside of the buffer
      unless min_x <= 0
        for y in min_y..max_y
          dispose_sprites(min_x-1, y)  
        end
      end
      # Adds any new sprites comming into the buffer
      for y in min_y..max_y
        add_sprites(max_x, y)  if @character_spritemap[[max_x,y]].nil?
      end
    end
    # For change in y-coordinates
    if diff_y > 0 # Up
      # Removes any sprites outside of the buffer
      unless max_y >= $game_map.height - 1
        for x in min_x..max_x
          dispose_sprites(x, max_y+1)  
        end
      end
      # Adds any new sprites comming into the buffer
      for x in min_x..max_x
        add_sprites(x, min_y)  if @character_spritemap[[x,min_y]].nil?
      end
    elsif diff_y < 0 # Down
      # Removes any sprites outside of the buffer
      unless min_y <= 0
        for x in min_x..max_x
          dispose_sprites(x, min_y-1)  
        end
      end
      # Adds any new sprites comming into the buffer
      for x in min_x..max_x
        add_sprites(x, max_y)  if @character_spritemap[[x,max_y]].nil?
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Called when an event has moved
  #--------------------------------------------------------------------------
  def update_event(old_x,old_y,event)
    # Finds the sprites on the event's old position
    sprites = @character_spritemap[[old_x,old_y]]
    # Checks if there are any sprites on the event's old position
    unless sprites.nil?
      # Goes through the sprites to find which one is attached to the given
      # event. Sprite is nil if no sprite on the event's old position is 
      # attached to the given event.
      sprite = nil
      for sprite in sprites
        break if sprite.character == event
      end
    end
    # If there is not a sprite attached to the event
    if sprite.nil?
      # Checks if the event has become visible
      if $game_map.visible?(event.x, event.y)
        # A sprite is create because the event is now visible
        sprite = Sprite_Character.new(@viewport1, event)
        # The sprite is added at the event's current position
        add_sprite(event.x,event.y,sprite)
        # We need to refresh the character sprites since we added one.
        @need_refresh = true
      end
    else # A sprite is attached to the event
      # Checks if the event is still visible
      if $game_map.visible?(event.x, event.y)
        # The event is still visible and moved from its old coordinate
        # to its new coordinates.
        move_event(old_x, old_y, sprite)
      else
        # The sprite is not visible anymore and thus removed
        remove_sprite(old_x,old_y,sprite)
        # The sprite is disposed since we don't want to wait for Ruby's
        # garbage cleaner to remove the sprite from view. (For big sprites)
        sprite.dispose
        # We need to refresh the character sprites since we removed one.
        @need_refresh = true
      end
    end
  end
  
  ##
  ## Macros
  ##
  
  #--------------------------------------------------------------------------
  # * Creates and adds sprites for all the events with the given x and y 
  #   coordinates to the spritemap.
  #--------------------------------------------------------------------------
  def add_sprites(x,y)
    # Returns if there are no events with the given x and y coordinates
    return if $game_map.event_map[[x,y]].nil?
    for event in $game_map.event_map[[x,y]]
      # Creates a sprite for the event
      sprite = Sprite_Character.new(@viewport1, event)
      # Adds the sprite to the spritemap
      add_sprite(x,y,sprite)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Disposes all the sprites on given x,y tile
  #--------------------------------------------------------------------------
  def dispose_sprites(x,y)
    # Returns if there are no sprites with the given coordinates
    return if @character_spritemap[[x,y]].nil?
    for sprite in @character_spritemap[[x,y]]
      # Removes the sprite from the datastructure
      remove_sprite(x,y,sprite)
      # Disposes the sprite
      sprite.dispose unless sprite.dispose
    end
  end

  #--------------------------------------------------------------------------
  # * Moves the sprite from its old coordinates to its new coordinates
  #--------------------------------------------------------------------------
  def move_event(old_x,old_y,sprite)
    # Gets the event attached to the character
    event = sprite.character
    # Returns if the sprite have not change position
    return if old_x == event.x && old_y == event.y
    # Removes the sprite from its old location
    remove_sprite(old_x, old_y, sprite)
    # Adds the sprite to the new location
    add_sprite(event.x, event.y, sprite)
  end
  
  ##
  ## Low level methods, alters the datastructure directly
  ##
  
  #--------------------------------------------------------------------------
  # * Adds the given sprite to the given x and y coordinate to
  #   @character_spritemap.
  #--------------------------------------------------------------------------
  def add_sprite(x,y,sprite)
    # Checks if there a not any sprite on the given tile already
    if @character_spritemap[[x,y]].nil?
      # Adds the sprite to the spriteset as an array containing the sprite
      @character_spritemap[[x,y]] = [sprite]
    else
      # Adds the sprite to the array of sprites with the same x and y
      # coordinates.
      @character_spritemap[[x,y]] << sprite
    end
  end
    
  #--------------------------------------------------------------------------
  # * Removes the given sprite with the given x and y coordinate from
  #   @character_spritemap.
  #--------------------------------------------------------------------------
  def remove_sprite(x,y,sprite)
    # Returns if there are no sprites with the given x and y coordinate
    return  unless !@character_spritemap[[x,y]].nil? &&
                   @character_spritemap[[x,y]].include?(sprite)
    # Checks if there are more sprites with the same coordinates
    if @character_spritemap[[x,y]].size > 1
      # Removes the sprite from the array of sprites with the given coordinates
      @character_spritemap[[x,y]].delete(sprite)
    else
      # Deletes the key attached to the array since there are no sprites left.
      @character_spritemap.delete([x,y])
    end
  end
end

#------------------------------------------------------------------------------
# * End SDK Enable Test
#------------------------------------------------------------------------------
end

unless Module.constants.include?('SDK')
#============================================================================
# * Compatibility :
#
#   This will probably not be compatible with scripts extending or modifying
#   the overwritten methods. 
#   
#   The following methods has been overwritten:
#    * Game_Map.update
#    * Spriteset_Map.initialize
#    * Spriteset_Map.update
#============================================================================

#============================================================================
# ** Game_Map
#============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Update Common Events
  #--------------------------------------------------------------------------
  def update_common_events
    for common_event in @common_events.values
      common_event.update
    end
  end
  #------------------------------------------------------------------------
  # * Frame Update Overwrite
  #------------------------------------------------------------------------
  def update
    # Refresh map if necessary
    if $game_map.need_refresh
      refresh
    end
    # If scrolling
    if @scroll_rest > 0
      # Change from scroll speed to distance in map coordinates
      distance = 2 ** @scroll_speed
      # Execute scrolling
      case @scroll_direction
      when 2  # Down
        scroll_down(distance)
      when 4  # Left
        scroll_left(distance)
      when 6  # Right
        scroll_right(distance)
      when 8  # Up
        scroll_up(distance)
      end
      # Subtract distance scrolled
      @scroll_rest -= distance
    end
    # Update map event
    update_events
    # Update common event
    update_common_events
    # Manage fog scrolling
    @fog_ox -= @fog_sx / 8.0
    @fog_oy -= @fog_sy / 8.0
    # Manage change in fog color tone
    if @fog_tone_duration >= 1
      d = @fog_tone_duration
      target = @fog_tone_target
      @fog_tone.red = (@fog_tone.red * (d - 1) + target.red) / d
      @fog_tone.green = (@fog_tone.green * (d - 1) + target.green) / d
      @fog_tone.blue = (@fog_tone.blue * (d - 1) + target.blue) / d
      @fog_tone.gray = (@fog_tone.gray * (d - 1) + target.gray) / d
      @fog_tone_duration -= 1
    end
    # Manage change in fog opacity level
    if @fog_opacity_duration >= 1
      d = @fog_opacity_duration
      @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d
      @fog_opacity_duration -= 1
    end
  end
end

#============================================================================
# ** Spriteset_Map
#============================================================================
class Spriteset_Map
  #------------------------------------------------------------------------
  # * Object Initialization Overwrite
  #------------------------------------------------------------------------
  def initialize
    # Make viewports
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 200
    @viewport3.z = 5000
    # Make tilemap
    @tilemap = Tilemap.new(@viewport1)
    @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
    for i in 0..6
      autotile_name = $game_map.autotile_names[i]
      @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
    end
    @tilemap.map_data = $game_map.data
    @tilemap.priorities = $game_map.priorities
    # Make panorama plane
    @panorama = Plane.new(@viewport1)
    @panorama.z = -1000
    # Make fog plane
    @fog = Plane.new(@viewport1)
    @fog.z = 3000
    # Make character sprites
    init_characters
    # Make hero sprite
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    # Make weather
    @weather = RPG::Weather.new(@viewport1)
    # Make picture sprites
    @picture_sprites = []
    for i in 1..50
      @picture_sprites.push(Sprite_Picture.new(@viewport2,
        $game_screen.pictures[i]))
    end
    # Make timer sprite
    @timer_sprite = Sprite_Timer.new
    # Frame update
    update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # Dispose of tilemap
    @tilemap.tileset.dispose
    for i in 0..6
      @tilemap.autotiles[i].dispose
    end
    @tilemap.dispose
    # Dispose of panorama plane
    @panorama.dispose
    # Dispose of fog plane
    @fog.dispose
    # Dispose of weather
    @weather.dispose
    # Dispose of picture sprites
    for sprite in @picture_sprites
      sprite.dispose
    end
    # Dispose of character sprites
    for sprite in @character_event_sprites
      sprite.dispose unless sprite.disposed?
    end
    # Dispose of timer sprite
    @timer_sprite.dispose
    # Dispose of viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
  #------------------------------------------------------------------------
  # * Frame Update Overwrite
  #------------------------------------------------------------------------
  def update
    # If panorama is different from current one
    if @panorama_name != $game_map.panorama_name or
       @panorama_hue != $game_map.panorama_hue
      @panorama_name = $game_map.panorama_name
      @panorama_hue = $game_map.panorama_hue
      if @panorama.bitmap != nil
        @panorama.bitmap.dispose
        @panorama.bitmap = nil
      end
      if @panorama_name != ""
        @panorama.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue)
      end
      Graphics.frame_reset
    end
    # If fog is different than current fog
    if @fog_name != $game_map.fog_name or @fog_hue != $game_map.fog_hue
      @fog_name = $game_map.fog_name
      @fog_hue = $game_map.fog_hue
      if @fog.bitmap != nil
        @fog.bitmap.dispose
        @fog.bitmap = nil
      end
      if @fog_name != ""
        @fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
      end
      Graphics.frame_reset
    end
    # Update tilemap
    @tilemap.ox = $game_map.display_x / 4
    @tilemap.oy = $game_map.display_y / 4
    @tilemap.update
    # Update panorama plane
    @panorama.ox = $game_map.display_x / 8
    @panorama.oy = $game_map.display_y / 8
    # Update fog plane
    @fog.zoom_x = $game_map.fog_zoom / 100.0
    @fog.zoom_y = $game_map.fog_zoom / 100.0
    @fog.opacity = $game_map.fog_opacity
    @fog.blend_type = $game_map.fog_blend_type
    @fog.ox = $game_map.display_x / 4 + $game_map.fog_ox
    @fog.oy = $game_map.display_y / 4 + $game_map.fog_oy
    @fog.tone = $game_map.fog_tone
    # Update character sprites
    update_character_sprites
    # Update weather graphic
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.ox = $game_map.display_x / 4
    @weather.oy = $game_map.display_y / 4
    @weather.update
    # Update picture sprites
    for sprite in @picture_sprites
      sprite.update
    end
    # Update timer sprite
    @timer_sprite.update
    # Set screen color tone and shake position
    @viewport1.tone = $game_screen.tone
    @viewport1.ox = $game_screen.shake
    # Set screen flash color
    @viewport3.color = $game_screen.flash_color
    # Update viewports
    @viewport1.update
    @viewport3.update
  end
end
end