#==============================================================================
# Equipment for Skills
# By Atoa
#==============================================================================
# This scripts allows to set skills that can be used only when
# some specific equipment are equiped.
# Useful if you don't want sword user characters to be able to use bows skills.
#==============================================================================

module Atoa
  # Do not remove this line
  Need_Skills = {'Weapons' => {}, 'Armors' => {}}
  # Do not remove this line
 
  # Need_Skills['Weapons'][Skill ID] = [Weapon ID,...]
  Need_Skills['Weapons'][57] = [1,2,3,4]
  Need_Skills['Weapons'][73] = [17,18,19,20]
  Need_Skills['Weapons'][74] = [17,18,19,20]
  Need_Skills['Weapons'][75] = [17,18,19,20]
  Need_Skills['Weapons'][76] = [17,18,19,20]
  Need_Skills['Weapons'][77] = [21,22,23,24]
  Need_Skills['Weapons'][78] = [21,22,23,24]
  Need_Skills['Weapons'][79] = [21,22,23,24]
  Need_Skills['Weapons'][78] = [21,22,23,24]
  
  # Need_Skills['Armors'][Skill ID] = [Armor ID,...]
end
 
#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Skill Need Weapon'] = true

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias atoa_weapon_need_skill_can_use skill_can_use?
  def skill_can_use?(skill_id)
    have_weapon = Need_Skills['Weapons'][skill_id].nil?
    for weapon in weapons
      if Need_Skills['Weapons'][skill_id] != nil and Need_Skills['Weapons'].include?(skill_id)
        have_weapon = true if Need_Skills['Weapons'][skill_id].include?(action_id(weapon))
      end
    end
    return false unless have_weapon 
    have_armor = Need_Skills['Armors'][skill_id].nil?
    for armor in armors
      if Need_Skills['Armors'][skill_id] != nil and action_id(armor) != nil and
         Need_Skills['Armors'].include?(skill_id)
        have_armor = true if Need_Skills['Armors'][skill_id].include?(action_id(armor))
      end
    end
    return false unless have_armor
    return atoa_weapon_need_skill_can_use(skill_id)
  end
end