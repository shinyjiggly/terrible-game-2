#==============================================================================
# ** Window_Base
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Actor Face (see Face Support script)
  #--------------------------------------------------------------------------
  def draw_actor_face(actor, x, y)
    # Loads the Picture of the face called as the character graphic's name.
    bitmap = RPG::Cache.picture(actor.face_name)
    # By default faces measures 96x96px
    cw = bitmap.width
    ch = bitmap.height
    src_rect = Rect.new(0, 0, cw, ch)
    self.contents.blt(x - cw, y - ch, bitmap, src_rect)
  end  
  
  #--------------------------------------------------------------------------
  # * Draw Actor Level
  #--------------------------------------------------------------------------
  def draw_actor_level(actor, x, y)
    # Draws the actor's level as default (Vocab support)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, Vocab::LEVEL)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 36, y, 24, 32, actor.level.to_s)
  end
  
  #--------------------------------------------------------------------------
  # * Make State Text String for Drawing
  #--------------------------------------------------------------------------
  def make_battler_state_text(battler, width, need_normal)
    # This method works as always but without brackets
    # Make text string for state names
    text = ""
    for i in battler.states
      if $data_states[i].rating >= 1
        if text == ""
          text = $data_states[i].name
        else
          new_text = text + "/" + $data_states[i].name
          text_width = self.contents.text_size(new_text).width
          text = new_text
        end
      end
    end
    # If text string for state names is empty, make it Normal
    if text == ""
      if need_normal
        text = Vocab::NOSTATE
      end
    end
    return text
  end
  
  #--------------------------------------------------------------------------
  # * Draw Actor State
  #--------------------------------------------------------------------------
  def draw_actor_state(actor, x, y, width = 120)
    text = make_battler_state_text(actor, width, true)
    if actor.hp == 0
      self.contents.draw_text(x, y, width, 32, text, 0, 5)
    elsif text == Vocab::NOSTATE
      self.contents.draw_text(x, y, width, 32, text, 0, 0)
    else
      self.contents.draw_text(x, y, width, 32, text, 0, 4)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw Actor Experience
  #--------------------------------------------------------------------------
  def draw_actor_exp(actor, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 24, 32, Vocab::EXPERIENCE)
    self.contents.font.color = normal_color
    self.contents.draw_text(x+32,y,84,32, actor.exp_s + " / " + actor.next_exp_s)
  end
  
  #--------------------------------------------------------------------------
  # * New Draw Icon with color
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, color=normal_color)
    return if item == nil
    self.contents.font.color = color
    self.contents.draw_icon(x, y + 4, 24, 24, item.icon_name)
    self.contents.draw_text(x + 28, y, 212, 32, item.name)
  end
end