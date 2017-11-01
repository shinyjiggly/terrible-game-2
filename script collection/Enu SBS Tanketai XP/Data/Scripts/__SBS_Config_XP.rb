#==============================================================================
# Sideview Battle System XP Configurations Version 2.2xp
#==============================================================================
# These configurations are exclusive for the RPG Maker XP
# These are new configuration constants used so the script can work on RMXP
# These are essential for the script to work well and smoothly
# These were separated from the previous configuration to allow you
# to use the whole configurations already settled for RMVX.
# To avoid conflicts with the script's basic configuration,
# it is recomended to place this script below the other configuration
# Some requested functions present in other script were added here
# as basic functions of the script, to avoid incompatibility.
#==============================================================================

module N01

  # Character Animation Repeat
  NEW_PATTERN_REPEAT = true
  # true = XP style, the frames will follow this sequence: 1, 2, 3, 4, 1, 2, 3...
  # false = VX style, the frames will follow this sequence: 1, 2, 3, 2, 1, 2, 3...  
  
  # Choose the Damage Alogarithm
  DAMAGE_ALGORITHM_TYPE = 0
  # 0 = Default XP Style, no changes
  # 1 = Default XP Modified, def/mdef reduces damage in % ( 10 def = 1% )
  # 2 = Default VX, Vitality replaces Dexterity, the status Attack, P.Def and
  #     M.Def are totally ignored. (Edit the menus script to remove these status)
  # 3 = Customized, an mix of XP e VX alogarithm, Vitality replaces Dexterity
  
  # Names of the status Evasion and Vitality (Vitality is only used if 
  # DAMAGE_ALGORITHM_TYPE > 1
  STAT_EVA = "Esvasion"
  STAT_VIT = "Vitality"
    
  # Define here the character's attack power when unarmed.
  UNARMED_ATTACK = 10
  
  # Define here the character's attack animation when unarmed.
  UNARMED_ANIM = 4
 
  # No animated battler, remaining the same way as the enemies.
  # Only let it as true if you want a battle system with completely not animated
  # allies.
  NO_ANIM_BATTLER = false
  
  # Show status effects balloons on the battles?
  BALLOON_ANIM  = true
  
  # Show effects' animations on the battles?
  STATE_ANIM = true
  
  # EXP division by the number of members on party
  EXP_SHARE = true
  
  # Cursor position on the target
  # 0 = customizable
  # 1 = below the target
  # 2 = above the target (adjusts self to the target's height)
  CURSOR_TYPE = 2
  
  # Readjust the cursor's position.
  CURSOR_POSITION = [ 0,  0]
 
  # Command Window Position
  COMMAND_WINDOW_POSITION = [240, 128]
  
  # Show Battler Name window?
  BATTLER_NAME_WINDOW = false
  
  # Effects' icons configuration
  # Icons must have the same name of effect plus "_st"
  # Ex.: Status Venom, must have an icon named "Venom_st"
  Icon_max = 5   # Maximum amount of showed icons
  Icon_X   = 24  # X size of the icon (width)
  Icon_Y   = 24  # Y size of the icon (height)
  X_Adjust = 0   # Readjustment of the X position
  Y_Adjust = 0   # Readjustment of the Y position
  
  # State Cycle times
  STATE_CYCLE_TIME = 4
  
  # Damage Exhibition configuration
  #                Red Green Blue
  HP_DMG_COLOR  = [255, 255, 255] # HP damage color
  HP_REC_COLOR  = [176, 255, 144] # HP cure color
  SP_DMG_COLOR  = [144,  96, 255] # SP damage color
  SP_REC_COLOR  = [255, 144, 255] # SP cure color
  CRT_DMG_COLOR = [255, 144,  96] # Critical damage color
  CRT_TXT_COLOR = [255,  96,   0] # Critical damage text color
  DAMAGE_FONT   = "Arial Black"   # Damage exhibition font
  DMG_F_SIZE    = 32     # Size of the damage exhibition font
  DMG_DURATION  = 40     # Duration, in frames, that the damage stays on screen      
  CRITIC_TEXT   = true   # Show text when critical damage is delt?
  CRITIC_FLASH  = true  # Flash effect when critical damage is dealt?
  MULTI_POP     = false  # Style in which the damage is shown true = normal / false = FF styled
  POP_MOVE      = false  # Moviment for damage exhibition?
  DMG_SPACE     = 12     # Space between the damage digits
  DMG_X_MOVE    = 2      # X movement of the damage (only if POP_MOVE = true)
  DMG_Y_MOVE    = 6      # Y movement of the damage
  DMG_GRAVITY   = 0.98   # Gravity effect, affects on the heeight the damage "jumps"
  
  # Configurations of the Battle Window
  STATUS_OPACITY  = 160  # Opacity of the Battle Window
  MENU_OPACITY    = 160  # Opacity of the Item/Skills window
  HELP_OPACITY    = 160  # Opacity of the Help Window
  COMMAND_OPACITY = 160  # Opacity of the Commands Window
  HIDE_WINDOW     = true # Hide status window when selecting items/skills?

  # Name of the sound file used when a dodge occurs.
  # This file must be on the Audio/SE folder of your project
  EVASION_EFFECT = "015-Jump01"
  
  # Message shown when a flee attempt succeeds
  ESCAPE_SUCCESS = "Escaped"
  
  # Message shown when a flee attempt fails
  ESCAPE_FAIL = "Failed!"
  
  # Allow Ambushes to occur?
  BACK_ATTACK = true
  
  # Define here the Ambush occurance rate
  BACK_ATTACK_RATE = 10
  
  # Define the message shown when an Ambush occurs
  BACK_ATTACK_ALERT = "Ambushed!"
  
  # Invert the character's position when an ambush occurs?
  BACK_ATTACK_MIRROR = true
  
  # Invert the battle background when an Ambush occurs?
  BACK_ATTACK_BATTLE_BACK_MIRROR = true
  
  # Here you can configurate the system (itens, skills, switchs) to protect 
  # the character from Ambushes. The item must be equiped, the skill must be
  # learned, and switches must be ON so the Ambush protection works. 
  # Only one of the 3 need to match the requirements to work.
  # In other words, the item can be equiped, but the skill not learned and the
  # switch OFF for the item's effect to take place.
  # For one item/skill/switch only: = [1]
  # For multiple: = [1,2]
  
  # Weapons' ID's
  NON_BACK_ATTACK_WEAPONS = []
  # Shields' ID's
  NON_BACK_ATTACK_ARMOR1 = []
  # Helmets' ID's
  NON_BACK_ATTACK_ARMOR2 = []
  # Armors' ID's
  NON_BACK_ATTACK_ARMOR3 = []
  # Accesories' ID's
  NON_BACK_ATTACK_ARMOR4 = []
  # Skills' ID's
  NON_BACK_ATTACK_SKILLS = []
  # Number of the Switch - when ON, the chance for Ambushes is zero
  NO_BACK_ATTACK_SWITCH = []
  # Number of the Switch - when ON, the chance for Ambushes is 100%
  BACK_ATTACK_SWITCH = []
 
  # Allow Preemptive Attacks to occur?
  PREEMPTIVE =  true
  
  # Define here the occurance rate of Preemptive Attacks
  PREEMPTIVE_RATE = 10
  
  # Define here the message shown when a Preemptive Attack occurs
  PREEMPTIVE_ALERT = "Preemptive!"
  
  # Here you can configurate the system (itens, skills, switchs) to increase 
  # the occurance of Preemptive Attacks. The item must be equiped, the skill must
  # be learned, and switches must be ON so the Ambush protection works. 
  # Only one of the 3 need to match the requirements to work.
  # In other words, the item can be equiped, but the skill not learned and the
  # switch OFF for the item's effect to take place.
  # For one item/skill/switch only: = [1]
  # For multiple: = [1,2]
  
  # Weapons' ID's
  PREEMPTIVE_WEAPONS = []
  # Shields' ID's
  PREEMPTIVE_ARMOR1 = []
  # Helmets' ID's
  PREEMPTIVE_ARMOR2 = []
  # Armors' ID's
  PREEMPTIVE_ARMOR3 = []
  # Accesories' ID's
  PREEMPTIVE_ARMOR4 = []
  # Skills' ID's
  PREEMPTIVE_SKILLS = []
  # Number of the Switch - when ON, the chance for Preemptive Attacks is zero
  NO_PREEMPTIVE_SWITCH = []
  # Number of the Switch - when ON, the chance for Preemptive Attacks is 100%
  PREEMPTIVE_SWITCH = []

end
