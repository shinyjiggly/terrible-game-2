#==============================================================================
# Atoa's Active Time Battle Version
# By Atoa
#==============================================================================
# This Script adds a time bar system to the game
# The configurations are explained below
#==============================================================================

module Atoa  
  # Do not remove or change these lines
  Cast_Time = {}
  Cast_Cancel = {}
  ATB_Freeze = {}
  ATB_Delay = {}
  # Do not remove or change these lines

  # Waiting Mode
  Wait_Mode = 0
  # 0 = On Hold Battle: the bar stops to select actions, skills and itens
  # 1 = Semi On Hold Battle: the bar stop to select itens and skills.
  # 2 = 100% Active Battle: the bar will never stop.
  
  # Pause the bar when a battler is executing an action?
  Wait_Act_End = true
  
  # Stop time bar during damage animation?
  Pause_if_Damaged = true
  
  # Show individual time bars for the battlers?
  Meters = true
  # Hide individual meters toghter with the status screen?
  Hide_Meters = true

  # Show a single bar that indicates the battler's action order?
  Bars = true
  # Hide singe bar toghter with the status screen?
  Hide_Bars = false
  # Time Bar Division
  Dual_Bars = 50
  # if lower than 0, the bar will not be divided, and actions with chanting
  # will restart from the begin. If higher than 0, the value will show the %
  # of the bar that will be reserved for casting (Like Grandia)

  # Battle Speed
  Atb_Speed = 10.0
  
  # Initial bar value modifier
  Atb_Initial_Value = 0
  
  # Multiplication rate of the initial bar value
  Atb_Initial_Rate  = 1.0
  
  # ATB's maximum value, only change if you know what you doing.
  Max_Atb = 500
 
  # Agility Modifier, The higher this value, the lower is the diference between
  # battlers with different agility
  Atb_Agi_Modifier = 50
    
  # Makes the bar gorws faster if no actor is active
  Faster_if_inactive = false
  
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
    
  # Set the escape style
  Escape_Type = 0
  # 0 = Escape options is shown on the character's action menu
  # 1 = Keep pressed the key set in Escape_Input to escape
  #     shows a message on the screen
  # 2 = Keep pressed the key set in Escape_Input to escape
  #     shows an escape bar
  
  # Key that must be pressed to escape
  Escape_Input = Input::X
    
  # Key that must be pressed to change the input battler
  Next_Input = Input::B
  
  # Key that must be pressed to end battler turn
  Cancel_Input = Input::A
  
  # Remember to not leave any equal input
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
  Escape_Time = 400
  
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
  # 4 = Above the characters
  # 5 = Custom
  
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
  # 2 = Above the enemy
  # 3 = Vertical list on the Side
  
  # Configuration of the Action Bars.
  Bar_Skin = 'ATBBar' # Name of the graphic file that represents the bar, must be
                      # on the Graphics/Windowskins folder
  X_Bar    = 128      # X position of the Bars
  Y_Bar    =  80      # Y position of the Bars
  
  # Name of the default graphic Icon for characters
  Default_Party_Icon = '050-Skill07'
  # Individual character's Icons
  # Must be configured on the following way:
  # Party_Icon = {'Battler file name' => 'Icon file name',...}
  Party_Icon = {
    'Leon' => 'Atoa-Icon',
    'Zelos' => 'Kahh-Icon',
    'Chelsea' => 'DarkLuar-Icon',
    'Klarth' => 'Tunicoelp-Icon',
  }
  
  # Name of the default graphic Icon for enemies
  Default_Enemy_Icon = '046-Skill03' 
  # Individual icons for enemies
  # must be configured on the following way:
  # Enemy_Icon => {'Battler file name' => 'Icon file name',...}
  Enemy_Icon = {}
  
  # Sound effect played when teh character's turn comes. nil for no sound
  Command_Up_SE = '046-Book01'
      
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CAST SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Chanting default pose, if nil, no pose is used.
  Chanting_Pose = nil 

  # To add an pose to an skill or item, add this effect to the setting of the
  # skill or the item.
  # 'Chanting/**'
  #   ** must be the Pose ID.
  
  # To set an chanting pose for an specific graphic, add this to the graphic setting:
  # 'Chanting' => Pose ID.
  
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
   
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SETTINGS OF ACTIONS THAT CHANGE THE ATB
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Actions that may cause changes on the target ATB
  
  # Chance that all actions have to cancel skill cast of the target.
  # This value is used for all actions that don't have individual definition.
  Base_Cast_Cancel = 0
    
  # Set here the chance that each action have of canceling the cast of target
  #  
  #   Cast_Cancel[Action_Type] = {Action_ID => Rate}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for weapons
  #     Action_ID = ID of the skill, item or weapon
  #     Rate = chance of calceling cast, increases with damage caused.
  #
  # Important: if tha action is an physical skill, the weapon cancel chance is
  #  also applied (the values aren't added, each one are calculated separatedely)
  
  #--------------------------------------------------------------------------
  # Pause on the ATB bar when recive damage
  # This value is used for all actions that don't have individual definition.
  # Time in frames that the ATB bar will be stoped, increases with damage caused.
  Base_ATB_Freeze = 0
    
  # Set here the actions that will cause ATB pause
  #  
  #   Cast_Cancel[Action_Type] = {Action_ID => Pause}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for weapons
  #     Action_ID = ID of the skill, item or weapon
  #     Pause = ATB pause time, increases with damage caused.
  #
  # Important: if tha action is an physical skill, the weapon pause is also calculated
   
  #--------------------------------------------------------------------------
  # Delay on the ATB bar when recive damage
  # This value is used for all actions that don't have individual definition.
  Base_ATB_Delay = 0
    
  # Set here the actions that will cause ATB delay
  #  
  #   Cast_Cancel[Action_Type] = {Action_ID => Delay}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for weapons
  #     Action_ID = ID of the skill, item or weapon
  #     Delay = ATB delay value, increases with damage caused.
  #
  # Important: if tha action is an physical skill, the weapon delay is also calculated

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa ATB'] = true

#==============================================================================
# ** RPG::Skill
#------------------------------------------------------------------------------
# Class that manage skills
#==============================================================================

class RPG::Skill
  #----------------------------------------------------------------------------
  # * Set action cast speed
  #     battler : battler
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
# ** RPG::Item
#------------------------------------------------------------------------------
# Class that manage items
#==============================================================================

class RPG::Item
  #----------------------------------------------------------------------------
  # * Set action cast speed
  #     battler : battler
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
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :max_escape_count
  attr_accessor :escape_count
  attr_accessor :hide_meters
  attr_accessor :no_active_battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_atb initialize
  def initialize
    initialize_atb
    @max_escape_count = 0
    @escape_count = 0
  end
  #--------------------------------------------------------------------------
  # * Get escape line type
  #--------------------------------------------------------------------------
  def escape_atb_linetype
    return 2 unless @battle_can_escape
    return 1 if @battle_can_escape
  end
  #--------------------------------------------------------------------------
  # * Get escap bar value
  #--------------------------------------------------------------------------
  def escape_atb_lineamount
    return 100 * @escape_count / @max_escape_count if @battle_can_escape
    return 100 unless @battle_can_escape
  end
end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :wait_mode
  attr_accessor :action_wait
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_atb initialize
  def initialize
    initialize_atb
    @wait_mode = Wait_Mode
    @action_wait = Wait_Act_End
  end
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Get idle pose ID
  #--------------------------------------------------------------------------
  alias set_idle_pose_atb set_idle_pose
  def set_idle_pose
    pose = set_idle_pose_atb
    unless pose == Dead_Pose or pose == Victory_Pose
      if battler.cast_action != nil
        action = @battler.cast_action
        cast_pose = set_pose_id('Chanting')
        ext = check_extension(action, 'CHANTING/')
        if ext != nil
          ext.slice!('CHANTING/')
          cast_pose = ext.to_i
        end
      end
    end
    return cast_pose.nil? ? pose : cast_pose
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :atb
  attr_accessor :cast_action
  attr_accessor :casting
  attr_accessor :cast_target
  attr_accessor :turn_count
  attr_accessor :guarding
  attr_accessor :passed
  attr_accessor :atb_delay
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_atb initialize
  def initialize
    initialize_atb
    @atb = 0
    @cast_skill = 0
    @turn_count = 0
    @atb_delay = 0
    @guarding = false
    @passed = false
    @casting = false
  end
  #--------------------------------------------------------------------------
  # * Get ATB line type
  #--------------------------------------------------------------------------
  def atb_linetype
    return 4 if self.cast_action != nil and self.atb_full?
    return 3 if self.cast_action != nil
    return 2 if self.atb_full?
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get ATB line value
  #--------------------------------------------------------------------------
  def atb_lineamount
    return 0 if self.dead?
    return 100 * self.atb / self.max_atb
  end
  #--------------------------------------------------------------------------
  # * Casting flag
  #--------------------------------------------------------------------------
  def casting
    return false if self.dead?
    return @casting
  end
  #--------------------------------------------------------------------------
  # * Get Max ATB
  #--------------------------------------------------------------------------
  def max_atb
    return Max_Atb
  end
  #--------------------------------------------------------------------------
  # * Set current ATB
  #     n : new atb
  #--------------------------------------------------------------------------
  def atb=(n)
    @atb = [[n.to_i, 0].max, self.max_atb].min
  end
  #--------------------------------------------------------------------------
  # * ATB Preset
  #--------------------------------------------------------------------------
  def atb_preset
    percent = self.max_atb * Atb_Initial_Rate * (rand(64) + 16) * (self.agi + Atb_Agi_Modifier) / total_agi / 1000
    self.atb = Atb_Initial_Value + percent
  end
  #--------------------------------------------------------------------------
  # * Battlers total agility
  #--------------------------------------------------------------------------
  def total_agi
    total = 0
    for battler in $game_party.actors + $game_troop.enemies
      total += battler.agi
    end
    return total
  end
  #--------------------------------------------------------------------------
  # * ATB full flag
  #--------------------------------------------------------------------------
  def atb_full?
    return @atb == self.max_atb
  end
  #--------------------------------------------------------------------------
  # * Update ATB
  #--------------------------------------------------------------------------
  def atb_update
    if self.cast_action.nil?
      self.atb += speed_adjust * 200 * (self.agi + Atb_Agi_Modifier) / total_agi / 100.0
    else
      cast = cast_action.cast_speed(self)
      self.atb += speed_adjust * (cast + Atb_Agi_Modifier)  / total_agi / 100.0
    end
  end
  #--------------------------------------------------------------------------
  # * Speed adjust
  #--------------------------------------------------------------------------
  def speed_adjust
    return $game_temp.no_active_battler ? Atb_Speed * 3.0 : Atb_Speed
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_atb set_damage
  def set_damage(user, action = nil)
    set_damage_atb(user, action)
    set_cast_cancel(user, action)
    set_freeze_action(user, action)
    set_delay_action(user, action)
  end
  #--------------------------------------------------------------------------
  # * Set cast cancel action
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_cast_cancel(user, action)
    if action != nil and Cast_Cancel[action.type_name] != nil and
       Cast_Cancel[action.type_name][action.id] != nil
      cancel_cast(user, Cast_Cancel[action.type_name][action.id], action)
      if action.type_name == 'Skill' and not action.magic? 
        for weapon in weapons
          cancel_cast(user, Cast_Cancel['Weapon'][weapon.id], action)
        end
      end
    else
      cancel_cast(user, Base_Cast_Cancel, action)
    end
  end
  #--------------------------------------------------------------------------
  # * Set ATB freeze action
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_freeze_action(user, action)
    if action != nil and ATB_Freeze[action.type_name] != nil and
       ATB_Freeze[action.type_name][action.id] != nil
      freeze_action(user, ATB_Freeze[action.type_name][action.id], action)
      if action.type_name == 'Skill' and not action.magic? 
        for weapon in weapons
          freeze_action(user, ATB_Freeze['Weapon'][weapon.id], action)
        end
      end
    else
      freeze_action(user, Base_ATB_Freeze, action)
    end
  end
  #--------------------------------------------------------------------------
  # * Set ATB delay action
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_delay_action(user, action)
    if action != nil and ATB_Delay[action.type_name] != nil and
       ATB_Delay[action.type_name][action.id] != nil
      delay_action(user, ATB_Delay[action.type_name][action.id], action)
      if action.type_name == 'Skill' and not action.magic? 
        for weapon in weapons
          delay_action(user, ATB_Delay['Weapon'][weapon.id], action)
        end
      end
    else
      delay_action(user, Base_ATB_Delay, action)
    end
  end
  #--------------------------------------------------------------------------
  # * No freeze flag
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def cant_cancel(user, action)
    return true if check_include(action, "NODAMAGE")
    return true if not user.target_damage[self].numeric?
    return true if user.target_damage[self] < 0
    return false
  end
  #--------------------------------------------------------------------------
  # * Set cast cancel
  #     user   : user
  #     cast   : cancel chance
  #     action : action
  #--------------------------------------------------------------------------
  def cancel_cast(user, cast, action)
    return if cant_cancel(user, action)
    rate =  cast + (cast * (user.target_damage[self] * 50.0 / self.maxhp) / 100.0)
    if rate > rand(100) and self.cast_action != nil
      self.cast_action = nil
      self.atb = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Set ATB freeze
  #     user   : user
  #     delay  : delay value
  #     action : action
  #--------------------------------------------------------------------------
  def freeze_action(user, delay, action)
    return if cant_cancel(user, action)
    rate =  delay + (delay * (user.target_damage[self] * 50.0 / self.maxhp) / 100.0)
    self.atb_delay += rate.to_i
  end
  #--------------------------------------------------------------------------
  # * Set ATB delay
  #     user   : user
  #     delay  : delay value
  #     action : action
  #--------------------------------------------------------------------------
  def delay_action(user, delay, action)
    return if cant_cancel(user, action)
    rate =  delay + (delay * (user.target_damage[self] * 50.0 / self.maxhp) / 100.0)
    self.atb -= rate.to_i
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
  # * Decide if Command is Inputable
  #--------------------------------------------------------------------------
  def inputable?
    return (self.atb_full? and super)
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Decide if Action is Possible
  #--------------------------------------------------------------------------
  def movable?
    return (self.atb_full? and super)
  end
  #--------------------------------------------------------------------------
  # * Get Battle Turn
  #--------------------------------------------------------------------------
  def get_battle_turn
    return @turn_count
  end
end

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias anim_face_initialize initialize
  def initialize
    @atb_meters = ATB_Meters.new if Meters
    @enm_meters = Enemy_Meters.new if Enemy_Meter > 0
    @atb_bars = ATB_Bars.new if Bars
    @alive_enemies = enemies_alive
    @old_party = $game_party.actors
    anim_face_initialize
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias atb_battle_status_refresh refresh
  def refresh
    atb_battle_status_refresh
    active_time_update
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  alias visible_atb visible=
  def visible=(n)
    visible_atb(n)
    need_reset
    @atb_meters.visible = n  if Hide_Meters and @atb_meters != nil
    @atb_bars.visible = n if Hide_Bars and @atb_bars != nil
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias atb_battle_status_dispose dispose
  def dispose
    atb_battle_status_dispose
    @atb_meters.dispose if @atb_meters != nil
    @enm_meters.dispose if @enm_meters != nil
    @atb_bars.dispose if @atb_bars != nil
  end
  #--------------------------------------------------------------------------
  # * Time bar update
  #--------------------------------------------------------------------------
  def active_time_update
    need_reset
    @atb_meters.refresh if @atb_meters != nil
    @enm_meters.refresh if @enm_meters != nil
    @atb_bars.refresh if @atb_bars != nil
  end
  #--------------------------------------------------------------------------
  # * Check if bars need reset
  #--------------------------------------------------------------------------
  def need_reset
    if (@alive_enemies != enemies_alive) or (@old_party != $game_party.actors)
      @alive_enemies = enemies_alive
      @old_party = $game_party.actors
      reset_bars
    end
  end
  #--------------------------------------------------------------------------
  # * Get number of alive enemies
  #--------------------------------------------------------------------------
  def enemies_alive
    alive = 0
    for i in 0...$game_troop.enemies.size
      alive += 1 unless $game_troop.enemies[i].dead?
    end
    return alive
  end
  #--------------------------------------------------------------------------
  # * Reset time bars
  #--------------------------------------------------------------------------
  def reset_bars
    @atb_meters.dispose if @atb_meters != nil
    @enm_meters.dispose if @enm_meters != nil
    @atb_bars.dispose if @atb_bars != nil
    @atb_meters = ATB_Meters.new if Meters
    @enm_meters = Enemy_Meters.new if Enemy_Meter > 0
    @atb_bars = ATB_Bars.new if Bars
  end
end

#==============================================================================
# ** ATB_Meters
#------------------------------------------------------------------------------
# Class that shows the time meters of actors
#==============================================================================

class ATB_Meters
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :meters
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @meters = []
    @skin = RPG::Cache.windowskin(Meter_Skin)
    i = 0
    for actor in $game_party.actors
      @meter = MeterSprite.new(@skin, 5)
      refresh_meter(i)
      i += 1
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    i = 0
    for actor in $game_party.actors
      @meters[i].line = actor.atb_linetype
      @meters[i].amount = actor.atb_lineamount
      @meters[i].refresh
      @meters[i].atb_visible = true
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Update meter
  #     index : index
  #--------------------------------------------------------------------------
  def refresh_meter(index)
    actor = $game_party.actors[index]
    case Meter_Pos_Style
    when 0
      @meter.x = index * (624 / Max_Party) + 4 + X_Meter
      @meter.y = Y_Meter
      @meter.z = 1000
    when 1
      @meter.x = X_Meter + ((624 / Max_Party) * ((4 - $game_party.actors.size)/2.0 + index)).floor
      @meter.y = Y_Meter
      @meter.z = 1000
    when 2
      @meter.x = X_Meter
      @meter.y = index * 32 + Y_Meter
      @meter.z = 1000
    when 3
      @meter.x = actor.base_x - @skin.width / 2
      @meter.y = actor.base_y - @skin.height / 5
      @meter.z = 100
    when 4
      @meter.x = actor.base_x - @skin.width / 2
      @meter.y = actor.base_y - @skin.height / 5 - 64
      @meter.z = 2500
    when 5
      base = Meter_Position[index]
      @meter.x = base[0]
      @meter.y = base[1]
      @meter.z = 2500
    end
    @meters[index] = @meter
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    @meters.each{|sprite| sprite.visible = n }
  end
  #--------------------------------------------------------------------------
  # * Window opacity
  #     n : opacity
  #--------------------------------------------------------------------------
  def opacity=(n)
    @meters.each{|sprite| sprite.opacity = n }
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @meters.each{|sprite| sprite.dispose }
  end
end

#==============================================================================
# ** Enemy_Meters
#------------------------------------------------------------------------------
# Class that shows the time meters of enemies
#==============================================================================

class Enemy_Meters
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :meters
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @meters = []
    @skin = RPG::Cache.windowskin(Meter_Skin)
    i = 0
    for enemy in $game_troop.enemies
      next if enemy.dead? and not [1,2].include?(Enemy_Meter)
      @meter = MeterSprite.new(@skin, 5)
      refresh_meter(i)
      i += 1
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    i = 0
    for enemy in $game_troop.enemies
      next if enemy.dead? and not [1,2].include?(Enemy_Meter)
      @meters[i].line = enemy.atb_linetype
      @meters[i].amount = enemy.atb_lineamount
      @meters[i].refresh
      @meters[i].atb_visible = (enemy.dead? and [1,2].include?(Enemy_Meter)) ? false : true
      @meters[i].visible = (enemy.dead? and [1,2].include?(Enemy_Meter)) ? false : true
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Update meter
  #     index : index
  #--------------------------------------------------------------------------
  def refresh_meter(index)
    enemy = $game_troop.enemies[index]
    case Enemy_Meter
    when 1
      @meter.x = enemy.base_x - @skin.width / 2
      @meter.y = enemy.base_y - @skin.height / 5
      @meter.z = 100
    when 2
      @meter.x = enemy.base_x - @skin.width / 2
      @meter.y = enemy.base_y - @skin.height / 5 - 64
      @meter.z = 1000
    when 3
      @meter.x = 32
      @meter.y = 80 + index * 32
      @meter.z = 3000
    end
    @meters[index] = @meter
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    @meters.each{|sprite| sprite.visible = n }
  end
  #--------------------------------------------------------------------------
  # * Window opacity
  #     n : opacity
  #--------------------------------------------------------------------------
  def opacity=(n)
    @meters.each{|sprite| sprite.opacity = n }
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @meters.each{|sprite| sprite.dispose }
  end
end

#==============================================================================
# ** Escape_Meters
#------------------------------------------------------------------------------
# Class that shows the escape meters
#==============================================================================

class Escape_Meters
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @skin = RPG::Cache.windowskin(Escape_Skin)
    @escape_meter = MeterSprite.new(@skin, 3)
    refresh_meter
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @escape_meter.line   = $game_temp.escape_atb_linetype
    @escape_meter.amount = $game_temp.escape_atb_lineamount
    @escape_meter.z = 5000
    @escape_meter.refresh
  end
  #--------------------------------------------------------------------------
  # * Update meter
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
    @escape_meter.z = 5000
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    @escape_meter.visible = n
  end
  #--------------------------------------------------------------------------
  # * Window opacity
  #     n : opacity
  #--------------------------------------------------------------------------
  def opacity=(n)
    @escape_meter.opacity = n
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @escape_meter.dispose
  end
end

#==============================================================================
# ** MeterSprite
#------------------------------------------------------------------------------
# Class that draws all bars
#==============================================================================

class MeterSprite < Sprite
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :line
  attr_accessor :amount
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     skin        : bar bitmap
  #     line_number : line number
  #--------------------------------------------------------------------------
  def initialize(skin, line_number)
    @line_number = line_number
    @skin   = skin
    @width  = @skin.width
    @height = @skin.height / @line_number
    @line   = 1
    @amount = 0
    @atb_visible = false
    @base_sprite.dispose if @base_sprite != nil
    @base_sprite = Sprite.new
    @base_sprite.bitmap = @skin
    @base_sprite.src_rect.set(0, 0, @width, @height)
    super()
    self.bitmap = @skin
    self.line = 1
    self.opacity = 0 if @line_number == 3
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    @base_sprite.visible = n
    super
  end
  #--------------------------------------------------------------------------
  # * Window opacity
  #     n : opacity
  #--------------------------------------------------------------------------
  def opacity=(n)
    @base_sprite.opacity = n
    super
  end
  #--------------------------------------------------------------------------
  # * ATB visibility flag
  #     n : visibility flag
  #--------------------------------------------------------------------------
  def atb_visible=(n)
    @atb_visible = n
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.src_rect.set(0, @line * @height, @width * @amount / 100, @height)
  end
  #--------------------------------------------------------------------------
  # * Sprite X coordinate
  #     n : new value
  #--------------------------------------------------------------------------
  def x=(n)
    super
    @base_sprite.x = n
  end
  #--------------------------------------------------------------------------
  # * Sprite Y coordinate
  #     n : new value
  #--------------------------------------------------------------------------
  def y=(n)
    super
    @base_sprite.y = n
  end
  #--------------------------------------------------------------------------
  # * Sprite Z coordinate
  #     n : new value
  #--------------------------------------------------------------------------
  def z=(n)
    super
    @base_sprite.z = z - 1
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @base_sprite.dispose
    super
  end
end

#==============================================================================
# ** ATB_Bars
#------------------------------------------------------------------------------
# Class that shows the bar and icons for battle flow
#==============================================================================

class ATB_Bars
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  def initialize
    @base = Sprite.new
    @base.bitmap = RPG::Cache.windowskin(Bar_Skin).dup
    @base.x = X_Bar + 8
    @base.y = Y_Bar
    @base.z = 3000
    @width  = @base.bitmap.width
    @height = @base.bitmap.height
    @iconset = {}
    @base.opacity = self.opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def refresh
    return @base.opacity = self.opacity = 0 unless Bars
    need_refresh = []
    for battler in $game_party.actors + $game_troop.enemies
      update_icon = false
      update_icon |= !@iconset.keys.include?(battler)
      for key in @iconset.keys
        update_icon |= @iconset[key].last != battler.battler_name
      end
      need_refresh << battler if update_icon
    end
    for battler in need_refresh
      @iconset[battler] = [Sprite.new, battler.battler_name] if @iconset[battler].nil?
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
      @iconset[battler].first.bitmap = RPG::Cache.icon(iconname).dup
      @iconset[battler].first.y = Y_Bar + @height / 2 - 12
    end
    icons_update
    self.visible = $game_temp.hide_windows ? false : true
  end
  #--------------------------------------------------------------------------
  # * Update Icons
  #--------------------------------------------------------------------------
  def icons_update
    for battler in @iconset.keys
      unless ($game_party.actors + $game_troop.enemies).include?(battler)
        @iconset[battler].first.dispose
        @iconset[battler] = nil
        @iconset.delete(battler)
        next
      end
      icon = @iconset[battler]
      wid = @width - 12
      if Dual_Bars > 0
        if battler.cast_action != nil
          bar1 = (100 - Dual_Bars) * wid / 100.0
          bar2 = Dual_Bars * wid / 100.0
          icon.first.x = X_Bar + bar1 + (bar2  * battler.atb / battler.max_atb)
        else
          bar1 = (100 - Dual_Bars) * wid / 100.0
          icon.first.x =  X_Bar + (bar1 * battler.atb / battler.max_atb)
        end
      else
        icon.first.x = X_Bar + wid * battler.atb / battler.max_atb
      end
      icon.first.x = X_Bar + wid if (battler.active? or battler.action?) and
                                     battler.cast_action.nil?
      icon.first.z = 3001 + icon.first.x
      icon.first.visible = battler.exist?
      icon.first.opacity = battler.exist? ? 255 : 0
    end
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    @base.visible = n
    for icon in @iconset.values
      icon.first.visible = n
    end
  end
  #--------------------------------------------------------------------------
  # * Window opacity
  #     n : opacity
  #--------------------------------------------------------------------------
  def opacity=(n)
    @base.opacity = n
    for icon in @iconset.values
      icon.first.opacity = n
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @base.dispose
    for icon in @iconset.values
      icon.first.dispose
    end
  end
end

#==============================================================================
# ** Interpreter
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # * Force Action
  #--------------------------------------------------------------------------
  def command_339
    return true unless $game_temp.in_battle
    iterate_battler(@parameters[0], @parameters[1]) do |battler|
      if battler.exist?
        battler.current_action.kind = @parameters[2]
        if battler.current_action.kind == 0
          battler.current_action.basic = @parameters[3]
        else
          battler.current_action.skill_id = @parameters[3]
        end
        if @parameters[4] == -2
          if battler.is_a?(Game_Enemy)
            battler.current_action.decide_last_target_for_enemy
          else
            battler.current_action.decide_last_target_for_actor
          end
        elsif @parameters[4] == -1
          if battler.is_a?(Game_Enemy)
            battler.current_action.decide_random_target_for_enemy
          else
            battler.current_action.decide_random_target_for_actor
          end
        elsif @parameters[4] >= 0
          battler.current_action.target_index = @parameters[4]
        end
        battler.current_action.forcing = true
        if battler.current_action.valid? and @parameters[5] == 1
          $game_temp.forcing_battler = battler
          @index += 1
          return false
        end
      end
    end
    return true
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :no_active_battler
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias main_atb main
  def main
    turn_count_speed  
    $game_temp.escape_count = 0
    $game_temp.hide_meters = false
    $game_temp.no_active_battler = true
    @escape_type = Escape_Type
    @escape_name = Escape_Name
    @input_battlers = []
    @action_battlers = []
    @input_battler = nil
    @action_battler = nil
    @escaped = false
    @update_turn_end = false
    @action_phase = false
    @freeze_atb = []
    main_atb
  end
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias start_atb start
  def start
    start_atb
    for battler in $game_party.actors + $game_troop.enemies
      battler.turn_count = 0
      battler.atb = 0
      battler.atb_preset
      battler.cast_action = nil
      battler.cast_target = nil
      battler.defense_pose = false
    end
  end
  #--------------------------------------------------------------------------
  # * Reset time bars
  #--------------------------------------------------------------------------
  def reset_bars
    @status_window.reset_bars
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_atb update
  def update
    update_battle_phases
    check_active_battler
    return $scene = Scene_Gameover.new if $game_temp.gameover
    update_atb
    return update_phase5 if @phase == 5
    return if $game_system.battle_interpreter.running? and $game_temp.forcing_battler.nil?
    update_turn_ending if @update_turn_end
    update_escape
    return if @escaped
    atb_update
    input_battler_update
    action_battler_update
  end
  #--------------------------------------------------------------------------
  # * Basic Update Processing
  #--------------------------------------------------------------------------
  alias update_basic_atb update_basic
  def update_basic
    update_basic_atb
    windows_dispose if @active_battler != nil and @active_battler.hp0?
  end
  #--------------------------------------------------------------------------
  # * Battle phases update
  #--------------------------------------------------------------------------
  def update_battle_phases
    if @phase == 1
      $game_temp.battle_main_phase = true
      @actor_command_window.opacity = 0
      @phase = 0
    elsif @phase != 5
      @phase = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Action battler update
  #--------------------------------------------------------------------------
  def action_battler_update
    if @action_battlers[0] != nil
      @action_battlers.flatten!
      battler = @action_battlers[0]
      battler.atb = 0 if battler.dead?
    end
    update_phase4
  end
  #--------------------------------------------------------------------------
  # * Check Active battler
  #--------------------------------------------------------------------------
  def check_active_battler
    no_active = (@action_battlers.empty? and @active_battlers.empty? and @input_battlers.empty?)
    $game_temp.no_active_battler = Faster_if_inactive ? no_active : false
  end
  #--------------------------------------------------------------------------
  # * Update battler inupt
  #--------------------------------------------------------------------------
  def input_battler_update
    check_battler_turn
    set_input_battle
    command_window_setup_update
    clear_disabled_battler
  end
  #--------------------------------------------------------------------------
  # * Check battler turn
  #--------------------------------------------------------------------------
  def check_battler_turn
    for battler in $game_party.actors + $game_troop.enemies
      if (battler.atb_full? or $game_temp.forcing_battler == battler) and not
         @action_battlers.include?(battler) and not
         @active_battlers.include?(battler) and not
         @input_battlers.include?(battler)
        battler_turn(battler)
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set battler input
  #--------------------------------------------------------------------------
  def set_input_battle
    if @input_battlers[0] != nil and @input_battler.nil? and !wait_on and
       ((@active_battlers.empty? and $game_system.action_wait) or not $game_system.action_wait)
      @input_battlers.flatten!
      @input_battler = @input_battlers[0]
      if @input_battler.current_action.forcing or @input_battler.confused?
        if @input_battler.confused?
          @input_battler.current_action.kind = 0
          @input_battler.current_action.basic = 0
        end
        @input_battler.defense_pose = false
        @action_battlers << @input_battlers.shift
        @action_battlers.compact!
        @input_battler = nil
      elsif @input_battler.inputable?
        @actor_index = $game_party.actors.index(@input_battler)
        @input_battler.current_action.clear
      else
        @input_battler.atb_update
        @input_battlers.shift
        @input_battler = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update command window
  #--------------------------------------------------------------------------
  def command_window_setup_update
    if @input_battler != nil
      @input_battler.defense_pose = false
      @input_battler.blink = true
      @active_battler = @input_battler
      if @actor_command_window.opacity == 0
        $game_system.se_play(RPG::AudioFile.new(Command_Up_SE)) if @active_battler.cast_action.nil? and Command_Up_SE != nil
        phase3_setup_command_window
      end
      update_phase3
    end
  end
  #--------------------------------------------------------------------------
  # * Clear disbled battlers
  #--------------------------------------------------------------------------
  def clear_disabled_battler
    for battler in $game_party.actors + $game_troop.enemies
      next if battler.exist?
      @input_battlers.delete(battler)
      @action_battlers.delete(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Escape update
  #--------------------------------------------------------------------------
  def update_escape
    if Input.press?(Escape_Input) and @escape_type > 0 
      if $game_temp.battle_can_escape
        update_escape_message
      else
        update_cant_escape
      end
    elsif @escape_type > 0
      update_escape_meter
    end
  end
  #--------------------------------------------------------------------------
  # * Escape message update
  #--------------------------------------------------------------------------
  def update_escape_message
    $game_temp.max_escape_count = update_escape_rate
    $game_temp.escape_count += 2 unless wait_on
    @escaping = true 
    update_escape_type_1 if !@help_window.visible and @escape_type == 1
    update_escape_type_2 if @escape_type == 2
    if $game_temp.escape_count >= $game_temp.max_escape_count
      $game_temp.escape_count = 0
      update_phase2_escape unless $game_party.all_dead?
    end
  end
  #--------------------------------------------------------------------------
  # * Update escape type 1
  #--------------------------------------------------------------------------
  def update_escape_type_1
    @help_window.set_text('')
    @help_window.set_text(Escape_Message, 1)
  end
  #--------------------------------------------------------------------------
  # * Update escape type 2
  #--------------------------------------------------------------------------
  def update_escape_type_2
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
  #--------------------------------------------------------------------------
  # * Update can't escape
  #--------------------------------------------------------------------------
  def update_cant_escape
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
  #--------------------------------------------------------------------------
  # * Update escape metter
  #--------------------------------------------------------------------------
  def update_escape_meter
    if @escaping
      @escaping = false
      @help_window.visible = false
    end
    $game_temp.escape_count = [$game_temp.escape_count - 1, 0].max unless wait_on
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
  #--------------------------------------------------------------------------
  # * Start battler turn
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_turn(battler)
    battler.turn_count += 1
    if battler.is_a?(Game_Actor)
      if battler.inputable? and battler.cast_action.nil?
        @input_battlers << battler
        @input_battlers.compact!
      else
        if battler.confused?
          battler.current_action.kind = 0
          battler.current_action.basic = 0
        end
        battler.defense_pose = false
        @action_battlers << battler
        @action_battlers.compact!
      end
    else
      set_enemy_action(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set enemy action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_enemy_action(battler)
    if battler.current_action.forcing or $game_temp.forcing_battler
      battler.current_action.forcing = false
      $game_temp.forcing_battler = nil
    else
      battler.make_action 
    end
    @action_battlers << battler
    @action_battlers.compact!
  end
  #--------------------------------------------------------------------------
  # * Turn Ending
  #--------------------------------------------------------------------------
  def turn_ending
  end  
  #--------------------------------------------------------------------------
  # * Update Turn Ending
  #--------------------------------------------------------------------------
  def update_turn_ending
    slip_damage_all if Slip_Damage_Pop_Time == 2
    @update_turn_end = false
  end
  #--------------------------------------------------------------------------
  # * Update ATB
  #--------------------------------------------------------------------------
  def atb_update
    update_meters
    return if wait_on
    @atb_turn_count += 1 if Custom_Turn_Count == 2
    if @atb_turn_count >= @abt_turn_speed
      for index in 0...$data_troops[@troop_id].pages.size
        page = $data_troops[@troop_id].pages[index]
        $game_temp.battle_event_flags[index] = false if page.span == 1
      end
      @update_turn_end = true if Slip_Damage_Pop_Time >= 2
      $game_temp.battle_turn += 1
      turn_count_speed
      for battler in $game_party.actors + $game_troop.enemies
        battler.remove_states_auto if battler.exist?
      end
      setup_battle_event
    end
    for battler in $game_party.actors + $game_troop.enemies
      unless battler.exist?
        battler.cast_action = nil
        battler.atb = 0
      end
      next if (@escaping and battler.actor? and @escape_type > 0)
      next if battler.restriction == 4 or @active_battlers.include?(battler)
      next unless battler.exist?
      next if Pause_if_Damaged and battler.damaged
      if battler.atb_delay > 0
        battler.atb_delay -= 1
        next
      end
      battler.atb_update
    end
  end
  #--------------------------------------------------------------------------
  # * Wait flag
  #--------------------------------------------------------------------------
  def wait_on
    return true if $game_system.wait_mode == 1 and (@skill_window != nil or @item_window != nil)
    return true if $game_system.wait_mode == 0 and @input_battler != nil
    return true if ($game_system.action_wait or not @freeze_atb.empty?) and not allow_next_action
    return true if @battle_start or @battle_ending or @phase == 5
    return false
  end
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  def start_phase2
  end
  #--------------------------------------------------------------------------
  # * Update time meterrs
  #--------------------------------------------------------------------------
  def update_meters
    @status_window.active_time_update
  end
  #--------------------------------------------------------------------------
  # * Set turn speed
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
  # * Frame Update (party command phase: escape)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    windows_dispose
    update_phase2_escape_type1 if @escape_type == 0 
    update_phase2_escape_type2 if @escape_type > 0
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: escape type 1)
  #--------------------------------------------------------------------------
  def update_phase2_escape_type1
    if rand(100) < set_escape_rate
      command_input_cancel
      @battle_ending = true
      $game_system.se_play($data_system.escape_se)
      battle_end(1)
      play_map_bmg
    else
      @escape_ratio += 3
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: escape type 2)
  #--------------------------------------------------------------------------
  def update_phase2_escape_type2
    @escaped = true
    command_input_cancel
    @battle_ending = true
    $game_system.se_play($data_system.escape_se)
    $game_system.bgm_play($game_temp.map_bgm)
    if @escape_atb_meters != nil
      @escape_atb_meters.dispose 
      @escape_atb_meters = nil
    end
    battle_end(1)
  end
  #--------------------------------------------------------------------------
  # * Escape rate update
  #--------------------------------------------------------------------------
  def update_escape_rate
    actors_agi = $game_party.avarage_stat('agi')
    enemies_agi = $game_troop.avarage_stat('agi')
    return  Escape_Time * enemies_agi / actors_agi
  end
  #--------------------------------------------------------------------------
  # * Set Defense Action
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_guard_action_atb set_guard_action
  def set_guard_action(battler)
    set_guard_action_atb(battler)
    battler.atb = 0
    battler.action_scope = 0
  end
  #--------------------------------------------------------------------------
  # * Set Escape Action
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_escape_action_atb set_escape_action
  def set_escape_action(battler)
    set_escape_action_atb(battler)
    battler.atb = 0
    battler.action_scope = 0
  end
  #--------------------------------------------------------------------------
  # * Set Skip Action
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_action_none_atb set_action_none
  def set_action_none(battler)
    set_action_none_atb(battler)
    battler.atb = 0
    battler.action_scope = 0
    battler.current_phase = 'Phase 5-1'
  end
  #--------------------------------------------------------------------------
  # * Start After Battle Phase
  #--------------------------------------------------------------------------
  alias start_phase5_atb start_phase5
  def start_phase5
    @help_window.visible = false if @help_window != nil
    @input_battler.blink = false if @input_battler != nil
    windows_dispose
    @battle_ending = true
    update_meters
    start_phase5_atb
  end
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  #--------------------------------------------------------------------------
  alias update_phase5_atb update_phase5
  def update_phase5
    windows_dispose
    update_phase5_atb
  end
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window phase3_setup_command_window
  def phase3_setup_command_window
    $game_temp.battle_start = false
    return if @escaped
    if @active_battler != nil and @active_battler.cast_action != nil
      @active_battler.blink = false
      return    
    end
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
    command_window_position
    @actor_command_window.back_opacity = Base_Opacity
    @actor_command_window.back_opacity = Base_Opacity
    @actor_command_window.z = 4500
    @active_battler_window.refresh(@active_battler)
    @active_battler_window.visible = Battle_Name_Window
    @active_battler_window.x = Command_Window_Custom_Position[0]
    @active_battler_window.y = Command_Window_Custom_Position[1] - 64
    @active_battler_window.z = 4500
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  def phase3_next_actor
    action_battler = @input_battlers.shift
    @action_battlers << action_battler
    @action_battlers.compact!
    command_input_cancel
    @input_battler = nil
    @actor_index = nil
    @active_battler = nil
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input of Previous Actor
  #--------------------------------------------------------------------------
  def phase3_switch_actor
    @input_battler.current_action.clear
    @input_battler.atb = 0 unless @input_battler.passed
    @input_battler.passed = false
    @input_battlers.delete(@input_battler)
    @action_battlers.delete(@input_battler)
    command_input_cancel
    @input_battler = nil
    @actor_index = nil
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase)
  #--------------------------------------------------------------------------
  alias update_phase3_atb update_phase3
  def update_phase3
    if cancel_command?
      if can_act?
        if @input_battler.confused?
          @input_battler.current_action.kind = 0
          @input_battler.current_action.basic = 0
        end
        @action_battlers << @input_battler
        @action_battlers.compact!
      end
      command_input_cancel
      return
    end
    update_phase3_atb
  end
  #--------------------------------------------------------------------------
  # * Command cancel flag
  #--------------------------------------------------------------------------  
  def cancel_command?
    return false if @input_battler.nil?
    return true if @input_battler.current_action.forcing
    return true if @input_battler.confused?
    return true if @input_battler.restriction == 4
    return true if not $game_party.actors.include?(@input_battler)
    return false
  end
  #--------------------------------------------------------------------------
  # * Can't act flag
  #--------------------------------------------------------------------------  
  def can_act?
    return true if @input_battler.current_action.forcing
    return true if @input_battler.confused?
    return false
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : basic command)
  #--------------------------------------------------------------------------
  alias update_phase3_basic_command_atb update_phase3_basic_command
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
    if Input.trigger?(Next_Input)
      $game_system.se_play($data_system.decision_se)
      @input_battler.passed = true
      phase3_switch_actor
      return
    end
    if Input.trigger?(Cancel_Input)
      $game_system.se_play($data_system.decision_se)
      phase3_switch_actor
      return
    end
    return if Input.trigger?(Next_Input) or Input.trigger?(Cancel_Input)
    update_phase3_basic_command_atb 
  end
  #--------------------------------------------------------------------------
  # * Cancel command input
  #--------------------------------------------------------------------------
  def command_input_cancel
    windows_dispose
    if @input_battler != nil
      @input_battler.blink = false
      @input_battlers.delete(@input_battler)
      @input_battler = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose windows
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
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_atb step2_part1
  def step2_part1(battler)
    battler.defense_pose = false
    if battler.cast_action != nil
      active_cast = battler.cast_action
      if active_cast.scope == 1 or active_cast.scope == 3 or active_cast.scope == 5
        battler.current_action.target_index = battler.cast_target
      end
      if active_cast.is_a?(RPG::Skill)
        battler.current_action.kind = 1 
        battler.current_action.skill_id = active_cast.id
      elsif active_cast.is_a?(RPG::Item)  
        battler.current_action.kind = 2 
        battler.current_action.item_id = active_cast.id
      end
      battler.cast_action = nil
    end
    step2_part1_atb(battler)
    if (battler.now_action.is_a?(RPG::Skill) or battler.now_action.is_a?(RPG::Item)) and 
       battler.cast_action.nil? and active_cast.nil?
      battler.cast_action = battler.now_action
      battler.cast_target = battler.current_action.target_index
      cast_speed = battler.now_action.cast_speed(battler)
      battler.cast_action = nil if cast_speed == 0
      unless cast_speed == 0
        battler.movement = false 
        battler.current_phase = 'Phase 5-1'
      end
    end
    if cant_use_action(battler) and battler.cast_action != nil
      battler.cast_action = nil
      battler.moviment = false 
      battler.current_phase = 'Phase 5-1'
    end
    reset_atb(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part1_atb step3_part1
  def step3_part1(battler)
    step3_part1_atb(battler)
    freeze_atb(battler)
  end
  #--------------------------------------------------------------------------
  # * ATB reset
  #     battler : active battler
  #--------------------------------------------------------------------------
  def reset_atb(battler)
    battler.atb = 0 unless battler.passed
    battler.passed = false
  end
  #--------------------------------------------------------------------------
  # * ATB pause
  #     battler : active battler
  #--------------------------------------------------------------------------
  def freeze_atb(battler)
    @freeze_atb << battler if check_include(battler_action(battler), 'FREEZEATB')
    @freeze_atb.uniq!
  end  
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_atb step5_part4
  def step5_part4(battler)
    step5_part4_atb(battler)
    @atb_turn_count += 1 unless Custom_Turn_Count == 2
    @input_battlers.delete(battler)
    @action_battlers.delete(battler)
    @action_battler = nil
    @freeze_atb.delete(battler)
    update_meters
    judge
  end
end