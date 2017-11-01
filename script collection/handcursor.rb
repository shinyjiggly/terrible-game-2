#===============================================================================
# Hand Cursor
# Author game_guy
# Version 1.0
#-------------------------------------------------------------------------------
# Intro:
# Tired of the boring, rectangle cursor you use for your window selection?
# This nifty script makes it so it uses an actual cursor like a hand or an
# arrow and displays it next to the choice.
#
# Features:
# Use Windows With or Without Hand Cursors
#
# Instructions:
# To use windowskins with cursor, place this in the windowskins filename.
# $cur then the system will detect it and use a hand cursor instead of a
# rectangle cursor. This way if you want you can still use normal rectangle
# cursors as well.
# Example: 001-Blue01$cur
#
# You can also change the X and Y offset, go down to begin config, and change
# the numbers.
# X_OFFSET ~ X coordinate for the cursor
# Y_OFFSET ~ Y coordinate for the cursor
# Its recommended to leave it as is for its at a pretty good setting.
# 
# Compatability:
# Not tested with SDK. 
# Should not conflict with anything.
#
# Credits:
# game_guy ~ For making it
# Chaze007 ~ For windowskin in screenshots
# Some RPG's ~ For having a hand cursor
#===============================================================================
module GameGuy
  X_OFFSET = -16
  Y_OFFSET = 0
end
class Window_Base
  def check_hand_cursor
    text = @windowskin_name
    text.gsub!(/\$cur/) do
      return true
    end
    return false
  end
end
class Window_Selectable < Window_Base
  alias gg_update_cursor_rect_lat update_cursor_rect
  def update_cursor_rect
    if !check_hand_cursor
      return gg_update_cursor_rect_lat 
    end
    if @index < 0
      self.cursor_rect.empty
      return
    end
    row = @index / @column_max
    if row < self.top_row
      self.top_row = row
    end
    if row > self.top_row + (self.page_row_max - 1)
      self.top_row = row - (self.page_row_max - 1)
    end
    cursor_width = self.width / @column_max - 32
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 32 - self.oy
    self.cursor_rect.set(x + GameGuy::X_OFFSET, y + GameGuy::Y_OFFSET, 32, 32)
  end
end
 
class Window_MenuStatus < Window_Selectable
  alias gg_update_cursor_rect_status_lat update_cursor_rect
  def update_cursor_rect
    if !check_hand_cursor
      return gg_update_cursor_rect_status_lat
    end
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0 + GameGuy::X_OFFSET, 
        @index * 116 + GameGuy::Y_OFFSET, 32, 32)
    end
  end
end
 
class Window_Target < Window_Selectable
  alias gg_update_cursor_rect_target_lat update_cursor_rect
  def update_cursor_rect
    if !check_hand_cursor
      return gg_update_cursor_rect_target_lat
    end
    if @index <= -2
      self.cursor_rect.set(0, (@index + 10) * 116, 32, 32)
    elsif @index == -1
      self.cursor_rect.set(0, 0, 32, 32)
    else
      self.cursor_rect.set(0 + GameGuy::X_OFFSET, 
        @index * 116 + GameGuy::Y_OFFSET, 32, 32)
    end
  end
end
class Window_Message < Window_Selectable
  alias gg_update_cursor_rect_message_lat update_cursor_rect
  def update_cursor_rect
    if !check_hand_cursor
      return gg_update_cursor_rect_message_lat
    end
    if @index >= 0
      n = $game_temp.choice_start + @index
      self.cursor_rect.set(8 + GameGuy::X_OFFSET, n * 32, @cursor_width, 32)
    else
      self.cursor_rect.empty
    end
  end
end
class Window_PartyCommand < Window_Selectable
  alias gg_update_cursor_rect_partycmd_lat update_cursor_rect
  def update_cursor_rect
    if !check_hand_cursor
      return gg_update_cursor_rect_partycmd_lat
    end
    self.cursor_rect.set(160 + index * 160 + GameGuy::X_OFFSET, 
      0 + GameGuy::Y_OFFSET, 32, 32)
  end
end
class Window_SaveFile < Window_Base
  alias gg_update_cursor_rect_savefile_lat update_cursor_rect
  def update_cursor_rect
    if !check_hand_cursor
      return gg_update_cursor_rect_savefile_lat
    end
    if @selected
      self.cursor_rect.set(0 + GameGuy::X_OFFSET, 0 + GameGuy::Y_OFFSET, 32, 32)
    else
      self.cursor_rect.empty
    end
  end
end