#==============================================================================
# ** Message Shutter Animation
#------------------------------------------------------------------------------
#
#  This script was made by Myownfriend, its only function is to add a shutter 
#  effect to message windows as they open and close. 
#
#  If your experiencing any compatibility problems with other scripts that make
#  small modifications to the message window, try placing this script directly 
#  under the original Window_Message class. If you experience any other problems
#  with this script, please go to http://www.rmphantasy.net/
#
#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  This message window is used to display text.
#==============================================================================


class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------- 
  alias mof_shutter_initialize :initialize
  def initialize
    mof_shutter_initialize
    @opening = false
    @closing = false
    @full_height = self.height
    @full_y = self.y
    @y_difference = @full_height/2
    @fade_in = false
    @fade_out = false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    open
    if @input_number_window != nil
      @input_number_window.update
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        $game_variables[$game_temp.num_input_variable_id] =
          @input_number_window.number
        $game_map.need_refresh = true
        @input_number_window.dispose
        @input_number_window = nil
        terminate_message
      end
      return
    end
    # If message is being displayed
    if @contents_showing
      # If choice isn't being displayed, show pause sign
      if $game_temp.choice_max == 0
        self.pause = true
      end
      # Cancel
      if Input.trigger?(Input::B)
        if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
          $game_system.se_play($data_system.cancel_se)
          $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
          terminate_message
        end
      end
      # Confirm
      if Input.trigger?(Input::C)
        if $game_temp.choice_max > 0
          $game_system.se_play($data_system.decision_se)
          $game_temp.choice_proc.call(self.index)
        end
        terminate_message
      end
      return
    end
    if @closing == false && $game_temp.message_text != nil
      @contents_showing = true
      $game_temp.message_window_showing = true
      reset_window
      refresh
      Graphics.frame_reset
      self.visible = true
      self.contents_opacity = 0
      self.y = @full_y + @y_difference
      self.height = 0
      if @input_number_window != nil
        @input_number_window.contents_opacity = 0
      end
      @opening = true
      return
    end
    close
  end
  #--------------------------------------------------------------------------
  # * Open Window Animation
  #--------------------------------------------------------------------------
  def open
    if @opening
      self.contents_opacity = 0
      self.height += @full_height/5
      self.y -= @y_difference/5
      if @input_number_window != nil
        @input_number_window.contents_opacity += 24
      end
      if self.height == @full_height 
        @opening = false
        self.contents_opacity = 255
      end
      @contents_showing = true
      return
    end
  end 
  #--------------------------------------------------------------------------
  # * Close Window Animation
  #--------------------------------------------------------------------------
  def close
    if self.visible
      @closing = true
      self.contents_opacity = 255
      self.height -= @full_height/5
      self.y += @y_difference/5
      if self.height == 0
        self.visible = false
        @wait_count = 5
        @closing = false
        $game_temp.message_window_showing = false
      end
      @contents_showing = false
      return
    end
  end
#-------------------------------------------------------------------------------
end