#==============================================================================
# ** Minkoff's Animated Battlers Add-On:
#    Animated Battler Formations
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.0
#    05-20-2008
#    RGSS / RPGMaker XP
#============================================================================== 
#  Orochii's notes:
#  WARNING! YOU NEED TO SET HERE THE SAME AMOUNT OF FORMATIONS AT THE 
#  FormationInfo SCRIPT. IF NOT IT WILL PRODUCE AN ERROR WHEN ACCESING TO LAST
#  FORMATIONS! (the ones that doesn't have a visual configuration).
#
#  By default in this demo, this is correctly set, so if you're using this 
#  vanilla configuration provided here, you should be fine :).
#  ----------------------------------------------------------------------------
#
#  INTRODUCTION:
#
#  It has been a  long time coming  in that I  wanted to  replace the  built-in 
#  formation system I hardwired into  "Minkoff's Animated Battlers - Enhanced",
#  and finally that time has arrived.  While the base system now has the origi-
#  ginal single formation,  it is by  this system  the end user  can design the
#  battle formations  for the actor battlers.   They will start out  and remain
#  lined up in the order the end user sets up.
#
#  The system recognizes the  'Mirror Effect'  system  in Animated Battlers XP,
#  and will adjust and reverse the battler positions accordingly.  You need not
#  worry about  creating duplicate  formation entries  for both left  and right
#  sided formations.
#
#------------------------------------------------------------------------------
#  
#  CREATING THE FORMATIONS:
#
#  This system allows you to create multiple formations.   This is accomplished
#  by the way you use the 'ABATXP_FORMATION' array.  The syntax is as follows:
#
#  ABATXP_FORMATION = { id => [ formation set ], id => [formation set],... }
#
#  So...  with that,  you can make  multiple sets  of formations  which you can
#  switch to while the game is running..
#
#  Now...  each formation set holds the x and y position for each actor battler
#  in combat.  Not by their 'Actor ID' mind you,  merely by party member order.
#  So the first member in your party,regardless of their position in your actor
#  database, will be first battler position defined in the formation set.  The
#  layout for each formation set is as follows:
#
#             [ [Battler 1's X & Y], [Battler 2's X & Y],... ]
#
#  Most people would set a formation set with allowances for 4 battlers. But if
#  you wanted to use a large party script  to increase the number of members in
#  your battle party, you can add more than 4 battler arrays like so:
#
#  ...ON = { 0 => [ [350,200], [395,235], [440,270], [485,305], [530,340] ],
#            1 => [ [530,200], [485,235], [440,275], [395,305], [350,340] ]  }
#  
#------------------------------------------------------------------------------
#
#  SCRIPT CALL:
#
#  There's only one script call you should be familiar with right now, and that
#  is the script call that changes the formation you want to use in battle.  By
#  default, the system uses the formation set by ID #0.  But you can change the
#  formation being used with the following call:
#
#
#  The call is simple:  $game_system.abatxp_form_id = number
#
#  Where the number is the ID number of your formation.  That's it.
#
#
#------------------------------------------------------------------------------
#
#  NOTE:
#
#  While designed and intended for use with Animated Battlers VX,  it can be
#  used with only the Actor Battler Graphics script to change the basic for-
#  mation of  the heroes.   With this,  you can make  a very simple sideview
#  system... just not animated.
#
#------------------------------------------------------------------------------
#
#  TERMS AND CONDITIONS:
#
#  Free to use, even in commercial projects.  Just note that I need some form
#  of due credit... even a mere mention in some end titles.
#
#==============================================================================

  # THE  FORMATION
  # SETTING  ARRAY
  # ==============
  #                   ID      Battler 1   Battler 2   Battler 3   Battler 4
  ABATXP_FORMATION = { 0 => [ [432, 320], [352, 240], [352, 400], [512, 240], [512,400] ], #PhoenixDance
                       1 => [ [512, 320], [352, 280], [352, 360], [432, 240], [432,400] ], #Genbu
                       2 => [ [352, 320], [432, 280], [432, 320], [512, 320], [512,360] ], #DragonForm
                       3 => [ [432, 320], [352, 280], [352, 360], [352, 240], [352,400] ], #Tiger'sCove
                       4 => [ [432, 320], [432, 280], [432, 360], [432, 240], [432,400] ], #FreeFight
                       5 => [ [352, 320], [352, 280], [352, 360], [432, 320], [512,320] ], #TriAnchor
                       6 => [ [352, 320], [432, 280], [432, 360], [512, 240], [512,400] ], #Speculation
                       7 => [ [512, 320], [352, 240], [352, 400], [432, 280], [432,360] ], #PowerRaise
                       8 => [ [352, 320], [512, 280], [512, 360], [512, 240], [512,400] ], #DesertLance
                       9 => [ [512, 320], [352, 280], [352, 360], [352, 240], [352,400] ], #HunterShift
                       10=> [ [432, 320], [352, 280], [352, 360], [432, 240], [432,400] ], #Whirlwind
                       11=> [ [432, 320], [512, 320], [352, 320], [432, 280], [432,360] ], #ImperialCross
                       12=> [ [352, 320], [512, 280], [352, 240], [512, 360], [352,400] ], #Squad
                       13=> [ [352, 240], [432, 280], [432, 320], [512, 360], [512,400] ], #Slash
                       14=> [ [432, 320], [512, 320], [352, 320], [512, 280], [512,360] ], #ImperialArrow
                       15=> [ [352, 320], [432, 240], [432, 400], [512, 280], [512,360] ], #DesertFox
                       16=> [ [352, 320], [432, 240], [432, 280], [432, 360], [432,400] ], #RapidStream
                       }

  
  
#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles system-related data. Also manages vehicles and BGM, etc.
# The instance of this class is referenced by $game_system.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :abatxp_form_id           # Formation ID
  attr_accessor :abatxp_mirror            # Mirror Effect (used by AnimBatVX)
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_game_system initialize unless $@
  def initialize
    init_game_system
    @abatxp_form_id = 0                # Initial formation
  end
end



#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Actor X Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    if $game_system.sv_angle == 1
      return 640 - ABATXP_FORMATION[$game_system.abatxp_form_id][self.index][0]
    else
      return ABATXP_FORMATION[$game_system.abatxp_form_id][self.index][0]
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Y Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    return ABATXP_FORMATION[$game_system.abatxp_form_id][self.index][1]
  end
end
