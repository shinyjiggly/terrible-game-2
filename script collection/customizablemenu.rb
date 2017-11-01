#------------------------------------------------------------------------------#
#                  Advenced Customizable Default Menu System                   #
#                           By: game_guy                                       #
#                           Version: 2.1                                       #
#------------------------------------------------------------------------------#
=begin
First Note:
This is not an update on my Game_Guy's Modded Default Menu
This is a brand new menu system I made. Its really controllable in many ways.
And its already at a high version because I was gone awhile.

Updates:
v 1.0 9-1-08: Script Made
Made it possible to name all choices.
Made it possible to shoose between Playtime or Gamename Window
Allowed Changing of back_opacity of all windows

v 1.2 9-17-08:
Made it possible to name all choices without using empty actor slots
Made it possible to name the gamename without an empty actor slot
Allowed changing of opacity in windows not back_opacity but just opacity

v 1.5 10-15-08: Been ahwile since I Updated
Made it possible to have a scrolling command window must have more than 6 choices to work
Made it possible to have map as background or just a black screen

v 1.78 beta 10-21-08:
Somewhat made it possible to have certain windows on or off
Somewhat made it possible to menu status height change depending on party member count

v 1.78 10-23-08:
Fully made it possible and fixed a bug having certain windows on or off
Fully made it possible to have the menu status hegiht change depending on party member count
All it was when i had the if statemeny like so
if $playtime_gamename_window = "Off" I forgot the == 
or the if $game_party.size = 1 instead of == i put =

v 2.1 11-26-08: New Features
Made it possible for you to choose the x and y location of each window
Made it possible to change the width an hieght of the gold, steps, and playtime/gamename window
Choose to have a picture as a background or the map as background


Description:
The default menu system with new customizations and choices you can do with this
script

Features:
Customizable Choices for all choices in menu: No using actors now
Customizable Background: map as back or a picture as a background
Turn on/off windows Playtime/Gamename Gold and Steps
Choose between the playtime window or gamename window
Customizable Game name: no using an actor slot now
Customizable opacity and back_opacity for all windows
Customizable x and y locations for all windows
Menu Status Height changes depending on the amount of members you have in your party
Scrolling Command Window type thing. Have more than 6 choices it adds a scroll function from my command_window2
Now change width and height for Gold, Steps, and Playtime/Gamename Windows


Thats all for now for this version

Instructions:
By each different customization

Required Scripts:
Window_Command2 by game_guy (Me) included in script 
Window_GameName by game_guy (Me) included in script
Window_MenuStatus Modded by game_guy (Me) included in script
Window_Gold Modded by game_guy (Me) included in script
Window_Steps Modded by game_guy (Me) included in script
Window_PlayTime Modded by game_guy (Me) included in script

You need all the modded scripts because so its able to change the width and height. If you don't want these
in then just erase the modded windows.

Scripts in Script: 
The Cusotmizable Menu System(Duh)
Window_Command2(Which has a scrolling function now)
Window_GameName(Which displays a gamename without an actor now)
Window_MenuStatusModded (Which changes the height depending on the party member count)

Few Unnecessary Side Notes:
Completely Made from scratch but used a few features from my modded default menu
There's More Coding than Comments believe me I counted >.> It seemed like more comment lines than coding
Cheese is made from Cows' Milk 
And Oreos do not taste good smuthered with mustard and ketchup I've tried it >.>
Right now the way it is setup the windows are rearanged in a mirror to the
original menu and the picture is set as background and the menu has 7 choices and
steps and playtime/gamename window are off

=end

# Begin Config

# if you want to have any of these changed in game just use call-script command
# and type in xxxx = yyyy
# xxxx is the option and yyyy is what the option equals for instant
# $pic_as_back = true but you want to change it to false in game
# you would type in the script command $pic_as_back = false
# this can give people who play your game some options

$choices_item = "Inventory" # Choice for Items
$choices_skill = "Magic" # Choice for Skills
$choices_equip = "Equipment" # Choice for Equip
$choices_status = "Status" # Choice for Status
$choices_save = "Save" # Choice for Save
$choices_load = "Load" # Choice for Load
$choices_exit = "Exit" # Choice for End Game
$pic_as_back = false # If set to false, map is background
$pic_name = "Morning" # Picture name for the picture you want to use
$playtime_gamename_window = "Off" # Off will turn it off must be spelled Off not off same with On no on
$gold_window = "On" # Above applies here
$steps_window = "Off" # Above Applies here
$playtime_or_gamename = "GameName" # Want playtime window or game name window
$gamename = "Game Name Here" # You can display anything besides a game name like even a variable
# just typy in $game_variables[x] x = the variable number and erase the ""
$playtime_gamename_window_opacity = 0 # Opacity for playtime/gamename window the line that goes around the window
$playtime_gamename_window_backopacity = 0 #background opacity for gamename window
$gold_window_opacity = 255 # Same above just gold_window
$gold_window_backopacity = 100 # Same above
$steps_window_opacity = 0 # Same above just steps window
$steps_window_backopacity = 0 # same above
$command_window_opacity = 255 # same above just command window
$command_window_backopacity = 100 # same above
$menustatus_window_opacity = 255 # same above just menustatus window
$menustatus_window_backopacity = 100 # same above
$playtime_gamename_x = 480 # playtime/gamename x coordinate
$playtime_gamename_y = 224 # playtime/gamename y coordinate
$gold_window_x = 480  # Same above just gold_window
$gold_window_y = 416 # Same above
$steps_window_x = 480 # Same above just steps window
$steps_window_y = 320 # Same above
$command_window_x = 480 # same above just command window
$command_window_y = 0 # Same above
$menustatus_window_x = 0 # same above just menustatus window
$menustatus_window_y = 0 # Same above
$playtime_gamename_width = 160 # playtime/gamename widht
$playtime_gamename_height = 96 #playtime/gamename height
$gold_window_width = 160 # gold width
$gold_window_height = 64 # gold height
$steps_window_width = 160 # steps width
$steps_window_height = 96 # steps height

#------------------------------------------------------------------------------#
#                                  Windows                                     #
#------------------------------------------------------------------------------#

# For people out there who want to add more options go right ahead as the
# command menu has a scroll function thing.
# Window_Command2 which has scroll functions
class Window_Command2 < Window_Selectable
  def initialize(width, commands)
    super(0, 0, width, 224)
    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, @item_max * 32)
    refresh
    self.index = 0
  end
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i, normal_color)
    end
  end
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index])
  end
  def disable_item(index)
    draw_item(index, disabled_color)
  end
end

#window gamename # now displays game name without using an actor slot
class Window_GameName < Window_Base
  
  def initialize
    super(0, 0, $playtime_gamename_width, $playtime_gamename_height)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, 130, 64, $gamename.to_s)
  end
  
end

# Altered Window_MenuStatus so it changes height depending on party member count
class Window_MenuStatus < Window_Selectable
  
  def initialize
    super(0, 0, 480, $menu_status)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
    self.active = false
    self.index = -1
  end

  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_graphic(actor, x - 40, y + 80)
      draw_actor_name(actor, x, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x + 90, y + 32)
      draw_actor_exp(actor, x, y + 64)
      draw_actor_hp(actor, x + 236, y + 32)
      draw_actor_sp(actor, x + 236, y + 64)
    end
  end

  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, @index * 116, self.width - 32, 96)
    end
  end
end

# Window's Steps/Gold/PLaytime Modded for height and width options
class Window_Gold < Window_Base
  def initialize
    super(0, 0, $gold_window_width, $gold_window_height)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    cx = contents.text_size($data_system.words.gold).width
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 0, 120-cx-2, 32, $game_party.gold.to_s, 2)
    self.contents.font.color = system_color
    self.contents.draw_text(124-cx, 0, cx, 32, $data_system.words.gold, 2)
  end
end

class Window_PlayTime < Window_Base
  def initialize
    super(0, 0, $playtime_gamename_width, $playtime_gamename_height)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 120, 32, "Play Time")
    @total_sec = Graphics.frame_count / Graphics.frame_rate
    hour = @total_sec / 60 / 60
    min = @total_sec / 60 % 60
    sec = @total_sec % 60
    text = sprintf("%02d:%02d:%02d", hour, min, sec)
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 32, 120, 32, text, 2)
  end
  def update
    super
    if Graphics.frame_count / Graphics.frame_rate != @total_sec
      refresh
    end
  end
end

class Window_Steps < Window_Base
  def initialize
    super(0, 0, $steps_window_width, $steps_window_height)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 120, 32, "Step Count")
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 32, 120, 32, $game_party.steps.to_s, 2)
  end
end

#------------------------------------------------------------------------------#
# ** Scene_Menu Modded and Customizable                                        #
#------------------------------------------------------------------------------#
#  This class performs menu screen processing.                                 #
#------------------------------------------------------------------------------#

class Scene_Menu
  
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  
  def main
    # Command Window Setup
    s1 = $choices_item.to_s
    s2 = $choices_skill.to_s
    s3 = $choices_equip.to_s
    s4 = $choices_status.to_s
    s5 = $choices_save.to_s
    s6 = $choices_load.to_s
    s7 = $choices_exit.to_s
    @command_window = Window_Command2.new(160, [s1, s2, s3, s4, s5, s6, s7])
    @command_window.index = @menu_index
    @command_window.x = $command_window_x
    @command_window.y = $command_window_y
    @command_window.opacity = $command_window_opacity
    @command_window.back_opacity = $command_window_backopacity
    # If number of party members is 0 disable first four commands
    if $game_party.actors.size == 0
      @command_window.disable_item(0)
      @command_window.disable_item(1)
      @command_window.disable_item(2)
      @command_window.disable_item(3)
    end
    if $game_system.save_disabled
      @command_window.disable_item(5)
    end
    # Keeps track of party members and alters the MenuStatus height
    if $game_party.actors.size == 1
      $menu_status = 180
    elsif $game_party.actors.size == 2
      $menu_status = 280
    elsif $game_party.actors.size == 3
      $menu_status = 380
    else
      $menu_status = 480
    end
    # Checks to see if Save is Disabled
    # End Command Setup
    # Checks to see if $pic_as_back is on
    if $pic_as_back == true
      @sprite = Sprite.new
      @sprite.bitmap = RPG::Cache.picture($pic_name)
    else
      @map = Spriteset_Map.new
    end
    
    # Checks the gold window options
    if $gold_window == "On"
      @gold_window = Window_Gold.new
      @gold_window.x = $gold_window_x
      @gold_window.y = $gold_window_y
      @gold_window.opacity = $gold_window_opacity
      @gold_window.back_opacity = $gold_window_backopacity
    end
    
    # Checks the playtime/gamename window options
    if $playtime_gamename_window == "On"
       if $playtime_or_gamename == "GameName"
         @playtime_gamename_window = Window_GameName.new
       else
         @playtime_gamename_window = WIndow_PlayTime.new
       end
       @playtime_gamename_window.x = $playtime_gamename_x
       @playtime_gamename_window.y = $playtime_gamename_y
       @playtime_gamename_window.opacity = $playtime_gamename_window_opacity
       @playtime_gamename_window.back_opacity = $playtime_gamename_window_backopacity 
     end
     
    # Checks the steps window options
    if $steps_window == "On"
      @steps_window = Window_Steps.new
      @steps_window.x = $steps_window_x
      @steps_window.y = $steps_window_y
      @steps_window.opacity = $steps_window_opacity
      @steps_window.back_opacity = $steps_window_backopacity
    end
    # checks the menustatus window options
    @status_window = Window_MenuStatus.new
    @status_window.x = $menustatus_window_x 
    @status_window.y = $menustatus_window_y
    @status_window.opacity = $menustatus_window_opacity
    @status_window.back_opacity = $menustatus_window_backopacity
    Graphics.transition
    # Main loop
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    # checks to see what windows need to be disposed
    if $pic_as_back == true
      @sprite.dispose
      @sprite.bitmap.dispose
    else
      @map.dispose
    end
    if $gold_window == "On"
      @gold_window.dispose
    end
    if $playtime_gamename_window == "On"
      @playtime_gamename_window.dispose
    end
    if $steps_window == "On"
      @steps_window.dispose
    end
    @command_window.dispose
    @status_window.dispose
  end

  def update
    # checks to see what windows need to be updated
    if $gold_window == "On"
      @gold_window.update
    end
    if $playtime_gamename_window == "On"
      @playtime_gamename_window.update
    end
    if $steps_window == "On"
      @steps_window.update
    end
    @command_window.update
    @status_window.update
    if @command_window.active
      update_command
      return
    end
    if @status_window.active
      update_status
      return
    end
  end

  def update_command
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Map.new
      return
    end
    
    if Input.trigger?(Input::C)
      if $game_party.actors.size == 0 and @command_window.index < 4
        $game_system.se_play($data_system.buzzer_se)
        return
      end

      case @command_window.index
      when 0  
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Item.new
      when 1  
        $game_system.se_play($data_system.decision_se)
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 2  
        $game_system.se_play($data_system.decision_se)
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 3  
        $game_system.se_play($data_system.decision_se)
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 4
        if $game_system.save_disabled
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Save.new
      when 5
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Load.new
      when 6  
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_End.new
      end
      return
    end
  end

  def update_status
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @command_window.active = true
      @status_window.active = false
      @status_window.index = -1
      return
    end
    if Input.trigger?(Input::C)
      case @command_window.index
      when 1  
        if $game_party.actors[@status_window.index].restriction >= 2
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Skill.new(@status_window.index)
      when 2  
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Equip.new(@status_window.index)
      when 3  
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Status.new(@status_window.index)
      end
      return
    end
  end
end
