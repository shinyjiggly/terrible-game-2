#==============================================================================
# Legaia Combo
# By Atoa
#==============================================================================
# This scripts emulates the combo system of the game Legend of Legaia
# With it, when you make an normal attack, you need to input an command sequence.
# and depending on the sequences, various attacks can be used.
#
# To open the list of combos, the script command is:
#  $scene = Scene_Combo.new(index)
#  where index is the actor index on the party
#
# NEW ADVANCED SETTINGS:
# There's nome new settings to add to actors, enemies and skills.
#
# Settings for skills
# "HIGHATTCK" - High Attack, don't hit targets with the setting "SMALL"
# "LOWATTCK"  - Low Attack, don't hit targets with the setting  "FLOAT"
#
# Settings for enemies and actors
# "SMALL" - Battler can't be target of attacks with the setting "HIGHATTCK"
# "FLOAT" - Battler can't be target of attacks with the setting "LOWATTCK"
#==============================================================================

module Atoa
  
  # Do not change or remove these lines
  Combo_List = {}
  Combo_Skill = {}
  Combo_Attacks = {}
  Combo_Attacks_Default = {}
  Combo_Command_Position = {}
  Focus_Boost = {}
  # Do not change or remove these lines
  
  # Example Advanced Settings, can be removed or changed
  Enemy_Settings[1] = ["NOCOLLAPSE","TIMEBEFOREANIM/10","FLOAT"]
  Enemy_Settings[2] = ["NOCOLLAPSE","SMALL"]
  
  Skill_Settings[129] = ["HELPDELETE","ANIME/14","TIMEAFTERANIM/6","HIGHATTCK"]
  Skill_Settings[130] = ["HELPDELETE","ANIME/13","TIMEAFTERANIM/6","LOWATTCK"]
  Skill_Settings[131] = ["HELPDELETE","ANIME/12","TIMEAFTERANIM/6"]
  Skill_Settings[132] = ["HELPDELETE","ANIME/7","TIMEAFTERANIM/6"]
  Skill_Settings[133] = ["NODAMAGE","ANIME/9","TIMEAFTERANIM/15"]
  Skill_Settings[134] = ["NODAMAGE","ANIME/9","TIMEAFTERANIM/15"]
  Skill_Settings[135] = ["NODAMAGE","ANIME/9","TIMEAFTERANIM/15"]
  
  Skill_Settings[136] = ["ANIME/15","JUMP/60","DMGBOUNCE/70","TIMEBEFOREANIM/0"]
  Skill_Settings[137] = ["NODAMAGE","ANIME/16","SEQUENCE/142","LIFT/70",
                         "MOVEPOSITION/0,0,-30,0,100","TIMEAFTERANIM/5"]
  Skill_Settings[138] = ["ANIME/19","TIMEAFTERANIM/6","DMGSHAKE/10",
                         "MOVEPOSITION/0,0,60,0,300"]
  Skill_Settings[139] = ["NODAMAGE","ANIME/21","SEQUENCE/143"]
  Skill_Settings[140] = ["ANIME/8","DMGSHAKE/10","TIMEBEFOREANIM/16","IMPACTDELAY/16"]
  Skill_Settings[141] = ["ANIME/15","JUMP/50","DMGBOUNCE/90","TIMEBEFOREANIM/0",
                         "SEQUENCE/144,145"]
  Skill_Settings[142] = ["HEAVYFALL/10","ANIME/17","TIMEBEFOREANIM/0","TIMEAFTERANIM/0",
                         "MOVEPOSITION/0,0,90,0,200","HELPHIDE"]
  Skill_Settings[143] = ["ANIME/18","HITS/2","JUMP/70","JUMPSPEED/100","TIMEBEFOREANIM/0",
                         "TIMEAFTERANIM/0","IMPACTDELAY/0","DAMAGEDELAY/0","HELPHIDE"]
  Skill_Settings[144] = ["ANIME/15","JUMP/70","DMGBOUNCE/120","TIMEBEFOREANIM/0","HELPHIDE"]
  Skill_Settings[145] = ["ANIME/15","JUMP/90","DMGBOUNCE/150","TIMEBEFOREANIM/0","HELPHIDE"]


  # Max number of attacks
  Max_Attacks = 10
  
  # Actions Base cost, sets the max width of the attack bar
  Base_Cost = 25
  
  # Rate of damage that are added to the Combo Points
  Damage_Gain_Rate = 50
  
  # ID of the skill used when learn new combos.
  # This skill is a dummied skill used only to show the animation on the user
  # So it's recomended to add the setting "NODAMAGE" and that it target's the user
  New_Combo_Skill = 133
  
  # Settings for the formula that defines the attack bar width
  # You can use script commands, to use one of the actor's stats, use "self.stat"
  Base_Bar_Formula = "75 + (self.agi / 4)"
  # The 'Status' value can be one of the following:
  #   'maxhp' = Max Hp
  #   'maxsp' = Max Sp
  #   'hp' = Current Hp
  #   'sp' = Current Sp
  #   'level' = Level
  #   'atk'  = Attack
  #   'pdef' = Physical Defense
  #   'mdef' = Magic Defense
  #   'str'  = Strength
  #   'dex'  = Dexterity
  #   'int'  = Intelligence
  #   'agi'  = Agility
  #   'eva'  = Evasion
  #   'hit'  = Hit Rate
  #   'crt'  = Critical Rate (only if using the "Add | New Status")
  #   'dmg'  = Critical Damage (only if using the "Add | New Status")
  #   'rcrt' = Critical Rate Resist (only if using the "Add | New Status")
  #   'rdmg' = Critical Damage Resist (only if using the "Add | New Status")
  #  if you create an new status on Game_Actor class, you can set them too.

  
  # Keyborard setting (don't change unless you know what you doing)
  A = Input::A  # Keyborard:Z
  B = Input::B  # Keyborard:X
  C = Input::C  # Keyborard:C
  X = Input::X  # Keyborard:A
  Y = Input::Y  # Keyborard:S
  Z = Input::Z  # Keyborard:D
  L = Input::L  # Keyborard:Q
  R = Input::R  # Keyborard:W
  UP = Input::UP
  DOWN = Input::DOWN
  LEFT = Input::LEFT
  RIGHT = Input::RIGHT
  
  # Confirm combo inpiut (recomended not use an key used for the combo input)
  Confirm_Combo = Input::C
  
  # Cancel combo inpiut (recomended not use an key used for the combo input)
  Cancel_Combo = Input::B
    
  # Default attacks settings
  # Combo_Attacks_Defualt[Key] = [Skill_ID, Gain, Cost]
  #   Key = Key used for the input
  #   Skill_ID = ID of the skill used
  #   Gain = Combo poinst gained
  #   Cost = Cost to use the attack
  Combo_Attacks_Default[UP] = [129, 3, 25]
  Combo_Attacks_Default[DOWN] = [130, 3, 25]
  Combo_Attacks_Default[LEFT] = [131, 3, 25]
  Combo_Attacks_Default[RIGHT] = [132, 3, 25]
  
  # Settings for the actors attacks
  # Combo_Attacks[Actor_ID] = {Key => [Skill_ID, Gain, Cost]}
  #   Actor_ID = ID of the actor
  #   Key = Key used for the input
  #   Skill_ID = ID of the skill used
  #   Gain = Combo poinst gained
  #   Cost = Cost to use the attack
  Combo_Attacks[12] = {UP => [129, 5, 25], DOWN => [130, 5, 25], LEFT=> [131, 5, 25],
                       RIGHT => [132, 5, 25]}
  
  # Default settings for bar increase when defending
  # It's possible to set increase values for the attack bar after the defense
  # (Like the 'Spirit' command from Legend of Legaia)
  Focus_Default_Boost = 25
  
  # Settings for bar increase when defending
  # Focus_Boost[Actor_ID] = Bonus
  #   Actor_ID = ID of the actor
  #   Bonus = Value increased
  Focus_Boost[12] = 50
  
  # Pose ID when defending
  Focus_Pose = 4
  
  # Skill Settings
  # Combo_Skill[Skill ID] = [[Key 1, Key 2,...], Type, Points, Animation]
  #   Skill_ID = Skill ID
  #   Key 1, Key 2,... = Input Sequence
  #   Type = Type of the attack, Numeric value equal 1, 2 or 3
  #     1 = Normal Combos (Arts). Are learned when the battler execute
  #        the command correctly
  #     2 = Super Combos (Super Arts). Needs to be manually learned before 
  #        they can be used, and aren't used even if the input is right before
  #        learned
  #     3 = Hyper Combos (Hyper Arts). They are used when the input is right.
  #        but aren't learned
  #   Points = Combo Points need to execute the attack.
  #   Animação = ID of the skill used before combos, only for Super Combos 
  #     and Hyper Combos. This skill is a dummied skill used only to show the 
  #     animation on the user. So it's recomended to add the setting "NODAMAGE"
  #     and that it target's the user. Can be ommited.
  Combo_Skill[136] = [[UP, DOWN, UP], 1, 15]
  Combo_Skill[137] = [[UP, LEFT, RIGHT], 1, 15]
  Combo_Skill[138] = [[DOWN, LEFT, RIGHT, LEFT], 1, 20]
  Combo_Skill[139] = [[RIGHT, DOWN, LEFT, UP], 2, 30, 134]
  Combo_Skill[140] = [[LEFT, LEFT, RIGHT, RIGHT], 2, 30, 134]
  Combo_Skill[141] = [[UP, UP, DOWN, DOWN, DOWN, UP], 3, 50, 135]
  
  # To manually teach an combo for an actor, use an 'Script Call' and add the code:
  #   add_combo(actor_id, combo_id)
  #     actor_id = Actor ID
  #     combo_id = Combo ID
  
  # List of skill allowed for each actor
  # Combo_List[Actor_ID] = [Combos]
  #    Actor_ID = Actor ID
  #    Combos = List of Combo Skill IDs
  Combo_List[12] = [136, 137, 138, 139, 140, 141]
  
  # Settings of wait time for command input if used with the 'Add | Atoa ATB'
  # If true, the time will stop for the command input, if false, the time
  # won't stop if Wait_Mode is higher than 0
  ATB_Wait = true
  
  # Configuration of the input exhibition.
  Keyboard_Type = true
  # true = keyboard exhibition (Ex.: X = keyboard X)
  # false = input exhibition (Ex.: X = keyboard A)
  
  # Show input entry with images
  Input_Images = true
  
  # Settings for comand entry images
  # The images must be on the windowsing folder.
  A_Image = 'ButonA' # Keyboard:Z
  B_Image = 'ButonB' # Keyboard:X
  C_Image = 'ButonC' # Keyboard:C
  X_Image = 'ButonX' # Keyboard:A
  Y_Image = 'ButonY' # Keyboard:S
  Z_Image = 'ButonZ' # Keyboard:D
  L_Image = 'ButonL' # Keyboard:Q
  R_Image = 'ButonR' # Keyboard:W
  UP_Image = 'ButonUP'
  DOWN_Image = 'ButonDOWN'
  LEFT_Image = 'ButonLEFT'
  RIGHT_Image = 'ButonRIGHT'
  
  #==============================================================================
  # Settings for the Input Window
  #==============================================================================

  # Input_Window_Settings = [Position X, Position Y, Opacity, Trasparent Edge]
  Input_Window_Settings = [32, 256, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Input_Window_Bg = ''
 
  # Position of the backgroun image
  # Input_Window_Bg_Postion = [Position X, Position Y]
  Input_Window_Bg_Postion = [0 , 0]

  #==============================================================================
  # Settings for the Combo List Window
  #==============================================================================

  # Change combo list page (recomended not use an key used for the combo input)
  Change_Next_Page = Input::R
  Change_Previous_Page = Input::L
  
  # Message shown on the combo list window
  Combo_Window_Message = "Combo List. Q or W: Change Page"
  
  # Combo_Window_Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Combo_Window_Settings = [320, 0, 320, 320, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Combo_Window_Bg = ''
 
  # Position of the backgroun image
  # Combo_Window_Bg_Postion = [Position X, Position Y]
  Combo_Window_Bg_Postion = [0 , 0]

  #==============================================================================
  # Settings for the Combo Points Window
  #==============================================================================

  # Point_Window_Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Point_Window_Settings = [80, 160, 172, 64, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Point_Window_Bg = ''
 
  # Position of the backgroun image
  # Point_Window_Bg_Postion = [Position X, Position Y]
  Point_Window_Bg_Postion = [0 , 0]
  
  # Show Combo Point Bar
  Show_Point_Bar = true
  
  # Bar position Adjust
  # Combo_Points_Pos_Adjust = [Position X, Position Y]
  Combo_Points_Pos_Adjust = [0, 0]
  
  # Name of the Combo Point stat.
  Combo_Points_Name = "AP"
  
  # Image filename for the bar, must be on the Windowskin folder
  Combo_Points_Meter = "APMeter"
  
  #==============================================================================
  # Settings for the Avaliable Commands List
  #==============================================================================

  # Combo_Cmd_Window_Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Combo_Cmd_Window_Settings = [112, 32, 96, 96, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Combo_Cmd_Window_Bg = ''
 
  # Position of the backgroun image
  # Combo_Cmd_Window_Bg_Postion = [Position X, Position Y]
  Combo_Cmd_Window_Bg_Postion = [0 , 0]
  
  # Position of the input display on the windows.
  # Combo_Attacks_Position[Key] = [Position X, Position Y]
  Combo_Command_Position[UP] = [21, 0]
  Combo_Command_Position[DOWN] = [21, 45]
  Combo_Command_Position[LEFT] = [0, 22]
  Combo_Command_Position[RIGHT] = [42, 22]

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Legaia Battle'] = true

#==============================================================================
# ** Input
#--------------------------------------------------------------------------
# Module that handles keyboard input
#==============================================================================

module Input
  #--------------------------------------------------------------------------
  # * Check invalid key
  #    num : key
  #--------------------------------------------------------------------------
  def n_trigger?(num)
    if trigger?(num)
      return false
    elsif trigger?(A) or trigger?(B) or trigger?(C) or
          trigger?(X) or trigger?(Y) or trigger?(Z) or
          trigger?(L) or trigger?(R) or
          trigger?(UP) or trigger?(DOWN) or trigger?(RIGHT) or trigger?(LEFT)
        return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Key text converter
  #     key : key
  #--------------------------------------------------------------------------
  def key_converter(key)
    if Atoa::Keyboard_Type
      case key
      when A then return 'A'
      when B then return 'B'
      when C then return 'C'
      when X then return 'X'
      when Y then return 'Y'
      when Z then return 'Z'
      when L then return 'R'
      when R then return 'L'
      end
    else
      case key
      when A then return 'Z'
      when B then return 'X'
      when C then return 'C'
      when X then return 'D'
      when Y then return 'S'
      when Z then return 'A'
      when L then return 'Q'
      when R then return 'W'
      end
    end
    case key
    when UP then return '↑'
    when DOWN then return '↓'
    when LEFT then return '←'
    when RIGHT then return '→'
    end
  end
  #--------------------------------------------------------------------------
  # * Key Image
  #     key : key
  #--------------------------------------------------------------------------
  def key_image(key)
    case key
    when A then return Atoa::A_Image
    when B then return Atoa::B_Image
    when C then return Atoa::C_Image
    when X then return Atoa::X_Image
    when Y then return Atoa::Y_Image
    when Z then return Atoa::Z_Image
    when L then return Atoa::L_Image
    when R then return Atoa::R_Image
    when UP then return Atoa::UP_Image
    when DOWN then return Atoa::DOWN_Image
    when LEFT then return Atoa::LEFT_Image
    when RIGHT then return Atoa::RIGHT_Image
    end
  end
  #--------------------------------------------------------------------------
  # * Creates module functions for the named methods
  #--------------------------------------------------------------------------
  module_function :n_trigger?
  module_function :key_converter
  module_function :key_image
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :combo_points
  attr_accessor :combo_size
  attr_accessor :base_size
  attr_accessor :ext_size
  attr_accessor :learned_combo
  attr_accessor :combo_sequence
  attr_accessor :focus_bonus
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_legaia initialize
  def initialize
    initialize_legaia
    @combo_points = 0
    @combo_size = 0
    @base_size = 0
    @ext_size = 0
    @learned_combo = []
    @combo_sequence = []
    @focus_bonus = false
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_legaia set_damage
  def set_damage(user, action = nil)
    set_damage_legaia(user, action)
    if (check_include(action, 'HIGHATTCK') and check_include(self, 'SMALL')) or
       (check_include(action, 'LOWATTCK') and check_include(self, 'FLOAT'))
      user.target_damage[self] = ''
    end
    if self.actor? and user.target_damage[self].numeric?
      self.combo_points +=  user.target_damage[self] * Damage_Gain_Rate / self.maxhp
    end
  end
  #--------------------------------------------------------------------------
  # * Set combo points
  #     n : new value
  #--------------------------------------------------------------------------
  def combo_points=(n)
    @combo_points = [[n, 0].max, 100].min
  end
  #--------------------------------------------------------------------------
  # * Get Bar size
  #--------------------------------------------------------------------------
  def bar_size
    return [[base_size + ext_size, 1].max, Max_Attacks * Base_Cost].min
  end
  #--------------------------------------------------------------------------
  # * Set combo bar base size
  #--------------------------------------------------------------------------
  def base_size
    @base_size = eval(Base_Bar_Formula) 
  end
  #--------------------------------------------------------------------------
  # * Set combo bar extra size
  #--------------------------------------------------------------------------
  def ext_size
    bonus = Focus_Boost[self.id].nil? ? Focus_Default_Boost : Focus_Boost[self.id] 
    @ext_size = @focus_bonus ? bonus : 0
  end
  #--------------------------------------------------------------------------
  # * Get combo cost
  #--------------------------------------------------------------------------
  def combo_current_cost
    value = 0
    for key in @combo_sequence
      value += battler_combo[key][2]
    end
    return value
  end
  #--------------------------------------------------------------------------
  # * Get combo next cost
  #--------------------------------------------------------------------------
  def combo_next_cost(key)
    return combo_current_cost + battler_combo[key][2]
  end
  #--------------------------------------------------------------------------
  # * Ger battler combos
  #--------------------------------------------------------------------------
  def battler_combo
    return (Combo_Attacks[self.id].nil? ? Combo_Attacks_Default : Combo_Attacks[self.id])
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Combo Points
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_combo_points(actor, x, y)
    if Show_Point_Bar
      bar_x = Combo_Points_Pos_Adjust[0] + x
      bar_y = Combo_Points_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
      @skin = RPG::Cache.windowskin(Combo_Points_Meter)
      @width  = @skin.width
      @height = @skin.height / 3
      src_rect = Rect.new(0, 0, @width, @height)
      self.contents.blt(bar_x, bar_y, @skin, src_rect)    
      @line   = (actor.combo_points == 100 ? 2 : 1)
      @amount = actor.combo_points.to_f / 100
      src_rect2 = Rect.new(0, @line * @height, @width * @amount, @height)
      self.contents.blt(bar_x, bar_y, @skin, src_rect2)
    end
    self.contents.draw_text(x + 32, y, 64, 32, Combo_Points_Name)
    self.contents.draw_text(x + 0, y, 108, 32, actor.combo_points.to_s, 2)
  end
end

#==============================================================================
# ** Window_InputCommand
#------------------------------------------------------------------------------
#  This window shows the command input
#==============================================================================

class Window_InputCommand < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :skill
  attr_reader :commands
  attr_reader :actor
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(Input_Window_Settings[0], Input_Window_Settings[1], actor.bar_size + 32, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4000
    if Input_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Input_Window_Bg)
      @background_image.x = self.x + Input_Window_Bg_Postion[0]
      @background_image.y = self.y + Input_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    self.back_opacity = Input_Window_Settings[2]
    self.opacity = Input_Window_Settings[2] if Input_Window_Settings[3] 
    @actor = actor
    create_input_images if Input_Images
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@actor.combo_sequence.size
      draw_key(i, @actor.combo_sequence[i])
    end
  end
  #--------------------------------------------------------------------------
  # * Creat input imagez
  #--------------------------------------------------------------------------
  def create_input_images
    images = [A_Image, B_Image, C_Image, X_Image, Y_Image, Z_Image, L_Image,
              R_Image, UP_Image, DOWN_Image, LEFT_Image, RIGHT_Image]
    @images_bitmaps = {}
    for img in images
      @images_bitmaps[img] = RPG::Cache.windowskin(img)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Key
  #     index : index
  #     key   : key
  #--------------------------------------------------------------------------
  def draw_key(index, key)
    x = index * @actor.battler_combo[key][2]
    if Input_Images
      bitmap = @images_bitmaps[Input.key_image(key)]
      self.contents.blt(x, 4, bitmap, Rect.new(0, 0, 24, 24))
    else
      self.contents.draw_text(x + 8, 0, 24, 32, Input.key_converter(key))
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    if Input_Images
      for img in @images_bitmaps.keys
        @images_bitmaps[img].dispose if img != nil
      end
    end
  end
end

#==============================================================================
# ** Window_ComboList
#------------------------------------------------------------------------------
#  This window shows the combo list
#==============================================================================

class Window_ComboList < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :combo_page
  attr_accessor :max_size
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(Combo_Window_Settings[0], Combo_Window_Settings[1], Combo_Window_Settings[2], Combo_Window_Settings[3])
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4000
    @combo_page = 0
    @max_size = ((self.width - 32) / 52).to_i
    if Combo_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Combo_Window_Bg)
      @background_image.x = self.x + Combo_Window_Bg_Postion[0]
      @background_image.y = self.y + Combo_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    self.back_opacity = Combo_Window_Settings[4]
    self.opacity = Combo_Window_Settings[4] if Combo_Window_Settings[5] 
    @actor = actor
    create_input_images if Input_Images
    refresh
  end
  #--------------------------------------------------------------------------
  # * Creat input imagez
  #--------------------------------------------------------------------------
  def create_input_images
    images = [A_Image, B_Image, C_Image, X_Image, Y_Image, Z_Image, L_Image,
              R_Image, UP_Image, DOWN_Image, LEFT_Image, RIGHT_Image]
    @images_bitmaps = {}
    for img in images
      @images_bitmaps[img] = RPG::Cache.windowskin(img)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, width - 32, 32, Combo_Window_Message, 1)
    @actor.learned_combo.sort!
    current_page = @combo_page * @max_size
    for index in current_page...([current_page + @max_size, @actor.learned_combo.size].min)
      skill = @actor.learned_combo[index]
      next if Combo_Skill[skill].nil?
      draw_skill_name(index, skill)
      for key in 0...Combo_Skill[skill][0].size
        draw_key(index, skill, key, Combo_Skill[skill][0][key])
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Key
  #     index : index
  #     key   : key
  #--------------------------------------------------------------------------
  def draw_key(index, skill, key, input)
    x = (width / 2) - (Combo_Skill[skill][0].size * Base_Cost / 2) - 16 + key * @actor.battler_combo[input][2]
    if Input_Images
      bitmap = @images_bitmaps[Input.key_image(input)]
      self.contents.blt(x, ((index % @max_size)  * 52) + 60, bitmap, Rect.new(0, 0, 24, 24))
    else
      self.contents.draw_text(x, ((index % @max_size) * 52) + 56, 24, 32, Input.key_converter(input))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Name
  #     index : item number
  #     id    : item ID
  #--------------------------------------------------------------------------
  def draw_skill_name(index, id)
    skill = $data_skills[id]
    y = (index % @max_size) * 52
    bitmap = RPG::Cache.icon(skill.icon_name)
    self.contents.blt(0, y + 36, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(28, y + 32, width, 32, skill.name, 0)
    self.contents.draw_text(width - 112, y + 32, 48, 32, Combo_Points_Name)
    self.contents.draw_text(width - 64, y + 32, 48, 32, Combo_Skill[id][2].to_s)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    if Input_Images
      for img in @images_bitmaps.keys
        @images_bitmaps[img].dispose if img != nil
      end
    end
  end
end

#==============================================================================
# ** Window_PointsShow
#------------------------------------------------------------------------------
#  This window shows points to be used in combos
#==============================================================================

class Window_PointsShow < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(Point_Window_Settings[0], Point_Window_Settings[1], Point_Window_Settings[2], Point_Window_Settings[3])
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4000
    if Point_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Point_Window_Bg)
      @background_image.x = self.x + Point_Window_Bg_Postion[0]
      @background_image.y = self.y + Point_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    self.back_opacity = Point_Window_Settings[4]
    self.opacity = Point_Window_Settings[4] if Point_Window_Settings[5] 
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_combo_points(@actor, 0, 0)
  end
end

#==============================================================================
# ** Window_ComboCommands
#------------------------------------------------------------------------------
#  This window shows the inputs available
#==============================================================================

class Window_ComboCommands < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(Combo_Cmd_Window_Settings[0], Combo_Cmd_Window_Settings[1], Combo_Cmd_Window_Settings[2], Combo_Cmd_Window_Settings[3])
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4000
    if Combo_Cmd_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Combo_Cmd_Window_Bg)
      @background_image.x = self.x + Combo_Cmd_Window_Bg_Postion[0]
      @background_image.y = self.y + Combo_Cmd_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    self.back_opacity = Combo_Cmd_Window_Settings[4]
    self.opacity = Combo_Cmd_Window_Settings[4] if Combo_Cmd_Window_Settings[5] 
    @actor = actor
    create_input_images if Input_Images
    refresh
  end
  #--------------------------------------------------------------------------
  # * Creat input imagez
  #--------------------------------------------------------------------------
  def create_input_images
    images = [A_Image, B_Image, C_Image, X_Image, Y_Image, Z_Image, L_Image,
              R_Image, UP_Image, DOWN_Image, LEFT_Image, RIGHT_Image]
    @images_bitmaps = {}
    for img in images
      @images_bitmaps[img] = RPG::Cache.windowskin(img)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for key in Combo_Command_Position.keys
      draw_key(key)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Key
  #     key   : key
  #--------------------------------------------------------------------------
  def draw_key(key)
    x = Combo_Command_Position[key][0]
    y = Combo_Command_Position[key][1]
    if Input_Images
      bitmap = @images_bitmaps[Input.key_image(key)]
      self.contents.blt(x, y, bitmap, Rect.new(0, 0, 24, 24))
    else
      self.contents.draw_text(x, y, 24, 32, Input.key_converter(key))
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    if Input_Images
      for img in @images_bitmaps.keys
        @images_bitmaps[img].dispose if img != nil
      end
    end
  end
end

#==============================================================================
# ** Window_ComboMenu
#------------------------------------------------------------------------------
#  This window shows the list of combos
#==============================================================================

class Window_ComboMenu < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 128, 640, 352)
    @actor = actor
    @column_max = 2
    create_input_images if Input_Images
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Acquiring Skill
  #--------------------------------------------------------------------------
  def skill
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.skill == nil ? "" : self.skill.description)
  end
  #--------------------------------------------------------------------------
  # * Creat input imagez
  #--------------------------------------------------------------------------
  def create_input_images
    images = [A_Image, B_Image, C_Image, X_Image, Y_Image, Z_Image, L_Image,
              R_Image, UP_Image, DOWN_Image, LEFT_Image, RIGHT_Image]
    @images_bitmaps = {}
    for img in images
      @images_bitmaps[img] = RPG::Cache.windowskin(img)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    @actor.learned_combo.sort!
    for index in 0...@actor.learned_combo.size
      skill = @actor.learned_combo[index]
      next if Combo_Skill[skill].nil? or $data_skills[skill].nil?
      @data.push($data_skills[skill])
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 52)
      for index in 0...@actor.learned_combo.size
        skill = @actor.learned_combo[index]
        next if Combo_Skill[skill].nil?
        draw_skill_name(index, skill)
        for key in 0...Combo_Skill[skill][0].size
          draw_key(index, skill, key, Combo_Skill[skill][0][key])
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Key
  #     index : index
  #     key   : key
  #--------------------------------------------------------------------------
  def draw_key(index, skill, key, input)
    x = (4 + index % 2 * (288 + 32)) + (width / (2 * @column_max)) - (Combo_Skill[skill][0].size * Base_Cost / 2) - 16 + key * @actor.battler_combo[input][2]
    if Input_Images
      bitmap = @images_bitmaps[Input.key_image(input)]
      self.contents.blt(x, (index / 2 * 52) + 32, bitmap, Rect.new(0, 0, 24, 24))
    else
      self.contents.draw_text(x, (index / 2 * 52) + 28, 24, 32, Input.key_converter(input))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Name
  #     index : item number
  #     id    : item ID
  #--------------------------------------------------------------------------
  def draw_skill_name(index, id)
    skill = $data_skills[id]
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 52
    bitmap = RPG::Cache.icon(skill.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, width, 32, skill.name, 0)
    self.contents.draw_text(x + (width / @column_max) - 112, y, 48, 32, Combo_Points_Name)
    self.contents.draw_text(x + (width / @column_max) - 64, y, 48, 32, Combo_Skill[id][2].to_s)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #---------------------------------------------------------------------------
  def update_cursor_rect
    return self.cursor_rect.empty if @index < 0
    row = @index / @column_max
    self.top_row = row if row < self.top_row
    self.top_row = row - (self.page_row_max - 1) if row > self.top_row + (self.page_row_max - 1)
    cursor_width = self.width / @column_max - 32
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 52 - self.oy
    self.cursor_rect.set(x, y, cursor_width, 52)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    if Input_Images
      for img in @images_bitmaps.keys
        @images_bitmaps[img].dispose if img != nil
      end
    end
    @background_image.dispose if @background_image != nil
  end
end

#==============================================================================
# ** Interpreter
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # * Add combo to the actor combo list
  #     actor_id : actor ID
  #     combo_id : combo ID
  #--------------------------------------------------------------------------
  def add_combo(actor_id, combo_id)
    $game_actors[actor_id].learned_combo << combo_id
    $game_actors[actor_id].learned_combo.sort!
    $game_actors[actor_id].learned_combo.uniq!
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias start_legaia start
  def start
    reset_focus_bonus
    start_legaia
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_legaia terminate
  def terminate
    reset_focus_bonus
    dispose_combo_windows
    terminate_legaia
  end
  #--------------------------------------------------------------------------
  # * Clear focus bonus
  #--------------------------------------------------------------------------
  def reset_focus_bonus
    for id in 1...$data_actors.size
      $game_actors[id].focus_bonus = false
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_legaia phase3_setup_command_window
  def phase3_setup_command_window
    @active_battler.combo_sequence.clear
    dispose_combo_windows if @combo_input_window != nil
    phase3_setup_command_window_legaia
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase)
  #--------------------------------------------------------------------------
  alias update_phase3_legaia update_phase3
  def update_phase3
    if @combo_input_window != nil and @combo_input_window.visible
      update_combo_input
      return
    end
    update_phase3_legaia
  end
  #--------------------------------------------------------------------------
  # * Confirm Attack Selection
  #--------------------------------------------------------------------------
  def confirm_attack_select
    $game_system.se_play($data_system.decision_se)
    @active_battler.current_action.kind = 0
    @active_battler.current_action.basic = 0
    @actor_command_window.active = false
    @actor_command_window.visible = false
    start_combo_input
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  alias phase3_next_actor_legaia phase3_next_actor
  def phase3_next_actor
    dispose_combo_windows if @combo_input_window != nil
    phase3_next_actor_legaia
  end
  #--------------------------------------------------------------------------
  # * End Enemy Selection
  #--------------------------------------------------------------------------
  def end_enemy_select
    update_temp_info if $atoa_script['Atoa CTB']
    @enemy_arrow.dispose
    @enemy_arrow = nil
    if @actor_command_window.commands[@actor_command_window.index] == $data_system.words.attack
      start_combo_input
      @help_window.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # * Set Defense Action
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_guard_action_legaia set_guard_action
  def set_guard_action(battler)
    if battler.actor?
      battler.movement = battler.step_foward = false
      text = Guard_Message.dup
      text.gsub!(/{battler_name}/i) {"#{battler.name}"}
      @help_window.set_text(text, 1, battler)
      battler.action_done = true
      battler.move_pose = false
      battler.idle_pose = false
      battler.focus_bonus = true
      battler.pose_id = @spriteset.battler(battler).set_idle_pose
      @spriteset.battler(battler).update_pose
      battler.pose_id = @spriteset.battler(battler).set_pose_id('Focus')
      pose_wait = @spriteset.battler(battler).battler_pose(battler.pose_id)
      battler.combo_points += Focus_Boost[battler.id].nil? ? Focus_Default_Boost : Focus_Boost[battler.id]
      battle_cry_basic(battler, 'DEFENSE')
      return @wait_all = 10 + battle_speed * 2 if pose_wait.nil?
      battler_pose_wait = check_wait_time(pose_wait[0] * pose_wait[1], battler, 'TIMEBEFOREANIM/')
      @wait_all = battler_pose_wait + battle_speed * 2
    else
      set_guard_action_legaia(battler)
    end
  end  
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_legaia step2_part1
  def step2_part1(battler)
    battler.focus_bonus = false
    step2_part1_legaia(battler)
  end
  #--------------------------------------------------------------------------
  # * Set hit number
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_hit_number_legaia set_hit_number
  def set_hit_number(battler)
    if battler.attack? and battler.actor?
      battler.current_action.action_sequence = set_combo_sequences(battler)
      set_first_sequence(battler)
    else
      set_hit_number_legaia(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set first sequence
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_first_sequence(battler)
    next_skill = battler.current_action.action_sequence.shift
    return if next_skill.nil?
    battler.current_action.skill_id = next_skill
    battler.current_action.kind = 1
    battler.current_skill = $data_skills[battler.current_action.skill_id]
    battler.current_action.action_sequence.unshift(action_sequences(battler, battler.current_skill))
    battler.current_action.action_sequence.flatten!
    battler.current_action.hit_times = action_hits(battler)
    battler.current_action.combo_times = action_combo(battler)
    set_action_help(battler.current_skill, battler)
    @help_window.visible = false if check_include(battler.current_skill, 'HELPDELETE')
  end
  #--------------------------------------------------------------------------
  # * Wait flag (for the Add | Atoa ATB and Add | Atoa CTB)
  #--------------------------------------------------------------------------
  alias wait_on_legaia wait_on if $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
  def wait_on
    return true if $atoa_script['Atoa ATB'] and ATB_Wait and @combo_input_window != nil
    return wait_on_legaia
  end
  #--------------------------------------------------------------------------
  # * Get combo sequence
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_combo_sequences(battler)
    sequence = []
    size = battler.combo_sequence.size
    for i in 0...size
      attack = battler.battler_combo[battler.combo_sequence[i]]
      combo = combo_check(battler, attack, i)
      sequence << (combo.nil? ? attack.first : combo)
    end
    sequence.flatten!
    return sequence
  end
  #--------------------------------------------------------------------------
  # * Get combo
  #     battler : battler
  #     attack  : current attack
  #     index   : index
  #--------------------------------------------------------------------------
  def combo_check(battler, attack, index)
    size = battler.combo_sequence.size
    for value in 0...index
      combo = combo_match(battler.combo_sequence[value..index], battler)
      return combo if combo != nil
    end
    battler.combo_points += attack[1]
    return nil
  end
  #--------------------------------------------------------------------------
  # * Check Combo Match
  #     combo   : attack lists
  #     battler : battler 
  #--------------------------------------------------------------------------
  def combo_match(combo, battler)
    for id in Combo_Skill.keys
      if Combo_Skill[id][0] == combo and battler.combo_points >= Combo_Skill[id][2] and
         (Combo_List[battler.id] != nil and Combo_List[battler.id].include?(id))
        if not battler.learned_combo.include?(id) and Combo_Skill[id][1] == 1
          battler.combo_points -= Combo_Skill[id][2]
          battler.learned_combo << id
          return [New_Combo_Skill , id]
        elsif (battler.learned_combo.include?(id) and Combo_Skill[id][1] == 2) or
           Combo_Skill[id][1] == 3
          battler.combo_points -= Combo_Skill[id][2]
          return Combo_Skill[id][3].nil? ? id : [Combo_Skill[id][3] , id]
        elsif battler.learned_combo.include?(id) and Combo_Skill[id][1] == 1
          battler.combo_points -= Combo_Skill[id][2]
          return id
        end
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Start combo input
  #--------------------------------------------------------------------------
  def start_combo_input
    @combo_input_window = Window_InputCommand.new(@active_battler)
    @combo_list_window = Window_ComboList.new(@active_battler)
    @combo_points_window = Window_PointsShow.new(@active_battler)
    @combo_commands_window = Window_ComboCommands.new(@active_battler)
  end
  #--------------------------------------------------------------------------
  # * Update combo input
  #--------------------------------------------------------------------------
  def update_combo_input
    if Input.trigger?(Confirm_Combo) 
      if @active_battler.combo_sequence.size > 0
        start_combo_target
        $game_system.se_play($data_system.decision_se)
      else
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    elsif Input.trigger?(Cancel_Combo)
      if @active_battler.combo_sequence.size == 0
        @active_battler.combo_sequence.clear
        @actor_command_window.active = true
        @actor_command_window.visible = true
        dispose_combo_windows
      else
        @active_battler.combo_sequence.pop
        @combo_input_window.refresh
      end
      $game_system.se_play($data_system.cancel_se)
      return
    elsif Input.trigger?(Change_Next_Page)
      page_size = (@combo_list_window.combo_page + 1) * @combo_list_window.max_size
      if page_size < @active_battler.learned_combo.size
        $game_system.se_play($data_system.cursor_se)
        @combo_list_window.combo_page += 1
      else
        $game_system.se_play($data_system.cursor_se)
        @combo_list_window.combo_page = 0
      end
      @combo_list_window.refresh
      return
    elsif Input.trigger?(Change_Previous_Page)
      if @combo_list_window.combo_page == 0
        $game_system.se_play($data_system.cursor_se)
        last_page = (@active_battler.learned_combo.size / @combo_list_window.max_size).to_i
        @combo_list_window.combo_page = last_page
      else
        $game_system.se_play($data_system.cursor_se)
        @combo_list_window.combo_page -= 1
      end
      @combo_list_window.refresh
      return
    end
    for key in [A, B, C, X, Y, Z, L, R, UP, DOWN, LEFT, RIGHT]
      if Input.trigger?(key) and @active_battler.battler_combo[key] != nil
        if @active_battler.combo_next_cost(key) <= @active_battler.bar_size
          @active_battler.combo_sequence << key
          @combo_input_window.refresh
          $game_system.se_play($data_system.cursor_se)
        else
          $game_system.se_play($data_system.buzzer_se)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Start combo target
  #--------------------------------------------------------------------------
  def start_combo_target
    @combo_input_window.visible = false
    @combo_list_window.visible = false
    @combo_points_window.visible = false
    @combo_commands_window.visible = false
    start_enemy_select
  end
  #--------------------------------------------------------------------------
  # * Dispose combo windows
  #--------------------------------------------------------------------------
  def dispose_combo_windows
    @combo_input_window.dispose if @combo_input_window != nil
    @combo_list_window.dispose if @combo_list_window != nil
    @combo_points_window.dispose if @combo_points_window != nil
    @combo_commands_window.dispose if @combo_commands_window != nil
    @combo_input_window = nil
    @combo_list_window = nil
    @combo_points_window = nil
    @combo_commands_window = nil
  end
end

#==============================================================================
# ** Scene_Combo
#------------------------------------------------------------------------------
#  This class performs combo screen processing.
#==============================================================================

class Scene_Combo
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0)
    @actor_index = actor_index
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @actor = $game_party.actors[@actor_index]
    @help_window = Window_Help.new
    @skill_window = Window_ComboMenu.new(@actor)
    @status_window = Window_SkillStatus.new(@actor)
    @skill_window.help_window = @help_window
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
    Graphics.freeze
    @help_window.dispose
    @skill_window.dispose
    @status_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @status_window.update
    @help_window.update
    @skill_window.update
    update_skill
  end
  #--------------------------------------------------------------------------
  # * Return Scene
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # * Frame Update (if skill window is active)
  #--------------------------------------------------------------------------
  def update_skill
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      return_scene
      return
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Combo.new(@actor_index)
      return
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Combo.new(@actor_index)
      return
    end
  end
end