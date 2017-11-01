#==============================================================================
# Bestiary
# by Atoa
#==============================================================================
# This script adds an monster book to your game.
#
# This bestary has some unique features:
# - Animated battler graphic in the bestiary
# - Shows Multi drop items and Steal Items
# - Elemental resist table
# - Show enemy Description text
# 
# To open the Bestiary, you must make an Script Call and add the comand:
# $scene = Scene_Bestiary.new
#
# Adding monster to bestiary via events:
# To add monster via events,  you must make an Script Call and add the comand:
# $game_party.add_enemy_info(Enemy_ID, type)
# Enemy_ID = Enemy ID in the database
# type = an integer between 0 and 4
#  0 = remove the enemy from the bestiary
#  1 = adds enemies hidding items droped and stole
#  2 = adds enemies showing all drop items, but not steal items
#  3 = adds enemies showing all steal items, but not drop items
#  4 = adds enemies showing all drop and steal items
#
# E.g.: $game_party.add_enemy_info(12, 3)
# It will add the enemy ID 12 to de bestiary, showing all steal items.
#
# Elemental Resistance Icons:
# Only Elements with icons will be shown on the resistance table.
# The icons file must have the same name as the element + '_elm'
# E.g.: Fire element must have an icon named 'Fire_elm'
#==============================================================================

module Atoa
  # Do not remove or change this line
  Enemy_Info = {}
  # Do not remove or change this line
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # BESTIARY CONFIGURATION
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  # Show Description? true = show / false = don't show
  Show_Description = true
 
  # Show Drop Items? true = show / false = don't show
  Show_Drops = true

  # Show Steal Items? true = show / false = don't show
  Show_Steal = true

  # Show items droped only after you drop them?
  Need_Drop = true
  # true = the item will only be shown once the monster droped one
  # false = all drop items will allways be shown

  # Show items steal only after you drop them?
  Need_Steal = true
  # true = the item will only be shown once you stole it
  # false = all steal items will allways be shown

  # Don't add enemies to the bestiary in battle?
  Dont_add_enemies_in_battle = false
  # true = enemies won't be added to bestiary in battle, so you must add them
  #        via script call (useful if you want an monster book that's is filled
  #        by using items or other ways)
  # false = Enemies will be added to the bestiary once you fight and win a battle
  
  # Direction of the battlers on the bestiary
  Bestiary_Battler_Direction = 6
  # 2 = battler faces down
  # 4 = battler faces left
  # 6 = battler faces right
  # 8 = battler faces up
  
  # Completion Visualization Mode
  Show_Amount = 3
  # 0 = Don't show value
  # 1 = The value will be shown as Real Numbers
  # 2 = The value will be shown as %
  # 3 = The value will be shown as % and Real Numbers
  
  # Position of the Enemies Status Text
  Status_Text_Position = 224
  
  # Distance between the status text and the numeric value
  Status_Text_Distance = 96
  
  # Position X of the elements resistance
  Element_Position = 178
  
  # Max number of elements shown in a column, max value = 8
  Max_Elements_Shown = 8
  
  # Exhibition of elemental resistance
  Element_Resists_Exhibition = 0
  # 0 = custom exhibition
  # 1 = exhibition by numbers, value shows target resistance
  # 2 = exhibition by numbers, value damage multiplication
 
  # Elemental resist text if 'Element_Resists_Exhibition = 0'
  Element_Resist_Text = ['Weakest','Weak','Normal','Resist','Imune','Absorb']

  # Configuration of the elemental resist text color
  #                         red blue green
  Weakest_Color = Color.new(255,   0,   0)
  Weak_Color    = Color.new(255, 128,  64)
  Neutral_Color = Color.new(255, 255, 255)
  Resist_Color  = Color.new(  0, 128, 255)
  Imune_Color   = Color.new(  0, 255, 255)
  Absorb_Color  = Color.new(  0, 255,   0)
  
  # Drop Items Message
  Drop_Message = 'Drop Items:'
  
  #Steal Items Message
  Steal_Message = 'Steal Items:'

  # Help Message
  Help_Message = 'Monster Book'
  
  # Name of the Exp status on the bestiary
  Exp_Text_Bestiary  = 'Exp'
  
  # Icon file name for money
  Gold_Icon = '034-Item03'
  
  # Window Opacity
  Windows_Opacity = 255
  Windows_Back_Opacity = 255
  
  # Show map in background? true = show / false = don't show
  Show_Map = false
  
  # IDs of the enemies that will never be shown in the bestiary
  Never_Show = [] 
  
  # Set Bestiary Windowskin.
  # Add here the file name of the windowskin.
  # if the value = nil, the current defalut windowskin will be used
  Bestiary_Window1 = nil
  Bestiary_Window2 = '001-Blue01'
  Bestiary_Window3 = '001-Blue01'
  
  # Background image
  # If you want to use your own backgruon image, add the filename here.
  # the graphic must be on the Windowskin folder.
  # if the value = nil, no image will be used.
  # Remember to reduce the window transparency.
  Back_Image = nil
  
  # Defaut Message for enemies without description
  No_Enemy_Info = ''
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # BESTIARY ENEMY DESCRIPTION CONFIG
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Enemy_Info[ID] = ['This is an Enemy description example',
  #                  'Text in different lines must be separated', 
  #                  'by comas']
  #
  Enemy_Info[1] = ['Oh my god! An scary ghost!',
                   'Runz to the hills! Or it will eat ya!']

  Enemy_Info[2] = ['Squishy! Squishy!',
                   "Isn't this thing too strong for an",
                   'simply jelly?']

  Enemy_Info[3] = ['An demon born from hell, that will',
                   'sent you to hell, to show how hell',
                   'can be a hell']

  Enemy_Info[4] = ['An guy with an spiky and dangerous',
                   "hair, you won't want to know what",
                   'lotion he uses...']

  Enemy_Info[5] = ['An cool charater to show how',
                   'you can use CCOA style battlers']

  Enemy_Info[6] = ['Another cool charater to show how',
                   'you can use CCOA style battlers']

  Enemy_Info[9] = ["Looks! It's Arshes!",
                   'Well this is just an example of how',
                   'you can use imobile battlers.',
                   "But i hope you don't use default RMXP",
                   'Battlers with sideview systems...']
                   
  Enemy_Info[10] = ['And here is Basil!',
                   'Just another example of how',
                   'you can use imobile battlers.']
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Bestiary'] = true

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy_bestiary_data
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias atoa_bestiary_initialize initialize
  def initialize
    atoa_bestiary_initialize
    @enemy_bestiary_data = Data_Bestiary.new
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Set multi drop items
  #--------------------------------------------------------------------------
  alias atoa_bestiary_multi_drops multi_drops
  def multi_drops
    drops = atoa_bestiary_multi_drops
    for item in drops
      $game_party.droped_items(@enemy_id, item)
    end
    return drops
  end
  #--------------------------------------------------------------------------
  # * Set steal items
  #     user : user
  #     ext  : steal action extensio
  #--------------------------------------------------------------------------
  alias atoa_bestiary_stole_item_set stole_item_set
  def stole_item_set(user, ext)
    steal = atoa_bestiary_stole_item_set(user, ext)
    unless steal.nil? or steal == false
      $game_party.stole_items(self.id, steal)
    end
    return steal
  end
end

#==============================================================================
# ** Game_Enemy_Bestiary 
#------------------------------------------------------------------------------
#  This class handles enemies shown on the bestiary
#==============================================================================

class Game_Enemy_Bestiary < Game_Enemy
  #--------------------------------------------------------------------------
  # * Set initial position
  #--------------------------------------------------------------------------
  def battler_position_setup
    @base_x = @original_x = @actual_x = @target_x = @initial_x = @hit_x = @damage_x = 100
    @base_y = @original_y = @actual_y = @target_y = @initial_y = @hit_y = @damage_y = 200
  end
end

#==============================================================================
# ** Sprite_Battler_Bestiary
#------------------------------------------------------------------------------
#  This sprite is used to display the battler on the bestiary
#==============================================================================

class Sprite_Battler_Bestiary < Sprite_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #     battler  : battler (Game_Battler)
  #     show     : show battler
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil, show = false)
    super(viewport, battler)
    @show = show
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    unless @show
      self.opacity = 0 
      @shadow.opacity = 0 if @shadow != nil
    end
  end
  #--------------------------------------------------------------------------
  # * Set default battler direction
  #--------------------------------------------------------------------------
  def default_battler_direction
    @battler.direction = Bestiary_Battler_Direction
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy_info 
  attr_accessor :enemy_droped_items
  attr_accessor :enemy_stole_items
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias atoa_bestiary_initialize initialize
  def initialize
    atoa_bestiary_initialize
    @enemy_info = {} if @enemy_info.nil?
    @enemy_stole_items = {} if @enemy_stole_items.nil?
    @enemy_droped_items = {} if @enemy_droped_items.nil?
  end
  #--------------------------------------------------------------------------
  # * Add Enemy Info
  #     enemy_id : enemy ID
  #     type     : show type
  #--------------------------------------------------------------------------
  def add_enemy_info(enemy_id, type = 1)
    @enemy_info[enemy_id] = type
  end
  #--------------------------------------------------------------------------
  # * Get max bestiary entries
  #--------------------------------------------------------------------------
  def enemy_bestiary_max
    return $game_temp.enemy_bestiary_data.id_data.size - 1
  end
  #--------------------------------------------------------------------------
  # * Get current bestiary entries
  #--------------------------------------------------------------------------
  def enemy_bestiary_now
    new_enemy_info = []
    for info in @enemy_info
      enemy = $data_enemies[info[0]]
      next if enemy.name == '' or Never_Show.include?(enemy.id) or info[1] == 0
      new_enemy_info << enemy.id
    end
    return new_enemy_info.size
  end
  #--------------------------------------------------------------------------
  # * Get bestiary complete rate
  #--------------------------------------------------------------------------
  def enemy_bestiary_complete_percentage
    e_max = enemy_bestiary_max.to_f
    e_now = enemy_bestiary_now.to_f
    comp = e_now / e_max * 100
    return comp.truncate
  end
  #--------------------------------------------------------------------------
  # * Set droped items
  #     enemy_id : enemy ID
  #     item     : item
  #--------------------------------------------------------------------------
  def droped_items(enemy_id, item)
    @enemy_droped_items[enemy_id] = [] if enemy_droped_items[enemy_id].nil?
    @enemy_droped_items[enemy_id] << item_get(item)
    @enemy_droped_items[enemy_id].uniq!
  end
  #--------------------------------------------------------------------------
  # * Set stole items
  #     enemy_id : enemy ID
  #     item     : item
  #--------------------------------------------------------------------------
  def stole_items(enemy_id, item)
    @enemy_stole_items[enemy_id] = [] if enemy_stole_items[enemy_id].nil?
    @enemy_stole_items[enemy_id] << item_get(item)
    @enemy_stole_items[enemy_id].uniq!
  end  
  #--------------------------------------------------------------------------
  # * Get item
  #     item : item
  #--------------------------------------------------------------------------
  def item_get(item)
    return 'w' + action_id(item).to_s if item.is_a?(RPG::Weapon)
    return 'a' + action_id(item).to_s if item.is_a?(RPG::Armor)
    return 'i' + action_id(item).to_s if item.is_a?(RPG::Item)
    return 'g' + item.to_s
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
  # * Get max bestiary entries
  #--------------------------------------------------------------------------
  def enemy_bestiary_max
    return $game_party.enemy_bestiary_max
  end
  #--------------------------------------------------------------------------
  # * Get current bestiary entries
  #--------------------------------------------------------------------------
  def enemy_bestiary_now
    return $game_party.enemy_bestiary_now
  end
  #--------------------------------------------------------------------------
  # * Get bestiary complete rate
  #--------------------------------------------------------------------------
  def enemy_bestiary_comp
    return $game_party.enemy_bestiary_complete_percentage
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base
  #--------------------------------------------------------------------------
  # * Draw Enemy
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #--------------------------------------------------------------------------
  def draw_enemy_bestiary(enemy, x, y)
    self.contents.font.color = normal_color
    self.contents.font.name = Font.default_name
    id = $game_temp.enemy_bestiary_data.id_data.index(enemy.id)
    self.contents.draw_text(x, y, 32, 32, id.to_s)
  end
  #--------------------------------------------------------------------------
  # * Enemy shown?
  #     id : enemy ID
  #--------------------------------------------------------------------------
  def show?(id)
    if $game_party.enemy_info[id] == 0 or $game_party.enemy_info[id].nil?
      return false
    else
      return true
    end
  end
end

#==============================================================================
# ** Window_Top_Message
#------------------------------------------------------------------------------
#  This window shows the information on the top
#==============================================================================

class Window_Top_Message < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x      : window x-coordinate
  #     y      : window y-coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = Font.default_name
    windowskin = Bestiary_Window1.nil? ? $game_system.windowskin_name : Bestiary_Window1
    self.windowskin = RPG::Cache.windowskin(windowskin)
    self.contents.draw_text(4, 0, 320, 32, Help_Message, 0)
    self.back_opacity = Windows_Back_Opacity
    self.opacity = Windows_Opacity
    if Show_Amount != 0
      case Show_Amount
      when 1
        e_now = $game_party.enemy_bestiary_now
        e_max = $game_party.enemy_bestiary_max
        text = e_now.to_s + '/' + e_max.to_s
      when 2
        comp = $game_party.enemy_bestiary_complete_percentage
        text = comp.to_s + '%'
      when 3
        e_now = $game_party.enemy_bestiary_now
        e_max = $game_party.enemy_bestiary_max
        comp = $game_party.enemy_bestiary_complete_percentage
        text = e_now.to_s + '/' + e_max.to_s + '    ' + comp.to_s + '%'
      end
      self.contents.draw_text(320, 0, 288, 32,  text, 2) if text != nil
    end
  end
end

#==============================================================================
# ** Window_Bestiary
#------------------------------------------------------------------------------
#  This window shows the enemy list
#==============================================================================

class Window_Bestiary < Window_Selectable
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  attr_reader   :data
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     index : index
  #--------------------------------------------------------------------------
  def initialize(index = 0)
    super(0, 64, 208, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = Font.default_name
    self.windowskin = RPG::Cache.windowskin(Bestiary_Window2)
    self.back_opacity = Windows_Back_Opacity
    self.opacity = Windows_Opacity
    @column_max = 1
    @bestiary_data = $game_temp.enemy_bestiary_data
    @data = @bestiary_data.id_data.dup
    @data.shift
    @item_max = @data.size
    self.index = 0
    refresh if @item_max > 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    self.contents = Bitmap.new(width - 32, row_max * 32)
    if @item_max > 0
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    enemy = $data_enemies[@data[index]]
    return if enemy.nil?
    x = 4 
    y = index * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.font.color = normal_color
    self.contents.font.name = Font.default_name
    draw_enemy_bestiary(enemy, x, y)
    if show?(enemy.id)
      self.contents.draw_text(x + 28, y, width - 48, 32, enemy.name, 0)
    else
      self.contents.draw_text(x + 28, y, width - 48, 32, '----------', 0)
    end
  end
end

#==============================================================================
# ** Window_Bestiary_Info
#------------------------------------------------------------------------------
#  This window shows the enemy info
#==============================================================================

class Window_Bestiary_Info < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(208, 64, 432, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.windowskin = RPG::Cache.windowskin(Bestiary_Window3)
    self.back_opacity = Windows_Back_Opacity
    self.opacity = Windows_Opacity
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #    enemy_id : enemy ID
  #    info_on  : show information
  #--------------------------------------------------------------------------
  def refresh(enemy_id, info_on = true)
    self.contents.clear
    return unless show?(enemy_id)
    enemy = $data_enemies[enemy_id]
    draw_enemy_bestiary(enemy, 4, 0)
    draw_enemy_name(enemy, 36, 0)
    if info_on
      self.contents.font.size = 16
      self.contents.font.bold = true
      x = Status_Text_Position
      y1 = Damage_Algorithm_Type == 2 ? 64 : 0
      y2 = Damage_Algorithm_Type == 2 ? -54 : 0
      draw_enemy_parameter(enemy, x, y1 + -8 , 0)
      draw_enemy_parameter(enemy, x, y1 +10, 1)
      draw_enemy_parameter(enemy, x, 32, 2) unless Damage_Algorithm_Type == 2
      draw_enemy_parameter(enemy, x, 50, 3) unless Damage_Algorithm_Type == 2
      draw_enemy_parameter(enemy, x, 68, 4) unless Damage_Algorithm_Type == 2
      draw_enemy_parameter(enemy, x, y1 + y2 + 90, 5)
      draw_enemy_parameter(enemy, x, y1 + y2 + 108, 6)
      draw_enemy_parameter(enemy, x, y1 + y2 + 126, 7)
      draw_enemy_parameter(enemy, x, y1 + y2 + 144, 8)
      draw_enemy_parameter(enemy, x, y1 + y2 + 162, 9)
      draw_enemy_exp(enemy, x - 32, 184)
      draw_enemy_gold(enemy, x + 84, 184)
      draw_enemy_drop_item(enemy, 0, 230) if Show_Drops
      draw_enemy_steal_item(enemy, (Show_Drops ? 212 : 0), 230) if Show_Steal
      self.contents.font.size = Font.default_size
      self.contents.font.color = normal_color
      self.contents.font.bold = false
    else
      self.contents.font.size = 16
      self.contents.font.bold = true
      draw_element_resist(enemy, Element_Position)
      self.contents.font.size = Font.default_size
      self.contents.font.color = normal_color
      self.contents.font.bold = false
      if Enemy_Info.include?(enemy_id)
        info = Enemy_Info[enemy_id].dup
        for i in 0...info.size
          self.contents.draw_text(0, i * 32 + 32,self.width - 32, self.height - 32, info[i]) if info[i].is_a?(String)
        end
      else
        self.contents.draw_text(0, 32,self.width - 32, self.height - 32, No_Enemy_Info) 
      end
    end
    self.contents.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # * Draw name
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #--------------------------------------------------------------------------
  def draw_enemy_name(enemy, x, y)
    self.contents.font.color = normal_color
    self.contents.font.name = Font.default_name
    self.contents.draw_text(x, y, 184, 32, enemy.name)
  end
  #--------------------------------------------------------------------------
  # * Draw EXP
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #--------------------------------------------------------------------------
  def draw_enemy_exp(enemy, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x + 12, y, 92, 32, Exp_Text_Bestiary)
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y ,92, 32, enemy.exp.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw gold
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #--------------------------------------------------------------------------
  def draw_enemy_gold(enemy, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x + 12, y, 64, 32, $data_system.words.gold)
    x = x + contents.text_size($data_system.words.gold).width
    self.contents.font.color = normal_color
    self.contents.draw_text(x - 12, y, 80, 32, enemy.gold.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw parameter
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #     type  : parameter type
  #--------------------------------------------------------------------------
  def draw_enemy_parameter(enemy, x, y, type)
    case type
    when 0
      parameter_name = $data_system.words.hp
      parameter_value = enemy.maxhp
    when 1
      parameter_name = $data_system.words.sp
      parameter_value = enemy.maxsp
    when 2
      parameter_name = $data_system.words.atk
      parameter_value = enemy.atk
    when 3
      parameter_name = $data_system.words.pdef
      parameter_value = enemy.pdef
    when 4
      parameter_name = $data_system.words.mdef
      parameter_value = enemy.mdef
    when 5
      parameter_name = $data_system.words.str
      parameter_value = enemy.str
    when 6
      parameter_name = Damage_Algorithm_Type > 1 ? Status_Vitality : $data_system.words.dex
      parameter_value = enemy.dex
    when 7
      parameter_name = $data_system.words.agi
      parameter_value = enemy.agi
    when 8
      parameter_name = $data_system.words.int
      parameter_value = enemy.int
    when 9
      parameter_name = Status_Evasion
      parameter_value = enemy.eva
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 96, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + Status_Text_Distance, y, 36, 32, parameter_value.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Drop Items
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #--------------------------------------------------------------------------
  def draw_enemy_drop_item(enemy, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y - 25, 160, 32, Drop_Message)
    self.contents.font.color = normal_color
    treasures = []
    drops = set_drops(enemy)
    for drop in drops
      treasures << drop unless drop.nil?
    end
    treasures.sort! {|a, b| a.id <=> b.id}
    treasures.sort! do |a, b|
      a_class = a.is_a?(RPG::Item) ? 0 : a.is_a?(RPG::Weapon) ? 1 : 2
      b_class = b.is_a?(RPG::Item) ? 0 : b.is_a?(RPG::Weapon) ? 1 : 2
      a_class <=> b_class
    end
    for i in 0...treasures.size
      item = treasures[i]
      bitmap = RPG::Cache.icon(item.icon_name)
      self.contents.blt(x, y + 4 + (i * 25), bitmap, Rect.new(0, 0, 24, 24))
      self.contents.draw_text(x + 28, y + (i * 25), 180, 32, item.name)
    end
    total_drops = set_all_drops(enemy)
    if total_drops.size > 0
      for i in treasures.size...total_drops.size
        self.contents.draw_text(x, y + (i * 25), 180, 32, '????????????????')
      end
    else
      self.contents.font.color = disabled_color
      self.contents.draw_text(x , y, 192, 32, '----------------')
    end
  end
  #--------------------------------------------------------------------------
  # * Get item drop
  #     enemy : enemy
  #--------------------------------------------------------------------------
  def set_drops(enemy)
    drops = []
    if Need_Drop and not ($game_party.enemy_info[enemy.id] == 2 or $game_party.enemy_info[enemy.id] == 4)    
      drops = $game_party.enemy_droped_items[enemy.id]
    else
      drops = set_all_drops(enemy)
    end
    return [] if drops.nil?
    drops.uniq!
    drop = []
    for item in drops
      item = item.split('')
      if item[0] == 'i'
        item = item.join
        item.slice!('i')
        drop << $data_items[item.to_i]
      elsif item[0] == 'a'
        item = item.join
        item.slice!('a')
        drop << $data_armors[item.to_i]
      elsif item[0] == 'w'
        item = item.join
        item.slice!('w')
        drop << $data_weapons[item.to_i]
      end
    end
    return drop
  end
  #--------------------------------------------------------------------------
  # * Show all drop items
  #     enemy : enemy
  #--------------------------------------------------------------------------
  def set_all_drops(enemy)
    drops = []
    drops << normal_drop(enemy) if normal_drop(enemy) != nil
    if Enemy_Drops[enemy.id] != nil
      for item in Enemy_Drops[enemy.id]
        drops << item[0]
      end
    end
    drops.uniq!
    return drops
  end
  #--------------------------------------------------------------------------
  # * Get normal drop
  #     enemy : enemy
  #--------------------------------------------------------------------------
  def normal_drop(enemy)
    return 'i' + enemy.item_id.to_s if enemy.item_id > 0
    return 'w' + enemy.weapon_id.to_s if enemy.weapon_id > 0
    return 'a' + enemy.armor_id.to_s if enemy.armor_id > 0
    return nil
  end
  #--------------------------------------------------------------------------
  # * Draw Steal Items
  #     enemy : enemy
  #     x     : window x-coordinate
  #     y     : window y-coordinate
  #--------------------------------------------------------------------------
  def draw_enemy_steal_item(enemy, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y - 25, 160, 32, Steal_Message)
    self.contents.font.color = normal_color
    treasures = []
    drops = set_steal(enemy)
    unless drops.nil?
      for drop in drops
        treasures << drop unless drop.nil?
      end
    end
    treasures.sort! {|a, b| (a.is_a?(Fixnum) ? a : a.id)  <=> (b.is_a?(Fixnum) ? b : b.id)}
    treasures.sort! do |a, b|
      a_class = a.is_a?(RPG::Item) ? 0 : a.is_a?(RPG::Weapon) ? 1 : a.is_a?(RPG::Armor) ? 2 : 3
      b_class = b.is_a?(RPG::Item) ? 0 : b.is_a?(RPG::Weapon) ? 1 : b.is_a?(RPG::Armor) ? 2 : 3
      a_class <=> b_class
    end
    for i in 0...treasures.size
      item = treasures[i]
      if item.is_a?(Fixnum)
        bitmap = RPG::Cache.icon(Gold_Icon)
        self.contents.blt(x, y + 4 + (i * 25), bitmap, Rect.new(0, 0, 24, 24))
        self.contents.draw_text(x + 28, y + (i * 25), 180, 32, item.to_s + ' ' + $data_system.words.gold)
      else
        bitmap = RPG::Cache.icon(item.icon_name)
        self.contents.blt(x, y + 4 + (i * 25), bitmap, Rect.new(0, 0, 24, 24))
        self.contents.draw_text(x + 28, y + (i * 25), 180, 32, item.name)
      end
    end
    total_drops = set_all_steal(enemy)
    if total_drops.size > 0
      for i in treasures.size...total_drops.size
        self.contents.draw_text(x, y + (i * 25), 180, 32, '????????????????')
      end
    else
      self.contents.font.color = disabled_color
      self.contents.draw_text(x , y, 180, 32, '----------------')
    end
  end
  #--------------------------------------------------------------------------
  # * Get item steal
  #     enemy : enemy
  #--------------------------------------------------------------------------
  def set_steal(enemy)
    drops = []
    if Need_Steal and not ($game_party.enemy_info[enemy.id] == 3 or $game_party.enemy_info[enemy.id] == 4)
      drops = $game_party.enemy_stole_items[enemy.id]
    else
      drops = set_all_steal(enemy)
    end
    return [] if drops.nil?
    drops.uniq!
    drop = []
    for item in drops
      item = item.split('')
      if item[0] == 'i'
        item = item.join
        item.slice!('i')
        drop << $data_items[item.to_i]
      elsif item[0] == 'a'
        item = item.join
        item.slice!('a')
        drop << $data_armors[item.to_i]
      elsif item[0] == 'w'
        item = item.join
        item.slice!('w')
        drop << $data_weapons[item.to_i]
      elsif item[0] == 'g'
        item = item.join
        item.slice!('g')
        drop << item.to_i
      end
    end
    return drop
  end
  #--------------------------------------------------------------------------
  # * Show all steal items
  #     enemy : enemy
  #--------------------------------------------------------------------------
  def set_all_steal(enemy)
    drops = []
    if Enemy_Steal[enemy.id] != nil
      for item in Enemy_Steal[enemy.id]
        drops << item[0]
      end
    end
    drops.uniq!
    return drops
  end
  #--------------------------------------------------------------------------
  # * Draw elemental resistance
  #     enemy : enemy
  #     x     : window x-coordinate
  #--------------------------------------------------------------------------
  def draw_element_resist(enemy, x)
    max_elment = [Max_Elements_Shown, 8].min
    y = (200 - (max_elment * 25)) / 2
    elements = $data_enemies[enemy.id].element_ranks
    base = value = 0
    case Element_Resists_Exhibition
    when 0
      table = [0] + Element_Resist_Text
    when 1
      table = [0] + ['-100%','-50%','0%','50%','100%','200%']
    else
      table = [0] + ['200%','150%','100%','50%','0%','-100%']
    end
    for i in 0...$data_system.elements.size
      begin
        bitmap = RPG::Cache.icon($data_system.elements[i] + '_elm')
        self.contents.blt(x + (base * 112), y + (value * 25), bitmap, Rect.new(0, 0, 24, 24))
        result = table[elements[i]]
        case elements[i]
        when 1
          self.contents.font.color = Weakest_Color
        when 2
          self.contents.font.color = Weak_Color
        when 3
          self.contents.font.color = Neutral_Color
        when 4
          self.contents.font.color = Resist_Color
        when 5
          self.contents.font.color = Imune_Color
        when 6
          self.contents.font.color = Absorb_Color
        end
        case Element_Resists_Exhibition
        when 0
          self.contents.draw_text(x + 28 + (base * 112), y - 4 + (value * 25), 180, 32, result.to_s, 0)
        else
          self.contents.draw_text(x + (base * 112), y - 4 + (value * 25), 72, 32, result.to_s, 2)
        end
        value += 1
        base += 1 if value == max_elment
        value = value % max_elment
      rescue
      end
    end
  end
end

#==============================================================================
# ** Data_Bestiary
#------------------------------------------------------------------------------
# This class keeps all bestiary info
#==============================================================================

class Data_Bestiary
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :id_data
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @id_data = enemy_bestiary_id_set
  end
  #--------------------------------------------------------------------------
  # * Get besteary ID data
  #--------------------------------------------------------------------------
  def enemy_bestiary_id_set
    data = [0]
    for i in 1...$data_enemies.size
      enemy = $data_enemies[i]
      next if enemy.name == '' or Never_Show.include?(enemy.id)
      data << enemy.id
    end
    return data
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start After Battle Phase
  #--------------------------------------------------------------------------
  alias atoa_bestiary_start_phase5 start_phase5
  def start_phase5
    for enemy in $game_troop.enemies
      $game_party.add_enemy_info(enemy.id, 1) unless enemy.hidden or Dont_add_enemies_in_battle
    end
    atoa_bestiary_start_phase5
  end
  #--------------------------------------------------------------------------
  # * Set items droped by enemies
  #--------------------------------------------------------------------------
  alias atoa_bestiary_treasure_drop treasure_drop
  def treasure_drop(enemy)
    item = atoa_bestiary_treasure_drop(enemy)
    $game_party.droped_items(enemy.id, item) if item != nil
    return item
  end
end

#==============================================================================
# ** Scene_Bestiary
#------------------------------------------------------------------------------
#  This class performs bestiary screen processing.
#==============================================================================

class Scene_Bestiary
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    $game_temp.enemy_bestiary_data = Data_Bestiary.new
    @title_window = Window_Top_Message.new(0, 0, 640, 64)
    @spriteset = Spriteset_Map.new if Show_Map
    unless Back_Image.nil?
      @back_image = Sprite.new
      @back_image.bitmap = RPG::Cache.windowskin(Back_Image)
    end
    @main_window = Window_Bestiary.new
    @main_window.active = true
    @info_window = Window_Bestiary_Info.new
    @info_window.visible = true
    @viewport = Viewport.new(208, 80, 400, 368)
    @viewport.z = 100
    @info_on = true
    update_info
    Graphics.transition
    loop do
      update
      Graphics.update
      Input.update
      $game_system.update
      $game_screen.update
      break if $scene != self
    end
    Graphics.freeze
    @monster_sprite.dispose
    @back_image.dispose unless Back_Image.nil?
    @main_window.dispose
    @info_window.dispose
    @title_window.dispose
    @spriteset.dispose if Show_Map
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if Input.repeat?(Input::UP) or Input.repeat?(Input::DOWN)
      @main_window.update
      @info_window.update
      update_info
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Map.new
      return
    end
    if Input.trigger?(Input::C) and Show_Description
      if @info_window.show?(@enemy_id)
        $game_system.se_play($data_system.decision_se)
        @info_on = @info_on ? false : true
        @info_window.refresh(@enemy_id ,@info_on)
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
    @monster_sprite.update if @monster_sprite != nil
  end
  #--------------------------------------------------------------------------
  # * Update information
  #--------------------------------------------------------------------------
  def update_info
    @enemy_id = @main_window.data[@main_window.index]
    @info_window.refresh(@enemy_id, @info_on)
    @enemy = Game_Enemy_Bestiary.new(0, 0, @enemy_id)
    show_info = @info_window.show?(@enemy_id)
    @monster_sprite.dispose if @monster_sprite != nil
    @monster_sprite = Sprite_Battler_Bestiary.new(@viewport, @enemy, show_info)
  end
end