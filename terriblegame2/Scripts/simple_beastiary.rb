#==============================================================================
# Beastary Version 1.0
# Date 5/1/07
# Made by BChimself
#------------------------------------------------------------------------------
# PLEASE READ! The beastary draws monster IDs from ingame variable # 1
# It is important that you set all variables in this script to a blank
# variable ingame for this use. If you get a WARNING message this may be
# the variables are crossed! I have marked what will need to be changed
# if you need to change the variables! Infact Every that you may want
# to or need to change is marked in a comment to the right!
# Enjoy!~ =p
#==============================================================================
class Beastary_Scene
  
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  
  def main
    @mobs_max = 10 #IMPORTANT TO CHANGE THIS!!!!
    @mobs_min = 1 #Where the list starts. Doesnt have to be 1!
    $game_variables[26] = @mobs_min #Change the [26] to your variable!
    @window_b1=Beastary_Window_1.new
    @window_b1.update(false)
    @window_b1.x=200
    @window_b1.y=60
    @window_b3=Beastary_Window_3.new
    @window_b3.update(" ")
    
    s1= "Next"
    s2= "Previous"
    s3= "Exit"
    @window_b2=Window_Command.new(200, [s1,s2,s3])
    @window_b2.y=60
    @window_b2.height=420
    @window_b2.index=@menu_index
    
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    
    Graphics.freeze
    @window_b1.dispose
    @window_b2.dispose
    @window_b3.dispose
  end
  
  def update
      
    @window_b2.update
    case @window_b2.index
      when 0
        @window_b3.update("==>")
      when 1
        @window_b3.update("<==")
      when 2
        @window_b3.update("Exit menu")
    end
    
    if Input.trigger?(Input::C) #ENTER
    case @window_b2.index
      when 0
        nexts #like this for a reason!
      when 1
        previous
      when 2
        exit
    end
  end
  
  if Input.trigger?(Input::B) #ESC
    $game_system.se_play($data_system.cancel_se)
    $scene=Scene_Map.new
    $game_map.autoplay
  end
end
#------------------------------------------------------------------------------
  def nexts
    if $game_variables[26] < @mobs_max
      $game_system.se_play($data_system.decision_se)
      $game_variables[26] += 1
      @window_b1.update(" ")
    else
      $game_system.se_play($data_system.buzzer_se)
    end
  end
    
  def previous
    if $game_variables[26] > @mobs_min
      $game_system.se_play($data_system.decision_se)
      $game_variables[26] -= 1
      @window_b1.update(" ")
    else
      $game_system.se_play($data_system.buzzer_se)
    end
  end
  
  def exit
    $game_system.se_play($data_system.cancel_se)
    $scene=Scene_Map.new
    $game_map.autoplay
  end
#==============================================================================
#                      Window 1 will show enemy data.
#                You will also need to change the variable
#                here if the its already in use. Just Creat
#                A new variable with in the game and name it
#               Monster ID or what ever. Change where it says.
#==============================================================================
class Beastary_Window_1 < Window_Base
  
  def initialize
    if $game_variables[26] <= 0 #Change the [26] to your variable!
      print "WARNING: Game will crash due to variables not set properly!"
    end
    if $game_variables[26] >= 1 #Change the [26] to your variable!
      super(0,0,440,420)
      self.contents = Bitmap.new(width-32,height-32)
      set_default_font
      #self.contents.font.name = "PlopDump" #This is the font used. I wouldn't change this.
      #self.contents.font.size = 20
    end
    
    def update(content)
      @mob_id = $data_enemies[$game_variables[26]].name #Change the [26] to your variable!
      @mob_maxhp = $data_enemies[$game_variables[26]].maxhp #Change the [26] to your variable!
      @mob_maxsp = $data_enemies[$game_variables[26]].maxsp #Change the [26] to your variable!
      @mob_exp = $data_enemies[$game_variables[26]].exp #Change the [26] to your variable!
      @mob_str = $data_enemies[$game_variables[26]].str #Change the [26] to your variable!
      @mob_dex = $data_enemies[$game_variables[26]].dex #Change the [26] to your variable!
      @mob_agi = $data_enemies[$game_variables[26]].agi #Change the [26] to your variable!
      @mob_int = $data_enemies[$game_variables[26]].int #Change the [26] to your variable!
      @mob_atk = $data_enemies[$game_variables[26]].atk #Change the [26] to your variable!
      @mob_pdef = $data_enemies[$game_variables[26]].pdef #Change the [26] to your variable!
      @mob_mdef = $data_enemies[$game_variables[26]].mdef #Change the [26] to your variable!
      @mob_eva = $data_enemies[$game_variables[26]].eva #Change the [26] to your variable!

      self.contents.clear
      self.contents.font.color = text_color(0) #This will change text color. Its red by default. Use the numbers 0-7.
      self.contents.draw_text(0,0,300,32, @mob_id)
      self.contents.font.color = text_color(2) #This will change text color. Its red by default. Use the numbers 0-7.
      #self.contents.draw_text(0,30,300,32,"HP("+@mob_maxhp.to_s+")/SP("+@mob_maxsp.to_s+")/EXP("+@mob_exp.to_s+")")
      self.contents.draw_text(0,30,300,32,"HP: "+@mob_maxhp.to_s+" ")
      self.contents.draw_text(0,50,300,32,"MP: "+@mob_maxsp.to_s+" ")
      self.contents.draw_text(0,70,300,32,"EXP: "+@mob_exp.to_s+" ")
      self.contents.font.color = text_color(1)
      self.contents.draw_text(0,90,300,32,"---------------------")
      self.contents.font.color = text_color(2)
      self.contents.draw_text(0,110,300,32,"STR: "+@mob_str.to_s+" ")
      self.contents.draw_text(0,130,300,32,"DEX: "+@mob_dex.to_s+" ")
      self.contents.draw_text(0,150,300,32,"SPD: "+@mob_agi.to_s+" ")
      self.contents.draw_text(0,170,300,32,"MAG: "+@mob_int.to_s+" ")
      self.contents.draw_text(0,190,300,32,"ATK: "+@mob_atk.to_s+" ")
      self.contents.draw_text(0,210,300,32,"DEF: "+@mob_pdef.to_s+" ")
      self.contents.draw_text(0,230,300,32,"MDEF: "+@mob_mdef.to_s+" ")
      self.contents.draw_text(0,250,300,32,"EVA: "+@mob_eva.to_s+" ")
      self.contents.font.color = text_color(1)
      self.contents.draw_text(0,270,300,32,"---------------------")
    end
              
  end
end
#==============================================================================
# Window 3 Help menu
#==============================================================================
class Beastary_Window_3 < Window_Base
  
  def initialize
    
    super(0,0,640,60)
    self.contents=Bitmap.new(width-32,height-32)
    self.contents.font.name = "PlopDump"
    self.contents.font.size = 20
    
  end
  
  def update(help_text)
    self.contents.clear
    self.contents.draw_text(0,0,440,32, help_text)
  end
end
end