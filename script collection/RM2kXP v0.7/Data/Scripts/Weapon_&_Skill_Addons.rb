#==============================================================================
# Weapon & Skill AddOns
#==============================================================================
# Buff/Debuff dragon quest style skills
# By gerkrt/gerrtunk
# Version: 1.1
# Date: 23/12/2010
#==============================================================================
 
=begin
 
--------Introduction-----------
 
This script returns a function that was in old rpgmakers and in games like dragon
quest: the option to reduce or sum battlers atributes temporally in combat based
in a fixed number and not using %.
 
You can ask for bugs, suggerences, compatibilitzations and any other things.
 
-------In the future------------
 
-The option to use fixed values with very small variance and not traditional skill
formula
-A max uses for each skill. In this way, a skill can lose its effects after a
number of uses. In this way you can control overbuffering.
-A max % of buffering for atributes. Another way of dealing with extreme buffs.
 
------Instructions-------------
                    skill_id1 effect type    skillid2 effect type, etc
Atribute_mod_skills = { 7=> [-777, 'maxhp'], 8=> [777, 'maxhp']}
 
For selecting buf or debuf you only need to put a positive or negative number.
 
 
Tags for the type(like in database ones)
 
maxhp
maxsp
 
str
dex
agi
int
 
atk
pdef
mdef
eva
 
---------Syntax notes--------------
 
'' delimites words in ruby
You can divide long linges like this:
 
Atribute_mod_skills = { 7=> [-777, 'maxhp'],
8=> [777, 'maxhp'],
9=> [777, 'maxhp']}
 
See that the new line have to be after a , and that the final one dont put a
final ,.
 
---------Other notes-----------------
 
-Is applied the skill variance, and force and intelligence influences
that you normally select in the database. It uses the same formula.
 
-The effects are acumulative.
 
-The effects are reset after combat.
 
=end

#==============================================================================
# % based weapons (& skills) states rates
# By gerkrt/gerrtunk
# Version: 1.0
# Date: 23/12/2010
#
# Modified By Midnight Moon to support skills.
# Date: 08/08/2011
#==============================================================================

=begin

--------Introduction-----------
 
Normally you can add any combination of states for weapons and skills,
but you dont have any other control. With this you can use any state based on %.
 
You can ask for bugs, suggerences, compatibilitzations and any other things.

The % means the posibilities that have the state to impact the enemy. After that
impact, the traditional formula(versus random+abdce) is applied. It works like
old rpgmakers state affliction.
 
 
weapon_id=>[[state_id1, posibility], [state_id2, posibility]]
 
Weap_state_rates = {3=>[[2, 100], [4,100]], 11=>[[2, 100], [4,100]] }
 
You can add any number of states for weapon, and weapons, just add a , before these.
and respect the {}.
 
---------Syntax notes--------------
 
You can divide long linges like this:
 
Weap_state_rates = {3=>[[2, 100], [4,100]],
11=>[[2, 100], [4,100]] ,
15=>[[2, 100], [4,100]] }
 
See that the new line have to be after a , and that the final one dont put a
final ,.


=end

module Wep
  
  # Set Atribute_mod_skills to nil if you want to deactivate
  # Buff/Debuff dragon quest style skills

  Atribute_mod_skills = { 7=> [-777, 'maxhp'], 8=> [777, 'maxhp']}
  
  # Set Weapon_state_rates to nil if you want to deactivate
  # % based weapons states rates
  
  Weapon_state_rates = {}
  
  # Set Skill_state_rates to nil if you want to deactivate
  # % based skills states rates
  
  Skill_state_rates = {
    12=>[[14, 20, [2, 9, 10, 13, 15]]],
    17 => [[15, 20, [1, 9, 14]]]
  }
end


class Scene_Battle
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:lose 2:escape)
  #     moded to reset actors atributes
  #--------------------------------------------------------------------------
  def battle_end(result)
   
    # Reset actors atributes modifiers  
    for actor in $game_party.actors
      actor.reset_atr_mod_list
    end
 
    # Clear in battle flag
    $game_temp.in_battle = false
    # Clear entire party actions flag
    $game_party.clear_actions
    # Remove battle states
    for actor in $game_party.actors
      actor.remove_states_battle
    end
    # Clear enemies
    $game_troop.enemies.clear
    # Call battle callback
    if $game_temp.battle_proc != nil
      $game_temp.battle_proc.call(result)
      $game_temp.battle_proc = nil
    end
    # Switch to map screen
    $scene = Scene_Map.new
  end
end

class Game_Battler
  #--------------------------------------------------------------------------
  # * Applying Normal Attack Effects
  #     attacker : battler
  #     moded to use unique states rates
  #--------------------------------------------------------------------------
  def attack_effect(attacker)
    # Clear critical flag
    self.critical = false
    # First hit detection
    hit_result = (rand(100) < attacker.hit)
    # If hit occurs
    if hit_result == true
      # Calculate basic damage
      atk = [attacker.atk - self.pdef / 2, 0].max
      self.damage = atk * (20 + attacker.str) / 20
      # Element correction
      self.damage *= elements_correct(attacker.element_set)
      self.damage /= 100
      # If damage value is strictly positive
      if self.damage > 0
        # Critical correction
        if rand(100) < 4 * attacker.dex / self.agi
          self.damage *= 2
          self.critical = true
        end
        # Guard correction
        if self.guarding?
          self.damage /= 2
        end
      end
      # Dispersion
      if self.damage.abs > 0
        amp = [self.damage.abs * 15 / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      # Second hit detection
      eva = 8 * self.agi / attacker.dex + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
    end
    # If hit occurs
    if hit_result == true
      # State Removed by Shock
      remove_states_shock
      # Substract damage from HP
      self.hp -= self.damage
      # State change
      @state_changed = false
      # Check to add unique states for weapons
      if attacker.is_a? Game_Actor and Wep::Weapon_state_rates[attacker.weapon_id] != nil
        state_add = []
        state_remove = []
        # Loop over state rates and check the posibilties. Create a state list.
        for state_rate in Wep::Weapon_state_rates[attacker.weapon_id]
          if rand(100) < state_rate[1]
            state_add.push(state_rate[0])
            for s in state_rate[2]
              state_remove.push(s)
            end
          end
        end
        states_plus(state_add) 
        states_remove(state_remove)
      else
        states_plus(attacker.plus_state_set)
        states_minus(attacker.minus_state_set)
      end
    # When missing
    else
      # Set damage to "Miss"
      self.damage = "Miss"
      # Clear critical flag
      self.critical = false
    end
    # End Method
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Apply Skill Effects
  #     user  : the one using skills (battler)
  #     skill : skill
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    # Clear critical flag
    self.critical = false
    # If skill scope is for ally with 1 or more HP, and your own HP = 0,
    # or skill scope is for ally with 0, and your own HP = 1 or more
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      # End Method
      return false
    end
    # Clear effective flag
    effective = false
    # Set effective flag if common ID is effective
    effective |= skill.common_event_id > 0
    # First hit detection
    hit = skill.hit
    if skill.atk_f > 0
      hit *= user.hit / 100
    end
    hit_result = (rand(100) < hit)
    # Set effective flag if skill is uncertain
    effective |= hit < 100
    # Si Golpeas
    if hit_result == true
      if Wep::Atribute_mod_skills[skill.id] != nil
        # Extract and calculate effect
        # Calculate power
        ef = Wep::Atribute_mod_skills[skill.id][0] + user.atk * skill.atk_f / 100
        ef -= self.pdef * skill.pdef_f / 200
        ef -= self.mdef * skill.mdef_f / 200
        # Calculate rate
        ra = 20
        ra += (user.str * skill.str_f / 100)
        ra += (user.dex * skill.dex_f / 100)
        ra += (user.agi * skill.agi_f / 100)
        ra += (user.int * skill.int_f / 100)
        # Calculate total effect
        total_ef = ef * ra / 20
        # Apply dispersion
        if skill.variance > 0
          amp = [total_ef * skill.variance / 100, 1].max
          total_ef += rand(amp+1) + rand(amp+1) - amp
        end
       
        # Apply if exist
        case Wep::Atribute_mod_skills[skill.id][1]
         
          when 'maxhp':
            self.atr_mod_list.maxhp += total_ef
          when 'maxsp':
            self.atr_mod_list.maxsp += total_ef
           
          when 'str':
            self.atr_mod_list.str += total_ef
          when 'dex':
            self.atr_mod_list.dex += total_ef
          when 'int':
            self.atr_mod_list.int += total_ef
          when 'agi':
            self.atr_mod_list.agi += total_ef
           
          when 'atk':
            self.atr_mod_list.atk += total_ef
          when 'pdef':
            self.atr_mod_list.pdef += total_ef
          when 'mdef':
            self.atr_mod_list.mdef += total_ef
          when 'eva':
            self.atr_mod_list.eva += total_ef
        end
      end
      
      # Calculate power
      power = skill.power + user.atk * skill.atk_f / 100
      if power > 0
        power -= self.pdef * skill.pdef_f / 200
        power -= self.mdef * skill.mdef_f / 200
        power = [power, 0].max
      end
      # Calculate rate
      rate = 20
      rate += (user.str * skill.str_f / 100)
      rate += (user.dex * skill.dex_f / 100)
      rate += (user.agi * skill.agi_f / 100)
      rate += (user.int * skill.int_f / 100)
      # Calculate basic damage
      self.damage = power * rate / 20
      # Element correction
      self.damage *= elements_correct(skill.element_set)
      self.damage /= 100
      # If damage value is strictly positive
      if self.damage > 0
        # Guard correction
        if self.guarding?
          self.damage /= 2
        end
      end
      # Dispersion
      if skill.variance > 0 and self.damage.abs > 0
        amp = [self.damage.abs * skill.variance / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      # Second hit detection
      eva = 8 * self.agi / user.dex + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva * skill.eva_f / 100
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
      # Set effective flag if skill is uncertain
      effective |= hit < 100
    end
    # If hit occurs
    if hit_result == true
      # If physical attack has power other than 0
      if skill.power != 0 and skill.atk_f > 0
        # State Removed by Shock
        remove_states_shock
        # Set to effective flag
        effective = true
      end
      # Substract damage from HP
      last_hp = self.hp
      self.hp -= self.damage
      effective |= self.hp != last_hp
      # State change
      @state_changed = false
      if Wep::Skill_state_rates[skill.id] != nil
        state_add = []
        state_remove = []
        # Loop over state rates and check the posibiltys. Create a state list.
        for state_rate in Wep::Skill_state_rates[skill.id]
          if rand(100) < state_rate[1]
            state_add.push(state_rate[0])
            for s in state_rate[2]
              state_remove.push(s)
            end
          end
        end
        states_plus(state_add)
        states_minus(state_remove)
        #effective |= states_plus(state_add)
        #effective |= states_minus(state_remove)
      else
        states_plus(skill.plus_state_set)
        states_minus(skill.minus_state_set)
        #effective |= states_plus(skill.plus_state_set)
        #effective |= states_minus(skill.minus_state_set)
      end
      # If power is 0
      if skill.power == 0
        # No damage
        self.damage = ""
        # If state does not change
        unless @state_changed
          # Miss
          self.damage = "Miss"
        end
      end
    else
      # Miss
      self.damage = "Miss"
    end
    unless $game_temp.in_battle
      self.damage = nil
    end
    return effective
  end
end
 

# Struct used to save the atributes modifiers for each actor
 
AtrList = Struct.new( :maxhp, :maxsp, :str, :dex, :int, :agi, :atk, :pdef,
:mdef, :eva )
 
#==============================================================================
# ** Game_Battler (part 1)
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================
 
class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :atr_mod_list
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias gb_wep_dq_init initialize unless $@
  def initialize
    @atr_mod_list = AtrList.new(0,0,0,0,0,0,0,0,0,0)
    return gb_wep_dq_init
  end
   
  #--------------------------------------------------------------------------
  # * Reset atr mod list (for when combat ends)
  #--------------------------------------------------------------------------
  def reset_atr_mod_list
    @atr_mod_list = AtrList.new(0,0,0,0,0,0,0,0,0,0)
  end
end
 
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#==============================================================================
 
class Game_Enemy < Game_Battler
 
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  alias wep_dq_base_maxhp base_maxhp unless $@
  def base_maxhp
    # Max is 9999 and min is 0
    if wep_dq_base_maxhp + @atr_mod_list.maxhp > 9999
      return 9999
    elsif wep_dq_base_maxhp + @atr_mod_list.maxhp <= 0
      return 1
    else
      return wep_dq_base_maxhp + @atr_mod_list.maxhp
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  alias wep_dq_base_maxsp base_maxsp unless $@
  def base_maxsp
    # Max is 9999 and min is 0
    if wep_dq_base_maxsp + @atr_mod_list.maxsp > 9999
      return 9999
    elsif wep_dq_base_maxsp + @atr_mod_list.maxsp <= 0
      return 1
    else
      return wep_dq_base_maxsp + @atr_mod_list.maxsp
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  alias wep_dq_base_str base_str unless $@
  def base_str
    # Max is 999 and min is 0
    if wep_dq_base_str + @atr_mod_list.str > 999
      return 999
    elsif wep_dq_base_str + @atr_mod_list.str <= 0
      return 1
    else
      return wep_dq_base_str + @atr_mod_list.str
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  alias wep_dq_base_dex base_dex unless $@
  def base_dex
    # Max is 999 and min is 0
    if wep_dq_base_dex + @atr_mod_list.dex > 999
      return 999
    elsif wep_dq_base_dex + @atr_mod_list.dex <= 0
      return 1
    else
      return wep_dq_base_dex + @atr_mod_list.dex
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  alias wep_dq_base_agi base_agi unless $@
  def base_agi
    # Max is 999 and min is 0
    if wep_dq_base_agi + @atr_mod_list.agi > 999
      return 999
    elsif wep_dq_base_agi + @atr_mod_list.agi <= 0
      return 1
    else
      return wep_dq_base_agi + @atr_mod_list.agi
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  alias wep_dq_base_int base_int unless $@
  def base_int
    # Max is 999 and min is 0
    if wep_dq_base_int + @atr_mod_list.int > 999
      return 999
    elsif wep_dq_base_int + @atr_mod_list.int <= 0
      return 1
    else
      return wep_dq_base_int + @atr_mod_list.int
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  alias wep_dq_base_atk base_atk unless $@
  def base_atk
    # Max is 999 and min is 0
    if wep_dq_base_atk + @atr_mod_list.atk > 999
      return 999
    elsif wep_dq_base_atk + @atr_mod_list.atk <= 0
      return 1
    else
      return wep_dq_base_atk + @atr_mod_list.atk
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  alias wep_dq_base_pdef base_pdef unless $@
  def base_pdef
    # Max is 999 and min is 0
    if wep_dq_base_pdef + @atr_mod_list.pdef > 999
      return 999
    elsif wep_dq_base_pdef + @atr_mod_list.pdef <= 0
      return 1
    else
      return wep_dq_base_pdef + @atr_mod_list.pdef
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  alias wep_dq_base_mdef base_mdef unless $@
  def base_mdef
    # Max is 999 and min is 0
    if wep_dq_base_mdef + @atr_mod_list.mdef > 999
      return 999
    elsif wep_dq_base_mdef + @atr_mod_list.mdef <= 0
      return 1
    else
      return wep_dq_base_mdef + @atr_mod_list.mdef
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  alias wep_dq_base_eva base_eva unless $@
  def base_eva
    # Max is 999 and min is 0
    if wep_dq_base_eva + @atr_mod_list.eva > 999
      return 999
    elsif wep_dq_base_eva + @atr_mod_list.eva <= 0
      return 1
    else
      return wep_dq_base_eva + @atr_mod_list.eva
    end
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
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  alias wep_dq_base_maxhp base_maxhp unless $@
  def base_maxhp
    # Max is 9999 and min is 0
    if wep_dq_base_maxhp + @atr_mod_list.maxhp > 9999
      return 9999
    elsif wep_dq_base_maxhp + @atr_mod_list.maxhp <= 0
      return 1
    else
      return wep_dq_base_maxhp + @atr_mod_list.maxhp
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  alias wep_dq_base_maxsp base_maxsp unless $@
  def base_maxsp
    # Max is 9999 and min is 0
    if wep_dq_base_maxsp + @atr_mod_list.maxsp > 9999
      return 9999
    elsif wep_dq_base_maxsp + @atr_mod_list.maxsp <= 0
      return 1
    else
      return wep_dq_base_maxsp + @atr_mod_list.maxsp
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  alias wep_dq_base_str base_str unless $@
  def base_str
    # Max is 999 and min is 0
    if wep_dq_base_str + @atr_mod_list.str > 999
      return 999
    elsif wep_dq_base_str + @atr_mod_list.str <= 0
      return 1
    else
      return wep_dq_base_str + @atr_mod_list.str
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  alias wep_dq_base_dex base_dex unless $@
  def base_dex
    # Max is 999 and min is 0
    if wep_dq_base_dex + @atr_mod_list.dex > 999
      return 999
    elsif wep_dq_base_dex + @atr_mod_list.dex <= 0
      return 1
    else
      return wep_dq_base_dex + @atr_mod_list.dex
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  alias wep_dq_base_agi base_agi unless $@
  def base_agi
    # Max is 999 and min is 0
    if wep_dq_base_agi + @atr_mod_list.agi > 999
      return 999
    elsif wep_dq_base_agi + @atr_mod_list.agi <= 0
      return 1
    else
      return wep_dq_base_agi + @atr_mod_list.agi
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  alias wep_dq_base_int base_int unless $@
  def base_int
    # Max is 999 and min is 0
    if wep_dq_base_int + @atr_mod_list.int > 999
      return 999
    elsif wep_dq_base_int + @atr_mod_list.int <= 0
      return 1
    else
      return wep_dq_base_int + @atr_mod_list.int
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  alias wep_dq_base_atk base_atk unless $@
  def base_atk
    # Max is 999 and min is 0
    if wep_dq_base_atk + @atr_mod_list.atk > 999
      return 999
    elsif wep_dq_base_atk + @atr_mod_list.atk <= 0
      return 1
    else
      return wep_dq_base_atk + @atr_mod_list.atk
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  alias wep_dq_base_pdef base_pdef unless $@
  def base_pdef
    # Max is 999 and min is 0
    if wep_dq_base_pdef + @atr_mod_list.pdef > 999
      return 999
    elsif wep_dq_base_pdef + @atr_mod_list.pdef <= 0
      return 1
    else
      return wep_dq_base_pdef + @atr_mod_list.pdef
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  alias wep_dq_base_mdef base_mdef unless $@
  def base_mdef
    # Max is 999 and min is 0
    if wep_dq_base_mdef + @atr_mod_list.mdef > 999
      return 999
    elsif wep_dq_base_mdef + @atr_mod_list.mdef <= 0
      return 1
    else
      return wep_dq_base_mdef + @atr_mod_list.mdef
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  alias wep_dq_base_eva base_eva unless $@
  def base_eva
    # Max is 999 and min is 0
    if wep_dq_base_eva + @atr_mod_list.eva > 999
      return 999
    elsif wep_dq_base_eva + @atr_mod_list.eva <= 0
      return 1
    else
      return wep_dq_base_eva + @atr_mod_list.eva
    end
  end
end