class Bitmap
if not method_defined?('original_draw_text')
alias original_draw_text draw_text
def draw_text(*arg)

  original_color = self.font.color.dup
  self.font.color = Color.new(0, 0, 0, 128)

  if arg[0].is_a?(Rect)
    arg[0].x += 2
    arg[0].y += 2
    self.original_draw_text(*arg)
    arg[0].x -= 2
    arg[0].y -= 2
  else
    arg[0] += 2
    arg[1] += 2
    self.original_draw_text(*arg)
    arg[0] -= 2
    arg[1] -= 2
  end

  self.font.color = original_color
  self.original_draw_text(*arg)

end
end
def gradation_rect(x, y, width, height, color1, color2, align = 0)
if align == 0
  for i in x...x + width
    red  = color1.red + (color2.red - color1.red) * (i - x) / (width - 1)
    green = color1.green +
            (color2.green - color1.green) * (i - x) / (width - 1)
    blue  = color1.blue +
            (color2.blue - color1.blue) * (i - x) / (width - 1)
    alpha = color1.alpha +
            (color2.alpha - color1.alpha) * (i - x) / (width - 1)
    color = Color.new(red, green, blue, alpha)
    fill_rect(i, y, 1, height, color)
  end
elsif align == 1
  for i in y...y + height
    red  = color1.red +
            (color2.red - color1.red) * (i - y) / (height - 1)
    green = color1.green +
            (color2.green - color1.green) * (i - y) / (height - 1)
    blue  = color1.blue +
            (color2.blue - color1.blue) * (i - y) / (height - 1)
    alpha = color1.alpha +
            (color2.alpha - color1.alpha) * (i - y) / (height - 1)
    color = Color.new(red, green, blue, alpha)
    fill_rect(x, i, width, 1, color)
  end
elsif align == 2
  for i in x...x + width
    for j in y...y + height
      red  = color1.red + (color2.red - color1.red) *
              ((i - x) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      green = color1.green + (color2.green - color1.green) *
              ((i - x) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      blue  = color1.blue + (color2.blue - color1.blue) *
              ((i - x) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      alpha = color1.alpha + (color2.alpha - color1.alpha) *
              ((i - x) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      color = Color.new(red, green, blue, alpha)
      set_pixel(i, j, color)
    end
  end
elsif align == 3
  for i in x...x + width
    for j in y...y + height
      red  = color1.red + (color2.red - color1.red) *
            ((x + width - i) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      green = color1.green + (color2.green - color1.green) *
            ((x + width - i) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      blue  = color1.blue + (color2.blue - color1.blue) *
            ((x + width - i) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      alpha = color1.alpha + (color2.alpha - color1.alpha) *
            ((x + width - i) / (width - 1.0) + (j - y) / (height - 1.0)) / 2
      color = Color.new(red, green, blue, alpha)
      set_pixel(i, j, color)
    end
  end
end
end
end

module RPG
class Sprite < ::Sprite
def damage(value, critical)
  dispose_damage
  if value.is_a?(Numeric)
    damage_string = value.abs.to_s
  else
    damage_string = value.to_s
  end
  bitmap = Bitmap.new(160, 48)
  bitmap.font.name = "Arial Black"
  bitmap.font.size = 32
  bitmap.font.color.set(0, 0, 0)
  bitmap.draw_text(-1, 12-1, 160, 36, damage_string, 1)
  bitmap.draw_text(+1, 12-1, 160, 36, damage_string, 1)
  bitmap.draw_text(-1, 12+1, 160, 36, damage_string, 1)
  bitmap.draw_text(+1, 12+1, 160, 36, damage_string, 1)
  if value.is_a?(Numeric) and value < 0
    bitmap.font.color.set(176, 255, 144)
  else
    bitmap.font.color.set(255, 255, 255)
  end
  bitmap.draw_text(0, 12, 160, 36, damage_string, 1)
  if critical
    bitmap.font.size = 20
    bitmap.font.color.set(0, 0, 0)
    bitmap.draw_text(-1, -1, 160, 20, "CRITICAL", 1)
    bitmap.draw_text(+1, -1, 160, 20, "CRITICAL", 1)
    bitmap.draw_text(-1, +1, 160, 20, "CRITICAL", 1)
    bitmap.draw_text(+1, +1, 160, 20, "CRITICAL", 1)
    bitmap.font.color.set(255, 255, 255)
    bitmap.draw_text(0, 0, 160, 20, "CRITICAL", 1)
  end
  @_damage_sprite = ::Sprite.new
  @_damage_sprite.bitmap = bitmap
  @_damage_sprite.ox = 80 + self.viewport.ox
  @_damage_sprite.oy = 20 + self.viewport.oy
  @_damage_sprite.x = self.x + self.viewport.rect.x
  @_damage_sprite.y = self.y - self.oy / 2 + self.viewport.rect.y
  @_damage_sprite.z = 3000
  @_damage_duration = 40
end
def animation(animation, hit)
  dispose_animation
  @_animation = animation
  return if @_animation == nil
  @_animation_hit = hit
  @_animation_duration = @_animation.frame_max
  animation_name = @_animation.animation_name
  animation_hue = @_animation.animation_hue
  bitmap = RPG::Cache.animation(animation_name, animation_hue)
  if @@_reference_count.include?(bitmap)
    @@_reference_count[bitmap] += 1
  else
    @@_reference_count[bitmap] = 1
  end
  @_animation_sprites = []
  if @_animation.position != 3 or not @@_animations.include?(animation)
    for i in 0..15
      sprite = ::Sprite.new
      sprite.bitmap = bitmap
      sprite.visible = false
      @_animation_sprites.push(sprite)
    end
    unless @@_animations.include?(animation)
      @@_animations.push(animation)
    end
  end
  update_animation
end
def loop_animation(animation)
  return if animation == @_loop_animation
  dispose_loop_animation
  @_loop_animation = animation
  return if @_loop_animation == nil
  @_loop_animation_index = 0
  animation_name = @_loop_animation.animation_name
  animation_hue = @_loop_animation.animation_hue
  bitmap = RPG::Cache.animation(animation_name, animation_hue)
  if @@_reference_count.include?(bitmap)
    @@_reference_count[bitmap] += 1
  else
    @@_reference_count[bitmap] = 1
  end
  @_loop_animation_sprites = []
  for i in 0..15
    sprite = ::Sprite.new
    sprite.bitmap = bitmap
    sprite.visible = false
    @_loop_animation_sprites.push(sprite)
  end
  update_loop_animation
end
def animation_set_sprites(sprites, cell_data, position)
  for i in 0..15
    sprite = sprites[i]
    pattern = cell_data[i, 0]
    if sprite == nil or pattern == nil or pattern == -1
      sprite.visible = false if sprite != nil
      next
    end
    sprite.visible = true
    sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
    if position == 3
      if self.viewport != nil
        sprite.x = self.viewport.rect.width / 2
        sprite.y = self.viewport.rect.height - 160
      else
        sprite.x = 320
        sprite.y = 240
      end
    else
      sprite.x = self.x + self.viewport.rect.x -
                  self.ox + self.src_rect.width / 2
      sprite.y = self.y + self.viewport.rect.y -
                  self.oy + self.src_rect.height / 2
      sprite.y -= self.src_rect.height / 4 if position == 0
      sprite.y += self.src_rect.height / 4 if position == 2
    end
    sprite.x += cell_data[i, 1]
    sprite.y += cell_data[i, 2]
    sprite.z = 2000
    sprite.ox = 96
    sprite.oy = 96
    sprite.zoom_x = cell_data[i, 3] / 100.0
    sprite.zoom_y = cell_data[i, 3] / 100.0
    sprite.angle = cell_data[i, 4]
    sprite.mirror = (cell_data[i, 5] == 1)
    sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
    sprite.blend_type = cell_data[i, 7]
  end
end
end
end

class Game_Actor < Game_Battler
def screen_x
  if self.index != nil
  n_split = [($game_party.actors.length * 0.5).ceil, 4].min
  case n_split
  when 1
    n_index = self.index * 2
  when 2
    if self.index < ($game_party.actors.length - 2)
      n_index = 0.5 + (2 * self.index)
    else
      if $game_party.actors.length == 3 then
        n_index = (self.index * 2) + 2
      elsif $game_party.actors.length == 4 then
        n_index = self.index * 2
      end
    end
  when 3
      n_index = self.index + (0.25 * (self.index + 1))
    if $game_party.actors.length == 5
    if self.index < 2
      n_index = self.index + (0.25 * (self.index + 1))
    else
      n_index = self.index + (0.25 * (self.index + 2)) + 1
    end
    end
  when 4
    n_index = self.index
    if $game_party.actors.length == 7
    if self.index < 3
      n_index = self.index
    else
      n_index = self.index + 1
    end
    end
  end
    return (n_index - ((n_index / 4).floor) * 4) * ((160 / (4)) / 5) + 480 + ((n_index / 4).floor * 60)
  else
    return 0
  end
end
#--------------------------------------------------------------------------
# ? ????? Y ?????
#--------------------------------------------------------------------------
def screen_y
  n_split = [($game_party.actors.length * 0.5).ceil, 4].min
  case n_split
  when 1
    n_index = self.index * 2
  when 2
    if self.index < ($game_party.actors.length - 2)
      n_index = 0.5 + (2 * self.index)
    else
      if $game_party.actors.length == 3 then
        n_index = (self.index * 2) + 2
      elsif $game_party.actors.length == 4 then
        n_index = self.index * 2
      end
    end
  when 3
      n_index = self.index + (0.25 * (self.index + 1))
    if $game_party.actors.length == 5
    if self.index < 2
      n_index = self.index + (0.25 * (self.index + 1))
    else
      n_index = self.index + (0.25 * (self.index + 2)) + 1
    end
    end
  when 4
    n_index = self.index
    if $game_party.actors.length == 7
    if self.index < 3
      n_index = self.index
    else
      n_index = self.index + 1
    end
    end
  end
  return (n_index - ((n_index / 4).floor) * 4) * ((160 / (4)) * 1.6) + 270 - ((n_index / 4).floor * (110 - (4 * 20)))
end
#--------------------------------------------------------------------------
# ? ????? Z ?????
#--------------------------------------------------------------------------
def screen_z
  # ??????????? Z ?????????
  if self.index != nil
    return self.index
  else
    return 0
  end
end
end

class Game_Enemy < Game_Battler
def screen_x
  n_split = [($game_troop.enemies.length * 0.5).ceil, 4].min
  case n_split
  when 1
    n_index = self.index * 2
  when 2
    if self.index < ($game_troop.enemies.length - 2)
      n_index = 0.5 + (2 * self.index)
    else
      if $game_troop.enemies.length == 3 then
        n_index = (self.index * 2) + 2
      elsif $game_troop.enemies.length == 4 then
        n_index = self.index * 2
      end
    end
  when 3
      n_index = self.index + (0.25 * (self.index + 1))
    if $game_troop.enemies.length == 5
    if self.index < 2
      n_index = self.index + (0.25 * (self.index + 1))
    else
      n_index = self.index + (0.25 * (self.index + 2)) + 2
    end
    end
  when 4
    n_index = self.index
    if $game_troop.enemies.length == 7
    if self.index < 3
      n_index = self.index
    else
      n_index = self.index + 1
    end
    end
  end
  return (n_index - ((n_index / 4).floor) * 4) * ((-160 / (4)) / 5) + 160 - ((n_index / 4).floor * 60)
end
#--------------------------------------------------------------------------
# ? ????? Y ?????
#--------------------------------------------------------------------------
def screen_y
  n_split = [($game_troop.enemies.length * 0.5).ceil, 4].min
  case n_split
  when 1
    n_index = self.index * 2
  when 2
    if self.index < ($game_troop.enemies.length - 2)
      n_index = 0.5 + (2 * self.index)
    else
      if $game_troop.enemies.length == 3 then
        n_index = (self.index * 2) + 2
      elsif $game_troop.enemies.length == 4 then
        n_index = self.index * 2
      end
    end
  when 3
      n_index = self.index + (0.25 * (self.index + 1))
    if $game_troop.enemies.length == 5
    if self.index < 2
      n_index = self.index + (0.25 * (self.index + 1))
    else
      n_index = self.index + (0.25 * (self.index + 2)) + 1
    end
    end
  when 4
    n_index = self.index
    if $game_troop.enemies.length == 7
    if self.index < 3
      n_index = self.index
    else
      n_index = self.index + 1
    end
    end
  end
  return (n_index - ((n_index / 4).floor) * 4) * ((160 / (4)) * 1.6) + 270 - ((n_index / 4).floor * (110 - (4 * 20)))
end
#--------------------------------------------------------------------------
# ? ????? Z ?????
#--------------------------------------------------------------------------
def screen_z
  return @member_index + 1
end
end

#==============================================================================
# Ã‚ ¦ Sprite_Battler
#------------------------------------------------------------------------------
#  ????????????????Game_Battler ???????????????
# ????????????????????
#==============================================================================

class Sprite_Battler < RPG::Sprite
#--------------------------------------------------------------------------
# ? ??????????
#--------------------------------------------------------------------------
attr_accessor :battler                  # ????
attr_accessor :moving        # Is the sprite moving?
attr_reader  :index
attr_accessor :target_index
attr_accessor :direction
attr_accessor :pattern
#--------------------------------------------------------------------------
# ? ?????????
#    viewport : ??????
#    battler  : ???? (Game_Battler)
#--------------------------------------------------------------------------
def initialize(viewport, battler = nil)
  super(viewport)
  change
  @old = Graphics.frame_count  # For the delay method
  @goingup = true    # Increasing animation? (if @rm2k_mode is true)
  @once = false      # Is the animation only played once?
  @animated = true  # Used to stop animation when @once is true
  self.opacity = 0
  @index = 0
  @pattern_b = 0
  @counter_b = 0
  @trans_sprite = Sprite.new
  @trans_sprite.opacity = 0
  @bar_hp_sprite = Sprite.new
  @bar_hp_sprite.bitmap = Bitmap.new(64, 10)
  @bar_sp_sprite = Sprite.new
  @bar_sp_sprite.bitmap = Bitmap.new(64, 10)
  @color1 = Color.new(0, 0, 0, 192)
  @color2 = Color.new(255, 255, 192, 192)
  @color3 = Color.new(0, 0, 0, 192)
  @color4 = Color.new(64, 0, 0, 192)
  @old_hp = -1
  @old_sp = -1
  @battler = battler
  @battler_visible = false
  @first = true
  @pattern = 0
  if $target_index == nil
    $target_index = 0
  end
  @battler.is_a?(Game_Enemy) ? enemy_pose(0, 1) : pose(0, 1)
end
#--------------------------------------------------------------------------
# ? ??
#--------------------------------------------------------------------------
def dispose
  if self.bitmap != nil
    self.bitmap.dispose
  end
  if @trans_sprite.bitmap != nil
    @trans_sprite.bitmap.dispose
  end
  @trans_sprite.dispose
  @bar_hp_sprite.bitmap.dispose
  @bar_hp_sprite.dispose
  @bar_sp_sprite.bitmap.dispose
  @bar_sp_sprite.dispose
  super
end

def change(frames = 0, delay = 0, offx = 0, offy = 0, startf = 0, once = false)
  @frames = frames
  @delay = delay
  @offset_x, @offset_y = offx, offy
  @current_frame = startf
  @once = once
  @goingup = true
  @animated = true
end
#--------------------------------------------------------------------------
# ? ??????
#--------------------------------------------------------------------------
def update
  bar_check = true if @_damage_duration == 1
  super
  @trans_sprite.blend_type = self.blend_type
  @trans_sprite.color = self.color
  if @_collapse_duration > 0
    @trans_sprite.opacity = self.opacity
  else
    @trans_sprite.opacity = [self.opacity, 160].min
  end
  if (@_damage_duration == 0 and bar_check == true) or @first == true
    @first = false if @first == true
    bar_check = false
    @bar_must_change = true
  end
  @bar_hp_sprite.opacity = self.opacity
  @bar_sp_sprite.opacity = self.opacity
  # ????? nil ???
  if @battler == nil
    self.bitmap = nil
    @trans_sprite.bitmap = nil
    loop_animation(nil)
    return
  end
  # ????????????????????
  if @battler.battler_name != @battler_name or
      @battler.battler_hue != @battler_hue
    # ????????????
    @battler_name = @battler.battler_name
    @battler_hue = @battler.battler_hue
    if @battler.is_a?(Game_Actor)
      @battler_name = @battler.character_name
      @battler_hue = @battler.character_hue
      @direction = 4
    else
      @direction = 6
    end
      self.bitmap = RPG::Cache.character(@battler_name, @battler_hue)
      @width = bitmap.width / 4
      @height = bitmap.height / 4
      @frame_width = @width
      @frame_height = @height
      self.ox = @width / 2
      self.oy = @height
      @pattern = @current_frame
      @direction = @offset_y
      sx = @pattern * @width
      sy = (@direction - 2) / 2 * @height
      self.src_rect.set(sx, sy, @width, @height)
      @current_frame = (@current_frame + 1) unless @frames == 0
      @animated = false if @current_frame == @frames and @once
      @current_frame %= @frames
      @trans_sprite.bitmap = self.bitmap
      @trans_sprite.ox = self.ox
      @trans_sprite.oy = self.oy
      @trans_sprite.src_rect.set(sx, sy, @width, @height)
    # ?????????????????? 0 ???
    if @battler.dead? or @battler.hidden
      self.opacity = 0
      @trans_sprite.opacity = 0
      @bar_hp_sprite.opacity = 0
      @bar_sp_sprite.opacity = 0
    end
  self.x = @battler.screen_x
  self.y = @battler.screen_y
  self.z = @battler.screen_z
end
change_sp_bar if @old_sp != @battler.sp
if delay(@delay) and @animated
    @pattern = @current_frame
    @direction = @offset_y
    sx = @pattern * @width
    sy = (@direction - 2) / 2 * @height
    self.src_rect.set(sx, sy, @width, @height)
    @current_frame = (@current_frame + 1) unless @frames == 0
    @animated = false if @current_frame == @frames and @once
    @current_frame %= @frames
    @trans_sprite.ox = self.ox
    @trans_sprite.oy = self.oy
    @trans_sprite.src_rect.set(sx, sy, @width, @height)
  end
  # ??????? ID ????????????
  if @battler.damage == nil and
      @battler.state_animation_id != @state_animation_id
    @state_animation_id = @battler.state_animation_id
    loop_animation($data_animations[@state_animation_id])
  end
  # ??????????????
  #if @battler.is_a?(Game_Actor) and @battler_visible
    # ???????????????????????
    #if $game_temp.battle_main_phase
      #self.opacity += 3 if self.opacity < 255
    #else
      #self.opacity -= 3 if self.opacity > 207
    #end
  #end
  # ??
  if @battler.blink
    blink_on
  else
    blink_off
  end
  # ??????
  unless @battler_visible
    # ??
    if not @battler.hidden and not @battler.dead? and
        (@battler.damage == nil or @battler.damage_pop)
      appear
      @battler_visible = true
    end
  end
  # ?????
  if @battler_visible
    # ??
    if @battler.hidden
      $game_system.se_play($data_system.escape_se)
      escape
      @trans_sprite.opacity = 0
      @battler_visible = false
    end
    # ??????
    if @battler.white_flash
      whiten
      @battler.white_flash = false
    end
    # ???????
    if @battler.animation_id != 0
      animation = $data_animations[@battler.animation_id]
      animation(animation, @battler.animation_hit)
      @battler.animation_id = 0
    end
    # ????
    if @battler.damage_pop
      damage(@battler.damage, @battler.critical)
      @battler.damage = nil
      @battler.critical = false
      @battler.damage_pop = false
    end
    if @bar_must_change == true
      @bar_must_change = false
      if @old_hp != @battler.hp
        change_hp_bar
      end
      if @battler.damage == nil and @battler.dead?
        if @battler.is_a?(Game_Enemy)
          $game_system.se_play($data_system.enemy_collapse_se)
        else
          $game_system.se_play($data_system.actor_collapse_se)
        end
        collapse
        @battler_visible = false
      end
    end
  end
  # ???????????
  @trans_sprite.x = self.x
  @trans_sprite.y = self.y
  @trans_sprite.z = self.z
  @bar_hp_sprite.x = @battler.screen_x - 32
  @bar_hp_sprite.y = @battler.screen_y - (@height +18) if @height != nil
  @bar_hp_sprite.z = 100
  @bar_sp_sprite.x = @battler.screen_x - 32
  @bar_sp_sprite.y = @battler.screen_y - (@height + 8) if @height != nil
  @bar_sp_sprite.z = 100
end

#--------------------------------------------------------------------------
# - Move the sprite
#  x : X coordinate of the destination point
#  y : Y coordinate of the destination point
#  speed : Speed of movement (0 = delayed, 1+ = faster)
#  delay : Movement delay if speed is at 0
#--------------------------------------------------------------------------
def move(x, y, speed = 1, delay = 0)
  @destx = x
  @desty = y
  @move_speed = speed
  @move_delay = delay
  @move_old = Graphics.frame_count
  @moving = true
end

#--------------------------------------------------------------------------
# - Move sprite to destx and desty
#--------------------------------------------------------------------------
def update_move
  return unless @moving
  movinc = @move_speed == 0 ? 1 : @move_speed
  if Graphics.frame_count - @move_old > @move_delay or @move_speed != 0
    self.x += movinc if self.x < @destx
    self.x -= movinc if self.x > @destx
    self.y += movinc if self.y < @desty
    self.y -= movinc if self.y > @desty
    @move_old = Graphics.frame_count
  end
  if @move_speed > 1  # Check if sprite can't reach that point
    self.x = @destx if (@destx - self.x).abs % @move_speed != 0 and
                        (@destx - self.x).abs <= @move_speed
    self.y = @desty if (@desty - self.y).abs % @move_speed != 0 and
                        (@desty - self.y).abs <= @move_speed
  end
  if self.x == @destx and self.y == @desty
    @moving = false
  end
end

#--------------------------------------------------------------------------
# - Pause animation, but still updates movement
#  frames : Number of frames
#--------------------------------------------------------------------------
def delay(frames)
  update_move
  if (Graphics.frame_count - @old >= frames)
    @old = Graphics.frame_count
    return true
  end
  return false
end

def change_hp_bar
  j = false
  @old_hp = @battler.hp if @old_hp == -1
  i = @old_hp
  loop do
    i -= 10
    if i < @battler.hp
      i = @battler.hp
      j = true
    end
    rate = i.to_f / @battler.maxhp
    @color5 = Color.new(80 - 24 * rate, 80 * rate, 14 * rate, 192)
    @color6 = Color.new(240 - 72 * rate, 240 * rate, 62 * rate, 192)
    @bar_hp_sprite.bitmap.clear
    @bar_hp_sprite.bitmap.fill_rect(0, 0, 64, 10, @color1)
    @bar_hp_sprite.bitmap.fill_rect(1, 1, 62, 8, @color2)
    @bar_hp_sprite.bitmap.gradation_rect(2, 2, 60, 6, @color3, @color4, 1)
    #@bar_hp_sprite.bitmap.fill_rect(2, 2, 60, 6, @color3)
    @bar_hp_sprite.bitmap.gradation_rect(2, 2, 64 * rate - 4, 6, @color5, @color6, 2)
    #@bar_hp_sprite.bitmap.fill_rect(2, 2, 64 * rate - 4, 6, @color5)
    @bar_hp_sprite.opacity = self.opacity
    Graphics.update
    if j == true
      j = false
      break
    end
  end
  @old_hp = @battler.hp
end

def change_sp_bar
  j = false
  @old_sp = @battler.sp if @old_sp == -1
  i = @old_sp
  loop do
    i -= 10
    if i < @battler.sp
      i = @battler.sp
      j = true
    end
    rate = i.to_f / @battler.maxsp
    @color7 = Color.new(14 * rate, 80 - 24 * rate, 80 * rate, 192)
    @color8 = Color.new(62 * rate, 240 - 72 * rate, 240 * rate, 192)
    @bar_sp_sprite.bitmap.clear
    @bar_sp_sprite.bitmap.fill_rect(0, 0, 64, 10, @color1)
    @bar_sp_sprite.bitmap.fill_rect(1, 1, 62, 8, @color2)
    @bar_sp_sprite.bitmap.gradation_rect(2, 2, 60, 6, @color3, @color4, 1)
    #@bar_hp_sprite.bitmap.fill_rect(2, 2, 60, 6, @color3)
    @bar_sp_sprite.bitmap.gradation_rect(2, 2, 64 * rate - 4, 6, @color7, @color8, 0)
    #@bar_hp_sprite.bitmap.fill_rect(2, 2, 64 * rate - 4, 6, @color5)
    @bar_sp_sprite.opacity = self.opacity
    Graphics.update
    if j == true
      j = false
      break
    end
  end
  @old_sp = @battler.sp
end

def enemy                                            #
  $target_index += $game_troop.enemies.size
  $target_index %= $game_troop.enemies.size
  return $game_troop.enemies[$target_index]          #
end                                                  #

def actor                                            #
  $target_index += $game_party.actors.size
  $target_index %= $game_party.actors.size
  return $game_party.actors[$target_index]            #
end

def index=(index)
  @index = index
  update
end

  def pose(number, frames = 4)
  case number
  when 0
    change(frames, 4, 0, 4, 0)
  when 1
    change(frames, 4, 0, 4)
  when 2
    change(frames, 4, 0, 6)
  else
    change(frames, 4, 0, 0, 0)
  end
end

  def enemy_pose(number ,enemy_frames = 4)
  case number
  when 0
    change(enemy_frames, 4, 0, 6, 0)
  when 1
    change(enemy_frames, 4, 0, 4)
  when 2
    change(enemy_frames, 4, 0, 6)
  else
    change(enemy_frames, 4, 0, 0, 0)
  end
end

def default_pose
  pose(0, 1)
end
end

#==============================================================================
# Ã‚ ¦ Spriteset_Battle
#------------------------------------------------------------------------------
#  ???????????????????????????? Scene_Battle ??
# ????????????
#==============================================================================

class Spriteset_Battle
#--------------------------------------------------------------------------
# ? ??????????
#--------------------------------------------------------------------------
attr_reader  :viewport1                # ????????????
attr_reader  :viewport2                # ????????????
attr_accessor :actor_sprites
attr_accessor :enemy_sprites
#--------------------------------------------------------------------------
# ? ?????????
#--------------------------------------------------------------------------
def initialize
  # ?????????
  @viewport1 = Viewport.new(0, 0, 640, 480)
  @viewport2 = Viewport.new(0, 0, 640, 480)
  @viewport3 = Viewport.new(0, 0, 640, 480)
  @viewport4 = Viewport.new(0, 0, 640, 480)
  @viewport2.z = 101
  @viewport3.z = 200
  @viewport4.z = 5000
  if $game_temp.battleback_name == ""
  @battleback_sprite = nil
  @tilemap = Tilemap.new(@viewport1)
  @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
  for i in 0..6
    autotile_name = $game_map.autotile_names[i]
    @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
  end
  @tilemap.map_data = $game_map.data
  @tilemap.priorities = $game_map.priorities
  else
  # ??????????????
  @tilemap = nil
  @battleback_sprite = Sprite.new(@viewport1)
  end
  # ????????????
  @enemy_sprites = []
  for enemy in $game_troop.enemies#.reverse
    @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
  end
  # ????????????
  @actor_sprites = []
  for j in 0..7
      # Ã† €™AÃ† €™NÃ† €™^Ã‚