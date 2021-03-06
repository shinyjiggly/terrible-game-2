#==============================================================================
# OPITIONAL SCRIPTS
#==============================================================================
#
# All scripts bellow Main are opitional Add-Ons fo the ACBS, and aren't
# vital for the systems
# If you want to use any of them, move the script to above main, leaving them
# just bellow the script "ACBS | Battle Main Code"
#
# If you don't want to use, just leave them or delete.
# Until they are bellow Main, they will have no effect
#
# All these scripts were modified to an better compatiblity with the ACBS,
# and they will not work with other battle systems
#==============================================================================

#==============================================================================
# UPDATING SCRIPTS AND ADD-ONS
#--------------------------------------------------------------------------
# To update the « Battle Scriptsa » just replace all their codes
# To update the add-ons copy and replace the code bellow the line
# ** Atoa Module
# It may be needed to add or remove constants from the settings,
# if that is needed, it will be listed on the version history
#==============================================================================

#==============================================================================
# BATTLERS CCOA AND RMXP DEFAULT
#--------------------------------------------------------------------------
# Use CCOA Battlers (that are divided in diferent files) and RMXP Default (static battlers)
# are now, a lot easier, just add an special character before the graphic filename
#
# For CCOA Battlers, add "%" on the filename
# Ex.: %Wenia
# You must add "%" for all files of this battler
#
# For RMXP Default battlers (non animated), add "$" on the filename
# Ex.: $001-Fighter01
#==============================================================================

#==============================================================================
# BATTLERS FILENAMES WITH SUFIX
#--------------------------------------------------------------------------
# Some add-ons and settings needs you to add special sufix on the battler filename
# The following settings needs this change:
#
# 1 - 4 Directions Battlers:
#   If the Basic Setting 'Battle_Style' is set 3. The battlers will have 4 direction.
#   The poses facing up and down needs an special sufix added to the battler filename
#   '_up' for face up
#   '_down' for face down
#
# 2 - CCOA Battlers.
#   They needs an sufix with an underscore'_' plus an numeric value that represents
#   the pose ID.
#   Ex.: %Wenia_3 #filename of the Pose ID 3
#  
# 3 - Graphics of sprites from the add-on "Equipment Sprites" needs specific sufixes
#   set on the add-on.
#
# 4 - Graphics of sprites from the add-on "States Graphic" needs specific sufixes
#   set on the add-on.
#
# If an graphic needs more than one sufix, they must be added on the following order
#   1 = Sufix of the Add-On "State Graphics"
#   2 = Sufix of the direction
#   3 = Sufix of the CCOA Battlers
#   4 = Sufix of the Add-On "Equipament Sprites"
#
#==============================================================================

#==============================================================================
# SCRIPT CALL COMMADNS:
#--------------------------------------------------------------------------
# There's some commands that can be used with the 'Script Call' command
#
# • Outside of Battle:
#
#  Prevents the activation of Intro Battle Cry for the next battle
#  $game_temp.no_actor_intro_bc = true #for actors
#  $game_temp.no_actor_enemy_bc = true #for enemies
#
#  Prevents the activation of Victory Battle Cry for the next battle
#  $game_temp.no_actor_victory_bc = true #for actors
#  $game_temp.no_enemy_victory_bc = true #for enemies
#
# • Inside of Battle:
#
#  Hide/Show Battle Status Window
#  $game_temp.status_hide = true/false
#   true shows window, false hides windows
#
#  Battler Movement.
#   $scene.battler_custom_move(battler, pos_x, pos_y)
#    - battler: Battler that will be moved
#       use $game_party.actors[index] or $game_actors[id] for actors
#       use $game_troop.enemies[index] for enemies
#    - pos_x: position x 
#    - pos_y: position y
#
#  Change Battler pose
#  $scene.battler_custom_pose(battler, pose)
#    - battler: Battler that will change pose
#       use $game_party.actors[index] or $game_actors[id] for actors
#       use $game_troop.enemies[index] for enemies
#    - pose: Pose ID
#
#  Pose sequence for battlers
#  $scene.battler_pose_sequence(battler, [poses])
#    - battler: Battler that will change pose
#       use $game_party.actors[index] or $game_actors[id] for actors
#       use $game_troop.enemies[index] for enemies
#    - pose: IDs of the poses that will be used
#
#  Reset Battler position
#  $scene.battler_reset_position(battler)
#    - battler: Battler that will reset position
#       use $game_party.actors[index] or $game_actors[id] for actors
#       use $game_troop.enemies[index] for enemies
#
#  Reset Battler pose
#  $scene.battler_reset_pose(battler)
#    - battler:Battler that will reset pose
#       use $game_party.actors[index] or $game_actors[id] for actors
#       use $game_troop.enemies[index] for enemies
#
#==============================================================================