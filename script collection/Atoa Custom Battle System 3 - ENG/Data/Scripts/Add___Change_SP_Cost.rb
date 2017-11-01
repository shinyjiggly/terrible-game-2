#==============================================================================
# Change SP Cost
# By Atoa
#==============================================================================
# This script allows to you to set classes or equipments that changes the sp cost
# of the skills
#==============================================================================

module Atoa
  # Do not remove this line
  Sp_Cost_Change = {'Weapon' => {}, 'Armor' => {}, 'Class' => {}}
  # Do not remove this line

  # Sp_Cost_Change_Equip[kind][id] => change
  #  kind = type, must be:
  #    'Class' for classes, 'Weapon' for weapons, 'Armor' for armors
  #  id = Class/Equipment ID
  #  change = change on the SP cost, negative values are cost reducitions, positive
  #    values are cost increase
  Sp_Cost_Change['Weapon'][38] = -25
  Sp_Cost_Change['Armor'][37] = 50
  Sp_Cost_Change['Class'][4] = -50
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa SP Change Cost'] = true

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Change SP cost
  #--------------------------------------------------------------------------
  def sp_change_equip
    sp_equip = 100
    if Sp_Cost_Change['Class'].include?(@class_id)
      sp_equip = (((100 + Sp_Cost_Change['Class'][@class_id]) * sp_equip)/ 100)
    end
    for equip in equips.compact
      if equip.is_a?(RPG::Weapon) and Sp_Cost_Change['Weapon'] != nil and
         Sp_Cost_Change['Weapon'].include?(action_id(equip))
        sp_equip = (((100 + Sp_Cost_Change['Weapon'][action_id(equip)]) * sp_equip)/ 100)
      elsif equip.is_a?(RPG::Armor) and Sp_Cost_Change['Armor'] != nil and
         Sp_Cost_Change['Armor'].include?(action_id(equip))
        sp_equip = (((100 + Sp_Cost_Change['Armor'][action_id(equip)]) * sp_equip)/ 100)
      end
    end
    return [sp_equip, 0].max
  end
  #--------------------------------------------------------------------------
  # * Get skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  def calc_sp_cost(skill)
    cost = super(skill)
    return (cost * sp_change_equip) / 100
  end
end