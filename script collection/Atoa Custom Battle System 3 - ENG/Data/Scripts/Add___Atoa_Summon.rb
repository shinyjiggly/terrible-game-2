#==============================================================================
# Summon
# by Atoa
#==============================================================================
# This script add Summoning skill to the actors
#
# With them the actors can summon allies to help in battler
#
# To add new allies to be summoned, just configure the summon skills and
# add their ID.
# An charcter is added to the summon list *automatically* once someone
# learn the skill or have an item that summons him.
#
# For all effects, the summons are normal character that you configure in the
# database. Your status, equipments and skill must be configurated there.
# You can use events comand normally to control them.
#
# You will find all explanation of how to configure the skil in the 'module Atoa'
#
# Specia Scrip Call for summons
#
# Change summon EXP:
# $game_party.summons_exp(X)
#  X = exp gained (can be postive or neagative)
#
# Change summons HP:
# $game_party.summons_change_hp(X)
#  X = HP changed (can be postive or neagative)
#
# Change summons SP:
# $game_party.summons_change_sp(X)
#  X = SP changed (can be postive or neagative)
#
# Cure All:
# $game_party.summons_heal_all
#
# Change Summons Level:
# $game_party.summons_level(X)
#  X = Level changed (can be postive or neagative)
#==============================================================================

module Atoa
  # Do not remove or change these lines
  Summon_Skill = {}
  Summon_Item = {}
  Summon_Status = {}
  # Do not remove or change these lines

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SUMMON BASIC SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
 
  # Return Summon Skill ID
  Rertun_Skill_ID = 87
  
  # % of Exp gained by removed actors
  Removed_Actors_exp_rate = 75
  
  # % of Exp gained by summons that stayed till the end of battle
  Summoned_exp_rate = 80
  
  # % of Exp gained by summons that dont't stayed till the end of battle
  Not_Summoned_exp_rate = 40
  
  # Don't allows summun exchange
  Dont_Allow_Summon_Twice = false
  # true = you can't use an summon skill when another summon is activated
  # false = you can use an summon skill when another summon is activated
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SUMMON STATUS MENU SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

  # Show Summon Face?
  Summon_Show_Face = false

  # Show Map on Back ground?
  Summon_Status_Show_Map = false
    
  # Summon Status Window Opacity
  Summon_Status_Opacity = 255
  Summon_Status_Back_Opacity = 255

  # Background image
  # If you want to use your own backgruon image, add the filename here.
  # the graphic must be on the Windowskin folder.
  # if the value = nil, no image will be used.
  # Remember to reduce the window transparency.
  Summon_Status_Back_Image = nil
  
  # Battler direction on the summon status
  Summon_Staus_Direction = 6
  # 2 = actor faces down
  # 4 = actor faces left 
  # 6 = actor faces right
  # 8 = actor faces up
  
  # Position X of the elements resistance
  Summon_Status_Element_Position = 224

  # Max number of elements shown in a column, max value = 8
  Summon_Max_Elements_Shown = 8
  
  # Exhibition of elemental resistance
  Summon_Element_Resists_Exhibition = 0
  # 0 = custom exhibition
  # 1 = exhibition by numbers, value shows target resistance
  # 2 = exhibition by numbers, value damage multiplication
  
  # Elemental resist text if 'Element_Resists_Exhibition = 0'
  Summon_Element_Resist_Text = ['Weakest','Weak','Normal','Resist','Imune','Absorb']
  
  # Configuration of the elemental resist text color
  #                                red blue green
  Summon_Weakest_Color = Color.new(255,   0,   0)
  Summon_Weak_Color    = Color.new(255, 128,  64)
  Summon_Neutral_Color = Color.new(255, 255, 255)
  Summon_Resist_Color  = Color.new(  0, 128, 255)
  Summon_Imune_Color   = Color.new(  0, 255, 255)
  Summon_Absorb_Color  = Color.new(  0, 255,   0)
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SUMMON SKILL SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can configure the summon skills
  
  # Summon_Skill[Skill_ID] = [[Type, Turns, BGM, Item, Fade All], [Actors_ID,...]]
  #   Skill_ID = ID da habilidade
  #   Type = set how actors will be removed
  #     0 = remove all actors, except the summoner
  #     1 = remove all actors
  #     2 = remove only the summoner
  #     3 = No actor is removed
  #   Turns = Duration in turns of the summon.
  #     - If is = nil, the summon won't have time limit
  #     - If is a numeric, the duration is this value in turns. 
  #     - Can also be an script command, use 'battler' to add values 
  #       according to summoner status
  #       Ex.: '(battler.level / 5) + 1'
  #            '(battler.int * 2) / 100'
  #   BGM = BGM change when summon skill is used
  #     Must be the name of the BMG file.
  #     if = nil, the music won't be changed
  #   Item = Set if summons can use items
  #     true = can use items
  #     false = can't use items
  #   Fade All = Fade effect for all battlers during the summon animation
  #     If true, all battlers disappear, if fails, only the removed ones.
  #   Actors_ID = IDs of the actors that will be summoned.
  #
  Summon_Skill[83] = [[0, nil, nil, false, false], [6]]
  Summon_Skill[84] = [[2, nil, nil, false, false], [7]]
  Summon_Skill[85] = [[3, 5, nil, false, false], [8]]
  Summon_Skill[86] = [[1, '(battler.level / 5) + 1', '005-Boss01', true, false], [6,7,8]]
    
  # Summon items
  # The summon items reproduces the effect of an summon skill
  #  Summon_Item[Item_ID] = Skill_ID
  #    Item_ID = ID of the item
  #    Skill_ID = ID of the summon skill used, must be one of the summon skills
  #      configurated above.
  #
  Summon_Item[30] = 86
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SUMMON STATUS INCREASE SETTINGG
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Since summons aren't accessible in menu, you can't change freely their equipment,
  # the only way to do this is through events.
  # To avoid that the equip status stay static, i created this option, that way
  # the equipment status of the summons will too increase with level.
  # 
  # The value set is multiplied by the current level.
  #
  # Remember that an character is considered an summon only when someone in party
  # have the skill to summon him.
  #
  # E.g.:  Summon_Status[5] = [1.8, 1.5, 1.2, 0.1, 0.2, 0.1, 0.5, 0.05, 0.15]
  #   The actor ID 5 in level 30 will have the following bonus:
  #   +54 Attack
  #   +45 P. Def
  #   +36 M. Def
  #   +3% Evasion
  #   +6% Hit Rate
  #   +3% Critical Rate
  #   +15% Critical Damage
  #   +1% Critical Rate Resistance
  #   +4% Critical Damage Resistance
  #
  
  # Default summon status.
  # These bonus are applied to summons who don't have their status set individually.
  #
  # Summon_Status_Default = [A, B, C, D, E, F, G, H, I]
  #   A = Attack
  #   B = P. Def
  #   C = M. Def
  #   D = Evasion
  #   E = Hit Rate
  #   F = Critical Rate
  #   G = Critical Damage
  #   H = Critical Rate Resistance
  #   I = Critical Damage Resistance
  Summon_Status_Default = [1.5, 1.0, 1.0, 0.1, 0.1, 0.1, 0.5, 0, 0]
  
  # Idividual summon statusValores individuais dos bonus dos Summons
  #
  # Summon_Status[ID] = [A, B, C, D, E, F, G, H, I]
  #   ID = Actor ID
  #   A = Attack
  #   B = P. Def
  #   C = M. Def
  #   D = Evasion
  #   E = Hit Rate
  #   F = Critical Rate
  #   G = Critical Damage
  #   H = Critical Rate Resistance
  #   I = Critical Damage Resistance
  Summon_Status[6] = [1.8, 1.4, 0.8, 0.15, 0.2, 0.1, 0.5, 0, 0]
  Summon_Status[7] = [1.6, 1.1, 1.2, 0.2, 0.1, 0.1, 0.5, 0, 0]
  Summon_Status[8] = [1.4, 0.8, 1.5, 0.1, 0.1, 0.1, 0.5, 0, 0]
  
  #==============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Summon'] = true

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
  attr_accessor :summon_active
  attr_accessor :bgm_memorize
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :summons
  attr_accessor :summoned
  attr_accessor :summoned_party
  attr_accessor :removed_actors
  attr_accessor :summons_exp
  attr_accessor :summons_level
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_summon initialize
  def initialize
    initialize_summon
    @removed_actors = []
    @summoned = []
    @summoned_party = []
    set_summons
  end
  #--------------------------------------------------------------------------
  # * Get summons
  #--------------------------------------------------------------------------
  def set_summons
    @summons = []
    for actor in @actors
      for skill_id in actor.skills
        set_summon_actors(skill_id) if Summon_Skill.include?(skill_id)
      end
      for removed in $game_actors[actor.id].removed_actors
        for skill_id in removed[0].skills
          set_summon_actors(skill_id) if Summon_Skill.include?(skill_id)
        end
      end
    end
    for i in 1...$data_items.size
      if item_number(i) > 0 and Summon_Item.include?(i)
        set_summon_actors(Summon_Item[i])
      end
    end
    return @summons
  end
  #--------------------------------------------------------------------------
  # * Set summon actors
  #     id : skill ID
  #--------------------------------------------------------------------------
  def set_summon_actors(id)
    if Summon_Skill.include?(id)
      for summon_id in Summon_Skill[id][1]
        @summons << $game_actors[summon_id] unless @summons.include?($game_actors[summon_id])
        $game_actors[summon_id].learn_skill(Rertun_Skill_ID)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias add_actor_summon add_actor
  def add_actor(actor_id)
    add_actor_summon(actor_id)
    set_summons
  end
  #--------------------------------------------------------------------------
  # * Add an Actor by index
  #     actor_id : actor ID
  #     index    : index
  #--------------------------------------------------------------------------
  alias add_actor_by_index_summon add_actor_by_index
  def add_actor_by_index(actor_id, index)
    add_actor_by_index_summon(actor_id, index)
    set_summons    
  end
  #--------------------------------------------------------------------------
  # * Add a Summon
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_summon(actor_id)
    set_summons
    actor = $game_actors[actor_id]
    unless @actors.include?(actor)
      @actors << actor
      actor.invisible = true
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Add a Summon by index
  #     actor_id : actor ID
  #     index    : index
  #--------------------------------------------------------------------------
  def add_summon_by_index(index, actor_id)
    set_summons
    actor = $game_actors[actor_id]
    unless @actors.include?(actor)
      @actors.insert(index, actor)
      actor.invisible = true
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Add an Actor after Summon by index
  #     actor_id : actor ID
  #     index    : index
  #--------------------------------------------------------------------------
  def add_summon_actor_by_index(actor_id, index)
    actor = $game_actors[actor_id]
    unless @actors.include?(actor)
      @actors.insert(index, actor)
      @actors.compact!
      actor.invisible = true
      $game_player.refresh
    end
  end 
  #--------------------------------------------------------------------------
  # * Change Summon EXP
  #     exp : EXP value
  #--------------------------------------------------------------------------
  def summons_exp(exp)
    set_summons
    for summon in @summons
      $game_actors[summon.id].exp += exp
    end
  end
  #--------------------------------------------------------------------------
  # * Change Summon HP
  #     hp : HP value
  #--------------------------------------------------------------------------
  def summons_change_hp(hp)
    set_summons
    for summon in @summons
      $game_actors[summon.id].hp += hp unless summon.dead?
    end
  end
  #--------------------------------------------------------------------------
  # * Change Summon SP
  #     hp : SP value
  #--------------------------------------------------------------------------
  def summons_change_sp(sp)
    set_summons
    for summon in @summons
      $game_actors[summon.id].sp += sp unless summon.dead?
    end
  end
  #--------------------------------------------------------------------------
  # * Change Summon Level
  #     level : level value
  #--------------------------------------------------------------------------
  def summons_level(level)
    set_summons
    for summon in @summons
      $game_actors[summon.id].level += level
    end
  end
  #--------------------------------------------------------------------------
  # * Heal all summons
  #--------------------------------------------------------------------------
  def summons_heal_all
    set_summons
    for summon in @summons
      $game_actors[summon.id].recover_all
    end
  end
  #--------------------------------------------------------------------------
  # * Check if Summonable
  #     id : skill ID
  #--------------------------------------------------------------------------
  def summonable?(id)
    for summon_id in Summon_Skill[id][1]
      summon = $game_actors[summon_id]
      return false if summon.dead?
    end
    for summon_id in Summon_Skill[id][1]
      return false if $game_party.summoned.include?($game_actors[summon_id])
    end
    return true
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
  attr_accessor :summoning
  attr_accessor :returning
  attr_accessor :summon_item
  attr_accessor :summoned_id
  attr_accessor :summon_config
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_summon initialize
  def initialize
    initialize_summon
    @summoning = 0
    @returning = 0
    @summon_item = 0
    @summoned_id = 0
    @summon_config = []
  end
  #--------------------------------------------------------------------------
  # * Check if object is a summon
  #--------------------------------------------------------------------------
  def summon?
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if battler is active
  #--------------------------------------------------------------------------
  alias active_summon active?
  def active?
    old_phases = active_summon
    new_phases = ['Summon 1', 'Summon 2', 'Summon 3', 'Summon 4', 'Summon 5', 
                  'Summon 6', 'Return 1', 'Return 2']
    return ((new_phases.include?(@current_phase) and not self.dead?) or old_phases)
  end
  #--------------------------------------------------------------------------
  # * Check if battler is on action phase
  #--------------------------------------------------------------------------
  alias action_summon action?
  def action?
    old_phases = action_summon
    new_phases = ['Summon 1', 'Summon 2', 'Summon 3', 'Summon 4', 'Summon 5', 
                  'Summon 6', 'Return 1', 'Return 2']
    return ((new_phases.include?(@current_phase) and not self.dead?) or old_phases)
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
  attr_accessor :removed_actors
  attr_accessor :summoned_actors
  attr_accessor :summon_turn
  attr_accessor :summoned_turn
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_summon_gameactor setup
  def setup(actor_id)
    setup_summon_gameactor(actor_id)
    @removed_actors = []
    @summoned_actors = []
    @summon_turn = 0
    @summoned_turn = 0
  end 
  #--------------------------------------------------------------------------
  # * Check if object is a summon
  #--------------------------------------------------------------------------
  def summon?
    $game_party.set_summons
    return $game_party.summons.include?(self)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  alias base_atk_summon base_atk
  def base_atk
    n = base_atk_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][0] : Summon_Status_Default[0]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  alias base_pdef_summon base_pdef
  def base_pdef
    n = base_pdef_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][1] : Summon_Status_Default[1]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  alias base_mdef_summon base_mdef
  def base_mdef
    n = base_mdef_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][2] : Summon_Status_Default[2]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  alias base_eva_summon base_eva
  def base_eva
    n = base_eva_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][3] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  alias hit_summon hit
  def hit
    n = hit_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][4] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  alias crt_summon crt
  def crt
    n = crt_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][5] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  alias dmg_summon dmg
  def dmg
    n = dmg_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][6] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  alias rcrt_summon rcrt
  def rcrt
    n = rcrt_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][5] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  alias rdmg_summon rdmg
  def rdmg
    n = rdmg_summon
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][6] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias skill_can_use_summon skill_can_use?
  def skill_can_use?(skill_id)
    if Summon_Skill.include?(skill_id)
      return false if $game_temp.summon_active and Dont_Allow_Summon_Twice
      return false unless $game_temp.in_battle
      return false unless $game_party.summonable?(skill_id)
    end
    skill_can_use_summon(skill_id)
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias main_summon main
  def main
    $game_party.summoned = []
    $game_party.summoned_party = []
    @old_party = []
    $game_temp.bgm_memorize = $game_system.playing_bgm 
    main_summon
  end
  #--------------------------------------------------------------------------
  # * Determine Battle Win/Loss Results
  #--------------------------------------------------------------------------
  alias judge_summon judge
  def judge
    summons_dead? if $game_temp.summon_active
    return judge_summon
  end
  #--------------------------------------------------------------------------
  # * Check if all summons are dead
  #--------------------------------------------------------------------------
  def summons_dead?
    for summons in $game_party.summoned_party
      all_dead = true
      for summon in summons
        all_dead = false unless $game_actors[summon].dead?
      end
      return_summon($game_actors[summons[0]]) if all_dead
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose 3:abort)
  #--------------------------------------------------------------------------
  alias battle_end_summon battle_end
  def battle_end(result)
    battle_end_summon(result)
    end_battle_return_party if $game_temp.summon_active
  end
  #--------------------------------------------------------------------------
  # * EXP Gain
  #--------------------------------------------------------------------------
  def gain_exp
    return_party if $game_temp.summon_active
    exp = exp_gained
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false and not $game_party.removed_actors.include?(actor)
        last_level = actor.level
        actor.exp += exp
        @status_window.level_up(i) if actor.level > last_level
      elsif actor.cant_get_exp? == false and $game_party.removed_actors.include?(actor)
        last_level = actor.level
        actor.exp += ((exp * Removed_Actors_exp_rate) / 100).to_i
        @status_window.level_up(i) if actor.level > last_level
      end
    end
    for summon in $game_party.summons
      if summon.cant_get_exp? == false and $game_party.summoned.include?(summon)
        last_level = summon.level
        summon.exp += ((exp * Summoned_exp_rate) / 100).to_i
        @status_window.level_up(i) if actor.level > last_level
      elsif summon.cant_get_exp? == false and not $game_party.summoned.include?(summon)
        last_level = summon.level
        summon.exp += ((exp * Not_Summoned_exp_rate) / 100).to_i
        @status_window.level_up(i) if actor.level > last_level
      end
    end
    $game_party.removed_actors.clear
    $game_party.summoned.clear
    return exp
  end
  #--------------------------------------------------------------------------
  # * Update Turn Ending
  #--------------------------------------------------------------------------
  alias update_turn_ending_summon update_turn_ending
  def update_turn_ending
    for battler in $game_party.actors
      return_summon(battler) if battler.summon? and battler.summon_turn != nil and
        ($game_temp.battle_turn - battler.summoned_turn) >= battler.summon_turn
    end
    update_turn_ending_summon
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_summon update
  def update
    $game_temp.summon_active = !$game_party.summoned.empty?
    update_summon 
  end
  #--------------------------------------------------------------------------
  # * Battler phases update
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias update_battler_phases_summon update_battler_phases
  def update_battler_phases(battler)
    update_battler_phases_summon(battler)
    phase = battler.current_phase
    summon_part1(battler) if phase == 'Summon 1' and not battler_waiting(battler)
    summon_part2(battler) if phase == 'Summon 2' and not battler_waiting(battler)
    summon_part3(battler) if phase == 'Summon 3' and not battler_waiting(battler)
    summon_part4(battler) if phase == 'Summon 4' and not battler_waiting(battler)
    summon_part5(battler) if phase == 'Summon 5' and not battler_waiting(battler)
    summon_part6(battler) if phase == 'Summon 6' and not battler_waiting(battler)
    return_part1(battler) if phase == 'Return 1' and not battler_waiting(battler)
    return_part2(battler) if phase == 'Return 2' and not battler_waiting(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part1_summon step3_part1
  def step3_part1(battler)
    summon(battler)
    if battler.returning != 0
      battler.current_phase = 'Return 1'
    else
      step3_part1_summon(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part2_summon step3_part2
  def step3_part2(battler)
    if battler.summoning != 0
      battler.current_phase = 'Summon 1'
    else
      step3_part2_summon(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler summon phase part 1
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon_part1(battler)
    skill = $data_skills[battler.summoning]
    @help_window.set_text(skill.name, 1) unless check_include(skill, 'HELPHIDE')
    battler.current_phase = 'Summon 2'
  end
  #--------------------------------------------------------------------------
  # * Update battler summon phase part 2
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon_part2(battler)
    $game_party.refresh
    action_anime(battler)
    unless $game_party.summonable?(battler.summoning)
      if battler.summon_item != 0
        $game_party.lose_item(battler.summon_item, 1) if $data_items[battler.summon_item].consumable
      else
        battler.consume_skill_cost($data_skills[battler.summoning])
      end
      battler.current_phase = 'Phase 6-1'
    else
      battler.current_phase = 'Summon 3'
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler summon phase part 3
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon_part3(battler)
    set_summon_actors(battler)
    for actor in $game_party.actors
      next if not Summon_Skill[battler.summoning][0][4] and not $game_party.removed_actors.include?(actor)
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.invisible = true
        actor.defense_pose = false
        actor.invisible_action = true if battler == actor
      end
    end
    battler.wait_time = 16
    battler.current_phase = 'Summon 4'
  end
  #--------------------------------------------------------------------------
  # * Update battler summon phase part 4
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon_part4(battler)
    for summon_id in Summon_Skill[battler.summoning][1]
      case battler.summon_config[0]
      when 0
        for actor in $game_party.actors
          next if actor == battler
          add_removed_actors(actor, summon_id)
        end
        set_summoned_actors(battler, summon_id)
        set_summon_commands(summon_id, battler.summon_config[3])
        $game_party.add_summon(summon_id)
      when 1
        for actor in $game_party.actors
          next if actor.summon?
          add_removed_actors(actor, summon_id)
        end
        set_summoned_actors(battler, summon_id)
        set_summon_commands(summon_id, battler.summon_config[3])
        $game_party.add_summon(summon_id)
      when 2
        $game_actors[summon_id].removed_actors << [battler, battler.index]
        set_summoned_actors(battler, summon_id)
        set_summon_commands(summon_id, battler.summon_config[3])
        $game_party.add_summon_by_index($game_party.actors.index(battler), summon_id)
      when 3
        set_summoned_actors(battler, summon_id)
        set_summon_commands(summon_id, battler.summon_config[3])
        $game_party.add_summon(summon_id)
      end
      reset_action($game_actors[summon_id])
      $game_actors[summon_id].summoned_id = battler.summoning
    end
    for actor in $game_party.removed_actors
      $game_party.summoned.delete(actor) if actor.summon?
      $game_party.remove_actor(actor.id)
    end
    $game_party.refresh
    for actor in $game_party.actors
      if Summon_Skill[battler.summoning][0][4] or Summon_Skill[battler.summoning][1].include?(actor.id)
        actor.battler_position_setup
      else
        actor.retunt_to_original_position
      end
      actor.pose_id = 0
    end
    if $atoa_script['Atoa ATB']
      reset_bars
    elsif $atoa_script['Atoa CTB']
      update_all_ctb
      @ctb_window.refresh 
    end
    battler.current_phase = 'Summon 5'
  end
  #--------------------------------------------------------------------------
  # * Set summoned actors
  #--------------------------------------------------------------------------
  def set_summoned_actors(battler, summon_id)
    for actor_id in Summon_Skill[battler.summoning][1]
      $game_actors[summon_id].summoned_actors << $game_actors[actor_id]
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler summon phase part 5
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon_part5(battler)
    unless battler.summon_config[2].nil?
      $game_system.bgm_play($game_temp.bgm_memorize) if $game_temp.bgm_memorize != nil
      $game_system.bgm_play(RPG::AudioFile.new(battler.summon_config[2], 100, 100)) 
      $game_temp.bgm_memorize = $game_system.playing_bgm
    end      
    if battler.summon_item != 0
      $game_party.lose_item(battler.summon_item, 1) if $data_items[battler.summon_item].consumable
    else
      battler.consume_skill_cost($data_skills[battler.summoning])
    end
    @status_window.refresh
    battler.current_phase = 'Summon 6'
    battler.wait_time = 4
  end
  #--------------------------------------------------------------------------
  # * Update battler summon phase part 6
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon_part6(battler)
    for actor in $game_party.actors
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.invisible = false
        next if @old_party.include?(actor)
      end
    end
    for summon_id in Summon_Skill[battler.summoning][1]
      actor = $game_actors[summon_id]
      actor.summon_turn = eval(battler.summon_config[1].to_s)
      actor.summoned_turn = $game_temp.battle_turn
    end
    for actor in $game_party.removed_actors
      $game_party.removed_actors.delete(actor) if actor.summon?
    end
    end_summoning(battler)
    battler.current_phase = 'Phase 5-1'
    battler.wait_time = 16
  end
  #--------------------------------------------------------------------------
  # * Set actors to be summoned
  #     battler : active battler
  #--------------------------------------------------------------------------
  def set_summon_actors(battler)
    battler.summon_config = Summon_Skill[battler.summoning][0].dup
    set_summoned_battlers(battler)
    $game_party.summoned_party << Summon_Skill[battler.summoning][1]
    $game_party.summoned_party.uniq!
    for actor in $game_party.actors
      battler.removed_actors.delete(actor)
      next if actor.summon? or @old_party.include?(actor)
      @old_party << actor
    end
    case battler.summon_config[0]
    when 0
      for actor in $game_party.actors
        next if actor.id == battler.id or $game_party.removed_actors.include?(actor)
        $game_party.removed_actors << actor
      end
    when 1
      for actor in $game_party.actors
        next if $game_party.removed_actors.include?(actor)
        $game_party.removed_actors << actor
      end
    when 2
      $game_party.removed_actors << battler
    end
  end
  #--------------------------------------------------------------------------
  # * Set Summoned battlers
  #     battler : active battler
  #--------------------------------------------------------------------------
  def set_summoned_battlers(battler)
    for summon_id in Summon_Skill[battler.summoning][1].dup
      next if $game_party.summoned.include?($game_actors[summon_id])
      $game_party.summoned << $game_actors[summon_id]
    end
  end
  #--------------------------------------------------------------------------
  # * Add removed actors
  #     battler   : active battler
  #     summon_id : summon skill ID
  #--------------------------------------------------------------------------
  def add_removed_actors(actor, summon_id)
    if actor.summon? 
      for actors in actor.removed_actors
        next if $game_actors[summon_id].removed_actors.include?(actors)
        $game_actors[summon_id].removed_actors << actors
      end
    else
      $game_actors[summon_id].removed_actors << [actor, actor.index]
    end
  end
  #--------------------------------------------------------------------------
  # * Set summon comnabds
  #     battler   : active battler
  #     summon_id : summon skill ID
  #--------------------------------------------------------------------------
  def set_summon_commands(summon_id, config)
    $game_actors[summon_id].disabled_commands.clear
    return if config
    $game_actors[summon_id].disabled_commands << $data_system.words.item
    $game_actors[summon_id].disabled_commands.uniq!
  end
  #--------------------------------------------------------------------------
  # * End summoning
  #     battler   : active battler
  #--------------------------------------------------------------------------
  def end_summoning(battler)
    battler.summon_item = 0
    battler.summoning = 0
    battler.returning = 0
  end
  #--------------------------------------------------------------------------
  # * Return summons
  #     battler : Battler ativo
  #--------------------------------------------------------------------------
  def return_summon(battler)
    return_part1(battler)
    wait(16)
    return_part2(battler)
    wait(16)
    battler.current_phase = ''
  end
  #--------------------------------------------------------------------------
  # * Update battler summon return phase part 1
  #     battler : active battler
  #--------------------------------------------------------------------------
  def return_part1(battler)
    hide_all = (Summon_Skill[battler.summoned_id] != nil and Summon_Skill[battler.summoned_id][0][4])
    for actor in $game_party.actors 
      next if not hide_all and not battler.summoned_actors.include?(actor)
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.invisible = true
        actor.invisible_action = true if battler == actor
      end
    end
    battler.wait_time = 16
    battler.current_phase = 'Return 2'
  end
  #--------------------------------------------------------------------------
  # * Update battler summon return phase part 2
  #     battler : active battler
  #--------------------------------------------------------------------------
  def return_part2(battler)
    $game_system.bgm_play($game_temp.bgm_memorize)
    hide_all = (Summon_Skill[battler.summoned_id] != nil and Summon_Skill[battler.summoned_id][0][4])
    for actor in battler.summoned_actors
      actor.summon_turn = 0
      actor.summoned_turn = 0
      actor.summoned_id = 0
      $game_party.summoned.delete(actor)
      $game_party.remove_actor(actor.id)
    end
    for actor in battler.removed_actors
      $game_party.add_summon_actor_by_index(actor[0].id, actor[1])
    end
    @spriteset.update
    if $atoa_script['Atoa ATB']
      reset_bars
    elsif $atoa_script['Atoa CTB']
      update_all_ctb
      @ctb_window.refresh 
    end
    $game_temp.summon_active = !$game_party.summoned.empty?
    battler.summoned_actors.clear
    battler.removed_actors.clear
    for actor in $game_party.actors
      $game_party.removed_actors.delete(actor)
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.invisible = false
      end
    end
    for actor in $game_party.actors
      actor.pose_id = 0
    end
    reset_actors_position(hide_all)
    @status_window.refresh
    end_summoning(battler)
    @action_battlers.delete(battler)
    @active_battlers.delete(battler)
    update_summoned_party
    battler.wait_time = 8
  end
  #--------------------------------------------------------------------------
  # * Reset actors positions
  #--------------------------------------------------------------------------
  def reset_actors_position(hide_all)
    for actor in $game_party.actors
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.pose_id = set_pose_id(actor, actor.dead? ? 'Dead' : 'Idle')
      end
      if hide_all
        actor.battler_position_setup
      else
        actor.retunt_to_original_position
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update summoned party
  #--------------------------------------------------------------------------
  def update_summoned_party
    for party_id in $game_party.summoned_party
      include_all = true
      for id in party_id
        include_all = false unless $game_party.actors.include?($game_actors[id])
      end
      $game_party.summoned_party.delete(party_id) unless include_all
    end
  end
  #--------------------------------------------------------------------------
  # * Return sumons in the end of battle
  #--------------------------------------------------------------------------
  def end_battle_return_party
    $game_party.actors.clear
    $game_party.summoned.clear
    for actor in @old_party
      $game_party.add_actor(actor.id)
    end
    for actor in $game_party.actors
      actor.invisible = false
    end
  end
  #--------------------------------------------------------------------------
  # * Clear actions
  #     battler : active battler
  #--------------------------------------------------------------------------
  def reset_action(battler)
    if $atoa_script['Atoa ATB']
      battler.atb = 0
    elsif $atoa_script['Atoa CTB']
      battler.ctb_preset
    end
  end
  #--------------------------------------------------------------------------
  # * Start summoning
  #     battler : active battler
  #--------------------------------------------------------------------------
  def summon(battler)
    return false if battler.nil? or not battler.actor? or cant_use_action(battler)
    now_action(battler)
    if battler.now_action.is_a?(RPG::Item) and Summon_Item.include?(now_id(battler)) 
      battler.summon_item = now_id(battler)
      battler.summoning = Summon_Item[now_id(battler)]
    elsif battler.now_action.is_a?(RPG::Skill) and Summon_Skill.include?(now_id(battler)) 
      battler.summon_item = 0
      battler.summoning = now_id(battler)
    elsif battler.now_action.is_a?(RPG::Skill) and now_id(battler) == Rertun_Skill_ID
      battler.returning = now_id(battler)
    else
      battler.summoning = 0
      battler.returning = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Return party
  #--------------------------------------------------------------------------
  def return_party
    for battler in $game_party.actors 
      hide_all |= (Summon_Skill[battler.summoned_id] != nil and Summon_Skill[battler.summoned_id][0][4])
    end
    for actor in $game_party.actors 
      next if @old_party.include?(actor) and not hide_all
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.invisible = true
      end
    end
    for actor in @old_party
      actor.invisible = true
    end
    wait(8)
    $game_system.bgm_play($game_system.bgm_memorize)
    update_summoned_party
    for actor in $game_party.actors 
      next unless actor.summon?
      $game_party.summoned.delete(actor)
      $game_party.remove_actor(actor.id)
      actor.summon_turn = 0
      actor.summoned_turn = 0
      actor.summoned_id = 0
    end
    $game_temp.summon_active = false
    $game_party.actors.clear
    for actor in @old_party
      $game_party.add_actor(actor.id)
    end
    reset_actors_position(hide_all)
    wait(8)
    for actor in $game_party.actors
      unless actor.dead? and not check_include(actor, 'NOCOLLAPSE')
        actor.invisible = false
      end
    end
    @spriteset.update
    @status_window.refresh
  end
end

#==============================================================================
# ** Sprite_Battler_Summon
#------------------------------------------------------------------------------
#  This sprite is used to display the battler of summons on the Summon window
#==============================================================================

class Sprite_Battler_Summon < Sprite_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #     battler  : battler (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport, battler)
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    battler_position_setup
    super
  end
  #--------------------------------------------------------------------------
  # * Set initial position
  #--------------------------------------------------------------------------
  def battler_position_setup
    @battler.base_x = @battler.original_x = @battler.actual_x = @battler.target_x = 100
    @battler.initial_x = @battler.hit_x = @battler.damage_x = 100
    @battler.base_y = @battler.original_y = @battler.actual_y = @battler.target_y = 200
    @battler.initial_y = @battler.hit_y = @battler.damage_y = 200
  end
  #--------------------------------------------------------------------------
  # * Get idle pose ID
  #--------------------------------------------------------------------------
  def set_idle_pose
    default_battler_direction
    if @battler.dead? and check_include(@battler, 'NOCOLLAPSE')
      return set_pose_id('Dead') 
    end
    for i in @battler.states
      return States_Pose[i] unless States_Pose[i].nil? 
    end
    if @battler.in_danger? and not check_include(@battler, 'NODANGER')
      return set_pose_id('Danger') 
    end
    return set_pose_id('Idle')
  end
  #--------------------------------------------------------------------------
  # * Set default battler direction
  #--------------------------------------------------------------------------
  def default_battler_direction
    @battler.direction = Summon_Staus_Direction
  end
end

#==============================================================================
# ** Window_Summon_Status
#------------------------------------------------------------------------------
#  This window displays status of summons
#==============================================================================

class Window_Summon_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(208, 64, 432, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh(actor)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #     actor : actor
  #--------------------------------------------------------------------------
  def refresh(actor)
    self.contents.clear
    f_x =  Summon_Show_Face ? 124 : 0
    draw_actor_battle_face(actor, 0, 112) if Summon_Show_Face
    draw_actor_name(actor, 4 + f_x, 0)
    draw_actor_level(actor, 4 + f_x, 32)
    draw_actor_state(actor, 136 + f_x, 0)
    draw_actor_hp(actor, 88 + f_x, 32, 172)
    draw_actor_sp(actor, 88 + f_x, 64, 172)
    self.contents.font.size = 16
    self.contents.font.bold = true
    x, y = 24 , 204
    y_adjust = Damage_Algorithm_Type == 2 ? -56 : 4
    draw_actor_parameter(actor, x, y + (20 * 0), 0) unless Damage_Algorithm_Type == 2
    draw_actor_parameter(actor, x, y + (20 * 1), 1) unless Damage_Algorithm_Type == 2
    draw_actor_parameter(actor, x, y + (20 * 2), 2) unless Damage_Algorithm_Type == 2
    draw_actor_parameter(actor, x, y + (20 * 3), 7) unless Damage_Algorithm_Type == 2
    draw_actor_parameter(actor, x, y + y_adjust + (20 * 4), 3)
    draw_actor_parameter(actor, x, y + y_adjust + (20 * 5), 4)
    draw_actor_parameter(actor, x, y + y_adjust + (20 * 6), 5)
    draw_actor_parameter(actor, x, y + y_adjust + (20 * 7), 6)
    self.contents.font.color = system_color
    self.contents.draw_text(212, 96, 80, 32, 'EXP')
    self.contents.draw_text(212, 118, 80, 32, 'Próximo')
    self.contents.font.color = normal_color
    self.contents.draw_text(288, 96, 84, 32, actor.exp_s, 2)
    self.contents.draw_text(288, 118, 84, 32, actor.next_rest_exp_s, 2)
    draw_element_resist(actor, Summon_Status_Element_Position)
    self.contents.font.size = Font.default_size
    self.contents.font.bold = false
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # * Draw Parameter
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : parameter type
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type)
    case type
    when 0
      parameter_name = $data_system.words.atk
      parameter_value = actor.atk
    when 1
      parameter_name = $data_system.words.pdef
      parameter_value = actor.pdef
    when 2
      parameter_name = $data_system.words.mdef
      parameter_value = actor.mdef
    when 3
      parameter_name = $data_system.words.str
      parameter_value = actor.str
    when 4
      parameter_name = Damage_Algorithm_Type > 1 ? Status_Vitality : $data_system.words.dex
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = Status_Evasion
      parameter_value = actor.eva
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 96, y, 36, 32, parameter_value.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw elemental resist
  #     actor : actor
  #     x     : draw spot x-coordinate
  #--------------------------------------------------------------------------
  def draw_element_resist(actor, x)
    max_elment = [Summon_Max_Elements_Shown, 8].min
    y = (496 - (max_elment * 25)) / 2
    if $atoa_script['Atoa New Resistances']
      elements = actor.elemental_resist
    else
      elements = $data_classes[actor.class_id].element_ranks
    end
    base = value = 0
    case Summon_Element_Resists_Exhibition
    when 0
      table = [0] + Summon_Element_Resist_Text
    when 1
      table = [0] + ['-100%','-50%','0%','50%','100%','200%']
    else
      table = [0] + ['200%','150%','100%','50%','0%','-100%']
    end
    for i in 0...$data_system.elements.size
      begin
        bitmap = RPG::Cache.icon($data_system.elements[i] + '_elm')
        self.contents.blt(x + (base * 112), y + (value * 25), bitmap, Rect.new(0, 0, 24, 24))
        result = table[elements[i]]
        case elements[i]
        when 1
          self.contents.font.color = Summon_Weakest_Color
        when 2
          self.contents.font.color = Summon_Weak_Color
        when 3
          self.contents.font.color = Summon_Neutral_Color
        when 4
          self.contents.font.color = Summon_Resist_Color
        when 5
          self.contents.font.color = Summon_Imune_Color
        when 6
          self.contents.font.color = Summon_Absorb_Color
        end
        case Summon_Element_Resists_Exhibition
        when 0
          self.contents.draw_text(x + 28 + (base * 112), y - 4 + (value * 25), 180, 32, result.to_s, 0)
        else
          self.contents.draw_text(x + (base * 112), y - 4 + (value * 25), 72, 32, result.to_s, 2)
        end
        value += 1
        base += 1 if value == max_elment
        value = value % max_elment
      rescue
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Face Graphic
  #     actor   : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     opacity : face opacity
  #--------------------------------------------------------------------------
  def draw_actor_battle_face(actor, x, y, opacity = 255)
    begin
      face = RPG::Cache.faces(actor.character_name, actor.character_hue)
      fw = face.width
      fh = face.height
      src_rect = Rect.new(0, 0, fw, fh)
      self.contents.blt(x - fw / 23, y - fh, face, src_rect, opacity)
    rescue
    end
  end
end

#==============================================================================
# ** Window_Command_Summon_Status
#------------------------------------------------------------------------------
#  This window shows the commands for summon status
#==============================================================================

class Window_Command_Summon_Status < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :commands
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     commands : commands
  #--------------------------------------------------------------------------
  def initialize(commands)
    super(0, 64, 208, 416)
    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, [@item_max * 32, 32].max)
    refresh
    self.index = 0
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
    self.contents.draw_text(rect, @commands[index].name)
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
# ** Scene_Summon_Status
#------------------------------------------------------------------------------
#  This class performs summon status screen processing.
#==============================================================================

class Scene_Summon_Status
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @spriteset = Spriteset_Map.new if Summon_Status_Show_Map
    unless Summon_Status_Back_Image.nil?
      @back_image = Sprite.new
      @back_image.bitmap = RPG::Cache.windowskin(Back_Image)
    end
    commands = []
    $game_party.set_summons
    for summon in $game_party.summons
      commands << summon
    end
    @main_window = Window_Command_Summon_Status.new(commands)
    @main_window.active = true
    @summon = @main_window.commands[@main_window.index]
    @info_window = Window_Summon_Status.new(@summon)
    @info_window.visible = true
    @help_window = Window_Help.new
    @help_window.set_text(@summon.name)
    @viewport = Viewport.new(208, 80, 400, 368)
    @viewport.z = 100
    update_info
    update
    Graphics.transition
    loop do
      update
      Graphics.update
      Input.update
      $game_system.update
      $game_screen.update
      break if $scene != self
    end
    Graphics.freeze
    @main_window.dispose
    @info_window.dispose
    @help_window.dispose
    @summon_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Return Scene
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if Input.repeat?(Input::UP) or Input.repeat?(Input::DOWN)
      @help_window.set_text(@summon.name)
      @main_window.update
      @info_window.update
      @help_window.update
      update_info
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      return_scene
      return
    end
    @summon_sprite.update if @summon_sprite != nil
  end
  #--------------------------------------------------------------------------
  # * Update info
  #--------------------------------------------------------------------------
  def update_info
    @summon = @main_window.commands[@main_window.index]
    @info_window.refresh(@summon)
    @summon_sprite.dispose if @summon_sprite != nil
    @summon_sprite = Sprite_Battler_Summon.new(@viewport, @summon)
  end
end