#===============================================================================
# Skill Charge
# By Atoa
#===============================================================================
# This script allow you to make 'Charge' type skills
# Each time you use an 'Charge' skill, you physical or magical power increases.
# You can use multiple times to have a higher increase.
# Once the character uses an attack/skill with the same type of the charge
# skill, he 'relase' the charges, increasing damage.
#==============================================================================

module Atoa
  
  # Show charge bonus with the action name?
  Show_Charge_Bonus = true

  # Charge for Normal Attacks/Physical Skills
  Charge_Physical_Rate = 25       # % of increase in damage
  Charge_Physical_Max  = 10       # Max times you can charge
  Charge_Physical_Name = 'Charge' # Damage Message for Physical Charge
  # ID of the skills with the 'Charge' effect
  Charge_Physical_ID   = [106]
 
  # Charge for Magical Skills
  Charge_Magical_Rate = 25          # % of increase in damage
  Charge_Magical_Max  = 10          # Max times you can charge
  Charge_Magical_Name = 'Meditate'  # Damage Message for Magical Charge
  # ID of the skills with the 'Meditate' effect
  Charge_Magical_ID   = [107]

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Charge'] = true

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
  attr_accessor :chargephy
  attr_accessor :chargemag
  attr_accessor :poweruse
  attr_accessor :magicuse
  attr_accessor :user
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_charge initialize
  def initialize
    initialize_charge
    @chargephy = @chargemag = 0
    @poweruse = @magicuse = false
  end  
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_charge set_damage
  def set_damage(user, action = nil)
    set_damage_charge(user, action)
    set_charge_value(user, action) if $game_temp.in_battle and action != nil
    attack_charge(user, action)
  end  
  #--------------------------------------------------------------------------
  # * Set Charge value
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_charge_value(user, action)
    if Charge_Physical_ID.include?(action.id)
      @chargephy += 1
      @chargephy = Charge_Physical_Max if @chargephy > Charge_Physical_Max
      user.target_damage[self] = Charge_Physical_Name unless user.target_damage[self].numeric?
    elsif Charge_Magical_ID.include?(action.id)
      @chargemag += 1
      @chargemag = Charge_Magical_Max if @chargemag > Charge_Magical_Max
      user.target_damage[self] = Charge_Magical_Name unless user.target_damage[self].numeric?
    end
  end
  #--------------------------------------------------------------------------
  # * Relase charges
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def attack_charge(user, action = nil)
    if user.chargephy > 0 and (action.nil? or not action.magic?) and not
       (Charge_Physical_ID.include?(action.id) or Charge_Magical_ID.include?(action.id))
      user.poweruse = true
      power_rate = Charge_Physical_Rate * user.chargephy
    end
    if user.chargemag > 0 and action != nil and action.magic? and not
       (Charge_Physical_ID.include?(action.id) or Charge_Magical_ID.include?(action.id))
      user.magicuse = true
      power_rate = Charge_Magical_Rate * user.chargemag
    end
    if user.target_damage[self].numeric? and power_rate != nil
      user.target_damage[self] += ((user.target_damage[self] * power_rate) / 100).to_i
    end
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias start_charge start
  def start
    start_charge
    reset_charge
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_charge terminate
  def terminate
    terminate_charge
    reset_charge
  end
  #--------------------------------------------------------------------------
  # * Clear charge values
  #--------------------------------------------------------------------------
  def reset_charge
    for actor in $game_party.actors
      actor.chargephy = actor.chargemag = 0
      actor.poweruse = actor.magicuse = false
    end
  end
  #--------------------------------------------------------------------------
  # * Action Start Animation
  #     battler : battler
  #--------------------------------------------------------------------------
  alias action_start_anime_charge action_start_anime
  def action_start_anime(battler)
    action_start_anime_charge(battler)
    if Show_Charge_Bonus 
      if battler.chargephy > 0 and battler.attack?
        action_message = Charge_Physical_Name
        action_message += ' +'
        action_message += battler.chargephy.to_s
      elsif battler.skill_use?
        unless Charge_Physical_ID.include?(now_id(battler)) or
           Charge_Magical_ID.include?(now_id(battler))
          if battler.chargephy > 0 and not battler.now_action.magic?
            action_message  = battler.now_action.name
            action_message += ' +'
            action_message += battler.chargephy.to_s
          elsif battler.chargemag > 0 and battler.now_action.magic?
            action_message  = battler.now_action.name
            action_message += ' +'
            action_message += battler.chargemag.to_s
          end
        end
      end
    end
    unless action_message.nil?
      set_action_help(action_message, battler)
      action_message = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias atoa_charge_step5_part3 step5_part3
  def step5_part3(battler)
    atoa_charge_step5_part3(battler)
    if battler.poweruse
      battler.chargephy = 0
      battler.poweruse = false
    end
    if battler.magicuse
      battler.chargemag = 0
      battler.magicuse = false
    end
  end
end