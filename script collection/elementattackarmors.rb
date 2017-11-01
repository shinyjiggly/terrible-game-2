#===============================================================================
# Element Attack Armors
# Author game_guy
# Version 1.0
#-------------------------------------------------------------------------------
# Intro:
# All armors setup in the database just allows you to make them guard against
# elements. This scripts makes it possible to allow them to add elements to
# your attack. Ex: You have Fiery Ring = Weapons do fire-typed damage 
# when equipped.
#
# Features:
# Adds elements to your attacks according to armor wearing.
#
# Instructions:
# Go down to Setup Armors and follow instructions there.
#
# Credits:
# game_guy ~ For making it
# jragyn00 ~ For requesting it
#===============================================================================
module GameGuy
  def self.accelement(id)
    case id
    #===========================
    # Armor Element Attack Setup
    # Use when armor_id then return [elements]
    #===========================
    when 25 then return [1, 2, 3, 4]
    end
    return []
  end
end
class Game_Actor < Game_Battler
  alias gg_elem_armor_attack_lat element_set
  def element_set
    return multi_equip_elem if defined?(G7_MS_MOD)
    elem = gg_elem_armor_attack_lat
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      if i != nil
        for j in GameGuy.accelement(i)
          elem.push(j)
        end
      end
    end
    return elem
  end
  def multi_equip_elem
    elem = gg_elem_armor_attack_lat
    for i in self.armor_ids
      if i != 0
        for j in GameGuy.accelement(i)
          elem.push(j)
        end
      end
    end
    return elem
  end
end