#Enemy HP Bars
#by Raziel
#Version: 1.1
#July 14 2006

class Window_Base < Window  
  #--------------------------------------------------------------------------
  # * Draw Slant Bar(by SephirothSpawn)
  #--------------------------------------------------------------------------
  def draw_slant_bar(x, y, min, max, width = 152, height = 6,
      bar_color = Color.new(150, 0, 0, 255), end_color = Color.new(255, 255, 60, 255))
    # Draw Border
    for i in 0..height
      self.contents.fill_rect(x + i, y + height - i, width + 1, 1, Color.new(50, 50, 50, 255))
    end
    # Draw Background
    for i in 1..(height - 1)
      r = 100 * (height - i) / height + 0 * i / height
      g = 100 * (height - i) / height + 0 * i / height
      b = 100 * (height - i) / height + 0 * i / height
      a = 255 * (height - i) / height + 255 * i / height
      self.contents.fill_rect(x + i, y + height - i, width, 1, Color.new(r, b, g, a))
    end
    # Draws Bar
    for i in 1..( (min / max.to_f) * width - 1)
      for j in 1..(height - 1)
        r = bar_color.red * (width - i) / width + end_color.red * i / width
        g = bar_color.green * (width - i) / width + end_color.green * i / width
        b = bar_color.blue * (width - i) / width + end_color.blue * i / width
        a = bar_color.alpha * (width - i) / width + end_color.alpha * i / width
        self.contents.fill_rect(x + i + j, y + height - j, 1, 1, Color.new(r, g, b, a))
      end
    end
  end
end


class Window_EnemyHP < Window_Base
  
  def initialize
    super(0, 0, 640, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    for i in 0...$game_troop.enemies.size
      @enemy = $game_troop.enemies[i]
    @saved_hp = @enemy.hp
    end
    refresh
  end
  
  
  def refresh
    self.contents.clear
    for i in 0...$game_troop.enemies.size
      @enemy = $game_troop.enemies[i]
      @percent = (@enemy.hp * 100) / @enemy.maxhp
      unless @enemy.hp == 0
      draw_slant_bar(@enemy.screen_x - 55, @enemy.screen_y - 10, @enemy.hp, @enemy.maxhp, width = 75, height = 6, bar_color = Color.new(150, 0, 0, 255), end_color = Color.new(255, 255, 60, 255))
      #self.contents.draw_text(@enemy.screen_x - 39, @enemy.screen_y - 22, 100, 32, "#{@percent}" + "%")
      self.contents.draw_text(@enemy.screen_x - 39, @enemy.screen_y - 22, 100, 32, "#{@enemy.hp}" + " HP")
    @saved_hp = @enemy.hp
      end
  end
end
end

class Scene_Battle
  
  alias raz_update update
  alias raz_update_phase5 update_phase5
  #alias raz_update_phase4_step1 update_phase4 #_step1
  alias raz_update_phase4 update_phase4 #_step5
  alias raz_enemy_hp_main main
  
   def main
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    @enemy_window = Window_EnemyHP.new
    @enemy_window.z = 95
    raz_enemy_hp_main
    @enemy_window.dispose
  end
  
  def update
    @enemy_window.update
    raz_update
  end
  def update_phase5 #atoa version!!
    return if not_in_position($game_party.actors) or collapsing
    unless $game_temp.battle_victory
      set_result_window
	  @enemy_window.visible = false
    end
    if @phase5_wait_count > 0 and $game_temp.battle_victory
	 # If wait count is larger than 0 AND battle is won
      @phase5_wait_count -= 1
	  # Decrease wait count
      update_result_window
	  @enemy_window.refresh if need_to_refresh_bar
      return
    end
   raz_update_phase5
end
=begin
def update_phase4 #_step1
  raz_update_phase4_step1
  @enemy_window.refresh
end

  def update_phase4_step5
    # Hide help window
    @help_window.visible = false
    # Refresh status window
    @status_window.refresh
    @enemy_window.refresh
    raz_update_phase4_step5
  end
=end  
 
  def need_to_refresh_bar
    for i in 0...$game_troop.enemies.size
      @enemy = $game_troop.enemies[i]
    if @saved_hp != @enemy.hp
      return true
    end
    end
    end

  def update_phase4
    # Hide help window
    @help_window.visible = false
    # Refresh status window
    @status_window.refresh if status_need_refresh
    @enemy_window.refresh if need_to_refresh_bar

    raz_update_phase4
  end
  
end