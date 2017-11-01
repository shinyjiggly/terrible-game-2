#==============================================================================
#
#      HERETIC'S ANIMATION SPEED
#      Version 1.0
#      Sunday, January 12th, 2014
#
#==============================================================================
#
#   ***  Overview  ***
#
#   This script allows you to set a different Animation Speed that is
#   different than a Character's Movement Speed.  Normally, they were tied
#   together.  This script allows each to be independant.  Thus, a Fairy can
#   flap her wings quickly while still moving about slowly.
#
#
#
#   ***  Instructions  ***
#
#   Place just below the SDK if installed, or below Scene_Debug if no SDK.
#   It should be as close to the Default Scripts (ending with Scene_Debug)
#   as you can get it.  Place ABOVE my Caterpillar if you use it.  It is
#   compatible with my other scripts, but does not require Caterpillar.
#
#   WARNING: If any Scripts OVERWRITE Game_Character Update, this script 
#            Will NOT Work!  See Troubleshooting.  Its not too difficult
#            to fix
#
#
#
#   ***  Usage  ***
#
#   This is PER EVENT PAGE
#
#   Put "anime_speed = X" on the First Line of a Comment on that Page in
#   the First Ten Lines of Commands on that Event Page.
#
#   Set the Animation Speed of ANY Character by putting @anime_speed = X in
#   a Move Route for that Character (Player or Event NPC).
#
#   Set the Animation Speed externally by running a Script from anywhere:
#   -  $game_map.events[event_id].anime_speed = X
#   -  $game_player.anime_speed = X
#
#   X must be a Number.  The number works the same as Move Speed.  So
#   a Low @anime_speed will cause a Slow Animation, but an Anime Speed of
#   6 will cause the character to have a very Fast Animation.
#
#   NOTE: Events will RESET their Animation Speed on any Page Changes.
#         PLAYER WILL NOT RESET THE ANIMATION SPEED
#
#   To CLEAR an Animation Speed, set the anime_speed to NIL
#   - $game_map.events[event_id].anime_speed = nil
#   - $game_player.anime_speed = nil
#
#
#
#
#
#   ***  Troubleshooting and Compatability  ***
#
#   I had to overwrite the existing definition of UPDATE so there may be some
#   compatability issues if any other script also overwrites UPDATE.
#
#   Any script that Aliases Update should work just fine.  But this script will
#   need to be ABOVE all of them.  If you use my Caterpillar, this script should
#   be ABOVE the Caterpillar.
#
#   Fortunately, this is actually an EASY SCRIPT.  The only change that I made
#   to Update was to add an IF ELSE statement.  If a Character has an Anime
#   Speed set, it will update appropriately.  If it doesn't, then the default
#   method of Updating Animations is used.  You can try modifying the Update
#   method of the Conflicting Script and just put in that relatively simple
#   to use IF ELSE statement.  Everything else can remain the same in your
#   additional Scripts.
#
#==============================================================================


#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================
class Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------  
  attr_accessor        :anime_speed   # Overrides Move Speed for Animations
  #If SDK
  if Object.const_defined?(:SDK)
    # Prevent F12 Crash
    unless self.method_defined?('sdk_heretic_anim_speed_update_animation')
      alias sdk_heretic_anim_speed_update_animation update_animation
    end
    #--------------------------------------------------------------------------
    # * Update Animation - SDK
    #--------------------------------------------------------------------------
    def update_animation
      # If Anime Speed has been set for Event
      if @anime_speed and @anime_speed.is_a?(Numeric)
        # Update Animations Based on Anime Speed instead of Move Speed
        anime_speed_update
      else
        # Call Original or Other Aliases
        sdk_heretic_anim_speed_update_animation      
      end
    end
  # If SDK not defined
  else
    #--------------------------------------------------------------------------
    # * Frame Update - Game Character (Non SDK) - Replacement
    #
    #   Because this replaces the Default update method for Game_Character, it
    #   needs to be above all other Scripts.  
    #--------------------------------------------------------------------------
    def update
      # Branch with jumping, moving, and stopping
      if jumping?
        update_jump
      elsif moving?
        update_move
      else
        update_stop
      end
      
      # This is really the only thing that I changed in Update.
      
      # If Anime Speed has been set for Event
      if @anime_speed and @anime_speed.is_a?(Numeric)
        # Update Animations Based on Anime Speed instead of Move Speed
        anime_speed_update
      # Anime Speed Not Set, use Default Method
      else
        # This is the section that controls a Character's Animations.  It
        # should be present in some form in ALL other replacements of the
        # update method.  If you are attempting to Edit another script, this
        # part is what belongs in the Else Statement.
        
        # If animation count exceeds maximum value
        # * Maximum value is move speed * 1 taken from basic value 18
        if @anime_count > 18 - @move_speed * 2
          # If stop animation is OFF when stopping
          if not @step_anime and @stop_count > 0
            # Return to original pattern
            @pattern = @original_pattern
          # If stop animation is ON when moving
          else
            # Update pattern
            @pattern = (@pattern + 1) % 4
          end
          # Clear animation count
          @anime_count = 0
        end
      end
      
      # The code below here is Default and doesnt need to be changed.
      
      # If waiting
      if @wait_count > 0
        # Reduce wait count
        @wait_count -= 1
        return
      end
      # If move route is forced
      if @move_route_forcing
        # Custom move
        move_type_custom
        return
      end
      # When waiting for event execution or locked
      if @starting or lock?
        # Not moving by self
        return
      end
      # If stop count exceeds a certain value (computed from move frequency)
      if @stop_count > (40 - @move_frequency * 2) * (6 - @move_frequency)
        # Branch by move type
        case @move_type
        when 1  # Random
          move_type_random
        when 2  # Approach
          move_type_toward_player
        when 3  # Custom
          move_type_custom
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Animation Speed Update for Game Character
  #
  #   * Used by both SDK and Non SDK
  #
  #   * This is called when @anime_speed for a Character is set.  It uses
  #     the Animation Speed over the Move Speed so that Animation Speed is
  #     independant of a Character's Move Speed
  #--------------------------------------------------------------------------
  def anime_speed_update
    # If animation count exceeds maximum value
    # * Maximum value is move speed * 1 taken from basic value 18
    #if @anime_count > 18 - @move_speed * 2 # Original Code
    if @anime_count > 18 - @anime_speed * 2
      # If stop animation is OFF when stopping
      if not @step_anime and @stop_count > 0
        # Return to original pattern
        @pattern = @original_pattern
      # If stop animation is ON when moving
      else
        # Update pattern
        @pattern = (@pattern + 1) % 4
      end
      # Clear animation count
      @anime_count = 0
    end    
  end  
end # End Game Character Class

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This section handles checking the Comments for "anime_speed = X" when
#  an Event is Refreshed and the Page is changed.
#  
#  If another script redefines Refresh for Game Event, it will cause the
#  page change detection to no longer work.  There is a way to fix this.
#
#  Leave this script ABOVE the conflicting script.  Then COPY this section
#  and place it in a New Script BELOW the conflicting script.  The alias
#  here will add the functionality of page changes to the other scripts
#  definition of refresh.  Just copy the Game_Event stuff, but leave
#  the entire Game_Character class alone.
#
#==============================================================================
class Game_Event < Game_Character
  alias animation_speed_event_refresh refresh
  def refresh
    # For Checking Page Changes
    anime_speed_page = @page
    # Call Original or Other Aliases
    animation_speed_event_refresh
    # If Event Not Erased and Page has changed
    unless @erased
      # If Page is not Nil and a Page Change is occuring
      if not @page.nil? and @page != anime_speed_page
        # Reset Anime Speed on Page Change
        @anime_speed = nil
        # For Performance on Refresh
        list_count = 0
        # For each Event Command as 'command' in the Page List of Event Commands
        @page.list.each {|command|
          # If Command Code is a Comment (Codes 108 and 408, 408 is Next Line)
          if command.code == 108
            # For each Command Paramater (What holds Values of Comments)
            command.parameters.each {|p|
              # Capture this Event Page's Animation Speed in the Comments
              p.gsub(/^anime_speed *= *([\d\.]+ *)/i){$1}
              # If Capture Group Not Empty
              if not $1.nil?
                # Change Anime Speed from Nil to Value in the Comment
                @anime_speed = (not $1.nil?) ? $1.to_f : nil
                # Break both Loops for this Event (performance)
                break(2)
              end
              } # End |p| loop for (Command List Parameters)
          end
        # Increment Internal Counter    
        list_count += 1
        # If too many Items in List (performance)
        if list_count > 10
          # Stop Iterating after 10 Event Commands
          break
        end            
        }  # End |command| loop (Event Command List)
      end
    end
  end
end