#==============================================================================
# Add-On: Overdrive
# by Atoa
# Based on KCG's Overdrive
#==============================================================================
# This Add-On adds an Overdrive/Limit Break system to the game.
# It works like this:
# A new bar is created, and gets filled up by many different actions, easily
# defined by you. When full, you can use special skills that you couldn't before.
#==============================================================================

module N01

  # IDs of the Overdrive skills.
  OD_Skills_ID = [119]
  
  # Name of the Overdrive bar graphic file. Must be on the Graphic/Windowskins folder.
  Overdrive_Meter = 'ODMeter'
  
  # Maximum value of the Overdrive Bar.
  Max_Overdrive = 1000
  
  # Overdrive gain ratio, change these values as you wish
  OD_Gain_Rate = [ 150, 300, 100, 100, 200, 150, 100,  30,  50, 150, 100] 
  #              [   A,   B,   C,   D,   E,   F,   G,   H,   I,   J,   K] 
  # A = Gain on attacking, varies depending on the amount of damage dealt
  # B = Gain when attacked, varies depending on the amount of damage received
  # C = Gain when attack is dodged
  # D = Gain when an attack misses
  # E = Gain when a battle is won
  # F = Gain after fleeing a battle
  # G = Gain on the beginning of a dead ally's turn
  # H = Gain at the beginning of an alive ally's turn
  # I = Fixed Gain at the beginning of the turn
  # J = Gain at the beginning of the turn if the character is almost dead
  # K = Gain if the character kills the target while attacking
  
  # Here you must set up the character's IDs according to the form that they
  # fill their OD meter. Only the character's that have their ID defined on a
  # certain way will fill their OD Meter like that. Remember, to assign at least
  # one kind of OD gain to each character, or it will never fill the OD meter.
  # Ex.:  DAMAGE_OD_PLUS = [4,5,8] Means that the characters 4, 5 e 8 will fill
  # their OD meter when receiving damage from an enemy
  #                        IDs of chars that gains OD:
  Attack_OD_Plus = [1,2] # when attacking
  Damage_OD_Plus = [3,4] # when being attacked
  Evade_OD_Plus  = [3]   # when dodge an attack
  Miss_OD_Plus   = [1]   # when miss an attack
  Win_OD_Plus    = [1]   # when a battle is won
  Escape_OD_Plus = [4]   # after a successful escape
  Dead_OD_Plus   = [3]   # in the begin fo turn for each dead ally
  Alive_OD_Plus  = [3,4] # in the begin fo turn for each alive ally
  Turn_OD_Plus   = [2,3] # fixed at the beginning of a turn
  Dying_OD_Plus  = [2,4] # in the begin of turn if near death
  Kill_OD_Plus   = [1,2] # if the character kills the target when attacks
  
  # OD Meter position on the Battle Status Window
  OD_Battle_Style = 0
  # 0 = Horizontal Pattern, not centralized
  # 1 = Horizontal Pattern, centralized
  # 2 = Vertical bars
  # 3 = Custom Position
  
  # Readjustment of the OD Meter's position on the Battle Status Window.  
  OD_X_Position = 0   # X position of the Meters
  OD_Y_Position = 112 # Y position of the Meters
  
  # Custom OD Bar position, only valid when OD_Battle_Style = 3
  OD_Custom_Position = [[460,180],[480,210],[500,240],[520,270]]
  
  # OD Meter position in main menu
  Menu_Style   = 1
  # 0 = Don't show
  # 1 = Above HP
  # 2 = Bellow name
  # 3 = Bellow level
  
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS Overdrive'] = true

#============================================================================== 
# ■ Game_Actor
#============================================================================== 
class Game_Actor < Game_Battler 
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def max_overdrive
    return Max_Overdrive
  end
  #--------------------------------------------------------------------------
  def overdrive
    return @overdrive == nil ? @overdrive = 0 : @overdrive
  end
  #--------------------------------------------------------------------------
  def overdrive=(n)
    @overdrive = [[n.to_i, 0].max, self.max_overdrive].min
  end
  #--------------------------------------------------------------------------
  def overdrive_full?
    return @overdrive == self.max_overdrive
  end
  #--------------------------------------------------------------------------
  def overdrive_update
    @overdrive = 0 if self.dead?
  end
end

#============================================================================== 
# ■ Window_Base
#============================================================================== 
class Window_Base < Window
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def draw_actor_overdrive(actor, x, y)
    @skin = RPG::Cache.windowskin(Overdrive_Meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(x , y, @skin, src_rect)    
    @line   = (actor.overdrive == actor.max_overdrive ? 2 : 1)
    @amount = 100 * actor.overdrive / actor.max_overdrive
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(x , y, @skin, src_rect2)
  end
end

#============================================================================== 
# ■ Game_Battler
#============================================================================== 
class Game_Battler 
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias acbs_skill_can_use_od skill_can_use?
  def skill_can_use?(skill_id)
    skill = $data_skills[skill_id]
    if self.actor? && skill != nil && OD_Skills_ID.include?(skill.id)
      return false unless self.overdrive_full?
    end
    acbs_skill_can_use_od(skill_id) 
  end  
  #-------------------------------------------------------------------------- 
  alias acbs_attack_effect_od attack_effect 
  def attack_effect(attacker) 
    effective = acbs_attack_effect_od(attacker)
    attack_od(attacker) if self.damage.is_a?(Numeric) 
    miss_od(attacker) if self.evaded or self.missed
    return effective
  end 
  #-------------------------------------------------------------------------- 
  alias perfect_acbs_attack_effect_od perfect_attack_effect 
  def perfect_attack_effect(attacker) 
    effective = perfect_acbs_attack_effect_od(attacker)
    attack_od(attacker) if self.damage.is_a?(Numeric) 
    miss_od(attacker) if self.evaded or self.missed
    return effective
  end 
  #-------------------------------------------------------------------------- 
  alias acbs_skill_effect_od skill_effect 
  def skill_effect(user, skill) 
    effective = acbs_skill_effect_od(user, skill) 
    attack_od(user) if self.damage.is_a?(Numeric) 
    miss_od(user) if self.evaded or self.missed
    return effective
  end
  #-------------------------------------------------------------------------- 
  alias perfect_acbs_skill_effect_od perfect_skill_effect 
  def perfect_skill_effect(user, skill) 
    effective = perfect_acbs_skill_effect_od(user, skill) 
    attack_od(user) if self.damage.is_a?(Numeric) 
    miss_od(user) if self.evaded or self.missed
    return effective
  end
  #-------------------------------------------------------------------------- 
  def attack_od(user)
    if user.actor? && !self.actor? && Attack_OD_Plus.include?(user.id) && self.damage > 0 
      od_up = [self.damage * OD_Gain_Rate[0] / (user.level + 10) / 50, 10].max
      user.overdrive += od_up
      user.overdrive += OD_Gain_Rate[10] if self.hp <= 0 and Kill_OD_Plus.include?(user.id)
    elsif !user.actor? && self.actor? && Damage_OD_Plus.include?(self.id) && self.damage > 0 
      od_up = [self.damage * OD_Gain_Rate[1] / self.maxhp, 1].max 
      self.overdrive += od_up
    end
  end
  #-------------------------------------------------------------------------- 
  def miss_od(user)
    if user.actor? && !self.actor? && Miss_OD_Plus.include?(user.id)
      user.overdrive += OD_Gain_Rate[3]
    elsif !user.actor? && self.actor? && Evade_OD_Plus.include?(self.id)
      self.overdrive += OD_Gain_Rate[2]
    end 
  end
end 

#==============================================================================
# ■ Window_Skill
#==============================================================================
class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = normal_color
      self.contents.font.color = crisis_color if OD_Skills_ID.include?(skill.id)
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == disabled_color ? 128 : 255
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    self.contents.draw_text(x + 232, y, 48, 32, skill.sp_cost.to_s, 2)
  end
end

#============================================================================== 
# ■ Window_BattleStatus
#============================================================================== 
class Window_BattleStatus < Window_Base 
  #-------------------------------------------------------------------------- 
  alias acbs_refresh_od refresh 
  def refresh 
    acbs_refresh_od
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      case OD_Battle_Style
      when 0
        meter_x = i * (624 / MAX_MEMBER) + OD_X_Position
        meter_y = OD_Y_Position
      when 1
        meter_x = OD_X_Position + ((624 / MAX_MEMBER) * ((4 - $game_party.actors.size)/2.0 + i)).floor
        meter_y = OD_Y_Position
      when 2
        meter_x = OD_X_Position
        meter_y = i * 32 + OD_Y_Position
      when 3
        meter_x = OD_Custom_Position[i][0]
        meter_y = OD_Custom_Position[i][1]
      end
      draw_actor_overdrive(actor, meter_x, meter_y)
    end
  end 
end 

#============================================================================== 
# ■ Window_MenuStatus
#============================================================================== 
class Window_MenuStatus < Window_Selectable
  #-------------------------------------------------------------------------- 
  alias acbs_refresh_od refresh 
  def refresh 
    acbs_refresh_od
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      x = 64
      y = i * 116
      draw_actor_overdrive(actor, x + 236, y + 12) if Menu_Style == 1
      draw_actor_overdrive(actor, x + 4, y + 24) if Menu_Style == 2
      draw_actor_overdrive(actor, x + 4, y + 56) if Menu_Style == 3
    end 
  end 
end 

#============================================================================== 
# ■ Window_Status
#============================================================================== 
class Window_Status < Window_Base 
  #-------------------------------------------------------------------------- 
  alias refresh_atoa_od refresh 
  def refresh 
    refresh_atoa_od
    draw_actor_overdrive(@actor, 96, 96) if Menu_Style != 0
  end
end

#============================================================================== 
# ■ Scene_Battle
#============================================================================== 
class Scene_Battle 
  #-------------------------------------------------------------------------- 
  include N01
  #-------------------------------------------------------------------------- 
  alias acbs_battle_end_od battle_end 
  def battle_end(result) 
    case result 
    when 0
      for actor in $game_party.actors 
        actor.overdrive += OD_Gain_Rate[4] if Win_OD_Plus.include?(actor.id) and actor.exist? 
      end 
    when 1 
      for actor in $game_party.actors 
        actor.overdrive += OD_Gain_Rate[5] if Escape_OD_Plus.include?(actor.id) and actor.exist? 
      end 
    end
    overdrive_update
    acbs_battle_end_od(result) 
  end 
  #-------------------------------------------------------------------------- 
  alias acbs_update_phase4_step2_atoa_od update_phase4_step2 
  def update_phase4_step2 
    if @active_battler.actor? 
      od_up = 0
      for actor in $game_party.actors 
        od_up += OD_Gain_Rate[6] if Dead_OD_Plus.include?(@active_battler.id) and actor.dead? 
        od_up += OD_Gain_Rate[7] if Dead_OD_Plus.include?(@active_battler.id) and !actor.dead? 
      end 
      od_up += OD_Gain_Rate[8] if Turn_OD_Plus.include?(@active_battler.id)
      od_up += OD_Gain_Rate[9] if Dying_OD_Plus.include?(@active_battler.id) and @active_battler.in_danger
      @active_battler.overdrive += od_up 
    end
    overdrive_update
    acbs_update_phase4_step2_atoa_od
  end 
  #-------------------------------------------------------------------------- 
  alias acbs_make_skill_action_result_atoa_od make_skill_action_result 
  def make_skill_action_result 
    acbs_make_skill_action_result_atoa_od
    @active_battler.overdrive = 0 if @active_battler.actor? && OD_Skills_ID.include?(@skill.id)
    overdrive_update
  end 
  #-------------------------------------------------------------------------- 
  alias acbs_update_phase4_step6_atoa_od update_phase4_step6
  def update_phase4_step6
    acbs_update_phase4_step6_atoa_od
    overdrive_update
  end
  #-------------------------------------------------------------------------- 
  def overdrive_update
    for actor in $game_party.actors do actor.overdrive_update end
    @status_window.refresh
  end
end

#============================================================================== 
# ■ Scene_Skill
#============================================================================== 
class Scene_Skill
  #-------------------------------------------------------------------------- 
  include N01
  #-------------------------------------------------------------------------- 
  alias update_skill_od_n01 update_skill
  def update_skill
    if Input.trigger?(Input::C)
      unless @skill == nil or not @actor.skill_can_use?(@skill.id) or @skill.scope >= 3
        @actor.overdrive = 0 if OD_Skills_ID.include?(@skill.id)
      end
    end
    update_skill_od_n01
  end
  #-------------------------------------------------------------------------- 
  def update_target
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @skill_window.active = true
      @target_window.visible = false
      @target_window.active = false
      return
    end
    if Input.trigger?(Input::C)
      unless @actor.skill_can_use?(@skill.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      if @target_window.index == -1
        used = false
        for i in $game_party.actors
          used |= i.skill_effect(@actor, @skill)
        end
      end
      if @target_window.index <= -2
        target = $game_party.actors[@target_window.index + 10]
        used = target.skill_effect(@actor, @skill)
      end
      if @target_window.index >= 0
        target = $game_party.actors[@target_window.index]
        used = target.skill_effect(@actor, @skill)
      end
      if used
        $game_system.se_play(@skill.menu_se)
        @actor.overdrive = 0 if OD_Skills_ID.include?(@skill.id)
        @actor.sp -= @actor.calc_sp_cost(@actor, @skill)
        @status_window.refresh
        @skill_window.refresh
        @target_window.refresh
        if $game_party.all_dead?
          $scene = Scene_Gameover.new
          return
        end
        if @skill.common_event_id > 0
          $game_temp.common_event_id = @skill.common_event_id
          $scene = Scene_Map.new
          return
        end
      end
      unless used
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
  end
end