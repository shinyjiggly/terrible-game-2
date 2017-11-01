#==============================================================================
# Advanced Status
# by Atoa
#==============================================================================
# This script add a lot of new stats and features for actors
# 
# He adds the following features:
# - Multi Slot for equips
# - 2 Weapons System
# - 2 Handed Weapons
# - Multiple Auto Status for Weapons and Armors
# - SP cost changing equips
# - Status Limit Settings
# - New Status for Equips
# - New status and elemental resist system
#
# IMPORTANT:
# - If you using the multi slot equip system, the event command for changing 
#   equips will be screwed.
#   So if you need to force any equip change with events, make an Script Call
#   and add this command:
#    $game_actors[Actor ID].equip(Slot Index, Equip ID)
#      Slot Index = remember that indexes starts from 0, so the 1st slot will
#        be index 0, the 2nd will be index 1...
#
# - Some functions are really complex, if you're a noob, don't mess with them.
#   Learn the basic of RGSS before trying the advanced features
#==============================================================================

module N01
  # Do not remove or change these lines
  constants = ['Equip_Lock','Auto_Status','Armor_Lock','Sp_Cost_Change_Equip',
    'Weapon_Lock','Max_Level','Speacial_Status','Element_Resist','State_Resist',
    'Equip_Set','Set_Effect','Equip_Skills','Weapon_Damage_Type'] 
  for i in 0...constants.size
    eval(constants[i] + " = {}") 
  end
  # Do not remove or change these lines
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # VISUALIZATION SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here yo can set some values to change the equip and status menu
  # This script isn't comatible with complex equip and status menu systems, 
  # so use this area to customize your menus
  
  # Exhibition style of the equip menu
  Equip_Menu_Syle = 0
  # 0 = Default, shows atk, pdef, mdef
  # 1 = Default, shows atk, pdef, mdef, str, dex, int, agi
  # 2 = Default, shows str, dex, int, agi
  # 3 and 4 = custom, shows all status (including the news)
  
  # Window Opacity
  Equip_Window_Opacity = 255
  
  # Show map on background
  Show_Map_Equip_Menu = false
  
  # Background image
  Equip_Menu_Back = nil
  # If you want to use your own backgruon image, add the filename here.
  # the graphic must be on the Windowskin folder.
  # if the value = nil, no image will be used.
  # Remember to reduce the window transparency.
  
  # Define here which symbols/letters will be used to show status alteration
  # On the side there are a few exemples on symbols you can also use
  Stat_Nil  = '>' # '■' '↔' '±' '=' '>'
  Stat_Up   = '>' # '▲' '↑' '»' '+' '>'
  Stat_Down = '>' # '▼' '↓' '«' '-' '>'
  
  # New Status Exhibition
  Extra_Status = [7,8,9]
  # 7 = Evasion
  # 8 = Hit Rate
  # 9 = Critical Rate
  # 10 = Critical Damage
  # 11 = Critical Rate Resist
  # 12 = Critical Damage Resist

  # Name of the new status
  Stat_Eva = 'Evasion'
  Stat_Hit = 'Hit'
  Stat_Crt = 'Critical'
  Stat_Dmg = 'Critical Damage'
  Stat_Res_Crt = 'Critical Resist'
  Stat_Res_Dmg = 'Critical Damage Resist'
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # DUAL WIELDING SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set wich actors or classes can use two weapons
  
  # Second Attack Pose ID
  Second_Attack_Pose = 12
  
  # This set if the tow_swords style will use the total actors attack in both
  # attacks or calculate each attack separately
  Use_Old_Two_Sword_Beahave = false
  # true = use old behave, the total attack is used and multiplied by the values
  #        in "TWO_SWORDS_STYLE" on the Basic config
  # false = use the new behave, where each damage is calculed separately, depending
  #       on the weapon in each hand
  
  # Attack power rate for normal attacks when using more than one weapon
  Dual_Attack_Power = 75
  
  # Attack power rate for skills when using more than one weapon
  Dual_Skill_Power = 75
  
  # Actors that uses two weapons, add here their ids
  Two_Swords_Actors = []

  # Classes that uses two weapons, add here their ids
  Two_Swords_Classes = []
  
  # You can add or remove the dual wielding feature with script calls.
  # 
  # $game_party.two_swords_actors_add(Actor ID)
  #  to add the dual wielding to an actor.
  #
  # $game_party.two_swords_actors_remove(Actor ID)
  #  to remove the dual wielding from an actor.
  #
  # $game_party.two_swords_classes_add(Class ID)
  #  to add the dual wielding to an class.
  #
  # $game_party.two_swords_classes_remove(Class ID)
  #  to remove the dual wielding from an class.
  #
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # RIGHT HAND AND LEFT HAND EQUIP SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set wich hand the equip can be used
  # Just add their ids bellow
  
  # Two Handed weapons
  Two_Hands_Weapons = []
  
  # Right Hand only Weapons
  Right_Hand_Weapons = []
  
  # Left Hand only Weapons
  Left_Hand_Weapons = []
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SKILL COST CHANGE EQIPMENTS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set equipments that changes the SP cost for skill
  # ou diminuem o custo de SP das habilidades
  
  # Sp_Cost_Change_Equip[equip_kind]= {id => change}
  #  equip_kind = kind of the equipment
  #    'Weapon' for weapons, 'Armor' for armors
  #  id = equip ID
  #  change = rate of change in the SP cost, postive values are reductions,
  #    negative values are increases
  Sp_Cost_Change_Equip['Weapon'] = {38 => 25}
  Sp_Cost_Change_Equip['Armor'] = {37 => -50}
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CONFIGURAÇÕES DOS SLOTS DE EQUIPAMENTOS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set the equipment multi slot configurations
  
  # Equipment Kinds
  # The order of the values here define the order that the equipment will be
  # shown in the menu
  # If you repeat an value, means that the actor can equip more than one
  # equip of that type,
  Equip_Kinds = [0,1,2,3,5,4,4]
  # 0 = Weapons (if you add more than one value equal zero, all these equips
  #     will be considered 'right hand', so they won't remove the shield)
  # 1 = Shields (any equip set as 'Shield' will be exchanged by an weapon if
  #     the actor have the dual wielding)
  # 2 = Helmets
  # 3 = Armors
  # 4 = Accessories
  # Values above 5 are the extra slots, use to creat equipments like Boots, Capes...
  # You must set the IDs of the extra slots equips in 'Extra_Equips_ID'
  #
  # It's recomended that you leave only one 'Weapon' and one 'Shield', once
  # it interfere in the Dual Wielding and 2 Haded Weapons
  
  # You can change this value individually for each actor making an script call
  # and adding this command:
  # $game_actors[actor_id].equip_kind = [x,y,z]
  #   actor_id = actor ID
  #   [x,y,z] = new equip kind configuration
  
  # IDs of the equipments
  # Extra_Equips_ID = {kind => [equips_ids]}
  #  kind = equipment type, set on Equip_Kinds
  #  equips_ids = id of the armors of this equip type
  Extra_Equips_ID = {5 => [38,39]}
  
  # Name of the equips shown in the equip and status window
  Equip_Names = ['Right Hand', 'Left Hand', 'Helmet', 'Armor', 'Boots', 
                 'Accessory', 'Accessory']
  # The order here is the order that the names are shown in the menu, set
  # them according to the values set in 'Equip_Kinds'.
  # if you change the value of the kinds with script calls, remember to change
  # the names.
  
  # You can change this value individually for each actor making an script call
  # and adding this command:
  # $game_actors[actor_id].equip_names = [x,y,z]
  #   actor_id = actor ID
  #   [x,y,z] = new equip names configuration
  
  # Equipment Lock, these lines allows you to 'lock' an determined type of 
  # equipment, don't allow the actor to stay without equipment of this type
  # You can change equips freely, but can't remove.
  # E.g.: You have an Bow user character, and don't want him to stay without bows.

  #  Equip_Lock[equip_kind] = {actor_id =>[equip_type_id]}
  #    equip_kind = kind of the equipment
  #      'Weapon' for weapons, 'Armor' for armors
  #    actor_id = actor id
  #    equip_type_id = id of the equipment
  #      0 = right hand weapon
  #      1 = left hand weapon or shield
  #      2,3,4... = armors
  Equip_Lock['Weapon']= {1 => [0], 2 => [0], 3 => [0], 4 => [0], 
                         5 => [0], 6 => [0], 7 => [0], 8 => [0]}
  
  Equip_Lock['Armor']= {1 => [1], 2 => [1]}
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # WEAPON ATTACK STATUS CONFIGURATION
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # here you can change the base status for damage of weapons
  # You cam make weapons that causes damage based on dex, int or other status
  #  
  # Weapon_Damage_Type = {Weapon_ID => {Status => Mult}}
  #   Weapon_ID = Weapon ID
  #   Status = Status that define the base damage of weapon. Can be:
  #     'maxhp',maxsp','hp','sp','level','str','dex','int','agi','atk',
  #     'def','mdef','eva','hit'
  #   If you create an new status on game actor, you can add it too
  #   Mult = Multiplier of the status, can be decimals.
  
  Weapon_Damage_Type = {39 => {'str'=> 0.5, 'agi' => 0.5}, 40 => {'int'=> 1},
    41 => {'hp'=> 0.1}, 42 => {'level'=> 10},}
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # STATUS LIMIT SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set new limits for status and level

  # Default level limit
  Max_Level_Default = 99
  
  # Individual level limit
  # Max_Level[ID] = X
  #  ID = Actor ID
  #  X = Max level
  Max_Level[1] = 99
  Max_Level[2] = 99
  Max_Level[3] = 99
  Max_Level[4] = 99
  
  # Actor status limit
  Actor_Max_Hp  = 9999
  Actor_Max_Sp  = 9999
  Actor_Max_Str = 999
  Actor_Max_Dex = 999
  Actor_Max_Agi = 999
  Actor_Max_Int = 999
  Actor_Max_Atk = 999
  Actor_Max_PDef = 999
  Actor_Max_MDef = 999
    
  # Base status Multiplier
  # These values change the base status of the character
  # Can be decimals(E.g.: 2.7)
  Actor_Mult_Hp  = 1
  Actor_Mult_Sp  = 1
  Actor_Mult_Str = 1
  Actor_Mult_Dex = 1
  Actor_Mult_Agi = 1
  Actor_Mult_Int = 1
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # NEW STATUS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Settings for the new status, here you can add new status for weapons and armors
  
  # Auto_Status = You can set one or more auto status to an Weapon or Armor
  # Auto_Status[equip_kind] = { A => [ B, C, D...]} 
  #   equip_kind = kind of the equipment
  #     'Weapon' for weapons, 'Armor' for armors
  #   A = Weapon ID or Armor ID
  #   B,C,D = ID dos status permanentes.
  #
  Auto_Status['Weapon'] = {}
  
  Auto_Status['Armor'] = {}
 
  # Speacial_Status = New Status for Weapons or Armors and
  # Speacial_Status[Action_Type] = { Action_ID => {Status => Value}} 
  #   equip_kind = kind of the equipment
  #     'Weapon' for weapons, 'Armor' for armors
  #   Action_ID = Weapon ID or Armor ID
  #   Status = Status Changed, can be equal:
  #     'hit' = Hit Rate: Hit Rate Modifier
  #     'crt' = Critical Rate: Changes the chance of causing critical hits.
  #     'dmg' = Critical Damage: Changes the damage dealt by critical hits.
  #     'rcrt' = Critical Rate Resist: Changes the chance of reciving citical hits
  #     'rdmg' = Critical Damage Resist: Changes the damage recived by critical hits.
  Speacial_Status['Weapon'] = {}
  
  Speacial_Status['Armor'] = {}
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ELEMENTAL AND STATUS RESISTANCE SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set an new style for the elemental and status resistance, allowing
  # you to set elemental resistance based on actors IDs and set increases and/or
  # decreases in resistance for equipments and status
  
  # Use the new status resist style?
  Use_New_Resist = true
  
  # Style of the resistance acumulation
  Addition_Type = 0
  # 0 = The values are added, considering all values
  # 1 = The values are added, considering only the higher and the lower values
  # 2 = The value used are the average, considering all values
  # 3 = The value used are the average, considering only the higher and the lower values
  
  # Element_Resist[Type] = {Type_ID => {Element_ID => Resist_Value}
  #   Type = type of the object that gives the resistance
  #     'Actor' = actor's natural resistance
  #     'State' = resistance given by states
  #     'Armor' = resistance given by armors
  #     'Weapon' = resistance given by weapons
  #   Type_ID = id of the actor, state, armor or weapon
  #   Element_ID = ID of the element that will have the value change
  #   Resist_Value = Resistance change value, must be an Integer.
  #     positive values are increases in resistance, negative are reductions.
  #     E.g.: an actor imune to fire equips an armor that gives -1 fire resistance
  #       will have the fire resistance changed from imune to resistant.
  Element_Resist['Actor'] = {1 => {4 => -1, 2 => -1}, 2 => {4 => 2, 2 => -1},
                             3 => {4 => 2, 2 => -1}, 4 => {4 => 2, 2 => -1}}
  Element_Resist['State'] = {}

  Element_Resist['Armor'] = {}
  
  Element_Resist['Weapon'] = {}

  
  # State_Resist[Type] = {Type_ID => {State_ID => Resist_Value}
  #   Type = type of the object that gives the resistance
  #     'Actor' = actor's natural resistance
  #     'State' = resistance given by states
  #     'Armor' = resistance given by armors
  #     'Weapon' = resistance given by weapons
  #   Type_ID = id of the actor, state, armor or weapon
  #   State_ID = ID of the state that will have the value change
  #   Resist_Value = Resistance change value, must be an Integer.
  #     positive values are increases in resistance, negative are reductions.
  State_Resist['Actor'] = {}
  
  State_Resist['State'] = {}
  
  State_Resist['Armor'] = {}
  
  State_Resist['Weapon'] = {}
  #=============================================================================
  

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # EQUIPMENT SKILLS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set equipments that adds skills for the actors when equiped,
  # you can also set an minimum level for the skills to be learned
  #
  # Equip_Skills[Equip_Type] = {Equip_ID => {Min_Level => Skill_ID}}
  #  Equip_Type = 'Weapon' for weapons, 'Armor' for armor
  #  Equips_ID = ID do equipamento
  #  Min_Level = minimum level required for learning the skill
  #  Skill_ID = id of the skill learned
  Equip_Skills['Weapon'] = {}
  
  Equip_Skills['Armor'] = {}
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # EQUIPMENT SET SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # These configurations allows you to creat "equip sets"
  # Sets are equipments that offer extra effects when used togther
  # 
  # The configuration are divided in two parts:
  #  - Equip_Set: where you configure wich equip is part of a set
  #  - Set_Effect: where you configure the effects of the set
  #
  
  # Equip_Set[Set_ID] = {Equip_Type => [Equips_IDs]}
  #  Set_ID = Set ID, this value must be the same as the one in 'Set_Effect'
  #  Equip_Type = 'Weapon' for weapons, 'Armor' for armor
  #  Equips_IDs = Equiment IDs
  Equip_Set[1] = {'Armor' => [12,24,28]}
 
  Equip_Set[2] = {'Weapon' => [4], 'Armor' => [4,8,16]}
  
  # Set_Effect[Set_ID] = {Effect_Type => Effects}
  #  Set_ID = Set ID, this value must be the same as the one in 'Equip_Set'
  #  Effect_Type = type of the effect
  #    'status' = change on the actor status
  #    'auto states' = auto states
  #    'skills' = skills learned
  #    'states' = elemental resistance change (only if 'Use_New_Resist = true')
  #    'elements' = states resistance change (only if 'Use_New_Resist = true')
  #  Effects = the chages caused, varies according to 'Effect_Type'
  #     - if 'Effect_Type' = 'status'
  #       'status' => {stat => value}
  #       value = value of change in the status
  #       stat = the status changed, must be one of the values bellow
  #        'maxhp' = Max Hp
  #        'maxsp' = Max Sp
  #        'level' = Level
  #        'atk'  = Attack
  #        'pdef' = Physical Defense
  #        'mdef' = Magic Defense
  #        'str'  = Strength
  #        'dex'  = Dexterity
  #        'int'  = Intelligence
  #        'agi'  = Agility
  #        'eva'  = Evasion
  #        'hit'  = Hit Rate
  #        'crt'  = Critical Rate
  #        'dmg'  = Critical Damage
  #        'rcrt' = Critical Rate Resist.
  #        'rdmg' = Critical Damage Resist.
  #     - if 'Effect_Type' = 'auto states'
  #       'auto states' => [states_ids]
  #         states_ids = ids of the auto states
  #     - if 'Effect_Type' = 'skills'
  #       'skills' => {min_level => skill_id}
  #         min_level = minimum level required for learning the skill
  #         skill_id = id of the skill learned
  #     - if 'Effect_Type' = 'states'
  #       'states' => {state_id => resist_value}
  #         state_id = id of the state
  #         resist_value = value of resitance change
  #     - se 'Effect_Type' = 'elements'
  #       'elements' => {element_id => resist_value}
  #         element_id = id of the element
  #         resist_value = value of resitance change
  Set_Effect[1] = {'status' => {'maxsp' => 500, 'int' => 100}}
  
  Set_Effect[2] = {'status' => {'maxhp' => 200, 'maxsp' => 200}, 'auto states' => [22], 
    'skills' => {1 => 31, 20 => 32}, 'states' => {1 => 1, 4 => 3},
    'elements' => {1 => 1, 3 => 1, 5 => 1}}
  #=============================================================================
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script['SBS Actor Status'] = true

#==============================================================================
# ■ RPG::Weapon
#==============================================================================
class RPG::Weapon
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :multi_auto_state_id
  attr_accessor :crt
  attr_accessor :dmg
  attr_accessor :hit
  attr_accessor :rcrt
  attr_accessor :rdmg
  attr_accessor :scope
  attr_accessor :element_resist
  #--------------------------------------------------------------------------
  alias acbs_initialize_actorstatus_rpgweapon initialize
  def initialize
    acbs_initialize_actorstatus_rpgweapon
    @multi_auto_state_id, @element_resist, @state_resist = [], [], []
  end
  #--------------------------------------------------------------------------
  def element_resist
    return @element_resist unless @element_resist.nil?
    resist = Element_Resist.dup
    @element_resist = []
    for i in 1...$data_system.elements.size
      if resist['Weapon'] != nil && resist['Weapon'][@id] != nil && 
         resist['Weapon'][@id][i] != nil
        @element_resist[i] = resist['Weapon'][@id][i]
      else
        @element_resist[i] = 0
      end
    end
    return @element_resist
  end
  #--------------------------------------------------------------------------
  def state_resist
    return @state_resist unless @state_resist.nil?
    resist = State_Resist.dup
    @state_resist = []
    for i in 1...$data_states.size
      if resist['Weapon'] != nil && resist['Weapon'][@id] != nil && 
         resist['Weapon'][@id][i] != nil
        @state_resist[i] = resist['Weapon'][@id][i]
      else
        @state_resist[i] = 0
      end
    end
    return @state_resist
  end
  #--------------------------------------------------------------------------
  def multi_auto_state_id
    st = Auto_Status['Weapon']
    return @multi_auto_state_id = st != nil && st[@id] != nil ? st[@id] : []
  end
  #--------------------------------------------------------------------------
  def hit
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['hit'] != nil ? wpn[@id]['hit'] : 0
  end
  #--------------------------------------------------------------------------
  def crt
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['crt'] != nil ? wpn[@id]['crt'] : 0
  end
  #--------------------------------------------------------------------------
  def dmg
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['dmg'] != nil ? wpn[@id]['dmg'] : 0
  end
  #--------------------------------------------------------------------------
  def rcrt
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['rcrt'] != nil ? wpn[@id]['rcrt'] : 0
  end
  #--------------------------------------------------------------------------
  def rdmg
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['rdmg'] != nil ? wpn[@id]['rdmg'] : 0
  end
  #--------------------------------------------------------------------------
  def type_id
    return 0
  end
end

#==============================================================================
# ■ RPG::Armor
#==============================================================================
class RPG::Armor
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :multi_auto_state_id
  attr_accessor :crt
  attr_accessor :dmg
  attr_accessor :hit
  attr_accessor :rcrt
  attr_accessor :rdmg 
  attr_accessor :element_resist
  #--------------------------------------------------------------------------
  alias acbs_initialize_actorstatus_rpgarmor initialize
  def initialize
    acbs_initialize_actorstatus_rpgarmor
    @multi_auto_state_id, @element_resist, @state_resist = [], [], []
  end
  #--------------------------------------------------------------------------
  def element_resist
    return @element_resist unless @element_resist.nil?
    resist = Element_Resist.dup
    @element_resist = []
    for i in 1...$data_system.elements.size
      if resist['Armor'] != nil && resist['Armor'][@id] != nil && 
         resist['Armor'][@id][i] != nil
        @element_resist[i] = resist['Armor'][@id][i]
      else
        @element_resist[i] = 0
      end
    end
    return @element_resist
  end
  #--------------------------------------------------------------------------
  def state_resist
    return @state_resist unless @state_resist.nil?
    resist = State_Resist.dup
    @state_resist = []
    for i in 1...$data_states.size
      if resist['Armor'] != nil && resist['Armor'][@id] != nil && 
         resist['Armor'][@id][i] != nil
        @state_resist[i] = resist['Armor'][@id][i]
      else
        @state_resist[i] = 0
      end
    end
    return @state_resist
  end
  #--------------------------------------------------------------------------
  def multi_auto_state_id
    st = Auto_Status['Armor']
    return @multi_auto_state_id = st != nil && st[@id] != nil ? st[@id] : []
  end
  #--------------------------------------------------------------------------
  def hit
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['hit'] != nil ? arm[@id]['hit'] : 0
  end
  #--------------------------------------------------------------------------
  def crt
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['crt'] != nil ? arm[@id]['crt'] : 0
  end
  #--------------------------------------------------------------------------
  def dmg
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['dmg'] != nil ? arm[@id]['dmg'] : 0
  end
  #--------------------------------------------------------------------------
  def rcrt
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['rcrt'] != nil ? arm[@id]['rcrt'] : 0
  end
  #--------------------------------------------------------------------------
  def rdmg
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['rdmg'] != nil ? arm[@id]['rdmg'] : 0
  end
  #--------------------------------------------------------------------------
  def type_id
    if Extra_Equips_ID != nil
      for kind in Extra_Equips_ID.dup
        return kind[0] if kind[1].include?(@id)
      end
    end
    return @kind + 1
  end
end

#==============================================================================
# ■ RPG::State
#==============================================================================
class RPG::State
  #--------------------------------------------------------------------------
  attr_accessor :element_resist
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  alias acbs_initialize_actorstatus_rpgstate initialize
  def initialize
    acbs_initialize_actorstatus_rpgstate
    @element_resist, @state_resist = [], []
  end
  #--------------------------------------------------------------------------
  def element_resist
    return @element_resist unless @element_resist.nil?
    resist = Element_Resist.dup
    @element_resist = []
    for i in 1...$data_system.elements.size
      if resist['State'] != nil && resist['State'][@id] != nil && 
         resist['State'][@id][i] != nil
        @element_resist[i] = resist['State'][@id][i]
      else
        @element_resist[i] = 0
      end
    end
    return @element_resist
  end
  #--------------------------------------------------------------------------
  def state_resist
    return @state_resist unless @state_resist.nil?
    resist = State_Resist.dup
    @state_resist = []
    for i in 1...$data_states.size
      if resist['State'] != nil && resist['State'][@id] != nil && 
         resist['State'][@id][i] != nil
        @state_resist[i] = resist['State'][@id][i]
      else
        @state_resist[i] = 0
      end
    end
    return @state_resist
  end
end

#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :two_swords_actors
  attr_accessor :two_swords_classes
  #--------------------------------------------------------------------------
  alias acbs_initialize_actorstatus_gameparty initialize
  def initialize
    acbs_initialize_actorstatus_gameparty
    @two_swords_actors = two_swords_actors
    @two_swords_classes = two_swords_classes
  end
  #--------------------------------------------------------------------------
  def two_swords_actors
    return @two_swords_actors.nil? ? Two_Swords_Actors.dup : @two_swords_actors
  end
  #--------------------------------------------------------------------------
  def two_swords_actors_add(id)
    actor = $game_actors[id]
    actor.remove_left_equip_actor
    @two_swords_actors << id
    @two_swords_actors.compact!
  end
  #--------------------------------------------------------------------------
  def two_swords_actors_remove(id)
    actor = $game_actors[id]
    actor.remove_left_equip_actor
    @two_swords_actors.delete(id)
    @two_swords_actors.compact!
  end
  #--------------------------------------------------------------------------
  def two_swords_classes
    return @two_swords_classes.nil? ? Two_Swords_Classes.dup : @two_swords_classes
  end
  #--------------------------------------------------------------------------
  def two_swords_classes_add(id)
    for actor in @actors
      actor.remove_left_equip_class(id)
    end
    @two_swords_classes << id
    @two_swords_classes.compact!
  end
  #--------------------------------------------------------------------------
  def two_swords_classes_remove(id)
    for actor in @actors
      actor.remove_left_equip_class(id)
    end
    @two_swords_classes.delete(id)
    @two_swords_classes.compact!
  end
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :crt
  attr_accessor :dmg
  attr_accessor :rcrt
  attr_accessor :rdmg
  attr_accessor :multi_attack
  attr_accessor :current_weapon
  attr_accessor :second_attack
  #--------------------------------------------------------------------------
  alias acbs_initialize_actorstatus_gamebattler initialize
  def initialize
    acbs_initialize_actorstatus_gamebattler
    @multi_attack = @second_attack = false
  end
  #--------------------------------------------------------------------------
  def crt
    return 5
  end
  #--------------------------------------------------------------------------
  def dmg
    return 100
  end
  #--------------------------------------------------------------------------
  def rcrt
    return 0
  end
  #--------------------------------------------------------------------------
  def rdmg
    return 0
  end
  #--------------------------------------------------------------------------
  def set_attack_critical(attacker)
    atk_crt = DAMAGE_ALGORITHM_TYPE > 1 ? attacker.agi : attacker.dex
    res_crt = attacker.crt - self.rcrt
    self.critical = rand(100) < [res_crt, 1].max * atk_crt / self.agi
  end
  #--------------------------------------------------------------------------
  def set_critical_damage(attacker)
    dmg_crt = attacker.dmg - self.rdmg
    self.damage += (self.damage * [dmg_crt, 1].max) / 100
  end
  #--------------------------------------------------------------------------
  def state_rate(state_id)
    table = [0,100,80,60,40,20,0]
    if Use_New_Resist
      result = state_rate_ranks(state_id)
    else
      result = table[self.state_ranks[state_id]]
    end
    return result
  end
  #--------------------------------------------------------------------------
  def states_plus(plus_state_set)
    effective = false
    for i in plus_state_set
      unless self.state_guard?(i)
        effective |= self.state_full?(i) == false
        if $data_states[i].nonresistance
          @state_changed = true
          add_state(i)
        elsif self.state_full?(i) == false
          state = state_rate(i)
          if rand(100) < state
            @state_changed = true
            add_state(i)
          end
        end
      end
    end
    return effective
  end
  #--------------------------------------------------------------------------
  alias acbs_elements_correct_actorstatus elements_correct
  def elements_correct(element_set)
    if Use_New_Resist
      value = 100
      absorb = false
      for i in element_set
        element = element_rate_rank(i)
        element *= -1 if element < 0 and absorb == true
        value *= element / 100
        absorb = true if element < 0 and absorb == false
      end
      return value.to_i
    else
      acbs_elements_correct_actorstatus(element_set)
    end
  end
  #--------------------------------------------------------------------------
  alias set_attack_damage_value_actorstatus set_attack_damage_value
  def set_attack_damage_value(attacker)
    if attacker.actor? and attacker.weapons.size > 0
      if attacker.actor? and attacker.weapons[0] != nil and attacker.weapons[1] != nil
        if Use_Old_Two_Sword_Beahave
          mulitiplier = attacker.second_attack ? TWO_SWORDS_STYLE[0] : TWO_SWORDS_STYLE[1]
        else
          mulitiplier = Dual_Attack_Power
        end
        wpn = (attacker.weapons[0].atk * mulitiplier) / 100
        wpn = (attacker.weapons[1].atk * mulitiplier) / 100 if attacker.second_attack
        weapon = attacker.second_attack ? attacker.weapons[1] : attacker.weapons[0]
      else
        weapon = attacker.weapons[0]
        wpn = attacker.atk
      end
      if Weapon_Damage_Type.include?(weapon.id)
        pwr = 0
        for stat in Weapon_Damage_Type[weapon.id]
          pwr += eval("(attacker.#{stat[0]} * #{stat[1]}).to_i")
        end
      else
        pwr = attacker.str
      end
      case DAMAGE_ALGORITHM_TYPE
      when 0
        atk = [wpn - (self.pdef / 2), 0].max
        str = [20 + pwr, 0].max
      when 1
        atk = [wpn - ((wpn * self.pdef) / 1000), 0].max
        str = [20 + pwr, 0].max
      when 2
        atk = 20
        str = [(pwr * 3) - (self.dex * 2) , 0].max
      when 3
        atk = [(10 + wpn) - (self.pdef / 2), 0].max
        str = [(20 + pwr) - (self.dex / 2), 0].max
      end
      self.damage = atk * str / 20
      self.damage = 1 if self.damage == 0 and (rand(100) > 40)
      self.damage *= elements_correct(weapon.element_set)
      self.damage /= 100
      attacker.second_attack = true if attacker.actor? and attacker.weapons[0] != nil and attacker.weapons[1] != nil
    else
      set_attack_damage_value_actorstatus(attacker)
    end
  end
  #--------------------------------------------------------------------------
  alias acbs_set_skill_power_actor_status_n01 set_skill_power
  def set_skill_power(user, skill)
    if user.actor?
      if user.actor? and user.weapons[0] != nil and user.weapons[1] != nil
        if Use_Old_Two_Sword_Beahave
          mulitiplier = ((TWO_SWORDS_STYLE[0] + TWO_SWORDS_STYLE[1]) / 2)
        else
          mulitiplier = Dual_Attack_Power
        end
        wpn = (user.atk * mulitiplier) / 100
      else
        wpn = user.atk
      end
      if Weapon_Damage_Type.include?(user.weapons[0].id)
        pwr = 0
        for stat in Weapon_Damage_Type[user.weapons[0].id]
          pwr += eval("(user.#{stat[0]} * #{stat[1]}).to_i")
        end
      else
        pwr = user.str
      end
      case DAMAGE_ALGORITHM_TYPE
      when 0,1,3
        power = skill.power + ((wpn * skill.atk_f) / 100)
      when 2
        user_str = (pwr * 4 * skill.str_f / 100)
        user_int = (user.int * 2 * skill.int_f / 100)
        if skill.power > 0
          power = skill.power + user_str + user_int
        else
          power = skill.power - user_str - user_int
        end
      end
      return power
    else
      return acbs_set_skill_power_actor_status_n01(user, skill)
    end
  end
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  attr_accessor :weapon_fix
  attr_accessor :armor_fix
  attr_accessor :equip_kind
  attr_accessor :equip_names
  attr_accessor :weapons
  attr_accessor :equip_id
  attr_accessor :two_swords_style
  #--------------------------------------------------------------------------
  alias acbs_initialize_actorstatus_gameactor initialize
  def initialize(actor_id)
    reset_set_status
    acbs_initialize_actorstatus_gameactor(actor_id)
    @equipment_skills = []
    @equip_id = []
    @equip_kind = equip_kind
    @equip_names = equip_names
    @element_resist = element_resist
    @state_resist = state_resist
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id == 0 and i == 0
        @equip_id[i] = @weapon_id
      elsif id != 0 and (1..4).include?(id)
        @equip_id[i] = eval("@armor#{id}_id")
      else
        @equip_id[i] = 0
      end
    end
    @weapon_fix = [@weapon_fix]
    @weapon_fix[1] = @armor1_fix if two_swords_style
    @armor_fix = [false]
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if (1..4).include?(id) and not (id == 1 and two_swords_style)
        @armor_fix[i] = eval("@armor#{id}_fix")
      elsif id > 0 and not (id == 1 and two_swords_style)
        @armor_fix[i] = false
      end
    end 
    @armor_fix[1] = @armor1_fix unless two_swords_style
    @equip_id[1] = 0 if Two_Hands_Weapons.include?(@weapon_id) or two_swords_style
    gain_equip_skills
    update_equip_set
    @elemental_resist = elemental_resist
    @states_resist = states_resist
    for equip in armors do update_auto_state(nil, equip) end
    for equip in equips do update_multi_auto_state(nil, equip) end
  end
  #--------------------------------------------------------------------------
  def element_resist
    return @element_resist unless @element_resist.nil?
    resist = Element_Resist.dup
    @element_resist = []
    for i in 1..$data_system.elements.size
      if resist['Actor'] != nil && resist['Actor'][@actor_id] != nil && 
         resist['Actor'][@actor_id][i] != nil
        @element_resist[i] = resist['Actor'][@actor_id][i]
      else
        @element_resist[i] = 0
      end
    end
    return @element_resist
  end
  #--------------------------------------------------------------------------
  def element_resist=(elements)
    return @element_resist unless elements.is_a?(Hash)
    resist = elements.dup
    @element_resist = []
    for i in 1...$data_system.elements.size
      if resist != nil && resist[i] != nil
        @element_resist[i] = resist[i]
      else
        @element_resist[i] = 0
      end
    end
    return @element_resist
  end
  #--------------------------------------------------------------------------
  def state_resist
    return @state_resist unless @state_resist.nil?
    resist = State_Resist.dup
    @state_resist = []
    for i in 1...$data_states.size
      if resist['Actor'] != nil && resist['Actor'][@actor_id] != nil && 
         resist['Actor'][@actor_id][i] != nil
        @state_resist[i] = resist['Actor'][@actor_id][i]
      else
        @state_resist[i] = 0
      end
    end
    return @state_resist
  end
  #--------------------------------------------------------------------------
  def state_resist=(states)
    return @state_resist unless states.is_a?(Hash)
    resist = states.dup
    @state_resist = []
    for i in 1...$data_states.size
      if resist != nil && resist[i] != nil
        @state_resist[i] = resist[i]
      else
        @state_resist[i] = 0
      end
    end
    return @state_resist
  end
  #--------------------------------------------------------------------------
  def equip_names
    return @equip_names.nil? ? Equip_Names : @equip_names
  end
  #--------------------------------------------------------------------------
  def equip_names=(n)
    @equip_names = n
  end
  #--------------------------------------------------------------------------
  def equip_kind
    return @equip_kind.nil? ? Equip_Kinds : @equip_kind
  end
  #--------------------------------------------------------------------------
  def equip_kind=(n)
    for i in 0...@equip_kind.size
      equip(i, 0) if @equip_kind[i] != n[i]
    end
    @equip_kind = n
    set_equip_id
  end
  #--------------------------------------------------------------------------
  def set_equip_id
    for i in 0...@equip_kind.size
      @equip_id[i] = 0 if @equip_id[i] == nil
    end
  end
  #--------------------------------------------------------------------------
  def two_swords_style
    return true if $game_party.two_swords_actors.include?(@actor_id)
    return true if $game_party.two_swords_classes.include?(@class_id)
    return false
  end
  #--------------------------------------------------------------------------
  def weapons
    result = []
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id == 0 or (id == 1 and two_swords_style)
        result << $data_weapons[@equip_id[i]]
      end
    end
    return result.compact
  end
  #--------------------------------------------------------------------------
  def armors
    result = []
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id > 1 or (id == 1 and not two_swords_style)
        result << $data_armors[@equip_id[i]]
      end
    end
    return result.compact
  end
  #--------------------------------------------------------------------------
  def equips
    return weapons + armors
  end  
  #--------------------------------------------------------------------------
  def elemental_resist
    @elemental_resist = [0]
    for i in 1...$data_system.elements.size
      value = $data_classes[@class_id].element_ranks[i]
      case Addition_Type
      when 0,2
        value += @element_resist[i]
        element_size = 1
        for kind in 0...@equip_kind.size
          id = @equip_kind[kind]
          if id == 0 or (id == 1 and two_swords_style)
            eqp = $data_weapons[@equip_id[kind]]
          else
            eqp = $data_armors[@equip_id[kind]]
          end
          value += eqp.element_resist[i] if eqp != nil
          element_size += 1 if eqp != nil and eqp.element_resist[i] != 0
        end
        for state in @states
          value += $data_states[state].element_resist[i]
          element_size += 1 if $data_states[state].element_resist[i] != 0
        end
        for set in @set_elemental_resist
          value += set[i] if set[i] != nil
          element_size += 1 if set[i] != nil and set[i] != 0
        end
        value /= element_size if Addition_Type == 2      
      when 1,3
        h, l = 0, 0
        h = @element_resist[i] if @element_resist[i] > 0
        l = @element_resist[i] if @element_resist[i] < 0
        for kind in 0...@equip_kind.size
          id = @equip_kind[kind]
          if id == 0 or (id == 1 and two_swords_style)
            eqp = $data_weapons[@equip_id[kind]]
          else
            eqp = $data_armors[@equip_id[kind]]
          end          
          if eqp.element_resist[i] > h and eqp.element_resist[i] > 0
            h = eqp.element_resist[i]
          elsif eqp.element_resist[i] < l and eqp.element_resist[i] < 0
            l = eqp.element_resist[i]
          end
        end
        for state in @states
          st = $data_states[state]
          if st.element_resist[i] > h and st.element_resist[i] > 0
            h = st.element_resist[i]
          elsif st.element_resist[i] < l and st.element_resist[i] < 0
            l = st.element_resist[i]
          end
        end
        for set in @set_elemental_resist
          if set[i] != nil and set[i] > h and set[i] > 0
            h = set[i]
          elsif set[i] != nil and set[i] < l and set[i] < 0
            l = set[i]
          end
        end
        value = h + l
        value /= 2 if h != 0 and l != 0 and Addition_Type == 2
      end
      @elemental_resist << [[value.to_i, 6].min, 1].max
    end
   return @elemental_resist
  end
  #--------------------------------------------------------------------------
  def states_resist
    @states_resist = [0]
    for i in 1...$data_states.size
      value = $data_classes[@class_id].state_ranks[i]
      case Addition_Type
      when 0,2
        value += @state_resist[i]
        state_size = 1
        for kind in 0...@equip_kind.size
          id = @equip_kind[kind]
          if id == 0 or (id == 1 and two_swords_style)
            eqp = $data_weapons[@equip_id[kind]]
          else
            eqp = $data_armors[@equip_id[kind]]
          end
          value += eqp.state_resist[i] if eqp != nil
          state_size += 1 if eqp != nil and eqp.state_resist[i] != 0
        end
        for state in @states
          value += $data_states[state].state_resist[i]
          state_size += 1 if $data_states[state].state_resist[i] != 0
        end
        for set in @set_state_resist
          value += set[i] if set[i] != nil
          element_size += 1 if set[i] != nil and set[i] != 0
        end
        value /= state_size if Addition_Type == 2
      when 1,3
        h, l = 0, 0
        h = @state_resist[i] if @state_resist[i] > 0
        l = @state_resist[i] if @state_resist[i] < 0
        for kind in 0...@equip_kind.size
          id = @equip_kind[kind]
          if id == 0 or (id == 1 and two_swords_style)
            eqp = $data_weapons[@equip_id[kind]]
          else
            eqp = $data_armors[@equip_id[kind]]
          end          
          if eqp.state_resist[i] > h and eqp.state_resist[i] > 0
            h = eqp.state_resist[i]        
          elsif eqp.state_resist[i] < l and eqp.state_resist[i] < 0
            l = eqp.state_resist[i]        
          end
        end
        for state in @states
          st = $data_states[state]
          if st.state_resist[i] > h and st.state_resist[i] > 0
            h = st.state_resist[i]        
          elsif st.state_resist[i] < l and st.state_resist[i] < 0
            l = st.state_resist[i]        
          end
        end
        for set in @set_state_resist
          if set[i] != nil and set[i] > h and set[i] > 0
            h = set[i]
          elsif set[i] != nil and set[i] < l and set[i] < 0
            l = set[i]
          end
        end
        value = h + l
        value /= 2 if h != 0 and l != 0
      end
      @states_resist << [[value.to_i, 6].min, 1].max
    end
    return @states_resist
  end
  #--------------------------------------------------------------------------
  def element_rate_rank(element_id)
    table = [0,200,150,100,50,0,-100]
    result = table[elemental_resist[element_id]]
    return result
  end
  #--------------------------------------------------------------------------
  def state_rate_ranks(state_id)
    table = [0,100,80,60,40,20,0]
    result = table[states_resist[state_id]]
    return result
  end
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id > 1 or (id == 1 and not two_swords_style)
        armor = $data_armors[@equip_id[i]]
        return true if armor != nil && armor.guard_state_set.include?(state_id)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  def sp_change_equip
    sp_equip = 100
    for equip in equips.compact
      if equip.is_a?(RPG::Weapon) and Sp_Cost_Change_Equip['Weapon'] != nil and
         Sp_Cost_Change_Equip['Weapon'].include?(equip.id)
        sp_equip = (((100 - Sp_Cost_Change_Equip['Weapon'][equip.id]) * sp_equip)/ 100)
      elsif equip.is_a?(RPG::Armor) and Sp_Cost_Change_Equip['Armor'] != nil and
         Sp_Cost_Change_Equip['Armor'].include?(equip.id)
        sp_equip = (((100 - Sp_Cost_Change_Equip['Armor'][equip.id]) * sp_equip)/ 100)
      end
    end
    return [sp_equip, 0].max
  end
  #-------------------------------------------------------------------------- 
  unless @alias_acbs_calc_sp_cost_actorstatus
    alias acbs_calc_sp_cost_actorstatus calc_sp_cost 
    @alias_acbs_calc_sp_cost_actorstatus = true
  end
  def calc_sp_cost(user, skill)
    cost = acbs_calc_sp_cost_actorstatus(user, skill)
    return (cost * sp_change_equip) / 100
  end
  #-------------------------------------------------------------------------- 
  def exp=(exp)
    lose_equip_skills
    forget_set_skills
    @exp = [exp, 0].max
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      for j in $data_classes[@class_id].learnings
        if j.level == @level
          learn_skill(j.skill_id)
        end
      end
    end
    while @exp < @exp_list[@level]
      @level -= 1
    end
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
    gain_equip_skills
    update_equip_set
  end
  #-------------------------------------------------------------------------- 
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    (2..(self.final_level + 1)).each { |i|
      if i > self.final_level
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    }
  end
  #-------------------------------------------------------------------------- 
  def level=(level)
    level = [[level, self.final_level].min, 1].max
    self.exp = @exp_list[level]
  end
  #-------------------------------------------------------------------------- 
  def final_level
    return Max_Level[@actor_id] != nil ? Max_Level[@actor_id] : Max_Level_Default
  end  
  #-------------------------------------------------------------------------- 
  def base_parameter(type)
    if @level >= 100
      calc_text = ("(param[99] - param[98]) * (level - 99)").dup
      calc_text.gsub!(/level/i) {"@level"}
      calc_text.gsub!(/param\[(\d+)\]/i) {
        "$data_actors[@actor_id].parameters[type, #{$1.to_i}]"}
      return $data_actors[@actor_id].parameters[type, 99] + eval(calc_text)
    end
    return $data_actors[@actor_id].parameters[type, @level]
  end
  #--------------------------------------------------------------------------
  def base_maxhp
    n = base_parameter(0)
    n *= Actor_Mult_Hp
    return [[n.to_i, 1].max, Actor_Max_Hp].min
  end
  #--------------------------------------------------------------------------
  def maxhp
    n = base_maxhp + @maxhp_plus + @set_maxhp
    for i in @states do n *= $data_states[i].maxhp_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Hp].min
  end
  #--------------------------------------------------------------------------
  def base_maxsp
    n = base_parameter(1)
    n *= Actor_Mult_Sp
    return [[n.to_i, 1].max, Actor_Max_Sp].min
  end
  #--------------------------------------------------------------------------
  def maxsp
    n = base_maxsp + @maxsp_plus + @set_maxsp
    for i in @states do n *= $data_states[i].maxsp_rate / 100.0 end
    return [[n.to_i, 0].max, Actor_Max_Sp].min
  end
  #--------------------------------------------------------------------------
  def base_str
    n = base_parameter(2)
    n *= Actor_Mult_Str
    for item in equips.compact do n += item.str_plus end
    return [[n.to_i, 1].max, Actor_Max_Str].min
  end
  #--------------------------------------------------------------------------
  def str
    n = base_str + @str_plus + @set_str
    for i in @states do n *= $data_states[i].str_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Str].min
  end
  #--------------------------------------------------------------------------
  def base_dex
    n = base_parameter(3)
    n *= Actor_Mult_Dex
    for item in equips.compact do n += item.dex_plus end
    return [[n.to_i, 1].max, Actor_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  def dex
    n = base_dex + @dex_plus + @set_dex
    for i in @states do n *= $data_states[i].dex_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  def base_agi
    n = base_parameter(4)
    n *= Actor_Mult_Agi
    for item in equips.compact do n += item.agi_plus end
    return [[n.to_i, 1].max, Actor_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  def agi
    n = base_agi + @agi_plus + @set_agi
    for i in @states do n *= $data_states[i].agi_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  def base_int
    n = base_parameter(5)
    n *= Actor_Mult_Int
    for item in equips.compact do n += item.int_plus end
    return [[n.to_i, 1].max, Actor_Max_Int].min
  end
  #--------------------------------------------------------------------------
  def int
    n = base_int + @int_plus + @set_int
    for i in @states do n *= $data_states[i].int_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Int].min
  end
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -Actor_Max_Hp].max, Actor_Max_Hp].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  def maxsp=(maxsp)
    @maxsp_plus += maxsp - self.maxsp
    @maxsp_plus = [[@maxsp_plus, -Actor_Max_Sp].max, Actor_Max_Sp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -Actor_Max_Str].max, Actor_Max_Str].min
  end
  #--------------------------------------------------------------------------
  def dex=(dex)
    @dex_plus += dex - self.dex
    @dex_plus = [[@dex_plus, -Actor_Max_Dex].max, Actor_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  def agi=(agi)
    @agi_plus += agi - self.agi
    @agi_plus = [[@agi_plus, -Actor_Max_Agi].max, Actor_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  def int=(int)
    @int_plus += int - self.int
    @int_plus = [[@int_plus, -Actor_Max_Int].max, Actor_Max_Int].min
  end
  #-------------------------------------------------------------------------- 
  def base_atk
    n = 0
    for item in weapons.compact do n += item.atk end
    n += @set_atk
    unarmed = UNARMED_ATTACK
    n = unarmed if weapons.empty?
    return [[n.to_i, 0].max, Actor_Max_Atk].min
  end
  #-------------------------------------------------------------------------- 
  def base_pdef
    n = 0
    for item in equips.compact do n += item.pdef end
    n += @set_pdef
    return [[n.to_i, 0].max, Actor_Max_PDef].min
  end
  #-------------------------------------------------------------------------- 
  def base_mdef
    n = 0
    for item in equips.compact do n += item.mdef end
    n += @set_mdef
    return [[n.to_i, 0].max, Actor_Max_MDef].min
  end
  #-------------------------------------------------------------------------- 
  def base_eva
    n = 0
    for item in armors.compact do n += item.eva end
    n += @set_eva
    return n
  end
  #------------------------------------------------------------------------------
  def update_multi_auto_state(old, new)
    if old != nil
      for state in old.multi_auto_state_id do remove_state(state, true) end
    end
    if new != nil and not self.dead?
      for state in new.multi_auto_state_id do add_state(state, true) end
    end
  end
  #------------------------------------------------------------------------------
  def hit
    n = super
    for item in equips.compact do n += item.hit end
    n += @set_hit
    return n.to_i
  end
  #--------------------------------------------------------------------------
  def crt
    n = super
    for item in equips.compact do n += item.crt end
    n += @set_crt
    return n.to_i
  end
  #--------------------------------------------------------------------------
  def dmg
    n = super
    for item in equips.compact do n += item.dmg end
    n += @set_dmg
    return n.to_i
  end
  #--------------------------------------------------------------------------
  def rcrt
    n = super
    for item in equips.compact do n += item.rcrt end
    n += @set_rcrt
    return n.to_i
  end
  #--------------------------------------------------------------------------
  def rdmg
    n = super
    for item in equips.compact do n += item.rdmg end
    n += @set_rdmg
    return n.to_i
  end
  #--------------------------------------------------------------------------
  def lock_equip(type)
    equip = (type == 0 or (type == 1 and two_swords_style)) ? 'Weapon' : 'Armor'
    id = @equip_kind[type]
    if Equip_Lock[equip] != nil
      eqp = Equip_Lock[equip].dup
    else
      return false
    end
    return (eqp.include?(@actor_id) and eqp[@actor_id].include?(id))
  end
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    type = @equip_kind[equip_type]
    if type == 0  
      if id == 0 or $game_party.weapon_number(id) > 0
        update_multi_auto_state($data_weapons[@equip_id[equip_type]], $data_weapons[id])
        $game_party.gain_weapon(@equip_id[equip_type], 1)
        @equip_id[equip_type] = id
        $game_party.lose_weapon(id, 1)
      end
    elsif type == 1
      if two_swords_style
        if id == 0 or $game_party.weapon_number(id) > 0
          update_multi_auto_state($data_weapons[@equip_id[equip_type]], $data_weapons[id])
          $game_party.gain_weapon(@equip_id[equip_type], 1)
          @equip_id[equip_type] = id
          $game_party.lose_weapon(id, 1)
        end
      else
        if id == 0 or $game_party.armor_number(id) > 0
          update_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
          update_multi_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
          $game_party.gain_armor(@equip_id[equip_type], 1)
          @equip_id[equip_type] = id
          $game_party.lose_armor(id, 1)
        end
      end
    elsif type > 1
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
        update_multi_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
        $game_party.gain_armor(@equip_id[equip_type], 1)
        @equip_id[equip_type] = id
        $game_party.lose_armor(id, 1)
      end
    end
    gain_equip_skills
    update_equip_set
  end
  #-------------------------------------------------------------------------- 
  def gain_equip_skills
    lose_equip_skills
    for kind in 0...@equip_kind.size
      id = @equip_kind[kind]
      if id == 0 or (id == 1 and two_swords_style)
        eqp = $data_weapons[@equip_id[kind]]
      else
        eqp = $data_armors[@equip_id[kind]]
      end
      if Equip_Skills[eqp.type] != nil and Equip_Skills[eqp.type][eqp.id] != nil
        skills = Equip_Skills[eqp.type][eqp.id].dup
        for skill in skills
          get_new_equip_skill(skill[1]) if skill[0] <= @level
        end
      end
    end
  end
  #-------------------------------------------------------------------------- 
  def lose_equip_skills
    for lose_skills in @equipment_skills
      self.forget_skill(lose_skills)
    end
    @equipment_skills.clear
  end
  #-------------------------------------------------------------------------- 
  def get_new_equip_skill(skill)
    unless self.skill_learn?(skill) or @equipment_skills.include?(skill)
      @equipment_skills << skill
      self.learn_skill(skill)
    end
  end
  #--------------------------------------------------------------------------
  def update_equip_set
    for state in @set_auto_states
      remove_state(state, true)
    end
    reset_set_status
    weapons_id = []
    armors_id = []
    for weapon in weapons
      weapons_id << weapon.id if weapon != nil
    end
    for armor in armors
      armors_id << armor.id if armor != nil
    end
    for set in Equip_Set
      armors_set = weapons_set = false
      if set[1]['Weapon'] != nil
        weapons_set_id = set[1]['Weapon'].dup
        weapons_set_id.uniq!
        set_size = 0
        for id in weapons_set_id
          set_size += 1 if weapons_id.include?(id)
        end
        weapons_set = true if set_size == weapons_set_id.size
      else
        weapons_set = true
      end
      if set[1]['Armor'] != nil
        armors_set_id = set[1]['Armor'].dup
        armors_set_id.uniq!
        set_size = 0
        for id in armors_set_id
          set_size += 1 if armors_id.include?(id)
        end
        armors_set = true if set_size == armors_set_id.size
      else
        armors_set = true
      end
      apply_set_efect(set[0]) if armors_set and weapons_set
    end
    for state in @set_auto_states
      add_state(state, true)
    end
    learn_set_skill
  end
  #--------------------------------------------------------------------------
  def reset_set_status
    status = ['maxhp','maxsp','atk','pdef','mdef','str','dex','int','agi','eva','hit',
      'crt','dmg','rcrt','rdmg']
    for st in status
      eval("@set_#{st} = 0")
    end
    @set_auto_states = []
    @set_elemental_resist = []
    @set_state_resist = []
    forget_set_skills
  end
  #--------------------------------------------------------------------------
  def apply_set_efect(set_id)
    return if Set_Effect[set_id].nil?
    set = Set_Effect[set_id].dup
    if set['status'] != nil
      for st in Set_Effect[set_id]['status']
        eval("@set_#{st[0]} += #{st[1]} if @set_#{st[0]} != nil")
      end
    end
    @set_skills << set['skills'] if  set['skills']
    @set_elemental_resist << set['elements'] if set['elements'] != nil
    @set_state_resist << set['states'] if set['states'] != nil
    @set_auto_states << set['auto states'] if set['auto states'] != nil
    @set_auto_states.flatten!
    @set_auto_states.uniq!
  end
  #--------------------------------------------------------------------------
  def forget_set_skills
    @set_skills = [] if @set_skills.nil?
    for skills in @set_skills
      for skill in skills
        self.forget_skill(skill[1])
      end
    end
    @set_skills.clear
  end
  #--------------------------------------------------------------------------
  def learn_set_skill
    for skills in @set_skills
      for skill in skills
        get_new_equip_skill(skill[1]) if skill[0] <= @level
      end
    end
  end
  #--------------------------------------------------------------------------
  def equippable?(item)
    if item.is_a?(RPG::Weapon)
      return true if $data_classes[@class_id].weapon_set.include?(item.id)
    end
    if item.is_a?(RPG::Armor)
      if $data_classes[@class_id].armor_set.include?(item.id) and not
         (item.type_id == 1 and two_swords_style)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  def remove_left_equip_actor
    for i in 0...@equip_kind.size
      equip(i, 0) if @equip_kind[i] == 1
    end
  end
  #--------------------------------------------------------------------------
  def remove_left_equip_class(class_id)
    if class_id == @class_id
      for i in 0...@equip_kind.size
        equip(i, 0) if @equip_kind[i] == 1
      end
    end
  end
  #--------------------------------------------------------------------------
  def remove_equip_class_change(class_id, old_class_id)
    if ($game_party.two_swords_classes.include?(class_id) and not
       $game_party.two_swords_classes.include?(old_class_id)) or
       ($game_party.two_swords_classes.include?(old_class_id) and not
       $game_party.two_swords_classes.include?(class_id))
      for i in 0...@equip_kind.size
        equip(i, 0) if @equip_kind[i] == 1
      end
    end
  end
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    remove_equip_class_change(class_id, @class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      for i in 0...@equip_kind.size
        if @equip_kind[i] == 0 or (@equip_kind[i] == 1 and two_swords_style)
          equip(i, 0) unless equippable?($data_weapons[@equip_id[i]])
        else
          equip(i, 0) unless equippable?($data_weapons[@equip_id[i]])
        end
      end
    end
  end
end

#==============================================================================
# ■  Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  def element_rate_rank(element_id)
    table = [0,200,150,100,50,0,-100]
    result = table[$data_enemies[@enemy_id].element_ranks[element_id]]
    value = $data_enemies[@enemy_id].element_ranks[element_id]
    case Addition_Type
    when 0,2
      for i in @states
        value += $data_states[i].element_resist[element_id]
        element_size += 1 if $data_states[i].element_resist[element_id] != 0
      end
      value /= element_size if Addition_Type == 2
    when 1,3
      h, l = 0, 0
      h = @element_resist[element_id] if @element_resist[element_id] > 0
      l = @element_resist[element_id] if @element_resist[element_id] < 0
      for i in @states
        st = $data_states[i]
        if st.element_resist[element_id] > h and st.element_resist[element_id] > 0
          h = st.element_resist[element_id]        
        elsif st.element_resist[element_id] < l and st.element_resist[element_id] < 0
          l = st.element_resist[element_id]        
        end
      end
      value = h + l
      value /= 2 if h != 0 and l != 0
    end
    result = table[[[value.to_i, 6].min,1].max]
    return result
  end
  #--------------------------------------------------------------------------
  def state_rate_ranks(state_id)
    table = [0,100,80,60,40,20,0]
    result = table[$data_enemies[@enemy_id].state_ranks[state_id]]
    value = $data_enemies[@enemy_id].state_ranks[state_id]
    case Addition_Type
    when 0,2
      for i in @states
        value += $data_states[i].state_resist[state_id]
        state_size += 1 if $data_states[i].state_resist[state_id] != 0
      end
      value /= state_size if Addition_Type == 2
    when 1,3
      h, l = 0, 0
      h = @state_resist[state_id] if @state_resist[state_id] > 0
      l = @state_resist[state_id] if @state_resist[state_id] < 0
      for i in @states
        st = $data_states[i]
        if st.state_resist[state_id] > h and st.state_resist[state_id] > 0
          h = st.state_resist[state_id]        
        elsif st.state_resist[state_id] < l and st.state_resist[state_id] < 0
          l = st.state_resist[state_id]        
        end
      end
      value = h + l
      value /= 2 if h != 0 and l != 0 and Addition_Type == 2
    end
    result = table[[[value.to_i, 6].min,1].max]
    return result
  end
end

#==============================================================================
# ■  Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type, w = 132)
    case type
    when 0
      parameter_name = $data_system.words.atk
      parameter_value = actor.atk
    when 1
      parameter_name = $data_system.words.pdef
      parameter_value = actor.pdef
    when 2
      parameter_name = $data_system.words.mdef
      parameter_value = actor.mdef
    when 3
      parameter_name = $data_system.words.str
      parameter_value = actor.str
    when 4
      parameter_name = $data_system.words.dex
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = Stat_Eva
      parameter_value = actor.eva
    when 8
      parameter_name = Stat_Hit
      parameter_value = actor.hit
    when 9
      parameter_name = Stat_Crt
      parameter_value = actor.crt
    when 10
      parameter_name = Stat_Dmg
      parameter_value = actor.dmg
    when 11
      parameter_name = Stat_Res_Crt
      parameter_value = actor.rcrt
    when 12
      parameter_name = Stat_Res_Dmg
      parameter_value = actor.rdmg
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, w + 32, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + w, y, 64, 32, parameter_value.to_s, 2)
  end
end

#==============================================================================
# ■ Window_Status
#==============================================================================
class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_graphic(@actor, 40, 112)
    draw_actor_name(@actor, 4, 0)
    draw_actor_class(@actor, 4 + 144, 0)
    draw_actor_level(@actor, 96, 32)
    draw_actor_state(@actor, 96, 64)
    draw_actor_hp(@actor, 96, 112, 172)
    draw_actor_sp(@actor, 96, 144, 172)
    for i in 0..2
      draw_actor_parameter(@actor, 96, 164 + [(236/(Extra_Status.size + 6)), 20].max * i, i)
    end
    for i in 3..6
      draw_actor_parameter(@actor, 96, 168 + [(236/(Extra_Status.size + 6)), 20].max * i, i)
    end
    for i in 7..(Extra_Status.size + 6)
      draw_actor_parameter(@actor, 96, 172 + [(236/(Extra_Status.size + 6)), 20].max * i,
        Extra_Status[i - 7])
    end
    self.contents.font.color = system_color
    self.contents.draw_text(320, 48, 80, 32, 'EXP')
    self.contents.draw_text(320, 80, 80, 32, 'Próximo')
    self.contents.draw_text(400, 128, 128, 32, 'Equipamentos')
    self.contents.font.color = normal_color
    self.contents.draw_text(400, 48, 84, 32, @actor.exp_s, 2)
    self.contents.draw_text(400, 80, 84, 32, @actor.next_rest_exp_s, 2)
    self.contents.font.color = system_color    
    data = []
    for i in 0...@actor.equip_kind.size
      id = @actor.equip_kind[i]
      if id == 0
        data.push($data_weapons[@actor.equip_id[i]])
      elsif id == 1 and @actor.two_swords_style
        data.push($data_weapons[@actor.equip_id[i]])
      elsif id != 0 or (id == 1 and not @actor.two_swords_style)
        data.push($data_armors[@actor.equip_id[i]])
      end
    end
    self.contents.font.color = system_color
    return if data.size == 0
    for i in 0...@actor.equip_names.size
      name = @actor.equip_names[i]
      self.contents.draw_text(320, 160 + [(280/data.size), 24].max * i, 92, 32, name)
    end
    for i in 0...data.size
      draw_item_name(data[i], 412, 160 + [(280/data.size), 24].max * i)
    end
  end
  #--------------------------------------------------------------------------
  def dummy
    self.contents.font.color = system_color
    self.contents.draw_text(400, 128, 128, 32, 'Equipamentos')
    data = []
    for i in 0...@actor.equip_kind.size
      id = @actor.equip_kind[i]
      if id == 0
        data.push($data_weapons[@actor.equip_id[i]])
      elsif id == 1 and @actor.two_swords_style
        data.push($data_weapons[@actor.equip_id[i]])
      elsif id != 0 or (id == 1 and not @actor.two_swords_style)
        data.push($data_armors[@actor.equip_id[i]])
      end
    end
    self.contents.font.color = system_color
    return if data.size == 0
    for i in 0...@actor.equip_names.size
      name = @actor.equip_names[i]
      self.contents.draw_text(320, 160 + [(280/data.size), 24].max * i, 92, 32, name)
    end
    for i in 0...data.size
      draw_item_name(data[i], 412, 160 + [(280/data.size), 24].max * i)
    end
  end
end

#==============================================================================
# Window_Selectable_Equip
#==============================================================================
class Window_Selectable_Equip < Window_Base
  #--------------------------------------------------------------------------
  attr_reader   :index
  attr_reader   :help_window
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item_max = 1
    @column_max = 1
    @index = -1
  end
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_help if self.active and @help_window != nil
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  def row_max
    return (@item_max + @column_max - 1) / @column_max
  end
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / 32
  end
  #--------------------------------------------------------------------------
  def top_row=(row)
    row = 0 if row < 0
    row = row_max - 1 if row > row_max - 1
    self.oy = row * 32
  end
  #--------------------------------------------------------------------------
  def page_row_max
    return (self.height - 32) / 32
  end
  #--------------------------------------------------------------------------
  def page_item_max
    return page_row_max * @column_max
  end
  #---------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    update_help if self.active and @help_window != nil
  end
  #---------------------------------------------------------------------------
  def update_cursor_rect
    return self.cursor_rect.empty if @index < 0
    row = @index / @column_max
    self.top_row = row if row < self.top_row
    if row > self.top_row + (self.page_row_max - 1)
      self.top_row = row - (self.page_row_max - 1)
    end
    cursor_width = self.width / @column_max - 32
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 32 - self.oy
    self.cursor_rect.set(x, y, cursor_width, 32)
  end
  #---------------------------------------------------------------------------
  def update
    super
    if self.active and @item_max > 0 and @index >= 0
      if Input.repeat?(Input::DOWN)
        if (@column_max == 1 and Input.trigger?(Input::DOWN)) or
           @index < @item_max - @column_max
          $game_system.se_play($data_system.cursor_se)
          @index = (@index + @column_max) % @item_max
        end
      end
      if Input.repeat?(Input::UP)
        if (@column_max == 1 and Input.trigger?(Input::UP)) or
           @index >= @column_max
          $game_system.se_play($data_system.cursor_se)
          @index = (@index - @column_max + @item_max) % @item_max
        end
      end
      if Input.repeat?(Input::RIGHT)
        if @column_max >= 2 and @index < @item_max - 1
          $game_system.se_play($data_system.cursor_se)
          @index += 1
        end
      end
      if Input.repeat?(Input::LEFT)
        if @column_max >= 2 and @index > 0
          $game_system.se_play($data_system.cursor_se)
          @index -= 1
        end
      end
      if Input.repeat?(Input::R)
        @index == @item_max if @index < @item_max
      end
      if Input.repeat?(Input::L)
        @index == @item_max if @index < @item_max
      end
    end
    if self.active and @help_window != nil
      update_help
    end
    update_cursor_rect
  end
end

#==============================================================================
# ■ Window_EquipRight
#==============================================================================
class Window_EquipRight < Window_Selectable_Equip
  #--------------------------------------------------------------------------  
  attr_accessor :data
  #--------------------------------------------------------------------------  
  include N01
  #--------------------------------------------------------------------------  
  def initialize(actor)
    case Equip_Menu_Syle
    when 0,2
      super(272, 64, 368, 192)
    when 1
      super(272, 64, 368, 224)
    when 3
      super(272, 64, 368, 192)
    when 4
      super(0, 64, 368, 192)
    end
    self.contents = Bitmap.new(width - 32, actor.equip_kind.size * 32)
    @actor = actor
    self.opacity = Equip_Window_Opacity
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------  
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------  
  def refresh
    self.contents.clear
    @data = []
    for i in 0...@actor.equip_kind.size
      id = @actor.equip_kind[i]
      if id == 0
        @data.push($data_weapons[@actor.equip_id[i]])
      elsif id == 1 and @actor.two_swords_style
        @data.push($data_weapons[@actor.equip_id[i]])
      elsif id != 0 or (id == 1 and not @actor.two_swords_style)
        @data.push($data_armors[@actor.equip_id[i]])
      end
    end
    @item_max = @data.size
    self.contents.font.color = system_color
    for i in 0...@actor.equip_names.size
      name = @actor.equip_names[i]
      self.contents.draw_text(4, 32 * i, 92, 32, name)
    end
    for i in 0...@data.size
      draw_item_name(@data[i], 92, 32 * i)
    end
  end
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.item == nil ? '' : self.item.description)
  end
end

#==============================================================================
# ■ Window_EquipLeft
#==============================================================================
class Window_EquipLeft < Window_Selectable
  #--------------------------------------------------------------------------
  include N01
  #--------------------------------------------------------------------------
  attr_accessor :new_equip
  attr_accessor :last_atk
  attr_accessor :last_pdef
  attr_accessor :last_mdef
  attr_accessor :last_str
  attr_accessor :last_dex
  attr_accessor :last_agi
  attr_accessor :last_int
  attr_accessor :last_eva
  attr_accessor :last_hit
  attr_accessor :last_crt
  attr_accessor :last_dmg
  attr_accessor :last_rcrt
  attr_accessor :last_rdmg
  #--------------------------------------------------------------------------
  def initialize(actor)
    case Equip_Menu_Syle
    when 0,2
      super(0, 64, 272, 192)
    when 1
      super(0, 64, 272, 224)
    when 3
      super(0, 64, 272, 416)
    when 4
      super(368, 64, 272, 416)
    end
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = Equip_Window_Opacity
    @actor = actor
    @new_equip, @last_equip = nil, nil
    @last_atk = @actor.atk
    @last_pdef = @actor.pdef
    @last_mdef = @actor.mdef
    @last_str = @actor.str
    @last_dex = @actor.dex
    @last_agi = @actor.agi
    @last_int = @actor.int
    @last_eva = @actor.eva
    @last_hit = @actor.hit
    @last_ctr = @actor.crt
    @last_dmg = @actor.dmg
    @last_rcrt = @actor.rcrt
    @last_rdmg = @actor.rdmg
    refresh
  end 
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @equip_stat, @base_stat, @new_stat = false, false, false
    case Equip_Menu_Syle
    when 0
      @equip_stat = true
      y_adjust = 64
      draw_actor_name(@actor, 12, 0)
      draw_actor_level(@actor, 12, 32)
    when 1
      @equip_stat, @base_stat = true, true
      y_adjust = 0
    when 2
      @base_stat = true
      y_adjust = 32
      draw_actor_name(@actor, 12, 0)
    when 3,4
      @equip_stat, @base_stat, @new_stat = true, true, true
      y_adjust = 0
    end
    self.contents.font.color = system_color
    y = 0
    for i in 0..12
      if ((0..2).include?(i) and @equip_stat) or ((3..6).include?(i) and @base_stat) or
         ((7..12).include?(i) and @new_stat)
        draw_actor_parameter(@actor, 12, y * 28 + y_adjust, i, 104)
        draw_change_arrow(y, y_adjust, i)
        y += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  def draw_change_arrow(y, adjust, type)
    case type
    when 0
      old_value = @actor.atk
      new_value = @new_atk
    when 1
      old_value = @actor.pdef
      new_value = @new_pdef
    when 2
      old_value = @actor.mdef
      new_value = @new_mdef
    when 3
      old_value = @actor.str
      new_value = @new_str
    when 4
      old_value = @actor.dex
      new_value = @new_dex
    when 5
      old_value = @actor.agi
      new_value = @new_agi
    when 6
      old_value = @actor.int
      new_value = @new_int
    when 7
      old_value = @actor.eva
      new_value = @new_eva
    when 8
      old_value = @actor.hit
      new_value = @new_hit
    when 9
      old_value = @actor.crt
      new_value = @new_crt
    when 10
      old_value = @actor.dmg
      new_value = @new_dmg
    when 11
      old_value = @actor.rcrt
      new_value = @new_rcrt
    when 12
      old_value = @actor.rdmg
      new_value = @new_rdmg
    end
    if new_value != nil
      if old_value == new_value
        self.contents.font.color = text_color(7)      
        self.contents.draw_text(172, y * 28 + adjust, 40, 32, Stat_Nil, 1)
        self.contents.font.color = normal_color
      elsif old_value < new_value
        self.contents.font.color = text_color(4)      
        self.contents.draw_text(172, y * 28 + adjust, 40, 32, Stat_Up, 1)
        self.contents.font.color = text_color(3)
      elsif old_value > new_value
        self.contents.font.color = text_color(6)      
        self.contents.draw_text(172, y * 28+ adjust, 40, 32, Stat_Down, 1)
        self.contents.font.color = text_color(2)
      end
      self.contents.draw_text(192, y * 28 + adjust, 48, 32, new_value.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  def set_new_parameters(new_atk = nil, new_pdef  = nil, new_mdef = nil, new_str  = nil,
        new_dex = nil, new_agi = nil, new_int = nil, new_eva = nil, new_hit = nil, 
        new_crt = nil, new_dmg = nil, new_rcrt = nil, new_rdmg = nil)
    if @new_str != new_str or @new_dex != new_dex or @new_agi != new_agi or 
       @new_int != new_int or @new_atk != new_atk or @new_pdef != new_pdef or
       @new_mdef != new_mdef or @new_eva != new_eva or @new_hit != new_hit or
       @new_crt != new_crt or @new_dmg != new_dmg or @new_rcrt != new_rcrt or
       @new_rdmg != new_rdmg
      @last_equip = @new_equip
      @new_atk = new_atk
      @new_pdef = new_pdef
      @new_mdef = new_mdef
      @new_str = new_str
      @new_dex = new_dex
      @new_agi = new_agi
      @new_int = new_int
      @new_eva = new_eva
      @new_hit = new_hit
      @new_crt = new_crt
      @new_dmg = new_dmg
      @new_rcrt = new_rcrt
      @new_rdmg = new_rdmg
      refresh
    end
  end
end

#==============================================================================
# Window_EquipItem
#==============================================================================
class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  attr_accessor :data
  #--------------------------------------------------------------------------
  def initialize(actor, equip_type)
    case Equip_Menu_Syle
    when 0,2
      super(0, 256, 640, 224)
      @column_max = 2
    when 1
      super(0, 288, 640, 192)
      @column_max = 2
    when 3
      super(272, 256, 368, 224)
      @column_max = 1
    when 4
      super(0, 256, 368, 224)
      @column_max = 1
    end
    @actor = actor
    @equip_type = equip_type
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    if @equip_type == 0 or (@equip_type == 1 and @actor.two_swords_style)
      weapon_set = $data_classes[@actor.class_id].weapon_set
      for i in 1...$data_weapons.size
        next if Two_Hands_Weapons.include?(i) and @equip_type == 1
        next if Right_Hand_Weapons.include?(i) and @equip_type == 1
        next if Left_Hand_Weapons.include?(i) and @equip_type == 0
        if $game_party.weapon_number(i) > 0 and weapon_set.include?(i)
          @data.push($data_weapons[i])
        end
      end
    end
    if @equip_type > 1 or (@equip_type == 1 and not @actor.two_swords_style)
      armor_set = $data_classes[@actor.class_id].armor_set
      for i in 1...$data_armors.size
        if $game_party.armor_number(i) > 0 and armor_set.include?(i)
          if $data_armors[i].type_id == @equip_type
            @data.push($data_armors[i])
          end
        end
      end
    end
    @data.push(nil) unless @actor.lock_equip(@equip_type)
    @item_max = @data.size
    self.contents = Bitmap.new(width - 32, [row_max, 1].max * 32)
    self.opacity = Equip_Window_Opacity
    for i in 0...(@actor.lock_equip(@equip_type) ? @item_max : @item_max - 1)
      draw_item(i)
    end
  end
  #-------------------------------------------------------------------------- 
  def draw_item(index)
    item = @data[index]
    case Equip_Menu_Syle
    when 0,1,2
      x = 4 + index % 2 * (288 + 32)
      y = index / 2 * 32
    when 3,4
      x = 4
      y = index * 32
    end
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ':', 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end

#==============================================================================
# ■ Scene_Equip
#==============================================================================
class Scene_Equip
  #-------------------------------------------------------------------------- 
  include N01
  #-------------------------------------------------------------------------- 
  def main
    @actor = $game_party.actors[@actor_index]
    @spriteset = Spriteset_Map.new if Show_Map_Equip_Menu
    if Equip_Menu_Back != nil
      @back_image = Sprite.new
      @back_image.bitmap = RPG::Cache.windowskin(Equip_Menu_Back)
    end
    @help_window = Window_Help.new
    @left_window = Window_EquipLeft.new(@actor)
    @right_window = Window_EquipRight.new(@actor)
    @right_window.index = @equip_index
    item_window_update
    @right_window.help_window = @help_window
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i + 1}.help_window = @help_window")
    end
    refresh
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
    Graphics.freeze
    @help_window.dispose
    @back_image.dispose if Equip_Menu_Back != nil
    @spriteset.dispose if Show_Map_Equip_Menu
    @left_window.dispose
    @right_window.dispose
    item_window_dispose  
  end
  #-------------------------------------------------------------------------- 
  def refresh
    @help_window.opacity = Equip_Window_Opacity
    if @right_window.index > @right_window.data.size - 1
      @right_window.index = @right_window.data.size - 1
    end
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i + 1}.visible = (@right_window.index == #{i})")
    end
    item1 = @right_window.item
    eval("@item_window = @item_window#{@right_window.index + 1}")
    @left_window.set_new_parameters if @right_window.active
    if @item_window.active
      @item2 = @item_window.item
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, @item2 == nil ? 0 : @item2.id)
      re_equip = []
      if @item2 != nil and @item2.type_id == 0 and Two_Hands_Weapons.include?(@item2.id)
        for i in 0...@actor.equip_kind.size
          id = @actor.equip_kind[i]
          if id == 1
            re_equip << [i, @actor.equip_id[i]]
            @actor.equip(i, 0)
          end
        end
      elsif @item2 != nil and (@item2.type_id == 1 or (@item2.type_id == 0 and 
         @actor.two_swords_style))
        for i in 0...@actor.equip_kind.size
          id = @actor.equip_kind[i]
          if @right_window.index != i and id == 0 and 
             Two_Hands_Weapons.include?(@actor.equip_id[id])
            re_equip << [i, @actor.equip_id[i]]
            @actor.equip(i, 0)
          end
        end
      end
      new_atk = @actor.atk
      new_pdef = @actor.pdef
      new_mdef = @actor.mdef
      new_str = @actor.str
      new_dex = @actor.dex
      new_agi = @actor.agi
      new_int = @actor.int
      new_eva = @actor.eva
      new_hit = @actor.hit
      new_crt = @actor.crt
      new_dmg = @actor.dmg
      new_rcrt = @actor.rcrt
      new_rdmg = @actor.rdmg
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      for equip in re_equip
        @actor.equip(equip[0], equip[1])
      end
      @actor.hp = last_hp
      @actor.sp = last_sp
      @left_window.set_new_parameters(new_atk, new_pdef, new_mdef, new_str, new_dex, 
        new_agi, new_int, new_eva, new_hit, new_crt, new_dmg, new_rcrt, new_rdmg)
    end
  end
  #-------------------------------------------------------------------------- 
  def item_window_update
    for i in 0...@actor.equip_kind.size
      type = @actor.equip_kind[i]
      eval("@item_window#{i+1} = Window_EquipItem.new(@actor, type)")
    end
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i + 1}.help_window = @help_window")
    end
    refresh
  end
  #-------------------------------------------------------------------------- 
  def item_window_dispose
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i+1}.dispose if @item_window#{i+1} != nil")
    end
  end
  #-------------------------------------------------------------------------- 
  def update_item
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @right_window.active = true
      @item_window.active = false
      @item_window.index = -1
      return
    end
    if Input.trigger?(Input::C)
      item = @item_window.item
      @actor.equip(@right_window.index, item == nil ? 0 : item.id)
      update_hands(item)
      @right_window.active = true
      @item_window.active = false
      @item_window.index = -1
      @right_window.refresh
      @item_window.refresh
      $game_system.se_play($data_system.equip_se)
      return
    end
  end
  #-------------------------------------------------------------------------- 
  def update_right
    if Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)
      @item_window.index = -1
      @item_window.refresh
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Menu.new(2)
      return
    end
    if Input.trigger?(Input::C)
      if @actor.equip_fix?(@right_window.index) or (@item_window.data.size == 0 and 
          @actor.lock_equip(@right_window.index))
        return $game_system.se_play($data_system.buzzer_se)
      end
      $game_system.se_play($data_system.decision_se)
      @right_window.active = false
      @item_window.active = true
      @item_window.index = 0
      return
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size + 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
  end
  #-------------------------------------------------------------------------- 
  def update_hands(item)
    if item != nil and item.type_id == 0 and Two_Hands_Weapons.include?(item.id)
      for i in 0...@actor.equip_kind.size
        id = @actor.equip_kind[i]
        @actor.equip(i, 0) if id == 1
      end
    elsif item != nil and (item.type_id == 1 or (item.type_id == 0 and @actor.two_swords_style))
      for i in 0...@actor.equip_kind.size
        id = @actor.equip_kind[i]
        if @right_window.index != i and id == 0 and 
           Two_Hands_Weapons.include?(@actor.equip_id[id])
          @actor.equip(i, 0)
        end
      end
    end
  end
end

#==============================================================================
# ■ Window_ShopStatus
#==============================================================================
class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @item == nil
      return
    end
    case @item
    when RPG::Item
      number = $game_party.item_number(@item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(@item.id)
    when RPG::Armor
      number = $game_party.armor_number(@item.id)
    end
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 200, 32, 'Você tem')
    self.contents.font.color = normal_color
    self.contents.draw_text(204, 0, 32, 32, number.to_s, 2)
    if @item.is_a?(RPG::Item)
      return
    end
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.equippable?(@item)
        self.contents.font.color = normal_color
      else
        self.contents.font.color = disabled_color
      end
      self.contents.draw_text(4, 64 + 64 * i, 120, 32, actor.name)
      for n in 0...actor.equip_kind.size
        id = actor.equip_kind[n]
        if @item.is_a?(RPG::Weapon) 
          item1 = $data_weapons[actor.equip_id[n]] if id == 0
        else
          if $data_armors[actor.equip_id[n]].type == @item.type_id and not
             (@item.type_id == 1 and actor.two_swords_style)
            item1 = $data_armors[actor.equip_id[n]]
          end
        end
      end
      if actor.equippable?(@item)
        change = 0
        if @item.is_a?(RPG::Weapon)
          atk1 = item1 != nil ? item1.atk : 0
          atk2 = @item != nil ? @item.atk : 0
          change = atk2 - atk1
        elsif @item.is_a?(RPG::Armor) && @item.kind <= 2
          pdef1 = item1 != nil ? item1.pdef : 0
          mdef1 = item1 != nil ? item1.mdef : 0
          pdef2 = @item != nil ? @item.pdef : 0
          mdef2 = @item != nil ? @item.mdef : 0
          change = pdef2 - pdef1 + mdef2 - mdef1
        elsif @item.is_a?(RPG::Armor) &&  @item.kind > 2
          change = 0
          item1 = nil
        end
        if change > 0 and actor.equippable?(@item)
          self.contents.font.color = text_color(3)
        elsif change < 0 and actor.equippable?(@item)
          self.contents.font.color = text_color(2)
        end
        self.contents.draw_text(64, 64 + 64 * i, 128, 32,sprintf('%+d', change), 2)
        self.contents.font.color = normal_color
      end
      if item1 != nil
        x = 4
        y = 64 + 64 * i + 32
        bitmap = RPG::Cache.icon(item1.icon_name)
        opacity = self.contents.font.color == normal_color ? 255 : 128
        self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
        self.contents.draw_text(x + 28, y, 212, 32, item1.name)
      end
    end
  end
  #--------------------------------------------------------------------------
  def item=(item)
    if @item != item
      @item = item
      refresh
    end
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  alias aas_turn_ending_n01 turn_ending
  def turn_ending
    for member in $game_party.actors + $game_troop.enemies
      member.second_attack = false
    end
    aas_turn_ending_n01
  end
  #--------------------------------------------------------------------------
  alias aas_action_end_n01 action_end
  def action_end
    aas_action_end_n01
    for member in $game_party.actors + $game_troop.enemies
      member.second_attack = false
    end
  end
end