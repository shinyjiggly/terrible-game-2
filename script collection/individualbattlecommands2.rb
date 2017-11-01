#==============================================================================
# Individual Battle Commands
# by Atoa
# Based on Charlie Lee script
# Modified by Atoa, to work with ACBS
#==============================================================================
# Following some suggestions, i've made some changes to the individual
# battle commands script
#
# Now you can not only add an command to an skill, you can also add an command
# to an actor (like in RM2000/2003/VX) and add an skill directly to an command
# so if you select the command, the skill will be used without opening the
# skill menu
# 
# 
# IMPORTANT: If you using the Add-On 'Atoa ATB' or 'Atoa CTB', put this script
# *bellow* the ATB/CTB Add-On.
#==============================================================================

module N01
  # Do not remove or change these lines
  Skill_Command = {}
  Actor_Command = {}
  Usable_Command = {}
  # Do not remove or change these lines

  # Show command list in status menu?
  Show_Commands_In_Menu = true
  
  # Position of command window in status menu
  Menu_Commands_Postition = [16,160]
  # Note: you must edit the status menu, or the command window will stay above
  # other informations
  
  # Command Window Border Opacity
  Command_Window_Border_Opacity = 255
  
  # Command Window Back Opacity
  Command_Window_Back_Opacity = 160
    
  # Max number of commands shown
  Max_Commands_Shown = 5

  # Skill Commands.
  # These commands appear automatically when an actor learn one of the skill
  # that is part of the command.
  #
  # Skill_Command[Command_Name] = [Skills_IDs]
  #
  Skill_Command['Magic'] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34,
    35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53,
    54, 55, 56]
  
  Skill_Command['Techs'] = [57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68,
    69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  
  Skill_Command['Unite'] = [98,99,100,101,102,103]
  
  Skill_Command['Overdrive'] = [119]

  Skill_Command['Summon'] = [120,121,122,123]

  # Actor Commands.
  # These are the commands linked to the actors, they will be shown even if
  # the actor has none of the skill of this command.
  # You can add the same command for different actors, the list of skills shown
  # will be separated for each
  #
  # Actor_Command[Command_Name] = {Actor_id => [Skills_IDs]}
  #
  Actor_Command['Skill'] = {1 => [85,86,89,93,118], 2 => [84,87,88,93,105,106,107],
    3 => [96,108,109,111,112,114]}
   
  Actor_Command['Wizzardry'] = {4 => [95,110,113,115,116,117]}
  
  # Usable Commands.
  # These commands are linked directly to an skill. Once you choose one of them
  # you will use without opening the skill menu.
  # This command appear automatically once the actor learn the skill linked to
  # the command. The skill linked to the command aren't shown in the skill
  # menu outside battle
  #
  # Direct_Comman[Command_Name] = Skill_ID
  #
  Usable_Command['Steal'] = 83
  
  Usable_Command['Cat Form'] = 97
  
  Usable_Command['Return Summon'] = 124
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS Individual Commands'] = true

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :individual_commands
  #--------------------------------------------------------------------------
  alias acbs_setup_ibc setup
  def setup(actor_id)
    acbs_setup_ibc(actor_id)
    @individual_commands = []
  end
  #--------------------------------------------------------------------------
  def refresh_commands
    @individual_commands = []
    for i in 0...@skills.size
      skill = $data_skills[@skills[i]]
      if skill != nil
        for command in Skill_Command.dup
          if command[1].include?(skill.id) and not @individual_commands.include?(command[0])
            @individual_commands << command[0]
          end
        end
        for command in Usable_Command.dup
          if command[1] == skill.id and not @individual_commands.include?(command[0])
            @individual_commands << command[0]
          end
        end        
      end
    end
    for command in Actor_Command.dup
      if command[1].include?(@actor_id) and not @individual_commands.include?(command[0])
        @individual_commands << command[0]
      end
    end
  end
end

#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias acbs_add_actor_ibc add_actor
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    acbs_add_actor_ibc(actor_id)
    actor = $game_actors[actor_id]
    actor.refresh_commands
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :escape_name
  #--------------------------------------------------------------------------
  alias acbs_phase3_setup_command_window_ibc phase3_setup_command_window
  def phase3_setup_command_window
    acbs_phase3_setup_command_window_ibc
    @active_battler.refresh_commands
    s1 = $data_system.words.attack
    s2 = $data_system.words.item
    s3 = $data_system.words.guard
    s4 = @escape_name if @escape_type == 0
    @individual_commands = [s1] + @active_battler.individual_commands + [s2, s3]
    if @escape_type == 0
      @individual_commands = [s1]+  @active_battler.individual_commands + [s2, s3, s4]
    end
    @actor_command_window.dispose
    @actor_command_window = Window_Command.new(160, @individual_commands, @active_battler)
    comand_size = (@individual_commands.size >= 5 ? 5 : @individual_commands.size)
    @actor_command_window.x = COMMAND_WINDOW_POSITION[0]
    @actor_command_window.y = COMMAND_WINDOW_POSITION[1] + 120 - 24 * comand_size 
    @actor_command_window.opacity = Command_Window_Border_Opacity
    @actor_command_window.back_opacity = Command_Window_Back_Opacity
    @actor_command_window.z = 4500
    @actor_command_window.index = 0
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @active_battler_window.refresh(@active_battler)
    @active_battler_window.visible = BATTLER_NAME_WINDOW
    @active_battler_window.x = COMMAND_WINDOW_POSITION[0]
    @active_battler_window.y = COMMAND_WINDOW_POSITION[1] + 56 - 24 * comand_size 
    @active_battler_window.z = 4500
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_basic_command_ibc update_phase3_basic_command
  def update_phase3_basic_command
    @direct_command = false
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      phase3_prior_actor
      return
    end
    if Input.trigger?(Input::C)
      @command_name = @actor_command_window.commands[@actor_command_window.index]
      case @command_name
      when $data_system.words.attack
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        start_enemy_select
      when $data_system.words.guard 
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 1
        phase3_next_actor
      when $data_system.words.item
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 2
        start_item_select
      when @escape_name
        if $game_temp.battle_can_escape == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        update_phase2_escape
        return
      end
      if @active_battler != nil and 
        @active_battler.individual_commands.include?(@command_name)
        if Usable_Command.include?(@command_name)
          unless @active_battler.skill_can_use?(Usable_Command[@command_name])
            $game_system.se_play($data_system.buzzer_se)
            return
          end
          @active_battler.current_action.kind = 1
          @commands_category = @command_name
          @direct_command = true
          start_command_select(Usable_Command[@command_name])
        else
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.kind = 1
          @commands_category = @command_name
          start_skill_select
        end
      end
      return
    end
    acbs_update_phase3_basic_command_ibc
  end
  #--------------------------------------------------------------------------
  alias acbs_start_skill_select_ibc start_skill_select
  def start_skill_select
    acbs_start_skill_select_ibc
    @skill_window.dispose
    @skill_window = Window_Skill.new(@active_battler, @commands_category)
    @skill_window.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  def start_command_select(skill_id)
    if Input.trigger?(Input::C)
      @skill = $data_skills[skill_id]
      if @skill.nil? or not @active_battler.skill_can_use?(@skill.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.skill_id = @skill.id
      if @skill.extension.include?("TARGETALL")
        start_select_all_battlers
        return
      elsif @skill.scope == 2 or (@skill.scope < 3 and @skill.extension.include?("RANDOMTARGET"))
        start_select_all_enemies
        return
      elsif @skill.scope == 4 or (@skill.scope > 2 and @skill.extension.include?("RANDOMTARGET"))
        start_select_all_actors
        return
      end
      if @skill.scope == 1
        start_enemy_select
      elsif @skill.scope == 3 or @skill.scope == 5
        start_actor_select
      else
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  def active_command_window
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @help_window.visible = false
    @active_battler_window.visible = true if BATTLER_NAME_WINDOW
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_enemy_select_ibc update_phase3_enemy_select
  def update_phase3_enemy_select
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_enemy_select
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.target_index = @enemy_arrow.index
      end_enemy_select
      phase3_next_actor
      @help_window.visible = false
      return
    end
    acbs_update_phase3_enemy_select_ibc
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_actor_select_ibc update_phase3_actor_select
  def update_phase3_actor_select
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_actor_select
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.target_index = @actor_arrow.index
      end_actor_select
      phase3_next_actor
      @help_window.visible = false
      return
    end
    acbs_update_phase3_actor_select_ibc
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_select_all_enemies_ibc update_phase3_select_all_enemies
  def update_phase3_select_all_enemies
    @enemy_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_all_enemies
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_all_enemies
      phase3_next_actor
      @help_window.visible = false
      return
    end
    acbs_update_phase3_select_all_enemies_ibc
  end
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_select_all_actors_ibc update_phase3_select_all_actors
  def update_phase3_select_all_actors
    @actor_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_all_actors
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_all_actors
      phase3_next_actor
      @help_window.visible = false
      return
    end
    acbs_update_phase3_select_all_actors_ibc
  end      
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_select_all_battlers_ibc update_phase3_select_all_battlers
  def update_phase3_select_all_battlers
    @battler_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_all_battlers
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_all_battlers
      phase3_next_actor
      @help_window.visible = false
      return
    end
    acbs_update_phase3_select_all_battlers_ibc
  end      
end

#==============================================================================
# ■ Window_Skill
#==============================================================================
class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize(actor, skill_command_type = '')
    super(0, 128, 640, 352)
    @skill_command_type = skill_command_type
    @actor = actor
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 320
      self.height = 160
      self.z = 900
      self.back_opacity = MENU_OPACITY
    end
  end
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    for i in 0...@actor.skills.size
      skill = $data_skills[@actor.skills[i]]
      if skill != nil and $game_temp.in_battle and skill_in_command?(skill)
        @data << skill
      elsif skill != nil and not $game_temp.in_battle
        for command in  Usable_Command.dup
          @data << skill unless command[1] == skill.id or @data.include?(skill)
        end
      end
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  def skill_in_command?(skill)
    if Skill_Command[@skill_command_type] != nil and 
       Skill_Command[@skill_command_type].include?(skill.id)
      return true 
    elsif Actor_Command[@skill_command_type] != nil and
       Actor_Command[@skill_command_type].include?(@actor.id) and
       Actor_Command[@skill_command_type][@actor.id].include?(skill.id)
      return true 
    end
    return false
  end
end

#==============================================================================
# ■ Window_Command
#==============================================================================
class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :commands
  #--------------------------------------------------------------------------
  def initialize(width, commands, battler = nil)
    if $scene.is_a?(Scene_Battle)
      comand_size = (commands.size >= 5 ? 192 : commands.size * 32 + 32)
      max_comand = Max_Commands_Shown * 32 + 32
    else
      comand_size =  commands.size * 32 + 32
      max_comand = comand_size
    end
    comand_size = [comand_size, max_comand].min
    super(0, 0, width, comand_size)
    @battler = battler
    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, @item_max * 32)
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      if $scene.is_a?(Scene_Battle) and @battler != nil and 
         Usable_Command.include?(@commands[i]) and not
         @battler.skill_can_use?(Usable_Command[@commands[i]])
        draw_item(i, disabled_color)
      elsif $scene.is_a?(Scene_Battle) and @commands[i] == $scene.escape_name and 
         $game_temp.battle_can_escape == false
        draw_item(i, disabled_color)
      else
        draw_item(i, normal_color)
      end
    end
  end
end

#==============================================================================
# ■ Scene_Status
#==============================================================================
class Scene_Status
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias acbs_main_scenestatus_ibc main
  def main
    set_command_window if Show_Commands_In_Menu
    acbs_main_scenestatus_ibc
    @command_window.dispose if Show_Commands_In_Menu
  end
  #--------------------------------------------------------------------------
  def set_command_window
    actor = $game_party.actors[@actor_index]
    actor.refresh_commands
    s1 = $data_system.words.attack
    s2 = $data_system.words.item
    s3 = $data_system.words.guard
    @individual_commands = [s1] + actor.individual_commands + [s2, s3]
    @command_window = Window_Command.new(160, @individual_commands, actor)
    @command_window.x = Menu_Commands_Postition[0]
    @command_window.y = Menu_Commands_Postition[1]
    @command_window.z = 1000
    @command_window.active = false
    @command_window.index = -1
  end
end