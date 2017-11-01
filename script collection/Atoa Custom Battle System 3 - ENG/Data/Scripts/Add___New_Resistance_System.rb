#==============================================================================
# New Resistance Sustem
# By Atoa
#==============================================================================
# This script allows you to set an new style for elemental and status
# resistance.
# You can set resistances direct to actors (and not only to classes),
# and set increases/decreases of resistance to equipments and states.
# You can also set how the resistances will stack.
#==============================================================================

module Atoa
  # Do not remove or change these lines
  State_Resist = {'Actor' => {}, 'State' => {}, 'Armor' => {}, 'Weapon' => {}, 'Enemy' => {}}
  Element_Resist = {'Actor' => {}, 'State' => {}, 'Armor' => {}, 'Weapon' => {}, 'Enemy' => {}}
  # Do not remove or change these lines
  
  # Basic elemental resist table
  #                    A    B    C   D   E    F
  Element_Table = [0, 200, 150, 100, 50, 0, -100]
  
  # Base resist value, equal the "C" resist
  Base_Element_Resist = 100
  
  # Basic state resist table
  #                   A   B   C   D   E   F
  States_Table = [0, 100, 80, 60, 40, 20, 0]
  
  # Base resist value, equal the "C" resist
  Base_State_Resist = 60

  # Style of the resistance acumulation
  Addition_Type = 0
  # 0 = The values are added, considering all values
  # 1 = The values are added, considering only the higher and the lower values
  # 2 = The value used are the average, considering all values
  # 3 = The value used are the average, considering only the higher and the lower values
  
  # Element_Resist[Type][Type_ID] => {Element_ID => Resist_Value,...}
  #   Type = type of the object that gives the resistance
  #     'Actor' = actor's natural resistance
  #     'State' = resistance given by states
  #     'Armor' = resistance given by armors
  #     'Weapon' = resistance given by weapons
  #     'Enemy' = resistance for enemies
  #   Type_ID = id of the actor, state, armor or weapon
  #   Element_ID = ID of the element that will have the value change
  #   Resist_Value = Resistance change value, must be an Integer.
  #     positive values are increases in resistance, negative are reductions.
  #     E.g.: an actor imune to fire equips an armor that gives -1 fire resistance
  #       will have the fire resistance changed from imune to resistant.
  Element_Resist['Actor'][1] = {4 => -1, 2 => -1}
  Element_Resist['Actor'][2] = {4 => 2, 2 => -1}
  Element_Resist['Actor'][3] = {4 => 2, 2 => -1}
  Element_Resist['Actor'][4] = {4 => 2, 2 => -1}

  Element_Resist['Armor'][1] = {4 => 3}
  
  # State_Resist[Type][Type_ID] => {State_ID => Resist_Value,...}
  #   Type = type of the object that gives the resistance
  #     'Actor' = actor's natural resistance
  #     'State' = resistance given by states
  #     'Armor' = resistance given by armors
  #     'Weapon' = resistance given by weapons
  #     'Enemy' = resistance for enemies
  #   Type_ID = id of the actor, state, armor or weapon
  #   State_ID = ID of the state that will have the value change
  #   Resist_Value = Resistance change value, must be an Integer.
  #     positive values are increases in resistance, negative are reductions.
  
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa New Resistances'] = true

#==============================================================================
# ** RPG::Weapon
#------------------------------------------------------------------------------
# Class that manage weapons
#==============================================================================

class RPG::Weapon
  #--------------------------------------------------------------------------
  # * Elemental resist
  #--------------------------------------------------------------------------
  def element_resist
    resist = Element_Resist.dup
    set_element_resist = []
    for i in 1...$data_system.elements.size
      if resist['Weapon'] != nil && resist['Weapon'][@id] != nil && 
         resist['Weapon'][@id][i] != nil
        set_element_resist[i] = resist['Weapon'][@id][i]
      else
        set_element_resist[i] = 0
      end
    end
    return set_element_resist
  end
  #--------------------------------------------------------------------------
  # * States resist
  #--------------------------------------------------------------------------
  def state_resist
    resist = State_Resist.dup
    set_state_resist = []
    for i in 1...$data_states.size
      if resist['Weapon'] != nil && resist['Weapon'][@id] != nil && 
         resist['Weapon'][@id][i] != nil
        set_state_resist[i] = resist['Weapon'][@id][i]
      else
        set_state_resist[i] = 0
      end
    end
    return set_state_resist
  end
end

#==============================================================================
# ** RPG::Armor
#------------------------------------------------------------------------------
# Class that manage armors
#==============================================================================

class RPG::Armor
  #--------------------------------------------------------------------------
  # * Elemental resist
  #--------------------------------------------------------------------------
  def element_resist
    resist = Element_Resist.dup
    set_element_resist = []
    for i in 1...$data_system.elements.size
      if resist['Armor'] != nil && resist['Armor'][@id] != nil && 
         resist['Armor'][@id][i] != nil
        set_element_resist[i] = resist['Armor'][@id][i]
      else
        set_element_resist[i] = 0
      end
    end
    return set_element_resist
  end
  #--------------------------------------------------------------------------
  # * States resist
  #--------------------------------------------------------------------------
  def state_resist
    resist = State_Resist.dup
    set_state_resist = []
    for i in 1...$data_states.size
      if resist['Armor'] != nil && resist['Armor'][@id] != nil && 
         resist['Armor'][@id][i] != nil
        set_state_resist[i] = resist['Armor'][@id][i]
      else
        set_state_resist[i] = 0
      end
    end
    return set_state_resist
  end
end

#==============================================================================
# ** RPG::State
#------------------------------------------------------------------------------
# Class that manage states
#==============================================================================

class RPG::State
  #--------------------------------------------------------------------------
  # * Elemental resist
  #--------------------------------------------------------------------------
  def element_resist
    resist = Element_Resist.dup
    set_element_resist = []
    for i in 1...$data_system.elements.size
      if resist['State'] != nil && resist['State'][@id] != nil && 
         resist['State'][@id][i] != nil
        set_element_resist[i] = resist['State'][@id][i]
      else
        set_element_resist[i] = 0
      end
    end
    return set_element_resist
  end
  #--------------------------------------------------------------------------
  # * States resist
  #--------------------------------------------------------------------------
  def state_resist
    resist = State_Resist.dup
    set_state_resist = []
    for i in 1...$data_states.size
      if resist['State'] != nil && resist['State'][@id] != nil && 
         resist['State'][@id][i] != nil
        set_state_resist[i] = resist['State'][@id][i]
      else
        set_state_resist[i] = 0
      end
    end
    return set_state_resist
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
  # * Get state base success rate
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_rate(state_id)
    result = state_rate_ranks(state_id)
    return result
  end
  #--------------------------------------------------------------------------
  # * Check state to be added
  #    index : index
  #--------------------------------------------------------------------------
  def check_add_state(index)
    state = state_rate(index)
    if rand(100) < state
      @state_changed = true
      @state_to_add << index
    end
  end
  #--------------------------------------------------------------------------
  # * Calculating Element Correction
  #     element_set : element
  #--------------------------------------------------------------------------
  def elements_correct(element_set)
    value = 100
    absorb = false
    for i in element_set
      element = element_rate_rank(i)
      element *= -1 if element < 0 and absorb == true
      value *= element / 100.0
      absorb = true if element < 0 and absorb == false
    end
    return value.to_i
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
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_newresist setup
  def setup(actor_id)
    setup_newresist(actor_id)
    @element_resist = element_resist
    @state_resist = state_resist
  end
  #--------------------------------------------------------------------------
  # * Elemental resist
  #--------------------------------------------------------------------------
  def element_resist
    resist = Element_Resist.dup
    set_element_resist = []
    for i in 1...$data_system.elements.size
      if resist['Actor'] != nil && resist['Actor'][@actor_id] != nil && 
         resist['Actor'][@actor_id][i] != nil
        set_element_resist[i] = resist['Actor'][@actor_id][i]
      else
        set_element_resist[i] = 0
      end
    end
    return set_element_resist
  end
  #--------------------------------------------------------------------------
  # * Change Elemental resist
  #     elements : new value
  #--------------------------------------------------------------------------
  def element_resist=(elements)
    return @element_resist unless elements.is_a?(Hash)
    resist = elements.dup
    @element_resist = []
    for i in 1...$data_system.elements.size
      if resist != nil && resist[i] != nil
        @element_resist[i] = resist[i]
      else
        @element_resist[i] = 0
      end
    end
    return @element_resist
  end
  #--------------------------------------------------------------------------
  # * State resist
  #--------------------------------------------------------------------------
  def state_resist
    resist = State_Resist.dup
    set_state_resist = []
    for i in 1...$data_states.size
      if resist['Actor'] != nil && resist['Actor'][@actor_id] != nil && 
         resist['Actor'][@actor_id][i] != nil
        set_state_resist[i] = resist['Actor'][@actor_id][i]
      else
        set_state_resist[i] = 0
      end
    end
    return set_state_resist
  end
  #--------------------------------------------------------------------------
  # * Change State resist
  #     elements : new value
  #--------------------------------------------------------------------------
  def state_resist=(states)
    return @state_resist unless states.is_a?(Hash)
    resist = states.dup
    @state_resist = []
    for i in 1...$data_states.size
      if resist != nil && resist[i] != nil
        @state_resist[i] = resist[i]
      else
        @state_resist[i] = 0
      end
    end
    return @state_resist
  end
  #--------------------------------------------------------------------------
  # * Get elemental resist vaule
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def elemental_resist(element_id)
    @element_resist[element_id] = 0 if @element_resist[element_id].nil?
    base_value = Element_Table.index(Base_Element_Resist)
    value = base_value + $data_classes[@class_id].element_ranks[element_id] - 3
    case Addition_Type
    when 0,2
      value += @element_resist[element_id]
      element_size = 1
      for eqp in equips
        value += eqp.element_resist[element_id]
        element_size += 1 if eqp.element_resist[element_id] != 0
      end
      for state in @states
        value += $data_states[state].element_resist[element_id]
        element_size += 1 if $data_states[state].element_resist[element_id] != 0
      end
      if $atoa_script['Atoa Equip Set']
        for set in @set_elemental_resist
          value += set[element_id] if set[element_id] != nil
          element_size += 1 if set[element_id] != nil and set[element_id] != 0
        end
      end
      value /= element_size if Addition_Type == 2      
    when 1,3
      base_resist = set_base_elemental_resist(value, base_value, element_id)
      base_resist.sort! {|a,b| b <=> a}
      h = base_resist.first.nil? ? 0 : base_resist.first
      l = base_resist.last.nil? ? 0 : base_resist.last
      addition = h + l
      addition /= 2 if  h > 0 and l < 0 and Addition_Type == 3
      value = base_value + addition
    end
    return [[value.to_i, Element_Table.size].min, 1].max
  end
  #--------------------------------------------------------------------------
  # * Get base elemental resit value
  #     value      : resist value
  #     base       : base value
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def set_base_elemental_resist(value, base, element_id)
    base_resist = [value - base, @element_resist[element_id]]
    for eqp in equips
      base_resist << eqp.element_resist[element_id]
    end
    for state in @states
      base_resist << $data_states[state].element_resist[element_id]
    end
    if $atoa_script['Atoa Equip Set']
      for set in @set_elemental_resist
        base_resist << set[element_id] if set[element_id] != nil
      end
    end
    return base_resist
  end
  #--------------------------------------------------------------------------
  # * Get state resist vaule
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def states_resist(state_id)
    @state_resist[state_id] = 0 if @state_resist[state_id].nil?
    base_value = States_Table.index(Base_State_Resist)
    value = base_value + $data_classes[@class_id].state_ranks[state_id] - 3
    case Addition_Type
    when 0,2
      value += @state_resist[state_id]
      state_size = 1
      for eqp in equips
        value += eqp.state_resist[state_id]
        state_size += 1 if eqp.state_resist[state_id] != 0
      end
      for state in @states
        value += $data_states[state].state_resist[state_id]
        state_size += 1 if $data_states[state].state_resist[state_id] != 0
      end
      if $atoa_script['Atoa Equip Set']
        for set in @set_state_resist
          value += set[state_id] if set[state_id] != nil
          element_size += 1 if set[state_id] != nil and set[state_id] != 0
        end
      end
      value /= state_size if Addition_Type == 2
    when 1,3
      base_resist = set_base_state_resist(value, state_id)
      base_resist.sort! {|a,b| b <=> a}
      h = base_resist.first.nil? ? 0 : base_resist.first
      l = base_resist.last.nil? ? 0 : base_resist.last
      addition = h + l
      addition /= 2 if  h > 0 and l < 0 and Addition_Type == 3
      value = base_value + addition
    end
    return [[value.to_i, States_Table.size].min, 1].max
  end
  #--------------------------------------------------------------------------
  # * Get base state resit value
  #     value    : resist value
  #     base     : base value
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def set_base_state_resist(value, base, state_id)
    base_resist = [value -  base, @state_resist[state_id]]
    for eqp in equips
      base_resist << eqp.state_resist[state_id]
    end
    for state in @states
      base_resist << $data_states[state].state_resist[state_id]
    end
    if $atoa_script['Atoa Equip Set']
      for set in @set_state_resist
        base_resist << set[state_id] if set[state_id] != nil
      end
    end
    return base_resist
  end
  #--------------------------------------------------------------------------
  # * Get base elemental multiplier
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def element_rate_rank(element_id)
    table = Element_Table
    result = table[elemental_resist(element_id)]
    return result
  end
  #--------------------------------------------------------------------------
  # * Get base success rate
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_rate_ranks(state_id)
    table = States_Table
    result = table[states_resist(state_id)]
    return result
  end
  #--------------------------------------------------------------------------
  # * Determine State Guard
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for eqp in equips
      next if eqp.is_a?(RPG::Weapon)
      return true if eqp.guard_state_set.include?(state_id)
    end
    return false
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
  # * Get elemental resist vaule
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def element_rate_rank(element_id)
    table = Element_Table
    base_value = Element_Table.index(Base_Element_Resist)
    value = base_value + $data_enemies[@enemy_id].element_ranks[element_id] - 3
    resit = Element_Resist['Enemy'][@enemy_id]
    value += resit[element_id] if resit != nil and resit[element_id]
    case Addition_Type
    when 0,2
      for i in @states
        value += $data_states[i].element_resist[element_id]
        element_size += 1 if $data_states[i].element_resist[element_id] != 0
      end
      value /= element_size if Addition_Type == 2
    when 1,3
      base_resist = [value - 3]
      for i in @states
        base_resist << $data_states[i].element_resist[element_id]        
      end
      base_resist.sort! {|a,b| b <=> a}
      h = base_resist.first.nil? ? 0 : base_resist.first
      l = base_resist.last.nil? ? 0 : base_resist.last
      addition = h + l
      addition /= 2 if  h > 0 and l < 0 and Addition_Type == 3
      value = 3 + addition
    end
    result = table[[[value.to_i, 6].min,1].max]
    return result
  end
  #--------------------------------------------------------------------------
  # * Get state resist vaule
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_rate_ranks(state_id)
    table = States_Table
    result = table[$data_enemies[@enemy_id].state_ranks[state_id]]
    value = $data_enemies[@enemy_id].state_ranks[state_id]
    resit = State_Resist['Enemy'][@enemy_id]
    value += resit[element_id] if resit != nil and resit[state_id]
    case Addition_Type
    when 0,2
      for i in @states
        value += $data_states[i].state_resist[state_id]
        state_size += 1 if $data_states[i].state_resist[state_id] != 0
      end
      value /= state_size if Addition_Type == 2
    when 1,3
      base_resist = [value - 3]
      for i in @states
        base_resist << $data_states[i].state_resist[state_id]        
      end
      base_resist.sort! {|a,b| b <=> a}
      h = base_resist.first.nil? ? 0 : base_resist.first
      l = base_resist.last.nil? ? 0 : base_resist.last
      addition = h + l
      addition /= 2 if  h > 0 and l < 0 and Addition_Type == 3
      value = 3 + addition
    end
    result = table[[[value.to_i, 6].min,1].max]
    return result
  end
end