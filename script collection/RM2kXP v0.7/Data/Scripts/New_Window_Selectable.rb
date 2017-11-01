#==============================================================================
# ** Window_Selectable
#==============================================================================

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    # If cursor is movable
    if self.active and @item_max > 0 and @index >= 0
      # If pressing down on the directional buttons
      if Input.repeat?(Input::DOWN)
        # Works similar but without the item_max comprovation
        $game_system.se_play($data_system.cursor_se)
        # Move cursor down
        @index = (@index + @column_max) % @item_max
      end
      # If pressing up on the directional buttons
      if Input.repeat?(Input::UP)
        # Works similar but without the item = 0 comprovation
        $game_system.se_play($data_system.cursor_se)
        # Move cursor up
        @index = (@index - @column_max + @item_max) % @item_max
      end
      # If pressing right on the directional buttons
      if Input.repeat?(Input::RIGHT)
        # Works as always
        if @column_max >= 2 and @index < @item_max - 1
          $game_system.se_play($data_system.cursor_se)
          # Move cursor right
          @index += 1
        end
      end
      # If pressing left on the directional buttons
      if Input.repeat?(Input::LEFT)
        # Works as always
        if @column_max >= 2 and @index > 0
          $game_system.se_play($data_system.cursor_se)
          # Move cursor left
          @index -= 1
        end
      end
      # If R button was pressed
      if Input.repeat?(Input::R)
        # Works as always
        if self.top_row + (self.page_row_max - 1) < (self.row_max - 1)
          $game_system.se_play($data_system.cursor_se)
          @index = [@index + self.page_item_max, @item_max - 1].min
          self.top_row += self.page_row_max
        end
      end
      # If L button was pressed
      if Input.repeat?(Input::L)
        # Works as always
        if self.top_row > 0
          $game_system.se_play($data_system.cursor_se)
          @index = [@index - self.page_item_max, 0].max
          self.top_row -= self.page_row_max
        end
      end
    end
    # Update help text (update_help is defined by the subclasses)
    if self.active and @help_window != nil
      update_help
    end
    # Update cursor rectangle
    update_cursor_rect
  end
end