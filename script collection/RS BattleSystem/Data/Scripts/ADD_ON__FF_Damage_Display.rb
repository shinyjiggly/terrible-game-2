#==============================================================================
# Â¦ RPG::Sprite
#------------------------------------------------------------------------------
# Change the damage display
#
# By Squall // squall@rmxp.ch
# released on the 30th march at rmxp.org
#
# expanded a little by Orochii Zouveleki, copying and adapting the enemy 
# advanced collapses from Atoa Custom Battle System.
# So I think you have to give credit to Atoa ohohohohoo!
#==============================================================================

class RPG::Sprite < ::Sprite
  #--------------------------------------------------------------------------
  # ? initialize
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @_whiten_duration = 0
    @_appear_duration = 0
    @_escape_duration = 0
    @_collapse_duration = 0
    @collapse_count = 0
    @_damage_duration = 0
    @frame_width = 0
    @frame_height = 0
    @_fastappear_duration = 0
    @_disappear_duration = 0
    @_effect_type = 0
    @_damage_durations = []
    @animation = {}
    @_animation_duration = 0
    @_damage_color = [0, 0, 0]
    @offset_x = 0
    @offset_y = 0
    @anim_index = 0
    @_blink = false
  end
  #--------------------------------------------------------------------------
  # ? dispose
  #--------------------------------------------------------------------------
  def dispose
    dispose_damage(0...@_damage_durations.size)
    dispose_animation
    dispose_loop_animation
    super
  end
  #--------------------------------------------------------------------------
  # ? effect?
  #--------------------------------------------------------------------------
  def effect?
    damage_duration = 0
    for value in @_damage_durations
      damage_duration += value
    end
    @_whiten_duration > 0 or
    @_appear_duration > 0 or
    @_escape_duration > 0 or
    @_collapse_duration > 0 or
    damage_duration > 0 or
    @_animation_duration > 0
  end
  #--------------------------------------------------------------------------
  # ? damage
  #--------------------------------------------------------------------------
  def damage(value, critical)
    dispose_damage(0...@_damage_durations.size)
    @_damage_sprites = []
    if value.is_a?(Numeric)
      damage_string = value.abs.to_s
    else
      damage_string = value.to_s
    end
    if critical
      damage_string += " CRITICAL"
    end
     
    for i in 0...damage_string.size
      letter = damage_string[i..i]
      bitmap = Bitmap.new(48, 48)
      bitmap.font.size = 24
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_text(-1, 12-1, 48, 48, letter, 1)
      bitmap.draw_text(+1, 12-1, 48, 48, letter, 1)
      bitmap.draw_text(-1, 12+1, 48, 48, letter, 1)
      bitmap.draw_text(+1, 12+1, 48, 48, letter, 1)
      if value.is_a?(Numeric) and value < 0
        bitmap.font.color.set(176, 255, 144)
      else
        bitmap.font.color.set(255, 255, 255)
      end
      bitmap.draw_text(0, 12, 48, 48, letter, 1)
     
      @_damage_sprites[i] = ::Sprite.new(self.viewport)
      @_damage_sprites[i].bitmap = bitmap
      @_damage_sprites[i].visible = false
      @_damage_sprites[i].ox = 16
      @_damage_sprites[i].oy = 16
      @_damage_sprites[i].x = self.x - self.ox / 2 + i * 12
      @_damage_sprites[i].y = self.y - self.oy / 2
      @_damage_sprites[i].z = 3000
      @_damage_durations[i] = 40 + i * 2
    end
  end
  #--------------------------------------------------------------------------
  # ? dispose_damage
  #--------------------------------------------------------------------------
  def dispose_damage(index)
    return if @_damage_sprites == nil
    if @_damage_sprites[index].is_a?(::Sprite) and @_damage_sprites[index].bitmap != nil
      @_damage_sprites[index].bitmap.dispose
      @_damage_sprites[index].dispose
      @_damage_durations[index] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ? update
  #--------------------------------------------------------------------------
  def update
    super
    update_withen
    update_appear
    update_escape
    update_collapse
    update_damage_pop
    update_anims
    update_loop_anim
    update_blink
    @@_animations.clear
  end
  
  def update_withen
    if @_whiten_duration > 0
      @_whiten_duration -= 1
      self.color.alpha = 128 - (16 - @_whiten_duration) * 10
    end
  end
  
  def update_appear
    if @_appear_duration > 0
      @_appear_duration -= 1
      self.opacity = (16 - @_appear_duration) * 16
    end
  end
  
  def update_escape
    if @_escape_duration > 0
      @_escape_duration -= 1
      self.opacity = 256 - (32 - @_escape_duration) * 10
    end
  end
  
  #def update_collapse
  #  if @_collapse_duration > 0
  #    @_collapse_duration -= 1
  #    self.opacity = 256 - (48 - @_collapse_duration) * 6
  #  end
  #end
  
  def update_collapse
    if @_collapse_duration > 0
      @_collapse_duration -= 1
      case @_effect_type
      when 0
        normal_collapse
      when 1
        boss_collapse
      when 2
        boss_collapse2
      when 3
        boss_collapse_advanced
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Normal Collapse
  #--------------------------------------------------------------------------
  def normal_collapse
    if @_collapse_duration == 46
      self.blend_type = 1
      self.color.set(255, 64, 64, 255)
    end
    self.opacity = 256 - (48 - @_collapse_duration) * 6 if @_collapse_duration <= 46
    @shadow.opacity = self.opacity if @shadow != nil
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect 1
  #--------------------------------------------------------------------------
  def boss_collapse
    if @_collapse_duration == 320
      $game_system.se_play(RPG::AudioFile.new('124-Thunder02', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 290
      $game_system.se_play(RPG::AudioFile.new('124-Thunder02', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 250
      $game_system.se_play(RPG::AudioFile.new('049-Explosion02',100, 50))
      self.blend_type = 1
      self.color.set(255, 128, 128, 128)
      @original_oy = self.oy 
    end
    if @_collapse_duration < 250
      self.oy -= 1
      @collapse_count = @collapse_count.nil? ? 0 : [@collapse_count + 1, 12].min
      self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height +
                        @_collapse_duration - 250 - @collapse_count)
      self.opacity = @_collapse_duration - 20
      self.zoom_y = (@_collapse_duration / 250.0)
      @shadow.opacity = self.opacity if @shadow != nil
      return if @_collapse_duration < 100
      if @_collapse_duration % 80 == 0
        $game_system.se_play(RPG::AudioFile.new('049-Explosion02',100, 50))
      end
      @original_oy = self.oy if @_collapse_duration == 1
    end
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect 2
  #--------------------------------------------------------------------------
  def boss_collapse2
    if @_collapse_duration == 320
      $game_system.se_play(RPG::AudioFile.new('124-Thunder02', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 290
      $game_system.se_play(RPG::AudioFile.new('124-Thunder02', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 250
      
      tmp_bitmap = self.bitmap.dup
      self.bitmap = Bitmap.new(tmp_bitmap.width,tmp_bitmap.height)
      tmp_rct = Rect.new(0,0,tmp_bitmap.width, tmp_bitmap.height)
      self.bitmap.blt(0, 0, tmp_bitmap, tmp_rct) 
      tmp_bitmap.dispose
      tmp_bitmap = nil
      $game_system.se_play(RPG::AudioFile.new('049-Explosion02',100, 50))
      self.blend_type = 1
      self.color.set(255, 128, 128, 128)
    end
    if @_collapse_duration < 250
      @offset_x = rand(5)
      @offset_y = @_collapse_duration - 250
      @frame_width = self.width if @frame_width == 0
      @frame_height = self.height if @frame_height == 0
      self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height + @offset_y)
      #self.zoom_y = (@_collapse_duration / 250.0)
      self.oy = self.height / (251-@_collapse_duration)
      tmp_bitmap = self.bitmap.dup
      tmp_rct = Rect.new(0,0,tmp_bitmap.width, tmp_bitmap.height-1)
      self.bitmap.clear
      self.bitmap.blt(0, 1, tmp_bitmap, tmp_rct) 
      self.opacity = @_collapse_duration - 20
      self.x = @battler.screen_x + @offset_x - rand(5)
      @shadow.opacity = self.opacity if @shadow != nil
      tmp_bitmap.dispose
      tmp_bitmap = nil
      return if @_collapse_duration < 100
      $game_system.se_play(RPG::AudioFile.new('049-Explosion02',100, 50)) if @_collapse_duration % 80 == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect 3
  #--------------------------------------------------------------------------
  def boss_collapse_advanced
    if @_collapse_duration == 550
      Audio.bgm_fade(2000) 
      Audio.bgs_fade(2000) 
    end
    if @_collapse_duration == 440 or @_collapse_duration == 380 or 
       @_collapse_duration == 280 or @_collapse_duration == 180
      $game_system.se_play(RPG::AudioFile.new('124-Thunder02', 100, 100))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 420 or @_collapse_duration == 360 or
       @_collapse_duration == 260 or @_collapse_duration == 160
      $game_system.se_play(RPG::AudioFile.new('124-Thunder02', 100, 50))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 350
      $game_system.se_play(RPG::AudioFile.new('137-Light03', 80, 50))
      self.blend_type = 1
      self.color.set(255, 255, 255, 128)
      @original_oy = self.oy 
    end
    if @_collapse_duration < 350 and @_collapse_duration > 40
      self.oy -= 1 if @_collapse_duration % 2 == 0
      @collapse_count = @collapse_count.nil? ? 0 : [@collapse_count + 1, 12].min
      self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height + @_collapse_duration / 2 - 175 - 
                        @collapse_count)
      
      self.x = @battler.screen_x - (116 - @_collapse_duration/3)
      self.y = @battler.screen_y + (175 - @_collapse_duration/2)
      self.opacity = @_collapse_duration - 60
      @shadow.opacity = self.opacity if @shadow != nil
      self.color.set(255, 255, 255, @_collapse_duration / 2 - 35)
      viewport.color = Color.new(255, 255, 255, 350 - @_collapse_duration)
      $game_system.se_play(RPG::AudioFile.new('137-Light03', 80, 50)) if @_collapse_duration % 90 == 0
    end
    $game_system.se_play(RPG::AudioFile.new('137-Light03', 80, 30)) if @_collapse_duration == 38
    if @_collapse_duration < 40 
      viewport.color = Color.new(255, 255, 255, @_collapse_duration * 6)
    end
    @original_oy = self.oy if @_collapse_duration == 39
  end
  
  def update_damage_pop
    for i in 0...@_damage_durations.size
      damage_sprite = @_damage_sprites[i]
      next if @_damage_durations[i] == nil
      if @_damage_durations[i] > 0
        @_damage_durations[i] -= 1
        damage_sprite.visible = (@_damage_durations[i] <= 40)
        case @_damage_durations[i]
        when 38..39
          damage_sprite.y -= 4
        when 36..37
          damage_sprite.y -= 2
        when 34..35
          damage_sprite.y += 2
        when 28..33
          damage_sprite.y += 4
        end
        damage_sprite.opacity = 256 - (12 - @_damage_durations[i]) * 32
        if @_damage_durations[i] == 0
          dispose_damage(i)
        end
      end
    end
  end
  
  def update_anims
    if @_animation != nil and (Graphics.frame_count % 2 == 0)
      @_animation_duration -= 1
      update_animation
    end
  end
  
  def update_loop_anim
    if @_loop_animation != nil and (Graphics.frame_count % 2 == 0)
      update_loop_animation
      @_loop_animation_index += 1
      @_loop_animation_index %= @_loop_animation.frame_max
    end
  end
  
  def update_blink
    if @_blink
      @_blink_count = (@_blink_count + 1) % 32
      if @_blink_count < 16
        alpha = (16 - @_blink_count) * 6
      else
        alpha = (@_blink_count - 16) * 6
      end
      self.color.set(255, 255, 255, alpha)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Collapse Effect
  #--------------------------------------------------------------------------
  def collapse
    @_effect_type = 0
    @_collapse_duration = 48
    ext = @battler.collapse_type
    if ext != 0
      type = ext
      if type == 1
        @_effect_type = 1
        @_collapse_duration = 320
      elsif type == 2
        @_effect_type = 2
        @_collapse_duration = 320
      elsif type == 3
        @_effect_type = 3
        @_collapse_duration = 560
      end
    end
    @_whiten_duration = 0
    @_appear_duration = 0
    @_escape_duration = 0
    @_disappear_duration = 0
  end
end