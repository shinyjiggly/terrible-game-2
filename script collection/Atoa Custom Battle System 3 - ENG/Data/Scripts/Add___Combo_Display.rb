#==============================================================================
# Combo Display
# By Atoa
#==============================================================================
# This Scritp creates an display for the Hit and Damage Numbers
#==============================================================================

module Atoa  
  
  # Position of the actors hit display
  # Actor_Display_Position = [Position X, Position Y]
  Actor_Display_Position = [480, 72]
  
  # Position of the enemies hit display
  # Enemy_Display_Position = [Position X, Position Y]
  Enemy_Display_Position = [96, 72]
  
  # Set if enemy hit display will be shown
  Show_Enemy_Combo = true
  
  # Name of the graphic of the hit display, the image must be on the "Digits" folder.
  Display_Base_Image = "Hits"
  
  # Position adjust of the base image of the hit display
  # Display_Base_Adjust = [Position X, Position Y]
  Display_Base_Adjust = [12, 0]
  
  # Position adjust of the hits digits
  # Hits_Base_Adjust = [Position X, Position Y]
  Hits_Base_Adjust = [0, 0]

  # Sufix of the hits digits images, the images must be on the "Digits" folder.
  Hit_Image_Sufix = "_hit"
  
  # Distance adjust of the hits digits
  Hit_Digit_Distance = 8
  
  # Initial Zoom of the hit digits image when changed
  Hit_Zoom = 200

  # Exibir total de dano causado
  Show_Total_Damage = true
  
  # Position adjust of the damage digits
  # Dmg_Base_Adjust = [Position X, Position Y]
  Dmg_Base_Adjust = [12, 36]

  # Sufix of the hits digits images, the images must be on the "Digits" folder.
  Dmg_Image_Sufix = "_dmg"
  
  # Distance adjust of the damage digits
  Dmg_Digit_Distance = 6
  
  # Initial Zoom of the damage digits image when changed
  Dmg_Zoom = 200
    
  # Aditional damage, in %, for each hit made (after the first)
  Hit_Damage_Bonus = 5

  # Time, in frames, for the next attack to be considered an combo hit
  Hit_Time = 75
  
  # Time, in frames, that the display stay visible
  Display_Time = 50
  
  # Time, in frames, for the diplay to fade out
  Fade_Time = 25
  
  # Movement direction of the display when fading
  Fade_Direction = 0
  # 0 = No movement
  # 1 = Down
  # 2 = Left
  # 3 = Right
  # 4 = Up
  
  # Consider healing values an hit
  Heal_Hit = false
  
  # Show combo display at the first hit, if false, it will be shown only on the 2nd hit
  Show_First_Hit = true
  
  # Stop combo count when the battler action ends.
  Break_Combo = true
  
  # Adds hits for multiple target actions
  Add_Multi_Targets_Hits = true
  # If true, each hit on each target will add an hit, if false
  # each hit will add 1 hit, no matter the number of targets.
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Combo Hits'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :combo_hit
  attr_accessor :valid_hit
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_combohit initialize
  def initialize
    initialize_combohit
    @combo_hit = 0
    @valid_hit = false
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_combohit set_damage
  def set_damage(user, action = nil)
    set_damage_combohit(user, action)
    damage = user.target_damage[self]
    if damage.numeric? and (damage > 0 or (Heal_Hit and damage < 0))
      user.valid_hit = true
    end
    if damage.numeric?
      user.target_damage[self] = damage + (damage * (Hit_Damage_Bonus * user.combo_hit) / 100.0).to_i
    end
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Combo_Hit_Display
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :hits
  attr_accessor :dmg
  attr_accessor :display_time
  attr_accessor :fade_time
  attr_accessor :time
  attr_accessor :fade
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x    : window x-coordinate
  #     y    : window y-coordinate
  #     hits : hit number
  #--------------------------------------------------------------------------
  def initialize(x, y, hits)
    @digits = []
    @damage = []
    @hit_digt = Sprite.new
    @hit_digt.bitmap = RPG::Cache.digits(Display_Base_Image)
    @hit_digt.z = 4000
    @x = x
    @y = y
    @hits = hits
    @dmg = dmg
    @zoom_time = 0
    @display_time = 0
    @fade_time = 0
    @time = 0
    update
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @zoom_time -= 1 if @zoom_time > 0
    @display_time -= 1 if @display_time > 0
    @fade_time -= 1 if @fade_time > 0
    set_combo_sprites
    update_display_sprites
    set_fade_effect
  end
  #--------------------------------------------------------------------------
  # * Set combo sprites
  #--------------------------------------------------------------------------
  def set_combo_sprites
    if @old_hits != @hits or (Show_Total_Damage and @old_dmg != @dmg)
      @fade = false
      @old_hits = @hits
      @old_dmg = @dmg
      @fade_time = 0
      @zoom_time = [Hit_Zoom / 20, 1].max
      @display_time = Display_Time
      damage = @hits.to_s.split('')
      set_hit_sprites
      set_dmg_sprites
    end
  end
  #--------------------------------------------------------------------------
  # * Set hit display sprite
  #--------------------------------------------------------------------------
  def set_hit_sprites
    digits = @hits.to_s.split('')
    for i in 0...digits.size
      @digits[i] = Sprite.new if @digits[i].nil?
      @digits[i].bitmap = RPG::Cache.digits(digits[i].to_s + Hit_Image_Sufix)
      @digits[i].z = 4100
    end
    if @digits.size > digits.size 
      for i in digits.size...@digits.size
        @digits[i].dispose if @digits[i] != nil
        @digits[i] = nil
      end
    end
    @digits.compact!
  end
  #--------------------------------------------------------------------------
  # * Set damage display sprite
  #--------------------------------------------------------------------------
  def set_dmg_sprites
    damage = @dmg.to_s.split('')
    for i in 0...damage.size
      @damage[i] = Sprite.new if @damage[i].nil?
      @damage[i].bitmap = RPG::Cache.digits(damage[i].to_s + Dmg_Image_Sufix)
      @damage[i].z = 4000
    end
    if @damage.size > damage.size 
      for i in damage.size...@damage.size
        @damage[i].dispose if @damage[i] != nil
        @damage[i] = nil
      end
    end
    @damage.compact!
  end
  #--------------------------------------------------------------------------
  # * Update sprtes display
  #--------------------------------------------------------------------------
  def update_display_sprites
    if @zoom_time > 0
      @digits.compact!
      @damage.compact!
      for i in 0...@digits.size
        @digits[i].zoom_x = 1.0 + (@zoom_time * Hit_Zoom / 1000.0)
        @digits[i].zoom_y = 1.0 + (@zoom_time * Hit_Zoom / 1000.0)
        @digits[i].opacity = 255 - (@zoom_time * Hit_Zoom / 10.0)
        @digits[i].x = set_digit_x_pos(i, @digits.size)
        @digits[i].y = set_digit_y_pos(i)
        @hit_digt.x = @x + Display_Base_Adjust[0]
        @hit_digt.y = @y + Display_Base_Adjust[1]
        @hit_digt.opacity = 255
      end
      if Show_Total_Damage
        for i in 0...@damage.size
          @damage[i].zoom_x = 1.0 + (@zoom_time * Dmg_Zoom / 1000.0)
          @damage[i].zoom_y = 1.0 + (@zoom_time * Dmg_Zoom / 1000.0)
          @damage[i].opacity = 255 - (@zoom_time * Dmg_Zoom / 10.0)
          @damage[i].x = set_damage_x_pos(i, @damage.size)
          @damage[i].y = set_damage_y_pos(i)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Hits X Digit Postion
  #     index : index
  #     size  : size
  #--------------------------------------------------------------------------
  def set_digit_x_pos(index, size)
    w = @digits[index].bitmap.width / 2
    d = w + Hit_Digit_Distance
    return @x + (index * d) - (d  * size) + w - (w * @digits[index].zoom_x) + Hits_Base_Adjust[0]
  end
  #--------------------------------------------------------------------------
  # * Get Hits Y Digit Postion
  #     index : index
  #--------------------------------------------------------------------------
  def set_digit_y_pos(index)
    h = @digits[index].bitmap.height / 2
    return @y + h - (h * @digits[index].zoom_y) + Hits_Base_Adjust[1]
  end
  #--------------------------------------------------------------------------
  # * Get Damage X Digit Postion
  #     index : index
  #     size  : size
  #--------------------------------------------------------------------------
  def set_damage_x_pos(index, size)
    w = @damage[index].bitmap.width / 2
    d = w + Dmg_Digit_Distance
    return @x + (index * d) - (d  * size) + w - (w * @damage[index].zoom_x) + Dmg_Base_Adjust[0]
  end
  #--------------------------------------------------------------------------
  # * Get Damage Y Digit Postion
  #     index : index
  #--------------------------------------------------------------------------
  def set_damage_y_pos(index)
    h = @damage[index].bitmap.height / 2
    return @y + h - (h * @damage[index].zoom_y) + Dmg_Base_Adjust[1]
  end
  #--------------------------------------------------------------------------
  # * Set fade effect
  #--------------------------------------------------------------------------
  def set_fade_effect
    if @display_time == 0 and @fade_time == 0 and not @fade
      @fade_time = [Fade_Time, 1].max
      @fade = true
    end
    if @fade_time > 0
      dir = Fade_Direction
      mov = (Fade_Time - @fade_time) * 2
      x_plus = dir == 2 ? mov : dir == 3 ? -mov : 0
      y_plus = dir == 1 ? mov : dir == 4 ? -mov : 0
      opacity = (@hit_digt.opacity * @fade_time  / Fade_Time)
      for i in 0...@digits.size
        @digits[i].x = set_digit_x_pos(i, @digits.size) + x_plus
        @digits[i].y = set_digit_y_pos(i) + y_plus
        @hit_digt.x = @x + Display_Base_Adjust[0] + x_plus
        @hit_digt.y = @y + Display_Base_Adjust[1] + y_plus
        @digits[i].opacity = opacity
        @hit_digt.opacity = opacity
      end
      if Show_Total_Damage
        for i in 0...@damage.size
          @damage[i].x = set_damage_x_pos(i, @damage.size) + x_plus
          @damage[i].y = set_damage_y_pos(i) + y_plus
          @damage[i].opacity = opacity
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    for digit in @digits
      digit.dispose
    end
    if Show_Total_Damage
      for dmg in @damage
        dmg.dispose
      end
    end
    @hit_digt.dispose
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias start_combohit start
  def start
    start_combohit
    @actor_combo_time = 0
    @actor_combo_hit = 0
    @actor_combo_dmg = 0
    @enemy_combo_time = 0
    @enemy_combo_hit = 0
    @enemy_combo_dmg = 0
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_combohit terminate
  def terminate
    terminate_combohit
    @actor_combo_display.dispose if @actor_combo_display != nil
    @enemy_combo_display.dispose if @enemy_combo_display != nil
  end
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  alias update_graphics_combohit update_graphics
  def update_graphics
    update_graphics_combohit
    update_combo_hit_values
    set_actor_combo_hit
    set_enemy_combo_hit
  end
  #--------------------------------------------------------------------------
  # * Update combo hit values
  #--------------------------------------------------------------------------
  def update_combo_hit_values
    @actor_combo_time = [@actor_combo_time - 1, 0].max
    @enemy_combo_time = [@enemy_combo_time - 1, 0].max
    @actor_combo_hit = 0 if @actor_combo_time == 0
    @actor_combo_dmg = 0 if @actor_combo_time == 0
    @enemy_combo_hit = 0 if @enemy_combo_time == 0
    @enemy_combo_dmg = 0 if @enemy_combo_time == 0
  end
  #--------------------------------------------------------------------------
  # * Set Actor combo hit
  #--------------------------------------------------------------------------
  def set_actor_combo_hit
    if @actor_combo_hit > (Show_First_Hit ? 0 : 1) and @actor_combo_display.nil?
      pos = Actor_Display_Position.dup
      pos[0] = 640 - pos[0] if $atoa_script['Atoa Battle Advantage'] and $game_temp.invert_postion and Battle_Style == 0
      @actor_combo_display = Combo_Hit_Display.new(pos[0], pos[1], @actor_combo_hit)
    elsif @actor_combo_hit > (Show_First_Hit ? 0 : 1) and @actor_combo_display != nil
      @actor_combo_display.hits = @actor_combo_hit
      @actor_combo_display.dmg = @actor_combo_dmg
      @actor_combo_display.time = @actor_combo_time
    end
    update_actor_hit_display if @actor_combo_display != nil
  end
  #--------------------------------------------------------------------------
  # * Update actor hit display
  #--------------------------------------------------------------------------  
  def update_actor_hit_display
    @actor_combo_display.update
    if @actor_combo_display.fade_time == 0 and @actor_combo_display.display_time == 0 and
       @actor_combo_display.time == 0
      @actor_combo_display.dispose
      @actor_combo_display = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Set enemy combo hit
  #--------------------------------------------------------------------------
  def set_enemy_combo_hit
    if @enemy_combo_hit > (Show_First_Hit ? 0 : 1) and @enemy_combo_display.nil?
      pos = Enemy_Display_Position.dup
      pos[0] = 640 - pos[0] if $atoa_script['Atoa Battle Advantage'] and $game_temp.invert_postion and Battle_Style == 0
      @enemy_combo_display = Combo_Hit_Display.new(pos[0], pos[1], @enemy_combo_hit)
    elsif @enemy_combo_hit > (Show_First_Hit ? 0 : 1) and @enemy_combo_display != nil
      @enemy_combo_display.hits = @enemy_combo_hit
      @enemy_combo_display.dmg = @enemy_combo_dmg
    end
    update_enemy_hit_display if @enemy_combo_display != nil
  end
  #--------------------------------------------------------------------------
  # * Update enemy hit display
  #--------------------------------------------------------------------------  
  def update_enemy_hit_display
    @enemy_combo_display.update
    if @enemy_combo_display.fade_time == 0 and @enemy_combo_display.display_time == 0
      @enemy_combo_display.dispose
      @enemy_combo_display = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Make Result of Actions
  #     battler : battler
  #--------------------------------------------------------------------------
  alias make_results_combohit make_results
  def make_results(battler)
    battler.combo_hit = battler.actor? ? @actor_combo_hit : @enemy_combo_hit
    if $atoa_script['Atoa Combination'] and battler_in_combination(battler)
      for actor in battler.combination_battlers
        actor.combo_hit = battler.actor? ? @actor_combo_hit : @enemy_combo_hit
      end
    end
    make_results_combohit(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_combohit step5_part4
  def step5_part4(battler)
    step5_part4_combohit(battler)
    @actor_combo_time = 0 if Break_Combo and battler.actor?
    @enemy_combo_time = 0 if Break_Combo and not battler.actor?
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias combination_step5_part4_combohit combination_step5_part4 if $atoa_script['Atoa Combination']
  def combination_step5_part4(battler)
    combination_step5_part4_combohit(battler)
    @actor_combo_time = 0 if Break_Combo and battler.actor?
    @enemy_combo_time = 0 if Break_Combo and not battler.actor?
  end
  #--------------------------------------------------------------------------
  # * Set target damage
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  alias set_target_damage_combohit set_target_damage
  def set_target_damage(battler, target)
    if $atoa_script['Atoa Combination'] and battler_in_combination(battler)
      for actor in battler.combination_battlers
        battler.valid_hit = true if actor.valid_hit
      end
    end
    if battler.valid_hit and battler.actor?
      @actor_combo_hit += 1 unless Add_Multi_Targets_Hits
      for hit_target in battler.target_battlers
        damage = battler.target_damage[hit_target]
        if damage.numeric? and (damage > 0 or (Heal_Hit and damage < 0))
          @actor_combo_hit += 1 if Add_Multi_Targets_Hits
          @actor_combo_dmg += damage.abs
        end
      end
      @actor_combo_time = Hit_Time
    elsif battler.valid_hit and not battler.actor? and Show_Enemy_Combo
      @enemy_combo_hit += 1 unless Add_Multi_Targets_Hits
      for hit_target in battler.target_battlers
        damage = battler.target_damage[hit_target]
        if damage.numeric? and (damage > 0 or (Heal_Hit and damage < 0))
          @enemy_combo_hit += 1 if Add_Multi_Targets_Hits
          @enemy_combo_dmg += damage.abs
        end
      end
      @enemy_combo_time = Hit_Time
    end
    battler.valid_hit = false
    set_target_damage_combohit(battler, target)
  end
end