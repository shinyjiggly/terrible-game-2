#==============================================================================
# MESSAGE EXPRESSION EVALUATOR
#------------------------------------------------------------------------------
#  This edit allows to display the result of Ruby expressions written directly
# in Show Message event commands using \f[<expression>].
#------------------------------------------------------------------------------
#  > EXAMPLE: "Three plus two is \f[3+2]." will be displayed as "Three plus
# two is 5."
#------------------------------------------------------------------------------
#  Most likely incompatible with any custom message systems. Simply remove this
# section if you have no use for it, or copy the outlined command to your
# custom Window_Message class.
#==============================================================================

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = normal_color
    x = y = 0
    @cursor_width = 0
    # Indent if choice
    if $game_temp.choice_start == 0
      x = 8
    end
    # If waiting for a message to be displayed
    if $game_temp.message_text != nil
      text = $game_temp.message_text
      # Control text processing
      begin
        last_text = text.clone
        text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
      end until text == last_text
      text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
#--------------------------------------------------------------------------
      text.gsub!(/\\[Ff]\[([ \w\=\+\-\*\/\$\(\)\!\.\,\'\:\%\@]+)\]/) { eval $1 }
#--------------------------------------------------------------------------
      # Change "\\\\" to "\000" for convenience
      text.gsub!(/\\\\/) { "\000" }
      # Change "\\C" to "\001" and "\\G" to "\002"
      text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
      text.gsub!(/\\[Gg]/) { "\002" }
      # Get 1 text character in c (loop until unable to get text)
      while ((c = text.slice!(/./m)) != nil)
        # If \\
        if c == "\000"
          # Return to original text
          c = "\\"
        end
        # If \C[n]
        if c == "\001"
          # Change text color
          text.sub!(/\[([0-9]+)\]/, "")
          color = $1.to_i
          if color >= 0 and color <= 7
            self.contents.font.color = text_color(color)
          end
          # go to next text
          next
        end
        # If \G
        if c == "\002"
          # Make gold window
          if @gold_window == nil
            @gold_window = Window_Gold.new
            @gold_window.x = 560 - @gold_window.width
            if $game_temp.in_battle
              @gold_window.y = 192
            else
              @gold_window.y = self.y >= 128 ? 32 : 384
            end
            @gold_window.opacity = self.opacity
            @gold_window.back_opacity = self.back_opacity
          end
          # go to next text
          next
        end
        # If new line text
        if c == "\n"
          # Update cursor width if choice
          if y >= $game_temp.choice_start
            @cursor_width = [@cursor_width, x].max
          end
          # Add 1 to y
          y += 1
          x = 0
          # Indent if choice
          if y >= $game_temp.choice_start
            x = 8
          end
          # go to next text
          next
        end
        # Draw text
        self.contents.draw_text(4 + x, 32 * y, 40, 32, c)
        # Add x to drawn text width
        x += self.contents.text_size(c).width
      end
    end
    # If choice
    if $game_temp.choice_max > 0
      @item_max = $game_temp.choice_max
      self.active = true
      self.index = 0
    end
    # If number input
    if $game_temp.num_input_variable_id > 0
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.number = number
      @input_number_window.x = self.x + 8
      @input_number_window.y = self.y + $game_temp.num_input_start * 32
    end
  end
end