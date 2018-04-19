#==============================================================================
#
#      HERETIC's CATERPILLAR SCRIPT [XP]
#      Version 2.0
#      Sunday, April 19th, 2015
#
#   Old Save Games from Old Versions will NOT be compatible!
#   Start a New Game!  :(
#
#   Note:  Numeric Versions cause old versions to not work due to the creation
#   of new variables (new features) being expected but never initialized.  These
#   variables are created when you fire up a new game, but since they dont exist
#   in older version save games, it may cause your game to crash.  When I dont
#   create any of these new variables, I have been using lettering increments.
#   So old save games from versions A to B are still compatible.
#
#   Multiple Message Windows by Wachunga should be ABOVE this script!
#
#   Pathfind by ForeverZer0 should be ABOVE this script!
#
#   This script fully redefines several major engine methods and should be
#   reasonably close to Main.  Other scripts that Alias the methods that
#   have been redefined are fine to but below.
#
#==============================================================================
#
#  Note - If you were using Version 1.98, old Save Games will no longer work.
#
#  Version 2.0 - Monday, November 10th, 2014 
#
#  This is a MAJOR update.  Use this version or above if you need compatability
#  with Heretic's Modular Passable Script.  Savegames from version 1.99.5 are
#  compatible with this version.
#
#  Updated for compatability with another script.  New Script is called 
#  Heretics Modular Passable.  It allows another new script for Diagonal Stairs
#  to work just fine with this one, but is not required unless Diagonal Stairs
#  is used. This version wont cause any crashes or compatability issues with
#  the previous version.  Some methods were moved around in order to maintain
#  proper Class Structures.
#
#  A total overhaul of this script is necessary and on my To Do list.  It was
#  one of my very first projects when I started scripting and has terrible
#  structure and documentation, the code is messy, but very functional.  It
#  is quite difficult to read, even by my standards, which are now much higher
#  as I have much more experience.
#
#  - Added orient_cat_to_player : Turns to Player Direction on last movement
#  - Changed fade_cat_to_player(opacity, duration, fade_player = true) which
#    now allows fading in or out the Caterpillar without affecting the Player.
#  - Added cat_fade_event, Fade Caterpillar and keep Player
#  - cat_fade_event(opacity, duration, player = true[default] / false)
#
#  ===== VEHICLE BOARDING  =====
#
#  I have completed a Vehicles script, which you'll definitely want to use
#  the new cat_fade_event(opacity, duration, player = false) when boarding
#  or disembarking from a Vehicle, either Boat or Magic Carpet, or other
#  stuff that other people come up with.
#
#  -----  MODULAR PASSABLE  ------
#
#  Modular Passable is basically an SDK for the Passable? methods.  The SDK
#  did not do anything with either of these methods, and the original method
#  was horribly written.  Modular Passable is a replacement for the normal
#  passable? methods that allows a crapton of things to be done.  Looping Maps
#  is one of the scripts I wrote that needs Modular Passable.  This Caterpillar
#  script has beeh heavily updated to be fully compatible with many of the
#  new Modular Passable scripts, including Diagonal Stairs Deluxe, Dowhill Ice,
#  NPCs on Event Tiles, Restrict Tile Passages, Hotfoot Tiles, Circular Sprite
#  Motion, Rotate and Pendulums, Mirror Movement, and VEHICLES!
#
#  The current version of this Caterpillar has a Framerate Optimizer that I
#  tried really hard to get to work as well as I could with Looping Maps, but
#  it hasn't turned out so well.  Be careful with the number of events you
#  use if you create a Looping Map as it will cause Lag!
#
#  END OF VERSION 2.0 UPDATE NOTES
#
#  ----
#
#
#  Version 1.99.5 - Slight change to Pathfinding Method Definition.  Another
#  method was added to allow calling 'pathfind' from a Move Route Script. I
#  altered both the Pathfinding Script and this script so they would work
#  together and separately as expected.  Bugfix for No SDK.
#  Thursday, September 27th, 2012
#
#  Version 1.99 - fixed a couple of Ladder Related Bugs.  Transferring Maps
#  from a Ladder or to a Ladder was causing unexpected Direction Fixes to not
#  be turned off.  Updated to 1.99 because this script is packaged as is with
#  an Updated Version of the MMW script, which now has more new features!
#  See the MMW script notes.
#
#  Version 1.98b - fixes a minor bug that caused a game crash when an imported
#  tilemap doesnt have a Tile Priority.
#
#  Version 1.98a just adds the ability to put the "Other" Foot Forward
#
#  CORE code came from Zeriab, ver 1.0, but this is so heavily modified
#  I have no choice but to call it my own, excluding Zeriab's code of course
#  which I used as a Base.  I dont think Zeriab supports
#  his original Caterpillar Script any more.
#
#  Heretic's Notes:
#
#  SIDE NOTE:  Since I have added several Naming Options, you should know that
#  you can combine these options in the names.
#  For Example:  "EV003\z_flat\move_route_wait_exclude" will do both
#
#  Please let me know of any bugs on http://www.rmxpunlimited.net or rmrk.net
#
#
#
# ----  FEATURES ----
#
# - Extensive Caterpillar Specific Movement Commands *see commands*
#
# - Doesn't require the SDK
#
# - Built In Frame Rate Optimizer
#
# - Built In Debug Messages - Useful for Troubleshooting
#   * Reports Missing or Duplicate Cat Actors
#   * Reports incorrect usage of a Script
#
# - Built In Bugfixes and Options for Interpreter Related Game Hangs
#
# - Built In Opacity Fading Effects
#
# - Pass Solid Actors allows Player to go thru Cat Actors but not Other NPC's
#
# - Auto Orient To Player makes Cat Actors face Player's Direction on Transfer
#
# - Ladder Effects for Player and Caterpillar.  Events are not affected.
#
# - Non Party "Followers" operate similar to your Cat Actors
#
# - Alternate Character Sprites for Dead Characters in the Caterpillar
#   * Cat Actors Dont Walk when Dead
#   *  or become Ghosts, Zombies, or Coffins, or choose your own PER CHARACTER
#   * Alt Sprites are based on Original Character Sprite.  So if you change
#   *  a Character's Sprite in the middle of the game for whatever reason, your
#   *  New Character Sprite will be replaced with a New Alt Sprit when Dead!
#
# - Z-Index Adjustments and Manual Control.  Allows for Flat Sprites!
#
# - Player and Events allowed to go OFF MAP with special conditions.
#
# - Demo explains many things in great detail
#
# - Compatible with Pathfind by ForeverZer0
# - Pathfind Script included in Demo with ForeverZer0's permission
#   *Note* - Pathfind in Demo is Modified to fix a bug in the Script.
#
# - Compatible with Multiple Message Windows script by Wachunga and Zeriab
#
#   Note - The version of Multiple Message Windows included has been heavily
#          modified.  There are quite a few new features, and bugfixes.  Be
#          advised that at this time, it still requires the SDK and isn't
#          compatible with BlizzABS.  There are versions out there which
#          do not require the SDK and are compatible with BlizzABS, but
#          don't include what changes I have made to it.  I do plan on
#          further revisions eventually.  But for now, since I also do
#          forget to update my notes, just look at the Multiple Message Windows
#          script for versions and changes
#
#
#   -------  FUTURE VERSIONS  -------
#
#   I'll probably start messing a bit with the MMW script to remove the need
#   for the SDK and to make it even more user friendly in order to eliminate
#   the dependancy on Event ID's
#
#
#   Hopefully by Version 2.0, I've taken care of all the bugs, compatability
#   issues, and made the functionality as easy as possible.  I know there are
#   a few things that need to be done, but not sure what they are yet.
#
#   *NOTE* 
#   - Please report any Bugs or Feature Requests to me on chaos-project.com or
#     RMRK.net
#
#
#       ------------   EASY SETUP  -----------
#
#  ***  SWITCHES MUST BE TURNED ON FOR ACTORS TO FOLLOW YOU ***
#
#  Make some Events and Name them something like "Larry\cat_actor[2]"
#
#  In that example "\cat_actor[2]" without the quotes needs to be there.
#  This will tell the script that this Event is a Cat Actor for Actor 2
#  In your Database, under the Actors Tab (the one on the left), use
#  those numbers in place of 2 for EACH PARTY MEMBER
#
#  Now, we need to turn on some SWITCHES!
#
#  In some sort of an Event, turn SWITCH 23 on (you can change that number)
#  and that Cat Actor should now follow you around.
#
#  When you turn on SWITCH 23, all of your CAT ACTORS will TELEPORT to your
#  position.  THIS IS NORMAL.  If you do NOT want this to happen, turn on
#  SWITCH 22 (again, default) to PAUSE the Caterpillar, then ADD your Actor
#  then UNPAUSE (turn SWITCH 22 OFF) the Caterpillar.  They become part of the
#  (Cat)erpillar that will follow you around, but if you add them while the
#  Pause Switch (22 by default, feel free to change to whatever) is turned on
#  then they wont snap to your location.
#
#  By the way, dont loop turning on SWITCH or GAME SWITCH 23 with the event.
#  Once the Switch is on, tell the Event to Stop Running!
#  Exit Event Processing, Erase Event, and Page 2 Self Switch A all work to
#  stop an Autorun or Parallel Event from continuing to run.  The differences
#  are greater than the scope of this Easy Setup Guide allows.
#
#  The SWITCH LABELS are empty by default, and names dont interfere with the
#  script.  I do suggest labeling those Switches so you can easily recognize
#  which Switch does what.
#
#
#  -----------  GAME SWITCHES  ----------
#
#  SWITCH 21 = LADDER EFFECTS - Player Only!  Doesnt affect other Events...
#  SWITCH 22 = CATERPILLAR PAUSE - Prevents Cat Actors from Snapping to Player
#  SWITCH 23 = CATERPILLAR ACTIVE - Turned off, Cat Actors dont follow Player
#      Turned On - They DO follow the Player
#      I recommend turning it on BEFORE adding Actors, and LEAVING IT ON
#      and use the PAUSE SWITCH to turn off Caterpillar Effects
#
#      *Note* - Recommend NOT changing maps with CATERPILLAR_PAUSE turned ON
#
#  SWITCH 24 = DEAD EFFECTS - Optional.  More of an Enhancement than Functional
#  SWITCH 25 = REMOVE_VISIBLE_ACTORS - Optional
#
#
#
#  --- EASY SETUP (Troubleshooting) ---
#
#
#  
#  YOUR GAME CRASHES AT STARTUP - New Versions of the Script wont be compatible
#   with old save games.  My fault.  Mostly lack of experience.
#
#  YOUR GAME WILL CRASH AT STARTUP if you are using DEAD EFFECTS and have NOT
#  Imported the Dead Effect Graphics (Zombie and Coffin) into your Game!
#  *See Demo for Graphics*
#
#  YOUR GAME CRASHES WHEN RUNNING A SCRIPT
#
#  You're probably calling the Script from the Wrong Script Window!
#  There are SEVERAL places to run a Script.
#  - Event Editor => Script...
#  - Event Editor => Set Move Route => Script... (Player)
#  - Event Editor => Set Move Route => Script... (Event)
#  - *Note* Player and Event in the Drop Down menu are DIFFERENT!
#
#  I tried really hard to prevent crashes and advise when a script is called
#  from the wrong window.  It can get confusing because there are quite a few
#  places to call them from.  If you find any that I missed, please let me know!
#
#  Since the Dead Effects and Ladder Effects Options are, well, Optional
#   you can Disable these Effects or just dont use them.
#
#
#  --- EASY SETUP (Recommendations) ---
#
#  Once you get the hang of setting up your Cat Actors by Naming them
#  with "Name\cat_actor[int]", and you have your Party, you'll probably
#  want to build yourself a TEMPLATE MAP.  This is especially important
#  if you want to use the Multiple Message Windows script.  This is
#  because MMW (or Multiple Message Windows) is ID SPECIFIC.
#
#  Create a Map, and name EVENT ID #1 to "Name\cat_actor[1] and
#  EVENT ID #2 to "Name\cat_actor[2]" and so on.  Do this for
#  each Actor in your Party.  Maybe even add a few extras.
#  One Event on Each Map for Every Actor in your Party on Every Map
#  
#  When you want to create a New Map, simply COPY AND PASTE YOUR TEMPLATE MAP
#
#  This saves you the extra work and frustrations from Missing Cat Actors and
#  Duplicate Cat Actors.
#  
#
#
#
#
#
#*****************************************
#********                       **********
#********    SCRIPT COMMANDS    **********
#********                       **********
#*****************************************
#
#  ---- Global Variables -----
#
#  Global Variables start with a Dollar Sign $variable
#  Change Variables by running a script $variable = true
#  Any Script Window allows for changing $variables
#
#  ** NOTE ** - Variables RESET when Loading a Save Game!
#
#  $walk_off_map
#    - Allows the Player and Cat Actors to move Off Map
#
#  $frame_optimizer - 
#    - Use for Debugging scenes if Events aren't moving when
#      you think they should be
#
#  ** NOTE ** - Variables RESET when Loading a Save Game!
#
#
# ---- Script Commands ----
#
# Run these from the ** Script Window
#
# - cat_backup(delay Optional, pushback Optional true or false) 
#   *  Moves Caterpillar Backwards
#   ** Call from Event Editor => Scripts
#
# - cat_speed(new_speed) 
#   *  Prevents Lag in Speed Changes
#   ** Call from Event Editor => Scripts
#
# - turn_cat(direction, Optional Delay)
#   *  Example: turn_cat('up', 3)
#   *  Makes Cat Actors turn a Direction
#   *  doesnt affect Player
#   ** Call from Event Editor => Scripts or 
#                Event Editor => Set Move Route (Player) => Scripts
#
# - orient_to_player 
#   *  Makes Cat Actors face same direction as Player
#   ** Call from Event Editor => Scripts
#
# - cat_forward
#   *  Forces Player to take One Step Forward for each Actor in the Caterpillar
#   *  ONLY AFFECTS PLAYER
#   ** Skippable if Unable to Move
#   ** Call from either Player Move Route => Scripts or Event Editor => Scripts
#
# - cat_generate_moves
#   *  Generates the Move List in case you cleared it for some reason
#   ** Call from Event Editor => Scripts
#
# - cat_stagger(direction, [offset=0])
#   *  Unstacks the Caterpillar in specified direction
#   ** Direction can be 2,4,6,8 or 'up','down','left', or 'right'
#   ** Offset to push Caterpillar back X number of tiles
#
# - get_opposite_direction
#   *  Returns direction opposite that character is facing
#   ** Useful when used with cat_stagger(get_opposite_direction)
#
#
# === Begin Turn Commands ===
#
# *Note:   Target the Player with 0 inwith the following Turn and Move commands
# *Note 2: Call from Event Editor => Set Move Route => Scripts
#
# - turn_toward_event(event_id) - Turns Character toward another Event
# - turn_away_from_event(event_id) - Turns Characteraway from another Event
# - move_toward_event(event_id) - Moves Charactertoward another Event
# - move_away_from_event(event_id) - Moves Characteraway from another Event
#
# *Note 3: Call these from Event Editor => Scripts, 
#          or Event Editor => Set Move Route (Player) => Scripts
#
# - turn_cat_toward_event(event_id, repeat Optional true or false, delay)
#   *  Turns Cat Actors toward another Event
#   *  doesn't affect Player
#   *  use an event_id, or 0 to target Player
#   *  delay is an optional wait before turning, cant use with repeat
#   *  Repeat is Optional, just plug in TRUE or FALSE
#
# - turn_cat_away_from_event(event_id, repeat Optional true or false)
#   *  See turn_cat_toward_event
#
# === End Turn Commands ===
#
# 
# - cat_to_player
#   *  Calls all Cat Actors to Stack up on the Players location
#   *  Works with "Wait for Move's Completion"
#   ** Call from Event Editor => Scripts
#
# - fade_cat_to_player(opacity, duration) 
#   *  Auto Fades Back In - See Examples in Demo
#   *  Works with "Wait for Move's Completion"
#   *  "Wait for Move's Completion" only waits for Movement, not Opacity.
#   *  Opacity needs a Number.  99% of the time just use 0 to fade out
#   ** Call from Event Editor => Scripts
#
# - cat_fade_out_per_step(duration, optional auto_fade_back_in)
#   *  Fades out Player and Cat Actors on each Sequential Step
#   *  Auto Fade Back In will Auto Fade all Actors back in with same Duration
#   ** Call from Event Editor => Scripts
#
# - cat_fade_in_per_step(duration)
#   *  Duration to fade back to previous Opacity or Ghost if Dead
#   *  Use when the Party is Faded Out
#   ** Call from Event Editor => Scripts
#
# - move_route_wait_exclude
#   *  Use for Events that cause Hangs or Unwanted Pauses
#   *  "Wait for Move's Completion" will Skip this event
#   *  Resets next time Map is Loaded
#   ** Call from Event Editor => Set Move Route (Event) => Scripts
#
# - move_route_wait_include 
#   *  Normal State - "Wait for Move's Completion" will wait for this event
#   ** Call from Event Editor => Set Move Route (Event) => Scripts
#
# - clear_cat_force_move_routes
#   *  Setting a Cat Actor with Repeating Move Route makes them not follow you.
#   *  Running this Script will fix that
#   ** Call from Event Editor => Scripts
#
# - delete_last_move
#   *  Erases the very last step a player had taken
#   ** Call from Event Editor => Scripts
#   
# - move_pop
#   *  Erases a move from the end of the move list
#   *  Useful when swapping Actors
#   ** Call from Event Editor => Scripts
#  
# - clear_moves
#   *  Clears all Caterpillar Movements 
#   ** Call from Event Editor => Scripts
#
# - pass_actors_on_ladders(true or false)
#   *  Allows you to Pass your Caterpillar Actors on Ladders
#   ** Call from Event Editor => Scripts
#
# - set_ladder_speed(int)
#   *  Movement Speed Changes on Ladders.  Change that speed with this.
#   ** Call from Event Editor => Scripts
#
# - foot_forward_on(optional 0 or 1)
#   *  Changes Actor to a Stepping Graphic
#   ** Call from Event Editor => Set Move Route => Scripts
#   ** option (1) arg to use the "Other" foot forward foot_forward_on(1)
#
#
#   *NOTE* - foot_forward_on requires the following conditions for each event:
#   - Direction Fix = OFF
#   - Move Animation = ON
#   - Step Animation = OFF
#   The above settings are Default for when new Events are created.
#
# - foot_forward_off
#   *  Resets Actor Graphic so they dont look like they are Stepping when still
#   ** Call from Event Editor => Set Move Route => Scripts
#   *NOTE* - Same requirements as foot_forward_on
#
# - add_follower(id)
#   *  Adds a Non Party "Follower" to your Caterpillar
#   ** Call from Event Editor => Set Move Route => Scripts
#
# - remove_follower(id)
#   *  Removes a Non Party "Follower" to your Caterpillar
#   ** Call from Event Editor => Set Move Route => Scripts
#
# - following?(follower_id)
#   *  Returns True or False if a Cat Follower is currently Following
#   ** Call from Event Editor => Conditional Branch => Scripts
#
# === Z-Index Commands ===
#
# - set_z(int)     - Specifies a new Z-Index
# - set_sub_z(int) - Specifies a new Negative Z-Indes - Under Tiles Only!
# - reset_z        - Resets Z-Index to NAMING PARAMETER
# - clear_z        - Gets rid of all Z-Index Adjustments
# - set_flat       - Forces a Sprite to render as Flat on the Ground
#
# *NOTE* - See Demo for full explanation and Demonstration
#
# ====Fade Commands ===
#
# *NOTE* - Call these from Event Editor => Set Move Route => Scripts
#
# fade_event(opacity, duration)
# *  Fades an Event to the Opacity (0 - 255) over Duration (Number of Frames)
# ** Call ONLY from Event Editor => Set Move Route = Scripts
#
#
#*****************************************
#********                       **********
#********  END SCRIPT COMMANDS  **********
#********                       **********
#*****************************************
#
# ====== NAMING PARAMETERS ======
#
# Change the Name of an Event to include One or Several of the Following
#
# \cat_actor[int]          - REQUIRED BY CATERPILLAR for Cat Actors!
#                            "int" is the Actor's ID in the Database.
#
# \off_map                 - Lets an Event go OFF MAP, not just
#                            Off Screen, when THROUGH is also Enabled
#
# \al_update               - Anti-Lag Update - Events with this Always Update.
#                            Autorun and Parallel dont need this.
#
# \move_route_wait_exclude - Use for Events that cause Hangs 
#
# \z_flat                  - Forces a Sprite to render as Flat on the Ground
#
# \z_add[int] - Adjusts a Sprite's Z-Index by this Value.  Try multiples of 32
#
# \z_sub[int] - Allows for Sprites under Tilesets
# 
# 
#
# ---- METHODS ----
#
# *NOTE* - Call from Event Editor => Conditional Branch => Script (on page 4)
#
# is_using_ladder?
# - Returns True or False if a Cat Actor is on a Ladder or Not
#
# party_using_ladder?
# - Returns True if anyone in the Party is on a Ladder
#
# cat_position_filled?(n)
# - Returns True if an Actor is in a Position 
#
# $game_player.last_moved_direction 
# - Last Direction Player was told to move, regardless of Direction Fix
#
# *NOTE* - Try printing stuff by using print
#          print "Hello World!" or
#          print $game_player.last_moved_direction
#          Also try adding "inspect" to things for more information with
#          print self.inspect in ANY script window!  You can script too!
#
#
#
###########################
#                         #    
#     Version History     #
#                         #
###########################
#
# --- Version 1.85 through Version 1.97 ---
#
# - Fixed a ton of Bugs and added a bunch of Features and Commands
#   (I thought that was funny, but yeah, thats basically what I did)
#
# --- End of Version History ---
#
#  ---  EVENT FADING ---
#
#  Now Events can Fade In and Out!
#
#  - Pretty easy.  Run a Script from the Event Editor Window
#  - Just put in "fade_event(opacity, duration)"
#  - Opacity is a Range from 0 to 255
#  - Duration is How Many Frames to take to get to that Opacity
#  - Example: fade_event(128,20) will fade to Half Opaque in One Second
#  - fade_event(0,40) will make an Event go Invisible in Two Seconds
#  - fade_event(255,10) will make an Event appear Solid in Half a Second
#  - RMXP Uses 20 Frames Per Second.
#
#  Additional Features:
#
#  Because there are TWO places you can enter Scripts, I tried to set up
#   a couple of Error Messages (optional) in case you call a Script
#   from the wrong window.  I also shortened up the names of Script Commands
#   so you dont have to put $game_thing.foo_bar.script, all you have to do
#   is just run "script_name" from the Script window.  Excluding
#   the extra characters there...
#
#=====================  CONFIG SECTION  =======================================

class Game_Caterpillar
  
  
  #   ---          YOU CAN EDIT STUFF HERE            ----
  
  
  
  # Variables

  $walk_off_map = false              
  
  # Allows Player to walk outside the Map!  
  # Player and Active Cat Actors ONLY! 
  # For other Events, name them \off_map
  # and check Through!
                                     
  $frame_optimizer = true            
  
  # Improves Framerate from too many events!  
  # Based on code from Near Fantastica with improvements and compatability
  # If your map has a lot of events on it, those events can cause serious lag
  # by constantly updating, which is a resource intensive process
  # The Framerate Optimizer works by not updating events that are too far
  # off the screen.  I tweaked it so that the largest available default
  # Character will update correctly instead of leaving graphical artifacts.
  # Add "\al_update" to an events name so it Always Updates: "EV001\al_update"
  # Note - Events that are moved by using any Set Move Route Event calls are
  # also always updated, so they can be set to walk on screen from off screen.
  
  
  
  #---  SWITCHES  ---
  
  # You can change the Numbers to match what ever Game Switch you want...
  
  CATERPILLAR_PAUSE_SWITCH = 22      # Use for Cutscenes
  CATERPILLAR_ACTIVE_SWITCH = 23     # Caterpillar is ON or OFF
  DEAD_ACTOR_EFFECTS = 24            # Only works with Caterpillar ON
  LADDER_EFFECTS = 21                # Game Switch Number for Slowing Movement

  # CONSTANTS - Keep the Same Throughout your Game
  PASS_SOLID_ACTORS = true           # Player can walk thru Cat Actors
  AUTO_ORIENT_TO_PLAYER = true       # Match Player Direction on Transfer
  REMOVE_VISIBLE_ACTORS = 25         # Number for Game Switch or true / false
  
  DISPLAY_DEVELOPER_ERRORS = true    # Shows Error Messages without Crashing
  
  CAT_GRAPHICS_DONT_CHANGE = true    # Applies ONLY to Event Page Graphics

  CAT_SCREEN_X = 640                 # Size of the Screen Horizontally
  CAT_SCREEN_Y = 480                 # Size of the Screen Vertically
  CAT_OFFSCREEN_DIST = 2             # Offscreen Distance in Tiles for Update

  # Ladder Stuff
  LADDER_TAG = 7                      # Set in Database, Tilesets, Terrain Tag
  LADDER_MOVE_SPEED = 3               # Movement Speed while on Ladders
  PASS_ACTORS_ON_LADDERS = false      # Walk thru Cat Actors on Ladders  
  
  # Array - Pick Any and separate with a Comma, 
  #         ['GHOST','DONT_WALK','ZOMBIE','COFFIN','ALTERNATE']
  
  # Available Options - DONT_WALK, GHOST, and ZOMBIE and ALT_SPRITE.
  # DO NOT USE GHOST and ZOMBIE together, they conflict!

  #--- THESE ARE EXAMPLES! PICK ONE OR MAKE YOUR OWN!  ----
  
  #DEAD_EFFECT = []                    # Example of how to Disable all effects
  DEAD_EFFECT = ['GHOST']              # Example of Ghost
  #DEAD_EFFECT = ['GHOST','DONT_WALK'] # Example of Two Effects
  #DEAD_EFFECT = ['DONT_WALK']         # Example of these two effects  
  #DEAD_EFFECT = ['ZOMBIE']            # Dont Combine Zombie and Coffin
  #DEAD_EFFECT = ['COFFIN']            # Dont Combine Zombie and Coffin
  #DEAD_EFFECT = ['ALT_SPRITE']        # Dont Combine with Zombie or Coffin

  # --- DONT DISABLE THESE, EVEN IF YOU DONT USE THE OPTIONS ----
  
  # Need These Variables...
  DEAD_GHOST_OPACITY = 140          # Opacity of Ghost Characters
  DEAD_GHOST_DURATION = 30          # Number of Frames to Transition to Ghost

  # ZOMBIE SETUP  

  #ZOMBIE_GRAPHIC = "" # Comment out the line below with # for NO Graphics
  ZOMBIE_GRAPHIC = "DeadCharacter.png" # Needed inMaterials/Characters Databse!
  ZOMBIE_OPACITY = 255  # You can make this Graphic as Transparent as you want
  ZOMBIE_DURATION = 20  # Time it takes to "dissolve" into a Zombie

  # COFFIN SETUP
  
  #COFFIN_GRAPHIC = "" # Comment out the line below with # for NO Graphics
  COFFIN_GRAPHIC = "JBCoffin.png"  # Change this line to your filename
  COFFIN_OPACITY = 255  # You can make this Graphic as Transparent as you want
  COFFIN_DURATION = 25  # Time it takes to "dissolve" into a Coffin
  
  # ALT SPRITE SETUP
  
  #ALT_SPRITE_GRAPHIC = "" # Comment out the line below with # for NO Graphics
  ALT_SPRITE_OPACITY = 255  # Make this Graphic as Transparent as you want
  ALT_SPRITE_DURATION = 30  # Time it takes to "dissolve" into a Coffin

  #  V V V  ----  YOU CAN EDIT THIS BELOW!  -----  V V V  
  
  def get_alt_sprite_graphic(sprite) # Dont change this line!
    
    # First Character Graphic
    if sprite == '001-Fighter01'
      # First Character Alt Graphic
      return '001-Fighter01Alt'
      
    # Second Character Graphic
    elsif sprite == '010-Lancer02'
      # Second Character Alt Graphic
      return '010-Lancer02Alt'
      
    # Third Character Graphic
    elsif sprite == '013-Warrior01'
      # Third Character Alt Graphic
      return '013-Warrior01Alt'
      
    # 4th Character Graphic
    elsif sprite == '019-Thief04'
      # 4th Charcter Alt Graphic
      return '019-Thief04Alt'
      
    # 5th Charcter Graphic      
    elsif sprite == '022-Hunter03'
      # 5th Charcter Alt Graphic      
      return '022-Hunter03Alt'
      
    # 6th Charcter Graphic
    elsif sprite == '023-Gunner01'
      # 6th Charcter Alt Graphic
      return '023-Gunner01Alt'
      
    # 7th Charcter Graphic      
    elsif sprite == '029-Cleric05'
      # 7th Charcter Alt Graphic
      return '029-Cleric05Alt'
      
    # 8th Charcter Graphic
    elsif sprite == '038-Mage06'
      # 8th Charcter Alt Graphic
      return '038-Mage06Alt'
      
    elsif sprite == ""
      # Return same as argument passed
      return ""
      
    else                                     # Dont change this line!
      if $DEBUG and DISPLAY_DEVELOPER_ERRORS # Dont change this line!
        # Comment out lines with the # character
        # Provide Informational Warning
        print "Warning!  No Alt Sprite for ", sprite
      end                                # Dont change this line!
      # Just return the Original to prevent Invisible Characters
      return sprite                      # Dont change this line!
    end                                  # Dont change this line!
  end                                    # Dont change this line!
  
  # NOTES FOR ABOVE:
  #  1:  If you use ALT SPRITES, an ALT SPRITE FOR EVERY ACTOR HAS TO EXIST!
  #        Those files MUST be in "Materialbase => Graphics/Characters"
  #        It is the Button at the top that says Materials.
  #  2:  I know you may not be Scripters, but those are the names for the
  #       characters in the Database.  Just edit those Names to suit your needs.
  #  3:  You dont have to follow my naming method.  I just put Alt at the end.
  #  4:  You dont have to use my Sprites.  I suck at spriting.  They are just
  #       quick and dirty versions of the same sprite.  But if you wanted to
  #       have "Bloody Versions" or something of the same sprite, maybe an angel
  #       with wings and a Halo, you can!  Whatever sprite you set up to use as
  #       an alternate is up to your creativity, or ability to find sprites on
  #       Google...  Just make sure the script here matches whatever you name
  #       your sprite in the Materialbase.
  
  
  
  
  # -----    YOU PROBABLY SHOULDNT EDIT STUFF BELOW HERE!   --------  

  #--------------------------------------------------------------------------
  # * Public Instance Variables - Game_Caterpillar
  #--------------------------------------------------------------------------
  attr_accessor :actors                     # Array to hold Caterpillar
  attr_accessor :actor_id_to_event          # Actor ID of Caterpillar Actor
  attr_accessor :walk_reset_array           # Dead Dont Walk
  attr_accessor :cat_steps                  # Number of Steps for Z-Index
  attr_accessor :actors_fade_out            # Fades Out Caterpillar
  attr_accessor :actors_fade_in             # Fades In Caterpillar
  attr_accessor :cat_graphics_dont_change   # Keeps Graphic when Pages Change
  attr_accessor :pass_actors_on_ladders     # Player Passes Actors on Ladder
  attr_accessor :ladder_move_speed          # Move Speed when on a Ladder
  attr_accessor :ladder_events              # Events with Ladder Graphics
  attr_accessor :transferring_actors        # Keeps Follower Graphics
  attr_accessor :follower                   # If Followers in Caterpillar
  attr_accessor :follower_ids               # Event ID of Follower
  attr_accessor :follower_events            # Array of Follower Events
  attr_accessor :followers                  # Non Party Caterpillar Actor
  attr_accessor :actors_fade_out            # Caterpillar Transition Out
  attr_accessor :actors_fade_in             # Caterpillar Transition In
  attr_accessor :fade_back_in               # Caterpillar Transition Reset
  attr_accessor :cat_player_transferring    # Used in Auto Orient on Map Change
  #----------------------------------------------------------------------------
  # * Initialize - Game_Caterpillar
  #----------------------------------------------------------------------------
  def initialize
    @actors = []
    @actor_id_to_event = {}
    @move_list = []
    @walk_reset_array = []
    @ladder_events = []
    @cat_steps = 0
    @transferring_actors = []
    @actors_fade_out = false
    @actors_fade_in = false
    @fade_back_in = false
    @cat_player_transferring = nil
    @cat_graphics_dont_change = CAT_GRAPHICS_DONT_CHANGE
    @pass_actors_on_ladders = PASS_ACTORS_ON_LADDERS
    @ladder_move_speed = LADDER_MOVE_SPEED
    @follower = false
    @follower_ids = []
    @follower_templates = []
    @follower_events = []
    @followers = []
  end
  #----------------------------------------------------------------------------
  # * Clear - Game_Caterpillar
  #  - Clear the Caterpillar data
  #----------------------------------------------------------------------------
  def clear
    @actors.clear
    @followers.clear
    @actor_id_to_event.clear
    @move_list.clear
  end
  #----------------------------------------------------------------------------
  # * Clear Moves - Game_Caterpillar
  #  - Empties the Array of Moves for each Caterpillar Actor and Followers
  #----------------------------------------------------------------------------
  def clear_moves
    @move_list.clear
  end
  #----------------------------------------------------------------------------
  # * Del Last Move - Game_Caterpillar
  #  - Deletes Players Last Recorded Movement for Caterpillar before execution
  #  - Called by Interpreter Script "delete_last_move"
  #----------------------------------------------------------------------------
  def del_last_move
    @move_list.delete_at(0)
  end
  #----------------------------------------------------------------------------
  # * Move Pop - Game_Caterpillar
  #  - Remove the Last Move Event off of @move_list Array
  #  - Useful when Swapping Caterpillar Actors in Last Position of Caterpillar
  #----------------------------------------------------------------------------
  def move_pop
    @move_list.pop
  end
  #----------------------------------------------------------------------------
  # * Clear Actor Force Move Route - Game_Caterpillar
  #  - Use this to Reset a Single Cat Actor's Forced Move Route
  #      actor : event
  #----------------------------------------------------------------------------
  def clear_actor_force_move_route(actor)
    # Save original move route
    if actor.original_move_route == nil
      actor.original_move_route = actor.move_route
      actor.original_move_route_index = actor.move_route_index
    end         
    # Check for existence of Move List
    if not actor.move_list.nil?
      # Clears this Actors Move List
      actor.move_list.clear
    end      
    # Clears this Actor from Move Route Forcing
    actor.move_route_forcing = false
    # Reset Actors Move Index to 0
    actor.move_route_index = 0
  end
  #----------------------------------------------------------------------------
  # * Clear Cat Force Move Routes - Game_Caterpillar
  #  - Clears Repeating Move Routes
  #----------------------------------------------------------------------------
  def clear_cat_force_move_routes
    for actor in @actors
      # Save original move route
      if actor.original_move_route == nil
        actor.original_move_route = actor.move_route
        actor.original_move_route_index = actor.move_route_index
      end      
      # move_list might not be defined, prevent crash when trying to clear
      if not actor.move_list.nil?
        # Clear the Move List      
        actor.move_list.clear
      end
      # Turn Off move_route_forcing
      actor.move_route_forcing = false
      # Reset the Index to 0
      actor.move_route_index = 0
    end
  end
  #----------------------------------------------------------------------------
  # * Turn Cat - Game_Caterpillar
  #  - Turns Caterpillar except Player to Direction
  #      d     : direction - up, down, left, right or 2, 4, 6, 8
  #      delay : delay between each Actor's Turn
  #----------------------------------------------------------------------------
  def turn_cat(d, delay = nil)
    # Set Direction to Lower Case if Direction is a String
    d.downcase! if d.is_a?(String)
    # If not a Valid Turn Direction
    if not ["down","left","right","up",2,4,6,8].include?(d)
      # If Display Developer ERrors
      if $DEBUG and DISPLAY_DEVELOPER_ERRORS
        print "Warning: Error in turn_cat(direction)", 
              "\n\n\"", d, "\" is not a Valid Direction\n\n",
              "'down','left','right','up', or 2, 4, 6, 8 are Valid Directions",
              "\n\n(*Note* don't use Quotes on Numbers)"
      end
      # Prevent execution due to Invalid Direction      
      return
    end
    # Change Strings to Numeric
    d = (d=="down" ? 2 : d=="left" ? 4 : d=="right" ? 6 : d=="up" ? 8 : d)
    # If a Optional Delay Argument is set
    if delay.is_a?(Numeric)
      # Apply to each Caterpillar Actor and Follower, except Player
      for i in 0...@actors.size
        # Invalidate unless the Direction is Valid
        valid = false
        # Actor variable
        actor = @actors[i]
        # Create a New Move Route
        route = RPG::MoveRoute.new
        route.repeat = false
        route.skippable = false
        # Move Command Codes : 16 - down, 17 -  left, 18 - right, 19 - up
        code = (d == 2 ? 16 : d == 4 ? 17 : d == 6 ? 18 : d == 8 ? 19 : 0)
        # Put the MoveCommand on to the Move Route
        route.list.unshift(RPG::MoveCommand.new(code, []))
        # Valid if Command Code is not 0
        valid = true if code > 0
        # Push on a Wait Command (Code 15) on to the Move Route for Delaying
        route.list.unshift(RPG::MoveCommand.new(15, [(i + 1) * delay]))
        # Force the Move Route to the Cat Actor IF it was a Valid Direction
        actor.force_move_route(route) if valid
      end
    # No Delay
    else
      # Apply Direction to Caterpillar, except Player
      for actor in @actors
        actor.direction = d if not actor.direction_fix
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Set Ladder Speed - Game_Caterpillar
  #  - Set the Move Speed on Ladders
  #      new_speed : movement speed
  #----------------------------------------------------------------------------
  def set_ladder_speed(new_speed)
    @ladder_move_speed = new_speed if new_speed.is_a?(Numeric)
  end
  #----------------------------------------------------------------------------
  # * In Move List? - Game_Caterpillar
  #  - Returns true if new coordinates are in the Caterpillar Move List
  #----------------------------------------------------------------------------
  def in_move_list?(x, y, d, new_x = nil, new_y = nil)
    # Check for Nils
    return unless x and y and d
    # If new coordinates already determined
    unless new_x and new_y
      # Get new coordinates
      new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
      new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    end
    # For each Caterpillar Movement
    for i in 0...@move_list.size
      # If the Target Coordinates are included in move_list
      if @move_list[i][1][2][0] == new_x and @move_list[i][1][2][1] == new_y
        # New Coordinates are in the Move List
        return true
      end
    end
    # Return false since it is not found in the @move_list
    return false
  end
  # If Heretic's Loop Maps is installed
  if Game_Map.method_defined?(:map_loop_passable?)
  #----------------------------------------------------------------------------
  # * In Move List? - Game_Caterpillar
  #  - Returns true if new coordinates are in the Caterpillar Move List
  #----------------------------------------------------------------------------
  def in_move_list?(x, y, d, new_x = nil, new_y = nil)
    # Check for Nils
    return unless x and y and d
    # If new coordinates already determined
    unless new_x and new_y
      # Get new coordinates
      new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
      new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
      # Round to Looping Maps
      new_x %= $game_map.width if $game_map.loop_horizontal?
      new_y %= $game_map.height if $game_map.loop_vertical?
    end
    # For each Caterpillar Movement
    for i in 0...@move_list.size
      # If the Target Coordinates are included in move_list
      if @move_list[i][1][2][0] == new_x and @move_list[i][1][2][1] == new_y
        # New Coordinates are in the Move List
        return true
      end
    end
    # Return false since it is not found in the @move_list
    return false
  end    
  end # End Loop Map Definition
  #----------------------------------------------------------------------------
  # * Check Missing - Game_Caterpillar
  #  - Checks Caterpillar for missing Map Events
  #----------------------------------------------------------------------------
  def check_missing
    # Check each Actor except for the Player
    for i in 1...$game_party.actors.size
      # Set Event to its corresponding Actor, regardless of Event ID
      event = @actor_id_to_event[$game_party.actors[i].id]
      # If Event for that Cat Actor Exists
      if not event.nil?
        # If we have set ALL the Cat Actors correctly
        if $check_missing_array.include? $game_party.actors[i].id and 
           $check_missing_array.size == ($game_party.actors.size - 1)
          # Set Value to False
          $check_missing_needs_to_run = false
        else
          # If we havent added that Character to the Array yet
          if not $check_missing_array.include? $game_party.actors[i].id
            # Add Actor so we can exclude them from Error Reporting
            $check_missing_array.push($game_party.actors[i].id)
          end
        end      
      else
        # If playing from the Editor, not Game and DEVELOPER ERRORS are On
        if $DEBUG == true and $missing_error_displayed != true and 
           DISPLAY_DEVELOPER_ERRORS == true and $game_party.actors.size > 1 and
          $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] == true           
          # Provide useful information to the person working on the Map
          print "WARNING: Missing a Cat Actor Event for Character: ",
                $game_party.actors[i].name, " on\n",
                "Map Name: ", $game_map.name, "  Map ID: ", $game_map.map_id
          print "WARNING: To fix this, just create an event and name it",
                " \"Char_Name\\cat_actor[",$game_party.actors[i].id, "]\"",
                "on\n this Map.  Need Actor Events on EVERY MAP that",
                "Character can go."
          $missing_error_displayed = true
        end
        # Resets Flags despite Errors so expect buggy Walk Anime
        $check_missing_needs_to_run = false
      end
    end 
    # If Caterpillar has Followers and no Error Messages yet
    if @follower and $missing_follower_error_displayed != true
      # Check each Follower
      for follower_id in @follower_ids
        follower_found = false
        follower = @follower_events[follower_id]
        # If the Event stored doesnt match the Map Event, Follower is Missing!
        if $game_map.events[follower.id] == @follower_events[follower_id]
          follower_found = true
        end
        if follower_found == false and $DEBUG == true and 
           DISPLAY_DEVELOPER_ERRORS == true
          # Display the Missing a Follower Warning          
          print "Warning: Missing a Follower: Follower #", follower_id, " on\n",
                "Map Name: ", $game_map.name, "  Map ID: ", $game_map.map_id,
                "\n\nTo fix this, just create an event and name it ",
                "\"whatever\\cat_follower[",follower_id, "]\" on\n this Map.",
                "This Event does NOT need to exist on every single Map, only\n",
                "on Maps that you allow this Follower to Follow you"
          $missing_follower_error_displayed = true      
        end
      end
    end
    $check_missing_needs_to_run = false       
  end
  #----------------------------------------------------------------------------
  # * Check Missing Reset - Game_Caterpillar
  #  - Resets on New Maps to Display Errors again
  #----------------------------------------------------------------------------
  def check_missing_reset
    # Reset the Array of Known Actors so they can be re-added per Map
    $check_missing_array.clear if $check_missing_array
    # Causes Check Missing to actually Run
    $check_missing_needs_to_run = true
    # This prevents errors from being displayed multiple times on the same map
    $missing_error_displayed = false
    $missing_follower_error_displayed = false    
  end
  #----------------------------------------------------------------------------
  # * Walk Reset - Game_Caterpillar
  #  - Resets Player and Caterpillar Actors Walk Anime
  #----------------------------------------------------------------------------
  def walk_reset
    # Sets Player Walk to True
    $game_player.walk_anime = true
    # Says we are open for checking again
    $walk_has_been_reset = true
    # Says we need to check for any Dead State to Animation Changes
    $walk_has_been_set = false
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Event is not a Cat Follower
      if not actor.cat_follower
        # Resets each Actor to Original Walk Animation Flags
        actor.walk_anime = actor.last_walk_anime
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Force Walk - Game_Caterpillar
  #  - Forces Walking Animations
  #  - Clears when Caterpillar is changed, moved, refreshed, or teleported
  #----------------------------------------------------------------------------
  def force_walk
    # Sets the Player to have a Walk Animation
    $game_player.walk_anime = true
    # For each of the Caterpillar Actors
    for actor in @actors
      # if Event is Not a Cat Follower
      if not actor.cat_follower
        # Set that Actor's Walk Animation ON regardless of Actor Dead State
        actor.walk_anime = true
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Ghost Reset - Game_Caterpillar
  #  - Resets Ghost to Original Opacity
  #----------------------------------------------------------------------------
  def ghost_reset
    # Reset the Opacity Ghost Flag
    $game_player.opacity_ghost = false    
    # Sets Player Opacity
    $game_player.fade_event_reset(DEAD_GHOST_DURATION)
    # Check Actor Dead Status next step
    $walk_has_been_reset = true
    # Says we need to check for any Dead State to Animation Changes
    $walk_has_been_set = false
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Event is not a Cat Follower
      if not actor.cat_follower      
        # Set Flag that Actor is no longer a Ghost
        actor.opacity_ghost = false
        # Resets each Actor to Original Opacity
        actor.fade_event_reset(DEAD_GHOST_DURATION)
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Force Ghost to Opaque - Game_Caterpillar
  #  - Resets Ghost to have an Opacity of 255
  #----------------------------------------------------------------------------
  def force_ghost_to_opaque
    # Reset the Opacity Ghost Flag
    $game_player.opacity_ghost = false
    # Sets the Player to Opaque 255
    $game_player.fade_event(255, DEAD_GHOST_DURATION)
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Actor is Not a Cat Follower
      if not actor.cat_follower
        # Set Flag that Actor is no longer a Ghost
        actor.opacity_ghost = false      
        # Sets each Actor to an Opacity of 255
        actor.fade_event(255, DEAD_GHOST_DURATION)
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Zombies Reset - Game_Caterpillar
  #  - Resets so Zombie Sprites do not display
  #----------------------------------------------------------------------------
  def zombies_reset
    # Set the Normal Effect Transition Flag
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = true    
    # Resets the Player's Alternate Sprite to Dissolve back into Player
    $game_player.fade_event_reset(ZOMBIE_DURATION)
    # Check Actor Dead Status next step
    $walk_has_been_reset = true
    # Says we need to check for any Dead State to Zombie Changes
    $walk_has_been_set = false    
    # For each of the Caterpillar Actors
    for actor in @actors
      # if Actor is Not a Cat Follower
      if not actor.cat_follower
        # Set Transition Flag
        actor.dead_effect_transition = false
        actor.normal_effect_transition = true
        # Resets each Actor to hide Zombie Sprite
        actor.fade_event_reset(ZOMBIE_DURATION)
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Force Zombies to Normal - Game_Caterpillar
  #  - Forces Zombie Sprites do not display
  #----------------------------------------------------------------------------
  def force_zombies_to_normal
    # Set the Normal Effect Transition Flag
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = true    
    # Resets the Player's Alternate Sprite to Dissolve back into Player
    $game_player.fade_event_reset(ZOMBIE_DURATION)
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Actor is Not a Cat Follower
      if not actor.cat_follower      
        # Set Transition Flag
        actor.dead_effect_transition = false
        actor.normal_effect_transition = true
        # Resets each Actor to Original Opacity to hide Zombie Sprite
        actor.fade_event_reset(ZOMBIE_DURATION)
      end
    end
  end    
  #----------------------------------------------------------------------------
  # * Coffins Reset - Game_Caterpillar
  #  - Resets so Coffin Sprites do not display
  #----------------------------------------------------------------------------
  def coffins_reset
    # Set the Normal Effect Transition Flag
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = true    
    # Resets the Player's Alternate Sprite to Dissolve back into Player
    $game_player.fade_event_reset(COFFIN_DURATION)
    # Check Actor Dead Status next step
    $walk_has_been_reset = true
    # Says we need to check for any Dead State to Animation Changes
    $walk_has_been_set = false    
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Actor is Not a Cat Follower
      if not actor.cat_follower      
        # Set Transition Flag
        actor.dead_effect_transition = false
        actor.normal_effect_transition = true
        # Resets each Actor to Original Opacity to hide Coffin Sprite
        actor.fade_event_reset(COFFIN_DURATION)
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Force Coffins to Normal - Game_Caterpillar
  #  - Forces Coffins Sprites do not display
  #----------------------------------------------------------------------------
  def force_coffins_to_normal
    # Set the Normal Effect Transition Flag
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = true    
    # Resets the Player's Alternate Sprite to Dissolve back into Player
    $game_player.fade_event_reset(COFFIN_DURATION)
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Actor is Not a Cat Follower
      if not actor.cat_follower
        # Set Transition Flag
        actor.dead_effect_transition = false
        actor.normal_effect_transition = true
        # Resets each Actor to hide Coffin Sprite
        actor.fade_event_reset(COFFIN_DURATION)
      end
    end
  end  
  #----------------------------------------------------------------------------
  # * Alt Sprite Reset - Game_Caterpillar
  #  - Resets so Alternate Character Sprites do not display
  #----------------------------------------------------------------------------
  def alt_sprite_reset
    # Set the Normal Effect Transition Flag
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = true    
    # Resets the Player's Alternate Sprite to Dissolve back into Player
    $game_player.fade_event_reset(ALT_SPRITE_DURATION)
    # Check Actor Dead Status next step
    $walk_has_been_reset = true
    # Says we need to check for any Dead State to Animation Changes
    $walk_has_been_set = false    
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Actor is Not a Cat Follower
      if not actor.cat_follower
        # Set Transition Flag
        actor.dead_effect_transition = false
        actor.normal_effect_transition = true
        # Resets each Actor to Original Opacity to hide Alt Character Sprite
        actor.fade_event_reset(ALT_SPRITE_DURATION)
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Force Alt Sprite to Normal - Game_Caterpillar
  #  - Forces Alternate Character Sprites do not display
  #----------------------------------------------------------------------------
  def force_alt_sprite_to_normal
    # Set the Normal Effect Transition Flag
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = true    
    # Resets the Player's Alternate Sprite to Dissolve back into Player
    $game_player.fade_event_reset(ALT_SPRITE_DURATION)
    # For each of the Caterpillar Actors
    for actor in @actors
      # If Actor is Not a Cat Follower
      if not actor.cat_follower      
        # Set Transition Flag
        actor.dead_effect_transition = false
        actor.normal_effect_transition = true
        # Resets each Actor to Original Opacity to hide Alt Character Sprite
        actor.fade_event_reset(ALT_SPRITE_DURATION)
      end
    end
  end    
  #----------------------------------------------------------------------------
  # * Force Dead to Normal - Game_Caterpillar
  #  - Forces Alternate Character Sprites do not display
  #----------------------------------------------------------------------------
  def force_dead_to_normal
    # Forces Cat Actors and Player to have a Walk Animation
    force_walk if DEAD_EFFECT.include? ('DONT_WALK')
    # Forces Cat Actors and Player to be Opaque (Opacity 255)
    force_ghost_to_opaque if DEAD_EFFECT.include? ('GHOST')
    # Resets Cat Actors and Player to Non Zombie Alternate Graphics
    zombies_reset if DEAD_EFFECT.include? ('ZOMBIE')
    # Resets Cat Actors and Player to Non Coffin Alternate Graphics
    coffins_reset if DEAD_EFFECT.include? ('COFFIN')
    # Resets Cat Actors and Player to Non Alt Sprite Alternative Graphics
    alt_sprite_reset if DEAD_EFFECT.include? ('ALT_SPRITE')
  end
  #----------------------------------------------------------------------------
  # * Dead Walk Animation - Game_Caterpillar
  #  - Manages Walk Anime and starts Dead Effect Transitions
  #----------------------------------------------------------------------------
  def dead_walk_animation
    # If Caterpillar Active, not Dead Effects are On, and no other Transitions
    if $game_switches[CATERPILLAR_ACTIVE_SWITCH] and
       $game_switches[DEAD_ACTOR_EFFECTS] and
       not @actors_fade_in and not @actors_fade_out and not @fade_back_in
      # For each of the Caterpillar Actors
      for i in 1...$game_party.actors.size
        # Set Event to its corresponding Actor, regardless of Event ID
        actor = @actor_id_to_event[$game_party.actors[i].id]
        # If Event for that Cat Actor Exists
        if not actor.nil?
          # If Dead Actors Don't Walk
          if DEAD_EFFECT.include? 'DONT_WALK'
            # Set Walk Animation to True if Alive and False if Dead
            actor.walk_anime = $game_party.actors[i].dead? ? false : true
          end
          # If Actors are Dead and not Fading Opacity
          if $game_party.actors[i].dead? and actor.opacity_duration == 0
            # If Dead Actors become Ghosts
            if DEAD_EFFECT.include? 'GHOST' and
               actor.opacity != DEAD_GHOST_OPACITY and
               actor.opacity_ghost == false
              # Fade Out the Cat Actor and Set Opacity Ghost Flag
              actor.opacity_ghost = true
              actor.fade_event(DEAD_GHOST_OPACITY, DEAD_GHOST_DURATION)
            elsif actor.opacity != 0
              if DEAD_EFFECT.include? 'ZOMBIE' and
                 actor.alt_opacity != ZOMBIE_OPACITY and
                 not actor.zombie_visible
                # Fade Out the Actor to Fade In the Zombie Sprite
                actor.zombie = true
                actor.normal_effect_transition = false
                actor.dead_effect_transition = true
                actor.fade_event(0, ZOMBIE_DURATION)
              elsif DEAD_EFFECT.include? 'COFFIN' and
                    actor.alt_opacity != COFFIN_OPACITY and
                    not actor.coffin_visible
                # Fade Out the Actor to Fade In the Zombie Sprite
                actor.coffin = true
                actor.normal_effect_transition = false
                actor.dead_effect_transition = true              
                actor.fade_event(0, COFFIN_DURATION)
              elsif DEAD_EFFECT.include? 'ALT_SPRITE' and
                    actor.alt_opacity != ALT_SPRITE_OPACITY and
                    not actor.alt_char_sprite_visible
                # Fade Out the Cat Actor and Set Coffin Flag
                actor.alt_char_sprite = true
                actor.normal_effect_transition = false
                actor.dead_effect_transition = true              
                actor.fade_event(0, ALT_SPRITE_DURATION)
              end               
            end
          end
          # If we have set all the Cat Actors then set flags until next step
          if @walk_reset_array and 
             @walk_reset_array.include?($game_party.actors[i].id) and 
             @walk_reset_array.size == $game_party.actors.size - 1
            # Shorthand for Game Player
            p = $game_player
            # DONT WALK for Player
            if DEAD_EFFECT.include? 'DONT_WALK'
              # Sets the Main Player Walk Animation
              p.walk_anime = $game_party.actors[0].dead? ? false : true
            end
            # If not Fading Opacity
            if p.opacity_duration == 0
              # If Player Effect is to become a Ghost
              if DEAD_EFFECT.include? 'GHOST'
                # If Player's Character is Dead
                if $game_party.actors[0].dead?
                  # If Player's Opacity isn't Ghost and not Opacity Ghost Flag
                  if p.opacity != DEAD_GHOST_OPACITY and not p.opacity_ghost
                    # Fade the Player to the Opacity of a Ghost
                    p.fade_event(DEAD_GHOST_OPACITY, DEAD_GHOST_DURATION)
                  end
                  # Set the Opacity Ghost Flag
                  p.opacity_ghost = true
                elsif $game_player.opacity_ghost
                  # Unset the Opacity Ghost Flag
                  p.opacity_ghost = false
                end               
              # Else Other Dead Effects  
              elsif $game_party.actors[0].dead? and p.opacity != 0
                # If Zombie (for Player)
                if DEAD_EFFECT.include?('ZOMBIE') and not p.zombie_visible and
                   p.alt_opacity != ZOMBIE_OPACITY
                  # Set the Zombie Flag for the Player
                  p.zombie = true                  
                  # Set the Dead Effect Transition Flag
                  p.normal_effect_transition = false
                  p.dead_effect_transition = true
                  # "Dissolve" the Player into a Zombie
                  p.fade_event(0, ZOMBIE_DURATION)
                # If Coffin (for Player)   
                elsif DEAD_EFFECT.include?'COFFIN' and not p.coffin_visible and
                      p.alt_opacity != COFFIN_OPACITY
                  # Set the Coffin Flag for the Player
                  p.coffin = true                  
                  # Set the Dead Effect Transition Flag
                  p.normal_effect_transition = false
                  p.dead_effect_transition = true
                  # "Dissolve" the Player into a Coffin
                  p.fade_event(0, COFFIN_DURATION)
                elsif DEAD_EFFECT.include?('ALT_SPRITE') and 
                      not p.alt_char_sprite_visible and 
                      p.alt_opacity != ALT_SPRITE_OPACITY
                  # Set the Alt Character Sprite Flag for the Player
                  p.alt_char_sprite = true                  
                  # Set the Dead Effect Transition Flag
                  p.normal_effect_transition = false
                  p.dead_effect_transition = true
                  # "Dissolve" the Player into a Alternate Character Sprite
                  p.fade_event(0, ALT_SPRITE_DURATION)                      
                end
              end
            end
            # Allows for resetting Actor Events back to original Walking State
            $walk_has_been_reset = false
            # This prevents from continuing to iterate thru 
            # the array as it is done with screen update (faster), not per step
            $walk_has_been_set = true 
          else
            # If we havent added that Character to the Array yet
            if not @walk_reset_array.include?($game_party.actors[i].id)
              # Add that Character to the Array that it has been checked
              @walk_reset_array.push($game_party.actors[i].id)
            end
          end  
        # Else Actor Event doesnt exist
        else
          # Resets Flags without finishing Dead Effects
          $walk_has_been_reset = false
          $walk_has_been_set = true 
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Orient to Player - Game_Caterpillar
  #  - Orients Cat Actors to Player's Direction
  #----------------------------------------------------------------------------
  def orient_to_player
    # For each Event in Actors, which holds ALL Caterpillar Actor Events
    for actor in @actors
      # If that Event's Character is in the Party
      if cat_actor_in_party?(actor)
        # Use Transition Processing to determine New Direction
        if $game_temp.player_new_direction != 0 and @cat_player_transferring
          # If the Event doesn't have a Direction Fix Flag
          unless actor.direction_fix
            # Set Direction to match the Player's TEMP Direction -  On Teleport
            actor.direction = $game_temp.player_new_direction
          end
        else
          # If the Event doesn't have a Direction Fix Flag
          unless actor.direction_fix
            # Set Direction to match the Player's Direction
            actor.direction = $game_player.direction
          end
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Make Backup Command - Game_Caterpillar
  #  - Generates Backup MoveCommands used by Cat Backup
  #  - May temporarily enable Through for Actor Passages through each other
  #  - Won't cause Collisions from Non Cat Actors to be affected
  #      actor    : Caterpillar Actor or Follower
  #      delay    : Delay in Frames between each Event's Movement Execution
  #      i        : Actor Index in Caterpillar
  #      pushback : Style of Movement passed from Cat Backup args
  #----------------------------------------------------------------------------
  def make_backup_command(actor, delay = nil, i = nil, pushback = nil)
    # Create a new RPG MoveRoute Object
    route = RPG::MoveRoute.new
    # Default Settings for RPG MoveRoute Object
    route.repeat = false
    route.skippable = true
    # If Caterpillar Actors and Followers can move through each other
    if actor.through
      # RPG MoveCommand - Code 13 for '1 Step Backward'
      route.list.unshift(RPG::MoveCommand.new(13, [])) # Backup
    else
      # If Through needs to be Re-enabled for moving Through Events
      if not actor.through 
        # RPG::MoveCommand - Code 38 to for 'Through Off'
        route.list.unshift(RPG::MoveCommand.new(38, []))
      end
      # If Delay Argument and not Pushback Style of Movement
      if delay and not pushback
        # Create Wait Value to pass as a Parameter to RPG::MoveCommand
        wait = [((actor.actor_index - 1) * delay) - 1]
        # RPG::MoveCommand - Code 15 to Wait Frames with Parameter of wait
        route.list.unshift(RPG::MoveCommand.new(15, wait))
      end 
      # RPG::MoveCommand - Code 13 for '1 Step Backward'      
      route.list.unshift(RPG::MoveCommand.new(13, []))
      # If a Delay Argument is passed
      if delay
        # RPG::MoveCommand - Code 15, Wait Frames with Parameter of Wait Value
        route.list.unshift(RPG::MoveCommand.new(15, [i * delay]))
      end
      # Determines if Through should be Enabled for Last Caterpillar Character
      if  i < @actors.size
        # RPG MoveCommand - Code 13 for 'Through On'
        route.list.unshift(RPG::MoveCommand.new(37, []))
      end
    end
    # Return the newly created Move Route Object for '1 Step Backward'
    return route
  end
  #----------------------------------------------------------------------------
  # * Cat Backup - Game_Caterpillar
  #  - Player and all Caterpillar Characters move One Step Backward
  #  - Called by Interpreter
  #      delay    : Wait in Frames between each Caterpillar Character Movement
  #      pushback : True / False - Player pushes into each for Chain Reaction
  #----------------------------------------------------------------------------
  def cat_backup(delay = nil, pushback = nil)
    # If Caterpillar is Not Active or Paused
    if $game_switches[CATERPILLAR_PAUSE_SWITCH] or
       not $game_switches[CATERPILLAR_ACTIVE_SWITCH]
      # Do not Backup if Caterpillar is Not Active or Paused
      return
    end
    # Turn Pause ON
    $game_switches[CATERPILLAR_PAUSE_SWITCH] = true
    # Deletes the Last Registered Player Movement from @move_list array
    @move_list.delete_at(0) if @move_list[0]
    # Make a New RPG::MoveRoute  
    player_step_back_route = RPG::MoveRoute.new
    # Default Parameters for RPG::MoveRoute Object
    player_step_back_route.repeat = false
    player_step_back_route.skippable = false
    # Game Switch ID to change as [Parameter]
    switch = [CATERPILLAR_PAUSE_SWITCH]
    # Add to MoveRoute List RPG::MoveCommand - Code 28 for 'Switch OFF...'
    player_step_back_route.list.unshift(RPG::MoveCommand.new(28, switch))  
    # Add to MoveRoute List RPG::MoveCommand - Code 13 for '1 Step Backward'  
    player_step_back_route.list.unshift(RPG::MoveCommand.new(13, []))   
    # If a Delay Argument is passed and not Pushback Style of Movement Argument
    if delay and not pushback
      # Create Wait Value to pass as a Parameter to RPG::MoveCommand
      wait = [@actors.size * delay]
      # RPG::MoveCommand - Code 15, Wait Frames with Parameter of Wait Value
      player_step_back_route.list.unshift(RPG::MoveCommand.new(15, wait))
    end
    # If Pushback Argument passed for Style of Movement
    if pushback
      # Iterator - First Cat Actor gets Delayed so Player can Backup into them
      i = 1
      # For each of the Cat Actors
      for actor in @actors
        # Create the Backup RPG::MoveRoute and Force the new Move Route
        actor.force_move_route(make_backup_command(actor, delay, i, pushback))
        i += 1
      end
    else
      # Iterator - Last Caterpillar Character moves First by Delaying the rest
      i = @actors.size - 1
      # For each of the Cat Actors
      for actor in @actors
        # Create the Backup RPG::MoveRoute and Force the new Move Route        
        actor.force_move_route(make_backup_command(actor, delay, i))
        i -= 1
      end
    end
    # Create the Backup RPG::MoveRoute and Force the new Move Route for Player
    $game_player.force_move_route(player_step_back_route)   
  end
  #----------------------------------------------------------------------------
  # * Turn Cat Toward Event - Game_Caterpillar
  #  - Turns all Caterpillar Characters to face an Event during a Cutscene
  #  - Repeat will only Repeat if Caterpillar is not Active or Paused
  #      event_target_id : Event ID to Turn Towards, 0 for Player
  #      repeat          : Repeat the Move Route of Turn Towards Target
  #      delay           : Wait in Frames between each Characters Turn Action
  #----------------------------------------------------------------------------
  def turn_cat_toward_event(event_target_id, repeat = false, delay = nil)
    # Repeat only while Paused or Not Active, else Caterpillar fails to follow
    if not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH] and
       $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH]
      # Override or Set any Repeat Arguments passed
      repeat = false
    end
    # Iterator for Delay Multiplier
    i = 1
    # For each Caterpillar Character
    for actor in @actors
      # If that Actor's Character is in the Party (may be Paused or Not Active)
      if cat_actor_in_party?(actor)
        # Turn Caterpillar Character Toward the Target Event if no Delay
        actor.turn_toward_event(event_target_id) if not delay.is_a?(Numeric)
        # Create a new RPG::MoveRoute Object
        new_route = RPG::MoveRoute.new
        # RPG::MoveRotue Parameters
        new_route.repeat = repeat
        new_route.skippable = false
        # Script Parameter Value for RPG::MoveComand Object from String
        script = "turn_toward_event(" + event_target_id.to_s + ")"
        # Add to MoveRoute List RPG::MoveCommand - Code 45 for 'Script...'
        command = RPG::MoveCommand.new(45, [script])
        # If Actor has a Move Route Object (some scripts cause this to be nil)
        if actor.move_route
          # Clear the Move Route
          actor.move_route.list.clear
        end
        # Add the Turn Script RPG::MoveCommand Object to new Move Route List
        new_route.list.unshift(command)
        # If not a Repeating Move Route and Delay Argument is passed
        if not repeat and delay.is_a?(Numeric)
          # RPG::MoveCommand - Code 15 Wait Frames with Parameter of Wait Value
          new_route.list.unshift(RPG::MoveCommand.new(15, [delay * i]))
        end
        # Force the Caterpillar Character Move Route to new Move Route
        actor.force_move_route(new_route)
        # Increment the Iterator for Delay
        i += 1 
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Turn Cat Away From Event - Game_Caterpillar
  #  - Turns all Caterpillar Characters Away From an Event during a Cutscene
  #  - Repeat will only Repeat if Caterpillar is not Active or Paused
  #      event_target_id : Event ID to Turn Away From, 0 for Player
  #      repeat          : Repeat the Move Route of Turn Away From Target
  #      delay           : Wait in Frames between each Characters Turn Action
  #----------------------------------------------------------------------------
  def turn_cat_away_from_event(event_target_id, repeat = false, delay = nil)
    # Repeat only while Paused or Not Active, else Caterpillar fails to follow
    if not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH] and
       $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH]
      # Override or Set any Repeat Arguments passed
      repeat = false
    end
    # Iterator for Delay Multiplier
    i = 1
    # For each Caterpillar Character
    for actor in @actors
      # If that Actor's Character is in the Party (may be Paused or Not Active)
      if cat_actor_in_party?(actor)
        # Turn Caterpillar Character Away From the Target Event if no Delay
        actor.turn_away_from_event(event_target_id) if not delay.is_a?(Numeric)
        # Create a new RPG::MoveRoute Object
        new_route = RPG::MoveRoute.new
        # RPG::MoveRotue Parameters
        new_route.repeat = repeat
        new_route.skippable = false
        # Script Parameter Value for RPG::MoveComand Object from String
        script = "turn_away_from_event(" + event_target_id.to_s + ")"
        # Add to MoveRoute List RPG::MoveCommand - Code 45 for 'Script...'
        command = RPG::MoveCommand.new(45, [script])
        # If Actor has a Move Route Object (some scripts cause this to be nil)
        if actor.move_route
          # Clear the Move Route
          actor.move_route.list.clear
        end
        # Add the Turn Script RPG::MoveCommand Object to new Move Route List
        new_route.list.unshift(command)
        # If not a Repeating Move Route and Delay Argument is passed
        if not repeat and delay.is_a?(Numeric)
          # RPG::MoveCommand - Code 15 Wait Frames with Parameter of Wait Value
          new_route.list.unshift(RPG::MoveCommand.new(15, [delay * i]))
        end
        # Force the Caterpillar Character Move Route to new Move Route
        actor.force_move_route(new_route)
        # Increment the Iterator for Delay
        i += 1 
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Actor In Party? - Game_Caterpillar
  #  - Determines whether or not an Event is in the Active Party
  #----------------------------------------------------------------------------
  def cat_actor_in_party?(event)
    # If that Event corresponding Actor is in the Game Party
    return @actors.include?(event)
  end
  #----------------------------------------------------------------------------
  # * Cat Follower In Party? - Game_Caterpillar
  #  - Determines whether or not a Cat Follower is in the Active Caterpillar
  #----------------------------------------------------------------------------
  def cat_follower_in_party?(event)
    # If that Event corresponding Actor is in the Game Party
    return @actors.include? (event)
  end  
  #----------------------------------------------------------------------------
  # * Is Cat Actor? - Game_Caterpillar
  #  - Determines whether an Event is flagged as a Cat Actor
  #  - Not Party Depeandant
  #----------------------------------------------------------------------------
  def is_cat_actor?(event)
    # If Event has a @caterpillar_actor property
    return true if not event.caterpillar_actor.nil?
  end
  #----------------------------------------------------------------------------
  # * Is Cat Follower? - Game_Caterpillar
  #  - Determines whether an Event is flagged as a Cat Follower
  #----------------------------------------------------------------------------
  def is_cat_follower?(event)
    # If Event has a @caterpillar_actor property
    return true if not event.cat_follower.nil?
  end  
  #----------------------------------------------------------------------------
  # * Is Cat Actor Dead? - Game_Caterpillar
  #  - Determines whether the Corresponding Character for a Cat Actor is Dead
  #----------------------------------------------------------------------------
  def is_cat_actor_dead?(event)
    if event.is_a?(Game_Player)
      # Party Leader is Actor 0 who is a Game_Player, not Event
      return true if $game_party.actors[0] and $game_party.actors[0].dead?
    end
    # Return True if the Character's Corresponding Party Member is Dead
    if not event.actor_index.nil? and $game_party.actors[event.actor_index] and
       $game_party.actors[event.actor_index].dead?
      return true 
    end
  end
  #----------------------------------------------------------------------------
  # * Is Using Ladder? - Game_Caterpillar
  #  - Returns Using Ladder State
  #----------------------------------------------------------------------------
  def is_using_ladder?(event)
    return event.using_ladder
  end
  #----------------------------------------------------------------------------
  # * Party Using Ladder? - Game_Caterpillar
  #  - Returns True if Player or Any of the Cat Actors are using the Ladder
  #----------------------------------------------------------------------------
  def party_using_ladder?
    result = false
    # If the Player has using_ladder Flag set to True
    result = true if $game_player.using_ladder == true
    # Check each Cat Actor, including Cat Followers
    for actor in @actors
      # If the Cat Actor has a using_ladder Flag set to True
      result = true if actor.using_ladder == true
    end
    return result
  end
  #----------------------------------------------------------------------------
  # * Add Follower - Game_Caterpillar
  #  - Adds a Follower (Non Party Member Caterpillar Actor) to Caterpillar
  #  - Followers are Retained across Maps
  #      event       : Follower Map Event
  #      follower_id : ID of Follower ( Event Name - EV123\cat_follower[1] )
  #----------------------------------------------------------------------------
  def add_follower(event, follower_id)
    if not @actors.include?(event) and not @follower_ids.include?(follower_id)
      @follower = true
      # Add Follower ID to Follower IDs Array
      if not @follower_ids.include?(follower_id)
        @follower_ids.push(follower_id) 
      end
      # Add Follower Template for Character Graphic across Map changes
      if not @follower_templates.include?(event)      
        @follower_templates[follower_id] = event.dup
      end
      event.move_list.clear
      event.set_actor_index(@actors.size + 1 + 1)
      @actors << event
      # If the Caterpillar is not Paused
      if not $game_switches[CATERPILLAR_PAUSE_SWITCH]
        # Snap the Event to the Players Location
        event.moveto($game_player.x, $game_player.y)
        # If Auto Orient is Enabled
        if AUTO_ORIENT_TO_PLAYER
          # Set the Events Direction to be the same as the Players
          orient_to_player
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Remove Follower - Game_Caterpillar
  #  - Removes a Follower Event from the Caterpillar
  #      follower_id : ID of Follower (Event Name - EV012\cat_follower[2])
  #----------------------------------------------------------------------------
  def remove_follower(follower_id)
    index = @actors.index(@follower_events[follower_id])
    @actors.delete_at(index) if not index.nil?
    index = @follower_ids.index(follower_id)
    @follower_ids.delete_at(index) if not index.nil?
    # Remove from Follower Templates for Graphics Transfer on Map Changes
    if not @follower_templates[follower_id].nil?    
      @follower_templates.delete_at(follower_id) 
    end
    # Unset Flag of any Followers
    @follower = false if @follower == []
  end
  #----------------------------------------------------------------------------
  # * Add Actor - Game_Caterpillar
  #  - Adds an Event to the Caterpillar 
  #  - Uses Event Name \caterpillar_actor[N] for Actor Party Correspondence
  #      event    : Map Event to add to the Caterpillar as a Caterpillar Actor
  #      actor_id : Corresponding Party Member for Caterpillar Actor
  #----------------------------------------------------------------------------
  def add_actor(event, actor_id)
    # Holds Actor IDs
    @actor_id_to_event[actor_id] = event
    # Clear any Recorded Move Events from the Player
    event.move_list.clear if not event.cat_follower
    # Prevent adding Duplicate Caterpillar Actors
    added = false
    # If Event's Walk Animation has not been Recorded
    if event.last_walk_anime.nil?
      # Record the Events Original Walk Anime Setting (Anime = Animation)
      event.last_walk_anime = event.walk_anime
    end
    # For each Non Player Actor
    for i in 1..$game_party.actors.size - 1
      # Party Member
      actor = $game_party.actors[i]
      # If Event's Cat Actor ID matches the Actor ID in the Database
      if actor.id == actor_id
        # Assigns the Game Party Index (0,1,2,3 etc) not the Actor ID
        event.set_actor_index(i)
        # Push Event on to the Caterpillar Members Array
        @actors << event
        # If the Caterpillar is not Paused
        if not $game_switches[CATERPILLAR_PAUSE_SWITCH]
          # Snap the Event to the Players Location
          event.moveto($game_player.x, $game_player.y)
          # If Auto Orient is Enabled
          if Game_Caterpillar::AUTO_ORIENT_TO_PLAYER
            # Set the Events Direction to be the same as the Players
            orient_to_player
          end
        end
        # If Dead Actor Effects Switch is ON
        if $game_switches[DEAD_ACTOR_EFFECTS]
          # If the Dead Effect is to Not Walk when Dead
          if DEAD_EFFECT.include? ('DONT_WALK')
            # Walk Animation is dependant on Party Member Dead
            event.walk_anime = ($game_party.actors[i].dead?) ? false : true
          end
          # If the Dead Effect is to be a Ghost
          if DEAD_EFFECT.include? ('GHOST')
            # If Corresponding Party Member is Dead
            if $game_party.actors[i].dead? and 
               event.opacity_duration != 0 and
               not event.opacity_ghost
              # Set the Event to Ghost Opacity
              event.fade_event(DEAD_GHOST_OPACITY, DEAD_GHOST_DURATION)
              # Set the Ghost Flag
              event.opacity_ghost = true
            end
          # If the Dead Effect is to be a Zombie
          elsif DEAD_EFFECT.include? ('ZOMBIE')
            # If Corresponding Party Member is Dead            
            if $game_party.actors[i].dead?
              # Set the Zombie Flag
              event.zombie = true
              # Set the Dead Effect Transition Flag
              event.normal_effect_transition = false
              event.dead_effect_transition = true
              # Set the Event to Ghost Opacity
              event.fade_event(0, ZOMBIE_DURATION)
            end            
          # If the Dead Effect is to be a Coffin
          elsif DEAD_EFFECT.include? ('COFFIN')
            # If Corresponding Party Member is Dead            
            if $game_party.actors[i].dead?
              # Set the Coffin Flag
              event.coffin = true
              # Set the Dead Effect Transition Flag
              event.normal_effect_transition = false
              event.dead_effect_transition = true
              # Set the Event to Ghost Opacity
              event.fade_event(0, COFFIN_DURATION)
            end            
         # If the Dead Effect is to be a Alternate Character Sprite
          elsif DEAD_EFFECT.include? ('ALT_SPRITE')
            # If Corresponding Party Member is Dead
            if $game_party.actors[i].dead?
              # Set the Alt Character Sprite Flag
              event.alt_char_sprite = true
              # Set the Dead Effect Transition Flag
              event.normal_effect_transition = false
              event.dead_effect_transition = true
              # Set the Event to Ghost Opacity
              event.fade_event(0, ALT_SPRITE_DURATION)
            end                        
          end          
        end
        # Flag that Actor has been added to Caterpillar to prevent Duplicates
        added = true
      end
    end
    # If Option to Erase Inactive Caterpillar Actors (Switch or Constant)
    if $game_switches[CATERPILLAR_ACTIVE_SWITCH] and
       not added and remove_visible_actors?
      # Erase Caterpillar Actors that do not correspond to the Active Party
      event.erase
    end
    # If Option to Erase Inactive Caterpillar Actors is OFF, clear Dead Effects
    if $game_switches[CATERPILLAR_ACTIVE_SWITCH] and 
       $game_switches[DEAD_ACTOR_EFFECTS] and 
       not added and not remove_visible_actors?
      # If the Dead Effect is to Not Walk and not Original Settings
      if DEAD_EFFECT.include? ('DONT_WALK') and 
         event.walk_anime != event.last_walk_anime
        # Resets each Event to Original Walk Animation Flags
        event.walk_anime = event.last_walk_anime
      end
      # If the Effect is to be a Ghost and not Original Settings
      if DEAD_EFFECT.include?('GHOST') and event.opacity_ghost and
         event.opacity != event.opacity_original 
        # Reset the Event to its Original Opacity before being Faded Out
        event.fade_event_reset(DEAD_GHOST_DURATION)
        # Reset the Ghost Flag
        event.opacity_ghost = false
      # If the Effect is to be a Ghost and not Original Settings       
      elsif DEAD_EFFECT.include? ('ZOMBIE') and event.zombie
        # Turn OFF the Dead Effect Transition in case it is set
        event.dead_effect_transition = false
        # Set the Normal Effect Transition Flag to hide Zombie Sprite
        event.normal_effect_transition = true
        # Reset the Event to its Original Opacity before being Faded Out
        event.fade_event_reset(ZOMBIE_DURATION)
        # NOTE the Zombie Flag should Reset after the Player takes a Step
      # If the Effect is to be a Coffin...        
      elsif DEAD_EFFECT.include? ('COFFIN') and event.coffin
        # Turn OFF the Dead Effect Transition in case it is set
        event.dead_effect_transition = false
        # Set the Normal Effect Transition Flag to hide Coffin Sprite
        event.normal_effect_transition = true
        # Reset the Event to its Original Opacity before being Faded Out
        event.fade_event_reset(Game_Caterpillar::COFFIN_DURATION)
        # NOTE the Coffin Flag should Reset after the Player takes a Step
      # If the Effect is to be an Alternate Character Sprite...          
      elsif DEAD_EFFECT.include? ('ALT_SPRITE') and event.alt_char_sprite
        # Turn OFF the Dead Effect Transition in case it is set
        event.dead_effect_transition = false
        # Set the Normal Effect Transition Flag to hide Alt Character Sprite
        event.normal_effect_transition = true
        # Reset the Event to its Original Opacity before being Faded Out
        event.fade_event_reset(Game_Caterpillar::ALT_SPRITE_DURATION)
        # NOTE the Alt Sprite Flag should Reset after the Player takes a Step
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Out Per Step - Game_Caterpillar
  #  - Cat Fades Out Every Step
  #      duration          : Time in Frames to fade out
  #      auto_fade_back_in : True / False to Fade Back In after Fade completes
  #----------------------------------------------------------------------------
  def cat_fade_out_per_step(duration, auto_fade_back_in = nil)
    # Sets these Variables so Fade out Transition can occur
    duration = 20 if duration and not duration.is_a?(Numeric)    
    @cat_steps = 0
    @actors_fade_out = duration
    @actors_fade_in = false
    @fade_back_in = auto_fade_back_in
  end
  #----------------------------------------------------------------------------
  # * Cat Fade In Per Step - Game_Caterpilalr
  #  - Party Characters Fade In with each Step
  #  - Use when Cat Fade Out Per Step is not used with auto_fade_back_in
  #      duration : Time in Frames to fade in
  #----------------------------------------------------------------------------
  def cat_fade_in_per_step(duration)
    # Sets these Variables so Fade out Transition can occur
    duration = 20 if duration and not duration.is_a?(Numeric)
    @cat_steps = 0
    @actors_fade_in = duration
    @actors_fade_out = false
  end
  #----------------------------------------------------------------------------
  # * Remove Visible Actors? -  Game_Caterpillar
  #  - Returns value of Game Switch or Constant
  #  - Check if Visible Actors should be removed
  #----------------------------------------------------------------------------
  def remove_visible_actors?
    if REMOVE_VISIBLE_ACTORS.is_a?(Integer)
      return $game_switches[REMOVE_VISIBLE_ACTORS]
    else
      return REMOVE_VISIBLE_ACTORS
    end
  end
  #----------------------------------------------------------------------------
  # * Center - Game_Caterpillar
  #  - Centers Caterpillar to Player on Map Transfer or Teleport
  #  - Checks for Ladder on Transfer in case Ladders cause Map Transfer
  #----------------------------------------------------------------------------
  def center
    # Check if the caterpillar is active
    return unless $game_switches[CATERPILLAR_ACTIVE_SWITCH]
    # Clear the Player to Caterpillar scheduled Movement
    @move_list.clear
    # updates the Actors in the caterpillar
    update
    # Move the actors to the new place
    for event in @actors
      # Teleport to Player's Position, Regardless if Paused or not.
      event.moveto($game_player.x, $game_player.y)
      # Clear that Actors Move List
      event.move_list.clear
    end
    # If the Script Option says Auto Orient is enabled and not called manually
    if AUTO_ORIENT_TO_PLAYER
      # Orients Cat Actors in Party to match the Player's Direction
      orient_to_player
    end
    # If teleported to a Ladder which needs all actors to Direction Fix UP
    if $game_switches[LADDER_EFFECTS] and
       $game_player.terrain_tag == LADDER_TAG
      # Store Movement Speed prior to changing for Ladders
      @ladder_reset_speed = $game_player.move_speed unless @speed_stored
      @speed_stored = true
      # Store Players Direction Fix Variable if not Stored
      if @ladder_last_direction_fix.nil?      
        @ladder_last_direction_fix = $game_player.direction_fix 
      end
      # Set the Player Speed to Scripted Speed
      $game_player.move_speed = @ladder_move_speed if @ladder_move_speed != 0
      # Set Players Ladder Flags to ON and tuns Player Up
      $game_player.direction = 8
      $game_player.direction_fix = true
      $game_player.using_ladder = true
      # Set Appropriate Ladder Flags
      @ladder_set = true
      @ladder_reset = false         
      # If Caterpillar is not Paused      
      if not $game_switches[CATERPILLAR_PAUSE_SWITCH] 
        # Turn On Direction Fix for Each Cat Actor and turns Actors Up
        for actor in @actors
          actor.direction = $game_player.direction
          actor.direction_fix = true
          actor.using_ladder = true
        end
      end
    end
    # If Editor and Constant Display Developer Errors is ON
    if $DEBUG and DISPLAY_DEVELOPER_ERRORS == true
      # New Map - Check for Duplicates Again
      $duplicates_checked = false
      # Check each Map Event for Caterpillar Actor and Follower Properties
      for event in $game_map.events.values
        # Check for Duplicate Caterpillar Actors and Followers
        event.check_duplicates
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Register Player Move - Game_Caterpillar
  #  - Registers a Player Movement to schedule for Caterpillar Movements
  #----------------------------------------------------------------------------
  def register_player_move(move_speed, *args)
    # Array holds Actors that have their Animations Set for that Step
    $game_system.caterpillar.walk_reset_array.clear
    # If Game Switch for DEAD_ACTOR_EFFECTS is On
    if $game_switches[DEAD_ACTOR_EFFECTS]
      # Sets flag to set the Actors Walk Animation
      $walk_has_been_set = false
    end
    # Get the Player's Terrain Tag
    terrain_tag = $game_player.terrain_tag
    # If Caterpillar Ladder Effects are Enabled
    if $game_switches[Game_Caterpillar::LADDER_EFFECTS] and
       Game_Caterpillar::LADDER_TAG != 0 and
       terrain_tag == Game_Caterpillar::LADDER_TAG and
       @ladder_set != true
      # Store Movement Speed prior to changing for Ladders
      @ladder_reset_speed = $game_player.move_speed unless @speed_stored
      @speed_stored = true
      # Store Players Direction Fix Variable if not set
      if @ladder_last_direction_fix.nil?      
        @ladder_last_direction_fix = $game_player.direction_fix 
      end
      # Set the Player Speed to Scripted Speed
      $game_player.move_speed = @ladder_move_speed if @ladder_move_speed != 0
      # Cat Actors inherit Using Ladder Flag, which prevents Movement
      $game_player.using_ladder = true
      $game_player.direction = 8 # Up
      $game_player.direction_fix = true
      @ladder_set = true
      @ladder_reset = false
    # If Player is not on a Ladder
    elsif terrain_tag != LADDER_TAG and @ladder_set and not @ladder_reset
      # Reset Ladder Related Variables
      @ladder_set = false
      @ladder_reset = true
      # Reset Player Variables to Stored Variables
      $game_player.move_speed = @ladder_reset_speed if @speed_stored
      @speed_stored = nil
      $game_player.direction_fix = @ladder_last_direction_fix 
      @ladder_last_direction_fix = nil
      # Disable Player's Ladder Flag to register proper Non Ladder Movements
      $game_player.using_ladder = false
      # Set Player Direction to the Direction that the Player Pressed
      $game_player.direction = $game_player.last_moved_direction
    end
    # If Fading the entire Caterpillar
    if $game_system.caterpillar.actors_fade_in
      # PLAYER
      if ($game_player.opacity * 1.0) == (0 * 1.0) and 
         $game_player.alt_opacity == 0 and 
         $game_player.opacity_duration == 0 and
         ((@cat_steps == 0 and $game_party.actors.size > 1) or
         $game_party.actors.size == 1)
        # Player is Dead?
        if $game_switches[DEAD_ACTOR_EFFECTS] and $game_party.actors[0].dead?
          # If the Player is Dead
          if DEAD_EFFECT.include?('GHOST')
            # Fade Back to Ghost Opacity
            $game_player.opacity_ghost = true            
            $game_player.fade_event(DEAD_GHOST_OPACITY, @actors_fade_in)
          elsif DEAD_EFFECT.include?('ZOMBIE')
            # Fade Back to Original Opacity
            $game_player.zombie = true            
            $game_player.fade_event(ZOMBIE_OPACITY, @actors_fade_in)
          elsif DEAD_EFFECT.include?('COFFIN')
            # Fade Back to Original Opacity
            $game_player.coffin = true            
            $game_player.fade_event(COFFIN_OPACITY, @actors_fade_in)
          elsif DEAD_EFFECT.include?('ALT_SPRITE')
            # Fade Back to Original Opacity
            $game_player.alt_char_sprite = true  
            $game_player.fade_event(ALT_SPRITE_OPACITY, @actors_fade_in)
          elsif DEAD_EFFECT == []
            # Fade Back to Original Opacity
            $game_player.fade_event_reset(@actors_fade_in)
          end
        # Player is NOT Dead
        else
          # Fade Back to Original Opacity
          $game_player.fade_event_reset(@actors_fade_in)
        end
      end
    elsif $game_system.caterpillar.actors_fade_out
      if $game_system.caterpillar.cat_steps == 0
        # Fade Out the Player
        $game_player.fade_event(0, @actors_fade_out)
      end
    end
    # Handle Paused or Inactive Caterpillars
    if not $game_switches[CATERPILLAR_ACTIVE_SWITCH] or 
       $game_switches[CATERPILLAR_PAUSE_SWITCH] or
       $game_party.actors.size == 1
      # Reset Fade Commands
      if $game_system.caterpillar.cat_steps > 1
        if $game_system.caterpillar.actors_fade_in
          # Reset the Fade In Flag
          $game_system.caterpillar.actors_fade_in = false
        end  
        # Hold the Value of @actors_fade_out
        last_fade_out = @actors_fade_out        
        @actors_fade_out = false
        if @fade_back_in
          # Reset to Original State
          @fade_back_in = false
          cat_fade_in_per_step(last_fade_out)
        end
      end
      # Increment Cat Steps since it wont be updated later
      $game_system.caterpillar.cat_steps += 1
    end    
    # If Caterpillar is Not Active or is Paused
    if not $game_switches[CATERPILLAR_ACTIVE_SWITCH] or
       $game_switches[CATERPILLAR_PAUSE_SWITCH]
      # Prevent further execution
      return
    end
    # If Caterpillar is Through for PASS_SOLID_ACTORS = false and Stacking
    if $cat_forced_to_through
      # Just for the Actors in the Active Party, not all Cat Actors
      for actor in @actors
        # Reset Cat Actors "Through" to Original State
        actor.reset_cat_through
      end
      # Turn this option off to prevent resetting every step
      $cat_forced_to_through = false
    end
    # Player Variables to be sent to the Cat Actors
    d = $game_player.direction
    df = $game_player.direction_fix
    l = $game_player.using_ladder
    # Add the new command
    @move_list.unshift([move_speed, args, df, d, l])
    # Append the new moves to the caterpillar events
    update_actor_movement
    # Check if Caterpillar Movement Command has been run by all Members
    if @move_list.size > @actors.size + 1
      # While more Movements are Registered than the Size of the Caterpillar
      while @move_list.size > @actors.size + 1
        # Remove the last move command
        @move_list.pop
      end
    end    
  end
  #----------------------------------------------------------------------------
  # * Update Actor Movement - Game_Caterpillar
  #  - Make Caterpillar Actors perform Registered Player Movements
  #----------------------------------------------------------------------------
  def update_actor_movement
    # For each Actor in the Caterpillar
    for i in 0...@actors.size
      # If there is a command in @move_list that hasnt been exectued
      if i + 1 < @move_list.size
        # Set the Command to the Registered Player's Movements
        command = @move_list[i + 1]
        # Sets Actor to an Iteration of Actors in @actors
        actor = @actors[i]
        # If the Player had Direction Fix turned on
        if $game_switches[LADDER_EFFECTS]
          # If Player Direction Fix
          if command[2] and not actor.using_ladder
            # Prevents Player Passage with pass_actors_on_ladders option
            actor.using_ladder = command[4]
            # Store Direction Fix for Resetting if it is not set
            if actor.direction_fix_last.nil?            
              actor.direction_fix_last = actor.direction_fix 
            end
            # Enable Direction Fix for the Cat Actor
            actor.direction_fix = true
            # Force the Actor to face the same direction the Player was facing
            actor.direction = command[3]
            # Store the Direction
            actor.direction_last = actor.direction if actor.direction_last.nil?
          elsif not command[2] and actor.using_ladder
            # Reset Direction Fix to Original
            actor.using_ladder = false
            actor.direction_fix = false if not actor.direction_fix_last
            actor.direction = actor.direction_last if actor.direction_fix_last
            actor.direction_last = nil
            actor.direction_fix_last = nil
          end
        elsif actor.using_ladder
          actor.using_ladder = false
          actor.direction_last = nil
          if not actor.direction_fix_last.nil?          
            actor.direction_fix = actor.direction_fix_last 
          end
          actor.direction_fix_last = nil
        end
        # Prepends Command to the Actor's @move_list
        actor.move_list.unshift(command[1])
        # Set Actor Move Speed to Players Recorded Move Speed at that spot
        actor.move_speed = command[0]    
        # Fades In All Cat Actors as they Step Forward to same spot
        if $game_system.caterpillar.actors_fade_in
          # Cat Actor Fade In Effects depending on DEAD_EFFECT
          if $game_system.caterpillar.cat_steps == i + 1
            # If the Actor is Dead
            if $game_switches[DEAD_ACTOR_EFFECTS] and 
               not actor.cat_follower and
               $game_party.actors[i + 1].dead?
              # If the Effect is GHOST
              if DEAD_EFFECT.include?('GHOST')
                # Fade Back to Ghost Opacity
                actor.fade_event(DEAD_GHOST_OPACITY, @actors_fade_in)
                actor.opacity_ghost = true
              elsif DEAD_EFFECT.include?('ZOMBIE')
                # Fade Back to ZOMBIE Opacity
                actor.zombie = true
                actor.fade_event(ZOMBIE_OPACITY, @actors_fade_in) 
              elsif DEAD_EFFECT.include?('COFFIN')
                # Fade Back to COFFIN Opacity
                actor.coffin = true
                actor.fade_event(COFFIN_OPACITY, @actors_fade_in) 
              elsif DEAD_EFFECT.include?('ALT_SPRITE')
                # Fade Back to ALT SPRITE Opacity
                actor.alt_char_sprite = true
                actor.fade_event(ALT_SPRITE_OPACITY, @actors_fade_in)
              end
            else
              # Fade Back to Original Opacity
              actor.fade_event_reset(@actors_fade_in) 
            end
          end
          # If we need to reset the Actors Fade In Flag
          if $game_system.caterpillar.cat_steps > @actors.size + 1
            # Reset the Fade In Flag
            $game_system.caterpillar.actors_fade_in = false
          end
        # Fades Out All Cat Actors at the same Location as they step
        elsif $game_system.caterpillar.actors_fade_out
          if $game_system.caterpillar.cat_steps == i + 1
            # Fade Out Cat Actor
            actor.fade_event(0, @actors_fade_out)
          end
          # Check to see if Actor Fade Out should be set to False
          if $game_system.caterpillar.cat_steps > @actors.size 
            # Hold the Value of @actors_fade_out
            last_fade_out = @actors_fade_out
            # Set the Fade Out Flag to False
            @actors_fade_out = false
            if @fade_back_in
               #Reset to Original State
              @fade_back_in = false
              cat_fade_in_per_step(last_fade_out)
              dont_increment = true
            end
          end
        end
      end
    end
    # Used for allowing Player to step out of a Non Passable Caterpillar    
    $game_system.caterpillar.cat_steps += 1 if not dont_increment
  end
  #----------------------------------------------------------------------------
  # * Create Path to Player - Game_Caterpillar
  #  - Create a Forced Route to Player from @move_list
  #      move_list             : Caterpillar Actor's Movement List, not Route
  #      max                   : Actor Index
  #      o = fade_out_opacity  : Actor is set to Fade to this Opacity
  #      d = fade_out_duration : Time in Frames for Duration of Fade
  #      turn                  : Turn to match Player Direction on last move
  #----------------------------------------------------------------------------
  def create_path_to_player(move_list, max, o = nil, d = nil, turn = nil)
    # Dont bother if nothing there    
    return if not move_list
    # Make a New RPG::MoveRoute  
    route_to_player = RPG::MoveRoute.new
    # Default values of RPG::MoveRoute
    route_to_player.repeat = false
    route_to_player.skippable = false 
    # If Argument to Turn and match Player's Direction on Last Movement
    if turn
      # Script to run to match Player's Direction as Parameter
      turn_cmd = "@direction = $game_player.direction if not @direction_fix" 
      # MoveRoute to use MoveCommand - Code 45 for Script and Parameter
      route_to_player.list.unshift(RPG::MoveCommand.new(45, [turn_cmd]))
    end
    # Clear Actor's Move List to prevent conflicts with this Move Route
    @actors[max].move_list.clear
    # For every item in move_list
    for i in 0...move_list.size
      # Sets a Default - Not Returned if Code is 0
      code = 0
      # If the current iteration is less than that Actor's Index
      if i <= max
        # Generate Codes based on move_list recorded action
        command = move_list[i][1][0]
        # Command Codes for Movement - Allow for 8 Direction Movement      
        code = 1 if command == 'move_down'
        code = 2 if command == 'move_left'
        code = 3 if command == 'move_right'
        code = 4 if command == 'move_up'
        code = 5 if command == 'move_lower_left'
        code = 6 if command == 'move_lower_right'
        code = 7 if command == 'move_upper_left'
        code = 8 if command == 'move_upper_right'
        code = 14 if command == 'jump'
        code = 29 if command == 'speed' # Change speed
        # If the Optional Fade Out Arguments are Passed
        if o.is_a? (Numeric) and d.is_a? (Numeric)
          # If this is the Last event in the move_list
          if i == 0
            # Script String for Fade Event Script Call
            fade_cmd = "fade_event(" + o.to_s + ", " + d.to_s + ")"
            # MoveRoute to use MoveCommand - Code 45 for Script and Parameter
            route_to_player.list.unshift(RPG::MoveCommand.new(45, [fade_cmd]))
          end
        end
        # Code 14 for Jump and Code 29 for Set Speed require Parameters
        if code == 14 or code == 29
          # P - Parameter is the Jump Target Array and Speed Parameters
          p = move_list[i].to_a[1].to_a[1]
        end
      end
      # MoveRoute to use MoveCommand if Valid Movement Code
      route_to_player.list.unshift(RPG::MoveCommand.new(code, p)) if code != 0
    end
    # Returns a Valid RPG::MoveRoute for Caterpillar Members to execute
    return route_to_player
  end
  #----------------------------------------------------------------------------
  # * Cat to Player - Game_Caterpillar
  #  - Calls All Cat Actors to the Player's current Position with Options
  #  - Additional Arguments for Fading (Teleport) and match Player Direction
  #  - Similar but Superior to Gather Followers in RPG Maker VX Ace
  #  - Allows for use of "Wait for Move's Completion"
  #  - Caterpillar Members given a higher Z-Index to appear over Player when up
  #  - Avoid using this command while under Priority 1 Tiles when facing Up
  #  - All Arguments are Optional and set to nil in Interpreter
  #      fade_out_opacity  : Opacity Target when last move is executed
  #      fade_out_duration : Duration of Opacity Transition
  #      turn_last_move    : Match Player's Direction on end of last move
  #----------------------------------------------------------------------------
  def cat_to_player(fade_out_opacity, fade_out_duration, turn_last_move = nil)
    # If Optional Arguments are valid and set
    if fade_out_opacity.is_a?(Numeric) and fade_out_duration.is_a?(Numeric)
      $game_player.fade_event(fade_out_opacity, fade_out_duration)
      $game_system.caterpillar.cat_steps = 0
      $game_system.caterpillar.actors_fade_in = fade_out_duration
    end
    # For each Actor in the Caterpillar
    for i in 0...@actors.size
      # Set the Command to the Registered Player's Movement
      command = @move_list[i]
      # Sets Actor to an Iteration of Actors in @actors
      actor = @actors[i]
      # Actors cant move Through Players - Turn Through On for this Actor
      actor.set_cat_through
      # Shorthand
      m = @move_list
      o = fade_out_opacity
      d = fade_out_duration
      t = turn_last_move
      # Makes Actor complete the move_list and end up on the Player, Stacked
      actor.force_move_route(create_path_to_player(m, i, o, d, t))
      # Set Actor Move Speed to Players Recorded Move Speed at that spot
      actor.move_speed = command[0] if @move_list[i]
    end
    # Clear the Move List since we just executed the whole thing.
    @move_list.clear
    # Reset Cat Steps for other situations
    $game_system.caterpillar.cat_steps = 0
    # Set Substack Property for Player for proper Z Index
    $game_player.substack_z = true if $game_player.direction == 8
  end
  #----------------------------------------------------------------------------
  # * Orient Cat to Player - Game_Caterpillar
  #  - Call from Interpreter 'orient_cat_to_player'
  #  - Default Arguments are delared here and just uses Cat to Player method
  #----------------------------------------------------------------------------
  def orient_cat_to_player(opacity = nil, duration = nil)
    # Set third Argument for Turning to True
    cat_to_player(opacity, duration, true)
  end
  #----------------------------------------------------------------------------
  # * Events Cat Passable? - Game_Caterpillar
  #  - Determine if Caterpillar Members can pass each other on Stagger calls
  #----------------------------------------------------------------------------
  def events_cat_passable?(x, y)
    result = true
    for event in $game_map.events.values
      if event.x == x and event.y == y and
         not event.through and
         event.character_name != "" and
         not event.caterpillar_actor and
         not event.cat_follower and
         not @actors.include?(event)
        result = false
      end
    end
    return result
  end
  #----------------------------------------------------------------------------
  # * Cat Stagger - Game_Caterpillar
  #  - Intended for use while not visible to set up Cutscenes
  #  - Stagger Caterpillar behind Player
  #  - Fixes Move Route Commands
  #  - Staggering into Impassable Locations causes Stacking
  #  - Takes into account Stagger called over a Ladder
  #  - Accepts String or Numeric Stagger Directions so 'Left' or 4 are accepted
  #      dir    : Direction to Stagger the Caterpillar Members
  #      offset : (Optional) Additional Distance from Player
  #----------------------------------------------------------------------------
  def cat_stagger(dir, offset = 0)
    # If not Fading while Stagger as these values are affected by Cat Steps
    if not @actors_fade_in and not @actors_fade_out and not @fade_back_in    
      # Cat Steps causes Z-Index to make Caterpillar on top of Player
      @cat_steps = @actors.size + 2 if @cat_steps < @actors.size + 1
    end    
    # Covert String Case 
    dir = dir.downcase if dir.is_a?(String)
    #  Convert String to Numeric
    case dir
    when 'down' then dir = 2
    when 'left' then dir = 4
    when 'right' then dir = 6
    when 'up' then dir = 8
    end
    # Prevent Execution if not Valid Direction
    return unless [2,4,6,8].include?(dir)
    # Shorthand
    df = $game_player.direction_fix    
    d = $game_player.direction
    l = $game_player.using_ladder    
    # Clear the stored Movement List
    @move_list.clear
    # Move List Command to Player's current position branching by Direction
    case dir
    when 2
      args = ["move_up",[],[$game_player.x, $game_player.y]]
      @move_list.push([$game_player.move_speed, args, df, d, l])
    when 4
      args = ["move_right",[],[$game_player.x, $game_player.y]]
      @move_list.push([$game_player.move_speed, args, df, d, l])    
    when 6
      args = ["move_left",[],[$game_player.x, $game_player.y]]
      @move_list.push([$game_player.move_speed, args, df, d, l])    
    when 8
      args = ["move_down",[],[$game_player.x, $game_player.y]]
      @move_list.push([$game_player.move_speed, args, df, d, l])    
    end
    # Determine Distance of Offset if Optional Offset Argument is used
    dist = (dir != 0) ? 1 + offset : 0
    # Placeholder and Iterator for checking if Stagger Placement is Passable
    blocked_dist = false
    i = 0
    # Shorthand for Player
    p = $game_player
    # For each Caterpillar Member to be moved by Stagger
    for event in @actors
      # Handles if used on a Ladder or not
      if $game_switches[Game_Caterpillar::LADDER_EFFECTS] and l
        # Store Direction Fix for Resetting
        event.direction_fix_last = false
        # Enable Direction Fix for the Cat Actor
        event.direction_fix = true
        # Force the Actor to face the same direction the Player was facing
        event.direction = 8
        # Store the Direction
        event.direction_last = (dir == 8) ? 2 : 8
        # Sets the Using Ladder flag
        event.using_ladder = true
      end
      # Create sequential Caterpillar Move List Commands at new Locations
      case dir
      when 2 # Down
        # If a Blocked Distance is set or Map is Impassable at Stagger Location
        if blocked_dist or not $game_map.passable?(p.x, p.y + dist, 8) or
           not events_cat_passable?(p.x, p.y + dist)
          # Distance from Player that Map is Impassable for next Actor
          dist = (blocked_dist) ? blocked_dist : dist - 1
          # Value used to prevent processing Passable again as it is expensive
          blocked_dist = dist
        end
        # Place the Caterpillar Actor and set the Direction
        event.moveto(p.x, p.y + dist)
        event.direction = 8 if not event.direction_fix
        # Create Movement Arguments as a Registered Caterpillar Movement
        args = ["move_up",[],[p.x, p.y + dist]]
        # Add the new command to Registered Caterpillar Movements
        @move_list.push([p.move_speed, args, df, d, l])
      when 4 # Left
        # If a Blocked Distance is set or Map is Impassable at Stagger Location
        if blocked_dist or not $game_map.passable?(p.x - dist, p.y, 6) or
           not events_cat_passable?(p.x - dist, p.y)
          # Distance from Player that Map is Impassable for next Actor
          dist = (blocked_dist) ? blocked_dist : dist - 1
          # Value used to prevent processing Passable again as it is expensive
          blocked_dist = dist
        end
        # Place the Caterpillar Actor and set the Direction
        event.moveto(p.x - dist, p.y)
        event.direction = 6 if not event.direction_fix
        # Create Movement Arguments as a Registered Caterpillar Movement
        args = ["move_right",[],[p.x - dist, p.y]]
        # Add the new command to Registered Caterpillar Movements
        @move_list.push([p.move_speed, args, df, d, l])
      when 6 # Right
        # If a Blocked Distance is set or Map is Impassable at Stagger Location
        if blocked_dist or not $game_map.passable?(p.x + dist, p.y, 4) or
           not events_cat_passable?(p.x + dist, p.y) 
          # Distance from Player that Map is Impassable for next Actor
          dist = (blocked_dist) ? blocked_dist : dist - 1
          # Value used to prevent processing Passable again as it is expensive
          blocked_dist = dist
        end
        # Place the Caterpillar Actor and set the Direction
        event.moveto(p.x + dist, p.y)
        event.direction = 4 if not event.direction_fix
        # Create Movement Arguments as a Registered Caterpillar Movement
        args = ["move_left",[],[p.x + dist, p.y]]
        # Add the new command to Registered Caterpillar Movements
        @move_list.push([p.move_speed, args, df, d, l])
      when 8 # Up
        # If a Blocked Distance is set or Map is Impassable at Stagger Location
        if blocked_dist or not $game_map.passable?(p.x, p.y - dist, 2) or
           not events_cat_passable?(p.x, p.y - dist)
          # Distance from Player that Map is Impassable for next Actor
          dist = (blocked_dist) ? blocked_dist : dist - 1
          # Value used to prevent processing Passable again as it is expensive
          blocked_dist = dist
        end
        # Place the Caterpillar Actor and set the Direction
        event.moveto(p.x, p.y - dist)
        event.direction = 2 if not event.direction_fix        
        # Create Movement Arguments as a Registered Caterpillar Movement
        args = ["move_down",[],[p.x, p.y - dist]]
        # Add the new command to Registered Caterpillar Movements
        @move_list.push([p.move_speed, args, df, d, l])
      end
      # Increase the Distance to move the next Cat Actor
      dist = (dir != 0) ? dist + 1 : 0  
      # Increase Iterator to measure Distance in Tiles
      i += 1
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Vanish - Game_Caterpillar
  #   - Sets Opacity to 0 for Characters in Caterpillar, including Player
  #----------------------------------------------------------------------------
  def cat_vanish
    # Reset the Transition Flags
    $game_player.dead_effect_transition = false
    $game_player.normal_effect_transition = false
    # Set the Player Opacity to 0
    $game_player.opacity = 0
    # Set the Player Opacity to 0
    $game_player.opacity_duration = 0    
    # Set the Player ALT Opacity to 0
    $game_player.alt_opacity = 0
    if $game_switches[DEAD_ACTOR_EFFECTS] and $game_party.actors[0].dead?
      if DEAD_EFFECT.include? 'DONT_WALK'
        # Set Walk Animation to True if Alive and False if Dead
        $game_player.walk_anime = $game_party.actors[0].dead? ? false : true
      end
      # Check the Dead Effects for Flags on Player
      if DEAD_EFFECT.include?('GHOST')
        # Set the Ghost Flag so Player fades to correct Opacity
        $game_player.opacity_ghost = true
      elsif DEAD_EFFECT.include?('ZOMBIE')
        # Set Visible Flag so Fade Up makes the Zombie appear
        $game_player.zombie_visible = true
      elsif Game_Caterpillar::DEAD_EFFECT.include?('COFFIN')
        # Override - Set the Visible Flag so Fade Up makes the Coffin appear
        $game_player.coffin_visible = true
      elsif Game_Caterpillar::DEAD_EFFECT.include?('ALT_SPRITE')
        # Set the Visible Flag so Fade Up makes the Alt Sprite appear
        $game_player.alt_char_sprite_visible = true        
      end
    end
    # Apply Changes to each Cat Actor
    for actor in @actors
      # Reset the Transition Flags
      actor.dead_effect_transition = false
      actor.normal_effect_transition = false      
      # Set the Actor Opacity to 0
      actor.opacity = 0
      # Set the Actor Opacity to 0
      actor.opacity_duration = 0    
      # Set the Actor Alt Opacity to 0
      actor.alt_opacity = 0
      # If DEAD_ACTOR_EFFECTS are ON and the Actor is Dead
      if $game_switches[DEAD_ACTOR_EFFECTS] and not actor.cat_follower and
         $game_party.actors[actor.actor_index].dead?
        # If DONT_WALK is the Effect to Apply
        if DEAD_EFFECT.include?('DONT_WALK')
          # Change Walk Animation to False
          actor.walk_anime = false
        end
        # If Ghost, Zombie, or Coffin are the current effects...
        if DEAD_EFFECT.include?('GHOST')
          # Set the Ghost Flag so Character fades to correct Opacity
          actor.opacity_ghost = true
        elsif DEAD_EFFECT.include?('ZOMBIE')
          # Set Visible Flag so Fade Up makes the Zombie appear
          actor.zombie = true
          actor.zombie_visible = true
        elsif DEAD_EFFECT.include?('COFFIN')
          # Override - Set the Visible Flag so Fade Up makes the Coffin appear
          actor.coffin = true
          actor.coffin_visible = true
        elsif DEAD_EFFECT.include?('ALT_SPRITE')
          # Set the Visible Flag so Fade Up makes the Alt Sprite appear
          actor.alt_char_sprite = true
          actor.alt_char_sprite_visible = true          
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Refresh - Game_Caterpillar
  #  - Refreshes Events in Caterpillar
  #  - Erases Caterpillar Members when not Paused and Switch set to OFF
  #  - Use Sparingly as it scans all Events for Caterpillar Name Denomination
  #----------------------------------------------------------------------------
  def refresh
    # If Not Active and Not Paused
    if not $game_switches[CATERPILLAR_ACTIVE_SWITCH] and
       not $game_switches[CATERPILLAR_PAUSE_SWITCH]
      # If Constant == true or Switch is Enabled
      if remove_visible_actors?
        # Go through the old actors to see if any should be erased
        for actor in @actors
          # If Actor is an Active Caterpillar Actor
          if @actors.include?(actor)
            # Temporarily Erase the Actor Event
            actor.erase
          end
        end
      end
    end
    # Check if the caterpillar is active
    return unless $game_switches[CATERPILLAR_ACTIVE_SWITCH]
    # If Caterpillar is not Paused
    if not $game_switches[CATERPILLAR_PAUSE_SWITCH]
      # Clear all Caterpillar Data
      clear
    end
    # Check each event if they are Cat Actor Events or not
    for event in $game_map.events.values
      # Checks the Event Name for Caterpillar Name Denomination
      event.check_caterpillar
    end
    # This allows changes to Party without snapping to Player's Position
    if not $game_switches[CATERPILLAR_PAUSE_SWITCH]
      # Center the Caterpillar Events at the Player's Position
      center
      # Used for Z-Index Adjustments
      $game_system.caterpillar.cat_steps = 0
      # If Player facing Up and not Direction Fix
      if $game_player.direction == 8 and not $game_player.direction_fix
        # Set Flag for proper Player Cat Actor Stacking
        $game_player.substack_z = true
      end
    end
    # Update the caterpillar, Graphics for Events changed to the Characters
    update
  end
  #----------------------------------------------------------------------------
  # * Update - Game_Caterpillar
  #  - Manages internal situation of Caterpillar when Active and Refreshed
  #  - Conditional Branch Options are controlled by Game Switches set in Config
  #----------------------------------------------------------------------------
  def update
    # If Caterpillar is not Active or Zero Party
    if not $game_switches[CATERPILLAR_ACTIVE_SWITCH] or
       $game_party.actors.size == 0
      # Caterpillar is Inactive
      return 
    end
    # old_actors is used to Erase those Cat Actors with Option
    old_actors = @actors
    # Reset @actors to Empty Array
    @actors = []
    # For each secondary Party Member in Active Party
    for i in 1...$game_party.actors.size
      # Figure out which Event corresponds to which Character
      event = @actor_id_to_event[$game_party.actors[i].id]
      # If the Event doesn't exist, or is not in the @actors Array
      unless event.nil? or @actors.include?(event)
        # Assigns the Game Party Index (0,1,2,3 etc) not the Actor ID
        event.set_actor_index(i)
        # Unerase Events if the OPTION is Enabled
        event.unerase if remove_visible_actors? and event.erased?
        # If transferring, maintain opacity for Dead Effects
        if @transferring_actors.size > 0
          for old in @transferring_actors
            # If Current Actor has same Caterpillar ID as Old Actor
            if old.caterpillar_actor == event.caterpillar_actor
              # Copy Properties from Old Cat Actor on Map Transfer
              event.opacity = old.opacity
              event.opacity_original = old.opacity_original
              event.opacity_target = old.opacity_target
              event.opacity_duration = old.opacity_duration
              event.opacity_duration_latest = old.opacity_duration_latest
              event.character_hue = old.character_hue
              event.blend_type = old.blend_type
              event.alt_opacity = old.alt_opacity
              event.opacity_ghost = old.opacity_ghost
              event.zombie = old.zombie
              event.coffin = old.coffin
              event.alt_char_sprite = old.alt_char_sprite
              event.zombie_visible = old.zombie_visible
              event.coffin_visible = old.coffin_visible
              event.alt_char_sprite_visible = old.alt_char_sprite_visible
              event.dead_effect_transition = old.dead_effect_transition
              event.normal_effect_transition = old.normal_effect_transition
              # Copied Actor information over so quit iterating array, to next
              break
            end
          end
        end
        # Add Event to the @actors Array for Caterpillar Movement of Event
        @actors << event
        # Changes the Events Graphic to that of the corresponding Actors
        event.character_name = $game_party.actors[i].character_name
        # If Game Switch for Dead Actor Effects is ON
        if $game_switches[DEAD_ACTOR_EFFECTS]
          # If Effects include DONT_WALK for Dead Party Members
          if DEAD_EFFECT.include? 'DONT_WALK'
            # Party Member State of Dead determines Walk Anime
            event.walk_anime = ($game_party.actors[i].dead?) ? false : true
          end
          # Set Appropriate Effects based on DEAD_EFFECTS Config
          if DEAD_EFFECT.include? 'GHOST'
            if $game_party.actors[event.actor_index].dead? and
               event.opacity != DEAD_GHOST_OPACITY and
               not event.opacity_ghost
              # Fade the Caterpillar Actor to the Ghost Opacity
              event.fade_event(DEAD_GHOST_OPACITY, DEAD_GHOST_DURATION)
              event.opacity_ghost = true
            end
          elsif DEAD_EFFECT.include? 'ZOMBIE'
            if $game_party.actors[event.actor_index].dead? and
               event.alt_opacity != ZOMBIE_OPACITY and
               event.zombie != true
              # Set the Zombie Flag and display the Zombie Sprite
              event.zombie = true
              # Set the Transition Flag
              event.normal_effect_transition = false
              event.dead_effect_transition = true
              # Fade Original Sprites Opacity to 0 and Zombie Sprite to Inverse
              event.fade_event(0, ZOMBIE_DURATION)  
            end
          elsif DEAD_EFFECT.include? 'COFFIN'
            if $game_party.actors[event.actor_index].dead? and
               event.alt_opacity != COFFIN_OPACITY and
               event.coffin != true
              # Set the Coffin Flag and display the Coffin Sprite
              event.coffin = true
              # Set the Transition Flag
              event.normal_effect_transition = false
              event.dead_effect_transition = true
              # Fade Original Sprites Opacity to 0 and Coffin Sprite to Inverse
              event.fade_event(0, COFFIN_DURATION)  
            end
          elsif DEAD_EFFECT.include? 'ALT_SPRITE'
            if $game_party.actors[event.actor_index].dead? and
               event.alt_opacity != ALT_SPRITE_OPACITY and
               event.alt_char_sprite != true
              # Set the Flag to display the Alt Char Sprite 
              event.alt_char_sprite = true
              # Set the Transition Flag
              event.normal_effect_transition = false
              event.dead_effect_transition = true
              # Fade Original Sprites Opacity to 0 and Alt Sprite to Inverse
              event.fade_event(0, ALT_SPRITE_DURATION)  
            end            
          end
        end
      end
    end
    # If Caterpillar has any Non Party Followers
    if @follower
      for i in 0...@follower_ids.size
        if @follower_events[@follower_ids[i]].nil?
          if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
            # Explain Missing Event on Map
            print "Warning: This map is missing an Event for",
                  "\\cat_follower[",@follower_ids[i],"]!\n\n",
                  "To fix: Just create an Event on \nthis Map and name it",
                  "\"Something\\cat_follower[",@follower_ids[i],"]."
          end
          # Skip to the Next Follower ID due to error
          next
        end
        # Follower Event
        follower = @follower_events[@follower_ids[i]]
        # If Follower Event is not already in the Caterpillar Actors Array
        if not @actors.include?(follower)
          # Push the Follower on to the Caterpillar Actor Array
          @actors << follower
          # Follower Actor Index is Position in Caterpillar
          follower.set_actor_index($game_party.actors.size + i + 1)
          # Default
          found = false
          # Transfer Old Followers to New Event for Follower from Old Actors
          for old_follower in old_actors
            if old_follower.cat_follower == @follower_ids[i]
              found = true
              break
            end
          end
          # If an Old Follower not found in Old Actors
          if found == false
            # Transfer Old Followers to New Event for Follower via Transfers
            for old_follower in @transferring_actors
              if old_follower.cat_follower == @follower_ids[i]
                found = true
                break
              end
            end
          end
          # If we need to use the Follower Template for the Old Follower
          if found == false
            # Use the Follower Templates instead
            old_follower = @follower_templates[@follower_ids[i]]
          end
          # Transfer Properties on Map Transfer from Old to Current Follower
          follower.character_name = old_follower.character_name
          follower.character_hue = old_follower.character_hue
          follower.blend_type = old_follower.blend_type
          follower.opacity = old_follower.opacity
          follower.opacity_original = old_follower.opacity_original
          follower.opacity_target = old_follower.opacity_target
          follower.opacity_duration = old_follower.opacity_duration
          follower.walk_anime = old_follower.walk_anime
          follower.step_anime = old_follower.step_anime
          follower.direction_fix = old_follower.direction_fix
          follower.direction_fix_last = old_follower.direction_fix_last
          # Check for Empty Names for Followers (Vehicle Bugfix Map Transfer)
          if follower.character_name == ""
            # Shorthand
            fix_name = @follower_templates[@follower_ids[i]].character_name
            # Get just the Character Name from Duplicate Template Event
            follower.character_name = fix_name
          end
        end
      end
    end
    # Reset the Temporary Array for Transferring Maps
    @transferring_actors = []
    # If Constant of REMOVE_VISIBLE_ACTORS is true or Switch is Enabled
    if remove_visible_actors?
      # Go through the old actors to see if any should be erased
      for actor in old_actors
        # if new @actors doesnt include that actor
        unless @actors.include?(actor)
          # Erases the Event for that Cat Actor (can be undone with unerase)
          actor.erase
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Unerase All - Game_Caterpillar
  #  - Unerase all erased Actor Events
  #----------------------------------------------------------------------------
  def unerase_all
    for event in @actor_id_to_event.values
      event.unerase
    end
  end
  #----------------------------------------------------------------------------
  # * Erase Non Party Events - Game Caterpillar
  #  - Erase Caterpillar Actor Events that do not correspond to the Party
  #----------------------------------------------------------------------------
  def erase_non_party_events
    for event in @actor_id_to_event.values
      event.erase unless @actors.include?(event)
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Speed - Game_Caterpillar
  #  - Sets a New Speed for the entire Caterpillar, including Player
  #      new_speed : Movement Speed (3, 4, 5, etc...)
  #----------------------------------------------------------------------------
  def cat_speed(new_speed)
    $game_player.move_speed = new_speed
    for actor in @actors
      actor.move_speed = new_speed
    end
    for move in @move_list
      move[0] = new_speed
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Event - Game_Caterpillar
  #  - Fades Entire Caterpillar At Same Time, INCLUDING Player
  #      opacity  : Opacity Fade Target
  #      duration : Time in Frames of Fade
  #      player   : (Optional - Default: true) Include the Player in Fade
  #----------------------------------------------------------------------------
  def cat_fade_event(opacity, duration, player = true)
    # Fade the Player if Argument is true
    $game_player.fade_event(opacity, duration) if player
    # For each Caterpillar Actor or Follower
    for actor in @actors
      # Fade each Cat Actor
      actor.fade_event(opacity, duration)
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Event Reset - Game_Caterpillar
  #  - Restores Entire Caterpillar At Same Time, INCLUDING Player
  #      duration : Time in Frames for Fade Transition
  #----------------------------------------------------------------------------
  def cat_fade_event_reset(duration)
    # Fade the Player
    $game_player.fade_event_reset(duration)
    for actor in @actors
      # Fade each Cat Actor
      actor.fade_event_reset(duration)
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Position Filled? - Game_Caterpillar
  #  - Returns True or False if a Position in the Caterpillar has an Actor
  #      position : Party Index (1 for Player, 2 for Cat Actor 1, etc...)
  #----------------------------------------------------------------------------
  def cat_position_filled?(position)
    # If the Position is not nil
    if not @actors[position-1].nil?
      return true 
    else
      return false
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Generate Moves - Game_Caterpillar
  #  - Generates Move Routes for Cat Actors
  #----------------------------------------------------------------------------
  def cat_generate_moves
    # Empty the current Move List
    @move_list.clear
    # Shorthand for Player Variables to be sent to the Caterpillar
    move_speed = $game_player.move_speed
    x = $game_player.x
    y = $game_player.y
    d = $game_player.direction
    df = $game_player.direction_fix
    l = $game_player.using_ladder
    # Stores X and Y coordinates when Jumping
    jump_target = []
    # Branch by Direction to create Arguments for Caterpillar Movement    
    case $game_player.last_moved_direction
    when 2 # Down
      args = ["move_down",jump_target,[x,y]]
    when 4 # Left
      args = ["move_left",jump_target,[x,y]]
    when 6 # Right
      args = ["move_right",jump_target,[x,y]]
    when 8 # Up
      args = ["move_up",jump_target,[x,y]]
    end
    # If Cat Actor exists and not same location as Player
    if args and @actors[0] and @actors[0] != x and @actors[0] != y
      # Add the new command        
      @move_list.push([move_speed, args, df, d, l])
    end
    # Start Caterpillar Actors at 2nd Caterpillar Actor
    for i in 2..@actors.size
      # Get Cat Actors current Direction
      temp_dir = @actors[i-1].direction
      # Turn Cat Actor toward previous Cat Actor to get Move Direction
      @actors[i-1].turn_toward_event(@actors[i-2].id)
      # Store New Direction
      new_dir = @actors[i-1].direction
      # Reset their Direction
      @actors[i-1].direction = temp_dir
      # Set Up the Move List Variables
      x = @actors[i-2].x
      y = @actors[i-2].y
      d = new_dir
      df = @actors[i-2].direction_fix
      l = @actors[i-2].using_ladder
      # Next Direction is based on the Direction Cat Actor has to turn   
      case new_dir
      when 2 # Down
        args = ["move_down",jump_target,[x,y]]
      when 4 # Left
        args = ["move_left",jump_target,[x,y]]
      when 6 # Right
        args = ["move_right",jump_target,[x,y]]
      when 8 # Up
        args = ["move_up",jump_target,[x,y]]
      end      
      # If not same Location as Previous Cat Actor
      if args and @actors[i-1] != x and @actors[i-1] != y
        # Add the new command        
        @move_list.push([move_speed, args, df, d, l])
      end
    end
  end
end

#--------------------------------------------------------------------------
# ** Fade Events (Module)
#--------------------------------------------------------------------------
module Fade_Events
  #--------------------------------------------------------------------------
  # * Fade Event - Fade Events (Module)
  #  - Smooth Transition to Opacity over Time
  #     opacity_target   : Target Opacity (0 to 255)
  #     opacity_duration : Duration in Frames
  #--------------------------------------------------------------------------
  def fade_event(opacity_target, opacity_duration)
    # If Error Reporting is On and not a Release Game
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
      if opacity_target.nil? or opacity_duration.nil?
        print "fade_event(opacity, duration) expects Two Arguments\n"
        return
      elsif not opacity_target.is_a? Numeric
        print "\"", opacity_target, "\" is not an Number!\n",
              "Both Arguments should be Numbers!\n\n",
              "I.E. fade_event(255,20)"
        return
      elsif not opacity_duration.is_a? Numeric
        print "\"", opacity_duration, "\" is not an Number!\n",
              "Both Arguments should be Numbers!\n\n",
              "I.E. fade_event(255,20)"
        return
      elsif opacity_target < 0 or opacity_target > 255
        print "\"", arg_opacity_target, "\" Opacity Out of Range\n",
              "Valid Range: 0 - 255"
      elsif opacity_duration < 0
        print "\"", opacity_target, "\" Duration Out of Range\n",
              "Valid Range: Any Positive Number or 0"
      end
    end
    # If Original Opacity is not yet Stored
    if not @opacity_original
      # Store the Original Value
      @opacity_original = @opacity
    end
    # If Party and no other Transition taking place
    if @opacity_duration > 0 and (self == $game_player or
       $game_system.caterpillar.cat_actor_in_party?(self) )
      # Set New Opacity To Fade To
      @opacity_target_latest = opacity_target * 1.0
      # Set Opacity Change Duration
      @opacity_duration_latest = opacity_duration
    # If no other Fade Event Transitions are occuring
    else
      # Set Opacity Target from Argument
      @opacity_target = opacity_target * 1.0
      # Set Opacity Duration from Argument
      @opacity_duration = opacity_duration
      # If Opacity Target matches current Opacity
      if @opacity == opacity_target and not $game_map.need_refresh
        # Reset the Duration to 0 since no Fade Event is taking place
        #@opacity_duration = 0
      end
      # If No Duration or End of Fade Event Opacity Duration
      if @opacity_duration == 0
        # Set Current Opacity to the Change To Opacity
        @opacity = @opacity_target
      end
    end
  end
  #----------------------------------------------------------------------------
  #  * Change Event Opacity - Fade Events (Module)
  #   - Changes an Event's Opacity and Alt Opacity after Fade Event is called
  #   - Alternate Sprite Opacity is Inverse of Opacity, so when Opacity
  #     is < 255 then the Alternate Zombie, Coffin, or Character Sprite 
  #     is set to the Inverse.  
  #   - Example: Opacity is 200, then Alt Opacity is 55 during Fade
  #----------------------------------------------------------------------------
  def change_event_opacity
    # Manage change in Event Opacity Level
    if @opacity_duration > 0 or @opacity_duration_latest > 0
      # Shorthand Local Variables
      t = @opacity_target
      d = @opacity_duration
      # Calculate Opacity Change for Main Sprite
      @opacity = (@opacity * (d - 1) + t) / d if d > 0
      # If a Dead or Normal Effect Transition is occuring
      if ($game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS] and
          @dead_effect_transition) or
         (@normal_effect_transition and 
           ((@zombie_visible and @zombie) or 
            (@coffin_visible and @coffin) or 
            (@alt_char_sprite and @alt_char_sprite_visible)))
        # Calculate Alt Sprite Opacity (o) as Inverse of Opacity Constants
        o = Game_Caterpillar::ZOMBIE_OPACITY - @opacity if @zombie
        o = Game_Caterpillar::COFFIN_OPACITY - @opacity if @coffin
        o = Game_Caterpillar::ALT_SPRITE_OPACITY - @opacity if @alt_char_sprite
        # Assign New Opacity (o)
        @alt_opacity = o
      elsif (@zombie_visible and @zombie) or 
            (@coffin_visible and @coffin) or 
            (@alt_char_sprite and @alt_char_sprite_visible)
        # Shorthand
        t = @opacity_target
        d = @opacity_duration
        # If Transition is Scheduled
        unless @opacity_target_latest.nil? or @opacity_duration_latest.nil?
          # Shorthand for Scheduled Transition
          t = @opacity_target_latest
          d = @opacity_duration_latest
        end
        # Transition Opacity of Alt Sprite
        @alt_opacity = (@alt_opacity * (d - 1) + t) / d
        # If Dead Actor Effects Game Switch is Off
        if not $game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS]
          # Check Visibility for Alt Character Sprites
          @zombie_visible = false if @alt_opacity == 0
          @coffin_visible = false if @alt_opacity == 0
          @alt_char_sprite_visible = false if @alt_opacity == 0
        end
        # If Fading while an Alt Sprite is visible
        if not @dead_effect_transition and not @normal_effect_transition and
           @alt_opacity > 0
          # Keep Characters Opacity at 0 
          @opacity = 0
        end
      end
      # Count Down to 0 to end Opacity Change
      @opacity_duration -= 1 if @opacity_duration > 0
    end    
  end
  #----------------------------------------------------------------------------
  # * Fade Event Reset - Fade Events (Module)
  #  - Reset Event Opacity to Opacity Original
  #      opacity_duration : time in frames
  #----------------------------------------------------------------------------
  def fade_event_reset(opacity_duration = nil)
    # If Argument has a Value passed
    if not opacity_duration.nil?
      # If Party and another Fade Event Transition is occuring
      if @opacity_duration > 0 and (self == $game_player or
         $game_system.caterpillar.cat_actor_in_party?(self) )
        # Set New Opacity To Fade To
        @opacity_target_latest = @opacity_original * 1.0
        # Set Opacity Change Duration
        @opacity_duration_latest = opacity_duration
        # If End of Change Opacity Duration
        if @opacity_duration_latest == 0 or 
           @opacity * 1.0 == @opacity_target * 1.0
          # Clear the scheduled Opacity Change
          @opacity_duration_latest = nil
          # Set Current Opacity to the Change To Opacity
          @opacity = @opacity_target
        end
      # If No Fade Event Transitions occuring and not Original Opacity
      elsif @opacity != @opacity_original
        # Set New Opacity To Fade To
        @opacity_target = @opacity_original * 1.0
        # Set Opacity Change Duration
        @opacity_duration = opacity_duration
        # If No Duration
        if opacity_duration == 0
          # Set Current Opacity to the Change To Opacity
          @opacity = @opacity_target
        end
      end
    else
      # Just set the Opacity to the Original Opacity
      @opacity = @opacity_original * 1.0
      # Set the Duration to 0
      @opacity_duration = 0
      # Clear scheduled Fade Event
      @opacity_duration_latest = nil
    end
  end
end

#==============================================================================
# ** Game_Character
#==============================================================================
class Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables - Game_Character
  #--------------------------------------------------------------------------  
  attr_accessor   :direction                   # Character Direction
  attr_accessor   :direction_fix               # Characters Can't Turn
  attr_accessor   :direction_fix_last          # Last State of Direction Fix
  attr_accessor   :direction_last              # Last Direction
  attr_accessor   :move_route                  # Character's Move Route
  attr_accessor   :character_name              # Character's Graphic
  attr_accessor   :character_hue               # Character's Hue
  attr_accessor   :blend_type                  # Character's Blend Type
  attr_accessor   :opacity                     # Character's Opacity
  attr_accessor   :opacity_original            # Character's Original Opacity
  attr_accessor   :opacity_target              # Character's New Fade Opacity
  attr_accessor   :opacity_target_latest       # Scheduled New Fade Opacity
  attr_accessor   :opacity_duration            # Duration of Opacity Transition
  attr_accessor   :opacity_duration_latest     # Scheduled New Fade Duration
  attr_accessor   :opacity_ghost               # Opacity of Ghosts when Dead
  attr_accessor   :original_move_route         # Stores Move Route when Forced
  attr_accessor   :move_route_index            # Index of Move Route Commands
  attr_accessor   :original_move_route_index   # Stored Index Move Route Forced
  attr_accessor   :move_route_wait_excluded    # Ignore Wait for Move Complete
  attr_accessor   :alt_opacity                 # Opacity of Alternate Sprite
  attr_accessor   :zombie                      # Zombie Effect Enabled
  attr_accessor   :zombie_visible              # Zobmie Sprite Visible
  attr_accessor   :coffin                      # Coffin Effect Enabled
  attr_accessor   :coffin_visible              # Coffin Sprite Visible
  attr_accessor   :alt_char_sprite             # Alt Character when Dead
  attr_accessor   :alt_char_sprite_visible     # Alt Sprite Visible
  attr_accessor   :alt_character_name          # Alternate Character Graphic
  attr_accessor   :need_new_sprite             # when Changing Graphic Files
  attr_accessor   :dead_effect_transition      # Used for Managing Alt Sprites
  attr_accessor   :normal_effect_transition    # Used for Managing Alt Sprites
  attr_accessor   :using_ladder                # Party Ladder Status
  attr_accessor   :move_speed                  # Movement Speed Exponent
  attr_accessor   :sprite_zoom_x               # Sprite Zoom X Value
  attr_accessor   :sprite_zoom_y               # Sprite Zoom X Value
  attr_accessor   :dont_update_sprite          # Anti Lag Property
  attr_reader     :pages                       # Page List of Event Commands
  attr_reader     :caterpillar_actor           # Event Follows Player
  attr_reader     :actor_index                 # Index of Party Member for Cat
  attr_reader     :wait_count                  # Delay before Move Commands
  #--------------------------------------------------------------------------
  # * Fade_Events (Module) - Game_Character
  #  - Makes Fade Event Module Methods and Properties available to this Class
  #--------------------------------------------------------------------------  
  include Fade_Events
  #----------------------------------------------------------------------------
  # * Initialize - Game_Character
  #  - Adds Properties for managing Fade Event with Dead Effects
  #----------------------------------------------------------------------------
  alias fade_events_initialize initialize unless $@
  def initialize
    # Initilaize Original First
    fade_events_initialize
    # Added Properties for Fade
    @opacity_original = @opacity * 1.0
    @opacity_target = @opacity_original
    @opacity_duration = 0
    @opacity_duration_latest = nil
    @opacity_target_latest = nil
    @opacity_ghost = false
    # Added Properties for Inflicted States
    @zombie = false
    @zombie_visible = false
    @coffin = false
    @coffin_visible = false
    @alt_char_sprite = false
    @alt_char_sprite_visible = false
    @need_new_sprite = false
    @dead_effect_transition = false
    @normal_effect_transition = false
    @alt_opacity = 0
    # Game Player Only
    @actor_index = 0 if self.is_a?(Game_Player)
    # New Interpreter Bugfix
    @move_route_wait_excluded = false
    # Used to prevent Player Movement thru Cat Actors while Cat is on a Ladder
    @using_ladder = false
    # Stores Player's Direction regardless of Direction Fix for Ladder
    @last_moved_direction = 0 if self.is_a?(Game_Player)
    @direction_fix_last = nil
    @direction_last = nil
  end
  #----------------------------------------------------------------------------
  # * Update (frame) - Game_Character
  #  - Updates calls to Fade Event and Effects
  #----------------------------------------------------------------------------
  alias fade_events_update update unless $@
  def update
    # Allow the Character's Sprite to Update (Anti Lag)
    @dont_update_sprite = false    
    # Run Original or other Aliases for Updating Character
    fade_events_update
    # If Opacity is changing during Fade Events
    if @opacity_duration > 0 or 
       (@opacity_duration_latest and @opacity_duration_latest > 0)
      # Manages the Events Current Opacity
      change_event_opacity
    # if Alternate Sprites are fully visible
    elsif ((@zombie_visible and @zombie) or 
           (@coffin_visible and @coffin) or
           (@alt_char_sprite and @alt_char_sprite_visible)) and
            @opacity != 0 and @alt_opacity != 0 and
           not $game_system.caterpillar.actors_fade_in and
           not $game_system.caterpillar.actors_fade_out and
           not $game_system.caterpillar.fade_back_in
      # Apply Fade to the Alternate Sprite
      @alt_opacity = @opacity
      # Reset Original Opacity to 0
      @opacity = 0
    end
    # Resets to Non Ghost, Non Zombie, and Non Coffin, and Non Alternate
    if ( (@caterpillar_actor or @cat_follower) and
       $game_system.caterpillar.cat_actor_in_party?(self) or
       self.is_a?(Game_Player) ) and
       not $game_system.caterpillar.is_cat_actor_dead?(self)
      # Shorthand
      effects = Game_Caterpillar::DEAD_EFFECT
      # If Disabling an Effect for Ghosts
      if self.opacity_ghost and effects.include?('GHOST')
        # Reset the Event to its original non ghost opacity
        @opacity_ghost = false
        # Restore the Character to Original Opacity
        fade_event(@opacity_original, Game_Caterpillar::DEAD_GHOST_DURATION)
      # If Disabling an Effect for Zombies
      elsif @zombie and effects.include?('ZOMBIE')
        # If Disabling an Effect for Zombies and End of Fade Transition
        if @opacity_duration == 0 and @zombie and @opacity == @opacity_original
          # Hides the Zombie Sprite and prevents Endless Loops
          @zombie = false
        # If Disabling an Effect for Zombies while Zombie Sprite is Visible
        elsif @opacity_duration == 0 and @zombie
          # Set the Transition Flag to allow Both Sprites to be Visible
          @dead_effect_transition = false
          @normal_effect_transition = true
          # Reset the Party Characters to Original Opacity with Fade
          fade_event(@opacity_original, Game_Caterpillar::ZOMBIE_DURATION)
        end
      # If Disabling an Effect for Coffins
      elsif @coffin and effects.include?('COFFIN')
        # If Disabling an Effect for Coffins and End of Fade Transition
        if @coffin and @opacity_duration == 0 and @opacity == @opacity_original
          # Hides the Coffin Sprite and prevents Endless Loops
          @coffin = false
        # If Disabling an Effect for Coffins while Coffin Sprite is Visible
        elsif @opacity_duration == 0 and @coffin == true
          # Set the Transition Flag to allow Both Sprites to be Visible
          @dead_effect_transition = false
          @normal_effect_transition = true
          # This resets the Event or Player to Original Opacity with Fade
          fade_event(@opacity_original, Game_Caterpillar::COFFIN_DURATION)
        end
      # If Disabling an Effect for Alternate Dead Character Sprites
      elsif @alt_char_sprite and effects.include?('ALT_SPRITE')
        # Reset the Event to its original non Alt Sprite opacity
        if @alt_char_sprite and @opacity_duration == 0 and 
           @opacity == @opacity_original
          # Hide the Alternate Dead Character Sprite and prevents Endless Loops
          @alt_char_sprite = false
        # If Disabling an Effect for Alt Sprite while Alt Sprite is Visible
        elsif @alt_char_sprite == true and @opacity_duration == 0
          # Set the Transition Flag to allow Both Sprites to be Visible
          @dead_effect_transition = false
          @normal_effect_transition = true
          # This resets the Event or Player to Original Opacity with Fade
          fade_event(@opacity_original, Game_Caterpillar::ALT_SPRITE_DURATION)
        end        
      end        
    end
    # Reset Transition Flag at End of Transition
    if @dead_effect_transition and @opacity_duration == 0
      # Reset the Dead Effect Transition to prevent Alt Sprite from Visible
      @dead_effect_transition = false
      # NOTE: @normal_effect_transition is reset elsewhere
    end
    # If two Fade Event Transitions are called to take place
    if not @opacity_target_latest.nil? and 
       not @opacity_duration_latest.nil? and @opacity_duration == 0
      # Transfer the Properties of the scheduled Fade Event Transition
      @opacity_duration = @opacity_duration_latest
      @opacity_duration_latest = nil
      @opacity_target = @opacity_target_latest
      @opacity_target_latest = nil
    end
  end
  # If this method is not provided by Heretic's Loop Maps
  unless method_defined?(:float_screen_y_adjust)
    #------------------------------------------------------------------------
    # * Float Screen Y Adjust - Game_Character
    #  - Returns value of Floating and Offset Sprites
    #  - Method is intended to be defined in other scripts to fallback to this
    #------------------------------------------------------------------------
    def float_screen_y_adjust
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # * Sprite On Screen? - Game_Character
  #  - Returns True when Character's Sprite is visible on or close to Screen
  #  - The Looping Map version is very inefficient.  If anyone has any
  #    advice on how to do this more efficiently, please let me know!
  #--------------------------------------------------------------------------
  def sprite_on_screen?
    # If Map is Looping
    if $game_map.loop?
      # Display Width and Display Height (for High Resolution in Theory)
      dw = Game_Caterpillar::CAT_SCREEN_X / 2 # usually 320 non Hi Res
      dh = Game_Caterpillar::CAT_SCREEN_Y / 2 # usually 240 non Hi Res
      # Offscreen Update in Tile Distances times Pixels per Tile
      cod = Game_Caterpillar::CAT_OFFSCREEN_DIST * 128
      # Size of Sprite for Update, x / 2 for Center and Offscreen Distance
      sprite_x = (@sprite_size_x ? @sprite_size_x / 2 : 16) + cod
      sprite_y = (@sprite_size_y ? @sprite_size_y : 32) + cod
      sprite_y += float_screen_y_adjust
      # Display X and Display Y with Size of Sprite Adjustment
      dx = 384 + sprite_x # 12 tiles * 32 pixels = 384
      dy = 288 + sprite_y #  9 tiles * 32 pixels = 288
      ax = screen_x - dw
      ay = screen_y - dh
      # Returns True if Sprite is On or Close to the Screen
      return ax >= -dx && ax <= dx && ay >= -dy && ay <= dy
    # Non Looping Map
    else
      # Display Limits
      display_x = $game_map.display_x - 512       # 256
      display_y = $game_map.display_y - 512       # 256
      display_width = $game_map.display_x + 3000  # 2820
      display_height = $game_map.display_y + 2600 # 2180
      # If too far off screen
      if @real_x <= display_x or
         @real_x >= display_width or
         @real_y <= display_y or
         @real_y >= display_height
        # Invalid
        return false
      end
      # Sprite is On Screen
      return true
    end
  end
  #--------------------------------------------------------------------------
  # * Set Sprite Size - Game_Character
  #  - Sets the Display Size of the Sprite and adjusts for Zoom Values
  #--------------------------------------------------------------------------
  def set_sprite_size(x, y, zoom_x, zoom_y)
    @sprite_size_x = x * zoom_x if not x.nil?
    @sprite_size_y = y * zoom_y if not y.nil?
  end
  #----------------------------------------------------------------------------
  # * Set Actor Index - Game_Character
  #  - Sets the Actors Index in Game Party - IE 0,1,2,3 regardless of Event ID
  #  - To be Depreceated in future releases
  #      index : Actor Index in Game Party
  #----------------------------------------------------------------------------
  def set_actor_index(index)
    # New Property reflects the Actors Position in $game_party.actors
    @actor_index = index
  end
  #----------------------------------------------------------------------------
  #
  #                ***  MODULAR PASSABLE COMPATABILITY  ***
  #
  #----------------------------------------------------------------------------
  # If Heretics Modular Passable Script available above this one
  if $Modular_Passable
    #--------------------------------------------------------------------------
    # * Character Passable? - Game_Character
    #  - Detects Event and Player Collisions modified for Caterpillar
    #     x : x-coordinate
    #     y : y-coordinate
    #     d : direction (0,2,4,6,8)
    #         * 0 = Determines if all directions are impassable (for jumping)
    #--------------------------------------------------------------------------
    alias caterpillar_off_map_character_passable? passable? unless $@
    def passable?(x, y, d)
      # If Event is Through and is allowed to go OFF MAP (Set by Name \off_map)
      if @through and @allowed_off_map
        # Passable - Events are allowed to move to Invalid Coordinates
        return true
      end
      # If Global Variable $walk_off_map is turned on
      if $walk_off_map == true
        # If Player or Active Cat Actor (in the party) trying to move Off Map
        if self == $game_player or ((@caterpillar_actor or @cat_follower) and
           $game_system.caterpillar.actors.include?(self))
          # Passable - True for Player and Cat Actors allowed Off Map
          return true
        end
      end
      # Call Original or other Aliases
      return caterpillar_off_map_character_passable?(x, y, d)
    end
    #--------------------------------------------------------------------------
    # * Caterpillar Moves List Other Passable? - Game_Character
    #  - Cat Actors are Impassable even if they are flagged Through
    #     x      : x-coordinate
    #     y      : y-coordinate
    #     d      : direction (0,2,4,6,8)
    #           * 0 = Determines if all directions are impassable (for jumping)
    #     new_x  : Target X Coordinate
    #     new_y  : Target Y Coordinate
    #     result : true or false passed as an arg by Aliases
    #--------------------------------------------------------------------------
    alias cat_moves_list_other_passable? other_passable? unless $@
    def other_passable?(x, y, d, new_x, new_y, result = nil)
      # If Through is off and not a Game Player
      if result.nil? and self != $game_player
        # If not an Active Cat Actor or Follower
        if (@caterpillar_actor.nil? and @cat_follower.nil?) or
           not $game_system.caterpillar.actors.include?(self)
          # If Caterpillar is Active and not Paused using Game Switches
          if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
             not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH]
            # If Event is trying to move to a position occupied by Cat Actors
            if $game_system.caterpillar.in_move_list?(x, y, d, new_x, new_y)
              # Impassable - Occupied by Caterpillar Movement
              result = false
            end
          end
        end
      end
      # Call Original or other Aliases
      cat_moves_list_other_passable?(x, y, d, new_x, new_y, result)
    end
    #--------------------------------------------------------------------------
    # * Event Character Not Passable? - Game_Character
    #  - Allows Player and Cat Actors / Followers to move through each other
    #  - Checks for Ladder Tile Usage
    #     x     : x-coordinate
    #     y     : y-coordinate
    #     d     : direction (0,2,4,6,8)
    #             * 0 = Determines if all directions are impassable (jumping)
    #     new_x : Target X Coordinate
    #     new_y : Target Y Coordinate
    #     event : Event being checked against in iteration loop
    #     result : true or false passed as an arg by Aliases    
    #--------------------------------------------------------------------------
    alias cat_character_not_passable? event_character_not_passable? unless $@
    def event_character_not_passable?(x,y,d, new_x, new_y, event, result = nil)
      # If Caterpillar is Active and not Paused using Game Switches
      if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
         not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH]
        # If Player or Cat Actors moving through each other
        if ((self == $game_player and Game_Caterpillar::PASS_SOLID_ACTORS) or
           $game_system.caterpillar.actors.include?(self)) and
           $game_system.caterpillar.actors.include?(event)
          # If Option to move through Cat Actors is off and Target on Ladder
          if self == $game_player and
             not $game_system.caterpillar.pass_actors_on_ladders and
             $game_system.caterpillar.is_using_ladder?(event)
            # Impassable - True that Player can not move through on Ladders
            result = true
          else
            # Passable - False that this Event is not Not Passable, so Passable
            result = false
          end
        end
      end
      # Call Original or other Aliases
      cat_character_not_passable?(x, y, d, new_x, new_y, event, result)
    end
  #----------------------------------------------------------------------------
  #
  #               ***  NON MODULAR PASSABLE METHODS  ***
  #
  #----------------------------------------------------------------------------
  else # $Modular_Passable isnt available
    #--------------------------------------------------------------------------
    # * Heretic Cat Character Passable? - Game_Character
    #  - Prohibits passage unless the conditions are met
    #  - Used by Passable? in default Game_Character method definition
    #      event : Iterated Event in Character Passable
    #--------------------------------------------------------------------------
    def heretic_cat_character_passable?(event)
      # If Pass Solid Actors is on, and Not Paused, and Active
      unless $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
             $game_system.caterpillar.cat_actor_in_party?(event) and
             Game_Caterpillar::PASS_SOLID_ACTORS and
             ($game_system.caterpillar.pass_actors_on_ladders or
             not $game_system.caterpillar.is_using_ladder?(event)) and
             ($game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
             not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH])
        # Impassable
        return false
      end
      # Conditions allow Passage
      return true
    end
    #--------------------------------------------------------------------------
    # * Passable? - Game_Character (REDEFINITION)
    #  - Determine if Passable
    #  - This method is used when Modular Passable is not available
    #  - Place Modular Passable Script as its own script ABOVE Caterpillar
    #  - Can cause compatability issues with other scripts due to redefinition
    #  - Recommend to use Heretic's Modular Passable to increase Compatability
    #    so that this method does not need to be redefined
    #  - Redefinition was needed due to nesting of checks where Events are
    #    prohibited from moving into the Caterpillar, and Caterpillar Events
    #    can move through each other and the Player
    #     x : x-coordinate
    #     y : y-coordinate
    #     d : direction (0,2,4,6,8)
    #         * 0 = Determines if all directions are impassable (for jumping)
    #--------------------------------------------------------------------------
    def passable?(x, y, d)
      # If Global Variable $walk_off_map and Player or Caterpillar Actor
      if $walk_off_map == true and (self == $game_player or 
         $game_system.caterpillar.actors.include?(self))
        # Allows OFF MAP Movement for Player and Active Caterpillar Actors
        return true
      end
      # If Through is OFF and not Player or Cat Actor and in Cat Movement
      if not @through and self != $game_player and
         not $game_system.caterpillar.cat_actor_in_party?(self)
        # If Event is trying to move to a position occupied by the Cat Actors
        if $game_system.caterpillar.in_move_list?(x, y, d)
          # Impassable - Location occupied by Caterpillar
          return false
        end
      end
      # If Through is ON and has an Allowed Off Map property
      if @through and @allowed_off_map
        # Passable - All movement, even Off Map is allowed
        return true
      end
      # Get new coordinates
      new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
      new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
      # If coordinates are outside of map
      unless $game_map.valid?(new_x, new_y)
        # impassable
        return false
      end
      # If through is ON
      if @through
        # passable
        return true
      end
      # If unable to leave first move tile in designated direction
      unless $game_map.passable?(x, y, d, self)
        # impassable
        return false
      end
      # If unable to enter move tile in designated direction
      unless $game_map.passable?(new_x, new_y, 10 - d)
        # impassable
        return false
      end
      # Loop all events
      for event in $game_map.events.values
        # If event coordinates are consistent with move destination
        if event.x == new_x and event.y == new_y
          # If through is OFF or Cat Actor thru Cat Actor
          unless event.through 
            # If self is event not a Player
            if self != $game_player
              # impassable
              return false
            end
            # With self as the player and partner graphic as character
            if event.character_name != ""
              # If Switches, Options and Conditions do not allow passage
              if not heretic_cat_character_passable?(event)
                # impassable
                return false
              end
            end
          end
        end
      end
      # If player coordinates are consistent with move destination
      if $game_player.x == new_x and $game_player.y == new_y
        # If through is OFF
        unless $game_player.through
          # If your own graphic is the character
          if @character_name != ""
            # impassable
            return false
          end
        end
      end
      # passable
      return true
    end
  end # Ends two alternate definitions of Passable if $Modular_Passable
  #--------------------------------------------------------------------------
  # * Set Dead Animation - Game_Character
  #   - Sets the Cat Actor and Player Walk Animations ON and OFF for each step
  #       unset : Make checks for Dead occur now instead of next step
  #--------------------------------------------------------------------------
  def set_dead_animation(unset=false)
    # If manually called
    if unset != false
      # This allows for Manual calls to Reset
      $walk_has_been_set = false;
    end
    # Resets Caterpillar Actor Walk Animation to Default of Event
    if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH]
      # If Player has taken a step and this needs to run again
      if not $walk_has_been_reset and 
         not $game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS] and
         not $game_system.caterpillar.actors_fade_in and
         not $game_system.caterpillar.actors_fade_out and
         not $game_system.caterpillar.fade_back_in
        # If DEAD_EFFECT has DONT_WALK in the Array
        if Game_Caterpillar::DEAD_EFFECT.include? 'DONT_WALK'
          # Resets the Player and Caterpillar Actors to Default Walk Flags
          $game_system.caterpillar.walk_reset
        end
        # Determine Dead Effect Type
        if Game_Caterpillar::DEAD_EFFECT.include? 'GHOST'
          # Resets the Player and Caterpillar to Default Opacity with a Fade
          $game_system.caterpillar.ghost_reset
        elsif Game_Caterpillar::DEAD_EFFECT.include? 'ZOMBIE'
          # Resets the Player and Cat Actors to Original Opacity with a Fade
          $game_system.caterpillar.zombies_reset
        elsif Game_Caterpillar::DEAD_EFFECT.include? 'COFFIN'
          # Resets the Player and Cat Actors to Original Opacity with a Fade
          $game_system.caterpillar.coffins_reset
        elsif Game_Caterpillar::DEAD_EFFECT.include? 'ALT_SPRITE'
          # Resets the Player and Cat Actors to Original Opacity with a Fade
          $game_system.caterpillar.alt_sprite_reset
        end
      # If Dead Effects have not been checked for this Player Step
      elsif $walk_has_been_set != true and
            $game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS]
        # Checks for Dead Actors once for each Player Step
        $game_system.caterpillar.dead_walk_animation
      end
    end  
  end
  #----------------------------------------------------------------------------
  # * Screen Z - Game_Character
  #  - Cat Actor's Z-Index is based on their Index in the Party
  #  - Index of 0 (Player) is on top, 3 is lower
  #  - When the Caterpillar is Stacked, if Player faces up, Indexes are reverse
  #     so the last Caterpillar Member is on top.  Used with Cat to Player
  #  - Cat Actors always Render as Tall Sprites minus their Cat Index
  #          height : Character Graphic Height  
  #----------------------------------------------------------------------------
  alias caterpillar_screen_z screen_z unless $@
  def screen_z(height = 0)
    # If Character has Always On Top set to ON
    if @always_on_top
      # If Event is Caterpillar Actor or Follower
      if @caterpillar_actor or @cat_follower
        # Get the Actor's Position in the Game Party
        if @caterpillar_actor
          actor_index = $game_actors[@caterpillar_actor].index
        end
        # Use assigned Index for Followers that arent a part of the Game Party
        actor_index = @actor_index if @cat_follower
        # If Cat Actor Event's Actor is in the Party
        if actor_index
          # Allows Events to be Above Always On Top Characters
          return 998 - actor_index
        end 
      else
        # 999, unconditional
        return 999
      end 
    end
    # If Event is a Caterpillar Actor or Follower
    if @caterpillar_actor or @cat_follower
      # Index is the Event's Position in the Caterpillar
      actor_index = $game_system.caterpillar.actors.index(self)
      # If Cat Actor Events Actor is in the Party, otherwise nil
      if actor_index
        # Adjust Actor Index for Non Zero
        actor_index += 1
        # Shorthand
        steps = $game_system.caterpillar.cat_steps
        cat_size = $game_system.caterpillar.actors.size + 1
        # If Cat Actor or Follower is facing Up and should still be on Top
        if @direction == 8 and steps < cat_size
          # Cat Actors always Render as Tall Sprites minus their Cat Index
          if $game_system.caterpillar.cat_steps <= actor_index
            # Facing Up so Last Caterpillar Members display above others
            return caterpillar_screen_z + 31 - cat_size + actor_index
          else
            # Player is on top, then sequence by Actor Index in Caterpillar
            return caterpillar_screen_z + 31 - actor_index
          end
        else
          # Keep Caterpillar Members stacked correctly
          actor_index -= 1 if actor_index == cat_size + 1 and @direction == 8
          # Cat Actors always Render as Tall Sprites minus Adjustments
          return caterpillar_screen_z + 31 - actor_index
        end
      end
    end
    # If Event has a \z_flat[int] string in Event Name and Always On Top is OFF
    if not @z_flat.nil? and not @always_on_top
      # Consider the Sprites Size and Adjust for it
      flat_height = (height != 0 and not height.nil?) ? height : 0
      # Calculate new Z-Index with Adjustments      
      adjusted_z = (@real_y - $game_map.display_y + 3)/4 + @z_flat - flat_height
      # Make sure those Characters stay Visible, < 0 they Disappear!
      adjusted_z = 0 if adjusted_z < 0
      # Return the Adjusted Z-Index Value
      return adjusted_z
    end
    # If Event has a \z_add[int] string in Event Name and Always On Top is OFF
    if not @z_add.nil? and not @always_on_top
      # Calculate new Z-Index with Adjustments
      adjusted_z = (@real_y - $game_map.display_y + 3) / 4 + 32 + @z_add
      # Make sure those Characters stay Visible, < 0 they Disappear!
      adjusted_z = 0 if adjusted_z < 0
      # Return the Adjusted Z-Index Value
      return (@real_y - $game_map.display_y + 3) / 4 + 32 + @z_add
    end
    # If Event has a \z_sub[int] string in Event Name and Always On Top is OFF
    if not @z_sub.nil? and not @always_on_top
      # Consider the Sprites Size and Adjust for it
      flat_height = (height != 0 and not height.nil?) ? height : 0
      # Calculate new Z-Index with Adjustments      
      adjusted_z = (@real_y - $game_map.display_y + 3)/4 + @z_sub - flat_height
      # Make sure those Characters stay Visible, < 0 they Disappear!
      adjusted_z = -1 if adjusted_z > -1
      # Return the Adjusted Z-Index Value
      return @z_sub.abs * -1 - flat_height
    end
    # If tile
    if @tile_id > 0
      # Shorthand
      priorities = $game_map.priorities[@tile_id]
      # Priorities sometimes come up as nil on imported tilesets
      tile_priority = (priorities) ? priorities : 0
      # Add tile priority * 32
      return (@real_y - $game_map.display_y + 3) / 4 + 32 + tile_priority * 32
    # If character
    elsif self != $game_player
      # Get the Number of Actors in the Caterpillar minus Player
      cat_size = $game_system.caterpillar.actors.size + 1
      # Allows Caterpillar Members have a Z-Index equal to the Player's
      cat = (height > 32 ? 31 - cat_size : 0)
      # Adjusts Characters for Party Size so Party is barely On Top
      return (@real_y - $game_map.display_y + 3) / 4 + 32 + cat
    # Else Player
    else
      # Get screen coordinates from real coordinates and map display position
      z = caterpillar_screen_z
      # If Player needs to render below the Cat Actors
      if @substack_z and @direction != 2
        # Decrease Player Z to Below Cat Actors and Above Events
        z -= ($game_system.caterpillar.actors.size + 1)
      elsif @substack_z and @direction == 2
        # Disable Substack for proper Caterpillar Stacking
        @substack_z = false
      end
      # If height exceeds 32, then add 31 (Ignore Height, Player ALWAYS Tall)
      return z + 31
    end
  end
  # If Heretic's Loop Maps is installed
  if Game_Map.method_defined?(:map_loop_passable?)
    #--------------------------------------------------------------------------
    # * Screen Z - Game_Character
    #  - Get Screen Z-Coordinates
    #     height : character height
    #--------------------------------------------------------------------------
    alias caterpillar_loop_map_screen_z screen_z unless $@
    def screen_z(height = 0)
      # Call other Aliases of Screen_Z for Initial Z Value
      z = caterpillar_loop_map_screen_z(height)
      # Return Unadjusted Z-Sub Value if Z-Sub (Caterpillar compatability)
      return z if @z_sub and z < 0
      # Correct Z Index If Map Loops Vertical
      return ($game_map.loop_vertical? and not @always_on_top) ? 
        z %= $game_map.height * 32.0 : z
    end     
  end
  #--------------------------------------------------------------------------
  # * Move Type Custom - Game_Character
  #  - Change Opacity Command causes Opacity Orignal to be stored
  #  - @move_route.nil? is a bugfix for other scripts that set it to nil
  #--------------------------------------------------------------------------  
  alias heretic_caterpillar_move_type_custom move_type_custom unless $@
  def move_type_custom
    # Interrupt if not stopping
    return if jumping? or moving? or @move_route.nil?
    # Loop until finally arriving at move command list
    if @move_route_index < @move_route.list.size
      # Get the move command at index
      command = @move_route.list[@move_route_index]
      # If command code is Change Opacity
      if command.code == 42
        # If Opacity Original not yet Stored or is Changed
        if not @opacity_original or @opacity_original != command.parameters[0]
          # Store Original Opacity as Parameter from Command
          @opacity_original = command.parameters[0]
        end
        # Force Opacity to stay the same in Fade Events Opacity
        @opacity_duration = 0
        @opacity_target = command.parameters[0]
        # Change Opacity managed in Original
      end
    end
    # Call Original or other Aliases
    heretic_caterpillar_move_type_custom
  end
  # If Heretic's Loop Maps is NOT installed
  unless Game_Map.method_defined?(:map_loop_passable?)
    #--------------------------------------------------------------------------
    # * Character Distance - Game_Character
    #  - Returns the X and Y Distance between self and another Character
    #  - This version does NOT check for Looping Maps because the
    #    script that allows for those features is unavailable here so
    #    this version is only used as a fallback for nonexistent methods
    #      target : Character (Player or Event)
    #--------------------------------------------------------------------------
    def character_distance(target)
      # Return Difference X and Y values as Array
      return [@x - target.x, @y - target.y]
    end
  end  
  #--------------------------------------------------------------------------
  # * Turn Towards Event - Game_Character
  #  - Turns Player or Event toward another Event
  #      event_target_id : Event ID or 0 for Player (redundant)
  #--------------------------------------------------------------------------
  def turn_toward_event(event_target_id)
    # Check if the Event ID is requesting Player
    if event_target_id == 0
      # Target is the Game Player (even though there is a Button for it)
      event_target = $game_player
    # Make sure that event_target_id is Numeric
    elsif event_target_id.is_a?(Integer)
      # Set Variable to the corresponding Event
      event_target = $game_map.events[event_target_id]
    elsif not event_target_id.is_a?(Integer)
      # If Developer Errors in Editor
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user
        print "Warning: Problem in turn_toward_event(", event_target_id, ")\n",
              "\"", event_target_id, "\" should be an Event ID\n",
              "which is a Number!"
      end
      # Target doesnt exist, prevent further execution
      return
    else
      # Set to Nil to prevent further processing
      event_target = nil
    end
    # Arg isnt usable or Event doesnt exist
    if event_target.nil?
      # If Developer Errors in Editor
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user
        print "Warning: Problem in turn_toward_event(", event_target_id, ")\n",
              "The Event \"", event_target_id, "\" does not exist!"
      end
      # Target doesnt exist, prevent further execution
      return
    end
    # Get difference in target character coordinates
    sx, sy = character_distance(event_target)    
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards target event
      sx > 0 ? self.turn_left : self.turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards target event
      sy > 0 ? self.turn_up : self.turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Away From Event - Game_Character
  #  - Turns Player or Event away from another Event
  #      event_target_id : Event ID or 0 for Player (redundant)
  #--------------------------------------------------------------------------
  def turn_away_from_event(event_target_id)
    # Check if the Event ID is requesting Player
    if event_target_id == 0
      # Target is the Game Player (even though there is a Button for it)
      event_target = $game_player
    # Make sure that event_target_id is Numeric
    elsif event_target_id.is_a?(Integer)
      # Set Variable to the corresponding Event
      event_target = $game_map.events[event_target_id]
    elsif not event_target_id.is_a?(Integer)
      # If Developer Errors in Editor      
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user        
        print "Warning: ",
              "Problem in turn_away_from_event(", event_target_id, ")\n",
              "\"", event_target_id, "\" should be an Event ID\n",
              "which is a Number!"
      end
      # Target doesnt exist, prevent further execution
      return      
    else
      # Set to Nil to prevent further processing
      event_target = nil
    end
    # Arg isnt usable or Event doesnt exist
    if event_target.nil?
      # If Developer Errors in Editor      
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user        
        print "Warning: ",
              "Problem in turn_away_from_event(", event_target_id, ")\n",
              "The Event \"", event_target_id, "\" does not exist!"
      end
      # Target doesnt exist, prevent further execution
      return
    end
    # Get difference in target character coordinates
    sx, sy = character_distance(event_target)    
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards target event
      sx > 0 ? self.turn_right : self.turn_left
    # If vertical distance is longer
    else
      # Turn up or down towards target event
      sy > 0 ? self.turn_down : self.turn_up
    end
  end
  #--------------------------------------------------------------------------
  # * Move Toward Event - Game_Character
  #  - Moves Player or Event toward another Event
  #      event_target_id : Event ID or 0 for Player (redundant)  
  #--------------------------------------------------------------------------
  def move_toward_event(event_target_id)
    # Check if the Event ID is requesting Player
    if event_target_id == 0
      # Target is the Game Player (even though there is a Button for it)
      event_target = $game_player
    # Make sure that event_target_id is Numeric
    elsif event_target_id.is_a?(Integer)
      # Set Variable to the corresponding Event
      event_target = $game_map.events[event_target_id]
    elsif not event_target_id.is_a?(Integer)
      # If Developer Errors in Editor       
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user          
        print "Warning: Problem in move_toward_event(", event_target_id, ")\n",
              "\"", event_target_id, "\" should be an Event ID\n",
              "which is a Number!"
      end
      # Target doesnt exist, prevent further execution
      return      
    else
      # Set to Nil to prevent further processing
      event_target = nil
    end
    # Arg isnt usable or Event doesnt exist
    if event_target.nil?
      # If Developer Errors in Editor       
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user          
        print "Warning: ",
              "Problem in move_toward_event(", event_target_id, ")\n",
              "The Event \"", event_target_id, "\" does not exist!"
      end        
      # Target doesnt exist, prevent further execution
      return
    end
    # Get difference in target character coordinates
    sx, sy = character_distance(event_target)    
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # Get absolute value of difference
    abs_sx = sx.abs
    abs_sy = sy.abs
    # If horizontal and vertical distances are equal
    if abs_sx == abs_sy
      # Increase one of them randomly by 1
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    # If horizontal distance is longer
    if abs_sx > abs_sy
      # Move towards player, prioritize left and right directions
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    # If vertical distance is longer
    else
      # Move towards player, prioritize up and down directions
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Away From Event - Game_Character
  #  - Moves Player or Event away from another Event
  #      event_target_id : Event ID or 0 for Player (redundant)  
  #--------------------------------------------------------------------------
  def move_away_from_event(event_target_id)
    # Check if the Event ID is requesting Player
    if event_target_id == 0
      # Target is the Game Player (even though there is a Button for it)
      event_target = $game_player
    # Make sure that event_target_id is Numeric
    elsif event_target_id.is_a?(Integer)
      # Set Variable to the corresponding Event
      event_target = $game_map.events[event_target_id]
    elsif not event_target_id.is_a?(Integer)
      # If Developer Errors in Editor       
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user          
        print "Warning: ",
              "Problem in move_away_from_event(", event_target_id, ")\n",
              "\"", event_target_id, "\" should be an Event ID\n",
              "which is a Number!"
      end
      # Target doesnt exist, prevent further execution            
      return        
    else
      # Set to Nil to prevent further processing
      event_target = nil
    end
    # Arg isnt usable or Event doesnt exist
    if event_target.nil?
      # If Developer Errors in Editor       
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        # Explain the problem to the user          
        print "Warning: ",
              "Problem in move_away_from_event(", event_target_id, ")\n",
              "The Event \"", event_target_id, "\" does not exist!"
      end        
      # Target doesnt exist, prevent further execution
      return
    end
    # Get difference in target character coordinates
    sx, sy = character_distance(event_target)    
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # Get absolute value of difference
    abs_sx = sx.abs
    abs_sy = sy.abs
    # If horizontal and vertical distances are equal
    if abs_sx == abs_sy
      # Increase one of them randomly by 1
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    # If horizontal distance is longer
    if abs_sx > abs_sy
      # Move away from event or player, prioritize left and right directions
      sx > 0 ? move_right : move_left
      if not moving? and sy != 0
        sy > 0 ? move_down : move_up
      end
    # If vertical distance is longer
    else
      # Move away from player, prioritize up and down directions
      sy > 0 ? move_down : move_up
      if not moving? and sx != 0
        sx > 0 ? move_right : move_left
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Foot Forward On - Game_Character
  #  - Allows Animation Change regardless of Direction
  #      frame : 0 (Default) or 1 specified for 'other foot' in Spritesheet
  #----------------------------------------------------------------------------
  unless self.method_defined?('foot_forward_on')  
    def foot_forward_on(frame = 0)
      return if @direction_fix or !@walk_anime or @step_anime or 
                $game_temp.in_battle
      if frame == 0
        case @direction
        when 2
          @pattern = 3
        when 4, 6, 8
          @pattern = 1
        else
          @pattern = 0
        end
        @original_pattern = @pattern
      elsif frame == 1
        case @direction
        when 2
          @pattern = 1
          when 4, 6, 8
          @pattern = 3
        else
          @pattern = 0
        end
        @original_pattern = @pattern
        # Explain the problem to the user        
      elsif $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
        print "Warning: foot_forward_on(", frame, ")\n",
              "expects either 0 or 1\n",
              "to specify a frame\n\n",
              "or just dont use the optional argument\n",
              "foot_forward_on OR foot_forward_on(0 or 1)"
      end
    end
    #--------------------------------------------------------------------------
    # * Foot Forward On - Game_Character
    #  - Reset Character Original Pattern and Pattern
    #--------------------------------------------------------------------------
    def foot_forward_off
      # If called by walking off screen, dont affect a Sign or Stepping Actor
      return if @direction_fix or not @walk_anime or @step_anime or 
                $game_temp.in_battle
      @pattern, @original_pattern = 0, 0
    end
  end
  #----------------------------------------------------------------------------
  # * Set Ladder Speed - Game_Character
  #  - Sets Movement Speed while on Ladder next time on Ladder
  #      new_speed : Move Speed
  #----------------------------------------------------------------------------
  def set_ladder_speed(new_speed)
    $game_system.caterpillar.set_ladder_speed(new_speed)
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Event - Game_Character
  #  - Fades out Caterpillar
  #      opacity  : Target Opacity
  #      duration : Time in Frames
  #      player   : true / false to Fade the Player with Caterpillar
  #----------------------------------------------------------------------------
  def cat_fade_event(opacity, duration, player = true)
    $game_system.caterpillar.cat_fade_event(opacity, duration, player)
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Event Reset - Game_Character
  #  - Restores Caterpillar Members and Player to Original Opacity
  #      duration : TIme in Frames
  #----------------------------------------------------------------------------
  def cat_fade_event_reset(duration)
    $game_system.caterpillar.cat_fade_event_reset(duration)
  end  
  #----------------------------------------------------------------------------
  # * Cat Fade Out Per Step - Game_Character
  #  - Fades Caterpillar to 0 Opacity over Duration
  #  - Auto Fades back in on Next Step if auto_fade_back_in = true
  #      duration          : Time in Frames to Fade Opacity
  #      auto_fade_back_in : true / false / nil Fade Back in once faded out
  #----------------------------------------------------------------------------
  def cat_fade_out_per_step(duration = nil, auto_fade_back_in = nil)
    duration = 20 if (duration and not duration.is_a?(Numeric)) or !duration
    $game_system.caterpillar.cat_fade_out_per_step(duration, auto_fade_back_in)
  end
  #----------------------------------------------------------------------------
  # * Cat Fade In Per Step - Game_Character
  #  - Sets the Party to Fade In each Incremental Step
  #  - Use this when Cat Fade Out Per Step doesnt use auto_fade_back_in
  #      duration          : Time in Frames to Fade Opacity
  #----------------------------------------------------------------------------
  def cat_fade_in_per_step(duration = nil)
    duration = 20 if (duration and not duration.is_a?(Numeric)) or !duration
    $game_system.caterpillar.cat_fade_in_per_step(duration)
  end
  #----------------------------------------------------------------------------
  # * Cat Stagger - Game_Character
  #  - Unstacks all Cat Actors in Direction
  #  - Useful for setting up Cutscenes while not visible
  #      dir    : Direction to Stagger (Up, Down, Left, Right, 2, 4, 6, or 8)
  #      offset : [Optional] Extra Distance to Stagger from Player
  #----------------------------------------------------------------------------
  def cat_stagger(dir, offset = 0)
    $game_system.caterpillar.cat_stagger(dir, offset)
  end
  #----------------------------------------------------------------------------
  # * Get Opposite Direction - Game Character
  #  - Returns Opposite Direction
  #----------------------------------------------------------------------------
  def get_opposite_direction
    # Return 0 if no valid direction
    return 0 if @direction == 0
    # Return Opposite Direction
    return 10 - @direction
  end    
  #----------------------------------------------------------------------------
  # * Cat Speed - Game_Character
  #  - Set Speed for Player and Cat Actors
  #----------------------------------------------------------------------------
  def cat_speed(new_speed)
    $game_system.caterpillar.cat_speed(new_speed)
  end  
  #----------------------------------------------------------------------------
  # * Move Route Wait Exclude - Game_Character
  #  - Excludes this Character from "Wait for Move's Completion" Command
  #----------------------------------------------------------------------------
  def move_route_wait_exclude
    @move_route_wait_excluded = true
  end
  #----------------------------------------------------------------------------
  # * Move Route Wait Include - Game_Character
  #  - Includes this Character from "Wait for Move's Completion" Command
  #----------------------------------------------------------------------------
  def move_route_wait_include
    @move_route_wait_excluded = false    
  end
  # If ForeverZer0's Pathfind Module is installed above Caterpillar 
  if Interpreter.method_defined? ('pathfind') and
     not self.method_defined?('pathfind')
    #--------------------------------------------------------------------------
    # * Pathfind - Game_Character
    #  - Pathfind by ForeverZero, see his documentation for Commands and Args
    #--------------------------------------------------------------------------
    def pathfind(x, y, *args)
      args[0] = @event.id if args[0] == nil
      args[1] = 0 if args[1] == nil
      # Add a simpler call for using as a script call
      Pathfind.new(Node.new(x, y), *args)
    end
  # Pathfind Not Installed
  elsif not Interpreter.method_defined? ('pathfind') and
        not self.method_defined?('pathfind')
    #--------------------------------------------------------------------------
    # * Pathfind - Game_Character
    #  - Pathfind Not Installed and Print Error
    #--------------------------------------------------------------------------
    def pathfind(*args)
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        print "Pathfind Script Not Installed"
      end
    end
  end  
  #----------------------------------------------------------------------------
  # * Turn Cat - Game_Character
  #  - Turns Caterpillar
  #  - Does NOT Turn Player
  #      direction : New Direction ("Text" or Numeric)
  #      delay     : Time in Frames between each Cat Actor's Turn Movement
  #----------------------------------------------------------------------------
  def turn_cat(direction, delay = nil)
    $game_system.caterpillar.turn_cat(direction, delay)
  end
  #----------------------------------------------------------------------------
  # * Turn Cat Toward Event - Game_Character
  #  - Turns Caterpillar Characters toward an Event
  #  - Executed in Game_Caterpillar by passing args along from Move Route call
  #      event_id : Event Target ID
  #      repeat   : Repeat Turn until Reset
  #      delay    : Time in Frames to wait between each Character's Turn
  #----------------------------------------------------------------------------
  def turn_cat_toward_event(event_id, repeat = false, delay = nil)
    $game_system.caterpillar.turn_cat_toward_event(event_id, repeat, delay)
  end
  #----------------------------------------------------------------------------
  # * Turn Cat Away From Event - Game_Character
  #  - Turns Caterpillar Characters Away From an Event
  #  - Executed in Game_Caterpillar by passing args along from Move Route call
  #      event_id : Event Target ID
  #      repeat   : Repeat Turn until Reset
  #      delay    : Time in Frames to wait between each Character's Turn
  #----------------------------------------------------------------------------
  def turn_cat_away_from_event(event_target_id, repeat = nil, delay = nil)
    $game_system.caterpillar.turn_cat_away_from_event(event, repeat, delay)
  end
  #----------------------------------------------------------------------------
  # * Cat To Player - Game_Character
  #  - Turns all Cat Actors to the same Direction as the Player
  #      opacity     : [Optional] Fades upon Stack
  #      duration    : [Optional] Duration of Fade
  #      turn_player : [Optional] Matches Player Direction upon Stack
  #----------------------------------------------------------------------------
  def cat_to_player(opacity = nil, duration = nil, turn_player = false)
    $game_system.caterpillar.cat_to_player(opacity, duration, turn_player)
  end  
  #----------------------------------------------------------------------------
  # * Orient To Player - Game_Character
  #  - Turns all Cat Actors to the same Direction as the Player
  #----------------------------------------------------------------------------
  def orient_to_player
    $game_system.caterpillar.orient_to_player
  end
end

#==============================================================================
# ** Game_Player
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------  
  attr_accessor  :walk_anime             # Walking Animation
  attr_accessor  :last_moved_direction   # Corrects Direction on Ladders
  attr_accessor  :last_d_sw              # State of Dead Effect Game Switch
  attr_accessor  :substack_z             # Transfer and Cat To Player
  #----------------------------------------------------------------------------
  # * Update - Game_Player
  #  - Watches for Changes to the Dead Effect Game Switch to reset Dead Effects
  #----------------------------------------------------------------------------
  alias heretic_caterpillar_player_update update unless $@
  def update
    # If a Change in the Dead Effect Switch or not set
    if @last_d_sw != $game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS]
      # Shorthand for Caterpillar
      c = $game_system.caterpillar
      # If a Caterpillar Transition is not taking place
      if not c.actors_fade_in and not c.actors_fade_out and not c.fade_back_in
        # If Caterpillar is Active and not Paused
        if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
           not $game_switches [Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH]
          # Set Flag to check for Dead Animations and Character Sprites
          $walk_has_been_set = false
          # Set the Dead Animations and Alt Character Sprite Transitions
          c.dead_walk_animation
          # Store the current State of the Dead Effect Game Switch
          @last_d_sw = $game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS]
        end
      end
    end
    # Call Original or other Aliases
    heretic_caterpillar_player_update
  end
  #----------------------------------------------------------------------------
  # * Passable? - Game_Player
  #  - Determines if Player can move to a Location
  #  - Stores Move Direction for Ladder Effects
  #  - Allows Player to walk Off the Map when $walk_off_map is true
  #      *args : Array of Unknown Size
  #----------------------------------------------------------------------------
  alias heretic_caterpillar_player_passable? passable? unless $@
  def passable?(*args)
    # Store Last Attempted Move Direction for Ladder
    @last_moved_direction = *args[2]    
    # If Global Variable $walk_off_map is set
    if $walk_off_map == true
      # Allow Player to move anywhere
      return true
    end
    # Return results of Original or other Aliases of Passable for Player
    return heretic_caterpillar_player_passable?(*args)
  end
  #----------------------------------------------------------------------------
  # * Increase Steps - Game_Player
  #  - Called when Player is Teleported or Transferred
  #----------------------------------------------------------------------------
  alias heretic_caterpillar_player_increase_steps increase_steps unless $@
  def increase_steps
    # Call Original or other Aliases
    heretic_caterpillar_player_increase_steps 
    # Reset Property
    @substack_z = false if $game_system.caterpillar.cat_steps > 0
  end
  #----------------------------------------------------------------------------
  # * Center - Game_Player
  #  - Called when Player is Teleported or Transferred
  #----------------------------------------------------------------------------
  alias heretic_caterpillar_game_player_center center unless $@
  def center(*args)
    # Call Original or other Aliases
    heretic_caterpillar_game_player_center(*args)
    # Center the Caterpillar to Player's Location
    $game_system.caterpillar.center
    # Used for Z-Index Adjustments, Steps and Direction determine the Z-Index
    $game_system.caterpillar.cat_steps = 0
    # If Option is Enabled to diaplay Errors for missing / duplicate Events
    if Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
      # Enables Displaying Error Messages for Missing Caterpillar Actors 
      $game_system.caterpillar.check_missing_reset
    end
  end
  #----------------------------------------------------------------------------
  # * Refresh - Game_Player
  #  - This alias keeps Player Opacity when Refreshed if System Option is on
  #----------------------------------------------------------------------------
  alias heretic_player_cat_refresh refresh unless $@
  def refresh
    # Store current Opacity
    opacity = @opacity
    # Call Original or other Aliases of Refresh
    heretic_player_cat_refresh
    # If keeping Player's Opacity
    if opacity and $game_system.dont_refresh_opacity
      # Set the Opacity to the Stored Opacity
      @opacity = opacity
    # Else, set to Default Opacity
    else
      @opacity = 255
    end
    # Player Ghost
    if Game_Caterpillar::DEAD_ACTOR_EFFECTS and
       Game_Caterpillar::DEAD_EFFECT.include?('GHOST') and
       @opacity_ghost == true and $game_party.actors[0].dead?
       @opacity != Game_Caterpillar::DEAD_GHOST_OPACITY
      # Reset Player Opacity to Ghost Opacity before Screen Update
      @opacity = Game_Caterpillar::DEAD_GHOST_OPACITY
    # Player Zombie
    elsif Game_Caterpillar::DEAD_ACTOR_EFFECTS and
          Game_Caterpillar::DEAD_EFFECT.include?('ZOMBIE') and
          @zombie and $game_party.actors[0].dead?
      if @dead_effect_transition or @normal_effect_transition
        # Reset Player Opacity to be partial if Zombie Flag is set
        @opacity = Game_Caterpillar::ZOMBIE_OPACITY - @alt_opacity
      elsif @zombie_visible
        @opacity = 0
      end
    # Player Coffin
    elsif Game_Caterpillar::DEAD_ACTOR_EFFECTS and
          Game_Caterpillar::DEAD_EFFECT.include?('COFFIN') and
          @coffin and $game_party.actors[0].dead?
      if @dead_effect_transition or @normal_effect_transition
        # Reset Player Opacity to be partial if Coffin Flag is set
        @opacity = Game_Caterpillar::COFFIN_OPACITY - @alt_opacity
      elsif @coffin_visible
        @opacity = 0
      end
    # Player Alt Sprite
    elsif Game_Caterpillar::DEAD_ACTOR_EFFECTS and
          Game_Caterpillar::DEAD_EFFECT.include?('ALT_SPRITE') and
          @alt_char_sprite and $game_party.actors[0].dead?
      if @dead_effect_transition or @normal_effect_transition
        # Reset Player Opacity to be partial if Alt Char Flag is set
        @opacity = Game_Caterpillar::ALT_SPRITE_OPACITY - @alt_opacity
      elsif $game_player.alt_char_sprite_visible
        @opacity = 0
      end      
    end
  end
  #----------------------------------------------------------------------------
  # * Cat Forward - Game_Player
  #  - Player takes One Step Forward for each Caterpillar Member
  #----------------------------------------------------------------------------
  def cat_forward
    # Create a New Move Route
    route = RPG::MoveRoute.new
    # Move Route Object Default Values
    route.repeat = false
    route.skippable = true
    # Get the Number of Steps to move Forward
    steps = $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH] ?
            1 : $game_system.caterpillar.actors.size + 1
    # Push a Step Forward (appropriate to Player Direction) for each Cat Actor
    while steps > 0
      # Put the MoveCommand on to the MoveRoute
      if $game_player.direction == 2 # Down
        route.list.unshift(RPG::MoveCommand.new(1, [])) # Move Down
        valid = true        
      elsif $game_player.direction == 4
        route.list.unshift(RPG::MoveCommand.new(2, [])) # Move Left
        valid = true
      elsif $game_player.direction == 6
        route.list.unshift(RPG::MoveCommand.new(3, [])) # Turn Right
        valid = true
      elsif $game_player.direction == 8
        route.list.unshift(RPG::MoveCommand.new(4, [])) # Turn Up
        valid = true
      end
      # Decrease Number of Steps  
      steps -= 1
    end
    # Push on a Wait for Move's Completion (Code: 210) on to the Move Route
    route.list.unshift(RPG::MoveCommand.new(210, []))
    # Force the Move Route to the Cat Actor IF it was a Valid Direction
    $game_player.force_move_route(route) if valid        
  end
  #----------------------------------------------------------------------------
  # * Add Follower - Game_Player
  #  - Provide Instructional Warning
  #----------------------------------------------------------------------------
  def add_follower(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
      print "Warning:  You can't Follow yourself, silly!\n\n",
        "Select the Event you want to add as a Cat Follower\n",
        "from the Drop Down Menu in Edit Move Routes\n",
        "to add THAT Event as a Cat Follower."
    end
  end  
  #----------------------------------------------------------------------------
  # * Remove Follower - Game_Player
  #  - Provide Instructional Warning
  #----------------------------------------------------------------------------
  def remove_follower(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
      print "Warning:  You can't Remove yourself from Following",
        "yourself, silly!\n\n",
        "Select the Event you want to Remove as a Cat Follower\n",
        "from the Drop Down Menu in Edit Move Routes\n",
        "to Remove THAT Event as a Cat Follower."
    end
  end    
  #----------------------------------------------------------------------------
  # * Multiple Methods for Player Movement - Game_Player
  #  - Generate registration of player moves to the caterpillar code
  #----------------------------------------------------------------------------
  # Constants - DO NOT EDIT
  MOVE_METHODS = ['move_down', 'move_left', 'move_right', 'move_up',
                  'move_lower_left', 'move_lower_right', 'move_upper_left',
                  'move_upper_right', 'jump']
  # Go through each method
  for method in MOVE_METHODS
    # Create the script for the specific method
    PROG = <<_END_
  def #{method}(*args)
    x,y = self.x, self.y
    super(*args)
    unless self.x == x && self.y == y
      $game_system.caterpillar.register_player_move(@move_speed, 
                            '#{method}', args, [self.x, self.y])
    end
  end
_END_
    # Run the script to create the alias methods for each move_method constant
    eval(PROG)
  end
end

#==============================================================================
# ** Scene_Load
#==============================================================================
class Scene_Load < Scene_File
  #----------------------------------------------------------------------------
  # * Read Save Data - Scene_Load
  #  - Corrects Ladder Directions from Save Games
  #      file : file object for reading (opened)
  #----------------------------------------------------------------------------
  alias caterpillar_read_save_data read_save_data unless $@
  def read_save_data(file)
    # Call Original (works for both SDK and Non SDK)
    caterpillar_read_save_data(file)
    # If Savegame has the Caterpillar set to Active
    if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
       $game_system.caterpillar.follower_ids.size > 0
      # Temporary Copy of Followers
      old_followers = []
      for actor in $game_system.caterpillar.actors
        if not actor.cat_follower.nil?
          old_followers << actor.dup
        end
      end
    end
    # Refresh the Caterpillar, strange bugs otherwise
    $game_system.caterpillar.refresh
    # Check if on a Ladder
    if $game_switches[Game_Caterpillar::LADDER_EFFECTS] and
       $game_player.using_ladder
      # Turns Player UP to face Ladder
      $game_player.direction = 8
      $game_player.last_moved_direction = 8
      $game_player.direction_fix = true
      for actor in $game_system.caterpillar.actors
        actor.direction = 8
        actor.direction_fix_last = false
        actor.direction_fix = true
        actor.using_ladder = true
      end
    else
      # Turns Player Down
      $game_player.direction = 2
      $game_player.last_moved_direction = 2
      $game_player.direction_fix = false
      for actor in $game_system.caterpillar.actors
        # Reset the Cat Actors
        actor.direction_fix = false
        actor.direction_fix_last = nil        
        actor.direction = 2
        actor.using_ladder = false
      end
    end
    # If Savegame has the Caterpillar set to Active
    if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
       $game_system.caterpillar.follower_ids.size > 0
      # Correct the Followers Opacity
      for old_follower in old_followers
        for actor in $game_system.caterpillar.actors
          if actor.id == old_follower.id
            # Transfer Properties on Scene Load from Old to Current Follower
            actor.character_name = old_follower.character_name
            actor.character_hue = old_follower.character_hue
            actor.blend_type = old_follower.blend_type
            actor.opacity = old_follower.opacity
            actor.opacity_original = old_follower.opacity_original
            actor.opacity_target = old_follower.opacity_target
            actor.opacity_duration = old_follower.opacity_duration
            actor.walk_anime = old_follower.walk_anime
            actor.step_anime = old_follower.step_anime
            actor.direction_fix = old_follower.direction_fix
            actor.direction_fix_last = old_follower.direction_fix_last
            # Check Player for Using Ladder
            if not $game_player.using_ladder
              # Reset Direction Fix to Direction Fix Last
              actor.direction_fix = actor.direction_fix_last
              # Clear Last Direction Fix
              actor.direction_fix_last = nil
              # Reset Ladder to False due to Centering
              actor.using_ladder = false
            end
            # End Iteration Loop
            break
          end
        end
      end
    end
  end
end

#==============================================================================
# ** Class Module
#   - Creates attr_sec_reader and .._accessor methods for Module
#==============================================================================
class Module
  # Prevent adding the method again should it already be present.
  unless self.method_defined?('attr_sec_accessor')
    #--------------------------------------------------------------------------
    # * Attr Sec Accessor - Class Module
    #  - Adds attr_sec_accessor :object method availability
    #--------------------------------------------------------------------------
    def attr_sec_accessor(sym, default = 0)
      attr_writer sym
      attr_sec_reader sym, default
    end
    #--------------------------------------------------------------------------
    # * Attr Sec Reader - Class Module
    #  - Adds attr_sec_reader :object method availability
    #--------------------------------------------------------------------------
    def attr_sec_reader(sym, default = 0)
      sym = sym.id2name
      string = "def #{sym};" +
               "  @#{sym} = #{default}  if @#{sym}.nil?;" +
               "  @#{sym};" +
               "end;"
      module_eval(string)
    end
  end
end

#==============================================================================
# ** Game_System
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------  
  attr_sec_accessor :caterpillar, 'Game_Caterpillar.new'  # Caterpillar Object
  attr_accessor     :dont_refresh_opacity                 # Keep Player Opacity
  #----------------------------------------------------------------------------
  # * Object Initialization - Game_System
  #----------------------------------------------------------------------------
  alias caterpillar_system_player_opacity_initialize initialize
  def initialize
    # Call Original
    caterpillar_system_player_opacity_initialize
    # Keep Player Opacity
    @dont_refresh_opacity = true
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------  
  attr_reader         :actor_id                    # Actor ID in the Database
end

#==============================================================================
# ** Game_Event
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------  
  attr_sec_accessor  :move_list, '[]'    # Cat Actors Move List
  attr_accessor      :move_speed         # Player Move Speed
  attr_accessor      :walk_anime         # Walking Animation Bool
  attr_accessor      :step_anime         # Stepping Animation
  attr_accessor      :last_walk_anime    # Last Walking Animation
  attr_accessor      :through            # Default Walk Through
  attr_accessor      :direction_fix      # Prohibit Changing Direction
  attr_accessor      :al_update          # Anti Lag Update - Faster processing
  attr_accessor      :cat_follower       # Allows for Non Party Cat Actors
  attr_accessor      :z_flat             # Causes Events to render as Flat
  attr_accessor      :allowed_off_map    # Event Name contains "\off_map"
  #----------------------------------------------------------------------------
  # * Object Initialization - Game_Event
  #----------------------------------------------------------------------------
  alias zeriab_caterpillar_game_event_initialize initialize unless $@
  def initialize(map_id, event, *args)
    # Gives Events an @allowed_off_map Property to allow them off the Map
    check_allowed_off_map(event)
    # Used for Displaying Errors about Missing Cat Actors
    $check_missing_array = []
    # Used for checking for Duplicate Cat Actors
    $duplicates_array = []
    # Check for Events with \z_flat or \z_add[int] flag in Name of Event
    check_flat_sprites(event)
    # Call Original or other Aliases
    zeriab_caterpillar_game_event_initialize(map_id, event, *args)
    # Check for Events with \move_route_wait_exclude flag in Name of Event
    check_move_route_wait_exclude(event)
    # Check every Event for a Ladder Graphic
    check_ladder_tags(event)
    # Check every Event for an \al_update Tag
    check_al_update(event)
    # Check for caterpillar actor denomination
    check_caterpillar    
  end
  #--------------------------------------------------------------------------
  # * Refresh - Game_Event
  #--------------------------------------------------------------------------
  alias heretic_caterpillar_game_event_refresh refresh unless $@
  def refresh
    # Holds current Event Graphic
    temp_character_name = @character_name
    # Holds current Walk Animation
    temp_walk_anime = @walk_anime
    # Holds current Opacity (which could be changing) for Dead Ghost Effect
    temp_opacity = @opacity
    # Holds Blend Type
    temp_blend_type = @blend_type
    # Run Original Refresh
    heretic_caterpillar_game_event_refresh
    # If its a Cat Actor, and Option is Enabled, Dont Change the Graphics!!!
    if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
       (($game_system.caterpillar.is_cat_actor?(self) and
       $game_system.caterpillar.cat_actor_in_party?(self)) or
       ($game_system.caterpillar.follower and
       $game_system.caterpillar.is_cat_follower?(self) and
       $game_system.caterpillar.actors.include?(self))) and
       $game_system.caterpillar.cat_graphics_dont_change  
      # This resets the Event Graphic back to be the Actors
      @character_name = temp_character_name
      # Reset Event Walk Animaion back to the Actors Current Walk Animation
      @walk_anime = temp_walk_anime
      # This resets Ghost Effects without affecting Duration 
      @opacity = temp_opacity
      # This resets the Blend Type
      @blend_type = temp_blend_type
    end
  end
  #--------------------------------------------------------------------------
  # * Set Flat - Game_Event
  #  - Causes an Event to render as Flat so Characters can walk on top of it
  #      new_z : [Optional] value of Z-Index Adjustment - Default : 0
  #--------------------------------------------------------------------------
  def set_flat(new_z = 0)
    # new_z is Optional.  If included, it is ADDED to the New Z-Index
    @z_flat = new_z
  end
  #----------------------------------------------------------------------------
  # * Set Z - Game_Event
  #  - Sets the Z-Index of an Event via a Script instead of a Name
  #      new_z : [Optional] value of Z-Index Adjustment - Default : nil
  #----------------------------------------------------------------------------
  def set_z(new_z = 0)
    # Assign Argument Value to Property - 32 for Height
    @z_add = new_z - 32
  end
  #----------------------------------------------------------------------------
  # * Reset Z - Game_Event
  #  - Resets the Z-Index of an Event via a Script instead of a Name
  #----------------------------------------------------------------------------
  def reset_z
    # Resets Z-Index adjusting Properties
    @z_flat = nil
    @z_add = nil
    @z_sub = nil
    # Reset this Event's Z-Index to be Name Based
    @event.name.gsub(/\\z_flat\[([-]?[0-9]+)\]|\\z_flat/i) {@z_flat = $1.to_i }
    return if @z_flat    
    @event.name.gsub(/\\z_add\[([-]?[0-9]+)\]/i) {@z_add = $1.to_i }
    return if @z_add
    @event.name.gsub(/\\z_sub\[\-([-]?[0-9]+)\]/i) {@z_sub = $1.to_i }
    return if @z_sub
  end  
  #----------------------------------------------------------------------------
  # * Clear Z - Game_Event
  #  - Clears the Z-Index of an Event
  #----------------------------------------------------------------------------
  def clear_z
    @z_flat = nil
    @z_add = nil
    @z_sub = nil
  end
  #----------------------------------------------------------------------------
  # * Set Sub Z - Game_Event
  #  - Negative Z-Index will cause Characters to render under Map Tiles Only!
  #----------------------------------------------------------------------------
  def set_sub_z(int)
    @z_flat = nil
    @z_add = nil
    @z_sub = (int.abs) * -1
  end
  #----------------------------------------------------------------------------
  # * Sets an Event to Temporarily have a Through Property - Dont Call Manually
  #  - Used with PASS_SOLID_ACTORS = false
  #  - Resets once Player steps away from Stacked Caterpillar Actors
  #----------------------------------------------------------------------------
  def set_cat_through
    # Store the Original Property so we can revert back to it later
    @original_through = @through if @original_through.nil?
    # Set that event to a Through flag so can walk Through the Player
    # Player can walk thru Caterpillar, but events cant walk thru the Player
    @through = true
    # Allows a Reset to Original State when true on Next Player Movement
    $cat_forced_to_through = true
  end
  #----------------------------------------------------------------------------
  # * Reset Cat Through - Game_Event
  #  - Resets an Event back to its Original Through Property
  #----------------------------------------------------------------------------
  def reset_cat_through
    # Resets the Event back to its Original Through State
    @through = @original_through if not @original_through.nil?
  end
  #--------------------------------------------------------------------------
  # * Coordinate Match? - Game_Event
  #  - Return true or false determined by Coordinate Match
  #--------------------------------------------------------------------------
  def coordinate_match?(x, y)
    # Returns True if X and Y args match the @X and @Y properties
    return (@x == x and @y == y)
  end
  #----------------------------------------------------------------------------
  # * Check Caterpillar - Game_Event
  #  - Check for Caterpillar Actor and Follower Event Name Denominations
  #  - EV002\cat_actor[2] becomes @caterpillar_actor = 2
  #----------------------------------------------------------------------------
  def check_caterpillar
    # Check for caterpillar actor denomination (Last is used if more present)
    @event.name.gsub(/\\cat_actor\[([0-9]+)\]/i) {@caterpillar_actor = $1}
    # Check if an valid denomination is found.
    if @caterpillar_actor.is_a?(String)
      @caterpillar_actor = @caterpillar_actor.to_i
      if $data_actors[@caterpillar_actor].nil?
        @caterpillar_actor = nil
      else
        $game_system.caterpillar.add_actor(self, @caterpillar_actor)
      end
    end
    # Check for Cat Follower Actor Denomination (Last is used if more present)
    @event.name.gsub(/\\cat_follower\[([0-9]+)\]/i) {@cat_follower = $1.to_i}
    if @cat_follower
      $game_system.caterpillar.follower_events[@cat_follower] = self
    else
      @cat_follower = nil
    end
  end
  #----------------------------------------------------------------------------
  # * Check Flat Sprites - Game_Event
  #  - Check Each Event for a \z_flat, \z_sub, or \z_add flag
  #----------------------------------------------------------------------------
  def check_flat_sprites(event)
    event.name.gsub(/\\z_flat\[([-]?[0-9]+)\]|\\z_flat/i) {@z_flat = $1.to_i }
    return if @z_flat    
    event.name.gsub(/\\z_add\[([-]?[0-9]+)\]/i) {@z_add = $1.to_i }
    return if @z_add
    event.name.gsub(/\\z_sub\[\-([-]?[0-9]+)\]/i) {@z_sub = $1.to_i }
    return if @z_sub    
  end
  #----------------------------------------------------------------------------
  # * Check Move Route Wait Exclude - Game_Event
  #  - Check Each Event for a \move_route_wait_exclude flag
  #  - "Wait for Move's Completion" doesnt wait for This Event
  #----------------------------------------------------------------------------
  def check_move_route_wait_exclude(e)
    # Name an Event "anything\move_route_wait_exclude
    e.name.gsub(/\\move_route_wait_exclude/i){@move_route_wait_excluded = true}
  end  
  #----------------------------------------------------------------------------
  # * Check Duplicates - Game_Event
  #  * Check for Duplicate Cat Actors that cause Problems with the Caterpillar
  #----------------------------------------------------------------------------
  def check_duplicates
    # If Duplicates have not been checked
    if not $duplicates_checked and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
      # Initialize - Resets to Uninitialized at end of check
      if $check_caterpillar_events_checked == nil
        $check_caterpillar_events_checked = 1
      else
        $check_caterpillar_events_checked += 1        
      end
      # If Just initialized, reset the Arrays used
      if $check_caterpillar_events_checked == 1
        # Holds ONLY Duplicated Events for Error Display
        $duplicated_events = []
        $duplicated_follower_events = []
        # Holds ALL Cat Actors - Duplicates Not Added
        $duplicates_array = []
        $duplicates_follower_array = []
        # Advises of Multiple Duplicates - Integer for Cat Actor
        error_displayed = nil
      end
      # If the Event is a Cat Actor
      if @caterpillar_actor
        # Iterate thru the Array for checking Subarrays
        for i in 0...$duplicates_array.size
          # If a Duplicate Cat Actor is found in Error Checking Array
          if $duplicates_array[i].include? (@caterpillar_actor)
            # Record if not Recorded
            if not $duplicated_events.include? ([@caterpillar_actor, @event])
              # Then Add it to the Array for Error Display
              $duplicated_events.push($duplicates_array[i])
            end
            # Record Both Conflicting Events
            if not $duplicated_events.include? ([@caterpillar_actor, @event])
              # Then Add it to the Array also for Error Display
              $duplicated_events.push([@caterpillar_actor, @event])
            end
          end
        end
        # Record All Duplicate Cat Actor Events for Error Display
        $duplicates_array.push([@caterpillar_actor, @event])
      # If the Event is a Cat Follower
      elsif @cat_follower
        # Iterate thru the Array for checking Subarrays
        for i in 0...$duplicates_follower_array.size
          # If a Duplicate Cat Follower is found in Error Checking Array
          if $duplicates_follower_array[i].include? (@cat_follower)
            # Record if not Recorded
            if not $duplicated_follower_events.include?([@cat_follower, @event])
              # Then Add it to the Array for Error Display
              $duplicated_follower_events.push($duplicates_follower_array[i])
            end
            # Record Both Conflicting Events
            if not $duplicated_follower_events.include?([@cat_follower, @event])
              # Then Add it to the Array also for Error Display
              $duplicated_follower_events.push([@cat_follower, @event])
            end
          end
        end
        # Even if it is a Duplicate Event, Add to Array for Erors
        $duplicates_follower_array.push([@cat_follower, @event])        
      end
      # Display Duplicate Errors once all Map Events are checked
      if $check_caterpillar_events_checked == $game_map.events.size
        # If there were any Duplicates (shows minimum of TWO)
        if not $duplicated_events.empty?
          # Iterate thru EVERY Duplicate Cat Actor
          for i in 0...$duplicated_events.size
            # Just easier to type - Temporary Variable
            dup_event = $duplicated_events[i].to_a[1]
            dup_actor_id = $duplicated_events[i].to_a[0].to_i
            dup_name = $game_actors[dup_actor_id].name
            # If Initial Warning for that Cat Actor Duplicate
            if error_displayed.nil? or 
               error_displayed != $duplicated_events[i].to_a[0]
              # Advise there are Duplicates for THIS Cat Actor
              print "WARNING: Caterpillar has detected\nDuplicate Cat Actors\n",
                "for Cat Actor: ", $duplicated_events[i].to_a[0], " Name: ", 
                 dup_name, "\n\n",
                "Duplicates move to the Players Position, but\n",
                "are NOT a part of the Caterpillar.\n",
                "They Might cause your game to Freeze\n",
                "under certain circumstances.\n\n",
                "Map Name: ", $game_map.name, "   Map ID: ", $game_map.map_id
              error_displayed = $duplicated_events[i].to_a[0]
            end
            # Explain which two Cat Actors are Duplicates
            print "Duplicate Cat Actor: ", $duplicated_events[i].to_a[0], "\n",
              "Event ID: ", dup_event.id, "\n",
              " - MAP Name: ", $game_map.name, "\n",
              " - Actor Name: ", dup_name, "\n",
              " - Event Name: ", dup_event.name, "\n",
              " - X: ", dup_event.x, "\n",
              " - Y: ", dup_event.y
          end
        end  
        # Followers
        if not $duplicated_follower_events.empty?
          # Iterate thru EVERY Duplicate Cat Actor
          for i in 0...$duplicated_follower_events.size
            # Just easier to type - Temporary Variable
            dup_event = $duplicated_follower_events[i].to_a[1]
            dup_event.name.gsub(/\\cat_follower\[([0-9]+)\]/i){
                                $temp_dup_follower_id = $1.to_i}
            # If Initial Warning for that Cat Follower Duplicate
            if error_displayed.nil? or error_displayed != $temp_dup_follower_id
              # Advise there are Duplicates for THIS Cat Actor
              print "WARNING: Caterpillar has detected\n",
                "Duplicate Cat Follower\nfor Cat Follower: ", dup_event.name,
                "\nMap Name: ", $game_map.name, "\nMap ID: ", $game_map.map_id
              error_displayed = $temp_dup_follower_id
            end
            # Explain which Events and Data are Duplicates
            print "Duplicate Cat Follower: ", $temp_dup_follower_id, 
              "\nEvent ID: ", dup_event.id, "\n",
              " - MAP Name: ", $game_map.name, "\n",
              " - Event Name: ", dup_event.name, "\n",
              " - X: ", dup_event.x, "\n",
              " - Y: ", dup_event.y
          end
        end    
        # Reset the Global Arrays and Variables
        $duplicated_events = []
        $duplicated_follower_events = []
        $duplicates_array = []       
        $duplicates_follower_array = []
        $check_caterpillar_events_checked = nil
        # Prevent running again until Reset
        $duplicates_checked = true
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Check Allowed Off Map - Game_Event
  #  - Reads Event Name for \off_map Comment
  #  - Enable Off Map movement by also enabling Through
  #----------------------------------------------------------------------------
  def check_allowed_off_map(event)
    event.name.gsub (/\\Off_Map/i) {@allowed_off_map = true}
  end
  #----------------------------------------------------------------------------
  # * Check Ladder Tags - Game_Event
  #  - Checks each Event Page for a Tile with a Ladder Terrain Tag
  #----------------------------------------------------------------------------
  def check_ladder_tags(event)
    # Check Each Page of an Event
    for page in event.pages
      # If Page has a Tile Graphic
      if @tile_id > 0
        if $game_map.terrain_tags[@tile_id] and
           $game_map.terrain_tags[@tile_id] > 0 and
           $game_map.terrain_tags[@tile_id] == Game_Caterpillar::LADDER_TAG
          # Push Event onto a Smaller Array, increases speed when checking 
          if not $game_system.caterpillar.ladder_events.include?(self)
            $game_system.caterpillar.ladder_events.push(self)
            return
          end
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Check AL Update - Game_Event
  #  - Reads Event Name for \al_update Comment
  #  - AL = Anti Lag, this Event always updates
  #----------------------------------------------------------------------------
  def check_al_update(event)
    # Check each Event's Name to see if it has \al_update
    event.name.gsub(/\\al_update/i) {@al_update = true}
  end
  #----------------------------------------------------------------------------
  # * Add Follower - Game_Event
  #  - Attempts to add Event ID as a Caterpillar Follower
  #----------------------------------------------------------------------------
  def add_follower(follower_id = nil)
    if not @cat_follower
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
        print "Warning:  The Event you are trying to add needs\n",
          "to have \\cat_follower[x] in the Name!\n\n",
          "Each Map you want to have Cat Followers on should have \n",
          "UNIQUE Cat Follower ID's\n\n",
          "I.E. dont put two \\cat_follower[3] tags on the same Map.\n\n",
          "No Follower Added"
      end
      return      
    end
    $game_system.caterpillar.add_follower(self, follower_id)
  end
  #----------------------------------------------------------------------------
  # * Remove Follower - Game_Event
  #  - Attempts to remove Event ID from Caterpillar Followers
  #----------------------------------------------------------------------------
  def remove_follower(follower_id = nil)
    if not follower_id
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
        print "Warning:  The Event you are trying to Remove needs\n",
          "to have \\cat_follower[x] in the Name!\n\n",
          "No Followers Removed"
      end
      return      
    end
    $game_system.caterpillar.remove_follower(follower_id)
  end
  #---------------------------------------------------------------------------
  # * Passable - game_event
  #  - Check passability for the Cat Actors as their Moves are Exectued
  #---------------------------------------------------------------------------
  alias zeriab_caterpillar_game_event_passable? passable? unless $@
  def passable?(*args)
    if (@caterpillar_actor.nil? and @cat_follower.nil?) or move_list.empty? or
       not $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH]
      return zeriab_caterpillar_game_event_passable?(*args)
    else
      return true
    end
  end
  #-------------------------------------------------------------------------
  # * Cat Check Command XY - game_event
  #  - Placeholder Definition, Intended to be Aliased or Replaced
  #-------------------------------------------------------------------------
  def cat_check_command_xy(cmd)
    return cmd
  end
  # If Heretic's Loop Maps is installed
  if Game_Map.method_defined?(:map_loop_passable?)
    #-------------------------------------------------------------------------
    # * Cat Check Command XY - game_event
    #  - Corrects XY and Real XY Values to prevent "Wandering" on Looping Maps
    #-------------------------------------------------------------------------
    def cat_check_command_xy(cmd)
      # Caterpillare Coordinates from Command Argument
      x = cmd[0]
      y = cmd[1]
      if $game_map.loop_horizontal?
        # Reset X Round Coordinates in Update
        @no_x_loop_round = false
        # Map Width
        w = $game_map.width
        # Logical Move Distance
        t = (x * 128).abs - @real_x
        # If Moving Distance is greater than 1/2 Map Width
        if t.abs > w * 64
          # Don't Round Coordinates in Update
          @no_x_loop_round = true
          # Round Movement Coordinates and Argument
          @x %= w
          x %= w
          # If Logical Coordinates cause Character to move in Wrong Direction
          if t > 0 and x > 0 and x * 128 > @real_x.abs
            # Round Properly
            @real_x %= w * 128
            # Check for Out of Range (Causes Wandering)
            if not ((x * 128).abs - @real_x + (w * 128)).abs < w * 128
              # Force Character to move properly out of normal rounding range
              @real_x += w * 128 if t < w * 128
            end
          elsif t < 0 and x * 128 < @real_x
            # Round Properly
            @real_x %= w * 128
            # Check for Out of Range (Causes Wandering)
            if not ((x * 128).abs - @real_x - (w * 128)).abs < w * 128
              # Force Character to move properly out of normal rounding range
              @real_x -= w * 128 if t > (w * 128).abs * -1
            end
          end
        end
      end
      # For Vertical Looping Maps
      if $game_map.loop_vertical?
        # Reset X Round Coordinates in Update
        @no_y_loop_round = false
        # Map Height
        h = $game_map.height
        # Logical Move Distance
        t = (y * 128).abs - @real_y
        # If Moving Distance is greater than 1/2 Map Width
        if t.abs > h * 64
          # Don't Round Coordinates in Update
          @no_y_loop_round = true
          # Round Movement Coordinates and Argument
          @y %= h
          y %= h
          # If Logical Coordinates cause Character to move in Wrong Direction
          if t > 0 and y <= h and y >= 0 and y * 128 > @real_y
            # Round Properly
            @real_y %= h * 128
            # Check for Out of Range (Causes Wandering)
            if not ((y * 128).abs - @real_y + (h * 128)).abs < h * 128
              # Force Character to move properly out of normal rounding range
              @real_y += h * 128 if t <= h * 128 #Good
            end
          elsif t < 0 and y <= h and y >= 0 and y * 128 < @real_y
            # Round Properly
            @real_y %= h * 128
            # Logical Move Distance
            t = (y * 128).abs - @real_y
            # Check for Out of Range (Causes Wandering)
            if not ((y * 128).abs - @real_y - (h * 128)).abs < h * 128
              # Force Character to move properly out of normal rounding range
              @real_y -= h * 128 if t != 0
            elsif t > 128 and t < h * 128 and t > h * 64
              # Force Character to move properly out of normal rounding range
              @real_y += h * 128
            end
          end
        end        
      end
      return x, y
    end
  end  
  #---------------------------------------------------------------------------
  #
  #    SDK and Non-SDK stuff
  #
  #---------------------------------------------------------------------------
  if Module.constants.include?('SDK')
    #-------------------------------------------------------------------------
    # * Update Movement - Game_Event
    #  - SDK Version
    #-------------------------------------------------------------------------
    alias zeriab_caterpillar_event_update_movement update_movement unless $@
    def update_movement
      # If the Caterpillar is Active
      if @caterpillar_actor and
         $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
         $game_system.caterpillar.cat_actor_in_party?(self)
        # Sets the Animation for Cat Actors EVERY STEP (Due to Poison on Map)
        set_dead_animation
      end      
      # If Not an Active Caterpillar Actor or Follower
      if (@caterpillar_actor.nil? and @cat_follower.nil?) or move_list.empty? or
          not $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] or
          $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH]
        # Return Original or other Aliases (SDK)
        return zeriab_caterpillar_event_update_movement
      end
      # Interrupt if not stopping
      if jumping? or moving?
        return
      end
      # If the Developer Display Errors Option is enabled
      if $check_missing_needs_to_run == true and
         Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS
        # Sets the Animation for Cat Actors
        $game_system.caterpillar.check_missing
      end
      # Retrive the command
      command = move_list[0]
      # Call the command as if it were an Event
      method(command[0]).call(*command[1])
      # Make sure the x and y are right in the end
      @x, @y = cat_check_command_xy(command[2])
      # Remove the command
      move_list.pop
    end
  else # Non-SDK version
    #-------------------------------------------------------------------------
    # * Update - Game_Event (Main Update Method)
    #  - Update Movement - Non SDK Version
    #-------------------------------------------------------------------------
    alias zeriab_caterpillar_game_event_update update unless $@
    def update
      # Interrupt if not stopping
      no_move = jumping? or moving?
      # If the Caterpillar is Active
      if @caterpillar_actor and 
         $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
         $game_system.caterpillar.cat_actor_in_party?(self)
        # Sets the Animation for Cat Actors EVERY STEP (Due to Poison on Map)
        set_dead_animation
      end
      # If the Developer Display Errors Option is enabled
      if Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS and 
         $check_missing_needs_to_run == true
        # Sets the Animation for Cat Actors
        $game_system.caterpillar.check_missing
      end      
      # Call Original or other Aliases
      zeriab_caterpillar_game_event_update
      # Check if it should return
      if $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] &&
         (@caterpillar_actor or @cat_follower) && !move_list.empty? && !no_move
        # Retrive the command
        command = move_list[0]
        # Call the command
        method(command[0]).call(*command[1])
        # Make sure the x and y are right in the end
        @x, @y = cat_check_command_xy(command[2])
        # Remove the command
        move_list.pop
      end
    end
  end
  #---------------------------------------------------------------------------
  # * Erased? - Game_Event
  #  - Returns true or false if an Event is erased
  #---------------------------------------------------------------------------
  def erased?
    return (@erased)
  end
  #---------------------------------------------------------------------------
  # * Unerase - Game_Event
  #  - Bring back an erased event
  #---------------------------------------------------------------------------
  def unerase
    @erased = false
    refresh
  end
end

#==============================================================================
# ** Game_Map
#==============================================================================
class Game_Map
  # Call outside of class, on Initial Game Start or Reset with F12, no cheating
  $walk_off_map = false
  #---------------------------------------------------------------------------
  # * Name - Game_Map
  #  - Returns Name of Map and removes dependancy on the SDK
  #  - Thank you Moonpearl and ForeverZer0!  
  #---------------------------------------------------------------------------
  # Class Variable for Map Info
  @@map_info = load_data("Data/MapInfos.rxdata") 
  def name(id = @map_id) 
    return @@map_info[id].name 
  end 
  #---------------------------------------------------------------------------
  # * Setup - Game_Map
  #  - Transfers Follower Data from one Map to the next
  #      *args : typically just Map ID
  #---------------------------------------------------------------------------
  alias zeriab_caterpillar_game_map_setup setup unless $@
  def setup(*args)
    # Shorthand
    c = $game_system.caterpillar
    # Allows saving transparency across Faded Map Transfers
    c.transferring_actors = c.actors.dup
    # Clears the Caterpillar
    $game_system.caterpillar.clear
    # Clears Ladder Event Array
    $game_system.caterpillar.ladder_events = []
    # Run Original or other Aliases
    zeriab_caterpillar_game_map_setup(*args)
    # Setup Caterpillar on New Map or New Location
    if Game_Caterpillar::AUTO_ORIENT_TO_PLAYER and
       $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
       not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH]
      # Orient each Cat Actor to the Player
      $game_system.caterpillar.orient_to_player
    end
  end
  #--------------------------------------------------------------------------
  # * Valid for Event Update - Game_Map
  #  - Updates Events on or close to the Screen and considers Sprite Size
  #      event : Game_Event (from Map)
  #--------------------------------------------------------------------------
  def valid_for_event_update?(event)
    return event.sprite_on_screen?
  end
  #---------------------------------------------------------------------------
  # * Update_Map_Scroll - Game_Map 
  #  - Handles Map Scrolling in Main Update Method
  #---------------------------------------------------------------------------
  def update_game_map_scroll
    # If scrolling    
	  if @scroll_rest > 0
	    distance = 2 ** @scroll_speed
  	  case @scroll_direction
	    when 2
  		  scroll_down(distance)
	    when 4 
		    scroll_left(distance)
	    when 6  
		    scroll_right(distance)
	    when 8  
		    scroll_up(distance)
	    end
	    @scroll_rest -= distance
  	end    
  end
  #---------------------------------------------------------------------------
  # * Create Map Event Update List - Game_Map
  #  - Can be aliased for smaller Lists for Performance
  #---------------------------------------------------------------------------
  def create_map_event_update_list
    events.values
  end
  #---------------------------------------------------------------------------
  # * Create Map Event Update List - Game_Map
  #  - Can be altered with Aliases for altering Conditions of Update
  #---------------------------------------------------------------------------
  def map_event_update_list_conditions?(event)
    # If Event is In Range, Auto, Parallel, Set Move Route, or Cat Actor
    if not $frame_optimizer or event.trigger == 3 or event.trigger == 4 or
       event.al_update or event.caterpillar_actor or event.cat_follower or
       event.sprite_on_screen?
      # Update this Event
      return true
    end
  end
  #---------------------------------------------------------------------------
  # * Update Game Map Events - Game_Map 
  #  - Updates Events in by Main Map Update Method
  #---------------------------------------------------------------------------
  def update_game_map_events
    # Create a list of Map Events to Update
    event_list = create_map_event_update_list
    # Iterate through the List of Events
    for event in event_list
      # Check for Conditions for Updating the Map Event
      if map_event_update_list_conditions?(event)
        # Update the Event
		    event.update
	    end
	  end
  end
  #---------------------------------------------------------------------------
  # * Update Game Common Events - Game_Map 
  #  - Updates Common Events in by Main Map Update Method
  #---------------------------------------------------------------------------
  def update_game_common_events
	  for common_event in @common_events.values
	    common_event.update
	  end
  end
  #---------------------------------------------------------------------------
  # * Update Game Map Fog - Game_Map 
  #  - Handles Fogs in by Main Map Update Method
  #---------------------------------------------------------------------------
  def update_game_map_fog
    # Update Fog
    @fog_ox -= @fog_sx / 8.0
	  @fog_oy -= @fog_sy / 8.0
	  if @fog_tone_duration >= 1
	    d = @fog_tone_duration
	    target = @fog_tone_target
	    @fog_tone.red = (@fog_tone.red * (d - 1) + target.red) / d
	    @fog_tone.green = (@fog_tone.green * (d - 1) + target.green) / d
	    @fog_tone.blue = (@fog_tone.blue * (d - 1) + target.blue) / d
	    @fog_tone.gray = (@fog_tone.gray * (d - 1) + target.gray) / d
	    @fog_tone_duration -= 1
	  end
	  if @fog_opacity_duration >= 1
	    d = @fog_opacity_duration
	    @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d
	    @fog_opacity_duration -= 1
	  end    
  end
  #---------------------------------------------------------------------------
  # * Update - Game_Map (FULL REDEFINITION)
  #  - Redefined for Framerate Optimizations and Modularized
  #  - Only updates Events in a Valid Scope, Autorun, Parallel, and Cat Actors
  #---------------------------------------------------------------------------
  def update
    # Refresh map if necessary
    refresh if $game_map.need_refresh
    # Update Map Scrolling
    update_game_map_scroll    
    # Update Map Events
    update_game_map_events
    # Update Common Events
    update_game_common_events
    # Update Fog
    update_game_map_fog
  end
  #----------------------------------------------------------------------------
  # * Terrain Tag - Game_Map
  #  - Returns Terrain Tag of Event Tiles
  #  - Open the Tileset in the Database then Save if Game Crashes here
  #      x, y :  Map Coordinates
  #----------------------------------------------------------------------------
  alias caterpillar_ladder_terrain_tag terrain_tag unless $@
  def terrain_tag(x, y)
    # Assign Temporary Value from call to Original or other Aliases
    tag = caterpillar_ladder_terrain_tag(x, y)
    if tag == 0 and $game_switches[Game_Caterpillar::LADDER_EFFECTS]
      # Checks a very small Array for Ladder Terrain Tags
      for event in $game_system.caterpillar.ladder_events
        # If tiles other than self are consistent with coordinates
        if event.tile_id > 0 and
           event.x == x and event.y == y and 
           not event.through
          # If Event Tile has a Terrain Tag 
          if @terrain_tags[event.tile_id] > 0
            # Return the Terrain Tag Value
            return @terrain_tags[event.tile_id]
          end
        end
      end
    end    
    # Return Results of Original or other Aliases if no Ladder Events
    return tag
  end
  # If this method is not provided by Heretic's Loop Maps
  unless method_defined?(:loop?)
    #------------------------------------------------------------------------
    # * Loop? - Game Map
    #  - Method is intended to be defined in other scripts to fallback to this
    #------------------------------------------------------------------------
    def loop?
      return false
    end
  end    
end

#==============================================================================
# ** Scene_Map
#==============================================================================
class Scene_Map
  #--------------------------------------------------------------------------
  # * Transfer Player - Scene_Map
  #  - Checks for Substack Z conditions
  #--------------------------------------------------------------------------
  alias heretic_caterpillar_transfer_player transfer_player unless $@
  def transfer_player
    # If Options are Enabled and Switches in proper setting
    if Game_Caterpillar::AUTO_ORIENT_TO_PLAYER and
       $game_switches[Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH] and
       not $game_switches[Game_Caterpillar::CATERPILLAR_PAUSE_SWITCH] and
       not $game_player.direction_fix and ( ($game_temp.player_transferring and 
       $game_temp.player_new_direction == 8) or $game_player.direction == 8)
      # Set Flag for Substack Z on Player
      $game_player.substack_z = true
    else
      $game_player.substack_z = false
    end
    # If Temp says Player is Transferring
    if $game_temp.player_transferring
      # Update Caterpillar Transferring Map Detection for Auto Orient
      $game_system.caterpillar.cat_player_transferring = true
    end
    # Call Original or other Aliases
    heretic_caterpillar_transfer_player
    # Clear the Temporary Transfer Flag
    $game_system.caterpillar.cat_player_transferring = nil
  end
end

#==============================================================================
# ** Game_Switches
#==============================================================================
class Game_Switches
  #----------------------------------------------------------------------------
  # * [] - Game_Switches
  #  - Erases and Unerases Caterpillar Actors on Caterpillar Switch Change
  #----------------------------------------------------------------------------
  alias zeriab_caterpillar_game_switches_setter :[]= unless $@
  def []=(switch_id, value, *args)
    zeriab_caterpillar_game_switches_setter(switch_id, value, *args)
    if switch_id == Game_Caterpillar::CATERPILLAR_ACTIVE_SWITCH
      $game_system.caterpillar.refresh
    elsif switch_id == Game_Caterpillar::REMOVE_VISIBLE_ACTORS
      if value
        $game_system.caterpillar.erase_non_party_events
      else
        $game_system.caterpillar.unerase_all
      end
    end
  end
end

#==============================================================================
# ** Interpreter
#==============================================================================
class Interpreter
  #----------------------------------------------------------------------------
  # * Change Party Member - Interpreter
  #  - 129 is the Interpreter Command Code for Change Party Member 
  #----------------------------------------------------------------------------
  alias zeriab_caterpillar_interpreter_command_129 command_129 unless $@
  def command_129
    result = zeriab_caterpillar_interpreter_command_129
    $game_system.caterpillar.refresh
    return result
  end
  #----------------------------------------------------------------------------
  # * Change Actor Graphic - Interpreter
  #  - 322 is the Interpreter Command Code for Change Actor Graphic
  #----------------------------------------------------------------------------
  alias zeriab_caterpillar_interpreter_command_322 command_322 unless $@
  def command_322
    # Results of Original or other Aliases
    result = zeriab_caterpillar_interpreter_command_322
    # Update the Caterpillar to check for Graphics
    $game_system.caterpillar.update
    # If Alternate Sprites are being used, set Flags to change the Alt Sprite
    if Game_Caterpillar::DEAD_EFFECT.include?('ALT_SPRITE')
      # If the Player needs a New Sprite for an Alternate Sprite
      if @parameters[0] == 1
        $game_player.need_new_sprite = true
      else
        # Shorthand
        c = $game_system.caterpillar
        # Cat Actor needs a New Sprite for an Alternate Sprite
        c.actor_id_to_event[@parameters[0]].need_new_sprite = true
      end
    end
    # Return caputred Results of Original or other Aliases
    return result
  end
  #--------------------------------------------------------------------------
  # * Update - Interpreter (FULL REDEFINITION)
  #  - INTERPRETER BUGFIX contains several Fixes for Game Hangups
  #  - Repeating Move Route Events are excluded from Waiting
  #  - Allows for Excluding Events with proper Flags from causing Waiting
  #--------------------------------------------------------------------------
  def update
    # Initialize loop count
    @loop_count = 0
    # Loop
    loop do
      # Add 1 to loop count
      @loop_count += 1
      # If 100 event commands ran
      if @loop_count > 100
        # Call Graphics.update for freeze prevention
        Graphics.update
        @loop_count = 0
      end
      # If map is different than event startup time
      if $game_map.map_id != @map_id
        # Change event ID to 0
        @event_id = 0
      end
      # If a child interpreter exists
      if @child_interpreter != nil
        # Update child interpreter
        @child_interpreter.update
        # If child interpreter is finished running
        unless @child_interpreter.running?
          # Delete child interpreter
          @child_interpreter = nil
        end
        # If child interpreter still exists
        if @child_interpreter != nil
          return
        end
      end
      # If waiting for message to end
      if @message_waiting
        return
      end
      # If Interpreter is waiting for ANY move to end
      if @move_route_waiting
        # Shorthand
        p = $game_player
        # If player is forcing move route and not repeating (BUGFIX)
        if p.move_route_forcing and not p.move_route.repeat and
           not (p.move_route_wait_excluded and p.wait_count > 0)
          return
        end
        # Loop (map events)
        for event in $game_map.events.values
          # Just skip this event because it is excluded, look at next event
          next if event.move_route_forcing and event.move_route_wait_excluded
          # If this event is forcing but not repeating move route (BUGFIX)
          if event.move_route_forcing and not event.move_route.repeat
            return
          end
        end
        # Clear move end waiting flag
        @move_route_waiting = false
      end
      # If waiting for button input
      if @button_input_variable_id > 0
        # Run button input processing
        input_button
        return
      end
      # If waiting
      if @wait_count > 0
        # Decrease wait count
        @wait_count -= 1
        return
      end
      # If an action forcing battler exists
      if $game_temp.forcing_battler != nil
        return
      end
      # If a call flag is set for each type of screen
      if $game_temp.battle_calling or
         $game_temp.shop_calling or
         $game_temp.name_calling or
         $game_temp.menu_calling or
         $game_temp.save_calling or
         $game_temp.gameover
        return
      end
      # If list of event commands is empty
      if @list == nil
        # If main map event
        if @main
          # Set up starting event
          setup_starting_event
        end
        # If nothing was set up
        if @list == nil
          return
        end
      end
      # If return value is false when trying to execute event command
      if execute_command == false
        return
      end
      # Advance index
      @index += 1
    end
  end
  #----------------------------------------------------------------------------
  # * Pathfind - Interpreter
  #  - Dipslay a Warning that Pathfind Script not installed
  #  - Method is not defined if Pathfind Script is installed above this one
  #----------------------------------------------------------------------------
  # Advise if Pathfind called but not installed
  if not self.method_defined? ('pathfind')
    def pathfind(*args)
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        print "Pathfind Script Not Installed"
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Set Move Route - Interpreter
  #  - Set Move Route is Command Code 209
  #  - Calls to Set Move Route will make an Event Always Update with Anti Lag
  #----------------------------------------------------------------------------
  alias anti_lag_command_209 command_209 unless $@
  def command_209
    # Run the Original
    anti_lag_command_209
    # Get character
    character = get_character(@parameters[0])
    # If no character exists
    if character == nil or character.is_a?(Game_Player)
      # Continue
      return true
    end
    # Set @al_update Flag
    character.al_update = true
    # Set Move Route successful
    return true
  end
  #----------------------------------------------------------------------------
  # * Fade Event - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def fade_event(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"fade_event\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end
  #----------------------------------------------------------------------------
  # * Turn Toward Event - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def turn_toward_event(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"move_toward_event(event_id)\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end
  #----------------------------------------------------------------------------
  # * Turn Away From Event - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def turn_away_from_event(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"move_away_from_event(event_id)\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end
  #----------------------------------------------------------------------------
  # * Move Route Wait Exclude - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def move_route_wait_exclude
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"move_route_wait_include\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end
  #----------------------------------------------------------------------------
  # * Move Route Wait Include - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def move_route_wait_include
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"move_route_wait_include\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end 
  #----------------------------------------------------------------------------
  # * Set Flat - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def set_flat(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"set_flat\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end     
  #----------------------------------------------------------------------------
  # * Set Z - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def set_z(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"set_z(", args, ")\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end    
  #----------------------------------------------------------------------------
  # * Reset Z - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def reset_z(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"reset_z\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end   
  #----------------------------------------------------------------------------
  # * Set Sub Z - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def set_sub_z(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"set_sub_z\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window"
    end
  end
  #----------------------------------------------------------------------------
  # * Add Follower - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def add_follower(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"add_follower(", args[0], ")\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window\n",
            "and use the Drop Down Menu to select the Event\n",
            "that you want to add as a Follower."
    end
  end    
  #----------------------------------------------------------------------------
  # * Remove Follower - Interpreter
  #  - Informational Warning about calling from wrong Script Window
  #----------------------------------------------------------------------------
  def remove_follower(*args)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
      print "Please call \"remove_follower(", args[0], ")\" from\n",
            "\"Edit Event\" -> \"Set Move Route\" -> Scripts Window\n",
            "instead of \n\"Edit Event\" -> Scripts Window\n",
            "and use the Drop Down Menu to select the Event\n",
            "that you want to Remove as a Follower."
    end
  end  
  #----------------------------------------------------------------------------
  # * Cat To Player - Interpreter
  #  - Turns all Cat Actors to the same Direction as the Player
  #      opacity     : [Optional] Fades upon Stack
  #      duration    : [Optional] Duration of Fade
  #      turn_player : [Optional] Matches Player Direction upon Stack
  #----------------------------------------------------------------------------
  def cat_to_player(opacity = nil, duration = nil, turn_player = false)
    $game_system.caterpillar.cat_to_player(opacity, duration, turn_player)
  end
  #----------------------------------------------------------------------------
  # * Orient Cat to Player - Interpreter
  #  - Call from Interpreter 'orient_cat_to_player'
  #  - Default Arguments are delared here and just uses Cat to Player method
  #      opacity     : [Optional] Fades upon Stack
  #      duration    : [Optional] Duration of Fade
  #      turn_player : [Optional] Value passed as True to Turn
  #----------------------------------------------------------------------------
  def orient_cat_to_player(opacity = nil, duration = nil)
    $game_system.caterpillar.orient_cat_to_player(opacity, duration)
  end
  #----------------------------------------------------------------------------
  # * Fade Cat to Player - Interpreter
  #  - Fades Caterpillar to Opacity Target on Last Move
  #  - Moves the whole Caterpillar to the Player, then Clears Move Route
  #      opacity     : [Optional] Fades upon Stack
  #      duration    : [Optional] Duration of Fade
  #      turn_player : [Optional] Use True to match Player Direction
  #----------------------------------------------------------------------------
  def fade_cat_to_player(opacity, duration, turn_player = false)
    $game_system.caterpillar.cat_to_player(opacity, duration, turn_player)
  end  
  #----------------------------------------------------------------------------
  # * Is Using Ladder? - Interpreter
  #  - Returns the value of a Specific Events @using_ladder state
  #----------------------------------------------------------------------------
  def is_using_ladder?
    return $game_map.events[@event_id].using_ladder
  end
  #----------------------------------------------------------------------------
  # * Party Using Ladder? - Interpreter
  #  - Returns true if any Caterpillar Members are on a Ladder
  #----------------------------------------------------------------------------
  def party_using_ladder?
    return $game_system.caterpillar.party_using_ladder?
  end  
  #----------------------------------------------------------------------------
  # * Orient To Player - Interpreter
  #  - Turns all Cat Actors to the same direction as the Player 
  #  - Useful during Transport
  #----------------------------------------------------------------------------
  def orient_to_player
    $game_system.caterpillar.orient_to_player
  end
  #----------------------------------------------------------------------------
  # * Turn Cat - Interpreter
  #  - Turns all Cat Actors to new direction, does Not affect Player
  #      direction : Text or Numeric Direction
  #      delay     : Wait Time in Frames between each sequential Actors Turn
  #----------------------------------------------------------------------------
  def turn_cat(direction, delay = nil)
    $game_system.caterpillar.turn_cat(direction, delay)
  end  
  #----------------------------------------------------------------------------
  # * Turn Cat Toward Event - Interpreter
  #  - Turns all Cat Actors to Face and Event, does Not affect Player
  #      event_id  : Event to Turn Toward
  #      repeat    : Creates a Move Route for Turning that Repeats
  #      delay     : Wait Time in Frames between each sequential Actors Turn
  #----------------------------------------------------------------------------
  def turn_cat_toward_event(event_id, repeat = false, delay = nil)
    $game_system.caterpillar.turn_cat_toward_event(event_id, repeat, delay)
  end
  #----------------------------------------------------------------------------
  # * Turn Cat Away From Event - Interpreter
  #  - Turns all Cat Actors to Face Away From Event, does Not affect Player
  #      event_id  : Event to Turn Away From
  #      repeat    : Creates a Move Route for Turning that Repeats
  #      delay     : Wait Time in Frames between each sequential Actors Turn
  #----------------------------------------------------------------------------
  def turn_cat_away_from_event(event_id, repeat = false, delay = nil)
    $game_system.caterpillar.turn_cat_away_from_event(event_id, repeat, delay)
  end
  #----------------------------------------------------------------------------
  # * Force Walk - Interpreter
  #  - Forces all Cat Actors to have a Walk Animation, regardless if Dead
  #  - Depreceated.  Left in for Legacy Support
  #----------------------------------------------------------------------------
  def force_walk
    # Pass data straight thru to the right method
    $game_system.caterpillar.force_walk
  end
  #----------------------------------------------------------------------------
  # * Force Ghost to Opaque - Interpreter
  #  - Forces all Cat Actors to Opacity of 255, regardless if Dead or Not
  #  - Depreceated.  Left in for Legacy Support
  #----------------------------------------------------------------------------
  def force_ghost_to_opaque
    # Pass data straight thru to the right method
    $game_system.caterpillar.force_ghost_to_opaque
  end
  #----------------------------------------------------------------------------
  # * Force Dead to Normal - Interpreter
  #  - Forces all Cat Actors to Normal Appearance, Walk Anime and Opacity
  #  - Depreceated.  Left in for Legacy Support
  #----------------------------------------------------------------------------
  def force_dead_to_normal
    # Pass data straight thru to the right method
    $game_system.caterpillar.force_dead_to_normal
  end
  #----------------------------------------------------------------------------
  # * Clear Moves - Interpreter
  #  - Clears all Registered Caterpillar Movement Commands
  #----------------------------------------------------------------------------
  def clear_moves
    $game_system.caterpillar.clear_moves
  end
  #----------------------------------------------------------------------------
  # * Move Pop - Interpreter
  #  - Pops the Registered Caterpillar Movement Command from End of Array
  #----------------------------------------------------------------------------
  def move_pop
    $game_system.caterpillar.move_pop
  end  
  #----------------------------------------------------------------------------
  # * Delete Last Move - Interpreter
  #  - Deletes the Last Registered Player Movement to prevent Cat following
  #  - Useful when Passability Situations change due to Tile Changes
  #----------------------------------------------------------------------------
  def delete_last_move
    # Pass data straight thru to the right method with right args
    $game_system.caterpillar.del_last_move
  end
  #----------------------------------------------------------------------------
  # * Clear Actor Force Move Route - Interpreter
  #  - Clears Forced Move Routes for One Actor
  #      actor : Caterpillar Member to clear the Move Route
  #----------------------------------------------------------------------------
  def clear_actor_force_move_route(actor)
    $game_system.caterpillar.clear_actor_force_move_route(actor)
  end
  #----------------------------------------------------------------------------
  # * Clear Actor Force Move Routes - Interpreter
  #  - Clears Forced Move Routes for all Caterpillar Members
  #----------------------------------------------------------------------------
  def clear_cat_force_move_routes
    $game_system.caterpillar.clear_cat_force_move_routes
  end
  #----------------------------------------------------------------------------
  # * Cat Stagger - Interpreter
  #  - Unstacks Caterpillar, Polar Opposite of Cat To Player
  #      dir    : Direction to Stager (Text or Numeric)
  #      offset : Additional Distance behind the Player's Character
  #----------------------------------------------------------------------------
  def cat_stagger(dir, offset = 0)
    $game_system.caterpillar.cat_stagger(dir, offset)
  end
  #----------------------------------------------------------------------------
  # * Get Opposite Direction - Interpreter
  #  - Returns Numeric Direction Opposite of Facing
  #----------------------------------------------------------------------------
  def get_opposite_direction
    # Return 0 if no valid direction
    return 0 if @direction == 0
    # Return Opposite Direction
    return 10 - @direction
  end
  #----------------------------------------------------------------------------
  # * Cat Vanish - Interpreter
  #  - Instantly causes all Caterpillar Members and Player to 0 Opacity
  #----------------------------------------------------------------------------
  def cat_vanish
    $game_system.caterpillar.cat_vanish
  end
  #----------------------------------------------------------------------------
  # * Cat Speed - Interpreter
  #  - Set the Move Speed for all Caterpillar Members and Player
  #      new_speed : Move Speed
  #----------------------------------------------------------------------------
  def cat_speed(new_speed)
    $game_system.caterpillar.cat_speed(new_speed)
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Event - Interpreter
  #  - Fades Entire Caterpillar At Same Time, (Optional) Player
  #      opacity  : Opacity Fade Target
  #      duration : Time in Frames of Fade
  #      player   : (Optional - Default: true) Include the Player in Fade
  #----------------------------------------------------------------------------
  def cat_fade_event(opacity, duration, player = true)
    $game_system.caterpillar.cat_fade_event(opacity, duration, player)
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Event Reset - Interpreter
  #  - Restores Entire Caterpillar At Same Time, Player Included
  #      duration : Time in Frames for Fade Transition
  #----------------------------------------------------------------------------
  def cat_fade_event_reset(duration)
    $game_system.caterpillar.cat_fade_event_reset(duration)
  end  
  #----------------------------------------------------------------------------
  # * Pass Actors On Ladders? - Interpreter
  #  - Returns if Pass Actors on Ladders Option
  #----------------------------------------------------------------------------
  def pass_actors_on_ladders?
    return $game_system.caterpillar.pass_actors_on_ladders
  end
  #----------------------------------------------------------------------------
  # * Cat Fade Out Per Step - Interpreter
  #  - Sets the Party to Fade Out on the Next Incremented Step
  #     duration          : Duration of Fade (Auto Set to 20 Frames if not set)
  #     auto_fade_back_in : True / False - Fade back in when all faded out
  #----------------------------------------------------------------------------
  def cat_fade_out_per_step(duration = nil, auto_fade_back_in = nil)
    duration = 20 if (duration and not duration.is_a?(Numeric)) or !duration
    $game_system.caterpillar.cat_fade_out_per_step(duration, auto_fade_back_in)
  end
  #----------------------------------------------------------------------------
  # * Cat Fade In Per Step - Interpreter
  #  - Sets the Party to Fade In each Incremental Step
  #  - Call manually when auto_fade_back_in is false in Cat Fade Out Per Step
  #      duration : Duration of Transition Fade Opacity
  #----------------------------------------------------------------------------
  def cat_fade_in_per_step(duration = nil)
    duration = 20 if (duration and not duration.is_a?(Numeric)) or !duration
    $game_system.caterpillar.cat_fade_in_per_step(duration)
  end
  #----------------------------------------------------------------------------
  # * Cat Backup - Interpreter
  #  - Causes entire Caterpillar to take One Step Back
  #      delay    : Delay between each Caterpillar Member's Movement
  #      pushback : Player moves back first, then sequentially
  #----------------------------------------------------------------------------
  def cat_backup(delay = nil, pushback = nil)
    $game_system.caterpillar.cat_backup(delay, pushback)
  end
  #----------------------------------------------------------------------------
  # * Set Ladder Speed - Interpreter  
  #  - Changes the Movement Speed while on Ladders
  #      new_speed : Move Speed
  #----------------------------------------------------------------------------
  def set_ladder_speed(new_speed)
    $game_system.caterpillar.set_ladder_speed(new_speed)
  end
  #----------------------------------------------------------------------------
  # * Cat Refresh - Interpreter  
  #  - Refresh the Caterpillar to check for Character Changes
  #  - Zeriab says "Use Sparingly" as this script is based on his Caterpillar
  #----------------------------------------------------------------------------
  def cat_refresh
    $game_system.caterpillar.refresh
  end
  #----------------------------------------------------------------------------
  # * Following? - Interpreter
  #  - Returns True or False if a Follower ID is in the Caterpillar
  #      follower_id : Follower ID (1, 2, 3, etc) from \cat_follower[2] Name
  #----------------------------------------------------------------------------
  def following?(follower_id)
    return $game_system.caterpillar.follower_ids.include?(follower_id)
  end
  #----------------------------------------------------------------------------
  # * Any Followers? - Interpreter
  #  - Returns True if any Followers (not Actors) are in the Caterpillar
  #----------------------------------------------------------------------------
  def any_followers?
    return ($game_system.caterpillar.follower_ids.size > 0)
  end
  #----------------------------------------------------------------------------
  # * Pass Actors On Ladders - Interpreter  
  #  - Changes Option of "Pass Actors On Ladders"
  #      bool : True or False
  #----------------------------------------------------------------------------
  def pass_actors_on_ladders(bool)
    if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS and
       bool.to_s != "true" and bool.to_s != "false"
      # Print an Error
      print "Warning: pass_actors_on_ladders expects\n\"true\" or \"false\"",
            "ONLY!\npass_actors_on_ladders(true)\npass_actors_on_ladders(false)"
      return
    end
    $game_system.caterpillar.pass_actors_on_ladders = bool
  end
  #----------------------------------------------------------------------------
  # * Get Cat Position ID - Interpreter
  #  - Required by Multiple Message Windows (Heretic Versions)
  #  - Returns Event ID of Caterpillar Actor in Position
  #  - Allows M.M.W. feature \P[c1] Text to appear over C1 Event
  #      cat_position : index
  #----------------------------------------------------------------------------
  def get_cat_position_id(cat_position)
    # Return the Event ID of the Cat Actor in cat_position
    return $game_system.caterpillar.actors[cat_position].id
  end
  #----------------------------------------------------------------------------
  # * Get Cat Position Actor ID - Interpreter
  #  - Returns Actor ID of Actor in Caterpillar Position
  #      cat_position : index
  #----------------------------------------------------------------------------
  def get_cat_position_actor_id(cat_position)
    return $game_system.caterpillar.actors[cat_position].caterpillar_actor
  end   
  #----------------------------------------------------------------------------
  # * Get Cat Position Name - Interpreter
  #  - Returns the Name of the Actor in a Caterpillar Position
  #  - Example: get_cat_position_name(2) returns "Estelle" or "Basil"
  #      actor_position : index
  #----------------------------------------------------------------------------
  def get_cat_position_name(actor_position)
    actor = $game_system.caterpillar.actors[actor_position - 1]
    return nil if actor.nil? or actor_position < 1 or 
                  actor_position > $game_party.actors.size or
                  not $game_system.caterpillar.is_cat_actor?(actor)
    return $game_party.actors[actor_position].name
  end  
  #----------------------------------------------------------------------------
  # * Cat Position Filled? - Interpreter
  #  - Returns True or False if position has a Cat Actor or Follower
  #----------------------------------------------------------------------------
  def cat_position_filled?(position)
    if not position.is_a?(Numeric)
      if $DEBUG and Game_Caterpillar::DISPLAY_DEVELOPER_ERRORS == true
        print "Warning: cat_position_filled?(n)",
              "expects that 'n' is a Number!"
        return false
      end
    end
    # Shortcut, helps keep scritps on one line
    $game_system.caterpillar.cat_position_filled?(position)
  end  
  #----------------------------------------------------------------------------
  # * Cat Forward - Interpreter
  #  - Creates a Move List for Player to take One Step Forward for each Actor
  #  - Useful when Eventing Movements from Off Screen
  #----------------------------------------------------------------------------
  def cat_forward
    $game_player.cat_forward
  end
  #----------------------------------------------------------------------------
  # * Generate Cat Moves - Interpreter
  #  - Generates a Move List for Cat Actors from current location
  #----------------------------------------------------------------------------
  def cat_generate_moves
    $game_system.caterpillar.cat_generate_moves
  end
end

#==============================================================================
# ** Sprite Character
#==============================================================================
class Sprite_Character < RPG::Sprite
  #----------------------------------------------------------------------------
  # * Update - Sprite Character
  #  - Stores the Size of the Sprites for proper Character Updating
  #----------------------------------------------------------------------------
  alias caterpillar_sprite_get_size_update update unless $@
  def update
    # Check for Skippable Conditions
    if @tile_id == @character.tile_id and
       @character_name == @character.character_name and
       @character_hue == @character.character_hue
      # If Sprite has no Graphic, Invisible, or Off the Screen
      if @character.animation_id == 0 and ( (@tile_id == 0 and 
         @character_name == "") or (self.opacity == 0 and 
         @character.opacity == 0) or not @character.sprite_on_screen?)
        # Set Flag for other Scripts to not Update the Sprite
        @character.dont_update_sprite = true
        # Prevent Sprite Updating
        return
      end
    end
    # Call Original or other Aliases
    caterpillar_sprite_get_size_update
    # Set Sprite Size in Event for proper Anti Lag Display
    @character.set_sprite_size(@cw, @ch, self.zoom_x, self.zoom_y)
  end
end

#==============================================================================
# ** Alt Sprite Character
#==============================================================================
class Alt_Sprite_Character < RPG::Sprite
  #----------------------------------------------------------------------------
  # * Public Instance Variables - Alt_Sprite_Character
  #----------------------------------------------------------------------------
  attr_reader   :character
  #----------------------------------------------------------------------------
  # * Object Initialization - Alt_Sprite_Character
  #  - Create the Alternate Character Sprite and Position Sprite
  #----------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    update    
  end
  #----------------------------------------------------------------------------
  # * Update - Alt_Sprite_Character
  #  - Updates Sprite Animations and Properties
  #----------------------------------------------------------------------------
  def update
    # Call RPG Sprite Update for Animations
    super
    # If tile ID, file name, or hue are different from current ones
    if @tile_id != @character.tile_id or
       @character_name != @character.alt_character_name or
       @character_hue != @character.character_hue
      # Remember tile ID, file name, and hue
      @tile_id = @character.tile_id
      @character_name = @character.alt_character_name
      @character_hue = @character.character_hue
      # If tile ID value is valid
      if @tile_id >= 384
        self.bitmap = RPG::Cache.tile($game_map.tileset_name,
          @tile_id, @character.character_hue)
        self.src_rect.set(0, 0, 32, 32)
        self.ox = 16
        self.oy = 32
      # If tile ID value is invalid
      else
        self.bitmap = RPG::Cache.character(@character.alt_character_name,
          @character.character_hue)
        @cw = bitmap.width / 4
        @ch = bitmap.height / 4
        self.ox = @cw / 2
        self.oy = @ch
      end
    end
    # Set visible situation
    self.visible = (not @character.transparent)
    # Shorthand
    c = @character
    dead_switch = $game_switches[Game_Caterpillar::DEAD_ACTOR_EFFECTS]
    z_opacity = Game_Caterpillar::ZOMBIE_OPACITY
    c_opacity = Game_Caterpillar::COFFIN_OPACITY
    a_opacity = Game_Caterpillar::ALT_SPRITE_OPACITY
    # Setup Character Width and Height Variables      
    @cw = bitmap.width / 4
    @ch - bitmap.height / 4
    self.ox = @cw / 2
    self.oy = @ch  
    # Set the Alt Player Sprite Walk Animation to Match Players      
    sx = c.pattern * @cw
    # Set the Alt Player Sprite Direction to Match Players
    sy = (c.direction - 2) / 2 * @ch
    # Display the Relevant part of Character Sprite for Direction and Step
    self.src_rect.set(sx, sy, @cw, @ch)      
    # Position matches Character
    self.x = c.screen_x
    self.y = c.screen_y
    self.z = c.screen_z(@ch)
    # Set opacity level, blend method, and bush depth
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    # Forces Opacity to Alt Opacity
    self.opacity = c.alt_opacity
    # If Zombie
    if c.zombie and dead_switch
      # Sets the Zombie Visible Flag
      if c.alt_opacity == z_opacity and not c.zombie_visible
        # Set the Zombie Visible Flag to True
        c.zombie_visible = true
      end
    # If Coffin
    elsif c.coffin and dead_switch
      # Sets the Zombie Visible Flag
      if c.alt_opacity == z_opacity and not c.coffin_visible
        # Set the Zombie Visible Flag to True
        c.coffin_visible = true
      end
    # If Alt Character Sprite
    elsif c.alt_char_sprite and dead_switch
      # Check for change to Graphics
      if c.need_new_sprite
        # If Player
        if c == $game_player
          n = $game_actors[1].character_name
        else
          # Get the Replacement Graphic Name
          n = $game_actors[@character.caterpillar_actor].character_name
        end
        # Get new Character Name for Alternate Graphic from Config
        new_name = $game_system.caterpillar.get_alt_sprite_graphic(n)
        # Assign New Alt Character Name to Character
        @character.alt_character_name = new_name
        # Clear the Need Sprite Flag
        c.need_new_sprite = false
      end
      # Sets the Alt Char Sprite Visible Flag
      if c.alt_opacity == a_opacity and not c.alt_char_sprite_visible
        # Set the Alt Char Sprite Visible Flag to True
        c.alt_char_sprite_visible = true
      end          
    else
      # If Dead Effect and Main Sprite is not visible due to Dead Effect
      if self.opacity == 0 and c.normal_effect_transition and
         (c.zombie_visible or c.coffin_visible or c.alt_char_sprite_visible)
        # Reset Transition To Normal Flag
        c.normal_effect_transition = false          
        # Reset Visibility Flags
        c.zombie_visible = false
        c.coffin_visible = false
        c.alt_char_sprite_visible = false
      end
    end
    # Zoom the Sprite if Sprite is Zoomed
    self.zoom_x = @character.sprite_zoom_x if @character.sprite_zoom_x
    self.zoom_y = @character.sprite_zoom_y if @character.sprite_zoom_y    
    # Set Sprite Size in Event for proper Anti Lag Display
    @character.set_sprite_size(@cw, @ch, self.zoom_x, self.zoom_y)
  end
end

#==============================================================================
# ** Spriteset Map
#==============================================================================
class Spriteset_Map
  #----------------------------------------------------------------------------
  # * Object Initialization - Spriteset Map
  #  - Creates Alternate Character Sprites for Caterpillar Actors
  #----------------------------------------------------------------------------
  alias caterpillar_spriteset_map_initialize initialize unless $@
  def initialize
    # Call Original or other Aliases
    caterpillar_spriteset_map_initialize
    # Default
    dead_effect_sprite = nil
    # Look for Effects in Caterpillar Config
    for effect in Game_Caterpillar::DEAD_EFFECT
      if ['ZOMBIE','COFFIN','ALT_SPRITE'].include?(effect)
        dead_effect_sprite = effect
      end
    end
    # If there are any Effect Sprites (Zombie, Coffin, or Alt Graphic)
    if dead_effect_sprite
      # Scan Events for Player and Active Caterpillar Actors
      for event in $game_map.events.values
        # Create Alternate Sprites for Caterpillar Actors
        if event.caterpillar_actor
          # Branch by Dead Effect Type (Zombie, Coffin, or Alt Character)
          case dead_effect_sprite
          when 'ZOMBIE'
            event.alt_character_name = Game_Caterpillar::ZOMBIE_GRAPHIC
          when 'COFFIN'
            event.alt_character_name = Game_Caterpillar::COFFIN_GRAPHIC
          when 'ALT_SPRITE'
            # Get the Normal Graphic Name
            name = $game_actors[event.caterpillar_actor].character_name
            # Get new Character Name for Alternate Graphic from Config
            new_name = $game_system.caterpillar.get_alt_sprite_graphic(name)
            # Assign Name to Event
            event.alt_character_name = new_name
          end          
          # Create Alternate Sprite Character
          sprite = Alt_Sprite_Character.new(@viewport1, event)
          # Add the Alt Sprite to Sprites Array
          @character_sprites.push(sprite)        
        end
      end
      # Branch by Dead Effect Type (Zombie, Coffin or Alt Character)
      case dead_effect_sprite
      when 'ZOMBIE'
        $game_player.alt_character_name = Game_Caterpillar::ZOMBIE_GRAPHIC
      when 'COFFIN'
        $game_player.alt_character_name = Game_Caterpillar::COFFIN_GRAPHIC
      when 'ALT_SPRITE'
        # Get the Player's Graphic File Name
        name = $game_actors[1].character_name
        # Get new Character Name for Alternate Graphic from Config
        new_name = $game_system.caterpillar.get_alt_sprite_graphic(name)
        # Assign the New Character Name for the Alternate Graphic from Config
        $game_player.alt_character_name = new_name
      end
      # Create Alternate Character Sprite for Player
      sprite = Alt_Sprite_Character.new(@viewport1, $game_player)
      # Add the Player's Alt Sprite to Sprites Array
      @character_sprites.push(sprite)
    end
  end
end