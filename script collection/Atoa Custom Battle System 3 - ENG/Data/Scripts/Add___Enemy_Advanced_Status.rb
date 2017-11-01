#==============================================================================
# Enemy Advanced Status
# By Atoa
#==============================================================================
# This scripts adds news features to the enemies
#
# - Set Max Limit for Enemy Status
# - New Enemy Status
# - Enemy Auto States
#==============================================================================

module Atoa
  # Do not remove or change these lines
  Enemy_Custom_Status = {}
  Speacial_Status_Enemy = {}
  # Do not remove or change these lines
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # STATUS LIMIT SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set new limits for enemy status

  # Enemy status limit
  Enemy_Max_Hp  = 999999
  Enemy_Max_Sp  = 999999
  Enemy_Max_Str = 999
  Enemy_Max_Dex = 999
  Enemy_Max_Agi = 999
  Enemy_Max_Int = 999
  Enemy_Max_Atk = 9999
  Enemy_Max_PDef = 9999
  Enemy_Max_MDef = 9999

  # Base status Multiplier
  # These values change the base status
  # Can be decimals(E.g.: 2.7)
  Enemy_Mult_Hp  = 1
  Enemy_Mult_Sp  = 1
  Enemy_Mult_Atk = 1
  Enemy_Mult_Pdf = 1
  Enemy_Mult_Mdf = 1
  Enemy_Mult_Str = 1
  Enemy_Mult_Dex = 1
  Enemy_Mult_Agi = 1
  Enemy_Mult_Int = 1
  Enemy_Mult_EXP = 1
  Enemy_Mult_Gld = 1
  # It's possible to change the multipliers valus with an Script Call using the code:
  #   $game_system.enemy_stat_mult[status]
  #     'maxhp' = Max Hp
  #     'maxsp' = Max Sp
  #     'atk'  = Attack
  #     'pdef' = Physical Defense
  #     'mdef' = Magic Defense
  #     'str'  = Strength
  #     'dex'  = Dexterity
  #     'int'  = Intelligence
  #     'agi'  = Agility
  #     'exp'  = Gained EXP
  #     'gold' = Gained Gold
  # This can be used, for example, in an dificult system
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # NEW STATUS SETTING
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Enemy Status config
  
  # You can set the enemy status here instead of doing it on the database
  # That way you can suprass the database limits (but you still can't pass the
  # limit set on 'STATUS LIMIT SETTINGS'
  #
  # Enemy_Custom_Status[Enemy_ID] => {Status => Value}
  #   Enemy_ID = Enemy ID
  #   Status = Status changed, you don't need to add all status here, only the 
  #     ones that you wish to change, the database values will be used for 
  #     the status that wasn't added here
  #     These are the status that can be changed:
  #      'maxhp' = Max Hp
  #      'maxsp' = Max Sp
  #      'atk'  = Attack
  #      'pdef' = Physical Defense
  #      'mdef' = Magic Defense
  #      'str'  = Strength
  #      'dex'  = Dexterity
  #      'int'  = Intelligence
  #      'agi'  = Agility
  #      'eva'  = Evasion
  #      'hit'  = Hit Rate
  #      'crt'  = Critical Rate
  #      'dmg'  = Critical Damage
  #      'rcrt' = Critical Rate Resist
  #      'rdmg' = Critical Damage Resist
  #      'exp'  = Gained EXP
  #      'gold' = Gained Gold

  Enemy_Custom_Status[1] = {'hp' => 2300, 'sp' => 500, 'str' => 53, 'dex' => 55, 'agi' => 66,
    'int' => 53, 'atk' => 107, 'pdef' => 108, 'mdef' => 9999, 'eva' => 10, 'exp' => 35, 
    'gold' => 33}
    
  Enemy_Custom_Status[2] = {'rcrt' => 50, 'rdmg' => 80}
  
  #=============================================================================
end


#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Enemy Status'] = true

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
  attr_accessor :enemy_stat_mult
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_enemystatus initialize
  def initialize
    initialize_enemystatus
    @enemy_stat_mult = {'hp' => Enemy_Mult_Hp, 'sp' => Enemy_Mult_Sp,
      'str' => Enemy_Mult_Str, 'dex' => Enemy_Mult_Dex, 'agi' => Enemy_Mult_Agi,
      'int' => Enemy_Mult_Int, 'atk' => Enemy_Mult_Atk, 'pdef' => Enemy_Mult_Pdf,
      'mdef' => Enemy_Mult_Mdf, 'exp' => Enemy_Mult_EXP , 'gold' => Enemy_Mult_Gld}
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
  # * Check if use custom status
  #     status : status
  #--------------------------------------------------------------------------
  def enemy_custom_status(status)
    return true if Enemy_Custom_Status != nil and Enemy_Custom_Status[@enemy_id] != nil and
                   Enemy_Custom_Status[@enemy_id][status] != nil
    return false
  end
  #--------------------------------------------------------------------------
  # * Get enemy custom status
  #     stat : stats
  #--------------------------------------------------------------------------
  def set_enemy_parameter(stat)
    if enemy_custom_status(stat)
      n = Enemy_Custom_Status[@enemy_id][stat]
    elsif $game_system.enemy_stat_mult.keys.include?(stat)
      n = eval("$data_enemies[@enemy_id].#{stat}")
    else
      return nil
    end
    n *= $game_system.enemy_stat_mult[stat] if $game_system.enemy_stat_mult.keys.include?(stat)
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    return set_enemy_parameter('hp')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    return set_enemy_parameter('sp')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    return set_enemy_parameter('str')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    return set_enemy_parameter('dex')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    return set_enemy_parameter('agi')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    return set_enemy_parameter('int')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  def base_atk
    return set_enemy_parameter('atk')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  def base_pdef
    return set_enemy_parameter('pdef')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  def base_mdef
    return set_enemy_parameter('mdef')
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  def base_eva
    return set_enemy_parameter('eva')
  end
  #--------------------------------------------------------------------------
  # * Get Hit
  #--------------------------------------------------------------------------
  def hit
    n = set_enemy_parameter('hit').nil? ? super : set_enemy_parameter('hit').nil?
    for i in @states do n *= $data_states[i].hit_rate / 100.0 end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  def crt
    n = set_enemy_parameter('crt').nil? ? super : set_enemy_parameter('ctr').nil?
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  def dmg
    n = set_enemy_parameter('dmg').nil? ? super : set_enemy_parameter('dmg').nil?
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  def rcrt
    n = set_enemy_parameter('rcrt').nil? ? super : set_enemy_parameter('rctr').nil?
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  def rdmg
    n = set_enemy_parameter('dmg').nil? ? super : set_enemy_parameter('dmg').nil?
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get EXP
  #--------------------------------------------------------------------------
  def exp
    return set_enemy_parameter('exp')
  end
  #--------------------------------------------------------------------------
  # * Get Gold
  #--------------------------------------------------------------------------
  def gold
    return set_enemy_parameter('gold')
  end
  #--------------------------------------------------------------------------
  # * Get Maximum HP
  #--------------------------------------------------------------------------
  def maxhp
    n = base_maxhp + @maxhp_plus
    for i in @states do n *= $data_states[i].maxhp_rate / 100.0 end
    return [[n.to_i, 1].max, Enemy_Max_Hp].min
  end
  #--------------------------------------------------------------------------
  # * Get Maximum SP
  #--------------------------------------------------------------------------
  def maxsp
    n = base_maxsp + @maxsp_plus
    for i in @states do n *= $data_states[i].maxsp_rate / 100.0 end
    return [[n.to_i, 0].max, Enemy_Max_Sp].min
  end
  #--------------------------------------------------------------------------
  # * Get Strength
  #--------------------------------------------------------------------------
  def str
    n = base_str + @str_plus
    for i in @states do n *= $data_states[i].str_rate / 100.0 end
    return [[n.to_i, 1].max, Enemy_Max_Str].min
  end
  #--------------------------------------------------------------------------
  # * Get Dexterity
  #--------------------------------------------------------------------------
  def dex
    n = base_dex + @dex_plus
    for i in @states do n *= $data_states[i].dex_rate / 100.0 end
    return [[n.to_i, 1].max, Enemy_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  # * Get Agility
  #--------------------------------------------------------------------------
  def agi
    n = base_agi + @agi_plus
    for i in @states do n *= $data_states[i].agi_rate / 100.0 end
    return [[n.to_i, 1].max, Enemy_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  # * Get Intelligence
  #--------------------------------------------------------------------------
  def int
    n = base_int + @int_plus
    for i in @states do n *= $data_states[i].int_rate / 100.0 end
    return [[n.to_i, 1].max, Enemy_Max_Int].min
  end
  #--------------------------------------------------------------------------
  # * Set Maximum HP
  #     maxhp : new maximum HP
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -Enemy_Max_Hp].max, Enemy_Max_Hp].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # * Set Maximum SP
  #     maxsp : new maximum SP
  #--------------------------------------------------------------------------
  def maxsp=(maxsp)
    @maxsp_plus += maxsp - self.maxsp
    @maxsp_plus = [[@maxsp_plus, -Enemy_Max_Sp].max, Enemy_Max_Sp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # * Set Strength (STR)
  #     str : new Strength (STR)
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -Enemy_Max_Str].max, Enemy_Max_Str].min
  end
  #--------------------------------------------------------------------------
  # * Set Dexterity (DEX)
  #     dex : new Dexterity (DEX)
  #--------------------------------------------------------------------------
  def dex=(dex)
    @dex_plus += dex - self.dex
    @dex_plus = [[@dex_plus, -Enemy_Max_Dex].max, Enemy_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  # * Set Agility (AGI)
  #     agi : new Agility (AGI)
  #--------------------------------------------------------------------------
  def agi=(agi)
    @agi_plus += agi - self.agi
    @agi_plus = [[@agi_plus, -Enemy_Max_Agi].max, Enemy_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  # * Set Intelligence (INT)
  #     int : new Intelligence (INT)
  #--------------------------------------------------------------------------
  def int=(int)
    @int_plus += int - self.int
    @int_plus = [[@int_plus, -Enemy_Max_Int].max, Enemy_Max_Int].min
  end
end