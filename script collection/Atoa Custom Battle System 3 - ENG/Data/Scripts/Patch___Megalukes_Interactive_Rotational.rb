#==============================================================================
# Atoa Custom Battle System / Megalukes Interactive Rotational Arrow Patch
# Megalukes Interactive Rotational Arrow by Megalukes
#==============================================================================
# Pacht for Megalukes Interactive Rotational Patch
#
# The Megalukes Interactive Rotational Arrow scripts must be added below
# the battle system core scripts but above the add-ons
#
# This patch must be added bellow all add-ons
#
# The script can be found at:
# http://www.santuariorpgmaker.com/forum/index.php?topic=8735
#==============================================================================

#==============================================================================
# ** Arrow_Base
#------------------------------------------------------------------------------
# É o sprite para mostrar o cursor de seleção na batalha
# Esta classe é utilizada em Arrow_Enemy e Arrow_Actor
#==============================================================================

class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  # Atualização de múltiplos cursores
  #--------------------------------------------------------------------------
  def update_multi_arrow
    self.opacity = 0
    return if @arrows.nil? or @arrows == []
    for i in 0...@arrows.size
      if Blink_Arrow == true
        @arrows[i].ox = self.bitmap.width  / 4
      else
        @arrows[i].ox = self.bitmap.width  / 2
      end
      @arrows[i].oy = self.bitmap.height / 2
      @arrows[i].angle += Target_Arrow_Rotate_Speed
      if Blink_Arrow == true
        @blink_count = (@blink_count + 1) % 8
        if @blink_count < 4
          @arrows[i].src_rect.set(0, 0, @arrows[i].bitmap.width / 2, @arrows[i].bitmap.height)
        else
          @arrows[i].src_rect.set(@arrows[i].bitmap.width / 2, 0, @arrows[i].bitmap.width / 2, self.bitmap.height)
        end
      else
        @arrows[i].src_rect.set(0, 0, @arrows[i].bitmap.width, @arrows[i].bitmap.height)
      end
    end
  end
end

#==============================================================================
# ** Arrow_Enemy
#------------------------------------------------------------------------------
# É o ponteiro que indica o inimigo a ser escolhido na batalha
#==============================================================================

class Arrow_Enemy < Arrow_Base
  #--------------------------------------------------------------------------
  # Renovação do Frame
  #--------------------------------------------------------------------------
  def update
    super
    $game_troop.enemies.size.times do
      break if self.enemy.exist?
      @index += 1
      @index %= $game_troop.enemies.size
    end
    cursor_down if Input.repeat?(Input::RIGHT)
    cursor_down if Input.repeat?(Input::UP)
    cursor_up if Input.repeat?(Input::LEFT)
    cursor_up if Input.repeat?(Input::DOWN)
    update_arrows if self.enemy != nil
  end
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor
  #--------------------------------------------------------------------------
  def update_arrows
    arrow_x = self.enemy.actual_x + MEGALUKESNEWARROW::Enemy_Target_Arrow_Adjust[0] 
    arrow_y = self.enemy.actual_y + MEGALUKESNEWARROW::Enemy_Target_Arrow_Adjust[1] - 45 
    if @player != nil
      temp_x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
      temp_y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
      self.adv_move(temp_x, temp_y, Target_Arrow_Speed)
    else
      self.x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
      self.y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    end
    @player = self.enemy
    self.zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
  end
end

#==============================================================================
# ** Arrow_Actor
#------------------------------------------------------------------------------
# É o ponteiro que indica o Herói a ser escolhido na batalha
#==============================================================================

class Arrow_Actor < Arrow_Base
  #--------------------------------------------------------------------------
  # Renovação do Frame
  #--------------------------------------------------------------------------
  def update
    super
    cursor_down if Input.repeat?(Input::RIGHT)
    cursor_down if Input.repeat?(Input::DOWN)
    cursor_up if Input.repeat?(Input::LEFT)
    cursor_up if Input.repeat?(Input::UP)
    update_arrows if self.actor != nil
  end
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor
  #--------------------------------------------------------------------------
  def update_arrows
    arrow_x = self.actor.actual_x + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[0]
    arrow_y = self.actor.actual_y + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[1] - 45
    if @player != nil
      temp_x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
      temp_y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
      self.adv_move(temp_x, temp_y, Target_Arrow_Speed)
    else
      self.x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
      self.y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    end
    @player = self.actor
    self.zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
  end
end

#==============================================================================
# ** Arrow_Self
#------------------------------------------------------------------------------
# É o ponteiro que indica seleção do usuário
#==============================================================================

class Arrow_Self < Arrow_Base
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor
  #--------------------------------------------------------------------------
  def update_arrows
    arrow_x = self.actor.actual_x + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[0]
    arrow_y = self.actor.actual_y + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[1] - 45
    if @player != nil
      temp_x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
      temp_y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
      self.adv_move(temp_x, temp_y, Target_Arrow_Speed)
    else
      self.x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
      self.y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    end
    @player = self.actor
    self.zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
  end
end

#==============================================================================
# ** Arrow_Actor_All
#------------------------------------------------------------------------------
# É o ponteiro que indica todos aliados a serem escolhido na batalha
#==============================================================================

class Arrow_Actor_All < Arrow_Base
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor
  #     index : Índice
  #--------------------------------------------------------------------------
  def update_arrows(index)
    arrow_x = @arrows[index].actor.actual_x + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[0]
    arrow_y = @arrows[index].actor.actual_y + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[1] - 45
    @arrows[index].x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
    @arrows[index].y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].z = 3000
  end
end

#==============================================================================
# ** Arrow_Enemy_All
#------------------------------------------------------------------------------
# É o ponteiro que indica todos inimigo a serem escolhido na batalha
#==============================================================================

class Arrow_Enemy_All < Arrow_Base
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor
  #     index : Índice
  #--------------------------------------------------------------------------
  def update_arrows(index)
    arrow_x = @arrows[index].enemy.actual_x + MEGALUKESNEWARROW::Enemy_Target_Arrow_Adjust[0]
    arrow_y = @arrows[index].enemy.actual_y + MEGALUKESNEWARROW::Enemy_Target_Arrow_Adjust[1] - 45
    @arrows[index].x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
    @arrows[index].y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].z = 3000
  end
end

#==============================================================================
# ** Arrow_Battler_All
#------------------------------------------------------------------------------
# É o ponteiro que indica todos battlers a serem escolhido na batalha
#==============================================================================

class Arrow_Battler_All < Arrow_Base
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor dos aliados
  #     index : Índice
  #--------------------------------------------------------------------------
  def update_arrows_actor(index)
    arrow_x = @arrows[index].actor.actual_x + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[0]
    arrow_y = @arrows[index].actor.actual_y + MEGALUKESNEWARROW::Actor_Target_Arrow_Adjust[1] - 45
    @arrows[index].x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
    @arrows[index].y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].z = 3000
  end
  #--------------------------------------------------------------------------
  # Atualizar posição do cursor dos inimigod
  #     index : Índice
  #--------------------------------------------------------------------------
  def update_arrows_enemy(index)
    arrow_x = @arrows[index].enemy.actual_x + MEGALUKESNEWARROW::Enemy_Target_Arrow_Adjust[0]
    arrow_y = @arrows[index].enemy.actual_y + MEGALUKESNEWARROW::Enemy_Target_Arrow_Adjust[1] - 45
    @arrows[index].x = $atoa_script['Atoa Battle Camera'] ? adjust_x_to_zoom(arrow_x) : arrow_x
    @arrows[index].y = $atoa_script['Atoa Battle Camera'] ? adjust_y_to_zoom(arrow_y) : arrow_y
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if $atoa_script['Atoa Battle Camera'] and Arrow_Zoom
    @arrows[index].z = 3000
  end
end