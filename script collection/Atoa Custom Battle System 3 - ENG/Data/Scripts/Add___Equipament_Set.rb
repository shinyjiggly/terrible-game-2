#==============================================================================
# Equipament Set
# By Atoa
#==============================================================================
# This script allows you to create "equipments sets".
# Sets are equipment that, when used all at same time, grants extra bonus.
#==============================================================================
module Atoa
  # Do not remove or change these lines
  Equip_Set = {}
  Set_Effect = {}
  # Do not remove or change these lines

  # Equip_Set[Set_ID] = {Equip_Type => [Equips_IDs]}
  #  Set_ID = Set ID, this value must be the same as the one in 'Set_Effect'
  #  Equip_Type = 'Weapon' for weapons, 'Armor' for armor
  #  Equips_IDs = Equiment IDs
  Equip_Set[1] = {'Armor' => [12,24,28]}
 
  Equip_Set[2] = {'Weapon' => [4], 'Armor' => [4,8,16]}
  
  # Set_Effect[Set_ID] = {Effect_Type => Effects}
  #  Set_ID = Set ID, this value must be the same as the one in 'Equip_Set'
  #  Effect_Type = type of the effect
  #    'status' = change on the actor status
  #    'auto states' = auto states
  #    'skills' = skills learned
  #    'states' = elemental resistance change (only if using 'New Resistance System')
  #    'elements' = states resistance change (only if using 'New Resistance System')
  #  Effects = the chages caused, varies according to 'Effect_Type'
  #     - if 'Effect_Type' = 'status'
  #       'status' => {stat => value}
  #       value = value of change in the status
  #       stat = the status changed, must be one of the values bellow
  #        'maxhp' = Max Hp
  #        'maxsp' = Max Sp
  #        'level' = Level
  #        'atk'  = Attack
  #        'pdef' = Physical Defense
  #        'mdef' = Magic Defense
  #        'str'  = Strength
  #        'dex'  = Dexterity
  #        'int'  = Intelligence
  #        'agi'  = Agility
  #        'eva'  = Evasion
  #        'hit'  = Hit Rate
  #        'crt'  = Critical Rate
  #        'dmg'  = Critical Damage
  #        'rcrt' = Critical Rate Resist.
  #        'rdmg' = Critical Damage Resist.
  #     - if 'Effect_Type' = 'auto states'
  #       'auto states' => [states_ids]
  #         states_ids = ids of the auto states
  #     - if 'Effect_Type' = 'skills'
  #       'skills' => {min_level => skill_id}
  #         min_level = minimum level required for learning the skill
  #         skill_id = id of the skill learned
  #     - if 'Effect_Type' = 'states'
  #       'states' => {state_id => resist_value}
  #         state_id = id of the state
  #         resist_value = value of resitance change
  #     - se 'Effect_Type' = 'elements'
  #       'elements' => {element_id => resist_value}
  #         element_id = id of the element
  #         resist_value = value of resitance change
  Set_Effect[1] = {'status' => {'maxsp' => 500, 'int' => 100}}
  
  Set_Effect[2] = {'status' => {'maxhp' => 200, 'maxsp' => 200}, 'auto states' => [22], 
    'skills' => {1 => 31, 20 => 32}, 'states' => {1 => 1, 4 => 3},
    'elements' => {1 => 1, 3 => 1, 5 => 1}}
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Equip Set'] = true

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_equipset setup
  def setup(actor_id)
    reset_set_status
    setup_equipset(actor_id)
    update_equip_set
  end
  #--------------------------------------------------------------------------
  # * Change level
  #--------------------------------------------------------------------------
  alias level_change_equiset level_change
  def level_change
    forget_set_skills
    level_change_equiset
    update_equip_set
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id         : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  alias equip_equiset equip
  def equip(equip_type, id)
    reset_set_status
    equip_equiset(equip_type, id)
    update_equip_set
  end
  #--------------------------------------------------------------------------
  # * Update equipment set
  #--------------------------------------------------------------------------
  def update_equip_set
    for state in @set_auto_states
      remove_state(state, true)
    end
    reset_set_status
    weapons_id = []
    armors_id = []
    for weapon in weapons
      weapons_id << action_id(weapon) if weapon != nil
    end
    for armor in armors
      armors_id << action_id(armor) if armor != nil
    end
    for set in Equip_Set
      armors_set = weapons_set = false
      if set[1]['Weapon'] != nil
        weapons_set_id = set[1]['Weapon'].dup
        weapons_set_id.uniq!
        set_size = 0
        for id in weapons_set_id
          set_size += 1 if weapons_id.include?(id)
        end
        weapons_set = true if set_size == weapons_set_id.size
      else
        weapons_set = true
      end
      if set[1]['Armor'] != nil
        armors_set_id = set[1]['Armor'].dup
        armors_set_id.uniq!
        set_size = 0
        for id in armors_set_id
          set_size += 1 if armors_id.include?(id)
        end
        armors_set = true if set_size == armors_set_id.size
      else
        armors_set = true
      end
      apply_set_efect(set[0]) if armors_set and weapons_set
    end
    for state in @set_auto_states
      add_state(state, true)
    end
    gain_set_skill
  end
  #--------------------------------------------------------------------------
  # * Reset set bonus
  #--------------------------------------------------------------------------
  def reset_set_status
    status = ['maxhp','maxsp','atk','pdef','mdef','str','dex','int','agi','eva','hit']
    status << ['crt','dmg','rcrt','rdmg'] if $atoa_script['Atoa New Status'] 
    status.flatten!
    for st in status
      eval("@set_#{st} = 0")
    end
    @set_equipment_skills = []
    @set_auto_states = []
    @set_elemental_resist = []
    @set_state_resist = []
    forget_set_skills
  end
  #--------------------------------------------------------------------------
  # * Apply Set effects
  #     set_id : Set ID
  #--------------------------------------------------------------------------
  def apply_set_efect(set_id)
    return if Set_Effect[set_id].nil?
    set = Set_Effect[set_id].dup
    if set['status'] != nil
      for st in Set_Effect[set_id]['status']
        eval("@set_#{st[0]} += #{st[1]} if @set_#{st[0]} != nil")
      end
    end
    @set_equipment_skills << set['skills'] if set['skills'] != nil
    @set_elemental_resist << set['elements'] if set['elements'] != nil
    @set_state_resist << set['states'] if set['states'] != nil
    @set_auto_states << set['auto states'] if set['auto states'] != nil
    @set_auto_states.flatten!
    @set_auto_states.uniq!
    gain_set_skill
  end
  #--------------------------------------------------------------------------
  # * Forget Set Skills
  #--------------------------------------------------------------------------
  def forget_set_skills
    @set_skills = [] if @set_skills.nil?
    for skill in @set_skills
      self.forget_skill(skill)
    end
    @set_skills.clear
  end
  #-------------------------------------------------------------------------- 
  # * Gain Set Skills
  #-------------------------------------------------------------------------- 
  def gain_set_skill
    forget_set_skills
    for skills in @set_equipment_skills
      for skill in skills.keys
        next if $atoa_script['Atoa Equiment Skill'] and
                Skill_Restriction[@actor_id] != nil and
                Skill_Restriction[@actor_id].include?(skills[skill])
        get_new_set_equip_skill(skills[skill]) if skill <= @level
      end
    end
  end  
  #-------------------------------------------------------------------------- 
  # * Learn set skills
  #-------------------------------------------------------------------------- 
  def get_new_set_equip_skill(skill)
    unless self.skill_learn?(skill) or @set_skills.include?(skill)
      @set_skills << skill
      self.learn_skill(skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Flag for Status limit
  #--------------------------------------------------------------------------
  def stat_limit
    return $atoa_script['Atoa Status Limit']
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  alias base_maxhp_equiset base_maxhp
  def base_maxhp
    n = base_maxhp_equiset + @set_maxhp
    return [[n.to_i, 1].max, stat_limit ? Actor_Max_Hp : 9999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  alias base_maxsp_equiset base_maxhp
  def base_maxsp
    n = base_maxsp_equiset + @set_maxsp
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_Sp : 9999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  alias base_str_equiset base_str
  def base_str
    n = base_str_equiset + @set_str
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_Str : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  alias base_dex_equiset base_dex
  def base_dex
    n = base_dex_equiset + @set_dex
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_Dex : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  alias base_agi_equiset base_agi
  def base_agi
    n = base_agi_equiset + @set_agi
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_Agi : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  alias base_int_equiset base_int
  def base_int
    n = base_int_equiset + @set_int
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_Int : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  alias base_atk_equiset base_atk
  def base_atk
    n = base_atk_equiset + @set_atk
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_Atk : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  alias base_pdef_equiset base_pdef
  def base_pdef
    n = base_pdef_equiset + @set_pdef
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_PDef : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  alias base_mdef_equiset base_mdef
  def base_mdef
    n = base_mdef_equiset + @set_mdef
    return [[n.to_i, 0].max, stat_limit ? Actor_Max_MDef : 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  alias base_eva_equiset base_eva
  def base_eva
    return base_eva_equiset + @set_eva
  end
  #--------------------------------------------------------------------------
  # * Get Hit
  #--------------------------------------------------------------------------
  alias hit_equiset hit
  def hit
    return hit_equiset + @set_hit
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  alias crt_equiset crt
  def crt
    return crt_equiset + @set_crt
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  alias dmg_equiset dmg
  def dmg
    return dmg_equiset + @set_dmg
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  alias rcrt_equiset rcrt
  def rcrt
    return rcrt_equiset + @set_rcrt
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  alias rdmg_equiset rdmg
  def rdmg
    return rdmg_equiset + @set_rdmg
  end
end