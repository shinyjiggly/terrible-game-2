#==============================================================================
# Add-On: Atoa's Conditional Turn Battle
# by Atoa
#==============================================================================
# This Add-On adds an CTB system (FFX Style)
# If you don't want to use this Add-ON, simply delete it
# The configurations are explained below
#==============================================================================

module N01
  # Do not remove or change these lines
  Cast_Time = {}
  Action_Cost = {}
  # Do not remove or change these lines
  
  # Definition of turn shifting.
  # This definition must be used for the duration of effects and
  # battle event conditions
  # This value does not count to enemies actions conditions
  Custom_Turn_Count = 0
  # 0 = By number of fighters
  # 1 = By number of executed actions
  
  # If 'Custom_Turn_Count = 1', define how many actions are equal to 1 turn
  Action_Turn_Count = 10
  
  # Name of the Escape Option
  Escape_Name = 'Fugir'
  
  #Sound effect played when teh character's turn comes.
  Command_Up_SE = '046-Book01'
 
  # Order Window Postion
  Ctb_Window_Position = [0,64]

  # Order show style
  Ctb_Order_Style = 0
  # 0 = Vertical Window with the battlers names, if an character start to cast
  #     an skill, the skill name will be shown in the window too
  # 1 = Vertical Window with images that represents each battler
  # 2 = Horizontal Window with images that represents each battler
  # 3 = No exhibition

  # Name of the image file shown if an battler do not have an image
  # when 'Ctb_Order_Style' equal 1 or 2.
  # The dimensions of the window are adjusted according to the dimension of
  # this image. It must be on the 'Faces' folder
  Defatult_Ctb_Img = 'default_ctb_turn'

  # File name extensions for the order images
  Ctb_Img_Ext = '_ctb_turn'
  
  # If 'Ctb_Order_Style' equal 1 or 2, you will need the images for the battlers
  # they must be placed on the Faces folder and must have the name equal the
  # battler graphis file name + Ctb_Img_Ext.
  # E.g.: if the battler file name is '001-Fighter01' and Ctb_Img_Ext = '_ctb_turn'
  #  the order image must be named '001-Fighter01_ctb_turn'

  # Number of Names/Images shown on the order window
  Show_Ctb_Turn = 13

  # Hide windows when a battler is executing an action?
  Hide_During_Action = true
  
  # Fade effect an move for images when the order is changed
  # Only if 'Ctb_Order_Style' equal 1 or 2
  Fade_Effect = true
  
  # Order Window Back Opacity
  Ctb_Window_Back_Opacity = 160
  
  # Order Window Border Opacity
  Ctb_Window_Border_Opacity = 255

  # CTB's maximum value, only change if you know what you doing.
  Max_Ctb = 500
 
  # Initial CTB value modifier
  Ctb_Initial_Value = 200
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ACTION COST SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  Defense_Cost   = 200 # Defend
  No_Action_Cost = 100 # No action
  Escape_Cost    = 500 # Escape
  
  Attack_Default_Cost = 300 # Default cost for Attacks
  Item_Default_Cost   = 300 # Default cost for Skills
  Skill_Default_Cost  = 300 # Default cost for Items
  
  # Custom Action cost
  # The actions without custom cost will use the default value
  #  
  #   Action_Cost[Action_Type] = {Action_ID => Cost}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for Weapons
  #     Action_ID = ID of the item, skill or weapon
  #     Cost = Action cost, lower vaule = faster action
  #       Recomended values between 100-500
  Action_Cost['Weapon'] = {}
  
  Action_Cost['Skill'] = {1 => 200, 2 => 350, 3 => 500}
  
  Action_Cost['Item'] = {1 => 200, 2 => 350, 3 => 500}
  
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

  Cast_Time['Skill'] = {1 => [300,'int'], 2 => [400,'int'], 3 => [500,'int'], 
    7 => [300,'int'], 8 => [400,'int'], 9 => [500,'int'], 10 => [300,'int'], 
    11 => [400,'int'], 12 => [500,'int'], 13 => [300,'int'], 14 => [400,'int'], 
    15 => [500,'int'], 16 => [300,'int'], 17 => [400,'int'], 18 => [500,'int'], 
    19 => [300,'int'], 20 => [400,'int'], 21 => [500,'int'], 22 => [300,'int'], 
    23 => [400,'int'], 24 => [500,'int'], 25 => [300,'int'], 26 => [400,'int'], 
    27 => [500,'int'], 28 => [300,'int'], 29 => [400,'int'], 30 => [500,'int']}
  
  Cast_Time['Item'] = {1 => [300,'int'], 2 => [300,'int'], 3 => [300,'int'], 
    7 => [300,'int'], 8 => [300,'int'], 9 => [300,'int'], 10 => [300,'int'], 
    11 => [300,'int'], 12 => [300,'int']}
  
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS CTB'] = true

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
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") * 2) + 100.0
        elsif Cast_Time['Skill'][@id][1] == 'hp' or Cast_Time['Skill'][@id][1] == 'sp' 
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") / 50) + 100.0
        else
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") / 5) + 100.0
        end
      end
      return (cast1 * cast2 / 200).to_i
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
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") * 2) + 100.0
        elsif Cast_Time['Item'][@id][1] == 'hp' or Cast_Time['Item'][@id][1] == 'sp' 
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") / 50) + 100.0
        else
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") / 5) + 100.0
        end
      end
      return (cast1 * cast2 / 200).to_i
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
  def escape_ctb_linetype
    return 2 unless @battle_can_escape
    return 1 if @battle_can_escape
  end
  #--------------------------------------------------------------------------
  def escape_ctb_lineamount
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
  attr_accessor :selected_action
  #--------------------------------------------------------------------------
  alias initialize_ctb initialize
  def initialize
    initialize_ctb
    @cast_skill = @turn_count = 0
    @guarding = false
    @cast_action = nil
  end
  #--------------------------------------------------------------------------
  def ctb_linetype
    return 4 if self.cast_action != nil and self.ctb_full?
    return 3 if self.cast_action != nil
    return 2 if self.ctb_full?
    return 1
  end
  #--------------------------------------------------------------------------
  def ctb_lineamount
    return 0 if self.dead?
    return 100 * self.ctb / self.max_ctb
  end
  #--------------------------------------------------------------------------
  def ctb_enemy_visible
    return 0 if self.dead? and Enemy_Meter > 0
    return 255
  end
  #--------------------------------------------------------------------------
  def max_ctb
    return Max_Ctb
  end
  #--------------------------------------------------------------------------
  def ctb
    return @ctb.nil? ? @ctb = 0 : @ctb
  end
  #--------------------------------------------------------------------------
  def ctb=(n)
    @ctb = [[n.to_i, 0].max, self.max_ctb].min
  end
  #--------------------------------------------------------------------------
  def ctb_preset
    preset = self.max_ctb - (((Ctb_Initial_Value + rand(50)) * (total_agi + 100)) / 
      (self.agi + 100))
    self.ctb = preset 
  end
  #--------------------------------------------------------------------------
  def total_agi
    total = 0
    battlers = 0
    for battler in $game_party.actors + $game_troop.enemies
      unless battler.dead?
        total += battler.agi
        battlers += 1
      end
    end
    total /= [battlers, 1].max
    return total
  end
  #--------------------------------------------------------------------------
  def ctb_full?
    return @ctb == self.max_ctb
  end
  #--------------------------------------------------------------------------
  def action_cost(cost)
    return cost * (total_agi + 100) / (self.agi + 100)
  end
  #--------------------------------------------------------------------------
  def cast_cost(cost, cast)
    return cost * (total_agi + 100) / (cast + 100)
  end
  #--------------------------------------------------------------------------
  def ctb_update(cost)
    if self.cast_action.nil?
      self.ctb -= action_cost(cost)
    else
      self.ctb -= cast_cost(cost, @cast_action.cast_speed(self)) 
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
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  def movable?
    return (self.ctb_full? and super)
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
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  attr_reader :phase
  attr_reader :active_battler
  attr_reader :selection_phase
  attr_reader :action_phase
  attr_reader :end_battle
  attr_reader :battle_start
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias main_ctb_n01 main
  def main
    turn_count_speed  
    @escape_ratio, @action_cost, @need_refresh = 40, 0, 0
    $game_temp.escape_count = 0
    @escape_type, @escape_name = 0, Escape_Name
    @input_battlers, @action_battlers = [], []
    @input_battler, @action_battler = nil, nil
    @update_turn_end, @action_phase, @selection_phase = false, false, false
    main_ctb_n01
  end
  #--------------------------------------------------------------------------
  alias start_ctb_n01 start
  def start
    start_ctb_n01
    for battler in $game_party.actors + $game_troop.enemies
      battler.turn_count = 0
      battler.ctb = 0
      battler.ctb_preset
      battler.cast_action = nil
      battler.cast_target = nil
    end
    for actor in $game_party.actors
      actor.ctb = actor.max_ctb - 1 if $preemptive
      actor.ctb = 0 if $back_attack 
    end
    for enemy in $game_troop.enemies
      enemy.ctb = 0 if $preemptive
      enemy.ctb = enemy.max_ctb - 1 if $back_attack 
    end
    @ctb_window = Window_Ctb.new
  end
  #--------------------------------------------------------------------------
  alias terminate_ctb_n01 terminate
  def terminate
    terminate_ctb_n01
    @ctb_window.dispose
  end
  #--------------------------------------------------------------------------
  alias update_ctb_n01 update
  def update
    if @phase == 1
      $game_temp.battle_main_phase = true
      @actor_command_window.opacity = 0
      @phase = 0
    elsif @phase != 5
      @phase = 0
    end
    @event_running = true if $game_system.battle_interpreter.running?
    update_ctb_n01
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
    ctb_update
    if @action_battlers[0] != nil && @action_battler.nil?
      @action_battlers.flatten!
      @action_battler = @action_battlers[0]
      if @action_battler.dead?
        @action_battler.ctb = 0
        @action_battler = nil
      else
        start_phase4
      end
    end
    input_battler_update if @action_battler.nil?
    if @action_battler != nil && !@spriteset.effect?
      @active_battler = @action_battler
      update_phase4
    end
  end
  #--------------------------------------------------------------------------
  alias update_basic_ctb update_basic
  def update_basic
    update_basic_ctb
    @ctb_window.refresh if Ctb_Order_Style != 0
  end
  #--------------------------------------------------------------------------
  def input_battler_update
    for battler in $game_troop.enemies + $game_party.actors
      if battler.ctb_full? and battler != @action_battler and not
         @action_battlers.include?(battler)
        battler_turn(battler)
        break unless battler.actor?
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
      elsif @input_battler.inputable? and @input_battler.ctb_full?
        @actor_index = $game_party.actors.index(@input_battler)
        @input_battler.current_action.clear
        @input_battler.blink = true
      else
        @action_cost = No_Action_Cost
        @input_battlers.shift
        @input_battler = nil
      end
    end
    if @input_battler != nil
      @now_battler = @active_battler
      @input_battler.defense_pose = false
      @active_battler = @input_battler
      phase3_setup_command_window if @actor_command_window.opacity == 0
      update_phase3
      @active_battler = @now_battler
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
      if battler.ctb_full? and battler.inputable? and battler.cast_action.nil?
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
  alias judge_ctb judge
  def judge
    @ctb_window.refresh
    @end_battle = judge_ctb
    return @end_battle
  end
  #--------------------------------------------------------------------------
  def ctb_update
    @wait_on = wait_on
    return if @wait_on
    if @ctb_turn_count >= @abt_turn_speed
      @update_turn_end = true
      $game_temp.battle_turn += 1
      turn_count_speed
      for battler in $game_party.actors + $game_troop.enemies
        battler.remove_states_auto if battler.exist?
      end
      setup_battle_event
    end
    all_ctb = []
    for battler in $game_party.actors + $game_troop.enemies
      battler.cast_action = nil unless battler.exist?
      all_ctb << battler.max_ctb - battler.ctb if battler.exist?
    end
    all_ctb.sort!
    for battler in $game_party.actors + $game_troop.enemies
      battler.ctb += all_ctb[0] if battler.exist? and not battler.restriction == 4
    end
  end
  #--------------------------------------------------------------------------
  def wait_on
    return true if @input_battler != nil or @action_battler != nil
    return true if @force_wait or @end_battle
    return false
  end
  #--------------------------------------------------------------------------
  def start_phase2
  end
  #--------------------------------------------------------------------------
  def turn_count_speed
    @ctb_turn_count = @abt_turn_speed = 0
    case Custom_Turn_Count
    when 0
      for battler in $game_party.actors + $game_troop.enemies
        @abt_turn_speed += 1 if battler.exist?
      end
    when 1
      @abt_turn_speed = Action_Turn_Count
    end
  end
  #--------------------------------------------------------------------------
  def update_phase2_escape
    windows_dispose
    update_phase2_escape_type1
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
    @party_command_window.visible = false
    @party_command_window.active = false
    wait(2)
    if @success
      @end_battle = true
      @ctb_window.refresh
      $game_system.se_play($data_system.escape_se)
      $game_system.bgm_play($game_temp.map_bgm)
      battle_end(1)
    else
      @escape_ratio += 3
      @action_cost = Escape_Cost
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  def cancel_action(cost)
    @input_battlers.delete(@active_battler)
    @active_battler.ctb_update(cost)
    @ctb_window.refresh
    @active_battler.blink = false
    if @actor_command_window != nil
      @actor_command_window.active = false
      @actor_command_window.visible = false
      @active_battler_window.visible = false
      @actor_command_window.opacity = 0
    end
    @input_battler = nil
    @actor_index = nil
    @active_battler = nil
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
  alias start_phase5_ctb start_phase5
  def start_phase5
    if @input_battler != nil
      @help_window.visible = false if @help_window != nil
      windows_dispose
      @input_battler.blink = false if @input_battler != nil
    end
    start_phase5_ctb
  end
  #--------------------------------------------------------------------------
  alias update_phase5_ctb_n01 update_phase5
  def update_phase5
    windows_dispose
    update_phase5_ctb_n01
  end
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    @battle_start = false
    if @active_battler != nil && @active_battler.cast_action != nil
      @active_battler.blink = false
      return    
    end
    @action_phase = false
    @selection_phase = true
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
    @ctb_window.refresh
  end
  #--------------------------------------------------------------------------
  alias update_phase3_skill_select_ctb_n01 update_phase3_skill_select
  def update_phase3_skill_select
    @active_battler.selected_action = @skill_window.skill
    if @curent_index != @skill_window.index
      @ctb_window.refresh
      @curent_index = @skill_window.index
      @curent_command_index = nil
    end
    update_phase3_skill_select_ctb_n01
  end
  #--------------------------------------------------------------------------
  alias update_phase3_item_select_ctb_n01 update_phase3_item_select
  def update_phase3_item_select
    @active_battler.selected_action = @item_window.item
    if @curent_index != @item_window.index
      @ctb_window.refresh
      @curent_index = @item_window.index
      @curent_command_index = nil
    end
    update_phase3_item_select_ctb_n01
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
  alias update_phase3_ctb_n01 update_phase3
  def update_phase3
    @ctb_window.refresh if Ctb_Order_Style != 0
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
    update_phase3_ctb_n01
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
  alias update_phase3_basic_command_ctb_n01 update_phase3_basic_command
  def update_phase3_basic_command
    case @actor_command_window.commands[@actor_command_window.index]
    when $data_system.words.attack
      @active_battler.selected_action = $data_weapons[@active_battler.weapon_id].nil? ?
       'Attack' : $data_weapons[@active_battler.weapon_id]
    when $data_system.words.guard 
      @active_battler.selected_action = 'Defend'
    when @escape_name
      @active_battler.selected_action = 'Escape'
    else
      @active_battler.selected_action = ''
    end
    if @curent_command_index != @actor_command_window.index
      @ctb_window.refresh
      @curent_command_index = @actor_command_window.index
      @curent_index = nil
    end
    if Input.trigger?(Input::A)
      $game_system.se_play($data_system.decision_se)
      @selection_phase = false
      @action_cost = No_Action_Cost
      phase3_next_actor
      return
    end
    if Input.trigger?(Input::C)
      case @actor_command_window.commands[@actor_command_window.index]
      when @escape_name
        if $game_temp.battle_can_escape == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        @selection_phase = false
        update_phase2_escape
        return
      end
    end
    update_phase3_basic_command_ctb_n01
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
      @enemy_arrow_all.dispose
      @enemy_arrow_all = nil
    end
    if @actor_arrow_all != nil
      @actor_arrow_all.dispose
      @actor_arrow_all = nil
    end
    if @battler_arrow_all != nil
      @enemy_arrow_all.dispose
      @enemy_arrow_all = nil
    end
    if @actor_command_window != nil
      @actor_command_window.active = false
      @actor_command_window.visible = false
      @active_battler_window.visible = false
      @actor_command_window.opacity = 0
    end
    @selection_phase = false
    @status_window.visible = true
  end
  #--------------------------------------------------------------------------
  alias update_phase4_step1_ctb_n01 update_phase4_step1
  def update_phase4_step1
    if @action_battlers.size == 0
      @input_battlers.clear
      @action_battlers.clear
      @action_battler = nil
    end
    update_phase4_step1_ctb_n01
  end  
  #--------------------------------------------------------------------------
  alias update_phase4_step2_ctb_n01 update_phase4_step2
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
    set_action_cost
    update_phase4_step2_ctb_n01
  end
  #--------------------------------------------------------------------------
  alias make_skill_action_result_ctb_n01 make_skill_action_result
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
    make_skill_action_result_ctb_n01
    @active_battler.cast_action = nil
  end
  #--------------------------------------------------------------------------
  alias make_item_action_result_ctb_n01 make_item_action_result
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
    make_item_action_result_ctb_n01
    @active_battler.cast_action = nil
  end 
  #--------------------------------------------------------------------------
  def set_action_cost
    if  @active_battler.current_action.kind == 0
      if @active_battler.current_action.basic == 0
        if Action_Cost['Attack'] != nil and Action_Cost['Attack'][@now_action.id] != nil and 
           @now_action.is_a?(RPG::Weapon)
          @action_cost = Action_Cost['Attack'][@now_action.id]
        else
          @action_cost = Attack_Default_Cost
        end
      elsif @active_battler.current_action.basic == 1
        @action_cost = Defense_Cost
      elsif @active_battler.is_a?(Game_Enemy) and @active_battler.current_action.basic == 2
        @action_cost = Escape_Cost
      elsif @active_battler.current_action.basic == 3
        @action_cost = No_Action_Cost
      end
    elsif @active_battler.current_action.kind == 1
      if Action_Cost['Skill'] != nil and Action_Cost['Skill'][@now_action.id] != nil and 
         @now_action.is_a?(RPG::Skill)
        @action_cost = Action_Cost['Skill'][@now_action.id]
      else
        @action_cost = Skill_Default_Cost
      end
    elsif @active_battler.current_action.kind == 2
      if Action_Cost['Item'] != nil and Action_Cost['Item'][@now_action.id] != nil and 
         @now_action.is_a?(RPG::Item)
        @action_cost = Action_Cost['Item'][@now_action.id]
      else
        @action_cost = Item_Default_Cost
      end
    else
      @action_cost = No_Action_Cost
    end
  end
  #--------------------------------------------------------------------------
  def start_phase4
    @phase4_step = 1
    @selection_phase = false
    @action_phase = true
    @ctb_window.refresh
  end
  #--------------------------------------------------------------------------
  alias update_phase4_step6_ctb_n01 update_phase4_step6
  def update_phase4_step6
    update_phase4_step6_ctb_n01
    @ctb_turn_count += 1
    @active_battler.ctb_update(@action_cost)
    @input_battlers.delete(@active_battler)
    @action_battlers.delete(@active_battler)
    @action_battler = nil
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
# ■ Window_Command
#==============================================================================
class Window_Ctb < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    case Ctb_Order_Style
    when 0,3
      x, y = Ctb_Window_Position[0], Ctb_Window_Position[1]
      z, w, h = 3900, 160, 22 + (18 * Show_Ctb_Turn)
      @back_opacity, @opacity = Ctb_Window_Back_Opacity, Ctb_Window_Border_Opacity
    when 1
      x, y = Ctb_Window_Position[0], Ctb_Window_Position[1]
      w = RPG::Cache.faces(Defatult_Ctb_Img).width + 32
      h = [((RPG::Cache.faces(Defatult_Ctb_Img).height + 2) * Show_Ctb_Turn) + 32, 480].min
      z, @back_opacity, @opacity = 3900, Ctb_Window_Back_Opacity, Ctb_Window_Border_Opacity
    when 2
      x, y = Ctb_Window_Position[0], Ctb_Window_Position[1]
      w = [((RPG::Cache.faces(Defatult_Ctb_Img).width + 2) * Show_Ctb_Turn) + 32, 640].min
      h = RPG::Cache.faces(Defatult_Ctb_Img).height + 32
      z, @back_opacity, @opacity = 3900, Ctb_Window_Back_Opacity, Ctb_Window_Border_Opacity
    end
    super(x, y, w, h)
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
    self.back_opacity = @back_opacity
    self.opacity = @opacity
    self.z = z
    @img_position = 0
    @order = []
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear 
    if $scene.battle_start or $scene.end_battle or Ctb_Order_Style == 3 or
      ($scene.action_phase and Hide_During_Action)
      self.back_opacity = 0
      self.opacity = 0
      self.contents_opacity = 0
      return
    else
      self.back_opacity = @back_opacity
      self.opacity = @opacity
      self.contents_opacity = 255
    end
    @old_order = @order.dup
    @order.clear
    get_ctb
    @order.sort!{|a,b| b[0] <=> a[0]}
    @img_position = 0 if @old_order != @order and not $scene.action_phase
    @img_position = 10 unless Fade_Effect
    if Ctb_Order_Style == 0
      self.contents.font.color = system_color
      self.contents.font.size = 22
      self.contents.font.bold = true
      self.contents.draw_text(0, 0, 100, 22, 'Ordem')
      for i in 0...@order.size
        battler = @order[i]
        y = 18 * i
        self.contents.font.size = i == 0 ? 18 : 14
        self.contents.font.bold = i == 0 ? true : false
        self.contents.font.color = normal_color if i == 0
        self.contents.font.color = system_color if i > 0
        name = i == 0 ? '> ' + battler[1].name : battler[1].name
        if battler[2] != ''
          self.contents.font.color = crisis_color
          name = name + ' > ' + battler[2]
        end
        self.contents.font.color = knockout_color if battler[3] == 2 or battler[3] == 3
        self.contents.font.color = disabled_color if battler[3] == 4
        self.contents.draw_text(4, y + 24, self.width - 32, 18, name)
      end
    elsif Ctb_Order_Style == 1
      @img_position = [@img_position + 1, 10].min
      y = 0
      for i in 0...@order.size
        battler = @order[i]
        hue = battler[1].battler_hue
        begin; @img = RPG::Cache.faces(battler[1].battler_name + Ctb_Img_Ext, hue)
        rescue; @img = RPG::Cache.faces(Defatult_Ctb_Img); end
        @width  = @img.width
        @height = @img.height 
        x = battler[1].actor? ? @width * (@img_position - 10) / 10 : 
          @width * (10 - @img_position) / 10
        src_rect = Rect.new(0, 0, @width, @height)
        self.contents.blt(x, y, @img, src_rect)
        self.contents_opacity = 155 + @img_position * 10
        y += @height + 2
      end
    elsif Ctb_Order_Style == 2
      @img_position = [@img_position + 1, 10].min
      x = 0
      for i in 0...@order.size
        battler = @order[i]
        hue = battler[1].battler_hue
        begin; @img = RPG::Cache.faces(battler[1].battler_name + Ctb_Img_Ext, hue)
        rescue; @img = RPG::Cache.faces(Defatult_Ctb_Img); end
        @width  = @img.width
        @height = @img.height 
        y = battler[1].actor? ? @height * (@img_position - 10) / 10 : 
          @height * (10 - @img_position) / 10
        src_rect = Rect.new(0, 0, @width, @height)
        self.contents.blt(x, y, @img, src_rect)
        self.contents_opacity = 155 + @img_position * 10
        x += @width + 2
      end
    end
  end
  #--------------------------------------------------------------------------
  def get_ctb
    i = 0
    while @order.size < Show_Ctb_Turn
      for member in $game_party.actors + $game_troop.enemies
        next if member.dead? or !member.exist?
        if i == 0
          if $scene.active_battler != nil and $scene.selection_phase and
             member == $scene.active_battler
            ctb = Max_Ctb + 1
            cast_name = ''
          else
            ctb = member.ctb
            cast_name = member.cast_action.nil? ? '' : member.cast_action.name
          end
        else
          if $scene.active_battler != nil and $scene.selection_phase and i == 1 and
             member == $scene.active_battler
            action = $scene.active_battler.selected_action
            cast = 0
            case action
            when 'Attack'
              ctb = Max_Ctb - member.action_cost(Attack_Default_Cost)
            when 'Defend'
              ctb = Max_Ctb - member.action_cost(Defense_Cost) 
            when 'Escape'
              ctb = Max_Ctb - member.action_cost(Escape_Cost)
            when RPG::Weapon
              if Action_Cost['Attack'] != nil and Action_Cost['Attack'][action.id] != nil
                cost = Action_Cost['Attack'][action.id]
                ctb = Max_Ctb - member.action_cost(cost)
              else
                ctb = Max_Ctb - member.action_cost(Attack_Default_Cost)
              end
            when RPG::Skill
              if Action_Cost['Skill'] != nil and Action_Cost['Skill'][action.id] != nil
                cost = Action_Cost['Skill'][action.id]
              else
                cost = Skill_Default_Cost
              end
              if Cast_Time['Skill'] != nil and Cast_Time['Skill'][action.id] != nil
                cast = action.cast_speed(member)
              end
              if cast != 0
                ctb = Max_Ctb - member.cast_cost(cost, cast)
              else
                ctb = Max_Ctb - member.action_cost(cost)
              end
            when RPG::Item
              if Action_Cost['Item'] != nil and Action_Cost['Item'][action.id] != nil
                cost = Action_Cost['Item'][action.id]
              else
                cost = Item_Default_Cost
              end
              if Cast_Time['Item'] != nil and Cast_Time['Item'][action.id] != nil
                cast = action.cast_speed(member)
              end
              if cast != 0
                ctb = Max_Ctb - member.cast_cost(cost, cast)
              else
                ctb = Max_Ctb - member.action_cost(cost)
              end
            else
              cast = 0
              ctb = Max_Ctb - member.action_cost(No_Action_Cost)
            end
            cast_name = cast == 0 ? '' : action.name
          else
            base_ctb = member.action_cost(Attack_Default_Cost)
            ctb = member.ctb - (base_ctb * i)
            cast_name = ''
          end
        end
        next unless ctb.is_a?(Numeric)
        @order << [ctb, member, cast_name, member.restriction]
      end
      i += 1
    end
  end
end