# * KMoreTroops XP
#   Scripter : Kyonides-Arkanthos
#   2016-11-28

#   Script Call   #

#   KMoreTroops.sleep = true  or  nil
#     Values : true - Stop sending Reinforcements, nil - Send Reinforcements
#     The default value is nil (see @sleep in line 17).
#     Can be changed at will during gameplay.

module KMoreTroops
  ARRIVAL = 'Beware! Reinforcements are coming this way!'
  BOSSARRIVAL = "Beware! You're not about to face a weakling..."
  BOSSIDS = []
  # { Old Troop ID => [New Troop ID, Continue if Same ID is found?], etc. }
  # "Continue" values : true - Fight, nil - This one will be the last battle
  REINFORCE = { 1 => [3,true], 3 => [5,nil], 5 => [7,nil] }
  @sleep = nil
  def self.sleep() @sleep end # Do Not Edit This Line
  def self.sleep=(bool) @sleep = bool end # Do Not Edit This Line
  REINFORCE.default = [0,nil] # Do Not Edit This Line
end

class Game_Troop
  def last_trooper?() @enemies.select{|e| e.exist? }.size == 1 end
  def last_trooper() @enemies.select {|e| e.exist? }[0] end
end

class Spriteset_Battle
  def make_reinforcements_sprites
    @enemy_sprites.each {|s| s.dispose }
    @enemy_sprites.clear
    $game_troop.enemies.reverse.each {|enemy|
      @enemy_sprites << Sprite_Battler.new(@viewport1, enemy) }
  end
end

class Scene_Battle
  alias kyon_kmoretroops_scn_map_main main
  alias kyon_kmoretroops_scn_battle_up_phase5 update_phase5
  def main
    @restart_wait_count = 0
    tid = $game_temp.battle_troop_id
    @reinforcement_id, @continue = KMoreTroops::REINFORCE[tid]
    kyon_kmoretroops_scn_map_main
  end

  def update_phase5
    unless KMoreTroops.sleep
      if @restart_wait_count > 0
        update_phase5_restart
        return
      end
      if @phase5_wait_count == 0 and @reinforcement_id > 0
        update_phase5_clear_enemies
        return
      end
    end
    kyon_kmoretroops_scn_battle_up_phase5
  end

  def update_phase5_restart
    @restart_wait_count -= 1
    if @restart_wait_count == 0
      @result_window.dispose
      @result_window = nil
      @help_window.set_text('')
      @help_window.visible = false
      @spriteset.make_reinforcements_sprites
      $game_system.se_play($data_system.battle_start_se)
      start_phase1
    end
  end

  def update_phase5_clear_enemies
    boss = KMoreTroops::BOSSIDS.include?(@reinforcement_id)
    text = boss ? KMoreTroops::BOSSARRIVAL : KMoreTroops::ARRIVAL
    @help_window.set_text(text, 1)
    $game_system.bgm_play($game_system.battle_bgm)
    $game_troop.enemies.clear
    @troop_id = @reinforcement_id
    $game_troop.setup(@troop_id)
    if @continue
      rid = @reinforcement_id
      @reinforcement_id, @continue = KMoreTroops::REINFORCE[rid]
    else
      @reinforcement_id = 0
    end
    @restart_wait_count = 80
  end

  alias kyon_scn_battle_up_phase4_step1 update_phase4_step1
  def update_phase4_step1
    if !@last_trooper and $game_troop.last_trooper?
      $game_temp.message_window_showing = true
      trooper = $game_troop.last_trooper
      name = trooper.name
      tid = trooper.id
      $game_temp.message_text = "#{name} says:\nHey! What's your damn problem?"
      @last_trooper = true
    end
    kyon_scn_battle_up_phase4_step1
  end
end