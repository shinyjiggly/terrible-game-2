#==============================================================================
# Skill Overdrive
# By Atoa
#==============================================================================
# This Add-On adds an Overdrive/Limit Break system to the game.
# It works like this:
# A new bar is created, and gets filled up by many different actions, easily
# defined by you. You can set actions that consume specifica ammounts of 
# that bar.
#
# IMPORTANT:
#
# All actors starts with the overdrive DISABLES.
# to enable the overdrive of an actor, you must make an 'Script Call':
# $game_actors[ID].overdrive_unlock = true
#==============================================================================

module Atoa
  
  # Do not remove these lines
  Actor_Overdrive = {}
  Overdrive_Skills = {}
  Overdrive_Damage = {}
  Overdrive_Modifier = {}
  # Do not remove these lines
  
  # Name of the Overdrive bar graphic file. Must be on the Windowskins folder.
  Overdrive_Meter = 'ODMeter'
  
  # Name of the Overdrive bar back graphic file. Must be on the Windowskins folder.
  # Leave nil for no background
  Overdrive_Back = 'ODMeterBack'

  # Maximum value of the Overdrive Bar.
  Max_Overdrive = 1000
  
  # Add here the skills that consum overdritve to be activated
  # Overdrive_Skills[ID] = Cost
  # ID = Skill ID
  # Custo = Overdrive value used, numeric vaule. Can't be higher than the value
  # of 'Max_Overdrive', you can user the constante Max_Overdrive to set
  # an value equal the max (so the action will consum all bar)
  Overdrive_Skills[108] = Max_Overdrive
  
  # Add here skill that changes the target overdrive when causing damage
  # Overdrive_Damage[ID] = Damage
  # ID = ID da skill.
  # Damage = 'Damage' on the Overdrive bar. Changes with the damage caused.
  
  # Add here skills and weapons that haves an different overdrive gain rate
  # Overdrive_Modifier['Type'] = {ID => Modifier}
  # 'Type' = 'Weapons' for weapons, 'Skills' for skills
  # ID = ID of the skill/weapons
  # Modifier = Rate of overdrive gain. 100 = no change.
  Overdrive_Modifier['Skill'] = {92 => 20, 93 => 30, 126 => 10, 127 => 10, 128 => 150}

  # Initial Overdrive value for each actor
  # Actor_Overdrive[ID] = {Type => Value}
  Actor_Overdrive[1] = {'Heal' => 100,'Atk' => 100, 'Miss' => 200, 'Win' => 300, 'Kill' => 300, 'Crt Atk' => 200}
  Actor_Overdrive[2] = {'Mag' => 100,'Atk' => 100, 'Turn' => 50, 'Danger' => 150, 'Kill' => 300, 'Crt Dmg' => 250}
  Actor_Overdrive[3] = {'Mag' => 100,'Dmg' => 200, 'Eva' => 200, 'Dead' => 100, 'Alive' => 30, 'Turn' => 50, 'Crt Atk' => 200}
  Actor_Overdrive[4] = {'Heal' => 100, 'Dmg' => 200, 'Run' => 300, 'Alive' => 30, 'Danger' => 150, 'Crt Dmg' => 250}
  # The values not liste here will be = 0.
  # Values = 0 will represent no change on the overdrive.
  # You can even set negative values, so it will mean lost on overdrive.
  # You can change at any time the overdrive gain rate of an determined type of
  # overdrive of an actor.
  # just use this code: $game_actors[Actor ID].set_overdrive_gain(Type, Value}
  
  # Overdrive increase types
  # 'Atk' = Gain on attacking, varies depending on the damage dealt and level
  # 'Mag' = Gain on attacking with magic, varies depending on the damage dealt and level
  # 'Heal' = Gain on healing, varies depending on the heal and level
  # 'Atk Dmg' = Gain when attacked physically, varies depending on the damage received and level
  # 'Mag Dmg' = Gain when attacked with magic, varies depending on the damage received and level
  # 'Eva' = Gain when attack is dodged
  # 'Miss' = Gain when an attack misses
  # 'Win' = Gain when a battle is won
  # 'Run' = Gain after fleeing a battle
  # 'Dead' = Gain on the beginning of the turn for each dead ally
  # 'Alive' = Gain at the beginning of the turn for each alive ally
  # 'Turn' = Gain at the beginning of the turn
  # 'Danger' = Gain at the beginning of the turn if the character in danger
  # 'Kill' = Gain if the character kills the target while attacking
  # 'Crt Atk' = Gain when cause critical damage, varies depending on the damage dealt and level
  # 'Crt Dmg' = Gain when recive critical damage, varies depending on the damage received and level
  # 'Advantage' = Gain at the beginning of the turn if have more alive actors than enemies
  # 'Disvantage' = Gain at the beginning of the turn if have less alive actors than enemies

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
  
  # Color of the overdrive skill on the menu (only when they're avaliable) in RGB
  #  Overdrive_Color = [Red, Green, Blue]
  #  Leave nil for no color.
  Overdrive_Color = [255, 255, 0]
  
  # Number of lines of the Overdrive bar graphic
  Overdrive_Lines = 3
  
  # Line of the overdrive bar graphic used based on the value on the bar
  # Overdrive_Line_Value = { 'Condition' => Line}
  #  'Condition' = String with an condition that sets wich line will be shown.
  #    Must be an valid script condition, where actor.overdrive is the overdrive value
  #    It's need some knowledge on RGSS, don't mess with it if you don't know
  #  Line = Line of the Overdrive bar graphic used.
  #     
  Overdrive_Line_Value = {
    'actor.overdrive <= Max_Overdrive / 4' => 1,
    'actor.overdrive > Max_Overdrive / 4 and actor.overdrive < Max_Overdrive' => 2,
    'actor.overdrive == Max_Overdrive' => 3
  }

  # OD Meter position in main menu
  Menu_Style   = 1
  # 0 = Don't show
  # 1 = Above HP
  # 2 = Bellow name
  # 3 = Bellow level
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Overdrive'] = true

#==============================================================================
# ** RPG::Skill
#------------------------------------------------------------------------------
# Class that manage skills
#==============================================================================

class RPG::Skill
  #--------------------------------------------------------------------------
  # * Get overdrive cost
  #--------------------------------------------------------------------------
  def overdrive_cost
    return Overdrive_Skills[@id].nil? ? 0 : [Overdrive_Skills[@id], Max_Overdrive].min
  end
  #--------------------------------------------------------------------------
  # * Get overdrive damage
  #--------------------------------------------------------------------------
  def overdrive_dmg
    return Overdrive_Damage[@id].nil? ? 0 : Overdrive_Damage[@id]
  end
end

#============================================================================== 
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler 
  #--------------------------------------------------------------------------
  # * Applying Normal Attack Effects
  #     attacker : battler
  #--------------------------------------------------------------------------
  alias attack_effect_overdrive attack_effect
  def attack_effect(attacker)
    effective = attack_effect_overdrive(attacker)
    attack_overdrive(attacker, attacker.weapons[0]) if effective and attacker.target_damage[self].numeric? 
    miss_overdrive(attacker) if attacker.target_damage[self] == Miss_Message
    return effective
  end 
  #--------------------------------------------------------------------------
  # * Apply Skill Effects
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  alias skill_effect_overdrive skill_effect
  def skill_effect(user, skill)
    effective = skill_effect_overdrive(user, skill) 
    if skill.overdrive_cost == 0 and not check_include(skill, 'SPDAMAGE')
      attack_overdrive(user, skill) if user.target_damage[self].numeric? and not skill.magic?
      mag_overdrive(user, skill) if user.target_damage[self].numeric? and skill.magic?
      heal_overdrive(user, skill) if user.target_damage[self].numeric? and user.target_damage[self] < 0
      miss_overdrive(user) if user.target_damage[self] == Miss_Message
    end
    if skill.overdrive_dmg != 0 and not check_include(skill, 'SPDAMAGE')
      user.overdrive -= calc_od_change(user.target_damage[self], skill.overdrive_dmg).to_i
    end
    return effective
  end
  #-------------------------------------------------------------------------- 
  # * Attack overdrive gain
  #     user  : user
  #     skill : skill
  #-------------------------------------------------------------------------- 
  def attack_overdrive(user, skill = nil)
    if user.actor? and not self.actor? and user.target_damage[self] > 0
      user.overdrive += calc_od_change(user.target_damage[self], user.overdrive_gain['Atk'], skill).to_i
      user.overdrive += calc_od_change(user.target_damage[self], user.overdrive_gain['Crt Atk'], skill).to_i
      user.overdrive += user.overdrive_gain['Kill'] if self.hp <= 0
    elsif self.actor? and not user.actor? and user.target_damage[self] > 0
      self.overdrive += calc_od_change(user.target_damage[self], self.overdrive_gain['Atk Dmg']).to_i
      self.overdrive += calc_od_change(user.target_damage[self], self.overdrive_gain['Crt Dmg']).to_i
    end
  end
  #-------------------------------------------------------------------------- 
  # * Magic overdrive gain
  #     user  : user
  #     skill : skill
  #-------------------------------------------------------------------------- 
  def mag_overdrive(user, skill = nil)
    if user.actor? and not self.actor? and user.target_damage[self] > 0
      user.overdrive += calc_od_change(user.target_damage[self], user.overdrive_gain['Mag'], skill).to_i
    elsif self.actor? and not user.actor? and user.target_damage[self] > 0
      self.overdrive += calc_od_change(user.target_damage[self], self.overdrive_gain['Mag Dmg']).to_i
    end
  end
  #-------------------------------------------------------------------------- 
  # * Heal overdrive gain
  #     user  : user
  #     skill : skill
  #-------------------------------------------------------------------------- 
  def heal_overdrive(user, skill = nil)
    if user.actor? and user.target_damage[self] < 0 and skill.power < 0
      user.overdrive += calc_od_change(user.target_damage[self].abs, user.overdrive_gain['Heal'], skill).to_i
    elsif self.actor? and user.target_damage[self] < 0
      self.overdrive += calc_od_change(user.target_damage[self].abs, self.overdrive_gain['Recover']).to_i
    end
  end
  #-------------------------------------------------------------------------- 
  # * Overdrive change calc
  #    dmg    : damage
  #    gain   : base gain
  #    action : action
  #-------------------------------------------------------------------------- 
  def calc_od_change(dmg, gain, action = nil)
    if action != nil and Overdrive_Modifier[action.type_name] != nil and
       Overdrive_Modifier[action.type_name][action.id] != nil
      modifier = Overdrive_Modifier[action.type_name][action.id] / 100.0
    else
      modifier = 1.0
    end
    if dmg <= self.maxhp / 10
      return (gain * modifier * (dmg * 100 / (self.maxhp / 10.0)) / 100).to_i
    else
      value = (dmg > self.maxhp / 5) ? self.maxhp / 5 : dmg
      return (gain * modifier * (value * 100 / (self.maxhp / 10.0)) / 100).to_i
    end
  end
  #-------------------------------------------------------------------------- 
  # * Miss overdrive gain
  #     user  : user
  #-------------------------------------------------------------------------- 
  def miss_overdrive(user)
    if user.actor? and !self.actor?
      user.overdrive += user.overdrive_gain['Miss']
    elsif self.actor? and not user.actor?
      self.overdrive += self.overdrive_gain['Eva']
    end 
  end  
end

#============================================================================== 
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :overdrive_gain
  attr_accessor :overdrive_unlock
  attr_accessor :old_overdrive
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_overdrive setup
  def setup(actor_id)
    setup_overdrive(actor_id)
    set_initial_overdrive
    @overdrive_unlock = false
    @old_overdrive = overdrive
  end
  #--------------------------------------------------------------------------
  # * Set initial overtrive values
  #--------------------------------------------------------------------------
  def set_initial_overdrive
    @overdrive_gain = {}
    od_list =  ['Atk', 'Mag', 'Heal', 'Atk Dmg', 'Mag Dmg', 'Recover', 'Eva', 'Miss',
                'Win', 'Run', 'Dead', 'Alive', 'Turn', 'Danger', 'Kill', 'Crt Atk',
                'Crt Dmg', 'Advantage', 'Disvantage']
    for od in od_list
      if Actor_Overdrive[@actor_id] != nil and Actor_Overdrive[@actor_id].include?(od)
        @overdrive_gain[od] = Actor_Overdrive[@actor_id][od]
      else
        @overdrive_gain[od] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set overdrive gain
  #    type  : type
  #    value : value
  #--------------------------------------------------------------------------
  def set_overdrive_gain(type, value)
    @overdrive_gain[type] = value
  end
  #--------------------------------------------------------------------------
  # * Get Max Overdrive
  #--------------------------------------------------------------------------
  def max_overdrive
    return Max_Overdrive
  end
  #--------------------------------------------------------------------------
  # * Get Overdrive
  #--------------------------------------------------------------------------
  def overdrive
    return (@overdrive == nil or @overdrive_unlock == false) ? @overdrive = 0 : @overdrive
  end
  #--------------------------------------------------------------------------
  # * Overdrive change
  #     n : new value
  #--------------------------------------------------------------------------
  def overdrive=(n)
    n = 0 if @overdrive_unlock == false
    @overdrive = [[n.to_i, 0].max, self.max_overdrive].min
  end
  #--------------------------------------------------------------------------
  # * Ovedrive full flag
  #--------------------------------------------------------------------------
  def overdrive_full?
    return @overdrive == self.max_overdrive
  end
  #--------------------------------------------------------------------------
  # * Overdrive Update
  #--------------------------------------------------------------------------
  def overdrive_update
    @overdrive = 0 if self.dead? or @overdrive_unlock == false
  end
  #--------------------------------------------------------------------------
  # * Consume skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  alias consume_skill_cost_overdrive consume_skill_cost
  def consume_skill_cost(skill)
    consume_skill_cost_overdrive(skill)
    self.overdrive = [self.overdrive - skill.overdrive_cost, 0].max
  end 
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias skill_can_use_overdrive skill_can_use?
  def skill_can_use?(skill_id)
    return false unless self.overdrive >= $data_skills[skill_id].overdrive_cost
    return skill_can_use_overdrive(skill_id) 
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Overdrive
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_overdrive(actor, x, y)
    return unless actor.overdrive_unlock
    if Overdrive_Back != nil
      back = RPG::Cache.windowskin(Overdrive_Back)
      w = back.width
      h = back.height
      src_rect = Rect.new(0, 0, w, h)
      self.contents.blt(x, y, back, src_rect)
    end
    skin = RPG::Cache.windowskin(Overdrive_Meter)
    w = skin.width
    h = skin.height / Overdrive_Lines
    line   = set_line(actor)
    amount = 100 * actor.overdrive / actor.max_overdrive
    src_rect = Rect.new(0, line * h, w * amount / 100, h)
    self.contents.blt(x , y, skin, src_rect)
  end
  #--------------------------------------------------------------------------
  # * Set used line
  #     actor : actor
  #--------------------------------------------------------------------------
  def set_line(actor)
    for condition in Overdrive_Line_Value.keys
      return [Overdrive_Line_Value[condition] - 1, 0].max if eval(condition)
    end
    return 0
  end
end

#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
#  This window displays usable skills on the skill and battle screens.
#==============================================================================

class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # * Set skill text color
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias set_skill_color_overdrive set_skill_color
  def set_skill_color(skill_id)
    if @actor.skill_can_use?(skill_id) and Overdrive_Color != nil and
       skill.overdrive_cost > 0
      color = Overdrive_Color
      return Color.new(color[0], color[1], color[2])
    else
      return set_skill_color_overdrive(skill_id)
    end
  end
end

#============================================================================== 
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Base 
  #-------------------------------------------------------------------------- 
  # * Refresh
  #-------------------------------------------------------------------------- 
  alias refresh_overdrive refresh 
  def refresh 
    refresh_overdrive
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      case OD_Battle_Style
      when 0
        meter_x = i * (624 / Max_Party) + OD_X_Position
        meter_y = OD_Y_Position
      when 1
        meter_x = OD_X_Position + ((624 / Max_Party) * ((4 - $game_party.actors.size)/2.0 + i)).floor
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
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #-------------------------------------------------------------------------- 
  # * Refresh
  #-------------------------------------------------------------------------- 
  alias refresh_overdrive refresh 
  def refresh 
    refresh_overdrive
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
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base 
  #-------------------------------------------------------------------------- 
  # * Refresh
  #-------------------------------------------------------------------------- 
  alias refresh_overdrive refresh 
  def refresh 
    refresh_overdrive
    draw_actor_overdrive(@actor, 96, 96) if Menu_Style != 0
  end
end

#============================================================================== 
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle 
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose 3:abort)
  #--------------------------------------------------------------------------
  alias battle_end_overdrive battle_end
  def battle_end(result)
    case result 
    when 0
      for actor in $game_party.actors 
        actor.overdrive += actor.overdrive_gain['Win']
      end 
    when 1 
      for actor in $game_party.actors 
        actor.overdrive += actor.overdrive_gain['Run']
      end 
    end
    battle_end_overdrive(result) 
  end 
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_overdrive step2_part1
  def step2_part1(battler)
    if battler.actor? 
      for actor in $game_party.actors 
        battler.overdrive += battler.overdrive_gain['Dead'] if actor.dead? 
        battler.overdrive += battler.overdrive_gain['Alive'] if !actor.dead? and actor != battler
      end 
      battler.overdrive += battler.overdrive_gain['Turn']
      battler.overdrive += battler.overdrive_gain['Danger'] if battler.in_danger?
      battler.overdrive += battler.overdrive_gain['Advantage'] if party_diff > 0
      battler.overdrive += battler.overdrive_gain['Disvantage'] if party_diff < 0
    end
    step2_part1_overdrive(battler)
  end 
  #-------------------------------------------------------------------------- 
  # * Get difference between parties
  #-------------------------------------------------------------------------- 
  def party_diff
    party = enemies = 0
    for actor in $game_party.actors 
      party += 1 unless actor.dead?
    end
    for enemy in $game_troop.enemies
      enemies += 1 unless enemy.dead?
    end
    return party - enemies
  end
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  alias update_graphics_overdrive update_graphics
  def update_graphics
    update_graphics_overdrive
    overdrive_update
  end
  #--------------------------------------------------------------------------
  # * Update Overdrive
  #--------------------------------------------------------------------------
  def overdrive_update
    need_update = false
    for actor in $game_party.actors
      if actor.old_overdrive != actor.overdrive
        actor.old_overdrive = actor.overdrive
        need_update = true
        actor.overdrive_update 
        if $atoa_script['Atoa ATB'] and @active_battler != nil and
           @active_battler == actor and @active_battler.overdrive != @old_overdrive
          @old_overdrive = @active_battler.overdrive
          if @actor_command_window.active and @actor_command_window.visible
            phase3_setup_command_window
          elsif @skill_window != nil and @skill_window.active and @skill_window.visible
            @skill_window.refresh
          end
        end
      end
    end
    @status_window.refresh if need_update
  end
end