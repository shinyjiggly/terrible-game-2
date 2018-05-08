#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character
  attr_accessor :move_speed
  
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
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(DOWN, [turn_enabled]))
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
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(LEFT, [turn_enabled]))
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
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(RIGHT, [turn_enabled]))
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
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(UP, [turn_enabled]))
    # If impassable
    else
      # Determine if touch event is triggered
      check_event_trigger_touch(@x, @y-1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Left
  #--------------------------------------------------------------------------
  def move_lower_left
    # If no direction fix
    unless @direction_fix
      # Face down is facing right or up
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
    end
    # When a down to left or a left to down course is passable
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
      # Update coordinates
      @x -= 1
      @y += 1
      # Increase steps
      increase_steps
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(DOWN_LEFT, [turn_enabled]))
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Right
  #--------------------------------------------------------------------------
  def move_lower_right
    # If no direction fix
    unless @direction_fix
      # Face right if facing left, and face down if facing up
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
    end
    # When a down to right or a right to down course is passable
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
      # Update coordinates
      @x += 1
      @y += 1
      # Increase steps
      increase_steps
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(DOWN_RIGHT, []))
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Left
  #--------------------------------------------------------------------------
  def move_upper_left
    # If no direction fix
    unless @direction_fix
      # Face left if facing right, and face up if facing down
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
    end
    # When an up to left or a left to up course is passable
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
      # Update coordinates
      @x -= 1
      @y -= 1
      # Increase steps
      increase_steps
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(UP_LEFT, [turn_enabled]))
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Right
  #--------------------------------------------------------------------------
  def move_upper_right
    # If no direction fix
    unless @direction_fix
      # Face right if facing left, and face up if facing down
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
    end
    # When an up to right or a right to up course is passable
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
      # Update coordinates
      @x += 1
      @y -= 1
      # Increase steps
      increase_steps
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(UP_RIGHT, [turn_enabled]))
    end
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
      # add to train actors movement
      $game_train.add_move(Game_MoveCommand.new(JUMP, [x_plus, y_plus]))
    end
  end
  
  def move_speed=(speed)
    @move_speed = speed
    for actor in $game_train.actors
      actor.move_speed = speed
    end
  end
end
