#≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
# ** Glitchfinder and theory's Target All Enemies DBS Addon      [RPG Maker XP]
#    Version 1.11
#------------------------------------------------------------------------------
#  This add-on enables Target All type weapons.
#==============================================================================
# * Version History
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   Version 1.00 ------------------------------------------------- (2009-05-29)
#     - Initial version
#     - Authors: theory and Glitchfinder
#    Version 1.10 ------------------------------------------------ (2011-03-16)
#      - Fixed crash on F12
#      - Removed forgotten print test
#      - Author: Glitchfinder
#     Version 1.11 ----------------------------------------------- (2011-03-22)
#       - Fixed crash when an actor with no weapon attacked
#       - Author: Glitchfinder
#==============================================================================
# * Instructions
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Place this script above Main, and below the default scripts. (I realize this
#  is obvious to most, but some people don't get it.)
#
#  To use this script, simply create an element named "Target All" (without the
#  quotes), and add it to the weapons that you want to use this feature.
#==============================================================================
# *Glitchfinder's Advice
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  This script is plug 'n play. Simply insert in the proper location, and
#  any weapon that has a specifically named element will target all enemies.
#==============================================================================
# * Contact
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Glitchfinder, the author of this script, may be contacted through his
#  website, found at http://www.glitchkey.com
#
#  You may also find Glitchfinder at http://www.hbgames.org
#==============================================================================
# * Usage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  This script may be used with the following terms and conditions:
#
#    1. This script is free to use in any noncommercial project. If you wish to
#       use this script in a commercial (paid) project, please contact
#       Glitchfinder at his website.
#    2. This script may only be hosted at the following domains:
#         http://www.glitchkey.com
#         http://www.hbgames.org
#    3. If you wish to host this script elsewhere, please contact Glitchfinder
#       or theory.
#    4. If you wish to translate this script, please contact Glitchfinder or
#       or theory. They will need the web address that you plan to host the
#       script at, as well as the language this script is being translated to.
#    5. This header must remain intact at all times.
#    6. Glitchfinder and theory remain the sole owners of this code. They may
#       modify or revoke this license at any time, for any reason.
#    7. Any code derived from code within this script is owned by Glitchfinder
#       and theory, and you must have their permission to publish, host, or
#       distribute their code.
#    8. This license applies to all code derived from the code within this
#       script.
#    9. If you use this script within your project, you must include visible
#       credit to Glitchfinder and theory, within reason.
#≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
 
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Alias Methods
  #--------------------------------------------------------------------------
  # If enemy selection method has not been aliased
  unless method_defined?(:targetall_enemy_select)
    # Alias the enemy selection method
    alias targetall_enemy_select start_enemy_select
  end
  #--------------------------------------------------------------------------
  # * Start Enemy Selection
  #--------------------------------------------------------------------------
  def start_enemy_select
    # Call original method
    targetall_enemy_select
    # Return if thr actor has no weapon equipped
    return unless (nil != $data_weapons[@active_battler.weapon_id])
    # Get current weapon's elements
    element_set = $data_weapons[@active_battler.weapon_id].element_set
    # Set up element name array
    element_names = []
    # Add the current weapon's element names to the element name array
    element_set.each {|i| element_names.push($data_system.elements[i])}
    # If the current weapon targets all
    if element_names.include?('Target All')
      # End enemy selection
      end_enemy_select
      # Set action
      @active_battler.current_action.basic = 128
      # Go to command input for next actor
      phase3_next_actor
    end
  end
  # If basic action result method has not been aliased
  unless method_defined?(:targetall_action)
    # Alias the basic action result method
    alias targetall_action make_basic_action_result
  end
  #--------------------------------------------------------------------------
  # * Make Basic Action Result
  #--------------------------------------------------------------------------
  def make_basic_action_result
    # If the current actor's weapon does not target all
    if @active_battler.current_action.basic != 128
      # Call the original method
      targetall_action
    else
      # Set animation ID
      @animation1_id = @active_battler.animation1_id
      @animation2_id = @active_battler.animation2_id
      # check restrictions and set targets
      @target_battlers = []
      # If attacking allies
      if @active_battler.restriction == 3
        # Attack all allies
        set_target_battlers(4)
      # If attacking enemies
      else
        # Attack all enemies
        set_target_battlers(2)
      end
      # Apply normal attack results
      for target in @target_battlers
        target.attack_effect(@active_battler)
      end
    end
  end
end