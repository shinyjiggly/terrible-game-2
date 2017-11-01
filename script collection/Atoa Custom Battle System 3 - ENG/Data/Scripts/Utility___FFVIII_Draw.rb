#==============================================================================
# Final Fantasy VIII Draw System
# by The Sleeping Leonhart
# This version was modified by Atoa to work with the ACBS
#------------------------------------------------------------------------------
# This script emulates the magic system from Final Fantasy VIII
# There, the magics don't consume magic points (MP, SP...),
# instead, each magic has an ammount, and each use reduce this ammount by 1.
# You can get more magics by using the "Draw" command to "steal" magics from
# enemies
# 
# IMPORTANT:
#   This script don't remove the SP cost of the skills
#   If you want to remove the cost, leave the cost 0 and use the
#   "Hide_Zero_SP" from the basic settings.
#   It's also recomended to use the setting "NODAMAGE" for the Draw skill
#   if you want is to deal no damage, so neither miss o 0 will pop
#
#------------------------------------------------------------------------------
# It's possible to add magic with Script Calls
#    $game_party.actors[Index].learn_skill(ID, Value)
#       Index = Actor Index
#       ID = Skill ID
#       Value = amount get
#==============================================================================

module FFVIII_MagicSystem
  # Do not remove or change this line
  Enemy_Draw_Skill = {}
  # Do not remove or change this line
  
  # ID of the Draw skill
  #  Absorb_Skill_Id = ID
  Absorb_Skill_Id = 163
  
  #  Set enemy magic list
  #    Enemy_Draw_Skill[Enemy_ID] = {Skill_ID => Skill_Number,...}
  #    Enemy_ID: enemy ID
  #    Skill_ID: Skill ID
  #    Skill_Number: Number of magic held by the enemy
  Enemy_Draw_Skill[1] = {1 => 10, 7 => 20, 10 => 25}
  
  # Set the skills that won't use the draw system (using the
  # default learning and cost system)
  #    Normal_Skill = [Skill_ID,...]
  #    Skill_ID: Skill ID
  Normal_Skill = [57, 61, 81]
  
  # Max number of skill that can be keep
  #    Max_Skill_Number = Value
  Max_Skill_Number = 100
  
  # Max number of skill that can be get at once
  #    Max_Absorb = Value
  Max_Absorb = 10
  
  # Color of magic numbers
  #   Number_Color = Color.new(Red, Green, Blue)
  Number_Color = Color.new(0, 255, 0)
  
  # Text shown when absorbing skills
  #   You can add {value} to show the ammount get, and {skill} to show
  #   skill name, leave nil for no text
  Draw_Skill_Text = "Absorveu {value} unidades da habilidade {skill}"
  
  # Text show when enemy has no skill
  No_Skill_Text = "No Skill"
  
end

$tsl_script = [] if $tsl_script == nil
$tsl_script.push("FFVIII MagicSystem")

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include FFVIII_MagicSystem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor  :skills_number
  attr_accessor  :skills_todraw
  attr_accessor  :draw_target
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias tslffviiims_gameactor_setup setup
  def setup(actor_id)
    @draw_skills_number = {}
    @draw_skills_number.default = 0
    tslffviiims_gameactor_setup(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Learn Skill
  #     skill_id : skill ID
  #     n        : number of skills get
  #--------------------------------------------------------------------------
  alias tslffviiims_gameactor_learn_skill learn_skill
  def learn_skill(skill_id, n = 1)
    if Normal_Skill.include?(skill_id)
      tslffviiims_gameactor_learn_skill(skill_id)
    else
      if skill_id > 0
        add_passive_effect(skill_id) if $tsl_script.include?("Passive Skill")
        @draw_skills.push(skill_id) if not skill_learn?(skill_id)
        @draw_skills.sort!
        @draw_skills_number[skill_id] += n
        @draw_skills_number[skill_id] = Max_Skill_Number if @draw_skills_number[skill_id] > Max_Skill_Number
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Forget Skill
  #     skill_id : skill ID
  #     n        : number of skills lost
  #--------------------------------------------------------------------------
  alias tslffviiims_gameactor_forget_skill forget_skill
  def forget_skill(skill_id, n = 1)
    if Normal_Skill.include?(skill_id)
      tslffviiims_gameactor_forget_skill(skill_id)
    else
      if @draw_skills_number.keys.include?(skill_id)
        if @draw_skills_number[skill_id] >= n
          @draw_skills_number[skill_id] -= n
        end
        if @draw_skills_number[skill_id] <= 0
          remove_passive_effect(skill_id) if $tsl_script.include?("Passive Skill")
          @draw_skills.delete(skill_id)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Consume skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  alias tslffviiims_gameactor_consume_skill_cost consume_skill_cost
  def consume_skill_cost(skill)
    tslffviiims_gameactor_consume_skill_cost(skill)
    unless Normal_Skill.include?(skill.id) or skill.id == Absorb_Skill_Id
      forget_skill(skill.id)
    end
  end 
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias tslffviiims_gameactor_skill_can_use skill_can_use?
  def skill_can_use?(skill_id)
    return false if @draw_skills_number.keys.include?(skill_id) and @draw_skills_number[skill_id] <= 0
    tslffviiims_gameactor_skill_can_use(skill_id)
  end
end

#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  This class deals with troops. Refer to "$game_troop" for the instance of
#  this class.
#==============================================================================

class Game_Troop
  #--------------------------------------------------------------------------
  # * Setup
  #     troop_id : troop ID
  #--------------------------------------------------------------------------
  alias tslffviiims_gametroop_setup setup
  def setup(troop_id)
    tslffviiims_gametroop_setup(troop_id)
    for enemy in @enemies
      if enemy != nil
        enemy.set_skill_number
      end
    end
  end
end

#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
#  This window displays usable skills on the skill and battle screens.
#==============================================================================

class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include FFVIII_MagicSystem
  #--------------------------------------------------------------------------
  # * Draw Skill Cost
  #     skill : skill
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  alias tslffviiims_windowskill_draw_skill_cost draw_skill_cost
  def draw_skill_cost(skill, x, y)
    tslffviiims_windowskill_draw_skill_cost(skill, x, y)
    if not Normal_Skill.include?(skill.id)
      self.contents.font.color = Number_Color
      self.contents.draw_text(x + 24, y, 204, 32, @actor.skills_number[skill.id].to_s,2)
    end
  end
end

#==============================================================================
# ** Window_AbsorbCommand
#------------------------------------------------------------------------------
#  This window displays the magics that can be absorbed
#==============================================================================

class Window_AbsorbCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include FFVIII_MagicSystem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     enemy_id : enemy ID
  #--------------------------------------------------------------------------
  def initialize(enemy)
    @commands = enemy.draw_skills != [] ? enemy.draw_skills : [No_Skill_Text]
    super(0, 0, 240, [@commands.size * 32 + 32,160 + 32].min)
    @enemy = enemy
    @item_max = @commands.size
    self.contents = Bitmap.new(width - 32, [@item_max * 32, 160].min)
    refresh
    self.index = 0
    self.back_opacity = Base_Opacity
    self.z = 2000
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i, normal_color)      
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #     color : text color
  #--------------------------------------------------------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    if command_name(index) == No_Skill_Text
      self.contents.draw_text(rect, @commands[index])
    else
      self.contents.draw_text(rect, $data_skills[@commands[index]].name)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Skill ID
  #--------------------------------------------------------------------------
  def skill_id
    return $data_skills[@commands[self.index]].id if command_name(self.index) != No_Skill_Text
  end
  #--------------------------------------------------------------------------
  # * Get command name
  #     index : índice
  #--------------------------------------------------------------------------
  def command_name(index)
    return @commands[index]
  end
  #--------------------------------------------------------------------------
  # * Disable Item
  #     index : item number
  #--------------------------------------------------------------------------
  def disable_item(index)
    draw_item(index, disabled_color)
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include FFVIII_MagicSystem
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase)
  #--------------------------------------------------------------------------
  alias tslffviiims_scenebattle_update_phase3 update_phase3
  def update_phase3
    if @absorb_window != nil
      update_absorb_window
      return
    end
    tslffviiims_scenebattle_update_phase3
  end
  #--------------------------------------------------------------------------
  # * End Skill Selection
  #--------------------------------------------------------------------------
  alias tslffviiims_scenebattle_end_skill_select end_skill_select
  def end_skill_select
    if @skill_window.skill.id == Absorb_Skill_Id and not
       @skill_window.visible and @absorb_window == nil
      target = $game_troop.enemies[@active_battler.current_action.target_index]
      set_absorb_window(target)
      return
    end
    tslffviiims_scenebattle_end_skill_select
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  alias tslffviiims_scenebattle_phase3_next_actor phase3_next_actor
  def phase3_next_actor
    return if @absorb_window != nil
    tslffviiims_scenebattle_phase3_next_actor
  end
  #--------------------------------------------------------------------------
  # * Start Skill Selection
  #--------------------------------------------------------------------------
  alias tslffviiims_scenebattle_start_skill_select start_skill_select
  def start_skill_select
    @active_battler.skills_todraw = nil
    @active_battler.draw_target = nil
    tslffviiims_scenebattle_start_skill_select
  end
  #--------------------------------------------------------------------------
  # * Update Absorb Window
  #--------------------------------------------------------------------------
  def update_absorb_window
    @absorb_window.update
    if Input.trigger?(Input::B)
      @absorb_window.dispose
      @absorb_window = nil
      @active_battler.skills_todraw = nil
      @active_battler.draw_target = nil
      skill = $data_skills[@active_battler.current_action.skill_id]
      confirm_action_select(skill)
      return
    end
    if Input.trigger?(Input::C) and @absorb_window.command_name(@absorb_window.index) != No_Skill_Text
      @active_battler.skills_todraw = @absorb_window.skill_id
      @active_battler.draw_target = @absorb_window.enemy
      end_skill_select if @skill_window != nil
      @help_window.visible = false
      @absorb_window.dispose
      @absorb_window = nil
      phase3_next_actor
    elsif Input.trigger?(Input::C) and @absorb_window.command_name(@absorb_window.index) == No_Skill_Text
      $game_system.se_play($data_system.cancel_se)
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Make Skill Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  alias tslffviiims_scenebattle_make_skill_action_result make_skill_action_result
  def make_skill_action_result(battler)
    tslffviiims_scenebattle_make_skill_action_result(battler)
    if battler.current_action.skill_id == Absorb_Skill_Id
      unless battler.draw_target.dead? and battler.draw_target != nil
        skill = battler.skills_todraw
        n = battler.draw_target.steal_skill(skill)
        battler.learn_skill(skill, n)
        if Draw_Skill_Text != nil
          text = Draw_Skill_Text.dup
          text.gsub!(/{value}/i) {"#{n.to_s}"}
          text.gsub!(/{skill}/i) {"#{$data_skills[skill].name.to_s}"}          
          @help_window.set_text(text, 1)
        end
      end
      battler.skills_todraw = nil
      battler.draw_target = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Show absorb window
  #     enemy : enemy
  #--------------------------------------------------------------------------
  def set_absorb_window(enemy)
    @absorb_window = Window_AbsorbCommand.new(enemy)
    @absorb_window.active = true
    @absorb_window.x = 0
    @absorb_window.y = 64
    @active_battler.skills_todraw = nil
    @active_battler.draw_target = nil
  end
  #--------------------------------------------------------------------------
  # * End direct command selection (only if using "Add | Individual Battle Commands")
  #--------------------------------------------------------------------------
  alias tslffviiims_scenebattle_end_direct_command_selection end_direct_command_selection if $atoa_script['Atoa Individual Commands']
  def end_direct_command_selection
    if @active_battler.current_action.skill_id == Absorb_Skill_Id and @absorb_window == nil
      target = $game_troop.enemies[@active_battler.current_action.target_index]
      set_absorb_window(target)
      return
    end
    tslffviiims_scenebattle_end_direct_command_selection
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include FFVIII_MagicSystem
  #--------------------------------------------------------------------------
  # * Set skill number
  #--------------------------------------------------------------------------
  def set_skill_number
    @draw_skills = []
    @draw_skills_number = {}
    @draw_skills_number.default = 0
    if Enemy_Draw_Skill.has_key?(@enemy_id)
      for i in Enemy_Draw_Skill[@enemy_id].keys
        @draw_skills.push(i) if not @draw_skills.include?(i)
        @draw_skills.sort!
        @draw_skills_number[i] = Enemy_Draw_Skill[@enemy_id][i]
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get enemy draw skills
  #--------------------------------------------------------------------------
  def draw_skills
    return @draw_skills
  end
  #--------------------------------------------------------------------------
  # * Steal Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def steal_skill(skill_id)
    n = 0
    tries = 0
    loop do
      n = rand(Max_Absorb) + 1
      x += 1
      break if @draw_skills_number[skill_id] - n >= 0 or tries > 10
    end
    @draw_skills_number[skill_id] -= n
    @draw_skills.delete(skill_id) if @draw_skills_number[skill_id] <= 0
    return n
  end
end