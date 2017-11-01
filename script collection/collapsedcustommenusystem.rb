#=============================================================================
#
# ** Collapsed_CMS
#
#-----------------------------------------------------------------------------
#
# By Ryex
# V 2.00
#
#-----------------------------------------------------------------------------
#
# Features
#
# *Gradient Bars for Health, SP, and EXP that lag less through entire menu
# *Smaller horizontal status window on main screen
# *Map as background 
# *Icons in command menu
# *Small only visible when you need it actor select menu
#
#-----------------------------------------------------------------------------
#
# Instructions
#
# Place in a new script above main
# If you want to change the icons search for this line
#
#  @command_window = Window_HCommand_WI.new
#
# without the # in front. Then replace the icon names in the array that
# follows the line above.
#
#=============================================================================
#==============================================================================
# ** Window_HCommand_WI Modified from Blizzard's Window_HCommand By Ryex
#------------------------------------------------------------------------------
#  This window deals with general command choices, but the display is
#  horizontal.
#==============================================================================

class Window_HCommand_WI < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     width    : window width
  #     commands : command text string array
  #--------------------------------------------------------------------------
  def initialize(width, commands)
    super
    self.width, self.height = commands.size * width + 32, 64
    @column_max = commands.size
    self.contents.dispose
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
    refresh
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #     color : text color
  #--------------------------------------------------------------------------
  def draw_item(i, color)
    self.contents.font.color = color
    w = (self.width - 32) / @column_max
    x = i % @column_max * w
    rect = Rect.new(x, 0, self.contents.width / @column_max, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.blt(x, 4, RPG::Cache.icon(@commands[i][0]),
          Rect.new(0, 0, 24, 24))
    self.contents.draw_text(rect, @commands[i][1], 1)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # If cursor position is less than 0
    if @index < 0
      self.cursor_rect.empty
      return
    end
    # Get current row
    row = @index / @column_max
    # If current row is before top row
    if row < self.top_row
      # Scroll so that current row becomes top row
      self.top_row = row
    end
    # If current row is more to back than back row
    if row > self.top_row + (self.page_row_max - 1)
      # Scroll so that current row becomes back row
      self.top_row = row - (self.page_row_max - 1)
    end
    # Calculate cursor width
    cursor_width = (self.width - 32) / @column_max
    # Calculate cursor coordinates
    x = @index % @column_max * cursor_width
    # Update cursor rectangle
    self.cursor_rect.set(x, 0, cursor_width, 32)
  end
end

#==============================================================================
# ** Window_CollapsedMenuStatus By Ryex
#------------------------------------------------------------------------------
#  This window displays limited party member stats horizontaly in the menu.
#==============================================================================

class Window_CollapsedMenuStatus < Window_Base
  #----------------------------------------------------------------------------
  # * Object Initialization
  #     x : x value
  #     y : y value
  #----------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 640, 192)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw a gradiant bar of a certen langth (you must provide the amount)
  #     x : x value
  #     y : y value
  #     p : fill_rate
  #     m : max leinght
  #     h : hight
  #     c : Color
  #--------------------------------------------------------------------------
  def draw_bar(x,y,p,m,h,c)
    self.contents.fill_rect(x, y - 1, m, h, Color.new(0, 0, 0))
    for i in 0...(h - 2)
      r = c.red * i / (h - 2)
      g = c.green * i / (h - 2)
      b = c.blue * i / (h - 2)
      self.contents.fill_rect(x + 1, y + i, p * (m - 2), 1, Color.new(r, g, b))
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actorx = i * 160 + 4
      draw_actor_name(actor, actorx - 4, 0)
      rate_hp = actor.hp.to_f / actor.maxhp
      draw_bar(actorx, 42, rate_hp, 120, 12, Color.new(255, 0, 0))
      draw_actor_hp(actor, actorx, 32, 120)
      rate_sp = actor.sp.to_f / actor.maxsp
      draw_bar(actorx, 74, rate_sp, 120, 12, Color.new(0, 0, 255))
      draw_actor_sp(actor, actorx, 64, 120)
      rate_exp = $game_party.actors[i].exp.to_f / $game_party.actors[i].next_exp_s.to_i
      draw_bar(actorx, 106, rate_exp, 120, 12, Color.new(255, 255, 0))
      draw_actor_level(actor, actorx, 96)
      draw_actor_state(actor, actorx, 128)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
  end
end

#==============================================================================
# ** Window_ActorSelect
#------------------------------------------------------------------------------
# This Window provides one the fuctions of the original Window_MenuStatus it
# allows the slection of the actor index
#==============================================================================

class Window_ActorSelect < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(272, 160, 96, 256)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 32
      y = i * 56
      actor = $game_party.actors[i]
      draw_actor_graphic(actor, x, y + 56)
    end
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, @index * 56, self.width - 32, 56)
    end
  end
end



#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen. (modified)
#==============================================================================

class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 640, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw a gradiant bar of a certen langth (you must provide the amount)
  #     x : x value
  #     y : y value
  #     p : fill_rate
  #     m : max leinght
  #     h : hight
  #     c : Color
  #--------------------------------------------------------------------------
  def draw_bar(x,y,p,m,h,c)
    self.contents.fill_rect(x, y - 1, m, h, Color.new(0, 0, 0))
    for i in 0...(h - 2)
      r = c.red * i / (h - 2)
      g = c.green * i / (h - 2)
      b = c.blue * i / (h - 2)
      self.contents.fill_rect(x + 1, y + i, p * (m - 2), 1, Color.new(r, g, b))
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    rate_hp = @actor.hp.to_f / @actor.maxhp
    draw_bar(96, 122, rate_hp, 120, 12, Color.new(255, 0, 0))
    rate_sp = @actor.sp.to_f / @actor.maxsp
    draw_bar(96, 154, rate_sp, 120, 12, Color.new(0, 0, 255))
    rate_exp = @actor.exp.to_f / @actor.next_exp_s.to_i
    draw_bar(96, 42, rate_exp, 120, 12, Color.new(255, 255, 0))
    draw_actor_graphic(@actor, 40, 112)
    draw_actor_name(@actor, 4, 0)
    draw_actor_class(@actor, 4 + 144, 0)
    draw_actor_level(@actor, 96, 32)
    draw_actor_state(@actor, 96, 64)
    draw_actor_hp(@actor, 96, 112, 172)
    draw_actor_sp(@actor, 96, 144, 172)
    draw_actor_parameter(@actor, 96, 192, 0)
    draw_actor_parameter(@actor, 96, 224, 1)
    draw_actor_parameter(@actor, 96, 256, 2)
    draw_actor_parameter(@actor, 96, 304, 3)
    draw_actor_parameter(@actor, 96, 336, 4)
    draw_actor_parameter(@actor, 96, 368, 5)
    draw_actor_parameter(@actor, 96, 400, 6)
    self.contents.font.color = system_color
    self.contents.draw_text(320, 48, 80, 32, "EXP")
    self.contents.draw_text(320, 80, 80, 32, "NEXT")
    self.contents.font.color = normal_color
    self.contents.draw_text(320 + 80, 48, 84, 32, @actor.exp_s, 2)
    self.contents.draw_text(320 + 80, 80, 84, 32, @actor.next_rest_exp_s, 2)
    self.contents.font.color = system_color
    self.contents.draw_text(320, 160, 96, 32, "equipment")
    draw_item_name($data_weapons[@actor.weapon_id], 320 + 16, 208)
    draw_item_name($data_armors[@actor.armor1_id], 320 + 16, 256)
    draw_item_name($data_armors[@actor.armor2_id], 320 + 16, 304)
    draw_item_name($data_armors[@actor.armor3_id], 320 + 16, 352)
    draw_item_name($data_armors[@actor.armor4_id], 320 + 16, 400)
  end
  def dummy
    self.contents.font.color = system_color
    self.contents.draw_text(320, 112, 96, 32, $data_system.words.weapon)
    self.contents.draw_text(320, 176, 96, 32, $data_system.words.armor1)
    self.contents.draw_text(320, 240, 96, 32, $data_system.words.armor2)
    self.contents.draw_text(320, 304, 96, 32, $data_system.words.armor3)
    self.contents.draw_text(320, 368, 96, 32, $data_system.words.armor4)
    draw_item_name($data_weapons[@actor.weapon_id], 320 + 24, 144)
    draw_item_name($data_armors[@actor.armor1_id], 320 + 24, 208)
    draw_item_name($data_armors[@actor.armor2_id], 320 + 24, 272)
    draw_item_name($data_armors[@actor.armor3_id], 320 + 24, 336)
    draw_item_name($data_armors[@actor.armor4_id], 320 + 24, 400)
  end
end


#==============================================================================
# ** Window_Target
#------------------------------------------------------------------------------
#  This window selects a use target for the actor on item and skill screens.
#  (modified)
#==============================================================================

class Window_Target < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 336, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z += 10
    @item_max = $game_party.actors.size
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw a gradiant bar of a certen langth (you must provide the amount)
  #     x : x value
  #     y : y value
  #     p : fill_rate
  #     m : max leinght
  #     h : hight
  #     c : Color
  #--------------------------------------------------------------------------
  def draw_bar(x,y,p,m,h,c)
    self.contents.fill_rect(x, y - 1, m, h, Color.new(0, 0, 0))
    for i in 0...(h - 2)
      r = c.red * i / (h - 2)
      g = c.green * i / (h - 2)
      b = c.blue * i / (h - 2)
      self.contents.fill_rect(x + 1, y + i, p * (m - 2), 1, Color.new(r, g, b))
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...$game_party.actors.size
      x = 4
      y = i * 116
      actor = $game_party.actors[i]
      rate_hp = actor.hp.to_f / actor.maxhp
      draw_bar(x + 152, y + 42, rate_hp, 120, 12, Color.new(255, 0, 0))
      rate_sp = actor.sp.to_f / actor.maxsp
      draw_bar(x + 152, y + 74, rate_sp, 120, 12, Color.new(0, 0, 255))
      rate_exp = $game_party.actors[i].exp.to_f / $game_party.actors[i].next_exp_s.to_i
      draw_bar(x + 8, y + 42, rate_exp, 120, 12, Color.new(255, 255, 0))
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      draw_actor_level(actor, x + 8, y + 32)
      draw_actor_state(actor, x + 8, y + 64)
      draw_actor_hp(actor, x + 152, y + 32)
      draw_actor_sp(actor, x + 152, y + 64)
    end
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # Cursor position -1 = all choices, -2 or lower = independent choice
    # (meaning the user's own choice)
    if @index <= -2
      self.cursor_rect.set(0, (@index + 10) * 116, self.width - 32, 96)
    elsif @index == -1
      self.cursor_rect.set(0, 0, self.width - 32, @item_max * 116 - 20)
    else
      self.cursor_rect.set(0, @index * 116, self.width - 32, 96)
    end
  end
end


#==============================================================================
# ** Window_SkillStatus
#------------------------------------------------------------------------------
#  This window displays the skill user's status on the skill screen.
#==============================================================================

class Window_SkillStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 64, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw a gradiant bar of a certen langth (you must provide the amount)
  #     x : x value
  #     y : y value
  #     p : fill_rate
  #     m : max leinght
  #     h : hight
  #     c : Color
  #--------------------------------------------------------------------------
  def draw_bar(x,y,p,m,h,c)
    self.contents.fill_rect(x, y - 1, m, h, Color.new(0, 0, 0))
    for i in 0...(h - 2)
      r = c.red * i / (h - 2)
      g = c.green * i / (h - 2)
      b = c.blue * i / (h - 2)
      self.contents.fill_rect(x + 1, y + i, p * (m - 2), 1, Color.new(r, g, b))
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    rate_hp = @actor.hp.to_f / @actor.maxhp
    draw_bar(284, 10, rate_hp, 120, 12, Color.new(255, 0, 0))
    rate_sp = @actor.sp.to_f / @actor.maxsp
    draw_bar(460, 10, rate_sp, 120, 12, Color.new(0, 0, 255))
    draw_actor_name(@actor, 4, 0)
    draw_actor_state(@actor, 140, 0)
    draw_actor_hp(@actor, 284, 0)
    draw_actor_sp(@actor, 460, 0)
  end
end


#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs menu screen processing.
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : command cursor's initial position
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    #creates map background
    @map = Spriteset_Map.new
    # Make command window
    s1 = $data_system.words.item
    s2 = $data_system.words.skill
    s3 = $data_system.words.equip
    s4 = "Status"
    s5 = "Save"
    s6 = "End Game"
    @command_window = Window_HCommand_WI.new(96, [["032-Item01",
        $data_system.words.item], ["044-Skill01", $data_system.words.skill],
        ["001-Weapon01", $data_system.words.equip], ["050-Skill07", "Status"],
        ["047-Skill04", "Save"], ["030-Key02","Exit"]
        ])
    @command_window.x = 16
    @command_window.y = 416
    @command_window.index = @menu_index
    # If number of party members is 0
    if $game_party.actors.size == 0
      # Disable items, skills, equipment, and status
      @command_window.disable_item(0)
      @command_window.disable_item(1)
      @command_window.disable_item(2)
      @command_window.disable_item(3)
    end
    # If save is forbidden
    if $game_system.save_disabled
      # Disable save
      @command_window.disable_item(4)
    end
    # Make status window
    @status_window = Window_CollapsedMenuStatus.new(0,0)
    @status_window.x = 0
    @status_window.y = 0
    # Make Actor slect window
    @actor_window = Window_ActorSelect.new
    @actor_window.z = 9998
    @actor_window.visible = false
    @actor_window.active = false
    # Make gold window
    @gold_window = Window_Gold.new
    @gold_window.x = 0
    @gold_window.y = 256
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @command_window.dispose
    @status_window.dispose
    @gold_window.dispose
    @actor_window.dispose
    @map.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update windows
    @command_window.update
    @status_window.update
    @gold_window.update
    @actor_window.update
    @map.update
    # If command window is active: call update_command
    if @command_window.active
      update_command
      return
    end
    # If status window is active: call update_status
    if @actor_window.active
      update_actor
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when command window is active)
  #--------------------------------------------------------------------------
  def update_command
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # If command other than save or end game, and party members = 0
      if $game_party.actors.size == 0 and @command_window.index < 4
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Branch by command window cursor position
      case @command_window.index
      when 0  # item
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to item screen
        $scene = Scene_Item.new
      when 1  # skill
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @actor_window.active = true
        @actor_window.visible = true
        @actor_window.index = 0
      when 2  # equipment
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @actor_window.active = true
        @actor_window.visible = true
        @actor_window.index = 0
      when 3  # status
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @actor_window.active = true
        @actor_window.visible = true
        @actor_window.index = 0
      when 4  # save
        # If saving is forbidden
        if $game_system.save_disabled
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to save screen
        $scene = Scene_Save.new
      when 5  # end game
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to end game screen
        $scene = Scene_End.new
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when Acior window is active)
  #--------------------------------------------------------------------------
  def update_actor
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Make command window active
      @command_window.active = true
      @actor_window.active = false
      @actor_window.visible = false
      @actor_window.index = -1
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by command window cursor position
      case @command_window.index
      when 1  # skill
        # If this actor's action limit is 2 or more
        if $game_party.actors[@actor_window.index].restriction >= 2
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to skill screen
        $scene = Scene_Skill.new(@actor_window.index)
      when 2  # equipment
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to equipment screen
        $scene = Scene_Equip.new(@actor_window.index)
      when 3  # status
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to status screen
        $scene = Scene_Status.new(@actor_window.index)
      end
      return
    end
  end
end
