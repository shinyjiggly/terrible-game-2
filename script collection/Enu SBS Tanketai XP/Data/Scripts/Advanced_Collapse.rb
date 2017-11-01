#==============================================================================
# Add-On: Advanced Collapse
# Created by Enu
#==============================================================================
# This Add-On adds a new collapse effects with a lot of nifty things
# Pretty useful for final bosses
#==============================================================================

module ADVANCED_COLLAPSE
  ADV_COLLAPSE_ID = 4 # Collapse's ID, must NEVER be equal to 1, 2 or 3
  ADV_COLLAPSE_ENEMIES = [35, 36, 37, 38, 39] #ID of the enemies that have advanced collapse.
end

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  alias collapse_type_advanced1 collapse_type
  #--------------------------------------------------------------------------
  def collapse_type
    for x in ADVANCED_COLLAPSE::ADV_COLLAPSE_ENEMIES
      return ADVANCED_COLLAPSE::ADV_COLLAPSE_ID if @enemy_id == x
    end
    collapse_type_advanced1
  end
end

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  alias update_collapse_advanced1 update_collapse
  alias collapse_action_advanced1 collapse_action
  #--------------------------------------------------------------------------
  def update_collapse
    update_collapse_advanced1
    boss_collapse_advanced1 if @collapse_type == ADVANCED_COLLAPSE::ADV_COLLAPSE_ID
  end
  #--------------------------------------------------------------------------
  def collapse_action
    collapse_action_advanced1
    @effect_duration = 560 if @collapse_type == ADVANCED_COLLAPSE::ADV_COLLAPSE_ID
  end  
  #--------------------------------------------------------------------------
  def boss_collapse_advanced1
    duration = @effect_duration
    if duration == 550
      Audio.bgm_fade(2000) 
      Audio.bgs_fade(2000) 
    end
    if duration == 440 or duration == 380 or duration == 280 or duration == 180
      Audio.se_play("Audio/SE/124-Thunder02", 100, 100)
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if duration == 420 or duration == 360 or duration == 260 or duration == 160
      Audio.se_play("Audio/SE/124-Thunder02", 100, 50)
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if duration == 350
      Audio.se_play("Audio/SE/137-Light03",80, 50)
      reset
      self.blend_type = 1
      self.color.set(255, 255, 255, 128)
    end
    if duration < 350 && duration > 40
      self.src_rect.set(0, duration / 2 - 175, @width, @height - @shadow.bitmap.height / 2)
      self.x += 10 if duration % 2 == 0
      self.opacity = duration - 60
      self.color.set(255, 255, 255, duration / 2 - 35)
      viewport.color = Color.new(255, 255, 255, 350 - duration)
      Audio.se_play("Audio/SE/137-Light03",80, 50) if duration % 90 == 0
    end
    Audio.se_play("Audio/SE/137-Light03",80, 30) if duration == 38
    viewport.color = Color.new(255, 255, 255, duration * 6) if duration < 40 
  end
end

class Scene_Battle
  #--------------------------------------------------------------------------
  alias process_victory_advanced1 process_victory
  #--------------------------------------------------------------------------
  def process_victory
    for enemy in $game_troop.enemies
      break boss_wait_advanced1 = true if enemy.collapse_type == ADVANCED_COLLAPSE::ADV_COLLAPSE_ID
    end
    wait(560) if boss_wait_advanced1
    process_victory_advanced1
  end
end