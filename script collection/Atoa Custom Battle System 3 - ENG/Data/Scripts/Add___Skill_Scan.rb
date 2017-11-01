#==============================================================================
# Skill Scan
# By Atoa
#==============================================================================
# With this you can create an 'scan' skill
# wich allows you to check enemy status.
#==============================================================================

module Atoa
  
  # ID of the scan skills
  Scan_Skills_ID = [109]
  
  # Enemies that can't be scanned
  No_Scan_Enemies = []
  
  # Scan text font size
  Scan_Window_Font_Size = 18
  
  # Scan_Window_Settings = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Scan_Window_Settings = [0 , 0, 352, 320, 160, false]
  
  # Image filename for window background, must be on the Windowskin folder
  Scan_Window_Bg = ''
 
  # Position of the backgroun image
  # Party_Command_Window_Bg_Postion = [Position X, Position Y]
  Scan_Window_Bg_Postion = [0 , 0]
  
  # Information shown in the window
  Scan_Infos = ['name', 'level', 'class', 'hp', 'sp', 'status', 'exp', 'element']
  # Add the name of the info you wish to show
  # 'name' = Shows target name
  # 'level' = Shows target level, for enemies check 'Scan_Enemy_Level'
  # 'class' = Shows target class, for enemies check 'Scan_Enemy_Class'
  # 'hp' = Shows target HP
  # 'sp' = Shows target SP
  # 'status = Shows target Status
  # 'exp' = Shows Exp given by target
  # 'elements' = Shows target elemental resistance
  
  # Postion of target name in the window
  Scan_Name_Postion = [0,0]
  
  # Postion of target hp in the window
  Scan_Hp_Postion = [0,52]
  
  # Postion of target sp in the window
  Scan_Sp_Postion = [0,76]
  
  # Postion of target exp in the window
  Scan_Exp_Postion = [184,0]
  
  # Postion of target status in the window
  Scan_Status_Postion = [0,104]

  # Status shown
  Scan_Status_Shown = ['atk','pdef','mdef','str','dex','int','agi']
  # Add here the name of the status you wish to show:
  # 'atk','pdef','mdef','str','dex','int','agi'
  
  # Distance between the status name and the value
  Scan_Status_Distance = 96
  
  # Postion of target level in the window
  Scan_Level_Postion = [128,0]

  # Enemies level, this have no influence in the enemy power, it's just
  # the value shown in the scan window
  # Scan_Enemy_Level = {Enemy_ID => Level}
  Scan_Enemy_Level = {1 => 1}
  
  # Postion of target class in the window
  Scan_Class_Postion = [0,24]
  
  # Enemies class, this have no influence in the enemy power, it's just
  # the value shown in the scan window
  # Scan_Enemy_Class = {Enemy_ID => Class}
  Scan_Enemy_Class = {1 => 'Undead'}
    
  # Postion of target elemental resistance in the window
  Scan_Element_Position = [196,64]
  
  # Max number of elements shown in a column, max value = 8
  Scan_Max_Elements_Shown = 8
  
  # Exhibition of elemental resistance
  Scan_Element_Resists_Exhibition = 0
  # 0 = custom exhibition
  # 1 = exhibition by numbers, value shows target resistance
  # 2 = exhibition by numbers, value damage multiplication
  
  # Elemental resist text if 'Element_Resists_Exhibition = 0'
  Scan_Element_Resist =  ['Weakest','Weak','Normal','Resist','Imune','Absorb']
  
  # Configuration of the elemental resist text color
  #                             red blue green
  Scan_Weakest_Color = Color.new(255,   0,   0)
  Scan_Weak_Color    = Color.new(255, 128,  64)
  Scan_Neutral_Color = Color.new(255, 255, 255)
  Scan_Resist_Color  = Color.new(  0, 128, 255)
  Scan_Imune_Color   = Color.new(  0, 255, 255)
  Scan_Absorb_Color  = Color.new(  0, 255,   0)
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Scan'] = true

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
  attr_accessor :target_scan
  attr_accessor :scan_count
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_scan initialize
  def initialize
    initialize_scan
    @target_scan = []
    @scan_count = 0
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :level
  attr_accessor :class_name
  #--------------------------------------------------------------------------
  # * Get level
  #--------------------------------------------------------------------------
  def level
    return Scan_Enemy_Level[@enemy_id] if Scan_Enemy_Level.include?(@enemy_id)
    return 1
  end
  #--------------------------------------------------------------------------
  # Definir nome da Classe
  #--------------------------------------------------------------------------
  def class_name
    return Scan_Enemy_Class[@enemy_id] if Scan_Enemy_Class.include?(@enemy_id)
    return ''
  end
end

#==============================================================================
# ** Window_Scan
#------------------------------------------------------------------------------
#  This window shows enemy information
#==============================================================================

class Window_Scan < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     battler : battler
  #--------------------------------------------------------------------------
  def initialize(battler)
    x,y = Scan_Window_Settings[0], Scan_Window_Settings[1]
    w,h = Scan_Window_Settings[2], Scan_Window_Settings[3]
    super(x,y,w,h)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4950
    if Scan_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Scan_Window_Bg)
      @background_image.x = self.x + Scan_Window_Bg_Postion[0]
      @background_image.y = self.y + Scan_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    self.back_opacity = Scan_Window_Settings[4]
    self.opacity = Scan_Window_Settings[4] if Scan_Window_Settings[5]
    @battler = battler
    refresh
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
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.size = Scan_Window_Font_Size
    fake = (No_Scan_Enemies.include?(@battler.id) and not @battler.actor?)
    if Scan_Infos.include?('name')
      draw_actor_name(@battler, Scan_Name_Postion[0], Scan_Name_Postion[1])
    end
    if Scan_Infos.include?('class')
      draw_actor_class(@battler, Scan_Class_Postion[0], Scan_Class_Postion[1])
    end
    if Scan_Infos.include?('element')
      draw_element_resist(@battler, Scan_Element_Position[0], Scan_Element_Position[1])
    end
    if Scan_Infos.include?('level')
      draw_actor_level(@battler, Scan_Level_Postion[0], Scan_Level_Postion[1], fake)
    end
    if Scan_Infos.include?('hp')
      draw_actor_hp(@battler, Scan_Hp_Postion[0], Scan_Hp_Postion[1], 160, fake)
    end
    if Scan_Infos.include?('sp')
      draw_actor_sp(@battler, Scan_Sp_Postion[0], Scan_Sp_Postion[1], 160, fake)
    end
    if Scan_Infos.include?('status')
      for i in 0...Scan_Status_Shown.size
        draw_actor_parameter(@battler, Scan_Status_Postion[0], 
          Scan_Status_Postion[1] + i * (Scan_Window_Font_Size + 2), Scan_Status_Shown[i], 
          Scan_Status_Distance, fake)
      end
    end
    if Scan_Infos.include?('exp') and not @battler.actor?
      x, y = Scan_Exp_Postion[0], Scan_Exp_Postion[1]
      self.contents.draw_text(x, y, 72, 32, 'Exp:')
      exp = fake ? '?????' : @battler.exp.to_s
      self.contents.draw_text(x, y, 128, 32, exp, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Name
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, x, y)
    self.contents.font.size = Scan_Window_Font_Size
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 120, 32, actor.name)
  end
  #--------------------------------------------------------------------------
  # * Draw Class
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y)
    self.contents.font.size = Scan_Window_Font_Size
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 236, 32, actor.class_name)
  end
  #--------------------------------------------------------------------------
  # * Draw Level
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_level(actor, x, y, fake = false)
    self.contents.font.size = Scan_Window_Font_Size
    self.contents.font.color = system_color
    name = 'Nv'
    size = contents.text_size(name).width
    self.contents.draw_text(x, y, size + 4, 32, name)
    self.contents.font.color = normal_color
    level = fake ? '??' : actor.level.to_s
    self.contents.draw_text(x + size, y, 24, 32, level, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Parameter
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : parameter type
  #     w     : width
  #     fake  : hide parameter
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type, w = 132, fake = false)
    case type
    when 'atk'
      parameter_name = $data_system.words.atk
      parameter_value = actor.atk
    when 'pdef'
      parameter_name = $data_system.words.pdef
      parameter_value = actor.pdef
    when 'mdef'
      parameter_name = $data_system.words.mdef
      parameter_value = actor.mdef
    when 'str'
      parameter_name = $data_system.words.str
      parameter_value = actor.str
    when 'dex'
      parameter_name = $data_system.words.dex
      parameter_value = actor.dex
    when 'agi'
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 'int'
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 'eva'
      parameter_name = Stat_Eva
      parameter_value = actor.eva
    when 'hit'
      parameter_name = Stat_Hit
      parameter_value = actor.hit
    when 'crt'
      parameter_name = Stat_Crt
      parameter_value = actor.crt
    when 'dmg'
      parameter_name = Stat_Dmg
      parameter_value = actor.dmg
    when 'rcrt'
      parameter_name = Stat_Res_Crt
      parameter_value = actor.rcrt
    when 'rdmg'
      parameter_name = Stat_Res_Dmg
      parameter_value = actor.rdmg
    end
    self.contents.font.size = Scan_Window_Font_Size
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, w + 32, 32, parameter_name)
    self.contents.font.color = normal_color
    status = fake ? '???' : parameter_value.to_s
    self.contents.draw_text(x + w, y, 64, 32, status, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw HP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #     fake  : hide parameter
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 144, fake = false)
    self.contents.font.size = Scan_Window_Font_Size
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.hp)
    self.contents.font.color = actor.hp == 0 ? knockout_color :
      actor.hp <= actor.maxhp / 4 ? crisis_color : normal_color
    hp_x = x + width - 108
    hp = fake ? '????' : actor.hp.to_s
    self.contents.draw_text(hp_x, y, 48, 32, hp, 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(hp_x + 48, y, 12, 32, '/', 1)
    self.contents.font.bold = true
    maxhp = fake ? '????' : actor.maxhp.to_s
    self.contents.draw_text(hp_x + 60, y, 48, 32, maxhp)
    self.contents.font.bold = false
  end
  #--------------------------------------------------------------------------
  # * Draw SP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #     fake  : hide parameter
  #--------------------------------------------------------------------------
  def draw_actor_sp(actor, x, y, width = 144, fake = false)
    self.contents.font.size = Scan_Window_Font_Size
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.sp)
    self.contents.font.color = actor.sp == 0 ? knockout_color :
      actor.sp <= actor.maxsp / 4 ? crisis_color : normal_color
    sp_x = x + width - 108
    sp = fake ? '????' : actor.sp.to_s
    self.contents.draw_text(sp_x, y, 48, 32, sp, 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(sp_x + 48, y, 12, 32, '/', 1)
    self.contents.font.bold = true
    maxsp = fake ? '????' : actor.maxsp.to_s
    self.contents.draw_text(sp_x + 60, y, 48, 32, maxsp)
    self.contents.font.bold = false
  end
  #--------------------------------------------------------------------------
  # * Draw elemental resistance
  #     battler : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_element_resist(battler, x, y)
    self.contents.font.size = Scan_Window_Font_Size
    max_elment = [Scan_Max_Elements_Shown, 8].min
    y = y + (200 - (max_elment * 25)) / 2
    if battler.actor? and not $atoa_script['Atoa New Resistances']
      elements = $data_classes[battler.class_id].element_ranks
    elsif battler.actor? and $atoa_script['Atoa New Resistances']
      elements = battler.elemental_resist
    else
      elements = $data_enemies[battler.id].element_ranks
    end
    base = value = 0
    case Scan_Element_Resists_Exhibition
    when 0
      table = [0] + Scan_Element_Resist
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
          self.contents.font.color = Scan_Weakest_Color
        when 2
          self.contents.font.color = Scan_Weak_Color
        when 3
          self.contents.font.color = Scan_Neutral_Color
        when 4
          self.contents.font.color = Scan_Resist_Color
        when 5
          self.contents.font.color = Scan_Imune_Color
        when 6
          self.contents.font.color = Scan_Absorb_Color
        end
        case Scan_Element_Resists_Exhibition
        when 0
          self.contents.draw_text(x + 28 + (base * 112), y - 4 + (value * 25), 180, 32, 
            result.to_s, 0)
        else
          self.contents.draw_text(x + (base * 112), y - 4 + (value * 25), 72, 32, 
            result.to_s, 2)
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
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part1_scan step4_part1
  def step4_part1(battler)
    if battler.now_action.is_a?(RPG::Skill) and
       Scan_Skills_ID.include?(now_id(battler))
      for target in battler.target_battlers
        battler.target_scan << target unless battler.target_scan.include?(target)
      end
    end
    step4_part1_scan(battler)
  end
  #--------------------------------------------------------------------------
  # * Check no damage
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  alias no_damage_scan no_damage
  def no_damage(battler, target)
    return true if battler.target_scan.include?(target)
    return no_damage_scan(battler, target)
  end
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  alias update_graphics_scan update_graphics
  def update_graphics
    update_graphics_scan
    update_scan
  end
  #--------------------------------------------------------------------------
  # * Update scan window
  #--------------------------------------------------------------------------
  def update_scan
    for battler in $game_party.actors + $game_troop.enemies
      if battler.target_scan.size > 0 and battler.dead? and @scan_window != nil
        if battler.target_scan.include?(@scan_window.battle)
          @scan_window.dispose
          @scan_window = nil
        end
        battler.target_scan.clear
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part3_scan step4_part3
  def step4_part3(battler)
    if battler.now_action.is_a?(RPG::Skill) and 
       Scan_Skills_ID.include?(now_id(battler))
      if @scan_window.nil?
        @help_window.visible = false
        @scan_window = Window_Scan.new(battler.target_scan.shift)
        battler.scan_count = 0
      elsif
        battler.scan_count += 1
      end
      if (Input.trigger?(Input::C) and battler.scan_count > 30) or 
         ($atoa_script['Atoa ATB'] and battler.scan_count > 90)
        if @scan_window != nil
          @scan_window.dispose
          @scan_window = nil
        end
      end
      return unless battler.target_scan.empty? and @scan_window.nil?
    end
    step4_part3_scan(battler)
  end
  #--------------------------------------------------------------------------
  # * Dispose windows
  #--------------------------------------------------------------------------
  alias windows_dispose_scan windows_dispose if $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
  def windows_dispose
    windows_dispose_scan
    if @scan_window != nil
      @scan_window.dispose
      @scan_window = nil
    end
  end
end