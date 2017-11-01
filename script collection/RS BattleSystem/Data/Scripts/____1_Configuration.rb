#==============================================================================
#
#                     C O N F I G U R A T I O N   P A G E 
#
#------------------------------------------------------------------------------
#  * (1) Configuration:  The Sprite Battler Class (initialize system)
#------------------------------------------------------------------------------
#
# ** Animated Battlers - Enhanced   ver. 13.8                      (01-07-2012)
#    -and-
# ** Animated Battlers VX           ver. 3.7                       (01-07-2012)
#
#============================================================================== 

  #==========================================================================
  #   ****                     ARROW CONTROLS                        ****   #
  #==========================================================================
  # * Just moves the targetting arrow around
  #--------------------------------------------------------------------------
  MNK_ARROW_X             = 14      # The x position for your target cursor
  MNK_ARROW_Y             = 10      # The y position for your target cursor
  
  #==========================================================================
  #   ****                    GENERAL CONTROLS                       ****   #
  #==========================================================================

  # * Default Battler Style Switches
  #--------------------------------------------------------------------------        
  DEFAULT_ENEMY           = true   # If true, these switches allows the use
  DEFAULT_ACTOR           = false   # of default battlers for actors/enemies
  DEFAULT_ENEMY_ID        = []     # Ids of enemies using default battlers
  DEFAULT_ACTOR_ID        = []     # Ids of actors using default battlers
  DEFAULT_COLLAPSE_ACTOR  = false   # If true, restores the old 'red fade'
  DEFAULT_COLLAPSE_ENEMY  = false   #   collapse effect (using spritesheets)

  # * Ccoa Spritestrip Style Switches
  #--------------------------------------------------------------------------        
  CCOA_ENEMY              = false   # If true, these switches allows the use
  CCOA_ACTOR              = false   # of ccoa spritestrips for actors/enemies
  CCOA_ENEMY_ID           = []      # Ids of enemies using ccoa spritestrips
  CCOA_ACTOR_ID           = []     # Ids of actors using ccoa spritestrips
  
  # * Background Battler Screentone Switches
  #   Note:  Battle animations and damage pops reside in the same viewport as
  #          the battlers.  If a battler's tone is altered by the screentone,
  #          so shall the battle animation and damage pops for that battler.
  #--------------------------------------------------------------------------        
  SCREENTONE_ENEMY_MATCH  = true    # If true, the actors/enemies tones match
  SCREENTONE_ACTOR_MATCH  = false   # with the background.  If false, no fix.
  
  # * Animation Frames and Animation Speed
  #--------------------------------------------------------------------------    
  MNK_SPEED               = 4       # Framerate speed of the battlers
  MNK_RUSH_SPEED          = 1.5     # Melee/Skill/Item motion speed of the battlers
  MNK_POSES               = 11      # Maximum # of poses (stances) in the template
  MNK_FRAMES              = 4       # Maximum # of frames in each pose
  MNK_FRAMES_STANDARD     = 4       # Standard # of frames played in each pose.
  
  # Individual Spritesheet Control Center
  #--------------------------------------------------------------------------        
  MNK_POSES_ENEMY         = {}  # ID and # of poses for each enemy
  MNK_FRAMES_ENEMY        = nil       # ID and # of frames for each enemy
  MNK_POSES_ACTOR         = {}  # ID and # of poses for each actor
  MNK_FRAMES_ACTOR        = nil       # ID and # of frames for each actor.
      
  # * Wooziness Rates
  #-------------------------------------------------------------------------- 
  MNK_LOW_HP_PERCENTAGE   = 0.25                    # Health% for WOOZY pose.
  MNK_LOW_HP_ACTOR        = {}  # Ind. health% for actors.
  MNK_LOW_HP_ENEMY        = {}             # Ind. health% for enemies.
  MNK_LOW_HP_FLAT         = false                   # If true, flat rate hp
  
    
    
  #==========================================================================
  #   ****                   POSE CONTROL CENTER                     ****   #
  #==========================================================================
    
  # Editable Template (Some people wanted to change their template design)
  #--------------------------------------------------------------------------
  MNK_POSE1   =   1   # Sets the 'Ready Pose'  (MNK_POSE1)   #1 in your template
  MNK_POSE2   =   2   # Sets the 'Struck Pose' (MNK_POSE2)   #2 in your template
  MNK_POSE3   =   3   # Sets the 'Woozy Pose'  (MNK_POSE3)   #3 in your template
  MNK_POSE4   =   4   # Sets the 'Block Pose'  (MNK_POSE4)   #4 in your template
  MNK_POSE5   =   5   # Sets the 'Charge Pose' (MNK_POSE5)   #5 in your template
  MNK_POSE6   =   6   # Sets the 'Retreat Pose'(MNK_POSE6)   #6 in your template
  MNK_POSE7   =   7   # Sets the 'Attack Pose' (MNK_POSE7)   #7 in your template
  MNK_POSE8   =   8   # Sets the 'Item Pose'   (MNK_POSE8)   #8 in your template
  MNK_POSE9   =   9   # Sets the 'Skill Pose'  (MNK_POSE9)   #9 in your template
  MNK_POSE10  =  10   # Sets the 'Victory Pose'(MNK_POSE10) #10 in your template
  MNK_POSE11  =  11   # Sets the 'Defeat Pose' (MNK_POSE11) #11 in your template
    
  # Editable Template (for Custom Actor Spritesheets)
  #--------------------------------------------------------------------------
  MNK_APOSE1   =   {2 => 2} 
  MNK_APOSE2   =   {2 => 2}   # Basil is using a Charset graphic as a battler.
  MNK_APOSE3   =   {2 => 2}   # The battler was copied into the Battler folder.
  MNK_APOSE4   =   {2 => 2}   # This setup allows you to use Charactersets for
  MNK_APOSE5   =   {2 => 2}   # battlers.
  MNK_APOSE6   =   {2 => 3} 
  MNK_APOSE7   =   {2 => 2} 
  MNK_APOSE8   =   {2 => 2} 
  MNK_APOSE9   =   {2 => 2} 
  MNK_APOSE10  =   {2 => 2}
  MNK_APOSE11  =   {2 => 2}
    
  # Editable Template (for Custom Enemy Spritesheets)
  #--------------------------------------------------------------------------
  MNK_EPOSE1   =   {1 => 2} 
  MNK_EPOSE2   =   {1 => 2}   # Did the same to the ghosts.  Note that enemies have
  MNK_EPOSE3   =   {1 => 2}   # no victory pose.
  MNK_EPOSE4   =   {1 => 2}   
  MNK_EPOSE5   =   {1 => 2}   
  MNK_EPOSE6   =   {1 => 3} 
  MNK_EPOSE7   =   {1 => 2} 
  MNK_EPOSE8   =   {1 => 2} 
  MNK_EPOSE9   =   {1 => 2} 
  MNK_EPOSE10  =   {1 => 2}   
  MNK_EPOSE11  =   {1 => 3}  # Setting the ghost to an invalid pose erases it.
     
  #==========================================================================
  #   ****                     CCOA POSE CENTER                      ****   #
  #==========================================================================
  
  # This is a simple array holding the individual string names of your custom
  # ccoa spritesheet suffixes.   They are loaded  into the array in the order
  # of the pose values.  So your first pose (typically 'Ready')  would be the
  # first pose in the array, followed by the next, and thereafter.
  #--------------------------------------------------------------------------

  CCOA_POSES = [  "_ready", "_hit", "_lowhp", "_guard", "_moveto", "_movefrom",
                  "_attack",  "_item",  "_skill", "_victory", "_dead"]

  
  #==========================================================================
  #   ****                 RANDOM ATTACK POSE CENTER                 ****   #
  #==========================================================================
  
  # Each value can be set to nil so no optional melee attack poses are avail-
  # able, or you can enter an array [ ] of poses that can be chosen randomly
  # along with your battler's pre-set attack pose.
  #--------------------------------------------------------------------------
  
  MNK_RANDOM_ATTACKS    = nil           # -- no random attacks here --
  MNK_RANDOM_ATTACKS_A  = {7 => [8,9]}  # Sets the 7th battler to use 8&9 too.
  MNK_RANDOM_ATTACKS_E  = nil           # -- no random attacks here --
  
  
  #==========================================================================
  #   ****               EXPANDED POSE CONTROL CENTER                ****   #
  #==========================================================================
  
  # Looping Poses
  #--------------------------------------------------------------------------
  # These arrays merely hold the ID  of actors or enemies whose poses loop at
  # the end of combat.  Enemies have no 'winning' animation pose.
  MNK_LOOPS_WINNING_ACTOR   = [7]     # Actor IDs if their victory pose loops
  MNK_LOOPS_WINNING_ENEMY   = []      # Enemy IDs if their victory pose loops
  MNK_LOOPS_DEFEATED_ACTOR  = []      # Actor IDs if their defeat pose loops
  MNK_LOOPS_DEFEATED_ENEMY  = []      # Enemy IDs if their defeat pose loops
  
  # Non-Default Poses (can expand beyond the default 11 poses here)
  # (New system mimics the revised Template system.  Can use 'custom' sheets)
  #--------------------------------------------------------------------------
  # The first value in each set indicates the index number  in a spritesheet.
  # This value is  overrided by a value  in one of the other two accompanying
  # arrays... one for actor battlerss, the other for enemy battlers.
  #
  # To define a pose linked to a specific battler, the syntax is...
  # '' hash array '' = { battler.id => pose# }
  # Where Aluxes and the Ghost (RTP)  would be  the 1st battlers (per array),
  # and the pose# would be the pose in your spritesheet.
  #
  # Combinations in the  hash arrays  are possible,  so if the MNK_POSES_DYING_E
  # array has {1 => 5, 9 => 2},  then the GHOST (enemy #1) would be using the
  # 6th pose (index 5) and the 9th enemy battler would be using the 3rd pose.
  #--------------------------------------------------------------------------
  MNK_POSES_SETUP       = 7          # Choose animation pose for 'preparation'
  MNK_POSES_SETUP_A     = {2 => 4}
  MNK_POSES_SETUP_E     = {1 => 4}    
  MNK_POSES_CASTPREP    = 4          # Set 'casting' pose for skill preparation
  MNK_POSES_CASTPREP_A  = {}          
  MNK_POSES_CASTPREP_E  = {9 => 3}    
  MNK_POSES_DYING       = 6          # Choose animation pose for dying throws.
  MNK_POSES_DYING_A     = {7 => 6}          
  MNK_POSES_DYING_E     = {9 => 5}    
  MNK_POSES_ESCAPE      = 2          # Set 'coward' pose for fleeing monsters)    
  MNK_POSES_ESCAPE_A    = {}         
  MNK_POSES_ESCAPE_E    = {9 => 5}   
  MNK_POSES_CRITICAL    = nil        # Set pose for BIG hits 
  MNK_POSES_CRIT_A      = {}
  MNK_POSES_CRIT_E      = {9 =>5}
  MNK_POSES_WINNING     = 4          # Set winning (Victory Dance before pose)
  MNK_POSES_WINNING_A   = {}
  MNK_POSES_WINNING_E   = {}         
  
  # Non-Default Pose Hashes (poses dependant on .id values)
  # (New system mimics the revised Template system.)
  #--------------------------------------------------------------------------
  # The first hash in each set  indicates the id number (be it skill, item or
  # otherwise, and the pose it brings up.   These mimic the 2nd array type in
  # the above Non-Default poses.   As such, a hash value of {1 => 10) for the
  # MNK_POSES_WEAPONS hash would make  the 'Bronze Sword' use the 10th index (or
  # 11th spritesheet) pose... aka the 'Defeat' pose.
  #
  # To define an advanced pose linked to a specific battler, the syntax is...
  #  = { battler.id => { item/skill.id => pose#  } }
  # ...so this gets  more complicated.   But this does allow  each battler to
  # have his or her own unique pose, regardless of spritesheet type.
  #--------------------------------------------------------------------------
  MNK_POSES_CASTED     = {61 => 6}  # Set a specific skill to use a pose
  MNK_POSES_CASTED_A   = {}         
  MNK_POSES_CASTED_E   = {}
  MNK_POSES_STATUS     = {3 => 3}   # Set status values to poses here
  MNK_POSES_STAT_A     = {}  
  MNK_POSES_STAT_E     = {}
  MNK_POSES_SKILLS     = {57 => 7}  # Default: #57(Cross Cut) does 'Attack'
  MNK_POSES_SKILLS_A   = {}  
  MNK_POSES_SKILLS_E   = {}
  MNK_POSES_ITEMS      = {13 => 4}  # Default: #13(Sharp Stone) does 'Block'
  MNK_POSES_ITEMS_A    = {}         
  MNK_POSES_ITEMS_E    = {}         
  MNK_POSES_WEAPONS    = {}         # Didn't set any weapons to any poses
  MNK_POSES_WEAPS_A    = {}
  MNK_POSES_WEAPS_E    = {}         # Non-functional (Enemies don't use 'em.)

  # Non-Default Pose Hashes (Charging Animation)
  # (Like above, but pertains to Charge-to-attack poses based on conditions)
  #--------------------------------------------------------------------------  
  MNK_POSES_S_CHARGE   = {73 => 6}  # Set a charging motion based on skill
  MNK_POSES_S_CHARGE_A = {}         
  MNK_POSES_S_CHARGE_E = {}
  MNK_POSES_I_CHARGE   = {73 => 6}  # Set a charging motion based on an item
  MNK_POSES_I_CHARGE_A = {}         
  MNK_POSES_I_CHARGE_E = {}
  MNK_POSES_W_CHARGE   = {25 => 1}  # Set a charging motion based on a weapon
  MNK_POSES_W_CHARGE_A = {}         
  MNK_POSES_W_CHARGE_E = {}         # Non-functional (Enemies don't use 'em.)
      
  # Non-Default Pose Hashes (Dodging Animation)
  # (Like above, but pertains to Targets dodging an attack based on conditions)
  #--------------------------------------------------------------------------   
  MNK_DODGE            = 3          # Sets a pose if a target dodges an attack
  MNK_ADODGE           = {}         # Dodging poses for individual actors
  MNK_EDODGE           = {}         # Dodging poses for individual enemies
  MNK_DODGE_WEAPS      = {}         # Set a specific 'Dodge' to a weapon attack
  MNK_DODGE_WEAPS_A    = {}         
  MNK_DODGE_WEAPS_E    = {}         
  MNK_DODGE_SKILLS     = {}         # Set a specific 'Dodge' to a skill
  MNK_DODGE_SKILLS_A   = {}
  MNK_DODGE_SKILLS_E   = {}
  MNK_DODGE_ITEMS      = {}         # Set a specific 'Dodge' to an item attack
  MNK_DODGE_ITEMS_A    = {}
  MNK_DODGE_ITEMS_E    = {}
  
  # Non-Default Pose Hashes (Hits & Critical Hits)
  # (Just like above, but pertains to specific hits and critical hits)
  #--------------------------------------------------------------------------
  MNK_STRUCK_WEAPS     = {}         # Set a specific 'Struck' to a weapon attack
  MNK_STRUCK_WEAPS_A   = {}         
  MNK_STRUCK_WEAPS_E   = {}         
  MNK_STRUCK_SKILLS    = {}         # Set a specific 'Struck' to a skill
  MNK_STRUCK_SKILLS_A  = { 7 => { 7 => 4 }}
  MNK_STRUCK_SKILLS_E  = {}
  MNK_STRUCK_ITEMS     = {}         # Set a specific 'Struck' to an item attack
  MNK_STRUCK_ITEMS_A   = {}
  MNK_STRUCK_ITEMS_E   = {}
  MNK_CRIT_WEAPS       = {}         # Set a specific 'Critical Hit' to a weapon
  MNK_CRIT_WEAPS_A     = {}
  MNK_CRIT_WEAPS_E     = {}       
  MNK_CRIT_SKILLS      = {}         # Set a specific 'Critical Hit' to a skill
  MNK_CRIT_SKILLS_A    = {7 => {7 => 10 }, 5 => {7 => 7}}
  MNK_CRIT_SKILLS_E    = {}
  MNK_CRIT_ITEMS       = {}         # Set a specific 'Critical Hit' to an item
  MNK_CRIT_ITEMS_A     = {}
  MNK_CRIT_ITEMS_E     = {}

    
  #==========================================================================
  #   ****                   FRAME CONTROL CENTER                    ****   #
  #==========================================================================

  # * Frames Control 
  #--------------------------------------------------------------------------    
  MNK_FRAMES_PER_POSE    = {}               # Set #of frames to pose(by index)

  # Advanced Individual Pose/Frame Hashes   # Advanced Individual Poses  uses
                                            # hashes within hashes. As a demo 
  MNK_POSES_FR_ACTOR = {}                   # you can see that enemy #1 has 2
  MNK_POSES_FR_ENEMY = {}                   # sets of controls:  index 0 (for
                                            # a ready pose is set to 1 frame,
  # while index 3 (block) is set to 'two' frames.   Likewise, for the actor's
  # hash, Actor #7 (Gloria) has only 1 control hash.   It sets index pose '0' 
  # (the ready pose again) to use four frames of animation (even though I had
  # set the ready pose to just use '2' with the MNK_FRAMES_PER_POSE hash earlier.

  
  #==========================================================================
  #   ****                   MOVEMENT CONTROL CENTER                 ****   #
  #==========================================================================
      
  # * Offset / Battler Overlap System
  #--------------------------------------------------------------------------    
  MNK_OFFSET            = 32          # How much addtl space between battlers
  MNK_OFFSET_ATK_A      = {1  =>  20} # Space between Actor attacker & target
  MNK_OFFSET_DEF_A      = {1  => -20} # Space between Actor defender & attacker
  MNK_OFFSET_ATK_E      = {3  =>  25} # Space between Enemy attacker & target
  MNK_OFFSET_DEF_E      = {3  =>  25} # Space between Enemy defender & attacker
  
  # * Forward Step System (Final Fantasy-Style)
  #--------------------------------------------------------------------------    
  MNK_STEP_ATTACK       = false   # If true, battler steps forward to attack
  MNK_STEP_SKILL        = false   # If true, battler steps forward to use skill
  MNK_STEP_ITEM         = true    # If true, battler steps forward to use item

  # * Jumping Attack System (FF Dragoon-Style)
  #--------------------------------------------------------------------------      
  JUMPING_ENEMY         = {}   # Enemy IDs for jumping rush attacks
  JUMPING_WEAPONS       = {}    # Weapon IDs for jumping rush attacks
  JUMPING_SKILLS        = {}  # Skill IDs for jumping rush skills
  JUMPING_ITEMS         = nil         # Item IDs for jumping rush item usage
  
  # * Movement Arrays (Arrays for skill/weapon/item IDs that affect movement)
  #--------------------------------------------------------------------------    
  MNK_MOVING_ITEM       = [1]     # Examples are items that need to be applied.
  MNK_MOVING_SKILL      = [61, 73]# Examples are martial-arts and sneak attacks
  MNK_MOVE2CENTER_ATK   = []      # Moves battler to center based on weapon id!
  MNK_MOVE2CENTER_ITEM  = [5]     # Moves battler to center for a big item atk!
  MNK_MOVE2CENTER_SKILL = [7]     # Moves battler to center for a big skill atk!
  #
  # * Remember, do not supply Skill or Item ID#'s that have 'None' scopes into
  #   either the MNK_MOVING_ITEM or MNK_MOVING_SKILL hashes.  These skills &
  #   item attacks have no target and would cause an error when trying to find
  #   an enemy to move towards.
 

    
  #==========================================================================
  #   ****                STATIONARY CONTROL CENTER                  ****   #
  #==========================================================================
  
  # * Stationary Battlers (simple True/False settings)
  #--------------------------------------------------------------------------    
  MNK_STATIONARY_ENEMIES = false    # If the enemies don't move while attacking
  MNK_STATIONARY_ACTORS  = false    # If the actors don't move while attacking
  
  # * Arrays filled with skill/weapon/item IDs that halt movement 
  #--------------------------------------------------------------------------    
  MNK_STATIONARY_ENEMY_IDS = []       # Enemies that don't RUN during melee attacks
  MNK_STATIONARY_WEAPONS = [17,18,19,20,21,22,23,24] # (examples are bows & guns)
  MNK_STATIONARY_SKILLS  = []       # (examples are bows & guns)
  MNK_STATIONARY_ITEMS   = []       # (examples are bows & guns)


    
  #==========================================================================
  #   ****               TRANSPARENCY CONTROL CENTER                 ****   #
  #==========================================================================
  MNK_TRANSLUCENCY      = 127      # Degree of transparency
  MNK_TRANSLUCENT_ACTOR = []       # ID of actor at translucency settings
  MNK_TRANSLUCENT_ENEMY = []   # ID of enemy at translucency settings
  MNK_PHASING           = true     # If battlers fade in/out while charging
  MNK_PHASING_ACTOR     = []   # IDs of actors that fade in/out if charging
  MNK_PHASING_ENEMY     = []      # IDs of enemies that fade in/out if charging
  MNK_FADE_IN           = true     # Battler fades in if replaced or transparent

    
    
  #==========================================================================
  #   ****                CUSTOM FEATURE CENTER                      ****   #
  #==========================================================================
        
  MNK_MIRROR_ENEMIES    = true     # Enemy battlers use reversed image
  MNK_CALC_SPEED        = false    # System calculates a mean/average speed
  MNK_AT_DELAY          = false    # Pauses battlesystem until animation done.
  MNK_ADV_OFF_TURN      = 1        # Number of turns before enemies turn around.
