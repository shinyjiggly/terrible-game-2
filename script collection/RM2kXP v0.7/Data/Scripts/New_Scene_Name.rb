#==============================================================================
# ** Scene_Name
#==============================================================================

class Scene_Name
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @spriteset = Spriteset_Map.new
    @actor = $game_actors[$game_temp.name_actor_id]
    @edit_window = Window_NameEdit.new(@actor, $game_temp.name_max_char)
    @face_window = Window_NameFace.new(@actor)
    @input_window = Window_NameInput.new
    @back_window = Window_Back.new
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @spriteset.dispose
    @edit_window.dispose
    @face_window.dispose
    @input_window.dispose
    @back_window.dispose
  end
end
