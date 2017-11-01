# ==============================================================================
# DIALOG BOXES
# ------------------------------------------------------------------------------
# Makes dialog boxes to give warning messages and confirm choices.
# ==============================================================================

module RPG
  def self.warn(str)
    $game_system.se_play($data_system.decision_se)
    Graphics.freeze
    message = []
    str.break_into_lines(65) do |s| message << s end
    height = 32 * (message.size + 2)
    window = Window_Base.new(32, (480 - height) / 2, 576, height)
    window.contents = Bitmap.new(window.width - 32, window.height - 32)
    for i in 0...message.size
      window.contents.draw_text(0, i * 32, window.width - 32, 32, message[i], 1)
    end
    window.contents.draw_text(0, window.contents.height - 32, 544, 32, "OK", 1)
    window.cursor_rect.set(208, window.contents.height - 32, 128, 32)
    window.active = true
    window.z = 5000
    Graphics.transition
    loop do
      Input.update
      Graphics.update
      window.update
      if Input.trigger?(Input::C) or Input.trigger?(Input::B)
        $game_system.se_play($data_system.cancel_se)
        break
      end
    end
    Graphics.freeze
    window.dispose
    Graphics.transition
    return
  end
  
  def self.confirm(str)
    $game_system.se_play($data_system.buzzer_se)
    Graphics.freeze
    message = []
    str.break_into_lines(65) do |s| message << s end
    height = 32 * (message.size + 2)
    window = Window_Base.new(32, (480 - height) / 2, 576, height)
    window.contents = Bitmap.new(window.width - 32, window.height - 32)
    for i in 0...message.size
      window.contents.draw_text(0, i * 32, window.width - 32, 32, message[i], 1)
    end
    window.contents.draw_text(0, window.contents.height - 32, 272, 32, "OK", 1)
    window.contents.draw_text(272, window.contents.height - 32, 272, 32, "Cancel", 1)
    window.cursor_rect.set(72, window.contents.height - 32, 128, 32)
    window.active = true
    window.z = 5000
    Graphics.transition
    index = 0
    result = nil
    while result.nil?
      Input.update
      Graphics.update
      window.update
      if Input.repeat?(Input::LEFT) or Input.repeat?(Input::RIGHT)
        $game_system.se_play($data_system.cursor_se)
        index += 1
        index %= 2
        window.cursor_rect.set(72 + 272 * index, window.contents.height - 32, 128, 32)
      end
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        result = index == 0
      end
      if Input.trigger?(Input::B)
        $game_system.se_play($data_system.cancel_se)
        result = false
      end
    end
    Graphics.freeze
    window.dispose
    Graphics.transition
    return result
  end
	
	def self.message(str, &block)
    message = []
    str.break_into_lines(65) do |s| message << s end
    height = 32 * (message.size + 1)
    window = Window_Base.new(32, (480 - height) / 2, 576, height)
    window.contents = Bitmap.new(window.width - 32, window.height - 32)
    for i in 0...message.size
      window.contents.draw_text(0, i * 32, window.width - 32, 32, message[i], 1)
    end
    window.z = 5000
		block.call
		window.dispose
    return
	end
end

module Graphics
	class << self
		alias mp_dialog_boxes_update update
		def update
			unless @message_window.nil?
				@message_window.dispose
				@message_window = nil
			end
			mp_dialog_boxes_update
		end
		
		def set_message_window(window)
			@message_window = window
			mp_dialog_boxes_update
		end
	end
end