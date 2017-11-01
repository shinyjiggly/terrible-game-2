class Game_Actor < Game_Battler
  
  #============================================================================#
  #=========================== START CONFIGURATION ============================#
  #============================================================================#
  
  #Setting this flag to true, characters can get more than one level after battle
  #Setting it to false, characters will get EXP until it gets to level up, all other points are wasted.
  ALLOW_MULTI_LEVEL_UP = false
  #Be warned, this makes "change level" event command to behave differently.
  
  #Sets how much of the obtained experience is influenced by the actual actor level.
  #If set to 1.0, all EXP will depend on level. 
  #If left on 0.0, level will not matter at all.
  LEVEL_CHANGE_RATE = 1.0
  
  #============================================================================#
  #=========================== END OF CONFIGURATION ===========================#
  #============================================================================#
  alias ozpe_setup setup
  def setup(actor_id)
    @ban = false
    ozpe_setup(actor_id)
  end
  
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    #pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..maxlevel+1
      if i > maxlevel
        @exp_list[i] = 0
      else
        #n = #actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = 100*(i-1) #@exp_list[i-1] + Integer(n)
      end
    end
  end
  
  def ban=(val= (!@ban))
    @ban = val
  end
  #--------------------------------------------------------------------------
  # * Change EXP
  #     exp : new EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    exp_change=exp-@exp
    # Level up
    if exp_change != 0
      rate=(1.0-LEVEL_CHANGE_RATE)+(LEVEL_CHANGE_RATE*((maxlevel*1.0-(@level-1))/(maxlevel*@level)))
      rate = 1.0 if @ban == true
      exp_change *= rate
      exp_change = Integer(exp_change)
      exp_change = 1 if exp_change == 0
      @exp = [[@exp+exp_change, 9999999].min, 0].max
      
      # Level down
      while @exp < @exp_list[@level]
        @hp_gain -= hp_gain
        @mp_gain -= mp_gain
        @level -= 1
        @exp= @exp_list[@level] if !(ALLOW_MULTI_LEVEL_UP)
      end
      # Correction if exceeding current max HP and max SP
      @hp = [@hp, self.maxhp].min
      @sp = [@sp, self.maxsp].min
    end
  end
end

class Interpreter
  #--------------------------------------------------------------------------
  # * Change Level
  #--------------------------------------------------------------------------
  def command_316
    # Get operate value
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    # Process with iterator
    iterate_actor(@parameters[0]) do |actor|
      # Change actor level
      actor.ban=true
      actor.level += value
      actor.ban=false
    end
    # Continue
    return true
  end
end