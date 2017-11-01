#==============================================================================
# Skill Combinação
# By Atoa
#==============================================================================
# This script allows you to create 'Combination' skills
# 
# These skill needs the participation of more than one actor.
#
# The skill power is based on the average of the participants stats.
# So, set valuers higher than the normal for combination skill.
#
# Add this scripts bellow the script 'ACBS | Battle Main Code'
# He must stay bellow *ALL* other battle related scripts
#
#¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
#                           ***IMPORTANT WARNING***                          #
#¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
#
# These settings are *VERY* complex and need an good RGSS knowledge
# If you're an noob on RPG Maker, DON'T MESS WITH THIS PART!
# I won't give any support for novice to use the Skill Combination
# So learn basic RGSS before trying to change here.
# Don't complain that it's don't work if you don't know what you doing.
#
#==============================================================================

module Atoa
  # Do not remove or change this line
  Combination_Skill ={}
  # Do not remove or change this line
    
  Skill_Settings[117] = ["MOVEPOSITION/0,-20,80,40,200","ANIME/15"]
  Skill_Settings[118] = ["MOVEPOSITION/0,20,80,-40,200","ANIME/13"]
  Skill_Settings[119] = ["MOVETYPE/NOMOVE","ANIME/Magic_Pose"]
  
  Skill_Settings[120] = ["MOVETYPE/STEPFOWARD"]
  
  Skill_Settings[123] = ["MOVETYPE/NOMOVE","ANIME/Magic_Pose"]
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # COMBINATION SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # The combinations are divided in 4 types 'Union', 'Fusion', 'Combination'
  # and 'Sequence'.
  # Each type has it own features.
  # They can enter in conflit if the combinations uses the same skills.
  # So, avoid using the same skills in various combinations types.
  #
  
  # UNION:
  # Union are skills where you combine battlers to use an skill.
  # You can only use them if all the battlers needed for the combination
  # are in condition to act.
  # Like the 'Unite' of Suikoden series
  # 
  # IMPORTANTE: 
  # - if used with the Atoa ATB, the union skill will be avaliable only
  #   when all needed actors have their bar full.
  # - if used with the Atoa CTB, the union skill will be avaliable only
  #   when all needed actors are near to act
  #
  # Combination_Skill['Union'] = {
  #   [Battler_Type, Skill_ID] => {Battler_ID =>[Effect_ID]},
  #   }
  # 
  #   Battler_Type = type of the battlers that participate of the combination
  #     'Actor' = the users are actors
  #     'Enemy' = the users are enemies
  #   Skill_ID = ID of the skill used and the result skill of the combiantion
  #   Effect_ID = ID of the skills that are used during the combination.
  #     each actor execute one action depending on the array index
  #
  Combination_Skill['Union'] =  {
  ['Actor', 100] => {1 =>[117, nil], 2 =>[118, nil], 4 =>[nil, 119]},
  ['Enemy', 101] => {5 =>[120], 6 =>[121]}
  }
  
  # FUSION:
  # Fusion are skill wich you combine two or more skills to make a new one.
  # If the skills that is part of the combination are used separately,
  # nothing happens, the skills are used normally.
  # Bur if all skills are used in the same turn, an new skill is used instead.
  # E.g.: You have an Fusion of Cross Cut and Fire.
  #   If you use them alone, they're used normally, but if you use them in the
  #   same turn, the skill 'Cross Fire' will be used instead.
  #
  # IMPORTANT:
  #   Doesn't work with the Atoa ATB or Atoa CTB
  #
  # Combination_Skill['Fusion'] = {
  #   Result_Skill_ID => {Fusion_Skill_ID =>[Effect_ID]},
  #   }
  #
  # 
  #   Result_Skill_ID = ID of the skill resulted of the Fusion
  #   Fusion_Skill_ID = IDs of the skills that makes the fusion
  #     You can set different moves based on the 'Fusion_Skill_ID'
  #     The battler thar is using that skill will do the corresponding move
  #   Effect_ID = ID of the skills that are used during the combination.
  #     each actor execute one action depending on the array index
  #
  Combination_Skill['Fusion'] = {
  102 => {7 =>[123], 57 =>[122]}
  }
  
  # COOPERATION:
  # Cooperation are skills thats needs more than one character to execute them.
  # Different from the 'Union', they're not based on the battler ID.
  # You need an number of battlers to use the skill, then, when this number is
  # reached, the skill is executed
  #
  # Combination_Skill['Cooperation'] = {
  #    Skill_ID => {Battler_Index =>[Effect_ID]},
  #    }
  # 
  #   Skill_ID = ID of the skill result of the Cooperation
  #   Battler_Index = Index fo the Battler, it's the number of 'indexes' that
  #     define, how many battlers will be needed to execute the skill.
  #     Must be always on order from 0 to the number of participating battler - 1
  #     The move is based on the index and the battler ID, the battler with
  #     the lower ID will execute the move with the lower index
  #   Effect_ID = ID das skills que são executadas na combinação.
  #     cada personagem executa sua respectiva ação de acordo com o index da array.
  #
  Combination_Skill['Cooperation'] = {
  103 => {0 =>[117], 1 =>[118], 2 =>[119]}
  }
  
  # SEQUENCE:
  # Squence are skills differents from the others, in the ones before, all the
  # battlers participates on the skill execution, but not on this.
  # In the sequence types combo, the skills are used normally, but when an
  # sequence is done, the last skill used becomes an new skill.
  # You can create sequences based on Skill ID or Elements ID
  # Similar to the combo system of Breath of Fire 4
  #
  # E.g 1.: when use the skills 'Fire', 'Fire' and 'Fira' in this order, the skill
  #   'Fira' won't be used, instead, the skill 'Blazing Hell' will be used
  # E.g 2.: when use an fire element skill and an wind element skill in this order
  #   the wind element skill will became the skill 'Explosion'.
  #
  # Note: In the case of elemental combination, if an skill have more than one element
  #  only the first will be considered
  #
  # There's also some extra settings for this combination type.
  #
  # Combination_Skill['Sequence'] = { Result_Skill_ID => [Action_Type, [Sequence_ID]]},
  #   Result_Skill_ID = ID of the skill result of the Sequence
  #   Action_Type = sequence type
  #     'Skill' = the combination is based on skill ID
  #     'Element' = the combination is based on skill Element
  #   Sequence_ID = IDs of the skill/elements useds in the sequence.
  #     The order you add the IDs here is what define the order that the
  #     skills must be used
  #
  Combination_Skill['Sequence'] = {
  104 => ['Skill', [7,7,8]],
  105 => ['Element', [1,6]],
  }
    
  # IDs of the skills thats negates sequence of elemental skills
  # Must be used in the case you don't want an skill to enter an elemental sequence
  # E.g.: The sword skill 'Hurricane' is wind elemental, but you don't want it
  # to make part of the 'Explosion' (fire » wind) sequence
  No_Sequence_Skills = [59]
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Combination'] = true

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
  attr_accessor :combination_battlers
  attr_accessor :cp_actors
  attr_accessor :cp_enemies
  attr_accessor :active_battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_combination initialize
  def initialize
    initialize_combination
    @active_battler = nil
    @combination_battlers = []
    @cp_actors = {}
    @cp_enemies = {}
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
  attr_accessor :in_combination
  attr_accessor :old_fusion
  attr_accessor :new_fusion
  attr_accessor :cp_skill
  attr_accessor :cooperation_index
  attr_accessor :combination_battlers
  attr_accessor :union_members
  attr_accessor :union
  attr_accessor :fusion
  attr_accessor :cooperation
  attr_accessor :combination_id
  attr_accessor :current_move
  attr_accessor :old_skill_used_id
  attr_accessor :move_size
  attr_accessor :union_leader
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_combination initialize
  def initialize
    initialize_combination
    @combination_battlers = []
    @union = []
    @fusion = []
    @cooperation = []
    @union_members = []
    @combination_id = 0
    @current_move = 0
    @old_skill_used_id = 0
    @move_size = 0
    @cooperation_index = 0
    @union_leader = false
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Combination
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def combination_can_use?(skill_id)
    skill = $data_skills[skill_id]
    if check_include(skill, 'CONSUMEHP')
      return false if calc_sp_cost(skill) > self.hp
    else
      return false if calc_sp_cost(skill) > self.sp
    end
    return false if dead?
    return false if $data_skills[skill_id].atk_f == 0 and self.restriction == 1
    occasion = skill.occasion
    return (occasion == 0 or occasion == 1) if $game_temp.in_battle
    return (occasion == 0 or occasion == 2) if !$game_temp.in_battle
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
  alias inputable_combination inputable?
  def inputable?
    return false if is_on_union?
    return inputable_combination
  end
  #--------------------------------------------------------------------------
  # * Decide if battler in on union
  #--------------------------------------------------------------------------
  def is_on_union?
    for battler in $game_party.actors
      return true if battler.union_members.include?(self)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias skill_can_use_combination_gameactor skill_can_use?
  def skill_can_use?(skill_id)
    if Combination_Skill['Union'] != nil and Combination_Skill['Union'].is_a?(Hash) and
       Combination_Skill['Union'].keys.include?(['Actor', skill_id])
      union = Combination_Skill['Union'][['Actor', skill_id]].dup
      for id in union.keys
        battler = $game_actors[id]
        return false unless $game_party.actors.include?(battler)
        return false unless battler.combination_can_use?(skill_id)
        return false unless battler.restriction <= 1 and not $atoa_script['Atoa CTB']
        return false if $atoa_script['Atoa CTB'] and not_all_next(union, battler)
      end
    end
    return skill_can_use_combination_gameactor(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Check if all battlers in union are about to act (only for 'Add | Atoa CTB')
  #     battler : battler
  #     union   : union skill
  #--------------------------------------------------------------------------
  def not_all_next(union, battler)
    battlers = $game_party.actors.dup + $game_troop.enemies.dup
    battlers.sort!{|a,b| b.ctb <=> a.ctb}
    for index in 0...union.keys.size
      return false if battlers[index] == battler
    end
    return true
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
  # * Decide if Command is Inputable
  #--------------------------------------------------------------------------
  alias inputable_combination inputable?
  def inputable?
    return false if is_on_union?
    return inputable_combination
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    if Combination_Skill['Union'] != nil and Combination_Skill['Union'].is_a?(Hash) and
       Combination_Skill['Union'].keys.include?(['Enemy', skill_id])
      union = Combination_Skill['Union'][['Enemy', skill_id]].dup
      for id in union.keys
        battler = set_enemy_battler(id)
        return false unless battler != nil and battler.exist?
        return false unless battler.combination_can_use?(skill_id)
        return false unless battler.inputable?
      end
    end
    return super
  end
  #--------------------------------------------------------------------------
  # * Get enemy for combination
  #     id : enemy ID
  #--------------------------------------------------------------------------
  def set_enemy_battler(id)
    for enemy in $game_troop.enemies
      return enemy if enemy.id == id
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Decide if battler in on union
  #--------------------------------------------------------------------------
  def is_on_union?
    for battler in $game_troop.enemies
      return true if battler.union_members.include?(self)
    end
    return false
  end
end

#==============================================================================
# ** Scene_Battle (part 1)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias start_combination start
  def start
    start_combination
    for battler in $game_troop.enemies + $game_party.actors
      reset_combination(battler)
    end
    reset_cooperaion
    @actors_skill_sequence = []
    @enemies_skill_sequence = []
    @actors_element_sequence = []
    @enemies_element_sequence = []
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_combination update
  def update
    $game_temp.active_battler = @active_battler
    update_combination
  end
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  alias start_phase2_combination start_phase2
  def start_phase2
    start_phase2_combination
    unless $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
      for battler in $game_troop.enemies + $game_party.actors
        reset_combination(battler)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input of Previous Actor
  #--------------------------------------------------------------------------
  def phase3_prior_actor
    begin
      @active_battler.blink = false if @active_battler != nil
      @active_battler.current_action.clear
      return start_phase2 if @actor_index == 0
      @actor_index -= 1
      @active_battler = $game_party.actors[@actor_index]
      @active_battler.union_members.clear
      @active_battler.blink = true
    end until @active_battler.inputable?
    phase3_setup_command_window
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : skill selection)
  #--------------------------------------------------------------------------
  alias update_phase3_skill_select_combination update_phase3_skill_select
  def update_phase3_skill_select
    @active_battler.union_members.clear
    update_phase3_skill_select_combination
  end
  #--------------------------------------------------------------------------
  # * Confirm Action Selection
  #     action : current action
  #--------------------------------------------------------------------------
  alias confirm_action_select_combination confirm_action_select
  def confirm_action_select(action)
    if action != nil and @active_battler.skill_can_use?(action.id) and
       Combination_Skill['Union'] != nil and Combination_Skill['Union'].is_a?(Hash) and
       Combination_Skill['Union'].keys.include?(['Actor', action.id])      
      union = Combination_Skill['Union'][['Actor', action.id]].dup
      @active_battler.union_members.clear
      for id in union.keys
        @active_battler.union_members << $game_actors[id]
      end
      @active_battler.union_leader = true
      for battler in @active_battler.union_members
        next if battler == @active_battler
        battler.current_action.clear
      end
    end
    confirm_action_select_combination(action)
  end
  #--------------------------------------------------------------------------
  # * Make Skill Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  alias make_skill_action_result_combination make_skill_action_result
  def make_skill_action_result(battler)
    if battler_in_combination(battler)
      return make_skill_combination_action_result(battler)
    elsif battler.in_combination == 'Sequence'
      return make_skill_sequence_action_result(battler)
    end 
    make_skill_action_result_combination(battler)
  end
  #--------------------------------------------------------------------------
  # * Make Combination Skill Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  def make_skill_combination_action_result(active)
    old_skill = $data_skills[active.combination_id]
    for battler in active.combination_battlers
      next if battler.now_action.nil?
      battler.current_skill = battler.now_action
    end
    if battler.in_combination == 'Union'
      return if check_union(active)
    elsif battler.in_combination == 'Fusion'
      return if check_fusion(active)
    elsif battler.in_combination == 'Cooperation'
      return if check_cooperation(active)
    end
    unless active.multi_action_running
      for battler in active.combination_battlers
        battler.consume_skill_cost(old_skill)
      end
    end
    active.multi_action_running = true
    @status_window.refresh if status_need_refresh
    for battler in active.combination_battlers
      next if battler.now_action.nil?
      battler.animation_1 = battler.now_action.animation1_id
      battler.animation_2 = battler.now_action.animation2_id
    end
    @common_event_id = active.current_skill.common_event_id
    for target in active.target_battlers
      taget_damage = 0
      for battler in active.combination_battlers
        next if battler.now_action.nil?
        target.skill_effect(battler, battler.now_action)
        taget_damage += battler.target_damage[target] if battler.target_damage[target].numeric?
        battler.target_damage[target] = nil
      end
      active.target_damage[target] = taget_damage
    end
    for battler in active.combination_battlers
      if $atoa_script['Atoa Overdrive'] and battler.actor?
        action = $data_skills[battler.combination_id]
        battler.overdrive = 0 if Overdrive_Skills.keys.include?(action.id)
      end
    end
  end 
  #--------------------------------------------------------------------------
  # * Make Squence Skill Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  def make_skill_sequence_action_result(battler)
    old_skill = $data_skills[battler.old_skill_used_id]
    battler.current_skill = battler.now_action
    unless battler.current_action.forcing or battler.multi_action_running
      unless battler.skill_can_use?(old_skill.id)
        $game_temp.forcing_battler = nil
        return
      end
    end
    unless battler.multi_action_running
      battler.consume_skill_cost(old_skill)
    end
    if old_skill.scope != battler.current_skill.scope
      battler.target_battlers = []
      set_targets(battler)
    end
    battler.multi_action_running = true
    @status_window.refresh if status_need_refresh
    battler.animation_1 = battler.now_action.animation1_id
    battler.animation_2 = battler.now_action.animation2_id
    @common_event_id = battler.current_skill.common_event_id
    for target in battler.target_battlers
      target.skill_effect(battler, battler.current_skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Checks for updating battler current phase
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias update_current_phase_combination update_current_phase
  def update_current_phase(battler)
    if battler_in_combination(battler)
      need_return = false
      for target in battler.combination_battlers
        target.wait_time = [target.wait_time - 1, 0].max
        need_return |= (target.wait_time > 0 or target.moving?)
      end
      return if need_return
    end
    update_current_phase_combination(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_combination step2_part1
  def step2_part1(battler)
    set_combination_action(battler)
    step2_part1_combination(battler)
    add_skill_to_sequence(battler)
    if battler.in_combination == 'Union'
      union_step2_part1(battler)
    elsif battler.in_combination == 'Fusion'
      fusion_step2_part1(battler)
    elsif battler.in_combination == 'Cooperation'
      cooperation_step2_part1(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part1_combination step3_part1
  def step3_part1(battler)
    if battler.in_combination == 'Union'
      union_step3_part1(battler)
    elsif battler.in_combination == 'Fusion'
      fusion_step3_part1(battler)
    elsif battler.in_combination == 'Sequence'
      sequence_step3_part1(battler)
    elsif battler.in_combination == 'Cooperation'
      cooperation_step3_part1(battler)
    else
      step3_part1_combination(battler)
    end
  end  
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part2_combination step3_part2
  def step3_part2(battler)
    if battler_in_combination(battler)
      combination_step3_part2(battler)
    else
      step3_part2_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part3_combination step3_part3
  def step3_part3(battler)
    if battler_in_combination(battler)
      combination_step3_part3(battler)
    else
      step3_part3_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part1_combination step4_part1
  def step4_part1(battler)
    if battler_in_combination(battler)
      combination_step4_part1(battler)
    else
      step4_part1_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part2_combination step4_part2
  def step4_part2(battler)
    if battler_in_combination(battler)
      combination_step4_part2(battler)
    else
      step4_part2_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part3_combination step4_part3
  def step4_part3(battler)
    if battler_in_combination(battler)
      combination_step4_part3(battler)
    else
      step4_part3_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part1_combination step5_part1
  def step5_part1(active)
    step5_part1_combination(active)
    if battler_in_combination(active)
      battlers_current_phase(active, 'Phase 5-2') 
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part2_combination step5_part2
  def step5_part2(battler)
    if battler_in_combination(battler)
      combination_step5_part2(battler)
    else
      step5_part2_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part3_combination step5_part3
  def step5_part3(active)
    step5_part3_combination(active)
    if battler_in_combination(active)
      battlers_current_phase(active, 'Phase 5-4') 
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_combination step5_part4
  def step5_part4(battler)
    if battler_in_combination(battler)
      combination_step5_part4(battler)
    else
      step5_part4_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Check action sequence
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias check_action_sequence_combination check_action_sequence
  def check_action_sequence(battler)
    if battler_in_combination(battler)
      combination_check_action_sequence(battler)
    else
      check_action_sequence_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set move position
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_move_postion_combination set_move_postion
  def set_move_postion(battler)
    if battler_in_combination(battler)
      set_move_init(battler)
    else
      set_move_postion_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set combination actions
  #     battler : battler
  #     active  : active battler
  #--------------------------------------------------------------------------
  def set_actions(battler, active)
    battler.combination_battlers = active.combination_battlers
    battler.cooperation = active.cooperation
    battler.union = active.union
    battler.fusion = active.fusion
    battler.combination_id = active.combination_id
    battler.current_move = active.current_move
    battler.target_battlers = active.target_battlers
    battler.current_action.kind = active.current_action.kind
    battler.current_action.skill_id = active.current_action.skill_id
    battler.current_action.target_index = active.current_action.target_index
  end
  #--------------------------------------------------------------------------
  # * Check if battler is in combination
  #     active  : active battler
  #--------------------------------------------------------------------------
  def battler_in_combination(battler)
    return true if battler.in_combination == 'Union'
    return true if battler.in_combination == 'Fusion'
    return true if battler.in_combination == 'Cooperation'
    return false
  end
  #--------------------------------------------------------------------------
  # * Set battlers current phase
  #     active : active battler
  #     phase  : current phase
  #--------------------------------------------------------------------------
  def battlers_current_phase(active, phase)
    for battler in active.combination_battlers
      battler.current_phase = phase
    end
    active.current_phase = phase
  end
  #--------------------------------------------------------------------------
  # * Set Action Cost (only for 'Add | Atoa CTB')
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_action_cost_combination set_action_cost if $atoa_script['Atoa CTB']
  def set_action_cost(battler)
    if battler_in_combination(battler)
      combination_set_action_cost(battler)
    else
      set_action_cost_combination(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set Combination Action Cost (only for 'Add | Atoa CTB')
  #     battler : battler
  #--------------------------------------------------------------------------
  def combination_set_action_cost(battler)
    action = $data_skills[battler.combination_id]
    if Action_Cost['Skill'] != nil and Action_Cost['Skill'][action.id] != nil and 
        action.is_a?(RPG::Skill)
      battler.current_cost = Action_Cost['Skill'][action.id]
    else
      battler.current_cost = Skill_Default_Cost
    end
  end
  #--------------------------------------------------------------------------
  # * Union skill updatebattler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def union_step2_part1(active)
    if cant_use_action(active)
      reset_atb(active) if $atoa_script['Atoa ATB']
      active.current_phase = 'Phase 5-1'
      return
    end
    now_action(active)
    active.union = Combination_Skill['Union'][[active.type_name, active.combination_id]].dup
    active.combination_battlers.clear
    active.current_move = 0
    for id in active.union
      battlers = active.actor? ? $game_party.actors : $game_troop.enemies
      for battler in battlers
        if id[0] == battler.id
          active.combination_battlers << battler 
          size = active.union[battler.id].size
          active.move_size = size if active.move_size.nil? or size > active.move_size
        end
      end
    end
    sort_combination_battlers(active)
  end
  #--------------------------------------------------------------------------
  # * Fusion skill update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def fusion_step2_part1(active)
    if cant_use_action(active)
      reset_atb(active) if $atoa_script['Atoa ATB']
      active.current_phase = 'Phase 5-1'
      return
    end
    now_action(active)
    active.fusion = Combination_Skill['Fusion'][active.combination_id].dup
    active.combination_battlers.clear
    active.current_move = 0
    battlers = active.actor? ? $game_party.actors : $game_troop.enemies
    for battler in battlers
      if battler.new_fusion == active.new_fusion
        active.combination_battlers << battler
        size = active.fusion[battler.old_fusion].size
        active.move_size = size if active.move_size.nil? or size > active.move_size
      end
    end
    sort_combination_battlers(active)
  end
  #--------------------------------------------------------------------------
  # * Cooperation skill update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def cooperation_step2_part1(active)
    unless chek_cooperation_full(active)
      reset_atb(active) if $atoa_script['Atoa ATB']
      active.in_combination = ''
      active.current_phase = 'Phase 5-1'
      return
    end
    active.combination_battlers.clear
    active.current_move = 0
    active.combination_id = active.cp_skill
    active.cooperation = Combination_Skill['Cooperation'][active.combination_id].dup
    if active.actor?
      active.combination_battlers = $game_temp.cp_actors[active.cp_skill].dup
      $game_temp.cp_actors[active.cp_skill].clear
    else
      active.combination_battlers = $game_temp.cp_enemies[active.cp_skill].dup
      $game_temp.cp_enemies[active.cp_skill].clear
    end
    active.combination_battlers.sort! {|a, b| a.id <=> b.id}
    for battler in active.combination_battlers
      index = index.nil? ? 0 : index + 1
      size = active.cooperation[index].size
      active.move_size = size if active.move_size.nil? or size > active.move_size
    end
  end
  #--------------------------------------------------------------------------
  # * Union skill update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def union_step3_part1(active)
    if member_in_action(active)
      reset_atb(active) if $atoa_script['Atoa ATB']
      return
    end
    for battler in active.combination_battlers
      set_actions(battler, active)
      now_action(battler)
      next if battler.now_action.nil?
      if cant_use_union(battler)
        reset_atb(active) if $atoa_script['Atoa ATB']
        active.current_phase = 'Phase 5-1' 
        active.action_scope = 0
        return
      end
    end
    for battler in active.combination_battlers
      action_start_anime_combination(battler, active.combination_id)
    end
    freeze_atb(active) if $atoa_script['Atoa ATB']
    battlers_current_phase(active, 'Phase 3-2')
  end
  #--------------------------------------------------------------------------
  # * Fusion skill update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def fusion_step3_part1(active)
    if member_in_action(active)
      reset_atb(active) if $atoa_script['Atoa ATB']
      return
    end
    for battler in active.combination_battlers
      set_actions(battler, active)
      now_action(battler)
      next if battler.now_action.nil?
      if cant_use_fusion(battler)
        reset_atb(active) if $atoa_script['Atoa ATB']
        active.current_phase = 'Phase 5-1' 
        active.action_scope = 0
        return
      end
    end
    for battler in active.combination_battlers
      action_start_anime_combination(battler, active.combination_id)
    end
    freeze_atb(active) if $atoa_script['Atoa ATB']
    battlers_current_phase(active, 'Phase 3-2')
  end
  #--------------------------------------------------------------------------
  # * Cooperation skill update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def cooperation_step3_part1(active)
    if member_in_action(active)
      reset_atb(active) if $atoa_script['Atoa ATB']
      return
    end
    index = 0
    for battler in active.combination_battlers
      set_actions(battler, active)
      battler.cooperation_index = index
      index += 1
      now_action(battler)
      next if battler.now_action.nil?
      if cant_use_cooperation(battler)
        break_cooperation(battler)
        reset_atb(active) if $atoa_script['Atoa ATB']
        active.current_phase = 'Phase 5-1' 
        active.action_scope = 0
        return
      end
    end
    for battler in active.combination_battlers
      action_start_anime_combination(battler, active.combination_id)
    end
    freeze_atb(active) if $atoa_script['Atoa ATB']
    battlers_current_phase(active, 'Phase 3-2')
  end
  #--------------------------------------------------------------------------
  # * Sequence skill update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def sequence_step3_part1(battler)
    if cant_use_sequence(battler)
      reset_atb(battler) if $atoa_script['Atoa ATB']
      battler.current_phase = 'Phase 5-1'
      battler.action_scope = 0
      return
    end
    action_start_anime(battler)
    battler.current_phase = 'Phase 3-2'
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step3_part2(active)
    for battler in active.combination_battlers
      now_action(battler)
      if battler.now_action != nil
        set_actions(battler, active)
        set_movement(battler)
        set_hit_number(battler)
        set_action_plane(battler)
        battler_effect_update(battler)
        battler.current_phase = 'Phase 3-3'
      end
    end
    active.current_phase = 'Phase 3-3' if active.now_action.nil?
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 3 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step3_part3(active)
    battlers_current_phase(active, 'Phase 4-1')
    for battler in active.combination_battlers
      next if battler.now_action.nil?
      battler.target_battlers = active.target_battlers
      action_anime(battler) if battler.hit_animation
    end
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 4 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step4_part1(active)
    make_results(active)
    for battler in active.combination_battlers
      next if battler.now_action.nil?
      throw_object(battler, battler.now_action)
    end
    battlers_current_phase(active, 'Phase 4-2') 
  end  
  #--------------------------------------------------------------------------
  # * Combination update battler phase 4 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step4_part2(active)
    if active.hit_animation 
      wait_base = active.animation_2 == 0 ? 0 : [$data_animations[active.animation_2].frame_max, 1].max
    else 
      wait_base = battle_speed
    end
    set_action_anim(active, wait_base)
    set_hurt_anim(active, wait_base)
    set_damage_pop(active)
    @status_window.refresh if status_need_refresh
    return unless all_throw_end(active) and anim_delay_end(active)
    wait_time = check_wait_time(wait_base, active, 'TIMEAFTERANIM/')
    active.wait_time = wait_time.to_i
    reset_animations(active)
    for battler in active.combination_battlers
      for target in battler.target_battlers
        throw_return(battler, target, battler.now_action)
      end
      battler.hit_animation = check_include(battler.now_action, "HITSANIMATION")
      battler.pose_animation = false
      battler.animation_2 = 0
    end
    battlers_current_phase(active, 'Phase 4-3') 
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 4 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step4_part3(active)
    @status_window.refresh if status_need_refresh
    return unless all_throw_end(active)
    steal_action_result(active) unless active.steal_action
    for battler in active.combination_battlers
      battler.mirage = false
      battler.critical_hit = false
      reset_random(battler)
    end
    have_no_hits = true
    for battler in active.combination_battlers
      next if battler.now_action.nil?
      have_no_hits = false if battler.current_action.hit_times > 0 and battler.current_action.move_times > 0
    end
    if have_no_hits 
      check_action_hit_times(active)
    else
      battler_movement_update(active)
    end
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 5 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step5_part2(active)
    for battler in active.combination_battlers
      update_move_return_init(battler)
      battler.current_phase = 'Phase 5-3'
    end
    update_move_return_init(active)
    active.current_phase = 'Phase 5-3'
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def combination_step5_part4(active)
    for battler in active.combination_battlers
      battler.current_phase = ''
      for battler in $game_troop.enemies + $game_party.actors
        @spriteset.battler(battler).default_battler_direction
      end
    end
    @active_battlers.delete(active)
    if $atoa_script['Atoa ATB']
      @atb_turn_count += 1 unless Custom_Turn_Count == 2
      active.passed = false
      for battler in active.combination_battlers
        battler.atb = 0 
      end
      @input_battlers.delete(active)
      @action_battlers.delete(active)
      update_meters
      judge
    elsif $atoa_script['Atoa CTB']
      @ctb_turn_count += 1
      for battler in active.combination_battlers
        battler.ctb_update(active.current_cost)
      end
      @input_battlers.delete(active)
      @action_battlers.delete(active)
      judge
    else
      for battler in active.combination_battlers
        @action_battlers.delete(battler)
      end
    end
    @last_active_enemy = active unless active.actor? and not active.dead?
    @last_active_actor = active if active.actor? and not active.dead?
    for battler in active.combination_battlers
      reset_combination(battler)
    end
    @status_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Check if battler is already active
  #     active : active battler
  #--------------------------------------------------------------------------
  def member_in_action(active)
    for battler in active.combination_battlers
      if battler != active and battler.current_phase != ''
        battler.current_phase = ''
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Set battle animation on target
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  alias set_target_animation_combination set_target_animation
  def set_target_animation(active, target)
    if battler_in_combination(active)
      for battler in active.combination_battlers
        next if battler.now_action.nil?
        battler.hit_animation = true
        battler.pose_animation = true
        set_target_animation_combination(battler, target)
      end
    else
      set_target_animation_combination(active, target)
    end
  end
  #--------------------------------------------------------------------------
  # * Throw return start animation
  #     battler : battler
  #     action  : action
  #--------------------------------------------------------------------------
  alias throw_return_combination throw_return
  def throw_return(battler, target, action)
    return if battler_in_combination(battler)and battler.now_action.nil?
    throw_return_combination(battler, target, action)
  end
  #--------------------------------------------------------------------------
  # * Action sequence combination check
  #     active : active battler
  #--------------------------------------------------------------------------
  def combination_check_action_sequence(active)
    for battler in active.combination_battlers
      battler.current_move += 1
      battler.move_size -= 1
      now_action(battler)
    end
    if active.move_size <= 0 or active.target_battlers.empty?
      active.current_action.action_sequence.clear
      active.target_battlers.clear
      active.action_scope = 0
      battlers_current_phase(active, 'Phase 5-1') 
    else
      for battler in active.combination_battlers
        battler_effect_update(battler)
        battler.current_phase = 'Phase 3-2'
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set Current Action
  #     battler : battler
  #--------------------------------------------------------------------------
  alias now_action_combination now_action
  def now_action(battler)
    if not battler.union.empty?
      if battler.union[battler.id][battler.current_move].nil?
        battler.now_action = nil
      else
        battler.now_action = $data_skills[battler.union[battler.id][battler.current_move]]
      end
      return
    elsif not battler.fusion.empty? and battler.old_fusion != 0
      if battler.fusion[battler.old_fusion][battler.current_move].nil?
        battler.now_action = nil
      else
        battler.now_action = $data_skills[battler.fusion[battler.old_fusion][battler.current_move]]
      end
      return
    elsif not battler.cooperation.empty?
      if battler.cooperation[battler.cooperation_index][battler.current_move].nil?
        battler.now_action = nil
      else
        battler.now_action = $data_skills[battler.cooperation[battler.cooperation_index][battler.current_move]]
      end
      return
    end
    now_action_combination(battler)
  end
  #--------------------------------------------------------------------------
  # * Break cooperation action
  #     battler : battler
  #--------------------------------------------------------------------------
  def break_cooperation(battler)
    if battler.actor?
      $game_temp.cp_actors[battler.cp_skill].delete(battler)
    else
      $game_temp.cp_enemies[battler.cp_skill].delete(battler)
    end
    battler.cp_skill = 0
  end
  #--------------------------------------------------------------------------
  # * Combination Action Start Animation
  #     battler : battler
  #--------------------------------------------------------------------------
  def action_start_anime_combination(battler, combination_id)
    battler.animation_1 = 0
    now_action(battler)
    skill = $data_skills[combination_id]
    if skill.magic?
      pose = set_pose_id(battler, 'Magic_Cast')
    else
      pose = set_pose_id(battler, 'Physical_Cast')
    end
    ext = check_extension(skill, 'CAST/')
    unless ext.nil?
      ext.slice!('CAST/')
      random_pose = eval("[#{ext}]")
      pose = random_pose[rand(random_pose.size)]
    end
    battler.pose_id = pose if pose != nil
    battler.animation_1 = skill.animation1_id
    @help_window.set_text(skill.name, 1) unless check_include(skill, 'HELPHIDE')
    if battler.now_action.is_a?(RPG::Skill)
      battle_cry_advanced(battler, 'SKILLCAST', now_id(battler))
    end
    set_mirage(battler, 'CAST')
    if battler.animation_1 == 0
       battler.wait_time = 0
    else
      battler.animation_id = battler.animation_1
      battler.animation_hit = true
      battler.wait_time = $data_animations[battler.animation_1].frame_max * 2
    end
    battler.mirage = false
  end
  #--------------------------------------------------------------------------
  # * Check permission for using union
  #     battler : battler
  #--------------------------------------------------------------------------
  def cant_use_union(battler)
    if battler.now_action.is_a?(RPG::Skill) and not battler.skill_can_use?(battler.combination_id)
      unless battler.current_action.forcing
        $game_temp.forcing_battler = nil
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check permission for using fusion
  #     battler : battler
  #--------------------------------------------------------------------------
  def cant_use_fusion(battler)
    if battler.now_action.is_a?(RPG::Skill) and not battler.skill_can_use?(battler.old_fusion)
      unless battler.current_action.forcing
        $game_temp.forcing_battler = nil
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check permission for using cooperation
  #     battler : battler
  #--------------------------------------------------------------------------
  def cant_use_cooperation(battler)
    unless battler.skill_can_use?(battler.cp_skill)
      unless battler.current_action.forcing
        $game_temp.forcing_battler = nil
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check permission for using sequence
  #     battler : battler
  #--------------------------------------------------------------------------
  def cant_use_sequence(battler)
    unless battler.skill_can_use?(battler.old_skill_used_id)
      unless battler.current_action.forcing
        $game_temp.forcing_battler = nil
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check union action
  #     active : active battler
  #--------------------------------------------------------------------------
  def check_union(active)
    for battler in active.combination_battlers
      return true if cant_use_union(battler) and not active.multi_action_running
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check fusion action
  #     active : active battler
  #--------------------------------------------------------------------------
  def check_fusion(active)
    for battler in active.combination_battlers
      return true if cant_use_fusion(battler) and not active.multi_action_running
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check cooperation action
  #     active : active battler
  #--------------------------------------------------------------------------
  def check_cooperation(active)
    for battler in active.combination_battlers
      return true if cant_use_cooperation(battler) and not active.multi_action_running
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Set cooperation action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_combination_action(battler)
    make_enemy_union
    set_union_action(battler)
    set_fusion_action(battler)
    set_cooperation_action(battler)
  end
  #--------------------------------------------------------------------------
  # * Set union action for enemies
  #--------------------------------------------------------------------------
  def make_enemy_union
    for battler in $game_troop.enemies
      action = battler.current_action
      if action.kind == 1 and Combination_Skill['Union'] != nil and Combination_Skill['Union'].is_a?(Hash) and
         Combination_Skill['Union'].keys.include?([battler.type_name, action.skill_id])
        combination = Combination_Skill['Union'][[battler.type_name, action.skill_id]]
        for enemy in $game_troop.enemies
          enemy.union_leader = true if enemy.id == combination.keys.first
          next if battler.union_members.include?(enemy)
          battler.union_members << enemy if combination.keys.include?(enemy.id)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set union action
  #     active : active battler
  #--------------------------------------------------------------------------
  def set_union_action(active)
    if active.is_on_union? and not active.union_leader
      @action_battlers.delete(active)
      active.current_action.clear
      active.union_members.clear
    end
    if active.now_action.is_a?(RPG::Skill)
      skill_id = now_id(active)
      combination = Combination_Skill['Union']
      if combination != nil and combination.is_a?(Hash) and
         combination.keys.include?([active.type_name, skill_id])  
        for battler in active.union_members
          if battler == active
            battler.in_combination = 'Union' 
            battler.combination_id = skill_id
          else
            @action_battlers.delete(battler)
            battler.current_action.clear
          end
          battler.union_members = []
        end
        active.union_members.clear
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set cooperation action
  #     active : active battler
  #--------------------------------------------------------------------------
  def set_cooperation_action(active)
    active.cp_skill = 0
    party = active.actor? ? $game_temp.cp_actors : $game_temp.cp_enemies
    for id in party.keys
      party[id].delete(active)
    end
    if Combination_Skill['Cooperation'] != nil
      for skill in Combination_Skill['Cooperation']
        if active.current_action.kind == 1 and active.current_action.skill_id == skill[0]
          active.cp_skill = skill[0]
          active.in_combination = 'Cooperation'
          $game_temp.cp_actors[skill[0]] << active if active.actor?
          $game_temp.cp_enemies[skill[0]] << active unless active.actor?
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Check cooperation full
  #     battler : battler
  #--------------------------------------------------------------------------
  def chek_cooperation_full(battler)
    if battler.skill_use? and Combination_Skill['Cooperation'] != nil and 
       Combination_Skill['Cooperation'].include?(battler.current_action.skill_id)
      for skill in Combination_Skill['Cooperation']
        battlers = battler.actor? ? $game_temp.cp_actors[skill[0]] : 
          $game_temp.cp_enemies[skill[0]]
        if skill[0] == battler.cp_skill and skill[1].size == battlers.size 
          return true 
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Clear combinations values
  #     battler : battler
  #--------------------------------------------------------------------------
  def reset_combination(battler)
    battler.union = []
    battler.fusion = []
    battler.union_members = []
    battler.combination_battlers = []
    battler.cooperation = {}
    battler.old_skill_used_id =  0
    battler.combination_id = 0
    battler.move_size = 0
    battler.current_move = 0
    battler.in_combination = ''
    battler.current_phase = ''
    battler.old_fusion = 0
    battler.new_fusion = 0
    battler.union_leader = false
    battler.current_action.clear
    party = battler.actor? ? $game_temp.cp_actors : $game_temp.cp_enemies
    for id in party.keys
      party[id].delete(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Clear cooperation values
  #--------------------------------------------------------------------------
  def reset_cooperaion
    if Combination_Skill['Cooperation'] != nil
      for skill in Combination_Skill['Cooperation']
        $game_temp.cp_actors[skill[0]] = []
        $game_temp.cp_enemies[skill[0]] = []
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Sort combination battlers
  #     active : active battler
  #--------------------------------------------------------------------------
  def sort_combination_battlers(active)
    active.combination_battlers.delete(active)
    active.combination_battlers.unshift(active)
    active.combination_battlers.uniq!
  end
  #--------------------------------------------------------------------------
  # * Set fusion action
  #     active : active battler
  #--------------------------------------------------------------------------
  def set_fusion_action(active)
    battlers = active.actor? ? $game_party.actors.dup : $game_troop.enemies.dup
    if Combination_Skill['Fusion'] != nil
      for skill_id in Combination_Skill['Fusion'].keys
        skill = Combination_Skill['Fusion'][skill_id].dup
        skill_fusion = []
        skill_fusion2 = [] 
        skills_fusion = []
        battler_in_fusion = []
        fusion_set = false
        for battler in battlers
          if battler.in_combination != 'Fusion' and battler.skill_use? and
             (@action_battlers.include?(battler) or battler == active) and
             skill.include?(battler.current_action.skill_id) and not 
             skill_fusion.include?(battler.current_action.skill_id)
            battler_in_fusion << battler
            skill_fusion << battler.current_action.skill_id
          end
        end
        for action in skill
          skill_fusion2 << action[0]
        end
        skill_fusion.sort!
        skill_fusion2.sort!
        for i in 0...skill_fusion.size
          fusion = skill_fusion[i...skill_fusion.size]
          skills_fusion << fusion if fusion.size > 1
        end
        for i in 0...skill_fusion.size
          fusion = skill_fusion[0...(skill_fusion.size - i)]
          skills_fusion << fusion if fusion.size > 1
        end
        for fusion in skills_fusion
          break fusion_set = true if skill_fusion2 == fusion
        end
        if fusion_set and battler_in_fusion.include?(active)
          for battler in battler_in_fusion
            if battler == active
              battler.old_fusion = battler.current_action.skill_id 
              battler.new_fusion = skill_id
              battler.in_combination = 'Fusion'
              battler.combination_id = battler.new_fusion
            elsif @action_battlers.include?(battler)
              battler.old_fusion = battler.current_action.skill_id 
              battler.new_fusion = skill_id
              @action_battlers.delete(battler)
            end
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Add skill to sequence
  #     active : active battler
  #--------------------------------------------------------------------------
  def add_skill_to_sequence(battler)    
    if battler.actor?
      @enemies_skill_sequence.clear
      if battler.current_action.kind == 1
        squence_skill = $data_skills[battler.current_action.skill_id]
        return if squence_skill.nil?
        @actors_skill_sequence << squence_skill.id
        unless No_Sequence_Skills.include?(squence_skill.id)
          @actors_element_sequence << squence_skill.element_set.first
        else
          @actors_element_sequence << nil
        end
      elsif battler.current_action.kind != 1
        @actors_skill_sequence.clear
        @actors_element_sequence.clear
      end
    else
      @actors_skill_sequence.clear
      if battler.current_action.kind == 1
        squence_skill = $data_skills[battler.current_action.skill_id]
        return if squence_skill.nil?
        @enemies_skill_sequence << squence_skill.id
        unless No_Sequence_Skills.include?(squence_skill.id)
          @enemies_element_sequence << squence_skill.element_set.first
        else
          @enemies_element_sequence << nil
        end
      elsif battler.current_action.kind != 1
        @enemies_skill_sequence.clear
        @enemies_element_sequence.clear 
      end
    end
    check_sequence_match(battler)
  end
  #--------------------------------------------------------------------------
  # * Check Sequence Match
  #     active : active battler
  #--------------------------------------------------------------------------
  def check_sequence_match(battler)
    skill_sequence_check = battler.actor? ? @actors_skill_sequence.dup : @enemies_skill_sequence.dup
    element_sequence_check = battler.actor? ? @actors_element_sequence.dup : @enemies_element_sequence.dup
    unless Combination_Skill['Sequence'].nil?
      for sequence in Combination_Skill['Sequence']
        combination_set = false
        if sequence[1][0] == 'Skill'
          for i in 0...skill_sequence_check.size
            break combination_set = true if [sequence[1][1]] == skill_sequence_check.indexes(i..skill_sequence_check.size)
          end
          if combination_set
            battler.old_skill_used_id = battler.current_action.skill_id
            battler.current_action.skill_id = sequence[0]
            battler.in_combination = 'Sequence'
            now_action(battler)
            if battler.actor?
              @actors_skill_sequence.pop
              @actors_skill_sequence << battler.current_action.skill_id
            else
              @enemies_skill_sequence.pop
              @enemies_skill_sequence << battler.current_action.skill_id
            end
            set_action_movement(battler)
            break
          end
        end
        if sequence[1][0] == 'Element'
          for i in 0...element_sequence_check.size
            break combination_set = true if [sequence[1][1]] == element_sequence_check.indexes(i..element_sequence_check.size)
          end
          if combination_set
            battler.old_skill_used_id = battler.current_action.skill_id
            battler.current_action.skill_id = sequence[0]
            battler.in_combination = 'Sequence'
            now_action(battler)
            squence_skill = $data_skills[battler.current_action.skill_id]
            if battler.actor?
              @actors_element_sequence.pop
              @actors_element_sequence << squence_skill.element_set.first
            else
              @enemies_element_sequence.pop
              @enemies_element_sequence << squence_skill.element_set.first
            end
            set_action_movement(battler)
            break
          end
        end
      end
    end
  end
end