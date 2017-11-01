#==============================================================================
# Skills Conditions
# by Atoa
#==============================================================================
# This script allows to set special Conditions by some skills to be used
#
#  You can set variables, switches, hp, sp or states necessary for the skill
#  usage to be enabled.
#==============================================================================

module Atoa
  # Do not remove these lines
  Skill_State_On = {}
  Skill_State_Off = {}
  Skill_Sw_On = {}
  Skill_Sw_Off = {}
  Skill_Var = {}
  Skill_Hp = {}
  Skill_Sp = {}
  # Do not remove these lines
  
  
  #=============================================================================
  # Conditions by active states
  #=============================================================================
  # These skills can be used only if the user is under one or a set of states
  #
  # Skill_State_On[Skill ID] = {'include' => [States ID]}
  # Skill_State_On[Skill ID] = {'set' => [States ID]}
  #
  #  'include' => [States ID]
  #    The battler can only use the skill if he under one of the listed states
  #   
  #  'set' => [States ID]
  #    The battler can only use the skill if he under *all* the listed states
  
   Skill_State_On[68] = {'include' => [3]} # This example the skill 68 can only be used
                                           # if the actor is undes the state ID 3.
  #=============================================================================
 
  #=============================================================================
  # Conditions by not active states
  #=============================================================================
  # These skills can be used only if the user is not under one or a set of states
  #
  # Skill_State_Off[Skill ID] = {'include' => [States ID]}
  # Skill_State_Off[Skill ID] = {'set' => [States ID]}
  #
  #  'include' => [States ID]
  #    The battler can only use the skill if he isn't under one of the listed states
  #   
  #  'set' => [States ID]
  #    The battler can only use the skill if he isn't under *all* the listed states
  
  #=============================================================================
 
  #=============================================================================
  # Conditions by active Switches
  #=============================================================================
  # These skills can be used only if one or a set of switches is turned on
  #
  # Skill_Sw_On[Skill ID] = {'include' => [States ID]}
  # Skill_Sw_On[Skill ID] = {'set' => [States ID]}
  #
  #  'include' => [ID dos Switches]
  #    The battler can only use the skill if one of the listed switches is ON
  #   
  #  'set' => [ID dos Switches]
  #    The battler can only use the skill if *all* the listed switches is ON
  
  #=============================================================================
  
  #=============================================================================
  # Conditions by not active Switches
  #=============================================================================
  # These skills can be used only if one or a set of switches is turned off
  #
  # Skill_Sw_Off[Skill ID] = {'include' => [Switches ID]}
  # Skill_Sw_Off[Skill ID] = {'set' => [Switches ID]}
  #
  #  'include' => [Switches ID]
  #    The battler can only use the skill if one of the listed switches is OFF
  #   
  #  'set' => [Switches ID]
  #    The battler can only use the skill if *all* the listed switches is OFF
 
  #=============================================================================
  
  #=============================================================================
  # Conditions by Variables
  #=============================================================================
  # These skills can be used only if the variable met the set condition
  #
  # Skill_Var[Skill ID] = {Variable ID => 'Condition'}
  #
  #  'Variable ID' = Variable ID used. Numeric Value
  #   
  #  'Condition' = Condition needed to allow the skill usage, must be *always*
  #    an sting with an contional sign followed bya number.
  #    Ex.:
  #       '<= 20'   - This mean that the condition will be met if the variable
  #                   is lower or equal to 20.
  #
  #   ** See bellow an list of possible signs. **
  
  #=============================================================================
  
  #=============================================================================
  # Conditions by HP
  #=============================================================================
  # Theses skills can be used only if the user HP met an certai condition
  #
  # Skill_Hp[Skill ID] = {'rate' => 'Condition'}
  # Skill_Hp[Skill ID] = {'integer' => 'Condition'}
  #
  #  'rate' => 'Condition'
  #    The comparison is made using the value as rate
  #     Ex.: 'rate' => '>= 50'
  #           This mean that the HP must be higher or equal to 50% of the max hp.
  #
  #  'integer' => 'Condição'
  #    The comparison is made using the integer value
  #     Ex.: 'integer' => '<= 150' 
  #           This mean that the SP must be lower or equal to 150.
  #   
  #  'Condition' = Condition needed to allow the skill usage, must be *always*
  #    an sting with an contional sign followed bya number.
  #    Ex.:
  #       '<= 20'   - This mean that the condition will be met if the variable
  #                   is lower or equal to 20.
  #
  #   ** See bellow an list of possible signs. **
  
  Skill_Hp[57] = {'rate' => '>= 50'} # This example, the skill 57 can be used
                                     # only if the hp is equal or higher than 50%
  #=============================================================================
  
  #=============================================================================
  # Conditions by SP
  #=============================================================================
  # Theses skills can be used only if the user HP met an certai condition
  #
  # Skill_Hp[Skill ID] = {'rate' => 'Condition'}
  # Skill_Hp[Skill ID] = {'integer' => 'Condition'}
  #
  #  'rate' => 'Condition'
  #    The comparison is made using the value as rate
  #     Ex.: 'rate' => '>= 50'
  #           This mean that the SP must be higher or equal to 50% of the max hp.
  #
  #  'integer' => 'Condição'
  #    The comparison is made using the integer value
  #     Ex.: 'integer' => '<= 150' 
  #           This mean that the SP must be lower or equal to 150.
  #   
  #  'Condition' = Condition needed to allow the skill usage, must be *always*
  #    an sting with an contional sign followed bya number.
  #    Ex.:
  #       '<= 20'   - This mean that the condition will be met if the variable
  #                   is lower or equal to 20.
  #
  #   ** See bellow an list of possible signs. **
    
  Skill_Hp[8] = {'integer' => '< 400'} # This example, the skill 8 can be used
                                       # onlyg if the sp is lower than 400
  
  #=============================================================================

  #=============================================================================
  # SIGNS FOR CONDTIONS
  #  <   - Lower than
  #  >   - Higher than
  #  <=  - Lower or Equal
  #  >=  - Higher or Equal
  #  ==  - Equal
  #  !=  - Different
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Skill Condition'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias stat_skill_can_use skill_can_use?
  def skill_can_use?(skill_id)
    return false if Skill_State_On[skill_id] != nil and not skill_state_on(skill_id)
    return false if Skill_State_Off[skill_id] != nil and not skill_state_off(skill_id)
    return false if Skill_Sw_On[skill_id] != nil and not skill_sw_on(skill_id)
    return false if Skill_Sw_Off[skill_id] != nil and not skill_sw_off(skill_id)
    return false if Skill_Var[skill_id] != nil and not skill_var(skill_id)
    return false if Skill_Hp[skill_id] != nil and not skill_hp(skill_id)
    return false if Skill_Sp[skill_id] != nil and not skill_sp(skill_id)
    return stat_skill_can_use(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Check active state condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_state_on(id)
    if Skill_State_On[id]['include'] != nil
      for i in Skill_State[id]['include']
        return true if @state.include?(i)
      end
    end
    if Skill_State[id]['set'] != nil
      for i in Skill_State[id]['set']
        return false unless @state.include?(i)
      end
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check inactive state condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_state_off(id)
    if Skill_State_On[id]['include'] != nil
      for i in Skill_State[id]['include']
        return false if @state.include?(i)
      end
    end
    if Skill_State[id]['set'] != nil
      for i in Skill_State[id]['set']
        return true unless @state.include?(i)
      end
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Check active swithc condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_sw_on(id)
    if Skill_Sw_On[id]['include'] != nil
      for i in Skill_Sw_On[id]['include']
        return true if $game_switches[i]
      end
    end
    if Skill_Sw_On[id]['set'] != nil
      for i in Skill_Sw_On[id]['set']
        return false unless $game_switches[i]
      end
      return true
    end
    return false    
  end 
  #--------------------------------------------------------------------------
  # * Check inactive swithc condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_sw_off(id)
    if Skill_Sw_Off[id]['include'] != nil
      for i in Skill_Sw_Off[id]['include']
        return true if $game_switches[i] == false
      end
    end
    if Skill_Sw_Off[id]['set'] != nil
      for i in Skill_Sw_Off[id]['set']
        return false unless $game_switches[i] == false
      end
      return true
    end
    return false    
  end
  #--------------------------------------------------------------------------
  # * Check variable condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_var(id)
    for var in Skill_Var[id]
      return true if eval("$game_variables[#{var[0]}] #{var[1]}")
    end
    return false    
  end
  #--------------------------------------------------------------------------
  # * Check HP condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_hp(id)
    if Skill_Hp[id]['integer'] != nil
      return true if eval("self.hp #{Skill_Hp[id]['integer']}")
    end
    if Skill_Hp[id]['rate'] != nil
      return true if eval("(self.hp * 100 / self.maxhp) #{Skill_Hp[id]['rate']}")
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check SP condition
  #     id : skill ID
  #--------------------------------------------------------------------------
  def skill_sp(id)
    if Skill_Sp[id]['integer'] != nil
      return true if eval("self.sp #{Skill_Sp[id]['integer']}")
    end
    if Skill_Sp[id]['rate'] != nil
      return true if eval("(self.sp * 100 / [self.maxsp, 1].max) #{Skill_Sp[id]['rate']}")
    end
    return false    
  end
end