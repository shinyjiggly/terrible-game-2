#==============================================================================
# ** Game_Player (Last Edited by: SWORDOFHOPE on 13/02/2007)
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Passable Determinants
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,1,2,3,4,7,6,8,9)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #     (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    # Get new coordinates
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : d == 1 ? -1 : d == 3 ? 1 :
    d == 7 ? -1 : d == 9 ? 1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : d == 1 ? 1 : d == 3 ? 1 :
    d == 7 ? 1 : d == 9 ? -1 : 0)
    # If coordinates are outside of map
    unless $game_map.valid?(new_x, new_y)
      # Impassable
      return false
    end
    # If debug mode is ON and ctrl key was pressed
    if $DEBUG and Input.press?(Input::CTRL)
      # Passable
      return true
    end
    super
  end

  #--------------------------------------------------------------------------
  # * Frame Update (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def update
    # Remember whether or not moving in local variables
    last_moving = moving?
    # If moving, event running, move route forcing, and message window
    # display are all not occurring
    unless moving? or $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing
      # Move player in the direction the directional button is being pressed
      case Input.dir8
      when 1
        move_lower_left(false)
      when 2
        move_down(false)
      when 3
        move_lower_right(false)
      when 4
        move_left(false)
      when 6
        move_right(false)
      when 7
        move_upper_left(false)
      when 8
        move_up(false)
      when 9
        move_upper_right(false)
      end
    end
    # Remember coordinates in local variables
    last_real_x = @real_x
    last_real_y = @real_y
    super
    # If character moves down and is positioned lower than the center
    # of the screen
    if @real_y > last_real_y and @real_y - $game_map.display_y > CENTER_Y
      # Scroll map down
      $game_map.scroll_down(@real_y - last_real_y)
    end
    # If character moves left and is positioned more let on-screen than
    # center
    if @real_x < last_real_x and @real_x - $game_map.display_x < CENTER_X
      # Scroll map left
      $game_map.scroll_left(last_real_x - @real_x)
    end
    # If character moves right and is positioned more right on-screen than
    # center
    if @real_x > last_real_x and @real_x - $game_map.display_x > CENTER_X
      # Scroll map right
      $game_map.scroll_right(@real_x - last_real_x)
    end
    # If character moves up and is positioned higher than the center
    # of the screen
    if @real_y < last_real_y and @real_y - $game_map.display_y < CENTER_Y
      # Scroll map up
      $game_map.scroll_up(last_real_y - @real_y)
    end
    # If not moving
    unless moving?
      # If player was moving last time
      if last_moving
        # Event determinant is via touch of same position event
        result = check_event_trigger_here([1,2])
        # If event which started does not exist
        if result == false
          # Disregard if debug mode is ON and ctrl key was pressed
          unless $DEBUG and Input.press?(Input::CTRL)
            # Encounter countdown
            if @encounter_count > 0
              @encounter_count -= 1
            end
          end
        end
      end
      # If C button was pressed
      if Input.trigger?(Input::C)
        # Same position and front event determinant
        check_event_trigger_here([0])
        check_event_trigger_there([0,1,2])
      end
    end
  end
end

#==============================================================================
# ** Game_Character (part 3) (Last Edited by: SWORDOFHOPE on 13/02/2007)
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # * Move Down
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_down(turn_enabled = true)
    # Turn down
    if turn_enabled
      turn_down
    end
    # If passable
    if passable?(@x, @y, 2)
      # Turn down
      turn_down
      # Update coordinates
      @y += 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x, @y+1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Left
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_left(turn_enabled = true)
    # Turn left
    if turn_enabled
      turn_left
    end
    # If passable
    if passable?(@x, @y, 4)
      # Turn left
      turn_left
      # Update coordinates
      @x -= 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x-1, @y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Right
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_right(turn_enabled = true)
    # Turn right
    if turn_enabled
      turn_right
    end
    # If passable
    if passable?(@x, @y, 6)
      # Turn right
      turn_right
      # Update coordinates
      @x += 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x+1, @y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move up
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_up(turn_enabled = true)
    # Turn up
    if turn_enabled
      turn_up
    end
    # If passable
    if passable?(@x, @y, 8)
      # Turn up
      turn_up
      # Update coordinates
      @y -= 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x, @y-1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Left (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_lower_left(turn_enabled = true)
    #Turn lower left
     if turn_enabled
       turn_lower_left
     end
    # When a down to left or a left to down course is passable
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
      # Turn lower_left
      turn_lower_left
      # Update coordinates
      @x -= 1
      @y += 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x-1, @y+1)  
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Right (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_lower_right(turn_enabled = true)
    #Turn lower_right
     if turn_enabled
       turn_lower_right
     end
    # When a down to right or a right to down course is passable
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
       # Turn lower_right
       turn_lower_right
      # Update coordinates
      @x += 1
      @y += 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x+1, @y+1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Left (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_upper_left(turn_enabled = true)
    #Turn upper_left
     if turn_enabled
       turn_upper_left
     end
    # When an up to left or a left to up course is passable
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
       # Turn upper_left
       turn_upper_left
      # Update coordinates
      @x -= 1
      @y -= 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x-1, @y-1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Right (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_upper_right(turn_enabled = true)
    #Turn upper_right
     if turn_enabled
       #turn_upper_right
       turn_upper_right
     end
    # When an up to right or a right to up course is passable
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
       # Turn upper_right
       turn_upper_right
      # Update coordinates
      @x += 1
      @y -= 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x+1, @y-1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move at Random (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_random
    case rand(8)
    when 0
      move_lower_left(false)
    when 1
      move_down(false)
    when 2
      move_lower_right(false)
    when 3
      move_left(false)
    when 4
      move_upper_left(false)
    when 5
      move_right(false)
    when 6
      move_upper_right(false)
    when 7
      move_up(false)
    end
  end
  #--------------------------------------------------------------------------
  # * Move toward Player
  #--------------------------------------------------------------------------
  def move_toward_player
    # Get difference in player coordinates
    sx = @x - $game_player.x
    sy = @y - $game_player.y
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
    # Get difference in player coordinates
    sx = @x - $game_player.x
    sy = @y - $game_player.y
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
  # * 1 Step Forward (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_forward
    case @direction
    when 1
      move_lower_left(false)
    when 2
      move_down(false)
    when 3
      move_lower_right(false)
    when 4
      move_left(false)
    when 6
      move_right(false)
    when 7
      move_upper_left(false)
    when 8
      move_up(false)
    when 9
      move_upper_right(false)
    end
  end
  #--------------------------------------------------------------------------
  # * 1 Step Backward (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def move_backward
    # Remember direction fix situation
    last_direction_fix = @direction_fix
    # Force directino fix
    @direction_fix = true
    # Branch by direction
    case @direction
    when 1  # Lower Left
      move_upper_right(false)
    when 2  # Down
      move_up(false)
    when 3  # Lower Right
      move_upper_left(false)
    when 4  # Left
      move_right(false)
    when 6  # Right
      move_left(false)
    when 7  # Upper Left
      move_lower_right(false)
    when 8  # Up
      move_down(false)
    when 9  # Upper Right
      move_lower_left
    end
    # Return direction fix situation back to normal
    @direction_fix = last_direction_fix
  end
  #--------------------------------------------------------------------------
  # * Jump
  #     x_plus : x-coordinate plus value
  #     y_plus : y-coordinate plus value
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    # If plus value is not (0,0)
    if x_plus != 0 or y_plus != 0
      # If horizontal distnace is longer
      if x_plus.abs > y_plus.abs
        # Change direction to left or right
        x_plus < 0 ? turn_left : turn_right
      # If vertical distance is longer, or equal
      else
        # Change direction to up or down
        y_plus < 0 ? turn_up : turn_down
      end
    end
    # Calculate new coordinates
    new_x = @x + x_plus
    new_y = @y + y_plus
    # If plus value is (0,0) or jump destination is passable
    if (x_plus == 0 and y_plus == 0) or passable?(new_x, new_y, 0)
      # Straighten position
      straighten
      # Update coordinates
      @x = new_x
      @y = new_y
      # Calculate distance
      distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      # Set jump count
      @jump_peak = 10 + distance - @move_speed
      @jump_count = @jump_peak * 2
      # Clear stop count
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Lower Left (Created by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_lower_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Down
  #--------------------------------------------------------------------------
  def turn_down
    unless @direction_fix
      @direction = 2
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Lower Right (Created by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_lower_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Left
  #--------------------------------------------------------------------------
  def turn_left
    unless @direction_fix
      @direction = 4
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Right
  #--------------------------------------------------------------------------
  def turn_right
    unless @direction_fix
      @direction = 6
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Upper Left (Created by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_upper_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Up
  #--------------------------------------------------------------------------
  def turn_up
    unless @direction_fix
      @direction = 8
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Upper Right (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_upper_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Right (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_right_90
    case @direction
    when 1
      turn_lower_right
    when 2
      turn_left
    when 3
      turn_upper_right
    when 4
      turn_up
    when 6
      turn_down
    when 7
      turn_lower_left
    when 8
      turn_right
    when 9
      turn_upper_left
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Left (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_left_90
    case @direction
    when 1
      turn_upper_left
    when 2
      turn_right
    when 3
      turn_lower_left
    when 4
      turn_down
    when 6
      turn_up
    when 7
      turn_upper_right
    when 8
      turn_left
    when 9
      turn_lower_right
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 180° (Last Edited by: SWORDOFHOPE on 13/02/2007)
  #--------------------------------------------------------------------------
  def turn_180
    case @direction
    when 1
      turn_upper_right
    when 2
      turn_up
    when 3
      turn_upper_left
    when 4
      turn_right
    when 6
      turn_left
    when 7
      turn_lower_right
    when 8
      turn_down
    when 9
      turn_lower_left
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Right or Left
  #--------------------------------------------------------------------------
  def turn_right_or_left_90
    if rand(2) == 0
      turn_right_90
    else
      turn_left_90
    end
  end
  #--------------------------------------------------------------------------
  # * Turn at Random
  #--------------------------------------------------------------------------
  def turn_random
    case rand(8)
    when 0
      turn_up
    when 1
      turn_right
    when 2
      turn_left
    when 3
      turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Towards Player
  #--------------------------------------------------------------------------
  def turn_toward_player
    # Get difference in player coordinates
    sx = @x - $game_player.x
    sy = @y - $game_player.y
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
  # * Turn Away from Player
  #--------------------------------------------------------------------------
  def turn_away_from_player
    # Get difference in player coordinates
    sx = @x - $game_player.x
    sy = @y - $game_player.y
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
end

