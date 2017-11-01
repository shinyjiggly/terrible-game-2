class Interpreter
  #--------------------------------------------------------------------------
  # * Show Text
  #--------------------------------------------------------------------------
  alias mp_face_command_101 command_101
  def command_101
    result = mp_face_command_101
    unless $game_temp.last_face_id == 0
      window = @balloon_windows.last
      picture = $game_screen.pictures[$game_temp.last_face_id]
      if $game_switches[SW_ENABLE_BALLOONS]
        x = window.x - WIDTH_FRAME - 2 * PADDING_FRAME + DISPLACE_X_FRAME
        if x < 0
          x = window.x + window.width - DISPLACE_X_FRAME
        end
        picture.displace_x = x
        picture.displace_y = window.y + (window.height - WIDTH_FRAME) / 2 +
          DISPLACE_Y_FRAME
      else
        picture.displace_x = $scene.message_window.x + DISPLACE_X_FRAME
        picture.displace_y = $scene.message_window.y - WIDTH_FRAME -
          PADDING_FRAME + DISPLACE_Y_FRAME
      end
    end
    return result
  end
end
