#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  This class performs game over screen processing.
#==============================================================================

class Scene_Gameover < Scene_Base
  def setup
    super
    # Make game over graphic
    @sprites.push(@sprite = Sprite.new)
    @sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
    # Stop BGM and BGS
    $game_system.bgm_play(nil)
    $game_system.bgs_play(nil)
    # Play game over ME
    $game_system.me_play($data_system.gameover_me)
  end
  
  def terminate
    @sprite.bitmap.dispose
    super
    # Execute transition
    Graphics.transition(40)
    # Prepare for transition
    Graphics.freeze
    # If battle test
    if $BTEST
      $scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Switch to title screen
      $scene = Scene_Title.new
    end
  end
end
