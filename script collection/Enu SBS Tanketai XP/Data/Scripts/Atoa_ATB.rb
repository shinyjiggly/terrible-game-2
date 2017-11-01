#==============================================================================
# Add-On: Atoa's Active Time Battle
# by Atoa
#==============================================================================
# This Add-On adds a time bar system to the game
# If you don't want to use this Add-ON, simply delete it
# The configurations are explained below
#==============================================================================

module N01  
  # Do not remove or change this line
  Cast_Time = {}
  # Do not remove or change this line

  # Waiting Mode
  Wait_Mode = 0
  # 0 = On Hold Battle: the bar stops to select actions, skills and itens
  # 1 = Semi On Hold Battle: the bar stop to select itens and skills.
  # 2 = 100% Active Battle: the bar will never stop.
  
  # Pause the bar when a battler is executing an action?
  Wait_Act_End = true
  
  # Show individual time bars for the battlers?
  Meters = true
  
  # Show a single bar that indicates the battler's action order?
  Bars = true
  
  # Battle Speed
  Speed = 10.0
  
  # Initial bar value modifier
  Atb_Initial_Value = 0
  
  # Multiplication rate of the initial bar value
  Atb_Initial_Rate  = 1.0
  
  # Definition of turn shifting.
  # This definition must be used for the duration of effects and
  # battle event conditions
  # This value does not count to enemies actions conditions
  Custom_Turn_Count = 0
  # 0 = By number of fighters
  # 1 = By number of executed actions
  # 2 = By time (in frames)
  
  # If 'Custom_Turn_Count = 1', define how many actions are equal to 1 turn
  Action_Turn_Count = 10
  
  # If 'Custom_Turn_Count = 2', define how much time (in frames) are equal to 1 turn
  Time_Tunr_Count = 1200 # 20 frames is about 1 second
  
  # Activate a timer for the casting of magical skills?
  Magic_Skill_Cast = true
  
  # Activate a timer for the casting of physical skills?
  Physical_Skill_Cast = true
  
  # Activate a timer for the casting of itens?
  Item_Cast = true
  
  # Set the escape style
  Escape_Type = 0
  # 0 = Escape options is shown on the character's action menu
  # 1 = Keep pressed the key set in Escape_Input to escape
  #     shows a message on the screen
  # 2 = Keep pressed the key set in Escape_Input to escape
  #     shows an escape bar
  
  # Key that must be pressed to escape
  Escape_Input = Input::A
  # Input::A  = Keyborard:Z
  # Input::B  = Keyborard:X
  # Input::C  = Keyborard:C
  # Input::X  = Keyborard:A
  # Input::Y  = Keyborard:S
  # Input::Z  = Keyborard:D
  # Input::L  = Keyborard:Q
  # Input::R  = Keyborard:W
 
  # Show the name for the escape option when Escape_Type = 0
  Escape_Name = 'Escape'
  
  # Escape message when Escape_Type = 1
  Escape_Message = 'Escaping...'
  Cant_Escape_Message = "Can't Escape!"
  
  # Time (in frames) needed to escape when Escape_Type > 0 
  # it is affected by the agility of characters and enemies
  Escape_Time = 600
  
  # Name of the graphic file when Escape_Type = 2
  Escape_Skin = 'ESCAPEMeter'
  
  # Position of the Fleeing Bar
  Escape_Meter_Pos_Type = 0
  # 0 = Above the characters
  # 1 = Upper-Mid of the screen
  # 2 = Custom position
  
  # Custom position of the Fleeing Bar when Escape_Meter_Pos_Type = 2
  Escape_Meter_Position = [240,64]
  
  # Time Bar configurations
  Meter_Skin  = 'ATBMeter' # Graphic file name that represents the bars
                           # must be on the Graphic/Windowskins folder
  
  # Position of the character's Time Bars
  Meter_Pos_Style = 0
  # 0 = Horizontal Pattern, not centralized
  # 1 = Horizontal Pattern, centralized
  # 2 = Vertical Bars
  # 3 = Under the characters
  # 4 = Custom
  
  # Readjust the Time Bar's position on the battle screen
  X_Meter = 12  # X position of the Bars
  Y_Meter = 360 # Y position of the Bars

  # Custom Time Bar position, only valid when Meter_Pos_Style = 4
  Meter_Position = [[460,180],[480,210],[500,240],[520,270]]

  # Coordinate 'Z' (height) of the Meter image if Meter_Pos_Style = 4
  Meter_Height = 500
  
  # Position of the enemie's Time Bars
  Enemy_Meter = 0
  # 0 = No time bars for the enemies
  # 1 = Under the enemy
  # 2 = Vertical list on the Side
  
  # Configuration of the Action Bars.
  Bar_Skin = 'ATBBar' # Name of the graphic file that represents the bar, must be
                      # on the Graphics/Windowskins folder
  X_Bar    = 128      # X position of the Bars
  Y_Bar    =  80      # Y position of the Bars
  
  # Name of the default graphic Icon for characters
  Default_Party_Icon = '050-Skill07'
  # Individual character's Icons
  # Must be configured on the following way: 'Battler file name' => 'Icon file name'
  Party_Icon = {
    '003-Fighter03' => 'Atoa-Icon',
    '008-Fighter08' => 'Kahh-Icon',
    '040-Mage08' => 'Herena-Icon',
    '035-Mage03' => 'Tunicoelp-Icon',
  }
  
  # Name of the default graphic Icon for enemies
  Default_Enemy_Icon = '046-Skill03' 
  # Individual icons for enemies
  # must be configured on the following way: 'Battler file name' => 'Icon file name'
  Enemy_Icon = {
  '003-Fighter03' => 'Ash-Icon',
  '049-Soldier01' => 'Soldier-Icon',
  }
  
  # Sound effect played when teh character's turn comes.
  Command_Up_SE = '046-Book01'
    
  # ATB's maximum value, only change if you know what you doing.
  Max_Atb = 60000
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CAST SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  # Default cast pose
  Casting_Pose_Default = "WAIT"
  
  # Individual cast pose
  # Casting_Pose = { Actor ID => "Action Name"}
  Casting_Pose = { 3 => "GUARD_ATTACK", 4 => "WAIT-FLOAT"}
  
  # NOTE: The poses must be configurated on the main config.
  
  # Set here the cast time for each item and skill
  # By default all items have the cast speed = 0 (that means, no cast).
  #  
  #   Cast_Time[Action_Type] = {Action_ID => [Speed, status]}
  #     Action_Type = 'Skill' for skills, 'Item' for items
  #     Action_ID = ID of the skill or item
  #     Speed = cast speed, higher value = faster cast
  #       recomended values between 500-100
  #     Status = The status that the cast speed is based
  #       if nil, the cast will have fixed speed
  #       the status can be:
  #         'hp', 'sp', 'level', 'str', 'dex', 'int', 'agi'

  Cast_Time['Skill'] = {1 => [500,'int'], 2 => [400,'int'], 3 => [300,'int'], 
    7 => [500,'int'], 8 => [400,'int'], 9 => [300,'int'], 10 => [500,'int'], 
    11 => [400,'int'], 12 => [300,'int'], 13 => [500,'int'], 14 => [400,'int'], 
    15 => [300,'int'], 16 => [500,'int'], 17 => [400,'int'], 18 => [300,'int'], 
    19 => [500,'int'], 20 => [400,'int'], 21 => [300,'int'], 22 => [500,'int'], 
    23 => [400,'int'], 24 => [300,'int'], 25 => [500,'int'], 26 => [400,'int'], 
    27 => [300,'int'], 28 => [500,'int'], 29 => [400,'int'], 30 => [300,'int']}
  
  Cast_Time['Item'] = {1 => [500,'int'], 2 => [500,'int'], 3 => [500,'int'], 
    7 => [500,'int'], 8 => [500,'int'], 9 => [500,'int'], 10 => [500,'int'], 
    11 => [500,'int'], 12 => [500,'int']}
  
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS ATB'] = true

#==============================================================================
# ■ RPG::Skill
#==============================================================================
class RPG::Skill
  #----------------------------------------------------------------------------
  include N01
  #----------------------------------------------------------------------------
  def cast_speed(battler)
    if Cast_Time != nil and Cast_Time['Skill'] != nil and Cast_Time['Skill'][@id] != nil
      cast1 = Cast_Time['Skill'][@id][0]
      if Cast_Time['Skill'][@id][1].nil?
        cast2 = 200
      else
        if Cast_Time['Skill'][@id][1] == 'level'
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") * 2) + 100
        elsif Cast_Time['Skill'][@id][1] == 'hp' or Cast_Time['Skill'][@id][1] == 'sp' 
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") / 50) + 100
        else
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") / 5) + 100
        end
      end
      return (cast1 * cast2).to_i
    end
    return 0
  end
end

#==============================================================================
# ■ RPG::Item
#==============================================================================
class RPG::Item
  #----------------------------------------------------------------------------
  include N01
  #----------------------------------------------------------------------------
  def cast_speed(battler)
    if Cast_Time != nil and Cast_Time['Item'] != nil and Cast_Time['Item'][@id] != nil
      cast1 = Cast_Time['Item'][@id][0]
      if Cast_Time['Item'][@id][1].nil?
        cast2 = 200
      else
        if Cast_Time['Item'][@id][1] == 'level'
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") * 2) + 100
        elsif Cast_Time['Item'][@id][1] == 'hp' or Cast_Time['Item'][@id][1] == 'sp' 
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") / 50) + 100
        else
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") / 5) + 100
        end
      end
      return cast1 * cast2
    end
    return 0
  end
end

#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  attr_accessor :max_escape_count
  attr_accessor :escape_count
  #--------------------------------------------------------------------------
  def escape_atb_linetype
    return 2 unless @battle_can_escape
    return 1 if @battle_can_escape
  end
  #--------------------------------------------------------------------------
  def escape_atb_lineamount
    return 100 * @escape_count / @max_escape_count if @battle_can_escape
    return 100 unless @battle_can_escape
  end
  #--------------------------------------------------------------------------
  def max_escape_count
    return @max_escape_count.nil? ? @max_escape_count = 0 : @max_escape_count
  end
  #--------------------------------------------------------------------------
  def escape_count
    return @escape_count.nil? ? @escape_count = 0 : @escape_count
  end
  #--------------------------------------------------------------------------
  def max_escape_count=(n)
    @max_escape_count = n
  end
  #--------------------------------------------------------------------------
  def escape_count=(n)
    @escape_count = n
  end
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :cast_action
  attr_accessor :cast_target
  attr_accessor :turn_count
  attr_accessor :guarding
  attr_accessor :passed
  #--------------------------------------------------------------------------
  alias acbs_initialize_atb initialize
  def initialize
    acbs_initialize_atb
    @cast_skill = @turn_count = 0
    @guarding = @passed = false
  end
  #--------------------------------------------------------------------------
  def atb_linetype
    return 4 if self.cast_action != nil and self.atb_full?
    return 3 if self.cast_action != nil
    return 2 if self.atb_full?
    return 1
  end
  #--------------------------------------------------------------------------
  def atb_lineamount
    return 0 if self.dead?
    return 100 * self.atb / self.max_atb
  end
  #--------------------------------------------------------------------------
  def atb_enemy_visible
    return 0 if self.dead? and Enemy_Meter > 0
    return 255
  end
  #--------------------------------------------------------------------------
  def max_atb
    return Max_Atb
  end
  #--------------------------------------------------------------------------
  def atb
    return @atb.nil? ? @atb = 0 : @atb
  end
  #--------------------------------------------------------------------------
  def atb=(n)
    @atb = [[n.to_i, 0].max, self.max_atb].min
  end
  #--------------------------------------------------------------------------
  def atb_preset
    percent = self.max_atb * Atb_Initial_Rate * (rand(64) + 16) * self.agi / total_agi / 240
    self.atb = Atb_Initial_Value + percent
  end
  #--------------------------------------------------------------------------
  def total_agi
    total = 0
    for battler in $game_party.actors + $game_troop.enemies
      total += battler.agi
    end
    return total
  end
  #--------------------------------------------------------------------------
  def atb_full?
    return @atb == self.max_atb
  end
  #--------------------------------------------------------------------------
  def atb_update
    if self.cast_action.nil?
      self.atb += Speed * (190 + rand(10)) * self.agi / total_agi
    else
      cast = cast_action.cast_speed(self)
      self.atb += Speed * cast / total_agi
    end
  end
  #--------------------------------------------------------------------------
  def casting
    if Casting_Pose[self.id] != nil
      return Casting_Pose[self.id]
    end
    return Casting_Pose_Default
  end
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  def inputable?
    return (self.atb_full? and super)
  end
end

#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  def movable?
    return (self.atb_full? and super)
  end
  #--------------------------------------------------------------------------
  def make_action
    self.current_action.clear
    return unless self.movable?
    available_actions = []
    rating_max = 0
    for action in self.actions
      n = @turn_count
      a = action.condition_turn_a
      b = action.condition_turn_b
      next if (b == 0 and n != a) or (b > 0 and (n < 1 or n < a or n % b != a % b))
      next if self.hp * 100.0 / self.maxhp > action.condition_hp
      next if $game_party.max_level < action.condition_level
      switch_id = action.condition_switch_id
      next if switch_id > 0 and $game_switches[switch_id] == false
      available_actions << action
      rating_max = action.rating if action.rating > rating_max
    end
    ratings_total = 0
    for action in available_actions
      ratings_total += action.rating - (rating_max - 3) if action.rating > rating_max - 3
    end
    if ratings_total > 0
      value = rand(ratings_total)
      for action in available_actions
        if action.rating > rating_max - 3
          if value < action.rating - (rating_max - 3)
            self.current_action.kind = action.kind
            self.current_action.basic = action.basic
            self.current_action.skill_id = action.skill_id
            self.current_action.decide_random_target_for_enemy
            return
          else
            value -= action.rating - (rating_max - 3)
          end
        end
      end
    end
  end
end

#==============================================================================
# ■ Game_System
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :wait_mode
  attr_accessor :action_wait
  #--------------------------------------------------------------------------
  alias acbs_initialize_atb initialize
  def initialize
    acbs_initialize_atb
    @wait_mode = Wait_Mode
    @action_wait = Wait_Act_End
  end
end

#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  def stand_by
    @repeat_action = @battler.normal
    @repeat_action = @battler.pinch if @battler.hp <= @battler.maxhp / 4
    @repeat_action = @battler.defence if @battler.defense_pose
    @repeat_action = @battler.casting if @battler.cast_action != nil
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
    action = @battler.defence if @battler.defense_pose
    action = @battler.casting if @battler.cast_action != nil
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
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias acbs_main_atb main
  def main
    turn_count_speed  
    @escape_ratio = 40
    $game_temp.escape_count = 0
    @escape_type, @escape_name = Escape_Type, Escape_Name
    @input_battlers, @action_battlers = [], []
    @input_battler, @action_battler = nil, nil
    @escaped = @update_turn_end = @action_phase = false
    acbs_main_atb
  end
  #--------------------------------------------------------------------------
  alias acbs_start_atb start
  def start
    acbs_start_atb
    add_bars
    for battler in $game_party.actors + $game_troop.enemies
      battler.turn_count = 0
      battler.atb = 0
      battler.atb_preset
      battler.cast_action = nil
      battler.cast_target = nil
      battler.defense_pose = false
    end
    for actor in $game_party.actors
      actor.atb = actor.max_atb - 1 if $preemptive
      actor.atb = 0 if $back_attack 
    end
    for enemy in $game_troop.enemies
      enemy.atb = 0 if $preemptive
      enemy.atb = enemy.max_atb - 1 if $back_attack 
    end
    update_meters
  end
  #--------------------------------------------------------------------------
  alias acbs_terminate_atb terminate
  def terminate
    acbs_terminate_atb
    remove_bars
  end
  #--------------------------------------------------------------------------
  def add_bars
    @atb_meters = ATB_Meters.new if Meters
    @atb_meters_enemy = ATB_Meters_Enemy.new if Enemy_Meter != 0 and Meters
    @atb_bars = ATB_Bars.new if Bars
  end
  #--------------------------------------------------------------------------
  def remove_bars
    @atb_meters.dispose if Meters
    @atb_bars.dispose if Bars
    @atb_meters_enemy.dispose if Enemy_Meter != 0 and Meters
  end
  #--------------------------------------------------------------------------
  alias acbs_update_atb update
  def update
    if @phase == 1
      $game_temp.battle_main_phase = true
      @actor_command_window.opacity = 0
      @phase = 0
    elsif @phase != 5
      @phase = 0
    end
    @event_running = true if $game_system.battle_interpreter.running?
    acbs_update_atb
    if $game_system.battle_interpreter.running?
      return
    elsif @event_running
      @status_window.refresh
      @event_running = false
    end
    return $scene = Scene_Gameover.new if $game_temp.gameover
    return update_phase5 if @phase == 5
    @event_running = true if $game_system.battle_interpreter.running?
    if @update_turn_end
      turn_ending 
      @update_turn_end = false
    end
    if Input.press?(Escape_Input) and @escape_type > 0 
      if $game_temp.battle_can_escape
        $game_temp.max_escape_count = update_phase2_escape_rate
        $game_temp.escape_count += 2 unless @wait_on
        @escaping = true
        if !@help_window.visible and @escape_type == 1
          @help_window.set_text('')
          @help_window.set_text(Escape_Message, 1)
        end
        if @escape_type == 2
          if @escape_atb_meters.nil?
            @escape_atb_meters = Escape_Meters.new
            @escape_meter_opacity = 0
            @escape_atb_meters.visible = true
          else @escape_atb_meters != nil
            @escape_atb_meters.opacity = 15 * @escape_meter_opacity
            @escape_meter_opacity = [@escape_meter_opacity + 1, 17].min
            @escape_atb_meters.refresh
          end
        end
        if $game_temp.escape_count >= $game_temp.max_escape_count
          $game_temp.escape_count = 0
          update_phase2_escape unless $game_party.all_dead?
        end
      else
        @help_window.set_text(Cant_Escape_Message, 1) if @escape_type == 1        
        if @escape_type == 2       
          if @escape_atb_meters.nil?
            @escape_atb_meters = Escape_Meters.new
            @escape_meter_opacity = 0
            @escape_atb_meters.visible = true
          else @escape_atb_meters != nil
            @escape_atb_meters.opacity = 15 * @escape_meter_opacity
            @escape_meter_opacity = [@escape_meter_opacity + 1, 17].min
            @escape_atb_meters.refresh
          end
        end
      end
    elsif @escape_type > 0
      if @escaping
        @escaping = false
        @help_window.visible = false
      end
      $game_temp.escape_count = [$game_temp.escape_count - 1, 0].max unless @wait_on
      if @escape_atb_meters != nil and $game_temp.escape_count == 0
        @escape_atb_meters.opacity = 15 * @escape_meter_opacity
        @escape_meter_opacity = [@escape_meter_opacity - 1, 0].max
        if @escape_meter_opacity == 0
          @escape_atb_meters.dispose 
          @escape_atb_meters = nil
        end
      end
      @escape_atb_meters.refresh if @escape_atb_meters != nil
    end
    return if @escaped
    atb_update
    input_battler_update(false)
    if @action_battlers[0] != nil && @action_battler.nil?
      @action_battlers.flatten!
      @action_battler = @action_battlers[0]
      if @action_battler.dead?
        @action_battler.atb = 0
        @action_battler = nil
      else
        start_phase4
      end
    end
    if @action_battler != nil && !@spriteset.effect?
      @active_battler = @action_battler
      update_phase4
    end
  end
  #--------------------------------------------------------------------------
  alias acbs_judge_atb judge
  def judge
    @end_battle = acbs_judge_atb
    return @end_battle
  end
  #--------------------------------------------------------------------------
  alias acbs_update_basic_atb update_basic
  def update_basic
    atb_update unless @battle_start
    input_battler_update(true)
    acbs_update_basic_atb
  end
  #--------------------------------------------------------------------------
  def input_battler_update(basic)
    for battler in  $game_troop.enemies + $game_party.actors
      if battler.atb_full? and battler != @action_battler and not
         @action_battlers.include?(battler)
        battler_turn(battler)
        break if Wait_Act_End and not battler.actor?
      end
    end
    if @input_battlers[0] != nil && @input_battler.nil? && !@wait_on
      @input_battlers.flatten!
      @input_battler = @input_battlers[0]
      if @input_battler.current_action.forcing || @input_battler.restriction == 2 || 
        @input_battler.restriction == 3
        if @input_battler.restriction == 2 || @input_battler.restriction == 3
          @input_battler.current_action.kind = 0
          @input_battler.current_action.basic = 0
        end
        @input_battler.defense_pose = false
        @action_battlers << @input_battler
        @input_battlers.shift
        @input_battler = nil
      elsif @input_battler.inputable?
        @actor_index = $game_party.actors.index(@input_battler)
        @input_battler.current_action.clear
        @input_battler.blink = true
      else
        @input_battler.atb_update
        @input_battlers.shift
        @input_battler = nil
      end
    end
    if @input_battler != nil
      @input_action = true if basic
      @now_battler = @active_battler
      @active_battler = @input_battler
      @input_battler.defense_pose = false
      phase3_setup_command_window if @actor_command_window.opacity == 0
      update_phase3
      @active_battler = @now_battler
      @input_action = false if basic
    end
    for battler in $game_party.actors + $game_troop.enemies
      if battler.dead? or not battler.exist?
        @input_battlers.delete(battler)
        @action_battlers.delete(battler)
      end
    end
  end
  #--------------------------------------------------------------------------
  def battler_turn(battler)
    battler.turn_count += 1
    if battler.is_a?(Game_Actor)
      if battler.inputable? and battler.cast_action.nil?
        @input_battlers << battler
      else
        if battler.restriction == 2 || battler.restriction == 3
          battler.current_action.kind = 0
          battler.current_action.basic = 0
        end
        battler.defense_pose = false
        @action_battlers << battler
      end
    else
      battler.make_action
      @action_battlers << battler
    end
  end
  #--------------------------------------------------------------------------
  def atb_update
    @wait_on = wait_on
    return if @wait_on
    @atb_turn_count += 1 if Custom_Turn_Count == 2
    if @atb_turn_count >= @abt_turn_speed
      @update_turn_end = true
      $game_temp.battle_turn += 1
      turn_count_speed
      for battler in $game_party.actors + $game_troop.enemies
        battler.remove_states_auto if battler.exist?
      end
      setup_battle_event
    end
    for battler in $game_party.actors + $game_troop.enemies
      unless battler == @action_battler or
         (@escaping and battler.actor? and @escape_type > 0)
        battler.atb_update if battler.exist? and not battler.restriction == 4
      end
    end
    update_meters
  end
  #--------------------------------------------------------------------------
  def wait_on
    return true if $game_system.wait_mode == 1 and (@skill_window != nil or @item_window != nil)
    return true if $game_system.wait_mode == 0 and @input_battler != nil
    return true if $game_system.action_wait and @action_battler != nil
    return true if @force_wait or @battle_end or @escaped
    return false
  end
  #--------------------------------------------------------------------------
  def start_phase2
  end
  #--------------------------------------------------------------------------
  def update_meters
    @atb_meters.refresh if Meters
    @atb_meters_enemy.refresh if Enemy_Meter != 0 and Meters
    @atb_bars.refresh if Bars
  end
  #--------------------------------------------------------------------------
  def turn_count_speed
    @atb_turn_count = @abt_turn_speed = 0
    case Custom_Turn_Count
    when 0
      for battler in $game_party.actors + $game_troop.enemies
        @abt_turn_speed += 1 if battler.exist?
      end
    when 1
      @abt_turn_speed = Action_Turn_Count
    when 2
      @abt_turn_speed = Time_Tunr_Count
    end
  end
  #--------------------------------------------------------------------------
  def update_phase2_escape
    windows_dispose
    update_phase2_escape_type1 if @escape_type == 0 
    update_phase2_escape_type2 if @escape_type > 0
  end
  #--------------------------------------------------------------------------
  def update_phase2_escape_type1
    enemies_agi = enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    enemies_agi /= [enemies_number, 1].max
    actors_agi = actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    actors_agi /= [actors_number, 1].max
    @success = rand(100) < @escape_ratio * actors_agi / enemies_agi
    if @success
      @battle_end = true
      $game_system.se_play($data_system.escape_se)
      $game_system.bgm_play($game_temp.map_bgm)
      battle_end(1)
    else
      @escape_ratio += 3
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  def update_phase2_escape_type2
    @escaped = true
    @party_command_window.visible = false
    @party_command_window.active = false
    @actor_command_window.visible = false if @actor_command_window != nil
    @actor_command_window.active = false if @actor_command_window != nil
    wait(1)
    @battle_end = true
    $game_system.se_play($data_system.escape_se)
    $game_system.bgm_play($game_temp.map_bgm)
    if @escape_atb_meters != nil
      @escape_atb_meters.dispose 
      @escape_atb_meters = nil
    end
    battle_end(1)
  end
  #--------------------------------------------------------------------------
  def update_phase2_escape_rate
    enemies_agi = enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    enemies_agi /= [enemies_number, 1].max
    actors_agi = actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    actors_agi /= [actors_number, 1].max
    escape_rate = Escape_Time * enemies_agi / (actors_agi * Speed)
    return escape_rate
  end
  #--------------------------------------------------------------------------
  alias acbs_start_phase5_atb start_phase5
  def start_phase5
    if @input_battler != nil
      @help_window.visible = false if @help_window != nil
      windows_dispose
      @input_battler.blink = false if @input_battler != nil
    end
    @atb_meters.opacity = 0 if Meter_Pos_Style == 3
    update_meters
    acbs_start_phase5_atb
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase5_atb update_phase5
  def update_phase5
    windows_dispose
    acbs_update_phase5_atb
  end
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    return if @escaped
    if @active_battler != nil && @active_battler.cast_action != nil
      @active_battler.blink = false
      return    
    end
    Audio.se_play('Audio/SE/' + Command_Up_SE)    
    @party_command_window.active = false
    @party_command_window.visible = false
    @actor_command_window.dispose if @actor_command_window != nil
    s1 = $data_system.words.attack
    s2 = $data_system.words.skill
    s3 = $data_system.words.item
    s4 = $data_system.words.guard
    s5 = @escape_name
    if @escape_type == 0
      @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4, s5])  
    else
      @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])  
    end
    @actor_command_window.x = COMMAND_WINDOW_POSITION[0]
    @actor_command_window.y = COMMAND_WINDOW_POSITION[1]
    @actor_command_window.back_opacity = COMMAND_OPACITY
    @actor_command_window.z = 4500
    @active_battler_window.refresh(@active_battler)
    @active_battler_window.visible = BATTLER_NAME_WINDOW
    @active_battler_window.x = COMMAND_WINDOW_POSITION[0]
    @active_battler_window.y = COMMAND_WINDOW_POSITION[1] - 64
    @active_battler_window.z = 4500
  end
  #--------------------------------------------------------------------------
  alias acbs_start_enemy_select_atb start_enemy_select
  def start_enemy_select
    @teste = true
    acbs_start_enemy_select_atb
    @atb_meters.visible = true if Meters
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_skill_select_atb update_phase3_skill_select
  def update_phase3_skill_select
    @atb_meters.visible = false if Meters and Meter_Pos_Style < 3 and HIDE_WINDOW
    acbs_update_phase3_skill_select_atb
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_item_select_atb update_phase3_item_select
  def update_phase3_item_select
    @atb_meters.visible = false if Meters and Meter_Pos_Style < 3 and HIDE_WINDOW
    acbs_update_phase3_item_select_atb
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_start_actor_select_atb start_actor_select
  def start_actor_select
    acbs_start_actor_select_atb
    @atb_meters.visible = true if Meters
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_start_skill_select_atb start_skill_select
  def start_skill_select
    acbs_start_skill_select_atb
    @atb_meters.visible = false if Meters and Meter_Pos_Style < 3 and HIDE_WINDOW
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_end_skill_select_atb end_skill_select
  def end_skill_select
    acbs_end_skill_select_atb
    @atb_meters.visible = true if Meters
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_start_item_select_atb start_item_select
  def start_item_select
    acbs_start_item_select_atb
    @atb_meters.visible = false if Meters and Meter_Pos_Style < 3 and HIDE_WINDOW
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  alias acbs_end_item_select_atb end_item_select
  def end_item_select
    acbs_end_item_select_atb
    @atb_meters.visible = true if Meters
    update_meters unless Wait_Mode == 2
  end
  #--------------------------------------------------------------------------
  def phase3_next_actor
    @input_battler.blink = false
    action_battler = @input_battlers.shift
    @action_battlers << action_battler
    command_input_cancel
    @input_battler = nil
    @actor_index = nil
    @active_battler = nil
  end
  #--------------------------------------------------------------------------
  def phase3_prior_actor
    @input_battler.current_action.kind = 0
    @input_battler.current_action.basic = 3
    @input_battler.blink = false
    action_battler = @input_battlers.shift
    @action_battlers << action_battler
    @input_battler = nil
    @actor_index = nil
    @active_battler = nil
    windows_dispose
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_atb update_phase3
  def update_phase3
    if cancel_command?
      if can_act?
        if [2, 3].include?(@input_battler.restriction)
          @input_battler.current_action.kind = 0
          @input_battler.current_action.basic = 0
        end
        @action_battlers << @input_battler
      end
      command_input_cancel
      return
    end
    acbs_update_phase3_atb
  end
  #--------------------------------------------------------------------------
  def cancel_command?
    return false if @input_battler.nil?
    return true if @input_battler.current_action.forcing
    return true if [2, 3, 4].include?(@input_battler.restriction)
    return true if not $game_party.actors.include?(@input_battler)
    return false
  end
  #--------------------------------------------------------------------------
  def can_act?
    return true if @input_battler.current_action.forcing
    return true if [2, 3].include?(@input_battler.restriction)
    return false
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_basic_command_atb update_phase3_basic_command
  def update_phase3_basic_command
    if Input.trigger?(Input::C)
      case @actor_command_window.commands[@actor_command_window.index]
      when @escape_name
        if $game_temp.battle_can_escape == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        update_phase2_escape
        return
      end
    end
    if Input.trigger?(Input::UP) and @input_action
      $game_system.se_play($data_system.cursor_se)
      @actor_command_window.index -= 1
      if @actor_command_window.index <= -1   
        @actor_command_window.index = @actor_command_window.commands_size - 1
      end
      return
    end
    if Input.trigger?(Input::DOWN) and @input_action
      $game_system.se_play($data_system.cursor_se)
      @actor_command_window.index += 1
      if @actor_command_window.index >= @actor_command_window.commands_size - 1
        @actor_command_window.index = 0
      end
      return
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.decision_se)
      phase3_next_actor
      return
    end
    if Input.trigger?(Input::A)
      $game_system.se_play($data_system.decision_se)
      @input_battler.passed = true
      phase3_next_actor
      return
    end
    acbs_update_phase3_basic_command_atb 
  end
  #--------------------------------------------------------------------------
  def command_input_cancel
    windows_dispose
    @input_battler.blink = false
    @input_battlers.delete(@input_battler)
    @input_battler = nil
  end
  #--------------------------------------------------------------------------
  def windows_dispose
    @help_window.visible = false if !@escaping
    if @enemy_arrow != nil
      @enemy_arrow.dispose
      @enemy_arrow = nil
    end
    if @actor_arrow != nil
      @actor_arrow.dispose
      @actor_arrow = nil
    end
    if @actor_arrow != nil
      @actor_arrow.dispose
      @actor_arrow = nil
    end
    if @skill_window != nil
      @skill_window.dispose
      @skill_window = nil
    end
    if @item_window != nil
      @item_window.dispose
      @item_window = nil
    end
    if @enemy_arrow_all != nil
      @enemy_arrow_all.dispose_multi_arrow
      @enemy_arrow_all = nil
    end
    if @actor_arrow_all != nil
      @actor_arrow_all.dispose_multi_arrow
      @actor_arrow_all = nil
    end
    if @battler_arrow_all != nil
      @battler_arrow_all.dispose_multi_arrow
      @battler_arrow_all = nil
    end
    if @actor_command_window != nil
      @actor_command_window.active = false
      @actor_command_window.visible = false
      @active_battler_window.visible = false
      @actor_command_window.opacity = 0
    end
    @status_window.visible = true
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase4_step1_atb update_phase4_step1
  def update_phase4_step1
    if @action_battlers.size == 0
      @input_battlers.clear
      @action_battlers.clear
      @action_battler.atb = 0
      @action_battler = nil
    end
    acbs_update_phase4_step1_atb
  end  
  #--------------------------------------------------------------------------
  alias acbs_update_phase4_step2_atb update_phase4_step2
  def update_phase4_step2
    @active_battler.defense_pose = false
    if @active_battler.cast_action != nil
      active_cast = @active_battler.cast_action
      if active_cast.scope == 1 or active_cast.scope == 3 or active_cast.scope == 5
        @active_battler.current_action.target_index = @active_battler.cast_target
      end
      if active_cast.is_a?(RPG::Skill)
        @active_battler.current_action.kind = 1 
        @active_battler.current_action.skill_id = @active_battler.cast_action.id
      elsif active_cast.is_a?(RPG::Item)  
        @active_battler.current_action.kind = 2 
        @active_battler.current_action.item_id = @active_battler.cast_action.id
      end
    end
    for state in @active_battler.battler_states
      @active_battler.remove_state(state.id) if state.extension.include?("ZEROTURNLIFT")
    end
    acbs_update_phase4_step2_atb
  end
  #--------------------------------------------------------------------------
  alias make_skill_action_result_atb_n01 make_skill_action_result
  def make_skill_action_result
    skill = $data_skills[@action_battler.current_action.skill_id]
    if @action_battler.cast_action == nil
      @active_battler.cast_action = skill
      @active_battler.cast_target = @active_battler.current_action.target_index
      @cast_speed = skill.cast_speed(@active_battler)
      @active_battler.cast_action = nil if @cast_speed == 0
      @spriteset.set_stand_by_action(@active_battler.actor?, @active_battler.index)
      return unless @cast_speed == 0
    end
    make_skill_action_result_atb_n01
    @active_battler.cast_action = nil
  end
  #--------------------------------------------------------------------------
  alias make_item_action_result_atb_n01 make_item_action_result
  def make_item_action_result
    item = $data_items[@action_battler.current_action.item_id]
    if @action_battler.cast_action == nil
      @active_battler.cast_action = item
      @active_battler.cast_target = @active_battler.current_action.target_index
      @cast_speed = item.cast_speed(@active_battler)
      @active_battler.cast_action = nil if @cast_speed == 0
      @spriteset.set_stand_by_action(@active_battler.actor?, @active_battler.index)
      return unless @cast_speed == 0
    end
    make_item_action_result_atb_n01
    @active_battler.cast_action = nil
  end 
  #--------------------------------------------------------------------------
  alias acbs_action_end_atb action_end
  def action_end
    acbs_action_end_atb
    @active_battler.cast_action = nil
  end
  #--------------------------------------------------------------------------
  def start_phase4
    @phase4_step = 1
    @action_phase = true
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase4_step6_atb update_phase4_step6
  def update_phase4_step6
    acbs_update_phase4_step6_atb
    @atb_turn_count += 1 unless Custom_Turn_Count == 2
    @active_battler.atb = 0 unless @active_battler.passed
    @active_battler.passed = false
    @input_battlers.delete(@active_battler)
    @action_battlers.delete(@active_battler)
    @action_battler = nil
    @action_phase = false
    update_meters
    judge
  end
end

#==============================================================================
# ■ Window_Command
#==============================================================================
class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  attr_accessor :commands
  #--------------------------------------------------------------------------
  def commands_size
    return @item_max
  end
end

#==============================================================================
# ■ ATB_Meters
#==============================================================================
class ATB_Meters
  #--------------------------------------------------------------------------
  attr_accessor :meters
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize
    @meters = []
    @skin = RPG::Cache.windowskin(Meter_Skin)
    for i in 0...$game_party.actors.size
      @meter = MeterSprite.new(@skin, 5)
      refresh_meter(i)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    return if !Meters
    for i in @meters.size...$game_party.actors.size
      refresh_meter(i)
    end
    for i in $game_party.actors.size...@meters.size
      @meters[i].dispose
      @meters[i] = nil
    end
    @meters.compact!    
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      @meters[i].line   = actor.atb_linetype
      @meters[i].amount = actor.atb_lineamount
      @meters[i].atb_visible = 255
    end
  end
  #--------------------------------------------------------------------------
  def refresh_meter(i)
    actor = $game_party.actors[i]
    case Meter_Pos_Style
    when 0
      @meter.x = i * (624 / MAX_MEMBER) + 4 + X_Meter
      @meter.y = Y_Meter
    when 1
      @meter.x = X_Meter + ((624 / MAX_MEMBER) * ((4 - $game_party.actors.size)/2.0 + i)).floor
      @meter.y = Y_Meter
    when 2
      @meter.x = X_Meter
      @meter.y = i * 32 + Y_Meter
    when 3
      @meter.x = actor.screen_x - @skin.width / 2
      @meter.y = actor.screen_y - @skin.height / 5
    when 4
      base = Meter_Position[i]
      @meter.x = base[0]
      @meter.y = base[1]
    end
    @meters[i] = @meter
  end
  #--------------------------------------------------------------------------
  def visible=(b)
    @meters.each{|sprite| sprite.visible = b }
  end
  #--------------------------------------------------------------------------
  def opacity=(b)
    @meters.each{|sprite| sprite.opacity = b }
  end
  #--------------------------------------------------------------------------
  def dispose
    @meters.each{|sprite| sprite.dispose }
  end
end

#==============================================================================
# ■ ATB_Meters_Enemy
#==============================================================================
class ATB_Meters_Enemy
  #--------------------------------------------------------------------------
  attr_accessor :enemy_meters
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize
    @meters = []
    @enemy_meters = [] if Enemy_Meter != 0
    @skin = RPG::Cache.windowskin(Meter_Skin)
    for i in 0...$game_troop.enemies.size
      next unless $game_troop.enemies[i].exist?
      @enemy_meter = MeterSprite.new(@skin, 5)
      refresh_enemy_meter(i)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    return if !Meters
    for i in @enemy_meters.size...$game_troop.enemies.size
      refresh_enemy_meter(i)
    end
    for i in $game_troop.enemies.size...@enemy_meters.size
      @enemy_meters[i].dispose
      @enemy_meters[i] = nil
    end
    @enemy_meters.compact!    
    for i in 0...$game_troop.enemies.size
      enemy = $game_troop.enemies[i]
      next unless enemy.exist?
      @enemy_meters[i].line   = enemy.atb_linetype
      @enemy_meters[i].amount = enemy.atb_lineamount
      @enemy_meters[i].atb_visible = enemy.atb_enemy_visible
    end
  end
  #--------------------------------------------------------------------------
  def refresh_enemy_meter(i)
    enemy = $game_troop.enemies[i]
    return @enemy_meters[i] = nil unless enemy.exist?
    case Enemy_Meter
    when 1
      @enemy_meter.x = enemy.screen_x - @skin.width / 2
      @enemy_meter.y = enemy.screen_y - @skin.height / 5
      @enemy_meter.z = 100
    when 2
      @enemy_meter.x = 32
      @enemy_meter.y = 80 + i * 32
      @enemy_meter.z = 1000
    end
    @enemy_meters[i] = @enemy_meter
  end
  #--------------------------------------------------------------------------
  def visible=(b)
    @meters.each{|sprite| sprite.visible = b }
  end
  #--------------------------------------------------------------------------
  def opacity=(b)
    @meters.each{|sprite| sprite.opacity = b }
  end
  #--------------------------------------------------------------------------
  def dispose
    @enemy_meters.each{|sprite| sprite.dispose }
  end
end

#==============================================================================
# ■ ATB_Bars
#==============================================================================
class ATB_Bars
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize
    @base = Sprite.new
    @base.bitmap = RPG::Cache.windowskin(Bar_Skin).dup
    @base.x = X_Bar
    @base.y = Y_Bar
    @base.z = 1000
    @width  = @base.bitmap.width
    @height = @base.bitmap.height
    @icon_set = []
    @base.opacity = self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    @base.opacity = self.opacity = 255 if Bars
    return @base.opacity = self.opacity = 0 if !Bars
    need_initializes = []
    for battler in $game_party.actors + $game_troop.enemies
      exist = false
      for set in @icon_set
        exist |= (set[1] == battler)
      end
      need_initializes << battler unless exist
    end
    for battler in need_initializes
      iconname = nil
      if battler.is_a?(Game_Actor)
        iconname = Party_Icon[battler.battler_name]
      else
        iconname = Enemy_Icon[battler.battler_name]
      end
      if iconname.nil?
        if battler.is_a?(Game_Actor)
          iconname = Default_Party_Icon
        else
          iconname = Default_Enemy_Icon
        end
      end
      sprite = Sprite.new
      sprite.bitmap = RPG::Cache.icon(iconname).dup
      sprite.y = Y_Bar + @height / 2 - 12
      @icon_set << [sprite, battler]
    end
    for set in @icon_set
      set[0].x = X_Bar + @width * set[1].atb / set[1].max_atb - 12
      set[0].z = 1001
      set[0].visible = (!set[1].dead? and set[1].exist?)
    end
  end
  #--------------------------------------------------------------------------
  def visible=(n)
    @base.visible = n
    @icon_set.each{|set| set[0].visible = n }
  end
  #--------------------------------------------------------------------------
  def opacity=(n)
    @base.opacity = n
    @icon_set.each{|set| set[0].opacity = n }
  end
  #--------------------------------------------------------------------------
  def dispose
    @base.dispose
    @icon_set.each{|set| set[0].dispose }
  end
end

#==============================================================================
# ■ Escape_Meters
#==============================================================================
class Escape_Meters
  #--------------------------------------------------------------------------
  attr_accessor :meters
  attr_reader   :meters
  attr_accessor :enemy_meters
  attr_reader   :enemy_meters
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize
    @skin = RPG::Cache.windowskin(Escape_Skin)
    @escape_meter = MeterSprite.new(@skin, 3)
    refresh_meter
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    @escape_meter.line   = $game_temp.escape_atb_linetype
    @escape_meter.amount = $game_temp.escape_atb_lineamount
  end
  #--------------------------------------------------------------------------
  def refresh_meter
    case Escape_Meter_Pos_Type
    when 0
      @escape_meter.x = 608 - @skin.width
      @escape_meter.y = 80
    when 1
      @escape_meter.x = 320 - skin.width
      @escape_meter.y = 64
    when 2
      @escape_meter.x = Escape_Meter_Position[0]
      @escape_meter.y = Escape_Meter_Position[1]
    end
  end
  #--------------------------------------------------------------------------
  def visible=(n)
    @escape_meter.visible = n
  end
  #--------------------------------------------------------------------------
  def opacity=(n)
    @escape_meter.opacity = n
  end
  #--------------------------------------------------------------------------
  def dispose
    @escape_meter.dispose
  end
end

#==============================================================================
# ■ MeterSprite
#==============================================================================
class MeterSprite < Sprite
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize(skin, line_height)
    @line_height = line_height
    @skin   = skin
    @width  = @skin.width
    @height = @skin.height / @line_height
    @line   = 1
    @amount = 0
    @atb_visible = 0
    @base_sprite.dispose if @base_sprite != nil
    @base_sprite = Sprite.new
    @base_sprite.bitmap = @skin
    @base_sprite.src_rect.set(0, 0, @width, @height)
    @base_sprite.z = 450 * @line_height
    @base_sprite.z = 60 if Meter_Pos_Style == 3 and @line_height == 5
    @base_sprite.z = Meter_Height if Meter_Pos_Style == 4 and @line_height == 5
    @base_sprite.opacity = 0
    super()
    self.z = @base_sprite.z + 1
    self.bitmap = @skin
    self.line = 1
    self.opacity = @base_sprite.opacity = 0 if !Meters or @line_height == 3
  end
  #--------------------------------------------------------------------------
  def line=(n)
    @line = n
    refresh
  end
  #--------------------------------------------------------------------------
  def amount=(n)
    @amount = n
    refresh
  end
  #--------------------------------------------------------------------------
  def visible=(n)
    super
    @base_sprite.visible = n
    refresh
  end
  #--------------------------------------------------------------------------
  def atb_visible=(n)
    @atb_visible = n
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    @base_sprite.opacity = self.opacity = @atb_visible if @line_height == 5
    @base_sprite.opacity = self.opacity if @line_height == 3
    @base_sprite.z =  self.z - 1
    self.opacity = @base_sprite.opacity = 0 if !Meters and @line_height == 5
    self.src_rect.set(0, @line * @height, @width * @amount / 100, @height)
  end
  #--------------------------------------------------------------------------
  def x=(n)
    super
    @base_sprite.x = n
  end
  #--------------------------------------------------------------------------
  def y=(n)
    super
    @base_sprite.y = n
  end
  #--------------------------------------------------------------------------
  def dispose
    @base_sprite.dispose
    super
  end
end