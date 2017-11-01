#===============================================================================
# ** BattleStatus Modification                                           Credits
#    by DerVVulfman
#    Version 1.2
#    10-02-06
#
#-------------------------------------------------------------------------------
# ** A MODIFICATION OF
# ** The Default Battle System's BattleStatus Window
#
#-------------------------------------------------------------------------------
#  This script is a reponse from a number of people who appreciated my RTAB ver-
#  sion of the BattleStatus Mod script, and requested a variant that worked with
#  out requiring RTAB itself. Similar in appearance, this system lines up all of
#  the heroes data into horizontal rows in the style of the Final Fantasy games.
#
#  EX:  ARSHES        [Normal ]        HP 204 / SP 199   
#       BASIL         [Knockout]       HP 184 / SP  49
#       GLORIA        [Normal ]        HP 234 / SP 299
#       HILDA         [Normal ]        HP 214 / SP 129
#
#  As a bonus, the system can Right-Justify the display and set the transparency
#  of the status window.   The only caveat of this is that  it doesn't highlight
#  the name of the hero in action. But, I have altered the battle command window
#  to change its height to appear just over  the name of the current hero in ac-
#  tion (instead of moving left to right).
#
#  This system has been revised  to be more compatible  with the 'KGC_OverDrive'
#  script,  now allowing for a more sensitive and accurate refreshing of the KGC
#  OverDrive bar, and matching add-ons.
#
#-------------------------------------------------------------------------------
#  There are two editable values:
#
#  BATTLESTATUS_LEFTJUSTIFY       Controls whether  the display shows the hero's
#                                 data left to right, or right to left.  It is a
#                                 boolean value (either true or false).
#
#                                 true - This setting will display the data just
#                                        like the above example.
#
#                                 false - This reverses the display  so the name
#                                         of the hero  is on the right,  and the 
#                                         ATB bar is on the left.
#
#
#  BATTLESTATUS_OPACITY           Controls the transparency  of the display  and
#                                 of the battle command window. The value ranges
#                                 from 0 to 2...
#
#                                 0 - The display and command windows are set to
#                                     a totally solid display.
#
#                                 1 - This is the 'semi-transparent' look of the
#                                     DBS system,   with the exception  that the
#                                     battle command window is  more solid so it
#                                     will show up over the battlestatus window.
#                                     The Battleback image will show through the
#                                     semi-transparent  window  as  long  as the
#                                     Battleback image height is sufficient. The
#                                     best size for the image is 640x480 full.
#
#                                 2 - This setting  will make  the battle status
#                                     window totally invisible.  Only the battle
#                                     command window will be visible,  though it
#                                     will be semi-transparent for effect.   Re-
#                                     garding the Battleback window.. see above.
#
#
#-------------------------------------------------------------------------------
#
#  * Scripts Added
#    Window_BattleStatus    - draw_actor_name2
#
#  * Scripts Edited
#    Window_BattleStatus    - initialize                  (DBS version Edit)
#    Window_BattleStatus    - update                      (DBS version Edit)
#    Window_BattleStatus    - refresh                     (DBS version Edit)
#    Scene_Battle (part 3)  - phase3_setup_command_window (DBS version Edit)
#
#-------------------------------------------------------------------------------

#==============================================================================
# ** EDITABLE CONSTANTS
#==============================================================================


BATTLESTATUS_OPACITY = 1
BATTLESTATUS_LEFTJUSTIFY = true

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 320, 640, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    @level_up_flags = [false, false, false, false]
    case BATTLESTATUS_OPACITY
    when 0
      self.back_opacity = 255
      self.opacity = 255
    when 1
      self.back_opacity = 160
      self.opacity = 255
    when 2
      self.back_opacity = 0
      self.opacity = 0
    end    
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    if BATTLESTATUS_LEFTJUSTIFY == true
      for i in 0...$game_party.actors.size
        actor = $game_party.actors[i]
        actor_y = i * 32 + 4
        draw_actor_name(actor, 0, actor_y)
        if @level_up_flags[i]
          self.contents.font.color = normal_color
          self.contents.draw_text(160,actor_y, 120, 32, "LEVEL UP!")
        else
          draw_actor_state(actor, 160, actor_y, 120)
        end
        draw_actor_hp(actor, 320, actor_y, 120)
        draw_actor_sp(actor,474, actor_y, 120)
      end
    else
      for i in 0...$game_party.actors.size
        actor = $game_party.actors[i]
        actor_y = i * 32 + 4
        draw_actor_name2(actor, 480, actor_y)
        if @level_up_flags[i]
          self.contents.font.color = normal_color
          self.contents.draw_text(160,actor_y, 120, 32, "LEVEL UP!")
        else
          draw_actor_state(actor, 360, actor_y, 120)
        end
        draw_actor_hp(actor, 0, actor_y, 120)
        draw_actor_sp(actor,160, actor_y, 120)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Name #2 (For Right-Justified BattleStatus Windows)
  #--------------------------------------------------------------------------
  def draw_actor_name2 (actor,x,y)
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 120, 32, actor.name, 2)
  end
end

#==============================================================================
# ** Scene_Battle (part 3)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    # Disable party command window
    @party_command_window.active = false
    @party_command_window.visible = false
    # Enable actor command window
    @actor_command_window.active = true
    @actor_command_window.visible = true
    # Set actor command window position
    # Horizontal based on justification
    if BATTLESTATUS_LEFTJUSTIFY == true    
      @actor_command_window.x = 0     
    else
      @actor_command_window.x = 480
    end
    # Vertical based on actor
    @actor_command_window.y = (320 - ($game_party.actors.size * 38)) +
      (@actor_index * 38)
    # Opacity of Command Window  
    case BATTLESTATUS_OPACITY
    when 0
      @actor_command_window.back_opacity = 255
      @actor_command_window.opacity = 255
    when 1
      @actor_command_window.back_opacity = 255
      @actor_command_window.opacity = 191
    when 2
      @actor_command_window.back_opacity = 255
      @actor_command_window.opacity = 160
    end                              
    @actor_command_window.z=125    
    @actor_command_window.index = 0
  end
end