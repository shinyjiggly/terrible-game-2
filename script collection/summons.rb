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
#
#==============================================================================
#
# IMPORTANT:
#  If you set any summon skill to add more battlers than the default limit,
#  don't forget to set correctly the positions of the party, on the script
#  "* SBS Config" in the line
#  ACTOR_POSITION = [[460,180],[480,210],[500,240],[520,270]]
#  If you don't change this it WILL cause errors (try using the skill "Summon Dohki"
#  withou changing the values and you will see what i'm talking about)
#
#  If the faces don't fit in the window when you use many summons, *you* must
#  fix it in the script "Battle Windows"
#==============================================================================

module N01
  # Do not remove or change these lines
  Summon_Skill = {}
  Summon_Item = {}
  Summon_Status = {}
  # Do not remove or change these lines

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SUMMON BASIC SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
 
  # Return Summon Skill ID
  Rertun_Skill_ID = 124
  
  # % of Exp gained by removed actors
  Removed_Actors_exp_rate = 70
  
  # % of Exp gained by summons that stayed till the end of battle
  Summoned_exp_rate = 80
  
  # % of Exp gained by summons that dont't stayed till the end of battle
  Not_Summoned_exp_rate = 40
  
  # Don't allows summun exchange
  Dont_allow_exchange = false
  # true = you can't use an summon skill when another summon is activated
  # false = you can use an summon skill when another summon is activated, making 
  #       the current summons to leave and summoning news summons
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SUMMON STATUS MENU SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

  # Show Summon Face?
  Summon_Show_Face = false
  # true = Mostrar
  # false = não mostrar

  # Show Map on Back ground?
  Summon_Status_Show_Map = false
  # true = Mostrar
  # false = não mostrar
  
  # Add actors summoned by items to de summon list?
  Add_Summon_Item = false
  # true = add
  # false = don't add
  
  # Summon Status Window Opacity
  Summon_Status_Opacity = 255
  Summon_Status_Back_Opacity = 255

  # Background image
  # If you want to use your own backgruon image, add the filename here.
  # the graphic must be on the Windowskin folder.
  # if the value = nil, no image will be used.
  # Remember to reduce the window transparency.
  Summon_Status_Back_Image = nil
  
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
  
  # Summon_Skill[Skill_ID] = [[Type, Turns, BGM, Item], [Actors_IDs]]
  #   Skill_ID = ID da habilidade
  #   Type = set how actors will be removed
  #     0 = remove all actors, except the summoner
  #     1 = remove all actors (this type doesn't work with ATB)
  #     2 = remove only the summoner
  #     3 = No actor is removed
  #   Turns = Duration in turns of the summon.
  #     If is a numeric, the duration is this value in turns. 
  #     If is = nil, the summon won't have time limit
  #     If is = 'level', the duration is based on the summoner level.
  #   BGM = BGM change when summon skill is used
  #     Must be the name of the BMG file.
  #     if = nil, the music won't be changed
  #   Item = Set if summons can use items
  #     true = can use items
  #     false = can't use items
  #   Actors_ID = IDs of the actors that will be summoned.
  #
  Summon_Skill[120] = [[0, nil, nil, false], [5]]
  Summon_Skill[121] = [[2, 1, nil, false], [6]]
  Summon_Skill[122] = [[3, 5, nil, false], [7]]
  Summon_Skill[123] = [[1, 'level', '005-Boss01', true], [5,6,7]]
  
  # Summon items
  # The summon items reproduces the effect of an summon skill
  #  Summon_Item[Item_ID] = Skill_ID
  #    Item_ID = ID of the item
  #    Skill_ID = ID of the summon skill used, must be one of the summon skills
  #      configurated above.
  #
  Summon_Item[30] = 123
  
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
  # Summon_Status_Default = [A, B, C, D, E, F, G, H. I]
  #   A = Attack
  #   B = P. Def
  #   C = M. Def
  #   D = Evasion
  #   E = Hit Rate
  #   F = Critical Rate
  #   G = Critical Damage
  #   H = Critical Rate Resistance
  #   I = Critical Damage Resistance
  Summon_Status_Default = [1.5, 1.5, 1.5, 0.1, 0.1, 0.1, 0.5, 0, 0]
  
  # Valores individuais dos bonus dos Summons
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
  Summon_Status[5] = [1.8, 1.5, 1.2, 0.1, 0.2, 0.1, 0.5, 0, 0]
  Summon_Status[6] = [1.6, 1.4, 1.5, 0.2, 0.1, 0.1, 0.5, 0, 0]
  Summon_Status[7] = [1.4, 1.3, 1.8, 0.1, 0.1, 0.1, 0.5, 0, 0]
  
  #==============================================================================
  # Edit Here the animation for summon skills
  SUMMON_ANIM = {"SUMMON_ANIM" => ["BEFORE_MOVE","WAIT(FIXED)","START_MAGIC_ANIM",
                          "WPN_SWING_UNDER","WPN_RAISED","WPN_SWING_V",
                          "OBJ_ANIM_WEIGHT","Can Collapse","24","COORD_RESET"]}
  ACTION.merge!(SUMMON_ANIM)
  #Don't change this
  SUMMON_START = {"SUMMON_START" => ["BEFORE_MOVE"]}
  ACTION.merge!(SUMMON_START)
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS Summon'] = true

#==============================================================================
# ■ RPG::Skill
#==============================================================================
class RPG::Skill
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias summon_base_action base_action
  def base_action
    return "SUMMON_START" if Summon_Skill.include?(@id)
    summon_base_action 
  end
end

#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  attr_accessor :summon_active
  attr_accessor :summoning
end

#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :summons
  attr_accessor :summoned
  attr_accessor :removed_actors
  attr_accessor :summons_exp
  attr_accessor :summons_level
  #--------------------------------------------------------------------------
  alias initialize_summon_n01 initialize
  def initialize
    initialize_summon_n01
    @removed_actors = @summoned = []
    summons
  end
  #--------------------------------------------------------------------------
  def summons
    @summons = []
    for actor in @actors
      for skill_id in actor.skills
        if Summon_Skill.include?(skill_id)
          for summon_id in Summon_Skill[skill_id][1]
            @summons << $game_actors[summon_id] unless @summons.include?($game_actors[summon_id])
            $game_actors[summon_id].learn_skill(Rertun_Skill_ID)
          end
        end
      end
    end
    for i in 1...$data_items.size
      if item_number(i) > 0 and Summon_Item.include?(i)
        if Summon_Skill.include?(Summon_Item[i])
          for summon_id in Summon_Skill[Summon_Item[i]][1]
            @summons << $game_actors[summon_id] unless @summons.include?($game_actors[summon_id])
            $game_actors[summon_id].learn_skill(Rertun_Skill_ID)
          end
        end
      end
    end
    return @summons
  end
  #--------------------------------------------------------------------------
  alias add_actor_summon_n01 add_actor
  def add_actor(actor_id)
    add_actor_summon_n01(actor_id)
    summons
  end
  #--------------------------------------------------------------------------
  def add_summon(actor_id)
    summons
    actor = $game_actors[actor_id]
    unless @actors.include?(actor)
      @actors << actor
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  def summons_exp(exp)
    summons
    for summon in @summons
      summon.exp += exp
    end
  end
  #--------------------------------------------------------------------------
  def summons_change_hp(hp)
    summons
    for summon in @summons
      summon.hp += hp unless summon.dead?
    end
  end
  #--------------------------------------------------------------------------
  def summons_change_sp(sp)
    summons
    for summon in @summons
      summon.sp += sp unless summon.dead?
    end
  end
  #--------------------------------------------------------------------------
  def summons_heal_all
    summons
    for summon in @summons
      summon.recover_all
    end
  end
  #--------------------------------------------------------------------------
  def summons_level(level)
    summons
    for summon in @summons
      summon.level += level
    end
  end
  #--------------------------------------------------------------------------
  def summons_dead?
    return false if @summoned.size == 0
    for summon_id in @summoned
      summon = $game_actors[summon_id]
      return false if summon.hp > 0
    end
    return true
  end
  #--------------------------------------------------------------------------
  def summonable?(id)
    summons = Summon_Skill[id][1]
    for summon_id in summons
      summon = $game_actors[summon_id]
      return true if summon.hp > 0
    end
    return false
  end
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias base_atk_summon_n01 base_atk
  def base_atk
    n = base_atk_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][0] : Summon_Status_Default[0]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias base_pdef_summon_n01 base_pdef
  def base_pdef
    n = base_pdef_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][1] : Summon_Status_Default[1]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias base_mdef_summon_n01 base_mdef
  def base_mdef
    n = base_mdef_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][2] : Summon_Status_Default[2]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias base_eva_summon_n01 base_eva
  def base_eva
    n = base_eva_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][3] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias hit_summon_n01 hit if $atoa_script['SBS Actor Status']
  def hit
    n = $atoa_script['SBS Actor Status'] ? hit_summon_n01 : super
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][4] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias crt_summon_n01 crt if $atoa_script['SBS Actor Status']
  def crt
    n = crt_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][5] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias dmg_summon_n01 dmg if $atoa_script['SBS Actor Status']
  def dmg
    n = dmg_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][6] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias rcrt_summon_n01 rcrt if $atoa_script['SBS Actor Status']
  def rcrt
    n = rcrt_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][5] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias rdmg_summon_n01 rdmg if $atoa_script['SBS Actor Status']
  def rdmg
    n = rdmg_summon_n01
    if $game_party.summons.include?(self)
      stat_plus = Summon_Status.include?(self.id) ? Summon_Status[self.id][6] : Summon_Status_Default[3]
      n += (stat_plus * @level).to_i
    end
    return n
  end
  #--------------------------------------------------------------------------
  alias skill_can_use_summon_n01 skill_can_use?
  def skill_can_use?(skill_id)
    if Summon_Skill.include?(skill_id)
      return false if $game_temp.summon_active and Dont_allow_exchange
      return false unless $game_temp.in_battle
      return false unless $game_party.summonable?(skill_id)
    end
    skill_can_use_summon_n01(skill_id)
  end
end

#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  alias update_summon_n01 update
  def update
    update_summon_n01
    self.opacity = 0 if @battler.actor? if $game_temp.summoning
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :summoned
  #--------------------------------------------------------------------------
  alias main_summon_n01 main
  def main
    $game_party.summoned = []
    @old_party = []
    @exchange_party = false
    $game_temp.summon_active = $game_temp.summoning = false
    @summon_item = {}
    main_summon_n01
  end
  #--------------------------------------------------------------------------
  alias judge_summon_n01 judge
  def judge
    if $game_temp.summon_active
      return_party if $game_party.all_dead?
      return_party if $game_party.summoned != [] && $game_party.summons_dead?
    end
    return judge_summon_n01
  end
  #--------------------------------------------------------------------------
  alias battle_end_summon_n01 battle_end
  def battle_end(result)
    battle_end_summon_n01(result)
    end_battle_return_party if $game_temp.summon_active
    $game_temp.summon_active = false
  end
  #--------------------------------------------------------------------------
  alias gain_exp_summon_n01 gain_exp
  def gain_exp
    return_party(true) if $game_temp.summon_active
    exp = gain_exp_summon_n01
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
      if summon.cant_get_exp? == false and $game_party.summoned.include?(summon.id)
        last_level = summon.level
        summon.exp += ((exp * Summoned_exp_rate) / 100).to_i
        @status_window.level_up(i) if actor.level > last_level
      elsif summon.cant_get_exp? == false and not $game_party.summoned.include?(summon.id)
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
  alias update_phase3_basic_command_summon_n01 update_phase3_basic_command
  def update_phase3_basic_command
    if Input.trigger?(Input::C)
      case @actor_command_window.commands[@actor_command_window.index]
      when $data_system.words.item 
        if @summon_item.include?(@active_battler.id) && @summon_item[@active_battler.id] == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
      end
    end
    update_phase3_basic_command_summon_n01
  end
  #--------------------------------------------------------------------------
  alias turn_ending_summon_n01 turn_ending
  def turn_ending
    return_party if $game_temp.summon_active && @summon_turn != nil && @summon_turn != 0 && ($game_temp.battle_turn - @summoned_turn) >= @summon_turn
    turn_ending_summon_n01
  end
  #--------------------------------------------------------------------------
  alias playing_action_summon_n01 playing_action
  def playing_action
    playing_action_summon_n01
    summon
  end
  #--------------------------------------------------------------------------
  def summon
    return false if @active_battler.nil? or not @active_battler.actor?
    now_action(@active_battler)
    if @now_action.is_a?(RPG::Item) && Summon_Item.include?(@now_action.id) 
      $game_party.lose_item(@now_action.id, 1) if @item.consumable
      id = Summon_Item[@now_action.id]
    elsif @now_action.is_a?(RPG::Skill) && Summon_Skill.include?(@now_action.id) 
      @active_battler.sp -= @now_action.sp_cost
      id = @now_action.id
    elsif @now_action.is_a?(RPG::Skill) && @now_action.id == Rertun_Skill_ID
      @active_battler.sp -= @now_action.sp_cost
      action_anim(@now_action.id)
      return_party
      return true
    else
      return false
    end
    summons(id)
    return true
  end
  #--------------------------------------------------------------------------
  def summons(id)
    $game_party.refresh
    action_anim(id)
    exchange_summon if $game_temp.summon_active
    remove_bars if $atoa_script['SBS ATB']
    @summon_config = Summon_Skill[id][0].dup
    $game_party.summoned = Summon_Skill[id][1].dup
    @old_party.clear
    for actor in $game_party.actors
      @old_party << actor
    end
    unless @exchange_party
      @status_window.refresh
    end
    @exchange_party = false
    unless @summon_config[2].nil?
      Audio.bgm_play('Audio/BGM/' + @summon_config[2], 100, 100)
      $game_system.bgm_memorize
    end
    @spriteset.remove_party
    $game_party.removed_actors.clear
    case @summon_config[0]
    when 0
      for actor in $game_party.actors
        $game_party.removed_actors << actor unless actor.id == @active_battler.id
      end
    when 1
      for actor in $game_party.actors
        $game_party.removed_actors << actor
      end
    when 2
      $game_party.removed_actors << @active_battler
    end
    for actor in $game_party.removed_actors
      $game_party.remove_actor(actor.id)
    end
    for summon_id in $game_party.summoned
      @summon_item[summon_id] = @summon_config[3]
      $game_party.add_summon(summon_id)
    end
    for battler in @action_battlers
      @action_battlers.delete(battler) if battler.actor? and not $game_party.actors.include?(battler)
    end
    $game_temp.summoning = true
    @spriteset.update_summon
    @status_window.refresh
    $game_temp.summoning = false
    add_bars if $atoa_script['SBS ATB']
    wait(4)
    @summon_turn = @summon_config[1] == 'level' ? 
      [(@active_battler.level / 5).to_i + 2, 1].max : @summon_config[1]
    @summoned_turn = $game_temp.battle_turn
    $game_temp.summon_active = true
  end
  #--------------------------------------------------------------------------
  def action_anim(id)
    @spriteset.set_action(@active_battler.actor?, @active_battler.index, "SUMMON_ANIM")
    wait(16)
    @active_battler.animation_id = $data_skills[id].animation1_id
    wait_time = $data_skills[id].animation1_id == 0 ? 0 : $data_animations[@active_battler.animation_id].frame_max
    wait(32)
  end
  #--------------------------------------------------------------------------
  def return_party(battle_end = false)
    wait(4)
    remove_bars if $atoa_script['SBS ATB']
    $game_system.bgm_play($game_system.bgm_memorize)
    @spriteset.remove_party
    $game_party.actors.clear
    $game_party.removed_actors.clear unless battle_end
    $game_party.summoned.clear unless battle_end
    return_old_party
    $game_temp.summoning = true
    @spriteset.update_summon
    @status_window.refresh
    $game_temp.summoning = false
    add_bars if $atoa_script['SBS ATB']
    wait(4)
    @summoned_turn = @summon_turn = 0
    $game_temp.summon_active = false
  end
  #--------------------------------------------------------------------------
  def exchange_summon
    old_active = @active_battler
    wait(4)
    remove_bars if $atoa_script['SBS ATB']
    $game_party.actors.clear
    $game_party.removed_actors.clear
    $game_party.summoned.clear
    return_old_party
    @summoned_turn = @summon_turn = 0
    $game_temp.summon_active = false
    @exchange_party = true
    @active_battler = old_active
    add_bars if $atoa_script['SBS ATB']
  end
  #--------------------------------------------------------------------------
  def end_battle_return_party
    remove_bars if $atoa_script['SBS ATB']
    $game_party.actors.clear
    return_old_party
    @summoned_turn = @summon_turn = 0
    $game_temp.summon_active = false
    add_bars if $atoa_script['SBS ATB']
  end
  #--------------------------------------------------------------------------
  def return_old_party
    for actor in @old_party
      $game_party.add_actor(actor.id)
    end
  end
end

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def update_summon
    @actor_sprites.clear
    for i in 0...$game_party.actors.size
      @actor_sprites.push(Sprite_Battler.new(@viewport2, $game_party.actors[i]))
    end
    update
  end
  #--------------------------------------------------------------------------
  def remove_party
    for sprite in @actor_sprites
      sprite.dispose
    end
  end
end

#==============================================================================
# ■ Window_Summon_Status
#==============================================================================
class Window_Summon_Status < Window_Base
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(208, 64, 432, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh(actor)
  end
  #--------------------------------------------------------------------------
  def refresh(actor)
    self.contents.clear
    f_x =  Summon_Show_Face ? 124 : 0
    draw_actor_face_graphic(actor, 0, 112) if Summon_Show_Face
    draw_actor_name(actor, 4 + f_x, 0)
    draw_actor_level(actor, 4 + f_x, 32)
    draw_actor_state(actor, 136 + f_x, 0)
    draw_actor_hp(actor, 88 + f_x, 32, 172)
    draw_actor_sp(actor, 88 + f_x, 64, 172)
    self.contents.font.size = 16
    self.contents.font.bold = true
    x, y = 24 , 204
    y_adjust = DAMAGE_ALGORITHM_TYPE == 2 ? -56 : 4
    draw_actor_parameter(actor, x, y + (20 * 0), 0) unless DAMAGE_ALGORITHM_TYPE == 2
    draw_actor_parameter(actor, x, y + (20 * 1), 1) unless DAMAGE_ALGORITHM_TYPE == 2
    draw_actor_parameter(actor, x, y + (20 * 2), 2) unless DAMAGE_ALGORITHM_TYPE == 2
    draw_actor_parameter(actor, x, y + (20 * 3), 7) unless DAMAGE_ALGORITHM_TYPE == 2
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
      parameter_name = DAMAGE_ALGORITHM_TYPE > 1 ? STAT_VIT : $data_system.words.dex
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = STAT_EVA
      parameter_value = actor.eva
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 96, y, 36, 32, parameter_value.to_s, 2)
  end
  #--------------------------------------------------------------------------
  def draw_element_resist(actor, x)
    max_elment = [Summon_Max_Elements_Shown, 8].min
    y = (496 - (max_elment * 25)) / 2
    if $atoa_script['SBS Actor Status']
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
  def draw_actor_face_graphic(actor, x, y, opacity = 255)
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
# ■ Window_Command_Summon_Status
#==============================================================================
class Window_Command_Summon_Status < Window_Selectable
  #--------------------------------------------------------------------------
  attr_accessor :commands
  #--------------------------------------------------------------------------
  def initialize(commands)
    super(0, 64, 208, 416)
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
      draw_item(i, normal_color)
    end
  end
  #--------------------------------------------------------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index].name)
  end
  #--------------------------------------------------------------------------
  def disable_item(index)
    draw_item(index, disabled_color)
  end
end

#==============================================================================
# ■ Scene_Summon_Status
#==============================================================================
class Scene_Summon_Status
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def main
    @spriteset = Spriteset_Map.new if Summon_Status_Show_Map
    unless Summon_Status_Back_Image.nil?
      @back_image = Sprite.new
      @back_image.bitmap = RPG::Cache.windowskin(Back_Image)
    end
    commands = []
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
    viewport = Viewport.new(208, 80, 400, 368)
    viewport.z = 101
    @anim_frames = @anim_max_frames = @frame_number = 0
    @summon_sprite = Sprite.new(viewport)
    update_info
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
  def return_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  def update
    @summon_sprite.update
    if Input.repeat?(Input::UP) or Input.repeat?(Input::DOWN)
      @help_window.set_text(@summon.name)
      @main_window.update
      @info_window.update
      @help_window.update
      @anim_frames = @anim_max_frames = @frame_number = 0
      update_info
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      return_scene
      return
    end
    summon_refresh
  end
  #--------------------------------------------------------------------------
  def update_info
    @summon = @main_window.commands[@main_window.index]
    @info_window.refresh(@summon)
    summon_update
  end
  #--------------------------------------------------------------------------
  def summon_refresh
    @frame_number = (@frame_number + 1) % @frame_max if @anim_frames == 0
    @anim_frames = [(@anim_frames + 1), 2].max % @frame_time
    @ca = @cw * @frame_number
    @summon_sprite.src_rect.set(@ca, 0, @cw, @ch)
  end
  #--------------------------------------------------------------------------
  def summon_update
    @summon_sprite.bitmap = RPG::Cache.character(@summon.battler_name, @summon.battler_hue) if WALK_ANIME
    begin
      @summon_sprite.bitmap = RPG::Cache.character(@summon.battler_name + "_1", @summon.battler_hue) unless WALK_ANIME
    rescue
      @summon_sprite.bitmap = RPG::Cache.character(@summon.battler_name, @summon.battler_hue) unless WALK_ANIME
    end
    @cw = @summon_sprite.bitmap.width / 4
    @ch = @summon_sprite.bitmap.height / 4
    @frame_max = 4
    @frame_time = 12
    @summon_sprite.x,@summon_sprite.y = 96 - @cw / 2, 192 - @ch
    summon_refresh
  end
end