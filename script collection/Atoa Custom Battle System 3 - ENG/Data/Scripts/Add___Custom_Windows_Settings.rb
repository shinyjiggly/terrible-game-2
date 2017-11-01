#==============================================================================
# Custom Windows Setting
# by Atoa
#==============================================================================
# This script allows you to customize battle windows.
# You can change the Skill Window, Item Window and Party Command Window.
# Actor Command Window customization can be done on the "Individual Battle Command" script
#==============================================================================

module Atoa
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ITEM WINDOW SETTING
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Settings for Item Window
  
  # Item_Window_Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Item_Window_Settings = [0 , 320, 640, 160, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Item_Window_Bg = ''
 
  # Position of the backgroun image
  # Item_Window_Bg_Postion = [Position X, Position Y]
  Item_Window_Bg_Postion = [0 , 0]

  # Number of columns for itens
  Item_Window_Colums = 2
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SKILL WINDOW SETTING
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Settings for Skill Window
  
  # Skill_Window_Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Skill_Window_Settings = [0 , 320, 640, 160, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Skill_Window_Bg = ''
 
  # Position of the backgroun image
  # Item_Window_Bg_Postion = [Position X, Position Y]
  Skill_Window_Bg_Postion = [0 , 0]

  # Number of columns for skills
  Skill_Window_Colums = 2
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # PARTY COMMAND WINDOW SETTING
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Settings for Party Command Window
  
  # Party_Command_Window__Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Party_Command_Window_Settings = [0 , 0, 640, 64, 160, false]

  # Image filename for window background, must be on the Windowskin folder
  Party_Command_Window_Bg = ''
 
  # Position of the backgroun image
  # Party_Command_Window__Bg_Postion = [Position X, Position Y]
  Party_Command_Window_Bg_Postion = [0 , 0]
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Custom Windows'] = true

#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays items in possession on the item and battle screens.
#==============================================================================

class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias custom_windows_initialize initialize
  def initialize
    custom_windows_initialize
    if $game_temp.in_battle
      if Item_Window_Bg != nil
        @background_image = Sprite.new
        @background_image.bitmap = RPG::Cache.windowskin(Item_Window_Bg)
        @background_image.x = self.x + Item_Window_Bg_Postion[0]
        @background_image.y = self.y + Item_Window_Bg_Postion[1]
        @background_image.z = self.z - 1
        @background_image.visible = self.visible
      end
      self.x = Item_Window_Settings[0]
      self.y = Item_Window_Settings[1]
      self.width = Item_Window_Settings[2]
      self.height = Item_Window_Settings[3]
      self.back_opacity = Item_Window_Settings[4]
      self.opacity = Item_Window_Settings[4] if Item_Window_Settings[5]
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @background_image.dispose if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    super
    @background_image.visible = n if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    @column_max = [Item_Window_Colums, 1].max
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if item.is_a?(RPG::Item) and $game_party.item_can_use?(item.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % @column_max * column_width
    y = index / @column_max * 32
    rect = Rect.new(x, y, column_width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, column_width, 32, item.name, 0)
    self.contents.draw_text(x + 24, y, column_width - 96, 32, ":", 2)
    self.contents.draw_text(x + 24, y, column_width - 64, 32, number.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Get column width
  #--------------------------------------------------------------------------
  def column_width
    return (self.width / @column_max)
  end
end

#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
#  This window displays usable skills on the skill and battle screens.
#==============================================================================

class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor        : actor
  #     command_type : skill type
  #--------------------------------------------------------------------------
  alias custom_windows_initialize initialize
  def initialize(actor, command_type = '')
    custom_windows_initialize(actor, command_type) if $atoa_script['Atoa Individual Commands']
    custom_windows_initialize(actor) unless $atoa_script['Atoa Individual Commands']
    if $game_temp.in_battle
      if Skill_Window_Bg != nil
        @background_image = Sprite.new
        @background_image.bitmap = RPG::Cache.windowskin(Skill_Window_Bg)
        @background_image.x = self.x + Skill_Window_Bg_Postion[0]
        @background_image.y = self.y + Skill_Window_Bg_Postion[1]
        @background_image.z = self.z - 1
        @background_image.visible = self.visible
      end
      self.x = Skill_Window_Settings[0]
      self.y = Skill_Window_Settings[1]
      self.width = Skill_Window_Settings[2]
      self.height = Skill_Window_Settings[3]
      self.back_opacity = Skill_Window_Settings[4]
      self.opacity = Skill_Window_Settings[4] if Skill_Window_Settings[5]
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @background_image.dispose if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    super
    @background_image.visible = n if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    @column_max = [Skill_Window_Colums, 1].max
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = normal_color
      if $atoa_script['Atoa Overdrive'] and Overdrive_Color != nil and
         skill.overdrive_cost > 0
        color = Overdrive_Color
        self.contents.font.color = Color.new(color[0], color[1], color[2])
      end
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % @column_max * column_width
    y = index / @column_max * 32
    rect = Rect.new(x, y, column_width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, column_width, 32, skill.name, 0)
    draw_skill_cost(skill, x, y)
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Cost
  #     skill : skill
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_skill_cost(skill, x, y)
    return if Hide_Zero_SP
    cost = @actor.calc_sp_cost(skill)
    self.contents.draw_text(x + 24, y, column_width - 64, 32, cost.to_s, 2)
  end  
  #--------------------------------------------------------------------------
  # * Get column width
  #--------------------------------------------------------------------------
  def column_width
    return (self.width / @column_max)
  end
end

#==============================================================================
# ** Window_PartyCommand
#------------------------------------------------------------------------------
#  This window is used to select whether to fight or escape on the battle
#  screen.
#==============================================================================

class Window_PartyCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias custom_windows_initialize initialize
  def initialize
    custom_windows_initialize
    if $game_temp.in_battle
      if Party_Command_Window_Bg != nil
        @background_image = Sprite.new
        @background_image.bitmap = RPG::Cache.windowskin(Party_Command_Window_Bg)
        @background_image.x = self.x + Party_Command_Window_Bg_Postion[0]
        @background_image.y = self.y + Party_Command_Window_Bg_Postion[1]
        @background_image.z = self.z - 1
        @background_image.visible = self.visible
      end
      self.x = Party_Command_Window_Settings[0]
      self.y = Party_Command_Window_Settings[1]
      self.width = Party_Command_Window_Settings[2]
      self.height = Party_Command_Window_Settings[3]
      self.back_opacity = Party_Command_Window_Settings[4]
      self.opacity = Party_Command_Window_Settings[4] if Party_Command_Window_Settings[5] 
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, self.height - 32)
      draw_item(0, normal_color)
      draw_item(1, $game_temp.battle_can_escape ? normal_color : disabled_color)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new((self.width / 4) + index * (self.width / 4) + 4, 0, 128 - 10, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index], 1)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @background_image.dispose if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    super
    @background_image.visible = n if @background_image != nil
  end
end