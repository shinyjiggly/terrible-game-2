#============================================================
#-- BASIC DEFINITIONS for RomancingSaga-like Battle System --
#============================================================
#By Orochii Zouveleki C:.
#
# · Distribute freely, and for use on any game, doesn't matters if is
# commercial.
# · Accreditations are nice! Not necessary. But don't claim this as yours!
#       But if you want to thank me, you can share with me
#       a free copy of your game =D. Either if commercial or not.
#       I'll be pleased to see that this helped someone, and how
#       it was used.
# · If possible, pass the word!

#Event Call script
#=================

# You can change/use victory BGM in-game by using the following code in a 
# Script Call command:
# victory_bgm = "newMusic"
# ...where newMusic is the name of the music file in Audio/BGM.

# You can recover all allies LP by using the following inside a Script Call:
# recover_all_lp
# Use it, for example, at INNs... (.-.)

#==============================================================================
#Character Info
#==============================================================================
module CharacterInfo
  ACTOR_LP = {
  :default=>10,
  1=>16,
  }
end

#==============================================================================
#Enemy Info
#==============================================================================
#Here you can define advanced collapse animations. Heavily based on Atoa's code
#from his Atoa Custom Battle System, so I have to give him credit for this.
#
#Important Note: Advanced collapse needs the "FF Damage Display" add-on script, 
#located below main by default. Move it above main if you want to use this 
#functionality.
#
#You can also define "double enemy troops". What they are is that instead of 
#using/loading a sole set of enemies from the DataBase, it loads also the next one!
#That means you can have up to 16 enemies in battle! Yay! Now you will bore 
#yourself to death while battling.

module EnemyInfo
  COLLAPSES = {
      32 => 3, #Copy this line for each enemy you want to have an special collapse animation
      #Examples (delete the first # to test them if you want)
      #1 => 1, #This makes the mole to be squished slowly.
      #1 => 2, #And this makes the mole to... dissapear in the ground...?
      #3 => 3, #This one lasts longer than the other ones, but just makes the enemy to fall slowly. For flying creatures.
      #And each includes a lot of Thunder sounds and dramatic flashes! (Atoascode cough cough cough)
      }
  
  # This array contains which enemy troops are going to be "double".
  DOUBLE_ENEMYTROOP = [1] #This example, throws you troop 1 AND troop 2. All stuff
                          #inside this battle system are "optimized" for this to
                          #happen without problems.
                          
  #And this is the boss enemy type. This means that these monsters don't change 
  #their "species" even if there's a higher level monster of that kind (they still
  #level up though!).
  BOSS_KIND= 18
  
  #-----
  #HOW Monster Leveling occurs?
  #-----
#  The party has an special "global level" value. This value increases one "level"
#each certain number of entered battles (doesn't matters if win, lose, escape...).
#When a monster level is lower than the global level, the monster gets leveled up
#to the global level. And, if there's a monster on database that shares enemy kind, 
#and its level is equal or lower than the NEW monster level, our monster "evolves".
#It also selects the higher level monster possible.

end

#==============================================================================
#Formation Info
#==============================================================================
#Works as a database for formation-related stuff. For the formation visualization
#definition, see script "Animated Battler Formations".

module FormationInfo
  #This section of the formation info defines important information related to how
  #actor-to-actor manual targeting works.
  #Based on this "matrix", the game will know how the characters are distributed
  #on the screen, on any formation, without comparing screen positions.
  #Maybe not the easiest for end-users of this script...
  
  #To add a formation, use this (without the begin/end lines):
=begin
  [[0,0,0,0,0], #RSName: N/A
   [0,0,0,0,0], #ThisName: ???
   [0,0,0,0,0]
  ],
=end
  #You have to put numbers at the matrix, each number symbolizes a character.
  #So, for example, the next one...
  
  F_MATRIX = [
  [[2,0,0,0,3], #RSName: Phoenix Dance
   [0,0,1,0,0], #ThisName: ???
   [4,0,0,0,5]
  ],
  
  #This one would look like this:
  
  # 2     4
  #        
  #    1   
  #        
  # 3     5
  
  #See that the matrix is rotated clockwise 90 degrees, and inverted vertically.
  #Zeroes means empty spaces. And don't worry, if a "number" doesn't haves an 
  #actor ingame, it will be treated as a zero. Or just the opposite, it's the
  #same!
  
  #By the way, this script makes your party a 5-person group! Never forget to add
  #numbers from 1 to 5.
  
  [[0,2,0,3,0], #RSName: Genbu
   [4,0,0,0,5], #ThisName: ???
   [0,0,1,0,0]
  ],
  
  [[0,0,1,0,0], #RSName: Dragon Form
   [0,0,2,3,0], #ThisName: ???
   [0,0,0,4,5]
  ],
  
  [[4,2,0,3,5], #RSName: Tiger's Cave
   [0,0,1,0,0], #ThisName: ???
   [0,0,0,0,0]
  ],
  
  [[0,0,0,0,0], #RSName: Free Fight
   [4,2,1,3,5], #ThisName: ???
   [0,0,0,0,0]
  ],
  
  [[0,2,1,3,0], #RSName: Tri Anchor
   [0,0,4,0,0], #ThisName: ???
   [0,0,5,0,0]
  ],
  
  [[0,0,1,0,0], #RSName: Speculation
   [0,2,0,3,0], #ThisName: ???
   [4,0,0,0,5]
  ],
  
  [[2,0,0,0,3], #RSName: Power Raise
   [0,4,0,5,0], #ThisName: ???
   [0,0,1,0,0]
  ],
  
  [[0,0,1,0,0], #RSName: Desert Lance
   [0,0,0,0,0], #ThisName: ???
   [4,2,0,3,5]
  ],
  
  [[4,2,0,3,5], #RSName: Hunter Shift
   [0,0,0,0,0], #ThisName: ???
   [0,0,1,0,0]
  ],
  
  [[0,2,0,3,0], #RSName: Whirlwind
   [0,0,1,0,0], #ThisName: ???
   [4,0,0,0,5]
  ],
  
  [[0,0,3,0,0], #RSName: Imperial Cross
   [0,4,1,5,0], #ThisName: ???
   [0,0,2,0,0]
  ],
  
  [[3,0,1,0,5], #RSName: N/A
   [0,0,0,0,0], #ThisName: Squad
   [0,2,0,4,0]
  ],
  
  [[1,0,0,0,1], #RSName: N/A
   [0,2,3,0,0], #ThisName: Slash
   [0,0,0,4,5]
  ],
  
  [[0,0,3,0,0], #RSName: Imperial Arrow
   [0,0,1,0,0], #ThisName: ???
   [0,4,2,5,0]
  ],
  
  [[0,0,1,0,0], #RSName: Desert Fox
   [2,0,0,0,3], #ThisName: ???
   [0,4,0,5,0]
  ],
  
  [[0,0,1,0,0], #RSName: Rapid Stream
   [2,3,0,4,5], #ThisName: ???
   [0,0,0,0,0]
  ],
  
  ]
  
  #This one is easier to set. Just give each actor one of the positions defined
  #at RowStuff, on each of the formations defined above.
  #Remember you can give ANY position you make at the RowStuff script.
  #And you can make ANY number of positions there.
  F_POS=[
  
  [:f,:m,:m,:d,:d], #PhoenixDance
  [:d,:f,:f,:m,:m], #Genbu
  [:f,:m,:m,:d,:d], #DragonForm
  [:m,:f,:f,:f,:f], #Tiger'sCove
  [:m,:m,:m,:m,:m], #FreeFight
  [:f,:f,:f,:m,:d], #TriAnchor
  [:f,:m,:m,:d,:d], #Speculation
  [:d,:f,:f,:m,:m], #PowerRaise
  [:f,:d,:d,:d,:d], #DesertLance
  [:d,:f,:f,:f,:f], #HunterShift
  [:m,:f,:f,:d,:d], #Whirlwind
  [:m,:d,:f,:m,:m], #ImperialCross
  [:f,:d,:f,:d,:f], #Squad
  [:f,:m,:m,:d,:d], #Slash
  [:m,:d,:f,:d,:d], #ImperialArrow
  [:f,:m,:m,:d,:d], #DesertFox
  [:f,:m,:m,:m,:m], #RapìdStream
  
  ]
  
  #These are the names displayed at the formation windows.
  F_NAMES=[ "Phoenix Dance",  #0
            "Genbu",          #1
            "Dragon Form",    #2
            "Tiger's Cove",   #3
            "Free Fight",     #4
            "Tri-Anchor",     #5
            "Speculation",    #6
            "Power Raise",    #7
            "Desert Lance",   #8
            "Hunter Shift",   #9
            "Whirlwind",      #10
            "Imperial Cross", #11
            "Squad",          #12
            "Slash",          #13
            "Imperial Arrow", #14
            "Desert Fox",     #15
            "Rapìd Stream",   #16
          ]
  
  #These are the formations available at start.
  F_STARTING=[4,0,1,2,3,5,6,7,8,9,10,11,12,13,14,15,16]
  
end

#==============================================================================
#Window Info
#==============================================================================
#You can set a LINE_HEIGHT just as RMVX does. Be warned however, it's not used
#on this script for anything! OHOHOHOHOHOHOHHO!!
#But you can access it from your own scripts by using WindowInfo::LINE_HEIGHT as
#a value.
#ex. @spriteX.y = otherVal * WindowInfo::LINE_HEIGHT

module WindowInfo
  #This is a constant that you can use at your windows for a "default line height".
  LINE_HEIGHT=20
  
  #Window vocabulary.
  #==================
  #Party command names ('Fight!' and 'Formations').
  PARTY_COMMAND_NAMES= ["Fight", "Formations"]
  
  #Message displayed at end of battle.
  BATTLE_END= "¡Battle has ended!"
  
  #'Evasion', 'Magic evasion', 'Hit %' and 'Hit number' display names.
  EXTRA_ATTRIBUTES= ["Evade","MagicEvade","Hit %","Hit #"]
  
  #Equip change symbols
  CHANGE_SYMBOLS= ["=", "+", "-"]
  
  #'Status', 'Formations', 'Save' and 'Exit' menu command display names.
  MENU_COMMAND_NAMES= ["Status","Formations","Save","Exit"]
  
  #Status screen EXP-related display names
  EXP_DISPLAY= ["EXP","NEXT"]
  
  #Window BattleStatus Information Offset
  OFF_X = 0
  OFF_Y = 16
  
  #Level up display phrase
  LEVELUP= "Level Up!"
  SKILLUP= "up!"
  
  #'Flee' comand display name
  FLEE_COMMAND_NAME= "Flee"
  
  #Prefix and sufix shown at help window when selecting character actions.
  #The ending sentence would be something like Prefix+Name+Suffix
  TURN_PREFIX= ""
  TURN_SUFIX= "'s turn"
  #This example sets it to "Character's turn".
  #Remember to use all necessary spaces!
  
end

#==============================================================================
#Other Info
#==============================================================================
#Works as a database for any other configurable stuff.

module RPG
  #These are the elements for weapon skills
  SKILL_CAT = [21,22,23,24]
  #This is the category for punching skills
  HIT_CAT = 25
  #And this is the category for magic attacks
  MAGIC_CAT = 26
  #These are the magic elements. Any magic containing any of these will have a sepparate level.
  MAGIC_LEVELS = [1,2,3,4,5,6,7,8]
  #This is the "punch" weapon, used to fill in extra info when you don't have a weapon
  PUNCHES_WEAPON_ID = 33 
  #Lastly, this is the number of battles needed for the Global Level to raise.
  GLOBAL_LEVELLING_BATTLES = 2
  
  #Special accessories. Based in FF6, some accesories were made as an extra ;P.
  # Element IDs. An accessory that has one of these marked, gives them one special
  # feature.
  SPEC_ACCESSORIES = [
      28, # Gauntlet - Ups physical strength during damage calculation.
      29, # Offering - 4 unblockable hits of 1/2 dmg. No crits. **Not fully implemented!
      30, # Physical Boost - +1/4 physical damage.
      31, # Magical Boost - +1/4 magical damage.
  ]
  #Skill tags. These are special element IDs, ignored during damage calculation.
  # When a skill has one of them marked, it gives the skill a special feature,
  # described below. You can change the number to use the element ID you want.
  # Just remember to not change anything else. To leave it in the same order.
  SKILL_TAGS = [
      17, #Deathblow - 100% unneffective on Death-resistant foes.
      18, #Unblockable - Just as the name says.
      19, #Ally/Enemy - Lets you to change between ally/enemy targets.*
      20, #One/All - Change scope between one/all of a kind (ally or foe).*
          # Can be used in conjunction with Ally/Enemy tag
    #* Not implemented for now.
  ]
  
  #Special states. Makes some 
  SPEC_STATES = [
      14, # PROTECT - Reduces physical damage.
      15, # SHELL - Reduces magical damage.
      17, # FAST - 2x Hits
      18, # SLOW - 0.5x Hits
      19, # MORPH - Ups damage output. Halves magic damage.
      21, # PETRIFY - Makes a character unable to act. Similar to death.
      22, # CLEAR - Physical misses, magical hits.
      23, # IMAGE - Physical fails, 1/4 possible of being removed.
  ]
  
  LVL_ICON=[]
  LVL_ICON[1]="mag_01"
  LVL_ICON[2]="mag_02"
  LVL_ICON[3]="mag_03"
  LVL_ICON[4]="mag_04"
  LVL_ICON[5]="mag_05"
  LVL_ICON[6]="mag_06"
  LVL_ICON[7]="mag_07"
  LVL_ICON[8]="mag_08"
  LVL_ICON[21]="001-Weapon01"
  LVL_ICON[22]="002-Weapon02"
  LVL_ICON[23]="005-Weapon05"
  LVL_ICON[24]="007-Weapon07"
  LVL_ICON[25]="050-Skill07"
  #Arrow configuration. Adjust these values to change selection cursor positioning.
  ARROW_ACTOR_OFFSET = [8,-64] # [xOffset, yOffset]
  ARROW_ENEMY_OFFSET = [8,-16] # [xOffset, yOffset]
  ARROW_ANIMSPEED = 16 #Higher value makes it slower.
  LP_WORD="LP"
  PHYSICAL_BOOST = 30
  MAGICAL_BOOST = 31
  #Level-up Animations!
  LIGHTBULB_ANIM = 2
  SKILL_LVL = {:default => 2,
                1 => 2,
                2 => 2,
                3 => 2,
                4 => 2,
                5 => 2,
                6 => 2,
                7 => 2,
                8 => 2,
                21=> 2,
                22=> 2,
                23=> 2,
                24=> 2,
                25=> 2,
          }
          
  #Victory BGM! - Tired of those ME? Here you can set a BGM!
  #Unset it by leaving it blank.
  VICTORY_BGM = "rs1_victory"
  
  SKILL_NEED = {
    # Skill learning extra parameters - Aside from character's weapon level,
    # you can define here two extra requirements. "General level" (based on how 
    # many battles have your party fought. And the character learned skills.
    
    # This is the default entry, used for any unspecified skill.
    #           Global level  Necessary skills      All or 1 necessary? (true/false)
    :default => [         0,  nil,                  nil],
    #      GL   
    59 => [ 0,  58, false], # This one needs one single skill.
    60 => [ 0,  [57,58,59], true], # This one needs three skills. All three of them
                                   # have to be already learned.
    64 => [ 0,  [61,62,63], false], #This one instead, just needs any of the three.
    
    # As always, remember to position correctly the =>,[] symbols.
  }
  #The skill experience gained by usage. Depends on the skill scope.
  # Remember! Total experience = value*successful hits. So multitarget skills 
  # get more exp. by hitting more enemies.
  #             None  Single enemy  All enemies  Single ally  All allies
  SKILL_GAIN = [8,    20,           5,           15,          6,
  #             Single ally (HP0)  All HP0 Allies  User
                18,                8,              10]
end