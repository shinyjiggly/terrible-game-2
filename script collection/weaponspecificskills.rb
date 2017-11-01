#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=#
# Weapon Specific Skills Script by TerreAqua
# Version: 1.1
# Type: Skill Limitation Add-on
# Key Term: Custom Skill System
# Date: 7/29/09
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=#

#===============================================================================
# Information
#-------------------------------------------------------------------------------
#
#   This script makes it so that some skills can only be used when a certain
#   weapon type is equipped.
#   For example, it shouldn't be possible to use a skill that shoots a bullet
#   when you're equipped with a sword.
#
#   Note: Should be compatible with all battle systems.
#
#   If you need to contact me about this script, please go to:
#   http://forum.chaos-project.com
#
#   You should have only gotten this script from http://chaos-project.com
#   Please let me know if you have found it somewhere else.
#===============================================================================
module Aqua
  module WeaponSpecificSkills
#:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~#
#:~:~:~:~:~:~:~:~:~:~::~:~:~: Instructions :~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~#
#:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~#
#===============================================================================
#
# Configure DUMMY_ELEMENT to include all the elements that are used for weapon
# types.
# Each weapon should have at least one of the dummy elements.
#
# Skills without a dummy element can be used with any weapon.
# Skills with 1 dummy element can only be used by that weapon type.
# Skills with multiple dummy elements can be used by multiple weapon types.
#
#===============================================================================

DUMMY_ELEMENT = [17, 18, 19, 20]

#:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~#
#:~:~:~:~:~:~:~:~:~:~:~:~  End Configure Area  :~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~#
#:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~#
  end
end

#===============================================================================
# Credits:
# Aqua (aka TerreAqua) for making this.
# vacancydenied for requesting it.
# Starrodkirby86 for just being him :)
#===============================================================================

#===============================================================================
#  This work is protected by the following license:
# #-----------------------------------------------------------------------------
# #  
# #  Creative Commons - Attribution-NonCommercial-ShareAlike 3.0 Unported
# #  ( http://creativecommons.org/licenses/by-nc-sa/3.0/ )
# #  
# #  You are free:
# #  
# #  to Share - to copy, distribute and transmit the work
# #  to Remix - to adapt the work
# #  
# #  Under the following conditions:
# #  
# #  Attribution. You must attribute the work in the manner specified by the
# #  author or licensor (but not in any way that suggests that they endorse you
# #  or your use of the work).
# #  
# #  Noncommercial. You may not use this work for commercial purposes.
# #  
# #  Share alike. If you alter, transform, or build upon this work, you may
# #  distribute the resulting work only under the same or similar license to
# #  this one.
# #  
# #  - For any reuse or distribution, you must make clear to others the license
# #    terms of this work. The best way to do this is with a link to this web
# #    page.
# #  
# #  - Any of the above conditions can be waived if you get permission from the
# #    copyright holder.
# #  
# #  - Nothing in this license impairs or restricts the author's moral rights.
# #  
# #-----------------------------------------------------------------------------
#===============================================================================

class Game_Actor
  alias aqua_weapon_specific_skill_can_use? skill_can_use?
  def skill_can_use?(skill_id)
    for i in 0...Aqua::WeaponSpecificSkills::DUMMY_ELEMENT.size
      dummyele = Aqua::WeaponSpecificSkills::DUMMY_ELEMENT[i]
      weapon = $data_weapons[self.weapon_id]
      if weapon == nil && $data_skills[skill_id].element_set.include?(dummyele)
        return false
      end
      if $data_skills[skill_id].element_set.include?(dummyele) &&
          weapon.element_set.include?(dummyele)
       return super
      end
    end
    a = Aqua::WeaponSpecificSkills::DUMMY_ELEMENT.any? {|e|
        $data_skills[skill_id].element_set.include?(e)}
    return false if a == true
    aqua_weapon_specific_skill_can_use?(skill_id)
  end
end

if $DUMMY_ELEMENTS != nil
  $DUMMY_ELEMENTS |= Aqua::WeaponSpecificSkills::DUMMY_ELEMENT
else
  $DUMMY_ELEMENTS = Aqua::WeaponSpecificSkills::DUMMY_ELEMENT.clone
end

class Game_Battler
  #--------------------------------------------------------------------------
  # * Fix Elements
  #--------------------------------------------------------------------------
  def elements_correct(elements)
    multiplier = size = 0
    elements.each {|i|
        unless $DUMMY_ELEMENTS.include?(i)
          multiplier += self.element_rate(i)
          size += 1
        end}
    return (size == 0 ? 100 : multiplier/size)
  end
  
end