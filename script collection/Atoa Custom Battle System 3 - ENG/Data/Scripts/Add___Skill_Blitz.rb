#==============================================================================
# Skill Blitz
# By Atoa
# Based on Claimh Blitz Script
#==============================================================================
# With this script, you must make an command input before the skills
#
# When the input fail, the skill may fail or have the damage reduce.
# (it can be set individually for each skill)
#==============================================================================

module Atoa
  # Do not remove or change this line
  Blitz_Skill = {}
  # Do not remove or change this line

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

  # Time for each input
  Key_Sec = 1.0
  
  #  Blitz_Window_Settings = [Width, Height, Opacity, Trasparent Edge]
  Blitz_Window_Settings = [280, 128, 160, false]
  
  # Image filename for window backgeound, must be on the Windowskin folder
  Blitz_Window_Bg = ''
 
  # Position of the backgroun image
  # Blitz_Window_Bg_Postion = [Position X, Position Y]
  Blitz_Window_Bg_Postion = [0 , 0]
  
  # Configuration of the text input exhibition (if Input_Images = false).
  Keyboard_Type = true
  # true = keyboard exhibition (Ex.: X = keyboard X)
  # false = input exhibition (Ex.: X = keyboard A)
  
  # Show input entry with images
  Input_Images = true
  
  # Settings for comand entry images
  # The images must be on the windowsing folder.
  # Besides the images with names set here, you will need images with
  # *the same file name* + 'in' to show the commands already inputed
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
  
  # Settings for command input for skill with cast time
  # Works only with the scripts Atoa ATB our Atoa CTB
  Blitz_Aftercast = false
  # true = Command Input is made after cast time
  # false = Command Input is made before cast time
  
  # Graphic file name of the Blitz Bar, must be on the Graphic/Windowskins folder
  Blitz_Bar_Name = 'BLITZMeter'

  # Postion of the commands exhibition on the window
  Input_Display_Position = [0, 48]

  # Type of Bar advance.
  Bar_Advance_Type = 0
  # 0 = the bar increase
  # 1 = the bar decrease

  # Input display position
  Window_Display_Position = 2
  # 0 = Default, not centralized
  # 1 = Default, centralized
  # 2 = Above Battler
  # 3 = custom
  
  # Postion of the input display if Input_Display_Position = 2
  Custom_Diplay_Postion = [[320,180],[320,180],[320,180],[320,180]]
    
  # Show Success/Fail message?
  Show_Success_Fail = false
  Success_Fail_Position = [0, 48]
  
  # Show actor name on the window?
  Show_Actor_Name = true
  Actor_Name_Position = [0, 0]
  
  # Show skill name on the window?
  Show_Skill_Name = true
  Skill_Name_Position = [0, 24]

  # Sound file used when the input fails
  Input_Fail_Sound = '003-System03'
  
  # Sound file used when the input succeceds
  Input_Success_Sound = '007-System07'
  
  # Message shown when the input fails
  Input_Fail_Message = 'Failed'
  
  # Message shown when the input succeceds
  Input_Success_Message = 'Success!'
    
  # Skill setting
  # Skill ID => [[Key 1, Key 2,...], Cancel, Power, Fail Anim)]
  # Skill_ID: ID of the Skill
  # Key 1, Key 2,...: Input order.
  # Cancel: set if the skill will canceled
  #   true = the skill isn't used if the input fail
  #   false = the skill is used even if the input fail
  # Power: Power rate if the input fail, only valid if Cancel = false
  # Fail Anim: ID of the animation used when the input fails, nil or 0 for no anim
  Blitz_Skill[7] = [[UP,DOWN], true, 50, 4]
  Blitz_Skill[8] = [[X,C,Z], true, 50, 4]
  Blitz_Skill[9] = [[DOWN,X,A,B], true, 50, 4]
  Blitz_Skill[10] = [[LEFT,UP], true, 50, 4]
  Blitz_Skill[11] = [[L,X,R], true, 50, 4]
  Blitz_Skill[12] = [[X,C,RIGHT,R], true, 50, 4]
  Blitz_Skill[13] = [[UP,RIGHT], true, 50, 4]
  Blitz_Skill[14] = [[L,Z,A], true, 50, 4]
  Blitz_Skill[15] = [[R,X,X,DOWN], true, 50, 4]
  Blitz_Skill[16] = [[DOWN, RIGHT], true, 50, 4]
  Blitz_Skill[17] = [[A,B,C], true, 50, 4]
  Blitz_Skill[18] = [[Y,X,DOWN,B], true, 50, 4]
  Blitz_Skill[19] = [[LEFT,DOWN], true, 50, 4]
  Blitz_Skill[20] = [[Z,Y,A], true, 50, 4]
  Blitz_Skill[21] = [[B,C,X,L], true, 50, 4]
  Blitz_Skill[22] = [[RIGHT,DOWN], true, 50, 4]
  Blitz_Skill[23] = [[A,B,R], true, 50, 4]
  Blitz_Skill[24] = [[X,Y,LEFT,R], true, 50, 4]
  Blitz_Skill[25] = [[LEFT,RIGHT], true, 50, 4]
  Blitz_Skill[26] = [[X,L,B], true, 50, 4]
  Blitz_Skill[27] = [[LEFT,X,C,Z], true, 50, 4]
  Blitz_Skill[28] = [[LEFT,DOWN], true, 50, 4]
  Blitz_Skill[29] = [[C,X,A], true, 50, 4]
  Blitz_Skill[30] = [[X,Z,C,UP], true, 50, 4]
  Blitz_Skill[31] = [[UP,DOWN,X], true, 50, 4]
  Blitz_Skill[32] = [[LEFT,RIGHT,L,R], true, 50, 4]
  Blitz_Skill[57] = [[A, C], true, 50, 4]
  Blitz_Skill[58] = [[C, X, UP], true, 50, 4]
  Blitz_Skill[59] = [[A, UP, RIGHT, A], true, 50, 4]
  Blitz_Skill[60] = [[Z, C, A, B], true, 50, 4]
  Blitz_Skill[61] = [[X, C], true, 50, 4]
  Blitz_Skill[62] = [[UP, X, DOWN], true, 50, 4]
  Blitz_Skill[63] = [[LEFT, C, Y, A], true, 50, 4]
  Blitz_Skill[64] = [[X, C, Y, A], true, 50, 4]
  Blitz_Skill[65] = [[Y, A], true, 50, 4]
  Blitz_Skill[66] = [[RIGHT, B, A], true, 50, 4]
  Blitz_Skill[67] = [[LEFT, UP, Z, A], true, 50, 4]
  Blitz_Skill[68] = [[Y, B, Y, A], true, 50, 4]
  Blitz_Skill[69] = [[LEFT, A], true, 50, 4]
  Blitz_Skill[70] = [[A, C, A], true, 50, 4]
  Blitz_Skill[71] = [[B, B, A, A], true, 50, 4]
  Blitz_Skill[72] = [[A, B, X, Y], true, 50, 4]
  Blitz_Skill[73] = [[X, A], true, 50, 4]
  Blitz_Skill[74] = [[Y, A, B], true, 50, 4]
  Blitz_Skill[75] = [[LEFT, RIGHT, Y, A], true, 50, 4]
  Blitz_Skill[76] = [[A, C, L, A], true, 50, 4]
  Blitz_Skill[77] = [[R, X], true, 50, 4]
  Blitz_Skill[78] = [[L, C, R], true, 50, 4]
  Blitz_Skill[79] = [[LEFT, L, RIGHT, R], true, 50, 4]
  Blitz_Skill[80] = [[C, C, Z, RIGHT], true, 50, 4]

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Blitz'] = true

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
  attr_accessor   :blitz_flag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_blitz initialize
  def initialize
    initialize_blitz
    @blitz_flag = false
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_blitz set_damage
  def set_damage(user, action = nil)
    set_damage_blitz(user, action)
    if $scene.is_a?(Scene_Battle) and action.is_a?(RPG::Skill) and user.blitz_flag and
       user.target_damage[self].numeric?
      user.target_damage[self] = (user.target_damage[self] * Blitz_Skill[action.id][2]) / 100
    end
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_blitz step2_part1
  def step2_part1(battler)
    step2_part1_blitz(battler)
    battler.blitz_flag = false
    if battler.actor? and battler.skill_use? and
       Blitz_Skill[battler.current_action.skill_id] != nil
      if ($atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB'])
       return if Blitz_Aftercast and battler.casting
       return if !Blitz_Aftercast and !battler.casting
      end
      result = make_blitz_result(battler)
      if result and Blitz_Skill[battler.current_action.skill_id][1]  
        blitz_fail_anime(battler, battler.current_action.skill_id)
        battler.consume_skill_cost($data_skills[battler.current_action.skill_id])
        battler.current_phase = 'Phase 5-1'
        if $atoa_script['Atoa ATB']
          battler.cast_action = nil
        elsif $atoa_script['Atoa CTB']
          battler.cast_action = nil
          set_action_cost(battler)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Input fail animation
  #     battler  : battler
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def blitz_fail_anime(battler, skill_id)
    unless Blitz_Skill[battler.current_action.skill_id][3].nil? or
           Blitz_Skill[battler.current_action.skill_id][3] == 0
      battler.animation_id = Blitz_Skill[battler.current_action.skill_id][3]
      battler.animation_hit = true
      battler.wait_time = $data_animations[battler.animation_id].frame_max * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Make input result
  #     battler  : battler
  #--------------------------------------------------------------------------
  def make_blitz_result(battler)
    blitz = Blitz_Skill[battler.current_action.skill_id][0]
    time = Key_Sec * blitz.size * Graphics.frame_rate
    battler.blitz_flag = true
    pos = set_blitz_window_position(battler)
    imgw = RPG::Cache.windowskin(Blitz_Bar_Name).width
    skill = $data_skills[battler.current_action.skill_id].name
    @window_keycount = Window_KeyCount.new(blitz, battler.name, skill, pos[0], pos[1])
    @window_counter = Window_KeyCounter.new(pos[0], pos[1] + 80, imgw + 32, 64)
    update_blitz_input(battler, time, skill, imgw, blitz)
    @window_keycount.dispose
    @window_counter.dispose
    @window_keycount = nil
    @window_counter = nil
    return battler.blitz_flag
  end
  #--------------------------------------------------------------------------
  # * Set input windo postion
  #     battler  : Lutador
  #--------------------------------------------------------------------------
  def set_blitz_window_position(battler)
    case Window_Display_Position
    when 0 
      x = (battler.index * 156) - (battler.index * 38)
      y = 192
    when 1 
      x = (((640 / Max_Party) * ((4 - $game_party.actors.size) / 2.0 + battler.index)).floor) - (battler.index * 40)
      y = 192
    when 2
      x = battler.base_x - 160
      y = battler.base_y - 64
    when 3 
      x = Custom_Diplay_Postion[battler.index][0]
      y = Custom_Diplay_Postion[battler.index][1]
    end
    return [x, y]
  end
  #--------------------------------------------------------------------------
  # * Update blitz input
  #     battler : battler
  #     time    : time
  #     skill   : skill
  #     imgw    : width
  #     blitz   : commands
  #--------------------------------------------------------------------------
  def update_blitz_input(battler, time, skill, imgw, blitz)
    key_count = 0
    for i in 0...time
      if battler.dead?
        @window_keycount.dispose
        @window_counter.dispose
        break 
      end
      if Input.trigger?(blitz[key_count])
        key_count += 1
        @window_keycount.key_in(battler.name, skill)
        $game_system.se_play($data_system.cursor_se)
      elsif Input.n_trigger?(blitz[key_count])
        break
      end
      if key_count >= blitz.size
        if Show_Success_Fail
          @window_keycount.text_in(Input_Success_Message, battler.name, skill)
        end
        $game_system.se_play(RPG::AudioFile.new(Input_Success_Sound))
        battler.blitz_flag = false
        break
      end
      @window_counter.refresh((i * imgw / time), imgw)
      update_graphics
    end
    if battler.blitz_flag
      if Show_Success_Fail
        @window_keycount.text_in(Input_Fail_Message, battler.name, skill)
      end
      $game_system.se_play(RPG::AudioFile.new(Input_Fail_Sound))
    end
  end
end

#==============================================================================
# ** Window_KeyCounter
#------------------------------------------------------------------------------
# Window that shows the time input time meter
#==============================================================================

class Window_KeyCounter < Window_Base
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
    self.opacity = 0
    self.z = 4000
    refresh(0, width - 32)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #     current : current width
  #     w       : max width
  #--------------------------------------------------------------------------
  def refresh(current, w)
    self.contents.clear
    draw_counter_bar(0, 0, current) if Bar_Advance_Type == 0
    draw_counter_bar(0, 0, w - current) if Bar_Advance_Type == 1
  end
  #--------------------------------------------------------------------------
  # * Draw Time bar
  #     x       : window x-coordinate
  #     y       : window y-coordinate
  #     current : current width
  #--------------------------------------------------------------------------
  def draw_counter_bar(x, y, current)
    bitmap = RPG::Cache.windowskin(Blitz_Bar_Name)
    cw = bitmap.width
    ch = bitmap.height / 2
    src_rect = Rect.new(0, 0, cw, ch)
    self.contents.blt(x, y, bitmap, src_rect)
    cw = bitmap.width * current / bitmap.width
    src_rect = Rect.new(0, ch, cw, ch)
    self.contents.blt(x, y, bitmap, src_rect)
  end
end

#==============================================================================
# ** Window_KeyCount
#------------------------------------------------------------------------------
# Window that shows the input info
#==============================================================================

class Window_KeyCount < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     key     : inputs
  #     battler : battler
  #     skill   : skill
  #     x       : window x-coordinate
  #     y       : window y-coordinate
  #--------------------------------------------------------------------------
  def initialize(key, battler, skill, x, y)
    super(x, y, Blitz_Window_Settings[0], Blitz_Window_Settings[1])
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = Blitz_Window_Settings[2]
    self.opacity = Blitz_Window_Settings[2] if Blitz_Window_Settings[3] 
    self.z = 4000
    if Blitz_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Blitz_Window_Bg)
      @background_image.x = self.x + Blitz_Window_Bg_Postion[0]
      @background_image.y = self.y + Blitz_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    @key = key
    @key_count = 0
    create_input_images if Input_Images
    refresh(battler, skill)
  end
  #--------------------------------------------------------------------------
  # * Create Input Images
  #--------------------------------------------------------------------------
  def create_input_images
    images = [A_Image, B_Image, C_Image, X_Image, Y_Image, Z_Image, L_Image,
              R_Image, UP_Image, DOWN_Image, LEFT_Image, RIGHT_Image]
    @images_bitmaps = {}
    for img in images
      @images_bitmaps[img] = RPG::Cache.windowskin(img)
      @images_bitmaps[img + "in"] = RPG::Cache.windowskin(img + "in")
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #     battler : battler
  #     skill   : skill
  #--------------------------------------------------------------------------
  def refresh(battler, skill)
    self.contents.clear
    draw_info(battler, skill)
    for i in 0...@key.size
      if Input_Images
        inputed = i < @key_count ? 'in' : ''
        bitmap = @images_bitmaps[Input.key_image(@key[i]) + inputed]
        rect = Rect.new(0, 0, bitmap.width, bitmap.height)
        x = i * bitmap.width
        self.contents.blt(Input_Display_Position[0] + x, Input_Display_Position[1], bitmap, rect)
      else
        x = i * 32 
        self.contents.font.color = i < @key_count ? knockout_color : normal_color
        self.contents.draw_text(x, 48, 100, 32, Input.key_converter(@key[i]))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Key input
  #     battler : battler
  #     skill   : skill
  #--------------------------------------------------------------------------
  def key_in(battler, skill)
    @key_count += 1
    refresh(battler, skill)
  end
  #--------------------------------------------------------------------------
  # * Draw Info
  #     battler : battler
  #     skill   : skill
  #--------------------------------------------------------------------------
  def draw_info(battler, skill)
    if Show_Actor_Name
      self.contents.font.color = normal_color
      self.contents.draw_text(Actor_Name_Position[0], Actor_Name_Position[1], 240, 32, battler)
    end
    if Show_Skill_Name
      self.contents.font.color = system_color
      self.contents.draw_text(Skill_Name_Position[0], Skill_Name_Position[1], 240, 32, skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Info Text
  #     text    : text
  #     battler : battler
  #     skill   : skill
  #--------------------------------------------------------------------------
  def text_in(text, battler, skill)
    self.contents.clear
    draw_info(battler, skill)
    self.contents.font.color = text == Input_Success_Message ? crisis_color : knockout_color
    self.contents.draw_text(Success_Fail_Position[0], Success_Fail_Position[1], 240, 32, text)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @background_image.dispose if @background_image != nil
  end
end