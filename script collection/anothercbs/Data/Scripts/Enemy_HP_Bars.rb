class Window_EnemyHP < Window_Base
  
  def initialize
    super(0, 0, 640, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    @old_hp = []
    refresh
  end
  
  def refresh
    self.contents.clear
    for i in 0...$game_troop.enemies.size
      @enemy = $game_troop.enemies[i]
      @old_hp[i] = @enemy.hp
      unless @enemy.hp == 0
        self.contents.font.size = 15
        self.contents.font.bold = true
        self.contents.font.color = Color.new(0,0,0)
        self.contents.draw_text(1, i * 32 + 36, 100, 32, @enemy.name)
        self.contents.draw_text(-1, i * 32 + 36, 100, 32, @enemy.name)
        self.contents.draw_text(1, i * 32 + 38, 100, 32, @enemy.name)
        self.contents.draw_text(-1, i * 32 + 38, 100, 32, @enemy.name)
        self.contents.font.color = normal_color
        self.contents.draw_text(0, i * 32 + 37, 100, 32, @enemy.name)
        draw_slant_bar(0, i*32 + 60, @enemy.hp, @enemy.maxhp, 50)
      end
    end
  end
  def update
    for i in 0...$game_troop.enemies.size
      enemy = $game_troop.enemies[i]
      if enemy.hp != @old_hp[i]
        refresh
      end
    end
  end
end
 
class Scene_Battle
  
  alias raz_update_phase5 update_phase5
  alias raz_update_phase4_step1 update_phase4_step1
  alias raz_update_phase4_step5 update_phase4_step5
  alias raz_enemy_hp_main main
  
  def main
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    @enemy_window = Window_EnemyHP.new
    @enemy_window.z = 95
    raz_enemy_hp_main
    @enemy_window.dispose
  end
  
  def update_phase5
    # If wait count is larger than 0
    if @phase5_wait_count > 0
      # Decrease wait count
      @phase5_wait_count -= 1
      # If wait count reaches 0
      if @phase5_wait_count == 0
        @enemy_window.visible = false
        # Show result window
        @result_window.visible = true
        # Clear main phase flag
        $game_temp.battle_main_phase = false
        # Refresh status window
        @status_window.refresh
        @enemy_window.refresh
      end
      return
    end
   raz_update_phase5
 end

def update_phase4_step1
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
end