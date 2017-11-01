#==============================================================================
# Sideview Battle System Version 2.2xp
#==============================================================================
#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  APPEAR    = 3
  DISAPPEAR = 4
  COLLAPSE  = 5
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @effect_type = 0
    @effect_duration = 0
    @move_x = 0
    @move_y = 0
    @move_z = 0
    @distanse_x = 0
    @distanse_y = 0
    @moving_x = 0
    @moving_y = 0
    @move_speed_x = 0
    @move_speed_y = 0
    @move_speed_plus_x = 0
    @move_speed_plus_y = 0
    @move_boost_x = 0
    @move_boost_y = 0
    @jump_time = 0
    @jump_time_plus = 0
    @jump_up = 0
    @jump_down = 0
    @jump_size = 0
    @float_time = 0
    @float_up = 0
    @jump_plus = 0
    @angle = 0
    @angling = 0
    @angle_time = 0
    @angle_reset = 0
    @zoom_x = 0
    @zoom_y = 0
    @zooming_x = 0
    @zooming_y = 0
    @zoom_time = 0
    @zoom_reset = 0
    @target_battler = []
    @now_targets = []
    @pattern = 0
    @pattern_back = false
    @wait = 0
    @unloop_wait = 0
    @action = []
    @anime_kind = 0
    @anime_speed = 0
    @frame = 0
    @anime_loop = 0
    @anime_end = false
    @anime_freeze = false
    @anime_freeze_kind = false
    @anime_moving = false
    @base_width = ANIME_PATTERN
    @base_height = ANIME_KIND
    @join = false
    @width = 0 
    @height = 0
    @picture_time = 0
    @individual_targets = []
    @balloon_duration = 65
    @reverse = false
    return @battler_visible = false if @battler == nil
    @anime_flug = true if @battler.actor? && !NO_ANIM_BATTLER
    @anime_flug = true if !@battler.actor? && @battler.anime_on
    @weapon_R = Sprite_Weapon.new(viewport,@battler) if @anime_flug
    make_battler
  end
  #--------------------------------------------------------------------------
  def make_battler
    @battler.base_position
    @battler_hue = @battler.battler_hue
    if @anime_flug
      @battler_name = @battler.battler_name if !@battler.actor?
      @battler_name = @battler.character_name if @battler.actor?
      @battler_hue = @battler.character_hue if @battler.actor?
      self.mirror = true if !@battler.actor? && @battler.action_mirror
      self.mirror = false if !@battler.actor? && @battler.action_mirror and $back_attack
      self.bitmap = RPG::Cache.character(@battler_name, @battler_hue) if WALK_ANIME
      begin
        self.bitmap = RPG::Cache.character(@battler_name + "_1", @battler_hue) unless WALK_ANIME
      rescue
        self.bitmap = RPG::Cache.character(@battler_name, @battler_hue) unless WALK_ANIME
      end
      @width = self.bitmap.width / @base_width
      @height = self.bitmap.height / @base_height
      @sx = @pattern * @width
      @sy = @anime_kind * @height
      self.src_rect.set(@sx, @sy, @width, @height)
    else
      @battler_name = @battler.battler_name
      self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
      @width = bitmap.width
      @height = bitmap.height
    end
    unless @back_attack_flug 
      if self.mirror && $back_attack
        self.mirror = false
      elsif $back_attack
        self.mirror = true
      end
      @back_attack_flug = true
    end
    @battler.reset_coordinate
    self.ox = @width / 2
    self.oy = @height * 2 / 3
    update_move
    @move_anime = Sprite_MoveAnime.new(viewport,battler)
    @picture = Sprite.new
    make_shadow if SHADOW
  end
  #--------------------------------------------------------------------------
  def update_battler_graphic
    return if @graphic_change or !WALK_ANIME or @anime_freeze or @battler.dead?
    if @battler.actor? and @anime_flug
      @battler.base_position
      @battler_name = @battler.character_name if @battler.actor?
      @battler_hue = @battler.character_hue if @battler.actor?
      self.bitmap = RPG::Cache.character(@battler_name, @battler_hue)if WALK_ANIME
      begin
        self.bitmap = RPG::Cache.character(@battler_name + "_1", @battler_hue) unless WALK_ANIME
      rescue
        self.bitmap = RPG::Cache.character(@battler_name, @battler_hue) unless WALK_ANIME
      end
      @width = self.bitmap.width / @base_width
      @height = self.bitmap.height / @base_height
      @sx = @pattern * @width
      @sy = @anime_kind * @height
      self.src_rect.set(@sx, @sy, @width, @height)
      self.ox = @width / 2
      self.oy = @height * 2 / 3
    end
    unless @back_attack_flug 
      if self.mirror && $back_attack
        self.mirror = false
      elsif $back_attack
        self.mirror = true
      end
      @back_attack_flug = true
    end
  end
  #--------------------------------------------------------------------------
  def make_shadow
    @shadow.dispose if @shadow != nil
    @battler_hue = @battler.battler_hue
    @shadow = Sprite.new(viewport)
    @shadow.z = 200
    @shadow.visible = false
    @shadow.bitmap = RPG::Cache.character(@battler.shadow, @battler_hue)
    @shadow_height = @shadow.bitmap.height
    @shadow_plus_x = @battler.shadow_plus[0] - @width / 2
    @shadow_plus_y = @battler.shadow_plus[1]
    @shadow.zoom_x = @width * 1.0 / @shadow.bitmap.width
    update_shadow
    @skip_shadow = true
  end
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose if self.bitmap != nil
    @weapon_R.dispose if @weapon_R != nil
    @move_anime.dispose if @move_anime != nil
    @picture.dispose if @picture != nil
    @shadow.dispose if @shadow != nil
    @balloon.dispose if @balloon != nil
    mirage_off
    super
  end  
  #--------------------------------------------------------------------------
  def damage_action(action)
    if action[0] == "absorb"
      action[0] = nil
      now_hp = @battler.hp
      now_sp = @battler.sp
      @battler.hp += action[3] if action[2] == "hp"
      @battler.sp += action[3] if action[2] == "sp"
      @battler.damage = now_hp - @battler.hp if action[2] == "hp"
      @battler.damage = now_sp - @battler.sp if action[2] == "sp"
      @battler.sp_damage = true if @battler.damage != 0 && action[2] == "sp"
      action[2] = false
    end
    unless @battler.evaded or @battler.missed or action[0] == nil
      @battler.animation_id = action[0]
      @battler.animation_hit = true
      @battler.anime_mirror = action[1]
    end
    dmg = @battler.damage
    dmg = 0 unless dmg.is_a?(Numeric)
    start_action(@battler.damage_hit) if dmg > 0 && action[2]
    if @battler.evaded or @battler.missed
      start_action(@battler.evasion) if action[2]
      Audio.se_play("Audio/SE/" + EVASION_EFFECT) if action[2]
    end
    damage_pop
  end
  #--------------------------------------------------------------------------
  def damage_pop
    damage(@battler.damage, @battler.critical, @battler.sp_damage)
    @battler.damage = nil
    @battler.sp_damage = false
    @battler.critical = false
    @battler.damage_pop = false
  end  
  #--------------------------------------------------------------------------
  def first_action
    action = @battler.first_action unless @battler.restriction == 4
    action = $data_states[@battler.state_id].base_action if @battler.states[0] != nil && @battler.restriction == 4
    start_action(action)
    @skip_shadow = false
  end
  #--------------------------------------------------------------------------
  def start_action(kind)
    reset
    stand_by
    @action = ACTION[kind].dup
    active = @action.shift
    @action.push("End")
    @active_action = ANIME[active]
    @wait = active.to_i if @active_action == nil
    action
  end
  #--------------------------------------------------------------------------
  def start_one_action(kind,back)
    reset
    stand_by
    @action = [back]
    @action.push("End")
    @active_action = ANIME[kind]
    action
  end
  #--------------------------------------------------------------------------
  def next_action
    return @wait -= 1 if @wait > 0
    return if @anime_end == false
    return @unloop_wait -= 1 if @unloop_wait > 0
    active = @action.shift
    @active_action = ANIME[active]
    @wait = active.to_i if @active_action == nil
    action
  end
  #--------------------------------------------------------------------------
  def stand_by
    @repeat_action = @battler.normal
    @repeat_action = @battler.pinch if @battler.hp <= @battler.maxhp / 4
    @repeat_action = @battler.defence if @battler.guarding?
    unless @battler.state_id == nil
      for state in @battler.battler_states.reverse
        next if state.extension.include?("NOSTATEANIME")
        next if @battler.is_a?(Game_Enemy) && state.extension.include?("EXCEPTENEMY")
        @repeat_action = state.base_action
      end 
    end
  end 
  #--------------------------------------------------------------------------
  def push_stand_by
    action = @battler.normal
    action = @battler.pinch if @battler.hp <= @battler.maxhp / 4
    action = @battler.defence if @battler.guarding?
    for state in @battler.battler_states.reverse
      next if state.extension.include?("NOSTATEANIME")
      next if @battler.is_a?(Game_Enemy) && state.extension.include?("EXCEPTENEMY")
      action = state.base_action
    end
    @repeat_action = action
    @action.delete("End")
    act = ACTION[action].dup
    for i in 0...act.size
      @action.push(act[i])
    end  
    @action.push("End")
    @anime_end = true
    @angle = self.angle = 0
  end
  #--------------------------------------------------------------------------
  def reset
    self.zoom_x = self.zoom_y = 1
    self.oy = @height * 2 / 3
    @angle = self.angle = 0
    @anime_end = true
    @non_repeat = false
    @anime_freeze = false
    @unloop_wait = 0
  end  
  #--------------------------------------------------------------------------
  def jump_reset
    @battler.jump = @jump_time = @jump_time_plus = @jump_up = @jump_down = 0 
    @jump_size = @jump_plus = @float_time = @float_up = 0 
  end
  #--------------------------------------------------------------------------
  def get_target(target)
    return if @battler.individual
    @target_battler = target
  end
  #--------------------------------------------------------------------------
  def send_action(action)
    @battler.play = 0
    @battler.play = action if @battler.active
  end
  #--------------------------------------------------------------------------
  def battler_join
    if @battler.exist? && !@battler_visible
      return if !@battler.exist? and @battler.is_a?(Game_Enemy)
      if @battler.revival && @anime_flug
        return @battler.revival = false 
      elsif @battler.revival && !@anime_flug
        @battler.revival = false
        return self.visible = true
      end  
      @anime_flug = true if @battler.actor? && !NO_ANIM_BATTLER
      @anime_flug = true if !@battler.actor? && @battler.anime_on
      make_battler 
      first_action if !@battler.actor? 
    end
    first_action if @battler.actor? and !@battler_visible
  end
  #--------------------------------------------------------------------------
  def update
    super
    return self.bitmap = nil && loop_animation(nil) if @battler == nil
    battler_join
    next_action
    update_battler_graphic
    update_anime_pattern
    update_target
    update_force_action
    update_move
    update_shadow if @shadow != nil
    @weapon_R.update if @weapon_action
    update_float if @float_time > 0
    update_angle if @angle_time > 0
    update_zoom if @zoom_time > 0
    update_mirage if @mirage_flug
    update_picture if @picture_time > 0
    update_move_anime if @anime_moving
    update_balloon if @balloon_duration <= 64
    damage_pop if @battler.damage_pop
    setup_new_effect
    update_effect
    update_battler_bitmap
  end
  #--------------------------------------------------------------------------
  def update_anime_pattern
    return @frame -= 1 if @frame != 0
    @weapon_R.action if @weapon_action && @weapon_R != nil
    if NEW_PATTERN_REPEAT
      if @pattern_back
        if @anime_loop == 0
          if @reverse
            @pattern -= 1
            @pattern = (@pattern < 0 ? @base_width - 1 : @pattern)
            if @pattern == -1
              @pattern_back = false 
              @anime_end = true
            end  
          else
            @pattern += 1
            @pattern = (@pattern > @base_width - 1 ? 0 : @pattern)
            if @pattern == @base_width
              @pattern_back = false 
              @anime_end = true
            end
          end
        else
          @anime_end = true
          if @anime_loop == 1
            @pattern = 0 if !@reverse
            @pattern = @base_width - 1 if @reverse
            @pattern_back = false
          end  
        end
      else
        if @reverse
          @pattern -= 1
          @pattern = (@pattern < 0 ? @base_width - 1 : @pattern)
          @pattern_back = true if @pattern == 0
        else
          @pattern += 1
          @pattern = (@pattern > @base_width - 1 ? 0 : @pattern)
          @pattern_back = true if @pattern == @base_width - 1
        end 
      end
    else
      if @pattern_back
        if @anime_loop == 0
          if @reverse
            @pattern += 1
            if @pattern == @base_width - 1
              @pattern_back = false 
              @anime_end = true
            end
          else  
            @pattern -= 1
            if @pattern == 0
              @pattern_back = false 
              @anime_end = true
            end  
          end  
        else
          @anime_end = true
          if @anime_loop == 1
            @pattern = 0 if !@reverse
            @pattern = @base_width - 1 if @reverse
            @pattern_back = false
          end  
        end  
      else
        if @reverse
          @pattern -= 1
          @pattern_back = true if @pattern == 0
        else  
          @pattern += 1
          @pattern_back = true if @pattern == @base_width - 1
        end  
      end
    end
    @frame = @anime_speed
    return if @anime_freeze
    return unless @anime_flug
    @sx = @pattern * @width
    @sy = @anime_kind * @height
    self.src_rect.set(@sx, @sy, @width, @height)
  end
  #--------------------------------------------------------------------------
  def update_target
    return if @battler.force_target == 0
    return if @battler.individual
    @target_battler = @battler.force_target[1]
    @battler.force_target = 0
  end  
  #--------------------------------------------------------------------------
  def update_force_action
    action = @battler.force_action
    return if action == 0
    @battler.force_action = 0
    return if @battler.active
    return collapse_action if action[0] == "N01collapse"
    return start_one_action(action[2],action[1]) if action[0] == "SINGLE"
    start_action(action[2])
    return if action[1] == ""
    @action.delete("End")
    @action.push(action[1])
    @action.push("End")
  end   
  #--------------------------------------------------------------------------
  def update_move
    if @move_speed_plus_x > 0
      @move_x += @moving_x
      @battler.move_x = @move_x
      @move_speed_plus_x -= 1
    elsif @move_speed_x > 0
      if @move_boost_x != 0
        @moving_x += @move_boost_x
      end  
      @move_x += @moving_x
      @battler.move_x = @move_x
      @move_speed_x -= 1
    end
    if @move_speed_plus_y > 0
      @move_y += @moving_y
      @battler.move_y = @move_y
      @move_speed_plus_y -= 1
    elsif @move_speed_y > 0
      if @move_boost_y != 0
        @moving_y += @move_boost_y 
      end
      @move_y += @moving_y
      @battler.move_y = @move_y
      @move_speed_y -= 1
    end
    if @jump_up != 0
      @jump_plus += @jump_up
      @battler.jump = @jump_plus
      @jump_up = @jump_up / 2
      @jump_time -= 1
      if @jump_time == 0 or @jump_up == @jump_sign
        @jump_down = @jump_up * 2 * @jump_sign * @jump_sign2
        @jump_time_plus += @jump_time * 2
        @jump_up = 0
        return
      end  
    end
    if @jump_down != 0 
      if @jump_time_plus != 0
        @jump_time_plus -= 1
      elsif @jump_down != @jump_size
        @jump_plus += @jump_down 
        @battler.jump = @jump_plus
        @jump_down = @jump_down * 2
        if @jump_down == @jump_size
          if @jump_flug
            @jump_flug = false
          else
            @jump_plus += @jump_down 
            @battler.jump = @jump_plus
            @jump_down = @jump_size = 0
          end
        end  
      end
    end
    self.x = @battler.position_x
    self.y = @battler.position_y
    self.z = @battler.position_z
  end
  #--------------------------------------------------------------------------
  def update_shadow
    @shadow.opacity = self.opacity
    @shadow.x = self.x + @shadow_plus_x
    @shadow.y = self.y + @shadow_plus_y - @jump_plus
  end
  #--------------------------------------------------------------------------
  def update_float
    @float_time -= 1
    @jump_plus += @float_up
    @battler.jump = @jump_plus
  end   
  #--------------------------------------------------------------------------
  def update_angle
    @angle += @angling
    self.angle = @angle
    @angle_time -= 1
    return @angle = 0 if @angle_time == 0
    self.angle = 0 if @angle_reset
  end  
  #--------------------------------------------------------------------------
  def update_zoom
    @zoom_x += @zooming_x
    @zoom_y += @zooming_y
    self.zoom_x = @zoom_x
    self.zoom_y = @zoom_y
    @zoom_time -= 1
    return if @zoom_time != 0
    @zoom_x = @zoom_y = 0
    self.oy = @height 
    self.zoom_x = self.zoom_y = 1 if @zoom_reset
  end  
  #--------------------------------------------------------------------------
  def update_mirage
    mirage(@mirage0) if @mirage_count == 1
    mirage(@mirage1) if @mirage_count == 3
    mirage(@mirage2) if @mirage_count == 5
    @mirage_count += 1
    @mirage_count = 0 if @mirage_count == 6
  end
  #--------------------------------------------------------------------------
  def update_picture
    @picture_time -= 1
    @picture.x += @moving_pic_x
    @picture.y += @moving_pic_y
  end  
  #--------------------------------------------------------------------------
  def update_move_anime
    @move_anime.update
    @anime_moving = false if @move_anime.finish?
    @move_anime.action_reset if @move_anime.finish?
  end  
  #--------------------------------------------------------------------------
  def setup_new_effect
    if @battler.blink
      blink_on
    else
      blink_off
    end
    if @battler.white_flash
      whiten
      @battler.white_flash = false
    end
    effects_update
    if not @battler_visible and @battler.exist?
      @effect_type = APPEAR
      @effect_duration = 16
      @battler_visible = true
    end
    if @battler_visible and @battler.hidden
      @effect_type = DISAPPEAR
      @effect_duration = 32
      @battler_visible = false
    end
    if @battler.collapse
      @effect_type = COLLAPSE
      @effect_duration = 48
      @battler.collapse = false
      @battler_visible = false
    end
    if @battler_visible && @battler.animation_id != 0
      animation = $data_animations[@battler.animation_id]
      @battler.animation_hit = true unless @battler.evaded or @battler.missed
      animation(animation, @battler.animation_hit)
      if @active_battler.is_a?(Game_Enemy)
        if @battler.actor? and @battler.anime_mirror
          @battler.anime_mirror = false
        elsif @battler.actor? and !@battler.anime_mirror
          @battler.anime_mirror = true 
        end
      end
      animation_mirror(@battler.anime_mirror)
      @battler.animation_id = 0
      @battler.anime_mirror = false
    end
  end
  #--------------------------------------------------------------------------
  def effects_update
    if @battler.damage == nil and @battler.state_animation_id != @state_animation_id and STATE_ANIM and @battler_visible 
      @state_animation_id = @battler.state_animation_id == nil ? 0 : @battler.state_animation_id
      loop_animation($data_animations[@state_animation_id])
    end
  end
  #--------------------------------------------------------------------------
  def update_effect
    if @effect_duration > 0
      @effect_duration -= 1
      case @effect_type
      when APPEAR
        update_appear
      when DISAPPEAR
        update_disappear
      when COLLAPSE
        update_collapse
      end
    end
  end
  #--------------------------------------------------------------------------
  def update_whiten
    self.blend_type = 0
    self.color.set(255, 255, 255, 128)
    self.opacity = 255
    self.color.alpha = 128 - (16 - @effect_duration) * 10
  end
  #--------------------------------------------------------------------------
  def update_appear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = (16 - @effect_duration) * 16
  end
  #--------------------------------------------------------------------------
  def update_disappear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 256 - (32 - @effect_duration) * 10
  end
  #--------------------------------------------------------------------------
  def update_collapse
    normal_collapse if @collapse_type == 2
    boss_collapse if @collapse_type == 3
  end
  #--------------------------------------------------------------------------
  def update_balloon
    @balloon_duration -= 1 if @balloon_duration > 0 && !@balloon_back
    @balloon_duration += 1 if @balloon_back
    if @balloon_duration == 64
      @balloon_back = false
      @balloon.visible = false
    elsif @balloon_duration == 0
      @balloon.visible = false if @balloon_loop == 0
      @balloon_back = true if @balloon_loop == 1
    end    
    @balloon.x = self.x
    @balloon.y = self.y
    @balloon.z = self.y
    @balloon.opacity = self.opacity
    sx = 7 * 32 if @balloon_duration < 12
    sx = (7 - (@balloon_duration - 12) / 8) * 32 unless @balloon_duration < 12
    @balloon.src_rect.set(sx, @balloon_id * 32, 32, 32)
    @balloon.visible = false if @battler.dead?
  end
  #--------------------------------------------------------------------------
  def update_battler_bitmap
    return if @graphic_change
    return if @battler.actor?
    if @battler.battler_name != @battler_name or @battler.battler_hue != @battler_hue
      @battler_name = @battler.battler_name
      @battler_hue = @battler.battler_hue
      make_battler
      self.opacity = 0 if @battler.dead? or @battler.hidden
    end
  end
  #--------------------------------------------------------------------------
  def action 
    return if @active_action == nil
    action = @active_action[0]
    return mirroring if action == "Invert"
    return angling if action == "angle"
    return zooming if action == "zoom"
    return mirage_on if action == "Afterimage ON"
    return mirage_off if action == "Afterimage OFF"
    return picture if action == "pic"
    return @picture.visible = false && @picture_time = 0 if action == "Clear image" 
    return graphics_change if action == "change"
    return battle_anime if action == "anime"
    return balloon_anime if action == "balloon"
    return sound if action == "sound"
    return $game_switches[@active_action[1]] = @active_action[2] if action == "switch"
    return variable if action == "variable"
    return two_swords if action == "Two Wpn Only"
    return non_two_swords if action == "One Wpn Only"
    return necessary if action == "nece"
    return derivating if action == "der"
    return individual_action if action == "Process Skill"
    return individual_action_end if action == "Process Skill End"
    return non_repeat if action == "Don't Wait"
    return @battler.change_base_position(self.x, self.y) if action == "Start Pos Change"
    return @battler.base_position if action == "Start Pos Return"
    return change_target if action == "target"
    return send_action(action) if action == "Can Collapse"
    return send_action(action) if action == "Cancel Action"
    return state_on if action == "sta+"
    return state_off if action == "sta-"
    return Graphics.frame_rate = @active_action[1] if action == "fps"
    return floating if action == "float"
    return eval(@active_action[1]) if action == "script"
    return force_action if @active_action.size == 4
    return reseting if @active_action.size == 5
    return moving if @active_action.size == 7
    return battler_anime if @active_action.size == 9
    return moving_anime if @active_action.size == 11
    return anime_finish if action == "End"
  end
  #--------------------------------------------------------------------------
  def mirroring  
    if self.mirror
      self.mirror = false
      @weapon_R.mirroring if @anime_flug
    else
      self.mirror = true
      @weapon_R.mirroring if @anime_flug
    end
  end  
  #--------------------------------------------------------------------------
  def angling  
    jump_reset
    @angle_time = @active_action[1]
    start_angle = @active_action[2]
    end_angle = @active_action[3]
    @angle_reset = @active_action[4]
    start_angle *= -1 if $back_attack
    end_angle *= -1 if $back_attack
    start_angle *= -1 if @battler.is_a?(Game_Enemy)
    end_angle *= -1 if @battler.is_a?(Game_Enemy)
    if @angle_time <= 0
      self.angle = end_angle
      return  @angle_time = 0
    end  
    @angling = (end_angle - start_angle) / @angle_time
    @angle = (end_angle - start_angle) % @angle_time + start_angle
  end
  #--------------------------------------------------------------------------
  def zooming  
    jump_reset
    @zoom_time = @active_action[1]
    zoom_x = @active_action[2] - 1
    zoom_y = @active_action[3] - 1
    @zoom_reset = @active_action[4]
    @zoom_x = @zoom_y = 1
    return @zoom_time = 0 if @zoom_time <= 0
    @zooming_x = zoom_x / @zoom_time
    @zooming_y = zoom_y / @zoom_time
  end  
  #--------------------------------------------------------------------------
  def mirage_on
    return if @battler.dead?
    @mirage0 = Sprite.new(self.viewport)
    @mirage1 = Sprite.new(self.viewport)
    @mirage2 = Sprite.new(self.viewport)
    @mirage_flug = true
    @mirage_count = 0
  end  
  #--------------------------------------------------------------------------
  def mirage(body)
    body.bitmap = self.bitmap.dup
    body.x = self.x
    body.y = self.y
    body.ox = self.ox
    body.oy = self.oy
    body.z = self.z
    body.mirror = self.mirror
    body.angle = @angle
    body.opacity = 160
    body.zoom_x = self.zoom_x
    body.zoom_y = self.zoom_y   
    body.src_rect.set(@sx, @sy, @width, @height) if @anime_flug
    body.src_rect.set(0, 0, @width, @height) unless @anime_flug
  end   
  #--------------------------------------------------------------------------
  def mirage_off
    @mirage_flug = false
    @mirage0.dispose if @mirage0 != nil
    @mirage1.dispose if @mirage1 != nil
    @mirage2.dispose if @mirage2 != nil
  end   
  #--------------------------------------------------------------------------
  def picture 
    pic_x = @active_action[1]
    pic_y = @active_action[2]
    pic_end_x = @active_action[3]
    pic_end_y = @active_action[4]
    @picture_time = @active_action[5]
    @moving_pic_x = (pic_end_x - pic_x)/ @picture_time
    @moving_pic_y = (pic_end_y - pic_y)/ @picture_time
    plus_x = (pic_end_x - pic_x)% @picture_time
    plus_y = (pic_end_y - pic_y)% @picture_time
    @picture.bitmap = RPG::Cache.picture(@active_action[7])
    @picture.x = pic_x + plus_x
    @picture.y = pic_y + plus_y
    @picture.z = 1
    @picture.z = 1900
    @picture.z = 3000 if @active_action[6]
    @picture.visible = true
  end 
  #--------------------------------------------------------------------------
  def graphics_change  
    return if @battler.is_a?(Game_Enemy)
    @battler_name = @active_action[2]
    @bitmap = RPG::Cache.character(@battler_name , @battler_hue) if WALK_ANIME
    @bitmap = RPG::Cache.character(@battler_name + "_1", @battler_hue) unless WALK_ANIME
    @width = @bitmap.width / @base_width
    @height = @bitmap.height / @base_height
    @battler.graphic_change(@active_action[2]) unless @active_action[1]
    @graphic_change = true
  end  
  #--------------------------------------------------------------------------
  def battle_anime
    return if @active_action[5] && !@battler.actor?
    return if @active_action[5] && @battler.weapons[1] == nil
    if @battler.actor?
      return if !@active_action[5] && @battler.weapons[0] == nil && @battler.weapons[1] != nil
    end
    anime_id = @active_action[1]
    if $back_attack
      mirror = true if @active_action[3] == false
      mirror = false if @active_action[3]
    end
    if anime_id < 0
      if @battler.current_action.kind == 1 && anime_id != -2
        anime_id = $data_skills[@battler.current_action.skill_id].animation2_id 
      elsif @battler.current_action.kind == 2 && anime_id != -2
        anime_id = $data_items[@battler.current_action.item_id].animation2_id
      else
        anime_id = NO_WEAPON
        if @battler.actor?
          weapon_id = @battler.weapon_id
          anime_id = UNARMED_ANIM
          anime_id = battler.weapons[0].animation2_id if battler.weapons[0] != nil
          anime_id = battler.weapons[1].animation2_id if @active_action[5]
        else
          weapon_id = @battler.weapon
          anime_id = $data_weapons[weapon_id].animation2_id if weapon_id != 0
        end
      end
      @wait = $data_animations[anime_id].frame_max if $data_animations[anime_id] != nil && @active_action[4]
      waitflug = true
      damage_action = [anime_id, mirror, true]
      return @battler.play = ["OBJ_ANIM",damage_action] if @battler.active
    end
    if @active_action[2] == 0 && $data_animations[anime_id] != nil
      @battler.animation_id = anime_id
      @battler.animation_hit = true
      @battler.anime_mirror = mirror
    elsif $data_animations[anime_id] != nil
      for target in @target_battler
        target.animation_id = anime_id
        target.anime_mirror = mirror
      end  
    end
    @wait = $data_animations[anime_id].frame_max if $data_animations[anime_id] != nil && @active_action[4] && !waitflug
  end
  #--------------------------------------------------------------------------
  def sound   
    pitch = @active_action[2] 
    vol =  @active_action[3]
    name = @active_action[4] 
    case @active_action[1]
    when "se"
      Audio.se_play("Audio/SE/" + name, vol, pitch)
    when "bgm"
      if @active_action[4] == ""
        now_bgm = RPG::BGM.last
        name = now_bgm.name
      end
      Audio.bgm_play("Audio/BGM/" + name, vol, pitch)
    when "bgs"
      if @active_action[4] == ""
        now_bgs = RPG::BGS.last
        name = now_bgs.name
      end
      Audio.bgs_play("Audio/BGS/" + name, vol, pitch)
    end
  end
  #--------------------------------------------------------------------------
  def balloon_anime
    return if self.opacity == 0
    if @balloon == nil
      @balloon = Sprite.new 
      @balloon.bitmap = RPG::Cache.picture("Balloon")
      @balloon.ox = @width / 16
      @balloon.oy = 320 / 10  + @height / 3 
    end
    @balloon_id = @active_action[1]
    @balloon_loop = @active_action[2]
    @balloon_duration = 64
    @balloon_back = false
    update_balloon
    @balloon.visible = true
    @balloon.visible = false unless BALLOON_ANIM
  end  
  #--------------------------------------------------------------------------
  def variable
    operand = @active_action[3]
    case @active_action[2]
    when 0
      $game_variables[@active_action[1]] = operand
    when 1
      $game_variables[@active_action[1]] += operand
    when 2
      $game_variables[@active_action[1]] -= operand
    when 3
      $game_variables[@active_action[1]] *= operand
    when 4
      $game_variables[@active_action[1]] /= operand
    when 5
      $game_variables[@active_action[1]] %= operand
    end
  end  
  #--------------------------------------------------------------------------
  def two_swords
    return @action.shift unless @battler.actor?
    return @action.shift if @battler.weapons[1] == nil
    active = @action.shift
    @active_action = ANIME[active]
    @wait = active.to_i if @active_action == nil
    action
  end
  #--------------------------------------------------------------------------
  def non_two_swords
    return unless @battler.actor?
    return @action.shift if @battler.weapons[1] != nil
    active = @action.shift
    @active_action = ANIME[active]
    @wait = active.to_i if @active_action == nil
    action
  end
  #--------------------------------------------------------------------------
  def necessary
    nece1 = @active_action[3]
    nece2 = @active_action[4]
    case @active_action[1]
    when 0
      target = [$game_party.actors[@battler.index]] if @battler.actor?
      target = [$game_troop.enemies[@battler.index]] if @battler.is_a?(Game_Enemy)
    when 1
      target = @target_battler
    when 2
      target = $game_troop.enemies
    when 3
      target = $game_party.actors
    end 
    return start_action(@battler.recover_action) if target.size == 0
    case @active_action[2]
    when 0
      state_on = true if nece2 > 0
      state_member = nece2.abs
      if nece2 == 0
        state_member = $game_party.actors.size if @battler.actor?
        state_member = $game_troop.enemies.size if @battler.is_a?(Game_Enemy)
      end  
      for member in target
        state_member -= 1 if member.state?(nece1)
      end
      if state_member == 0 && state_on
        return
      elsif state_member == nece2.abs
        return if state_on == nil
      end  
    when 1  
      num_over = true if nece2 > 0
      num = 0
      for member in target
        case  nece1
        when 0 
          num += member.hp
        when 1 
          num += member.mp
        when 2
          num += member.atk
        when 3 
          num += member.dex
        when 4
          num += member.agi
        when 5 
          num += member.int
        end
      end
      num = num / target.size
      if num > nece2.abs && num_over
        return
      elsif num < nece2.abs
        return if num_over == nil
      end
    when 2
      if $game_switches[nece1]
        return if nece2
      else
        return unless nece2
      end  
    when 3
      if nece2 > 0
        return if $game_variables[nece1] > nece2
      else
        return unless $game_variables[nece1] > nece2.abs
      end
    when 4
      skill_member = nece2.abs
      for member in target
        skill_member -= 1 if member.skill_learn?(nece1)
        return if skill_member == 0
      end  
    end 
    return @action = ["End"] if @non_repeat
    action = @battler.recover_action
    action = @battler.defence if @battler.guarding?
    return start_action(action)
  end  
  #--------------------------------------------------------------------------
  def derivating 
    return unless @active_action[2] && !@battler.skill_learn?(@active_action[3])
    return if rand(100) > @active_action[1]
    @battler.derivation = @active_action[3]
    @action = ["End"]
  end
  #--------------------------------------------------------------------------
  def individual_action
    @battler.individual = true
    @individual_act = @action.dup
    send_action(["Individual"])
    @individual_targets = @target_battler.dup
    @target_battler = [@individual_targets.shift]
  end
  #--------------------------------------------------------------------------
  def individual_action_end
    return @battler.individual = false if @individual_targets.size == 0
    @action = @individual_act.dup
    @target_battler = [@individual_targets.shift]
  end  
  #--------------------------------------------------------------------------
  def non_repeat
    @repeat_action = []
    @non_repeat = true
    anime_finish
  end  
  #--------------------------------------------------------------------------
  def change_target
    return @target_battler = @now_targets.dup if @active_action[2] == 3
    target = [@battler] if @active_action[2] == 0
    target = @target_battler.dup if @active_action[2] != 0
    if @active_action[2] == 2
      @now_targets = @target_battler.dup
      @target_battler = []
    end  
    if @active_action[1] >= 1000
      members = $game_party.actors if @battler.actor?
      members = $game_troop.enemies unless @battler.actor?
      index = @active_action[1] - 1000
      if index < members.size
        if members[index].exist? && @battler.index != index
          members[index].force_target = ["N01target_change", target]
          @target_battler = [members[index]] if @active_action[2] == 2
          change = true
        else
          for member in members
            next if @battler.index == member.index
            next unless member.exist?
            member.force_target = ["N01target_change", target]
            @target_battler = [member] if @active_action[2] == 2
            break change = true
          end
        end
      end
    elsif @active_action[1] > 0
      for member in $game_party.actors + $game_troop.enemies
        if member.state?(@active_action[1])
          member.force_target = ["N01target_change", target]
          @target_battler.push(member) if @active_action[2] == 2
          change = true
        end  
      end  
    elsif @active_action[1] < 0
      skill_id = @active_action[1].abs
      for actor in $game_party.actors
        if actor.skill_learn?(skill_id)
          actor.force_target = ["N01target_change", target]
          @target_battler.push(target) if @active_action[2] == 2
          change = true
        end  
      end
    else
      for member in @target_battler
        member.force_target = ["N01target_change", target]
        @target_battler.push(member) if @active_action[2] == 2
        change = true
      end
    end
    return if change
    return @action = ["End"] if @non_repeat
    return start_action(@battler.recover_action)
  end    
  #--------------------------------------------------------------------------
  def state_on
    state_id = @active_action[2]
    case @active_action[1]
    when 0
      @battler.add_state(state_id)
    when 1
      if @target_battler != nil
        for target in @target_battler
          target.add_state(state_id)
        end
      end
    when 2
      for target in $game_troop.enemies
        target.add_state(state_id)
      end
    when 3
      for target in $game_party.actors
        target.add_state(state_id)
      end
    when 4
      for target in $game_party.actors
        if target.index != @battler.index
          target.add_state(state_id)
        end  
      end
    end
    start_action(@battler.recover_action) unless @battler.movable?
  end 
  #--------------------------------------------------------------------------
  def state_off  
    state_id = @active_action[2]
    case @active_action[1]
    when 0
      @battler.remove_state(state_id)
    when 1
      if @target_battler != nil
        for target in @target_battler
          target.remove_state(state_id)
        end
      end
    when 2
      for target in $game_troop.enemies
        target.remove_state(state_id)
      end
    when 3
      for target in $game_party.actors
        target.remove_state(state_id)
      end
    when 4
      for target in $game_party.actors
        if target.index != @battler.index
          target.remove_state(state_id)
        end  
      end
    end
  end  
  #--------------------------------------------------------------------------
  def floating  
    jump_reset
    @jump_plus = @active_action[1]
    float_end = @active_action[2]
    @float_time = @active_action[3]
    @float_up = (float_end - @jump_plus)/ @float_time
    @wait = @float_time
    if @anime_flug
      move_anime = ANIME[@active_action[4]]
      if move_anime != nil
        @active_action = move_anime
        battler_anime
        @anime_end = true
      end 
    end
    @battler.jump = @jump_plus
  end      
  #--------------------------------------------------------------------------
  def force_action
    kind = @active_action[0]
    rebirth = @active_action[2]
    play = @active_action[3]
    action = [kind,rebirth,play]
    if @active_action[1] >= 1000
      members = $game_party.actors if @battler.actor?
      members = $game_troop.enemies unless @battler.actor?
      index = @active_action[1] - 1000
      if index < members.size
        if members[index].exist? && @battler.index != index
          return members[index].force_action = action
        else
          for target in members
            next if @battler.index == target.index
            next unless target.exist?
            force = true
            break target.force_action = action
          end
        end
      end
      return if force
      return @action = ["End"] if @non_repeat
      return start_action(@battler.recover_action)
    elsif @active_action[1] == 0
      for target in @target_battler
        target.force_action = action if target != nil
      end
    elsif @active_action[1] > 0
      for target in $game_party.actors + $game_troop.enemies
        target.force_action = action if target.state?(@active_action[1])
      end
    elsif @active_action[1] < 0  
      return if @battler.is_a?(Game_Enemy)
      for actor in $game_party.actors
        unless actor.id == @battler.id
          actor.force_action = action if actor.skill_id_learn?(@active_action[1].abs)
        end
      end
    end 
  end
  #--------------------------------------------------------------------------
  def reseting
    jump_reset
    self.angle = 0
    @distanse_x   = @move_x * -1
    @distanse_y   = @move_y * -1
    @move_speed_x = @active_action[1]
    @move_speed_y = @move_speed_x
    @move_boost_x = @active_action[2]
    @move_boost_y = @move_boost_x
    @jump         = @active_action[3]
    move_distance
    if @anime_flug
      move_anime = ANIME[@active_action[4]]
      if move_anime != nil 
        @active_action = move_anime
        battler_anime
      end 
      @anime_end = true
    end
  end
  #--------------------------------------------------------------------------
  def moving  
    jump_reset
    xx = @active_action[1]
    xx *= -1 if $back_attack
    case @active_action[0]
    when 0
      @distanse_x = xx
      @distanse_y = @active_action[2]
    when 1
      if @target_battler == nil
        @distanse_x = xx
        @distanse_y = @active_action[2]
      else
        target_x = 0
        target_y = 0
        time = 0
        for i in 0...@target_battler.size
          if @target_battler[i] != nil
            time += 1
            target_x += @target_battler[i].position_x
            target_y += @target_battler[i].position_y
          end  
        end 
        if time == 0
          @distanse_x = xx
          @distanse_y = @active_action[2]
        else  
          target_x = target_x / time
          target_y = target_y / time
          @distanse_y = target_y - self.y + @active_action[2]
          if @battler.actor?
            @distanse_x = target_x - self.x + xx
          else
            @distanse_x = self.x - target_x + xx
          end  
        end  
      end  
    when 2
      if @battler.actor?
        @distanse_x = xx - self.x
        @distanse_x = 640 + xx - self.x if $back_attack
      else
        @distanse_x = self.x - xx
        @distanse_x = self.x - (Graphics.width + xx) if $back_attack
      end 
      @distanse_y = @active_action[2] - self.y
    when 3
      if @battler.actor?
        @distanse_x = xx + @battler.base_position_x - self.x 
      else
        @distanse_x = xx + self.x - @battler.base_position_x
      end 
      @distanse_y = @active_action[2] + @battler.base_position_y - @battler.position_y
    end
    @move_speed_x = @active_action[3]
    @move_speed_y = @active_action[3]
    @move_boost_x = @active_action[4]
    @move_boost_y = @active_action[4]
    @jump         = @active_action[5]
    @jump_plus = 0
    move_distance
    if @anime_flug
      move_anime = ANIME[@active_action[6]]
      if move_anime != nil 
        @active_action = move_anime
        battler_anime
      end  
      @anime_end = true
    end
  end
  #--------------------------------------------------------------------------
  def move_distance
    if @move_speed_x == 0
      @moving_x = 0
      @moving_y = 0
    else  
      @moving_x = @distanse_x / @move_speed_x
      @moving_y = @distanse_y / @move_speed_y
      over_x = @distanse_x % @move_speed_x
      over_y = @distanse_y % @move_speed_y
      @move_x += over_x
      @move_y += over_y
      @battler.move_x = @move_x
      @battler.move_y = @move_y
      @distanse_x -= over_x
      @distanse_y -= over_y
    end  
    if @distanse_x == 0
      @move_speed_x = 0
    end
    if @distanse_y == 0
      @move_speed_y = 0
    end
    boost_x = @moving_x
    move_x = 0
    if @move_boost_x > 0 && @distanse_x != 0
      if @distanse_x == 0
        @move_boost_x = 0
      elsif @distanse_x < 0
        @move_boost_x *= -1
      end
      for i in 0...@move_speed_x
        boost_x += @move_boost_x
        move_x += boost_x
        over_distance = @distanse_x - move_x
        if @distanse_x > 0 && over_distance < 0
          @move_speed_x = i 
          break
        elsif @distanse_x < 0 && over_distance > 0
          @move_speed_x = i 
          break
        end 
      end
      before = over_distance + boost_x
      @move_speed_plus_x = (before / @moving_x).abs
      @move_x += before % @moving_x
      @battler.move_x = @move_x
    elsif @move_boost_x < 0 && @distanse_x != 0
      if @distanse_x == 0
        @move_boost_x = 0
      elsif @distanse_x < 0
        @move_boost_x *= -1
      end
      for i in 0...@move_speed_x
        boost_x += @move_boost_x
        move_x += boost_x
        lost_distance = @distanse_x - move_x
        before = lost_distance
        if @distanse_x > 0 && boost_x < 0
          @move_speed_x = i - 1
          before = lost_distance + boost_x
          break
        elsif @distanse_x < 0 && boost_x > 0
          @move_speed_x= i - 1
          before = lost_distance + boost_x
          break
        end
      end
      plus = before / @moving_x
      @move_speed_plus_x = plus.abs
      @move_x += before % @moving_x
      @battler.move_x = @move_x
    end
    boost_y = @moving_y
    move_y = 0
    if @move_boost_y > 0 && @distanse_y != 0
      if @distanse_y == 0
        @move_boost_y = 0
      elsif @distanse_y < 0
        @move_boost_y *= -1
      end
      for i in 0...@move_speed_y
        boost_y += @move_boost_y
        move_y += boost_y
        over_distance = @distanse_y - move_y
        if @distanse_y > 0 && over_distance < 0
          @move_speed_y = i 
          break
        elsif @distanse_y < 0 && over_distance > 0
          @move_speed_y = i 
          break
        end 
      end
      before = over_distance + boost_y
      @move_speed_plus_y = (before / @moving_y).abs
      @move_y += before % @moving_y
      @battler.move_y = @move_y
    elsif @move_boost_y < 0 && @distanse_y != 0
      if @distanse_y == 0
        @move_boost_y = 0
      elsif @distanse_y < 0
        @move_boost_y *= -1
      end
      for i in 0...@move_speed_y
        boost_y += @move_boost_y
        move_y += boost_y
        lost_distance = @distanse_y - move_y
        before = lost_distance
        if @distanse_y > 0 && boost_y < 0
          @move_speed_y = i 
          before = lost_distance + boost_y
          break
        elsif @distanse_y < 0 && boost_y > 0
          @move_speed_y = i 
          before = lost_distance + boost_y
          break
        end
      end
      plus = before / @moving_y
      @move_speed_plus_y = plus.abs
      @move_y += before % @moving_y
      @battler.move_y = @move_y
    end
    x = @move_speed_plus_x + @move_speed_x
    y = @move_speed_plus_y + @move_speed_y
    if x > y
      end_time = x
    else
      end_time = y
    end
    @wait = end_time
    if @jump != 0
      if @wait == 0
        @wait = @active_action[3]
      end  
      @jump_time = @wait / 2
      @jump_time_plus = @wait % 2
      @jump_sign = 0
      @jump_sign2 = 0
      if @jump < 0
        @jump_sign = -1
        @jump_sign2 = 1
        @jump = @jump * -1
      else
        @jump_sign = 1
        @jump_sign2 = -1
      end
      @jump_up = 2 ** @jump * @jump_sign
      if @jump_time == 0
        @jump_up = 0
      elsif @jump_time != 1
        @jump_size = @jump_up * @jump_sign * @jump_sign2
      else
        @jump_size = @jump_up * 2 * @jump_sign * @jump_sign2
        @jump_flug = true
      end  
    end
  end
  #--------------------------------------------------------------------------
  def battler_anime
    @anime_kind  = @active_action[1]
    @anime_speed = @active_action[2]
    @anime_loop  = @active_action[3]
    @unloop_wait = @active_action[4]
    @anime_end = true
    @reverse = false
    if @weapon_R != nil && @active_action[8] != ""
      weapon_kind = ANIME[@active_action[8]]
      two_swords_flug = weapon_kind[11]
      return if two_swords_flug && !@battler.actor?
      return if two_swords_flug && @battler.weapons[1] == nil && @battler.actor?
      if @battler.actor? && @battler.weapons[0] == nil && !two_swords_flug
        @weapon_R.action_reset
      elsif @battler.actor? && @battler.weapons[1] == nil && two_swords_flug
        @weapon_R.action_reset
      elsif !@battler.actor? && @battler.weapon == 0
        @weapon_R.action_reset
      else
        @weapon_R.action_reset
        if @active_action[5] != -1
          @weapon_R.freeze(@active_action[5])
        end
        @weapon_R.weapon_graphics unless two_swords_flug
        @weapon_R.weapon_graphics(true) if two_swords_flug
        @weapon_R.weapon_action(@active_action[8],@anime_loop)
        @weapon_action = true
        @weapon_R.action 
      end
    elsif @weapon_R != nil
      @weapon_R.action_reset
    end  
    @anime_end = false
    if @active_action[5] != -1 && @active_action[5] != -2
      @anime_freeze = true
      @anime_end = true
    elsif @active_action[5] == -2
      @anime_freeze = false
      @reverse = true
      @pattern = @base_width - 1
      if @weapon_action && @weapon_R != nil
        @weapon_R.action 
        @weapon_R.update
      end
    else  
      @anime_freeze = false
      @pattern = 0
      if @weapon_action && @weapon_R != nil
        @weapon_R.action 
        @weapon_R.update
      end
    end  
    @pattern_back = false
    @frame = @anime_speed
    @battler.move_z = @active_action[6]
    if @shadow != nil
      @shadow.visible = true if @active_action[7]
      @shadow.visible = false unless @active_action[7]
      @shadow.visible = false if @skip_shadow
    end
    file_name = ""
    unless @active_action[0] == 0
      file_name = "_" + @active_action[0].to_s
    end  
    return unless @anime_flug
    begin
      self.bitmap = RPG::Cache.character(@battler_name + file_name, @battler_hue)
    rescue
      self.bitmap = RPG::Cache.character(@battler_name, @battler_hue)
    end
    @sx = @pattern * @width
    @sy = @anime_kind * @height
    @sx = @active_action[5] * @width if @anime_freeze
    self.src_rect.set(@sx, @sy, @width, @height)
  end
  #--------------------------------------------------------------------------
  def moving_anime
    @move_anime.action_reset if @anime_moving
    @anime_moving = true
    mirror = false
    mirror = true if $back_attack
    id = @active_action[1]
    target = @active_action[2]
    x = y = mem = 0
    if target == 0
      if @target_battler == nil
        x = self.x
        y = self.y
      else
        if @target_battler[0] == nil
          x = self.x
          y = self.y
        else  
          x = @target_battler[0].position_x
          y = @target_battler[0].position_y
        end  
      end  
    elsif target == 1
      if @battler.actor?
        for target in $game_troop.enemies
          x += target.position_x
          y += target.position_y
          mem += 1
        end
        x = x / mem
        y = y / mem
      else
        for target in $game_party.actors
          x += target.position_x
          y += target.position_y
          mem += 1
        end
        x = x / mem
        y = y / mem
      end
    elsif target == 2
      if @battler.actor?
        for target in $game_party.actors
          x += target.position_x
          y += target.position_y
          mem += 1
        end
        x = x / mem
        y = y / mem
      else
        for target in $game_troop.enemies
          x += target.position_x
          y += target.position_y
          mem += 1
        end
        x = x / mem
        y = y / mem
      end
    else
      x = self.x
      y = self.y
    end  
    plus_x = @active_action[6]
    plus_y = @active_action[7]
    plus_x *= -1 if @battler.is_a?(Game_Enemy)
    distanse_x = x - self.x - plus_x
    distanse_y = y - self.y - plus_y
    type = @active_action[3]
    speed = @active_action[4]
    orbit = @active_action[5]
    if @active_action[8] == 0
      @move_anime.base_x = self.x + plus_x
      @move_anime.base_y = self.y + plus_y
    elsif @active_action[8] == 1 
      @move_anime.base_x = x + plus_x
      @move_anime.base_y = y + plus_y
      distanse_y = distanse_y * -1
      distanse_x = distanse_x * -1
    else 
      @move_anime.base_x = x
      @move_anime.base_y = y
      distanse_x = distanse_y = 0
    end
    if @active_action[10] == ""
      weapon = ""  
    elsif @anime_flug != true
      weapon = ""  
    else
      if @battler.actor?
        battler = $game_party.actors[@battler.index] 
        weapon_id = battler.weapon_id
      else  
        battler = $game_troop.enemies[@battler.index]
        weapon_id = battler.weapon
      end  
      weapon_act = ANIME[@active_action[10]].dup if @active_action[10] != ""
      if weapon_id != 0 && weapon_act.size == 3
        weapon_file = $data_weapons[weapon_id].flying_graphic
        if weapon_file == ""
          weapon_name = $data_weapons[weapon_id].graphic
          icon_weapon = false
          if weapon_name == ""
            weapon_name = $data_weapons[weapon_id].icon_name
            icon_weapon = true
          end  
        else
          icon_weapon = false
          weapon_name = weapon_file
        end
        weapon = @active_action[10]
      elsif weapon_act.size == 3
        weapon = ""
      elsif weapon_act != nil && $data_skills[@active_battler.current_action.skill_id] != nil
        icon_weapon = false
        weapon_name = $data_skills[@battler.current_action.skill.id].flying_graphic
        weapon = @active_action[10]
      end
    end
    @move_anime.z = 1
    @move_anime.z = 1000 if @active_action[9]
    @move_anime.anime_action(id,mirror,distanse_x,distanse_y,type,speed,orbit,weapon,weapon_name,icon_weapon)
  end  
  #--------------------------------------------------------------------------
  def anime_finish
    return individual_action_end if @individual_targets.size != 0
    send_action(@active_action[0]) if @battler.active
    mirage_off if @mirage_flug
    start_action(@repeat_action) unless @non_repeat
  end   
  #--------------------------------------------------------------------------
  def collapse_action
    @non_repeat = true
    @effect_type = COLLAPSE
    @collapse_type = @battler.collapse_type unless @battler.actor?
    @battler_visible = false unless @battler.actor?
    @effect_duration = COLLAPSE_WAIT + 32 if @collapse_type == 2
    @effect_duration = 360 if @collapse_type == 3
  end  
  #--------------------------------------------------------------------------
  def normal_collapse
    if @effect_duration == 31
      $game_system.se_play($data_system.enemy_collapse_se)
      self.blend_type = 1
      self.color.set(255, 64, 64, 255)
    end
    self.opacity = 256 - (48 - @effect_duration) * 6 if @effect_duration <= 31
  end  
  #--------------------------------------------------------------------------
  def boss_collapse
    if @effect_duration == 320
      Audio.se_play("Audio/SE/124-Thunder02", 100, 80)
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @effect_duration == 290
      Audio.se_play("Audio/SE/124-Thunder02", 100, 80)
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @effect_duration == 250
      Audio.se_play("Audio/SE/049-Explosion02",100, 50)
      reset
      self.blend_type = 1
      self.color.set(255, 128, 128, 128)
    end
    if @effect_duration < 250
      self.src_rect.set(0, @effect_duration - 250, @width, @height - @shadow.bitmap.height / 2)
      self.x += 10 if @effect_duration % 2 == 0
      self.opacity = @effect_duration - 20
      return if @effect_duration < 100
      Audio.se_play("Audio/SE/049-Explosion02",100, 50) if @effect_duration % 80 == 0
    end
  end
end