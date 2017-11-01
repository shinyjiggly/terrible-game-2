#==============================================================================
# ** Animated Battlers - Enhanced   ver. 13.8                      (01-07-2012)
#
#------------------------------------------------------------------------------
#  * (0) Credits:  Includes features included & additional system notes
#------------------------------------------------------------------------------
#  Animated Battlers by Minkoff
#  Enhancements by DerVVulfman        
#  Low percentage and Status Poses 
#     Concept & Base coding by Twin Matrix
#  Hero & Enemy z.depth concept by Min-Chan and Caldaron ( totally redone :) )
#  Collapse stack-error found by JirbyTaylor(fixed) / Code by SephirothSpawn
#  Default 'Battle Animation' glitch found by Mimi Chan (Note, can't fully fix)
#  Compatability Fix for 'Gradient Bars v3.4+' by Trickster.
#  AT Battle Pause code supplied by Fomar0153
#  'None/All' Target error found by daigotsu. Solution found & fixed... mostly.
#  Configurables now saved in save file.  Feature requested by MasterMind5823.
#  Viewport error (related to Gradient Bar fix) detected by Alistor.  Fixed.
#  Long-running Full-Screen 'Battle Animation' glitch found by Mimi-Chan. Fixed.
#  Dead battlers found still on battlefield at combat start (found by Angel_FX).
#  Variable frames per poses glitch found by Mimi-Chan... found source n fixed.
#  Dodge pose application base by Jaberwocky.
#  Ccoa Sprite Sheets by Ccoa and the request of their use and inclusion by Yin.
#  
#============================================================================== 
#
#  INTRODUCTION:
#
#  This script is not a battlesystem but a graphic overlay system that can con-
#  vert a frontview 'Strategy'  battlesystem into a Sideview battlesystem.   It
#  has gone through a number of changes over the months that I have put my spin
#  on the system, originally coded by Minkoff himself.
#
#  As of now, this system works  with the default battlesystem, the RTAB system
#  by Cogwheel, ParaDog's ATB, XRXS's system,  and a number of systems designed
#  by Trickster.
#
#  Again,  this system  changes the  'graphic'  overlay system  and is meant to 
#  change the battlers  and battler's startup positions  for a sideview system.
#  It is not meant  to alter  anything else,  including combat values,  defense
#  levels, or any other graphics other than those related to the battlers them-
#  selves.
#
#============================================================================== 
#
#  REGARDING:
#  Skill and Item Scopes:
#  Until recently,  the revised system did not allow  for target scopes beyond 
#  a single target.  This was unintentional and unforseen.   However, with the
#  revision made in version 7.3, this was corrected. But, skills or items that
#  have a target scope of  'None'  would still create an error if this form of
#  attack is set in either $moving_item_atk or $moving_skill_atk hashe arrays.
#  Don't supply the id #'s of any 'None' scope skills/items into these hashes.
#
#============================================================================== 
#
#  COMPATABILITY ISSUES:
#
#  RTAB:  Connected Attacking
#  A powerful add-on to the RTAB system by Cogwheel, this script allows an ac-
#  tor to apply multiple hits on a target.  At first, there was no auto-detect
#  feature which gave ME MIGRANES... having to use insert switch in the config 
#  section.  Now there is one.  The only caveat is that you must STILL comment
#  out or remove the entire 'action_phase' routine in Con. Attacking (which is
#  roughly lines 30 to 80).
#
#  LARGE PARTY (Fomar0153's)
#  This system allows you to make use of the 'Large Party' system by Fomar0153.
#  Unlike the previous version(s) of Animated Battlers, you don't have to place
#  the second half  of Fomar's Large Party script (the Battlestatus Page) under
#  Animated Battlers  in order  to work.   Please follow all of Fomar0153's in-
#  structions as always.
#
#============================================================================== 
#
#   ADDITIONAL CALLS AVAILABLE PRIOR TO COMBAT:
#
#------------------------------------------------------------------------------
#  SIDEVIEW MIRROR:     This value switches  the positions  of both enemies and
#                       heroes to opposite ends of the screen.
#
#   Script : $sideview_mirror = [number]
#   number : a value indicating whether the hero & enemy positions are switched
#            0 = Default:  Enemies on the left, Heroes on the right
#            1 = Switched: Heroes on the left, Enemies on the right
#
#============================================================================== 
#
#   Things added since original version by Minkoff:
#
#   Can reverse the battler positions
#   Editable spritesheet layout in script
#   Able to define total/max frames per pose
#   Can define individual # of frames per each pose
#   Can use 'red-out' RTP death or 'battler death' pose
#   Can show battler falling before death.
#   'Casting' pose now available for RTAB/Skill Timing users
#   Can show battler celebrating before victory pose
#   Can tag battlers who's victory pose loops indefinitely
#   Can show actor battlers get ready before battle starts.
#   Separate poses for 'skills', 'items' or 'weapons' based on their id
#   Can allow the battlers to step forward before using items & skills (FFVII+)
#   Attacking battlers rush towards their targets while item & skill users don't
#   Certain weapons can force the battler NOT to move
#   Certain items & skills can force battlers to 'rush' the enemy
#   Certain skills or items can force movement to the center of the screen
#   Stationary enemies. In case enemies do NOT move when they attack.
#   Adjustable 'low health' checker. Set your low health to 25%... 30%... 10%...
#   Poses now available for status ailments
#   Dead revert to 'victory' pose bug fixed.
#   Default battlers now available for actors and/or enemies
#   Default battlers now usable by ID number (had to rewrite red-out for that)
#   Escaping Enemies bug found by SteveE22.  Fixed just as fast.
#   Hero Formations (total of 8 hardwired -& 1 random- ... add at your own risk)
#   Z-Depth for attack overlapping purposes
#   Corrected attack overlap offset routine.  Overlap now based on battler size
#   Certain skills and items can now prevent movement
#   Can allow battlers to take step forward before performing 'attack' pose.(FF)
#   Certain weapons can move battlers to center screen instead of a full move.
#   Escaping Enemies can now have a pose before disappearing (was a rush pose)
#   Redesigned Scene_Battle's movement routine
#   Added pose for Critical Hits
#   Added the enemy's hash for frame number based on poses
#   Added the actor's hash for frame number based on poses
#   Re-Tooled the formations to go beyond the default four party system
#   Minor value added for compatability with Delissa's Battle Cry script
#   Default Collapse Stack-Error fixed(code by SephirothSpawn) found JirbyTaylor
#   Removed dependancy on $game_system for the Sideview Mirror system
#   Fixed the 'Blocking during Victory State' bug discovered by Kaze950
#   Battler tones now adapt to the background tones, requested by doom900
#   Fixed changing battler/battler system.  Include fade-in switch req by Neonyo
#   Set individual Actors/Enemies that phase on an attack
#   Translucent battlers... a personal desire for ghosts you can see through!
#   Adjustable opacity for translucent battlers... can't forget that.
#   FREAKIN'!!!  Fixed the Battler tones.  I forgot to 'untone' the 1st viewport.
#   Adjustable 'attack/skill/item' movement speeds requested by KAIRE.
#   Removed annoying translucency 'flicker' (excess code totally unneeded).
#   Individual 'Woozy' Rates per battlers added (JirbyTaylor gave me the idea).
#   Woozy and Status poses now override any blocking pose.  Makes sense, eh?
#   Can now use individually sized spritesheets for enemies and actors.
#   'Casting' pose now available for ParaDog's Spell Residence/Delay users.
#   Another escaping enemies (do-nothing switch) bug found by Boomy. Lengthy fix
#   Redefined the casting pose values.  Now set up for 'each' battler.  Better.
#   ---Noted: 'FullScreen' Battle Animation bug found by Mimi Chan.
#   A combination 'Nil'-Pose/Nil-State bug was fixed.  Found by Gaxx
#   'Templates per Spritesheet' system for Actors and Enemies now available.
#   ---Noted: Removed Battle Animation attempted fix. (Can't fix.  Removed.) 
#   Created 'Obtain Pose' for multiple spritesheet types to shorten code.
#   Added additional 'Custom Spritesheet' poses for the Casting pose & the like.
#   Added individual 'Casting' poses hash for each skill used.
#   Added addt. Advanced 'Custom Spritesheet' pose system for Casting & the like
#   Removed the unnecessary 'viewport.z' statement, compatible with Grad. Bars!
#   System 'can' pause the AT bar growth when performing attack, skill & item!
#   A 'None / All'-Target bug was found by daigotsu.  Taken care of... mostly.
#   Configurables (like $sideview_mirror) not saved. Bug found by MasterMind5823 
#   Now a 'casting' pose available when used with the Skill Casting Delay system
#   Bug squashed related to Casting Pose addition
#   Random Formation/Custom Battlesystem bug found by Alistor.  Very small fix.
#   The Actor Command Window was 'under' the battlers.  Found by Alistor. Fixed.
#   Moves actor battlers into viewport 1.  Fixes hero/window menu glitches.
#   Fixes the battle animation glitch found by Mimi Chan by relocating enemies!
#   Additional compatability with Fomar0153's Large Party (v2) system added.
#   Fixed a minor bug with battle poses if called from a Custom Sheet template.
#   Can tag battlers who's defeat poses loops indefinitely (Hakuya suggestion).
#   Dead guys now hidden at battle start (visible if 'raised) Thanks Angel_FX.
#   Converted the CONFIG section to use 'constants' to reduce resources used.
#   Converted the $global RTAB/ParaDog/Fomar detection values to $game_system.
#   Includes an Adaptation Switch for use with RTAB's Connected Attacking script
#   -Finally- Connected Attacking is auto-detected.  Adaption switch not needed.
#   Got tired of referring to IDX nos for template.  Poses start at 1, not 0!!!
#   Replaced all but '7' $global values with $game_system values.  Resources!!!
#   Revised the AT bar growth system for Trickster's newer battlesystems.
#   Repaired the Victory Pose looop/no-loop glitch found by joooda
#   Now you can config where the targetting arrow is (long overdue).
#   Repaired some CTBs 'non-existant' moved values - found by bojox3m.
#   System cleanup.  Condensed a number of existing routines.  Made new ones.
#   Added Flatrate HP feature to the 'low health' checker. A Boo Mansion request.
#   Battlers can seem to be attacked from behind with the 'Advantages!' system.
#   Added 'STRUCK by...' poses. Indiv. poses based how you're attacked Kaze950)!
#   Fixed the DEFAULT_ACTOR_ID collapse bug. RTP battlers die collapse style!
#   Repaired a bug in the 'Casting Pose' routine for ParaDog's Spell Delay.
#   Reduced the number of instance variables & set up as 'locals'.
#   Repaired a 'Variable Frames per Pose' glitch found by Mimi-Chan.
#   Better handling of 'same pose' attack pausing.
#   New overlap offset routine.  Overlap now based on individual battler sizes
#   Minor:  Renamed the 'Final Fantasy Stepping' values in the config section.
#   Stationary Skill system stopped working on transtion.  Fixed by Charlie Fleed
#   Similiar Stationary Item system also repaired.
#   Restructure:  Broke down the Action Animation section for easier editing.
#   Added 'Random' attack poses into the configuration, returns a lost feature.
#   Better handling of changed battlers.  Still quirky, but much better.
#   Enhanced screentone/battler features with new screentone switches for Jacen.
#   An oversight of Stationary Weapons/Skills/Items handled.
#   An oversight in the Random Melee Attack system discovered by Delmaschio.
#   Another oversight in Random Melee Attacks found and corrected.
#   Repaired a glitch with the Actor/Enemy offset system.
#   Tweaked the battler fade-in system
#   Decreased the sprite system size.   Made it more modular.
#   Long overdue, enemy battlers now have a winning 'loopable' victory pose.
#   Finally solved the frozen target bug I've been trying to squash for months.
#   Fixed a combined RTP/Spritesheet fadeout color problem.
#   Fixed a 'die before being hit' bug
#   Rewrote the 'offset' system to consider individual battler sizes
#   Removed the built-in formation system.
#   Added autodetect compatability with Charlie Fleed's Select-All system.
#   Added custom 'Charge based on Skill' feature.
#   Added custom 'Charge based on Item' feature.
#   Added custom 'Charge based on Weapon' feature.
#   Added new Jumping feature, jump flag also governs the height of the jump.
#   Rather than use a patch, JUMPING SKILL/WEAPON and ITEM arrays built-in.
#   Application for optional Dodge pose as suggested by Jaberwocky added.
#   Added JUMPING ability to enemies... they were left out before.
#   Added Casting Pose capability for Charlie Fleed's CTB.
#   Moved the 'Defend' state to fix a loss-of-defend-stance bug found by Boomy.
#   Added compatability with Ccoa's Spritestrip system as requested by Yin.
#   Found & fixed compatability issue with Trickster's Timer Battle System Base.
#   Added Casting Pose and individual skill poses for Trickster Timer Systems.
#   Added a system to use the initial battler if a ccoa battler file is missing.
#
#   128 counted
#==============================================================================
