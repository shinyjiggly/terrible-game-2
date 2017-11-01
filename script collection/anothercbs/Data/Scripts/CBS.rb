#--------------------------------------------------------------------------
# ™Sideview battle simple English version 
#
#    (C) copyright by http://rye.jp/     Date 2007/01/12    Ver alpha
#--------------------------------------------------------------------------
#  Side view battle script walking graphic version      Special Thanks by blz
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
#  Standard of graphic file
#--------------------------------------------------------------------------
#  battler graphics
#  
#  @Walking graphic is used as it is.
#  @ 
#  weapon graphics
#  
#  @The icon graphic of arms is used as it is.       
#      

  
module Side_view
  #--------------------------------------------------------------------------
  # œ Using together RTAB@™Automatic recognition
  #--------------------------------------------------------------------------
  if Scene_Battle.method_defined?("synthe?")
    RTAB = true
  else
    RTAB = false
  end
  #--------------------------------------------------------------------------
  # œ Using together RTAB cam ™Automatic recognition
  #--------------------------------------------------------------------------
  def camera_correctness
    return false if !RTAB
    begin 
      return $scene.drive
    rescue
      return false
    end
  end
  #--------------------------------------------------------------------------
  # œ The maximum number of parties
  #--------------------------------------------------------------------------
  Party_max = 4
  #--------------------------------------------------------------------------
  # œ Expansion rate of Battler graphic(actor exclusive use)
  #--------------------------------------------------------------------------
  CHAR_ZOOM = 1.0
  #--------------------------------------------------------------------------
  # œ Arrow cursor position correction
  #--------------------------------------------------------------------------
  ARROW_OX = 0
  ARROW_OY = 64
  #--------------------------------------------------------------------------
  # œ State name treated as flight (Array)
  #--------------------------------------------------------------------------
  FLY_STATES = ["Flying"]
  #--------------------------------------------------------------------------
  # œ Positional correction of combat screen party
  #--------------------------------------------------------------------------
  PARTY_X = 480     # X position of party
  PARTY_Y = 200     # Y position of party
  FORMATION_X = 32  # actor's interval X
  FORMATION_Y = 38  # actor's interval Y
  #--------------------------------------------------------------------------
  # œ ƒJƒXƒ^ƒ}ƒCƒY’è”
  #--------------------------------------------------------------------------
  NORMAL   = "NORMAL"
  WALK_R   = "WALK_R"
  WALK_L   = "WALK_L"
  ATTACK   = "ATTACK"
  ATTACK_R = "ATTACK_R"
  ATTACK_L = "ATTACK_L"
  MAGIC    = "MAGIC"
  ITEM     = "ITEM"
  # ƒAƒjƒ‚ÌÝ’è
  ANIME = { 
    # [id,Loop?,speed,weapon visible,pattern freeze,Weapon Right or Left(using RTAB)]
    NORMAL            => [1,true , 0,false, true ,""    ], # Standby usually
    WALK_R            => [2,true , 6,false, false,""    ], # move Right
    WALK_L            => [1,true , 6,false, false,""    ], # move Left
    ATTACK_R          => [1,false, 6,true , false,"Right"],# attack by Right hand
    ATTACK_L          => [1,false, 6,true , false,"Left"], # attack by Left hand
    MAGIC             => [1,false, 6,false, false,""    ], # spell Magic
    ITEM              => [1,false, 6,false, false,""    ], # using Item
    }
    
  # default (Do not change it)  
  ANIME.default = [1,false,12,false,"",""]
  
  # ƒAƒNƒVƒ‡ƒ“Ý’è‚ÌŠÖ˜A•t‚¯
  ACTION_LIB = { 
    "Hero Move"            => "moving_setup",
    "Hero Graphic Change"  => "change",
    "Throw Animation"      => "flying",
    "main phase step 3"    => "animation1",
    "main phase step 4"    => "animation2",
    "Waiting"              => "wait",
    "Graphic Reverse"      => "reverse",
    "Afterimage ON"        => "shadow_on",
    "Afterimage OFF"       => "shadow_off",
    "Freeze ON"            => "freeze",
    "Freeze OFF"           => "freeze_lifting",
    "Display Animation"    => "animation_start",
    "Play Sound Effect"    => "play_se",
  }
  ACTION_LIB.default = "finish"

  # (Do not change it)
  DUAL_WEAPONS_ANIME = [ATTACK]
  


  # Arms display X coordinates
  BLZ_X = {
  0=>[0,0,0,0],   # NO MOTION
  1=>[2,2,2,2],   # Shake lowering
  2=>[15,10,0,0], # Piercing
  3=>[2,2,2,2],   # Raising
  4=>[0,0,3,3],   # Bow and gun
  5=>[0,0,0,0],   # For addition
  6=>[0,0,0,0],   # For addition
  7=>[0,0,0,0],   # For addition
  8=>[0,0,0,0],   # For addition
  }
  # Arms display Y coordinates
  BLZ_Y = {
  0=>[0,0,0,0], # NO MOTION
  1=>[6,6,6,6], # Shake lowering
  2=>[6,6,6,6], # Piercing
  3=>[6,6,6,6], # Raising
  4=>[8,8,8,8], # Bow and gun
  5=>[0,0,0,0], # For addition
  6=>[0,0,0,0], # For addition
  7=>[0,0,0,0], # For addition
  8=>[0,0,0,0], # For addition
  }
  # Arms display Angle
  BLZ_ANGLE = {
  0=>[0,0,0,0],                            # NO MOTION
  1=>[75-45*3,75-45*2,75-45*1,75-45*1],    # Shake lowering
  2=>[45,45,45,45],                        # Piercing
  3=>[100-45*1,100-45*2,100-45*3,00-45*4], # Raising
  4=>[45,45,45,45],                        # Bow and gun
  5=>[0,0,0,0],                            # For addition
  6=>[0,0,0,0],                            # For addition
  7=>[0,0,0,0],                            # For addition
  8=>[0,0,0,0],                            # For addition
  }
  
  #--------------------------------------------------------------------------
  # œ SHAKE
  #--------------------------------------------------------------------------
  SHAKE_FILE = "SHAKE"  # filename
  SHAKE_POWER = 5       # POWER
  SHAKE_SPEED = 5       # SPEED
  SHAKE_DURATION = 5    # DURATION
  #--------------------------------------------------------------------------
  # œ UPSIDE_DOWN
  #--------------------------------------------------------------------------
  UPSIDE_DOWN_FILE = "UPSIDE_DOWN" # filename
  #--------------------------------------------------------------------------
  # œ REVERSE
  #--------------------------------------------------------------------------
  REVERSE_FILE = "REVERSE" # filename
  #--------------------------------------------------------------------------
  # œ ‰ñ“]‚ÌÝ’è
  #--------------------------------------------------------------------------
  TURNING_FILE = "ROTATION" # filename
  TURNING_DIRECTION = 1     # Directioni1.Anti-clockwise, -1.clockwise)
  TURNING_SPEED = 32        # Speed
  TURNING_DURATION = 1      # Rotation frequency
  #--------------------------------------------------------------------------
  # œ ˆÚ“®‚ÌÝ’è
  #--------------------------------------------------------------------------
  MOVE_FILE = "MOVE"             # filename
  MOVE_RETURN = 1                # Do you return to former position?
  MOVE_SPEED = 32                # Speed
  MOVE_COORDINATES = [0, -640]   # Relative coordinates from former position
  #--------------------------------------------------------------------------
  # œ Add Animation (using RTAB)
  #--------------------------------------------------------------------------
  ADD_ANIME_FILE = "Add_ANIME"   # filename
  ADD_ANIME_ID = 0               # Animation ID 
  #--------------------------------------------------------------------------
  # œ using RTAB (Do not change it)
  #--------------------------------------------------------------------------
  def convert_battler
    return RTAB ? @active_actor : @active_battler
  end
  #--------------------------------------------------------------------------
  # œ using RTAB (Do not change it)
  #--------------------------------------------------------------------------
  def convert_battler2(*arg)
    return RTAB ? arg[0] : @active_battler
  end
end

#--------------------------------------------------------------------------
# œ action performer
#--------------------------------------------------------------------------
module BattleActions
  
  # Because the one below is one example to the last
  # Please make it originally. 

  Actions = {

  "Normal Attack" => [
  
  "main phase step 3",
  "Hero Graphic Change#WALK_L",
  "Hero Move#target,32,0,64,0",
  "Hero Graphic Change#NORMAL",
  "Waiting#5",
  "Hero Graphic Change#ATTACK",
  "Throw Animation",
  "main phase step 4",
  "Waiting#5",
  "Hero Graphic Change#WALK_L",
  "Play Sound Effect#016-Jump02,80,100",
  "Hero Move#self,0,0,18,4",
  "end"
  ],
  

  "One step advancement Attack" => [
  
  "main phase step 3",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,-32,0,12,0",
  "Hero Graphic Change#NORMAL",
  "Waiting#5",
  "Hero Graphic Change#ATTACK",
  "Throw Animation",
  "main phase step 4",
  "Waiting#5",
  "Hero Graphic Change#WALK_L",
  "Play Sound Effect#016-Jump02,80,100",
  "Hero Move#self,0,0,12,0",
  "end"
  ],
  

  "Enemy Attack" => [
  
  "main phase step 3",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,-36,0,12,0",
  "Hero Graphic Change#NORMAL",
  "Waiting#5",
  "Hero Graphic Change#ATTACK",
  "Throw Animation",
  "main phase step 4",
  "Waiting#5",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,0,0,12,0",
  "end"
  ],
  
  
  "Spell Magic" => [
  
  "main phase step 3",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,-32,0,4,0",
  "Hero Graphic Change#MAGIC",
  "Waiting#15",
  "Throw Animation",
  "main phase step 4",
  "Waiting#5",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,0,0,4,2",
  "end"
  ],

  "Using Item" => [
  
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,-32,0,4,0",
  "main phase step 3",
  "Hero Graphic Change#ITEM",
  "Waiting#15",
  "Throw Animation",
  "main phase step 4",
  "Waiting#5",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,0,0,4,2",
  "end"
  ],
  
  "Using Skill" => [
  
  "Hero Graphic Change#WALK_L",
  "Hero Move#target_near,50,0,48,6",  
  "Graphic Reverse",
  "Freeze ON#ATTACK#3",
  "main phase step 3",
  "Play Sound Effect#135-Light01,100,100",
  "Display Animation#self,42",
  "Waiting#15",
  "Graphic Reverse",
  "Afterimage ON",
  "Hero Move#target_far,-50,0,48,0",
  "main phase step 4",
  "Waiting#5",
  "Afterimage OFF",
  "Freeze OFF",
  "Hero Graphic Change#WALK_L",
  "Hero Move#self,0,0,48,1,0",
  "end"
  ],
  }

end
  
module RPG

  # Because the one below is one example to the last
  # Please make it originally. 

  class Weapon
    #--------------------------------------------------------------------------
    # Weapon sctions. Set what weapons are a stand still weapon.
    #--------------------------------------------------------------------------
    def battle_actions
      case @id
      when 21 # Bronze Gun
        return BattleActions::Actions["One step advancement Attack"]
      end 
      return BattleActions::Actions["Normal Attack"] # default
    end
  end
  class Skill
    #--------------------------------------------------------------------------
    # œ action performer
    #--------------------------------------------------------------------------
    def battle_actions
      if self.magic?
        return BattleActions::Actions["Spell Magic"] # default
      else
        return BattleActions::Actions["Using Skill"] # default
      end
    end
  end
  class Item
    #--------------------------------------------------------------------------
    # œ action performer
    #--------------------------------------------------------------------------
    def battle_actions
      return BattleActions::Actions["Using Item"] # default
    end
  end
end
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # œ action performer
  #--------------------------------------------------------------------------
  def battle_actions
    return BattleActions::Actions["Enemy Attack"] # default
  end
end
module RPG
=begin
  
  œ Setting of arms type
    
    The attribute of the name "WeaponType" is made, and it is applied to arms. 
    The figure is written behind "WeaponType". 
@@
    Example.@WeaponType1@
    
=end
  class Weapon
    #--------------------------------------------------------------------------
    # œ WeaponType
    #--------------------------------------------------------------------------
    def anime
      # Elemental
      element_name = "WeaponType"
      for i in @element_set
        if $data_system.elements[i] =~ /#{element_name}([+-]?[0-9]+)?(%)?/
          return $1.to_i
        end
      end
      # Weapon ID

  # Because the one below is one example to the last
  # Please make it originally. 

      case @id
      when 1,2,3,4
        return 1 # (WeaponType) Refer from the 115th line to the 150th line. 
      when 5,6,7,8
        return 2 # (WeaponType) Refer from the 115th line to the 150th line. 
      end
      return 1 # defaut
    end
  end
end
=begin
#--------------------------------------------------------------------------
# œ Throw Animation
#--------------------------------------------------------------------------
  
@  Animation is thrown out from performar to target. 
    Please make animation from the data base. 

   [ Animation ID, Speed, Do you shuttle?, Straight line (false) or curve(true)]        
=end
module RPG
  class Weapon
    #--------------------------------------------------------------------------
    # œ Throw Animation
    #--------------------------------------------------------------------------
    def flying_anime
      # Example
      #case @id
      #when 34 # Boomerang
      #  return [10,32,true,true]
      #when 17,18,19,20 # Arrow
      #  return [40,32,false,false]
      #end
      return [0,0,false,false] # No throw
    end
  end
  class Skill
    #--------------------------------------------------------------------------
    # œ Throw Animation
    #--------------------------------------------------------------------------
    def flying_anime
      # Example
      #case @id
      #when 34 # Boomerang
      #  return [10,32,true,true]
      #when 17,18,19,20 # Arrow
      #  return [40,32,false,false]
      #end
      return [0,0,false,false] # No throw
    end
  end
  class Item
    #--------------------------------------------------------------------------
    # œ Throw Animation
    #--------------------------------------------------------------------------
    def flying_anime
      # Example
      #case @id
      #when 34 # Boomerang
      #  return [10,32,true,true]
      #when 17,18,19,20 # Arrow
      #  return [40,32,false,false]
      #end
      return [0,0,false,false] # No throw
    end
  end
end

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # œ Throw Animation
  #--------------------------------------------------------------------------
  def flying_anime
      # Example
      #case @id
      #when 34 # Boomerang
      #  return [10,32,true,true]
      #when 17,18,19,20 # Arrow
      #  return [40,32,false,false]
      #end
    return [0,0,false,false] # No throw
  end
end
#==============================================================================
# ¡ Game_Battler
#==============================================================================
class Game_Battler
  include Side_view
  #--------------------------------------------------------------------------
  # œ ’Ç‰ÁEŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_accessor :height                  # ‰æ‘œ‚Ì‚‚³
  attr_accessor :real_x                  # XÀ•W•â³
  attr_accessor :real_y                  # YÀ•W•â³
  attr_accessor :real_zoom               # Šg‘å—¦
  attr_accessor :wait_count              # ƒAƒjƒ[ƒVƒ‡ƒ“ ‘Ò‚¿ŽžŠÔ
  attr_accessor :wait_count2             # ƒAƒjƒ[ƒVƒ‡ƒ“ ‘Ò‚¿ŽžŠÔ2
  attr_accessor :pattern                 # ƒAƒjƒ[ƒVƒ‡ƒ“ ƒJƒEƒ“ƒgiƒLƒƒƒ‰)
  attr_accessor :shake                   # ƒVƒFƒCƒNŠJŽnƒtƒ‰ƒbƒO
  attr_accessor :reverse                 # ¶‰E”½“]ƒtƒ‰ƒbƒO
  attr_accessor :shadow                  # Žc‘œƒtƒ‰ƒbƒO
  attr_accessor :flash_flag              # ‘M‚«ƒtƒ‰ƒbƒO
  attr_reader   :ox                      # XÀ•W•â³
  attr_reader   :oy                      # YÀ•W•â³
  attr_reader   :flying_x                # ‰“‹——£ƒAƒjƒXÀ•W
  attr_reader   :flying_y                # ‰“‹——£ƒAƒjƒYÀ•W
  attr_reader   :flying_anime            # ‰“‹——£ƒAƒjƒ
  attr_reader   :animation1_on           # s“®ƒAƒjƒŠJŽnƒtƒ‰ƒbƒO
  attr_reader   :animation2_on           # ‘ÎÛƒAƒjƒŠJŽnƒtƒ‰ƒbƒO
  #--------------------------------------------------------------------------
  # œ ƒfƒtƒHƒ‹ƒg‚ÌƒAƒjƒ[ƒVƒ‡ƒ“‘Ò‚¿ŽžŠÔ‚ðŽæ“¾
  #--------------------------------------------------------------------------
  def animation_duration=(animation_duration)
    @_animation_duration = animation_duration
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹ŠJŽnŽž‚ÌƒZƒbƒgƒAƒbƒv
  #--------------------------------------------------------------------------
  def start_battle
    @height = 0
    @real_x = 0
    @real_y = 0
    @real_zoom = 1.0
    @battler_condition = ""
    @action = nil
    @battle_actions = []
    @battler_action = false
    @step = 0
    @anime_on = false
    @wait_count = 0
    @wait_count2 = 0
    @ox = 0
    @oy = 0
    @pattern = 0
    @pattern_log = true
    @pattern_freeze = false
    @condition_freeze = false
    @active = false
    @move_distance = nil
    @move_wait = 0
    @move_coordinates = [0,0,0,0]
    @flying_distance = nil
    @flying_wait = 0
    @flying_x = 0
    @flying_y = 0
    @flash_flag = {}
    self.flying_clear
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®’†”»’è
  #--------------------------------------------------------------------------
  def moving?
    # XÀ•W•â³‚Ü‚½‚ÍAYÀ•W•â³‚ª0‚Å‚È‚¯‚ê‚ÎAˆÚ“®’†
    return (@ox != 0 or @oy != 0)
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®I—¹”»’è
  #--------------------------------------------------------------------------
  def move_end?
    return (@ox == @move_coordinates[0] and @oy == @move_coordinates[1])
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒVƒ‡ƒ“ŠJŽnÝ’è
  #--------------------------------------------------------------------------
  def action(flag = true)
    @battler_action = flag
    @animation1_on = false
    @animation2_on = false
    @step = "setup"
  end    
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒVƒ‡ƒ“’†”»’è
  #--------------------------------------------------------------------------
  def action?
    return @battler_action 
  end
  #--------------------------------------------------------------------------
  # œ ‘M‚«”»’è
  #--------------------------------------------------------------------------
  def flash?
    return @flash_flg
  end
  #--------------------------------------------------------------------------
  # œ í“¬•s”\”»’è
  #--------------------------------------------------------------------------
  def anime_dead?
    if $game_temp.in_battle and !RTAB
      if [2,3,4,5].include?($scene.phase4_step)
        return @last_dead
      end
    end
    return @last_dead = self.dead?
  end
  #--------------------------------------------------------------------------
  # œ ƒsƒ“ƒ`ó‘Ô”»’è
  #--------------------------------------------------------------------------
  def crisis?
    if $game_temp.in_battle and !RTAB
      if [2,3,4,5].include?($scene.phase4_step)
        return @last_crisis
      end
    end
    return @last_crisis = (self.hp <= self.maxhp / 4 or badstate?)
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒbƒhƒXƒe[ƒg”»’è
  #--------------------------------------------------------------------------
  def badstate?
    for i in @states
      unless $data_states[i].nonresistance
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # œ ”òs
  #--------------------------------------------------------------------------
  def fly
    if @fly != nil
      return @fly
    end
    for id in @states
      if FLY_STATES.include?($data_states[id].name)
        return 60
      end
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # œ ‰“‹——£ƒAƒjƒ–Ú•WÀ•W‚ÌŒvŽZ
  #--------------------------------------------------------------------------
  def flying_setup
    # “ñ“x–Ú‚ÍŽÀs‚µ‚È‚¢
    return if @flying_distance != nil && !camera_correctness
    if RTAB
      targets = @target
    else
      targets = $scene.target_battlers
    end
    # –Ú“IÀ•W‚ðŒvŽZ
    @f_target_x = 0
    @f_target_y = 0
    for t in targets
      @f_target_x += t.screen_x 
      @f_target_y += t.screen_y
    end
    if targets != []
      @f_target_x /= targets.size
      @f_target_y /= targets.size
    else
      @flying_distance = 0
      return
    end
    # ‹——£‚ÌŒvŽZ
    @flying_distance = (self.screen_x - @f_target_x).abs + (self.screen_y - @f_target_y).abs
    @flying_end = false
  end
  #--------------------------------------------------------------------------
  # œ ‰“‹——£ƒAƒjƒ
  #--------------------------------------------------------------------------
  def flying_animation
    # –ß‚é
    if @step != "flying" or @flying_distance.nil?
      return [false,true]
    end
    # ‚ ‚ç‚©‚¶‚ßŒvŽZ
    self_x = self.screen_x
    self_y = self.screen_y
    @flying_distance = @flying_distance == 0 ? 1 : @flying_distance
    n1 = @flying_wait / @flying_distance.to_f
    if @flying_distance - @flying_wait > @flying_distance / 2
      n2 = 1.0 + 10.0 * @flying_wait / @flying_distance.to_f
    else
      n2 = 1.0 + 10.0 * (@flying_distance - @flying_wait) / @flying_distance.to_f
    end
    if !@flying_anime[4]
      # ’¼üˆÚ“®
      x = (self_x + 1.0 * (@f_target_x - self_x) * n1).to_i
      y = (self_y + 1.0 * (@f_target_y - self_y) * n1).to_i
    else
      # ‹ÈüˆÚ“®
      if !@flying_proceed_end
        x = (self_x + 1.0 * (@f_target_x - self_x) * n1).to_i
        y = (self_y + 1.0 * (@f_target_y - self_y) * n1 - n2**2).to_i
      else
        x = (self_x + 1.0 * (@f_target_x - self_x) * n1).to_i
        y = (self_y + 1.0 * (@f_target_y - self_y) * n1 + n2**2).to_i
      end
    end
    # À•W‘ã“ü
    @flying_x = x
    @flying_y = y
    # ƒEƒGƒCƒg
    if !@flying_proceed_end
      # ŠJŽn
      @flying_proceed_start = @flying_wait == 0
      @flying_wait += @flying_anime[1]
      @flying_wait = [@flying_wait,@flying_distance].min
      @flying_proceed_end = @flying_wait == @flying_distance
    else
      # ŠJŽn
      @flying_return_start = @flying_wait == @flying_distance
      @flying_wait -= @flying_anime[1]
      @flying_wait = [@flying_wait,0].max
      @flying_return_end = @flying_wait == 0
    end
    if @flying_anime[1] == 0
      @flying_end = true
    elsif !@flying_anime[2]
      @flying_end = @flying_proceed_end
    else
      @flying_end = @flying_return_end
    end
    # ’l‚ð•Ô‚·iƒAƒjƒŠJŽn,ƒAƒjƒI—¹)
    return [@flying_proceed_start,@flying_end]
  end
  #--------------------------------------------------------------------------
  # œ ‰“‹——£ƒAƒjƒ‰Šú‰»
  #--------------------------------------------------------------------------
  def flying_clear
    @flying_proceed_start = false
    @flying_proceed_end = false
    @flying_return_start = false
    @flying_return_end = false
    @flying_end = true
    @flying_anime = [0,0,false,false]
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®
  #--------------------------------------------------------------------------
  def move
    # ‹——£‚ÌŒvŽZ
    @move_distance = (@move_coordinates[2] - @move_coordinates[0]).abs +
                     (@move_coordinates[3] - @move_coordinates[1]).abs
    if @move_distance > 0
      return if @ox == @move_coordinates[0] and @oy == @move_coordinates[1]
      array = @move_coordinates
      # ƒWƒƒƒ“ƒv•â³’l‚ÌŒvŽZ
      n = 100.0 * @move_wait / @move_distance 
      jump = -@move_action[4] * n * (100 - n) / 100.0
      @ox = (array[2] + 1.0 * (array[0] - array[2]) * (@move_distance - @move_wait) / @move_distance.to_f).to_i
      @oy = (array[3] + 1.0 * (array[1] - array[3]) * (@move_distance - @move_wait) / @move_distance.to_f + jump).to_i
      # ƒEƒGƒCƒg
      @move_wait -= @move_action[3]
      @move_wait = [@move_wait,0].max
    end
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®ƒAƒNƒVƒ‡ƒ“‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def get_move_action
    string = @action.split(/#/)[1]
    string = string.split(/,/)
    @move_action = [string[0],string[1].to_i,string[2].to_i,string[3].to_i,string[4].to_i,string[5].to_i]
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒVƒ‡ƒ“‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def get_step
    if @action.nil?
      @step = "finish"
      return 
    end
    return ACTION_LIB[@action.split(/#/)[0]]
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ŽŸ‚ÌƒAƒNƒVƒ‡ƒ“‚Ö)
  #--------------------------------------------------------------------------
  def update_next
    @action = @battle_actions.shift
    @step = get_step
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (“®ìŽæ“¾)
  #--------------------------------------------------------------------------
  def update_setup
    # ƒAƒNƒVƒ‡ƒ“‚ÌŽæ“¾
    self.get_actions
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ˆÚ“®Žæ“¾)
  #--------------------------------------------------------------------------
  def update_moving_setup
    # ˆÚ“®ƒAƒNƒVƒ‡ƒ“‚ÌŽæ“¾
    self.get_move_action
    # ˆÚ“®–Ú•W‚ÌÝ’è
    self.move_setup
    @step = "moving"
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ˆÚ“®)
  #--------------------------------------------------------------------------
  def update_moving
    # ˆÚ“®
    self.move
    self.condition = @battler_condition
    # ˆÚ“®Š®—¹‚µ‚½‚çŽŸ‚ÌƒXƒeƒbƒv‚Ö
    if move_end?
      update_next
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒjƒŽÀs)
  #--------------------------------------------------------------------------
  def update_action
    con = @action.split(/#/)[1]
    # ‰EŽèE¶Žè‚ð•ª‚¯‚é
    if DUAL_WEAPONS_ANIME.include?(con)
      if !@first_weapon and @second_weapon
        con = con + "_L"
      else
        con = con + "_R"
      end
    end
    # ƒAƒjƒ•ÏX
    self.condition = con
    # ƒ‹[ƒv‚©”Û‚©
    if !ANIME[@battler_condition][1]
      self.anime_on
    end
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (‰“‹——£ƒAƒjƒ)
  #--------------------------------------------------------------------------
  def update_flying
    # –Ú•W‚ÌÝ’è
    self.flying_setup
    # ‰“‹——£ƒAƒjƒI—¹
    if @flying_end or @flying_anime == [0,0,false,false]
      self.flying_clear
      update_next
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒjƒ•ÏX)
  #--------------------------------------------------------------------------
  def update_change
    con = @action.split(/#/)[1]
    # ‰EŽèE¶Žè‚ð•ª‚¯‚é
    if DUAL_WEAPONS_ANIME.include?(con)
      if !@first_weapon and @second_weapon
        con = con + "_L"
      else
        con = con + "_R"
      end
    end
    # ƒAƒjƒ•ÏX
    self.condition = con
    # ƒ‹[ƒv‚©”Û‚©
    if !ANIME[@battler_condition][1]
      self.anime_on
    end
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (s“®ƒAƒjƒ)
  #--------------------------------------------------------------------------
  def update_animation1
    @animation1_on = true
    # s“®ƒAƒjƒ‚ÌŒã‚És“®‚ðŠJŽn‚·‚é
    if $scene.phase4_step == 3
      id = RTAB ? @anime1 : $scene.animation1_id
      animation = $data_animations[id]
      frame_max = animation != nil ? animation.frame_max : 0
      @wait_count2 = frame_max * 2
      return
    end
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (‘ÎÛƒAƒjƒ)
  #--------------------------------------------------------------------------
  def update_animation2
    @animation2_on = true
    # s“®ƒAƒjƒ‚ÌŒã‚És“®‚ðŠJŽn‚·‚é
    if $scene.phase4_step == 4
      id = RTAB ? @anime2 : $scene.animation2_id
      animation = $data_animations[id]
      frame_max = animation != nil ? animation.frame_max : 0
      @wait_count2 = frame_max * 2
      return
    end
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒEƒGƒCƒg)
  #--------------------------------------------------------------------------
  def update_wait
    @wait_count2 = @action.split(/#/)[1].to_i
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (Žc‘œ•\Ž¦)
  #--------------------------------------------------------------------------
  def update_shadow_on
    @shadow = true
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (Žc‘œÁ‹Ž)
  #--------------------------------------------------------------------------
  def update_shadow_off
    @shadow = false
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (¶‰E”½“])
  #--------------------------------------------------------------------------
  def update_reverse
    @reverse = @reverse ? false : true
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (‘M‚«ƒAƒjƒ)
  #--------------------------------------------------------------------------
  def update_flash
    # ‘M‚«ƒAƒjƒ‚ÌŒã‚És“®‚ðŠJŽn‚·‚é
    if @flash_flag["normal"]
      @wait_count = $scene.flash_duration
      @flash_flag["normal"] = false
      return
    end
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (SE‚Ì‰‰‘t)
  #--------------------------------------------------------------------------
  def update_play_se
    data = @action.split(/#/)[1]
    data = data.split(/,/)
    # SE ‚ð‰‰‘t
    Audio.se_play("Audio/SE/" + data[0], data[1].to_i, data[2].to_i)
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒNƒ^[ƒAƒjƒŒÅ’è)
  #--------------------------------------------------------------------------
  def update_freeze
    con = @action.split(/#/)[1]
    # ‰EŽèE¶Žè‚ð•ª‚¯‚é
    if DUAL_WEAPONS_ANIME.include?(con)
      if !@first_weapon and @second_weapon
        con = con + "_L"
      else
        con = con + "_R"
      end
    end
    # ƒAƒjƒ•ÏX
    self.condition = con
    @pattern = @action.split(/#/)[2].to_i
    @pattern_freeze = true
    @condition_freeze = true
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒNƒ^[ƒAƒjƒŒÅ’è‰ðœ)
  #--------------------------------------------------------------------------
  def update_freeze_lifting
    @pattern_freeze = false
    @condition_freeze = false
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒjƒ[ƒVƒ‡ƒ“‚Ì•\Ž¦)
  #--------------------------------------------------------------------------
  def update_animation_start
    data = @action.split(/#/)[1]
    data = data.split(/,/)
    target = data[0] 
    animation_id = data[1].to_i
    if RTAB
      case target
      when "self"
        @animation.push([animation_id,true])
      when "target"
        for tar in @target
          tar.animation.push([animation_id, true])
        end
      end
    else
      case target
      when "self"
        @animation_id = animation_id
        @animation_hit = true
      when "target"
        for tar in $scene.target_battlers
          tar.animation_id = animation_id
          tar.animation_hit = true
        end
      end
    end
    update_next
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (“®ìI—¹)
  #--------------------------------------------------------------------------
  def update_finish
    # “®ìI—¹
    @battler_action = false
    @step = "setup"
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‰[‚Ìó‘Ôiƒoƒgƒ‰[ƒOƒ‰ƒtƒBƒbƒN‚Ìƒ^ƒCƒv)
  #--------------------------------------------------------------------------
  def condition
    return @battler_condition
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‰[‚Ìó‘Ô •ÏXiƒoƒgƒ‰[ƒOƒ‰ƒtƒBƒbƒN‚Ìƒ^ƒCƒv)
  #--------------------------------------------------------------------------
  def condition=(condition)
    return if @condition_freeze
    if @battler_condition != condition
      @wait_count = ANIME[condition][2]
      @pattern = 0
    end
    @battler_condition = condition
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update
    # ƒEƒFƒCƒg’†‚Ìê‡
    if @wait_count == 0
      # ƒpƒ^[ƒ“XV
      self.char_animation
      @wait_count = ANIME[@battler_condition][2]
    end
    # ƒpƒ^[ƒ“XV
    self.char_animation
    # ƒEƒFƒCƒg’†‚Ìê‡
    if @wait_count2 > 0
      return
    end
    
    # s“®ƒAƒjƒ[ƒVƒ‡ƒ“
    if @battler_action
      method("update_" + @step).call
      return
    end
    
    # ƒf[ƒ^‰Šú‰»
    @animation1_on = false
    @animation2_on = false
    @action = nil
    @battle_actions = []
    @move_wait = 0
    @move_distance = nil
    @flying_wait = 0
    @flying_distance = nil
    @flash = false

    # ’ÊíE‘Ò‹@
    return self.condition = NORMAL
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒVƒ‡ƒ“‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def get_actions
    skill = $data_skills[self.current_action.skill_id]
    item = $data_items[self.current_action.item_id]
    kind = self.current_action.kind
    # “®ìŽæ“¾
    @battle_actions = []
    # ƒXƒLƒ‹
    if skill != nil && kind == 1
      @battle_actions = skill.battle_actions.dup
      @flying_anime = skill.flying_anime
    # ƒAƒCƒeƒ€
    elsif item != nil && kind == 2
      @battle_actions = item.battle_actions.dup
      @flying_anime = item.flying_anime
    # ¶ŽèUŒ‚
    elsif !@first_weapon and @second_weapon and self.is_a?(Game_Actor)
      @battle_actions = self.battle_actions2.dup
      @flying_anime = self.flying_anime2
    # ‰EŽèUŒ‚
    elsif self.current_action.basic == 0 and
      self.is_a?(Game_Actor) and self.current_action.kind == 0
      @battle_actions = self.battle_actions1.dup
      @flying_anime = self.flying_anime1
    # ’ÊíUŒ‚
    elsif self.current_action.basic == 0 and self.current_action.kind == 0
      @battle_actions = self.battle_actions.dup
      @flying_anime = self.flying_anime
    else
      @battle_actions = ["I—¹"]
      @flying_anime = [0,0,false,false]
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒ‹[ƒv‚µ‚È‚¢ƒAƒjƒ‚ÌƒZƒbƒg
  #--------------------------------------------------------------------------
  def anime_on
    @pattern = 0
    @pattern_log = true
    return
  end
  #--------------------------------------------------------------------------
  # œ ƒpƒ^[ƒ“XV
  #--------------------------------------------------------------------------
  def char_animation
    # ƒpƒ^ƒ“ŒÅ’è‚Ìê‡‚à‚Ç‚é
    return if @pattern_freeze
    # ƒ‹[ƒv‚µ‚È‚¢ƒAƒjƒ‚Ìê‡ 1234 ‚ÅŽ~‚Ü‚é
    if !ANIME[@battler_condition][1] && @pattern == 3
      return
    end
    # ƒAƒjƒ‚³‚¹‚È‚¢ê‡ 1 ‚ÅŽ~‚Ü‚é
    if ANIME[@battler_condition][4]
      @pattern = 0
      return
    end
    @pattern = (@pattern + 1) % 4
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒjƒƒ^ƒCƒv
  #--------------------------------------------------------------------------
  def anime_type
    return ANIME[@battler_condition] != nil ? ANIME[@battler_condition][0] : 0
  end
end
#==============================================================================
# ¡ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  include Side_view
  #--------------------------------------------------------------------------
  # œ ƒZƒbƒgƒAƒbƒv
  #--------------------------------------------------------------------------
  alias side_view_setup setup
  def setup(actor_id)
    side_view_setup(actor_id)
    start_battle
  end
  #--------------------------------------------------------------------------
  # œ “ñ“•Ší‚ÌIDŽæ“¾@¦ƒGƒ‰[‰ñ”ð—p
  #--------------------------------------------------------------------------
  def weapon2_id
    return @weapon2_id != nil ? @weapon2_id : 0
  end
  #--------------------------------------------------------------------------
  # œ X•ûŒü ƒ|ƒWƒVƒ‡ƒ“ Žæ“¾
  #--------------------------------------------------------------------------
  def position
    return $data_classes[@class_id].position
  end
  #--------------------------------------------------------------------------
  # œ Y•ûŒü ƒ|ƒWƒVƒ‡ƒ“ Žæ“¾
  #--------------------------------------------------------------------------
  def position2
    return self.index
  end
  #--------------------------------------------------------------------------
  # œ •ŠíƒAƒjƒƒ^ƒCƒv
  #--------------------------------------------------------------------------
  def weapon_anime_type(type = @battler_condition)
    file_name  = weapon_anime_type0(type)
    visible   = weapon_anime_type1(type)
    z         = weapon_anime_type2(type)
    motion    = weapon_anime_type3(type)
    return [file_name,visible,z,motion]
  end
  # •ŠíƒAƒCƒRƒ“Žæ“¾
  def weapon_anime_type0(type = @battler_condition)
    type = ANIME[type][5]
    return weapon_anime1 if type == "Right"
    return weapon_anime2 if type == "Left"
    return nil
  end
  # •\Ž¦E”ñ•\Ž¦‚ÌŽæ“¾
  def weapon_anime_type1(type = @battler_condition)
    return ANIME[type][3]
  end
  # ƒoƒgƒ‰[‚æ‚èã‚É•\Ž¦‚·‚é‚©‚Ç‚¤‚©
  def weapon_anime_type2(type = @battler_condition)
    type = ANIME[type][5]
    return true if type == "Left"
    return false
  end
  # •Ší‚Ì“®ìNoDŽæ“¾
  def weapon_anime_type3(type = @battler_condition)
    type = ANIME[type][5]
    return extend_weapon_anime1 if type == "Right"
    return extend_weapon_anime2 if type == "Left"
    return 0
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾(ƒJƒƒ‰•â³–³‚µ)
  #--------------------------------------------------------------------------
  def true_x
    return PARTY_X + position * FORMATION_X + @ox
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾(ƒJƒƒ‰•â³–³‚µ)
  #--------------------------------------------------------------------------
  def true_y
    # ƒp[ƒeƒB“à‚Ì•À‚Ñ‡‚©‚ç Y À•W‚ðŒvŽZ‚µ‚Ä•Ô‚·
    if self.index != nil
      y = position2 * FORMATION_Y + PARTY_Y + @oy - @height / 2
      return y
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def screen_x(true_x = self.true_x)
    return 320 + (true_x - 320) * @real_zoom + @real_x
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def screen_y(true_y = self.true_y)
    return true_y * @real_zoom + @real_y
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Z À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y + 1000
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾(ˆÚ“®‚È‚Ç‚µ‚Ä‚¢‚È‚¢ê‡)
  #--------------------------------------------------------------------------
  def base_x
    return 320 + (true_x - @ox - 320) * @real_zoom + @real_x
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def base_y
    return (true_y - @oy) * @real_zoom + @real_y
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Šg‘å—¦‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def zoom
    return ($scene.zoom_rate[1] - $scene.zoom_rate[0]) *
                          (true_x + @fly) / 480 + $scene.zoom_rate[0]
  end
  #--------------------------------------------------------------------------
  # œ UŒ‚—pAƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def attack_x(z)
    return (320 - true_x) * z * 0.75
  end
  #--------------------------------------------------------------------------
  # œ UŒ‚—pAƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def attack_y(z)
    return (160 - (true_y + fly / 4) * z + @height * zoom * z / 2) * 0.75
  end
  #--------------------------------------------------------------------------
  # œ ‘M‚«‘Ò‚¿ŽžŠÔ
  #--------------------------------------------------------------------------
  def flash_duration
    return $scene.flash_duration
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒjƒ[ƒVƒ‡ƒ“Žæ“¾
  #--------------------------------------------------------------------------
  def battle_actions1
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.battle_actions : BattleActions::Actions["’ÊíUŒ‚"]
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒjƒ[ƒVƒ‡ƒ“Žæ“¾
  #--------------------------------------------------------------------------
  def battle_actions2
    weapon = $data_weapons[@weapon2_id]
    return weapon != nil ? weapon.battle_actions : BattleActions::Actions["’ÊíUŒ‚"]
  end
  #--------------------------------------------------------------------------
  # œ •ŠíƒAƒjƒ[ƒVƒ‡ƒ“ “®‚«•û Žæ“¾
  #--------------------------------------------------------------------------
  def extend_weapon_anime1
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.anime : 0
  end
  #--------------------------------------------------------------------------
  # œ •ŠíƒAƒjƒ[ƒVƒ‡ƒ“ “®‚«•û Žæ“¾
  #--------------------------------------------------------------------------
  def extend_weapon_anime2
    weapon = $data_weapons[@weapon2_id]
    return weapon != nil ? weapon.anime : 0
  end
  #--------------------------------------------------------------------------
  # œ •ŠíƒAƒjƒ[ƒVƒ‡ƒ“Žæ“¾
  #--------------------------------------------------------------------------
  def weapon_anime1
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.icon_name : ""
  end
  #--------------------------------------------------------------------------
  # œ •ŠíƒAƒjƒ[ƒVƒ‡ƒ“Žæ“¾
  #--------------------------------------------------------------------------
  def weapon_anime2
    weapon = $data_weapons[@weapon2_id]
    return weapon != nil ? weapon.icon_name : ""
  end
  #--------------------------------------------------------------------------
  # œ ‰“‹——£ƒAƒjƒ[ƒVƒ‡ƒ“Žæ“¾
  #--------------------------------------------------------------------------
  def flying_anime1
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.flying_anime : [0,0,false,false]
  end
  #--------------------------------------------------------------------------
  # œ ‰“‹——£ƒAƒjƒ[ƒVƒ‡ƒ“Žæ“¾
  #--------------------------------------------------------------------------
  def flying_anime2
    weapon = $data_weapons[@weapon2_id]
    return weapon != nil ? weapon.flying_anime : [0,0,false,false]
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®–Ú•WÀ•W‚ÌŒvŽZ
  #--------------------------------------------------------------------------
  def move_setup
    if RTAB
      targets = @target
    else
      targets = $scene.target_battlers
    end
    case @move_action[0]
    when "self" # Ž©•ª
      @target_x = self.base_x
      @target_y = self.base_y
    when "target_near" # ˆê”Ô‹ß‚­‚Ìƒ^[ƒQƒbƒg
      targets.sort!{|a,b| a.screen_x<=>b.screen_x }
      targets.reverse!
      if targets != []
        @target_x = targets[0].screen_x
        @target_y = targets[0].screen_y
      else
        @target_x = self.base_x
        @target_y = self.base_y
      end
    when "target_far" # ˆê”Ô‰“‚­‚Ìƒ^[ƒQƒbƒg
      targets.sort!{|a,b| a.screen_x<=>b.screen_x }
      if targets != []
        @target_x = targets[0].screen_x
        @target_y = targets[0].screen_y
      else
        @target_x = self.base_x
        @target_y = self.base_y
      end
    when "target" # ƒ^[ƒQƒbƒg’†‰›
      @target_x = 0
      @target_y = 0
      for t in targets
        @target_x += t.screen_x
        @target_y += t.screen_y
      end
      if targets != []
        @target_x /= targets.size
        @target_y /= targets.size
      end
    when "troop" # "ƒgƒ‹[ƒv’†‰›"
      @target_x = 0
      @target_y = 0
      for t in $game_troop.enemies
        @target_x += t.screen_x
        @target_y += t.screen_y
      end
      if $game_troop.enemies != []
        @target_x /= $game_troop.enemies.size
        @target_y /= $game_troop.enemies.size
      end
    when "party" # "ƒp[ƒeƒB’†‰›"
      @target_x = 0
      @target_y = 0
      for t in $game_party.actors
        @target_x += t.screen_x
        @target_y += t.screen_y
      end
      if $game_party.actors != []
        @target_x /= $game_party.actors.size
        @target_y /= $game_party.actors.size
      end
    when "screen" # "‰æ–Ê"
      @target_x = self.base_x
      @target_y = self.base_y
    end
    # •â³
    @target_x += @move_action[1] - self.base_x
    @target_y += @move_action[2] - self.base_y
    # ˆÚ“®–Ú•W‚ÌÀ•W‚ðƒZƒbƒg
    @move_coordinates = [@target_x.to_i,@target_y.to_i,@move_coordinates[0],@move_coordinates[1]]
    # ‹——£‚ÌŒvŽZ(ƒEƒGƒCƒg‚ÌÝ’è)
    @move_wait     = (@move_coordinates[2] - @move_coordinates[0]).abs +
                     (@move_coordinates[3] - @move_coordinates[1]).abs
  end
end
#==============================================================================
# ¡ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # œ ƒZƒbƒgƒAƒbƒv
  #--------------------------------------------------------------------------
  alias side_view_initialize initialize
  def initialize(troop_id, member_index)
    side_view_initialize(troop_id, member_index)
    start_battle
  end
  def character_name
    return battler_name
  end
  def character_hue
    return battler_hue
  end
  def reverse
    return !@reverse
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®
  #--------------------------------------------------------------------------
  def move
    # ‹——£‚ÌŒvŽZ
    @move_distance = (@move_coordinates[2] - @move_coordinates[0]).abs +
                     (@move_coordinates[3] - @move_coordinates[1]).abs
    if @move_distance > 0
      return if @ox == @move_coordinates[0] and @oy == @move_coordinates[1]
      array = @move_coordinates
      # ƒWƒƒƒ“ƒv•â³’l‚ÌŒvŽZ
      n = 100.0 * @move_wait / @move_distance 
      jump = -@move_action[4] * n * (100 - n) / 100.0
      @ox = (array[2] + 1.0 * (array[0] - array[2]) * (@move_distance - @move_wait) / @move_distance.to_f).to_i
      @oy = (array[3] + 1.0 * (array[1] - array[3]) * (@move_distance - @move_wait) / @move_distance.to_f + jump).to_i
      # ƒEƒGƒCƒg
      @move_wait -= @move_action[3]
      @move_wait = [@move_wait,0].max
    end
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®–Ú•WÀ•W‚ÌŒvŽZ
  #--------------------------------------------------------------------------
  def move_setup
    if RTAB
      targets = @target
    else
      targets = $scene.target_battlers
    end
    case @move_action[0]
    when "self" # Ž©•ª
      @target_x = self.base_x
      @target_y = self.base_y
    when "target_near" # ˆê”Ô‹ß‚­‚Ìƒ^[ƒQƒbƒg
      targets.sort!{|a,b| a.screen_x<=>b.screen_x }
      if targets != []
        @target_x = targets[0].screen_x
        @target_y = targets[0].screen_y
      else
        @target_x = self.base_x
        @target_y = self.base_y
      end
    when "target_far" # ˆê”Ô‰“‚­‚Ìƒ^[ƒQƒbƒg
      targets.sort!{|a,b| a.screen_x<=>b.screen_x }
      targets.reverse!
      if targets != []
        @target_x = targets[0].screen_x
        @target_y = targets[0].screen_y
      else
        @target_x = self.base_x
        @target_y = self.base_y
      end
    when "target" # ƒ^[ƒQƒbƒg’†‰›
      @target_x = 0
      @target_y = 0
      for t in targets
        @target_x += t.screen_x
        @target_y += t.screen_y
      end
      if targets != []
        @target_x /= targets.size
        @target_y /= targets.size
      end
    when  "party" # "ƒgƒ‹[ƒv’†‰›"
      @target_x = 0
      @target_y = 0
      for t in $game_troop.enemies
        @target_x += t.screen_x
        @target_y += t.screen_y
      end
      if $game_troop.enemies != []
        @target_x /= $game_troop.enemies.size
        @target_y /= $game_troop.enemies.size
      end
    when "troop" # "ƒp[ƒeƒB’†‰›"
      @target_x = 0
      @target_y = 0
      for t in $game_party.actors
        @target_x += t.screen_x
        @target_y += t.screen_y
      end
      if $game_party.actors != []
        @target_x /= $game_party.actors.size
        @target_y /= $game_party.actors.size
      end
    when "screen" # "‰æ–Ê"
      @target_x = self.base_x
      @target_y = self.base_y
    end
    # •â³
    @target_x -= @move_action[1] + self.base_x
    @target_y -= @move_action[2] + self.base_y
    # ˆÚ“®–Ú•W‚ÌÀ•W‚ðƒZƒbƒg
    @move_coordinates = [@target_x.to_i,@target_y.to_i,@move_coordinates[0],@move_coordinates[1]]
    # ‹——£‚ÌŒvŽZ(ƒEƒGƒCƒg‚ÌÝ’è)
    @move_wait     = (@move_coordinates[2] - @move_coordinates[0]).abs +
                     (@move_coordinates[3] - @move_coordinates[1]).abs
  end
  if RTAB
  alias original_x true_x
  alias original_y true_y
  else
  alias original_x screen_x
  alias original_y screen_y
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾(ƒJƒƒ‰•â³–³‚µ)
  #--------------------------------------------------------------------------
  def true_x
    return original_x + @ox
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾(ƒJƒƒ‰•â³–³‚µ)
  #--------------------------------------------------------------------------
  def true_y
    return original_y - @height / 2 + @oy
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def screen_x(true_x = self.true_x)
    return true_x * @real_zoom + @real_x 
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾
  #--------------------------------------------------------------------------
  def screen_y(true_y = self.true_y)
    return true_y * @real_zoom + @real_y
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚ÌŽæ“¾(ˆÚ“®‚È‚Ç‚µ‚Ä‚¢‚È‚¢ê‡)
  #--------------------------------------------------------------------------
  def base_x(true_x = self.true_x)
    return (true_x - @ox) * @real_zoom + @real_x
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚ÌŽæ“¾(ˆÚ“®‚È‚Ç‚µ‚Ä‚¢‚È‚¢ê‡)
  #--------------------------------------------------------------------------
  def base_y(true_y = self.true_y)
    return (true_y - @oy) * @real_zoom + @real_y
  end
end
#==============================================================================
# ¡ Game_Party
#==============================================================================
class Game_Party
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒ^[‚ð‰Á‚¦‚é
  #     actor_id : ƒAƒNƒ^[ ID
  #--------------------------------------------------------------------------
  alias side_view_add_actor add_actor
  def add_actor(actor_id)
    # ƒAƒNƒ^[‚ðŽæ“¾
    actor = $game_actors[actor_id]
    # ƒTƒCƒhƒrƒ…[ƒf[ƒ^‚Ì‰Šú‰»
    actor.start_battle
    # –ß‚·
    side_view_add_actor(actor_id)
  end
end
#==============================================================================
# ¡ Scene_Battle
#==============================================================================
class Scene_Battle
  include Side_view
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_reader   :phase            # ƒtƒF[ƒY
  attr_reader   :phase4_step      # ƒtƒF[ƒY‚SƒXƒeƒbƒv
  attr_reader   :active_battler   # ‘ÎÛ‚Ì”z—ñ
  attr_reader   :target_battlers  # ‘ÎÛ‚Ì”z—ñ
  attr_reader   :animation1_id    # s“®ƒAƒjƒID
  attr_reader   :animation2_id    # ‘ÎÛƒAƒjƒID
  #--------------------------------------------------------------------------
  # œ ƒƒCƒ“ˆ—
  #--------------------------------------------------------------------------
  alias side_view_main main
  def main
    # ƒoƒgƒ‰[‰Šú‰»
    for battler in $game_party.actors + $game_troop.enemies
      battler.start_battle
    end
    # –ß‚·
    side_view_main
  end
  #--------------------------------------------------------------------------
  # œ ‘M‚«”»’è
  #--------------------------------------------------------------------------
  def flash?
    return @flash_flag ? true : false
  end  
  #--------------------------------------------------------------------------
  # œ ‘M‚«ƒAƒjƒ‘Ò‚¿ŽžŠÔŽæ“¾
  #--------------------------------------------------------------------------
  def flash_duration
    animation = nil
    if FLASH_ANIME
      animation = $data_animations[FLASH_ANIMATION_ID]
    end
    return animation != nil ? animation.frame_max * 2 + 2 : 0
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 2 : ƒAƒNƒVƒ‡ƒ“ŠJŽn)
  #--------------------------------------------------------------------------
  alias side_view_update_phase4_step2 update_phase4_step2
  def update_phase4_step2(*arg)
    battler = convert_battler2(*arg)
    battler.action
    side_view_update_phase4_step2(*arg)
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 3 : s“®‘¤ƒAƒjƒ[ƒVƒ‡ƒ“)
  #--------------------------------------------------------------------------
  alias side_view_update_phase4_step3 update_phase4_step3
  def update_phase4_step3(*arg)
    battler = convert_battler2(*arg)
    return if !battler.animation1_on and battler.action? and !battler.flash?
    if battler.flash? and FLASH_ANIME
      battler.flash_flag["normal"] = true
    end
    side_view_update_phase4_step3(*arg)
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 4 : ‘ÎÛ‘¤ƒAƒjƒ[ƒVƒ‡ƒ“)
  #--------------------------------------------------------------------------
  alias side_view_update_phase4_step4 update_phase4_step4
  def update_phase4_step4(*arg)
    battler = convert_battler2(*arg)
    targets = RTAB ? battler.target : @target_battlers
    return if !battler.animation2_on and battler.action?
    side_view_update_phase4_step4(*arg)
    for target in targets
      if RTAB
        value = nil
        if target.damage_sp.include?(battler)
          value = target.damage_sp[battler]
        end
        if target.damage.include?(battler)
          if value == nil or value == "Miss"
            value = target.damage[battler]
          elsif value.is_a?(Numeric) && value > 0
            value = target.damage[battler] == "Miss" ? value : target.damage[battler]
          end
        end
      else
        value = target.damage
      end
      if target.is_a?(Game_Actor)
        # ƒ_ƒ[ƒW‚Ìê‡
        if value.is_a?(Numeric) && value > 0
          # ƒVƒFƒCƒN‚ðŠJŽn
          target.shake = true
        end
      elsif target.is_a?(Game_Enemy)
        # ƒ_ƒ[ƒW‚Ìê‡
        if value.is_a?(Numeric) && value > 0
          # ƒVƒFƒCƒN‚ðŠJŽn
          target.shake = true
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒvƒŒƒoƒgƒ‹ƒtƒF[ƒYŠJŽn
  #--------------------------------------------------------------------------
  alias start_phase1_correct start_phase1 
  def start_phase1
    # ƒJƒƒ‰‚ÌÝ’è
    # Œ³Xƒtƒƒ“ƒgƒrƒ…[Œü‚¯‚Ì”’l‚É‚È‚Á‚Ä‚¢‚é‚½‚ß
    @zoom_rate = [1.0, 1.0]
    start_phase1_correct
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒ^[ƒRƒ}ƒ“ƒhƒtƒF[ƒYŠJŽn
  #--------------------------------------------------------------------------
  alias start_phase3_correct start_phase3 
  def start_phase3
    battler = convert_battler
    start_phase3_correct
    if RTAB
      # ƒJƒƒ‰‚ÌÝ’è
      # Œ³Xƒtƒƒ“ƒgƒrƒ…[Œü‚¯‚Ì”’l‚É‚È‚Á‚Ä‚¢‚é‚½‚ß
      @camera = "command"
      @spriteset.screen_target(0, 0, 1.0)
    end
  end
end

class Spriteset_Battle
  include Side_view
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #--------------------------------------------------------------------------
  alias side_veiw_initialize initialize
  def initialize
    side_veiw_initialize
    # ƒAƒNƒ^[ƒXƒvƒ‰ƒCƒg‚ð‰ð•ú
    for sprite in @actor_sprites
      sprite.dispose
    end
    # ƒAƒNƒ^[ƒXƒvƒ‰ƒCƒg‚ðì¬
    @actor_sprites = []
    for i in 1..Party_max
      @actor_sprites.push(Sprite_Battler.new(@viewport1))
    end
    update
  end
  #--------------------------------------------------------------------------
  # œ ‰æ–Ê‚ÌƒXƒNƒ[ƒ‹
  #--------------------------------------------------------------------------
  if method_defined?("screen_scroll")
  alias side_view_screen_scroll screen_scroll
  def screen_scroll
    side_view_screen_scroll
    # ƒAƒNƒ^[‚ÌˆÊ’u•â³
    for actor in $game_party.actors
      actor.real_x = @real_x
      actor.real_y = @real_y
      actor.real_zoom = @real_zoom
    end
  end
  end
end

class Sprite_Battler < RPG::Sprite
  include Side_view
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #     viewport : ƒrƒ…[ƒ|[ƒg
  #     battler  : ƒoƒgƒ‰[ (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @weapon = Sprite_Weapon.new(viewport, battler)
    @flying = Sprite_Flying.new(viewport, battler)
    @shadow = []
    @fly = 0
    @fly_direction = 1
    @rand = rand(10)
    @bitmaps = {}
    self.effect_clear
  end
  #--------------------------------------------------------------------------
  # œ ‰ð•ú
  #--------------------------------------------------------------------------
  alias side_view_dispose dispose
  def dispose
    side_view_dispose
    @weapon.dispose if @weapon != nil
    @flying.dispose if @flying != nil
    if @_target_sprite != nil
      @_target_sprite.bitmap.dispose
      @_target_sprite.dispose
      @_target_sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update
    super
    # ƒoƒgƒ‰[‚ª nil ‚Ìê‡
    if @battler == nil
      self.bitmap = nil
      @weapon.bitmap = nil
      loop_animation(nil)
      return
    end
    # ƒoƒgƒ‰[XV
    @battler.update 
    # ƒoƒgƒ‰[ƒAƒjƒ‚Ìƒf[ƒ^Žæ“¾
    @anime_type = @battler.anime_type
    # bitmap ‚ðƒLƒƒƒbƒVƒ…‰»
    path = @anime_type[0].to_s + "#" + @battler.pattern.to_s
    if not @bitmaps.include?(path) or @bitmaps[path].disposed?
      # ƒtƒ@ƒCƒ‹–¼‚©F‘Š‚ªŒ»Ý‚Ì‚à‚Ì‚ÆˆÙ‚È‚éê‡
       change = (@battler.character_name != @battler_name or @battler.character_hue != @battler_hue)
      if change
        # ƒrƒbƒgƒ}ƒbƒv‚ðŽæ“¾AÝ’è
        @battler_name = @battler.character_name
        @battler_hue = @battler.character_hue
        @bitmap = RPG::Cache.character(@battler_name, @battler_hue)
        @width = @bitmap.width / 4
        @height = @bitmap.height / 4
        self.ox = @width / 2
        self.oy = @height / 2
        @battler.height = @height
        @flag = true
        # í“¬•s”\‚Ü‚½‚Í‰B‚êó‘Ô‚È‚ç•s“§–¾“x‚ð 0 ‚É‚·‚é
        if @battler.dead? or @battler.hidden
          self.opacity = 0
        end
      end
      if (@anime_type[0] != @battler_condition or
         @battler.pattern != @battler_pattern or flag)
        # ƒrƒbƒgƒ}ƒbƒv‚ðŽæ“¾AÝ’è
        @battler_condition = @anime_type[0]
        @battler_pattern = @battler.pattern
        @sx = @battler.pattern * @width
        @sy = @anime_type[0] % 4 * @height
        self.bitmap = Bitmap.new(@width,@height)
        self.bitmap.blt(0,0, @bitmap,Rect.new(@sx, @sy, @width, @height))
        @bitmaps[path] = self.bitmap
        flag = false
      end
    end
     self.bitmap = @bitmaps[path]
    # ”òs
    update_fly
    # ƒVƒFƒCƒN
    update_shake
    # ‰ñ“]
    update_turning
    # ”½“]
    update_reverse    
    # ˆÚ“®
    update_moving
    # ’Ç‰ÁƒAƒjƒ
    update_add_anime
    # ƒGƒtƒFƒNƒgŒø‰Ê‚Ì“K—p
    update_effect
    # ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚ªŒ»Ý‚Ì‚à‚Ì‚ÆˆÙ‚È‚éê‡
    flag = RTAB ? true : @battler.damage == nil
    if flag and @battler.state_animation_id != @state_animation_id
      @state_animation_id = @battler.state_animation_id
      loop_animation($data_animations[@state_animation_id])
    end
    # ƒVƒFƒCƒN
    if @battler.shake
      self.start_shake(5, 5, 5)
      @battler.shake = false
    end
    # –¾–Å
    if @battler.blink
      blink_on
    else
      blink_off
    end
    # •s‰ÂŽ‹‚Ìê‡
    unless @battler_visible
      flag = RTAB ? (@battler.damage.size < 2 or @battler.damage_pop.size < 2) :
                    (@battler.damage == nil or @battler.damage_pop)
      # oŒ»
      if not @battler.hidden and not @battler.dead? and flag
        appear
        @battler_visible = true
      end
    end
    if RTAB
    # ƒ_ƒ[ƒW
    for battler in @battler.damage_pop
      if battler[0].class == Array
        if battler[0][1] >= 0
          $scene.skill_se
        else
          $scene.levelup_se
        end
        damage(@battler.damage[battler[0]], false, 2)
      else
        damage(@battler.damage[battler[0]], @battler.critical[battler[0]])
      end
      if @battler.damage_sp.include?(battler[0])
        damage(@battler.damage_sp[battler[0]],
                @battler.critical[battler[0]], 1)
        @battler.damage_sp.delete(battler[0])
      end
      @battler.damage_pop.delete(battler[0])
      @battler.damage.delete(battler[0])
      @battler.critical.delete(battler[0])
    end
    end
    # ‰ÂŽ‹‚Ìê‡
    if @battler_visible
      # “¦‘–
      if @battler.hidden
        $game_system.se_play($data_system.escape_se)
        escape
        @battler_visible = false
      end
      # ”’ƒtƒ‰ƒbƒVƒ…
      if @battler.white_flash
        whiten
        @battler.white_flash = false
      end
      if RTAB
      # ƒAƒjƒ[ƒVƒ‡ƒ“
      if !@battler.animation.empty?
        for animation in @battler.animation.reverse
          if animation[2]
            animation($data_animations[animation[0]], animation[1], true)
          else
            animation($data_animations[animation[0]], animation[1])
          end
          @battler.animation.delete(animation)
        end
      end
      else
      # ƒAƒjƒ[ƒVƒ‡ƒ“
      if @battler.animation_id != 0
        animation = $data_animations[@battler.animation_id]
        animation(animation, @battler.animation_hit)
        @battler.animation_id = 0
      end
      end
      # ƒ_ƒ[ƒW
      if !RTAB and @battler.damage_pop
        damage(@battler.damage, @battler.critical)
        @battler.damage = nil
        @battler.critical = false
        @battler.damage_pop = false
      end
      flag = RTAB ? (@battler.damage.empty? and $scene.dead_ok?(@battler)) :
                     @battler.damage == nil
      # ƒRƒ‰ƒvƒX
      if flag and @battler.dead?
        if @battler.is_a?(Game_Actor)
          $game_system.se_play($data_system.actor_collapse_se)
        elsif @battler.is_a?(Game_Enemy)
          $game_system.se_play($data_system.enemy_collapse_se)
        end
        collapse
        @battler_visible = false
      end
    end
    # ƒXƒvƒ‰ƒCƒg‚ÌÀ•W‚ðÝ’è
    self.x = @battler.screen_x + @effect_ox
    self.y = @battler.screen_y + @effect_oy
    self.z = @battler.screen_z
    self.zoom_x = @battler.real_zoom
    self.zoom_y = @battler.real_zoom
    # ƒEƒFƒCƒgƒJƒEƒ“ƒg‚ðŒ¸‚ç‚·
    @battler.wait_count -= 1
    @battler.wait_count2 -= 1
    # ƒAƒjƒ[ƒVƒ‡ƒ“‘Ò‚¿ŽžŠÔŽæ“¾
    @battler.animation_duration = @_animation_duration
    if @battler.is_a?(Game_Actor)
      self.zoom_x *= CHAR_ZOOM
      self.zoom_y *= CHAR_ZOOM
    end
    # ‰“‹——£ƒAƒjƒ
    if @battler.flying_anime != [0,0,false,false] and @flying.nil?
      @flying = Sprite_Flying.new(self.viewport, @battler)
    elsif @battler.flying_anime == [0,0,false,false] and !@flying.nil?
      @flying.dispose
      @flying = nil
    end
    if @flying != nil
      @flying.battler = @battler
      @flying.update
    end
    if @battler.is_a?(Game_Actor)
      # •ŠíƒAƒjƒ
      if @battler.weapon_anime_type1 and @weapon.nil?
        @weapon = Sprite_Weapon.new(self.viewport, @battler)
      elsif !@battler.weapon_anime_type1 and !@weapon.nil?
        @weapon.dispose
        @weapon = nil
      end
      if @weapon != nil
        @weapon.battler = @battler
        @weapon.update
        @weapon.opacity = self.opacity
        @weapon.x = self.x + BLZ_X[@battler.weapon_anime_type3][@battler.pattern]
        @weapon.y = self.y + BLZ_Y[@battler.weapon_anime_type3][@battler.pattern]
        @weapon.angle = BLZ_ANGLE[@battler.weapon_anime_type3][@battler.pattern]
        if self.mirror
          @weapon.angle += @weapon.angle - 180
        end
      end
    end
    # Žc‘œ
    if @battler.shadow
      if Graphics.frame_count % 2 == 0
        shadow = ::Sprite.new(self.viewport)
        shadow.bitmap = self.bitmap.dup
        shadow.x = self.x
        shadow.y = self.y
        shadow.ox = self.ox
        shadow.oy = self.oy
        shadow.mirror = self.mirror
        shadow.angle = self.angle
        shadow.opacity = 160
        shadow.zoom_x = self.zoom_x
        shadow.zoom_y = self.zoom_y
        if @battler.is_a?(Game_Actor)
          shadow.src_rect.set(@sx, @sy, @width, @height)
        else
          shadow.src_rect.set(0, 0, @width, @height)
        end
        @shadow.push([shadow,duration = 10,@battler.true_x + @effect_ox,@battler.true_y + @effect_oy])
      end
    end
    for s in @shadow
      if !s[0].disposed?
        s[0].update
        s[1] -= 1
        if s[1] < 1
          if s[0].bitmap != nil
            s[0].bitmap.dispose
          end
          s[0].dispose
        else
          s[0].x = @battler.screen_x(s[2])
          s[0].y = @battler.screen_y(s[3])
        end
      else
        s = nil
      end
    end
    @shadow.compact!
  end
  #--------------------------------------------------------------------------
  # œ ƒGƒtƒFƒNƒg‚É‚æ‚éÀ•WŒn‚ÌXV
  #--------------------------------------------------------------------------
  def update_effect
    # Šp“x‚ÌC³
    if @_upside_down
      self.angle = (@_turning + 180) % 360
    else
      self.angle = @_turning
    end
    # X À•W‚ÌC³’l
    @effect_ox = @_shake + @_moving[0]
    # Y À•W‚ÌC³’l
    @effect_oy = -@fly + @_moving[1]
    if  @_animation == nil or (RTAB and @_animation.empty?)
      self.effect_clear
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒVƒFƒCƒNXV
  #--------------------------------------------------------------------------
  def update_shake
    if @_shake_duration >= 1 or @_shake != 0
      delta = (@_shake_power * @_shake_speed * @_shake_direction) / 10.0
      if @_shake_duration <= 1 and @_shake * (@_shake + delta) < 0
        @_shake = 0
      else
        @_shake += delta
      end
      if @_shake > @_shake_power * 2
        @_shake_direction = -1
      end
      if @_shake < - @_shake_power * 2
        @_shake_direction = 1
      end
      if @_shake_duration >= 1
        @_shake_duration -= 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ”òsXV
  #--------------------------------------------------------------------------
  def update_fly
    if @rand > 0
      @rand -= 1
      return
    end
    if @battler.fly != 0
      if @fly < @battler.fly / 4
        @fly_direction = 1
      elsif @fly > @battler.fly / 2
        @fly_direction = -1
      end
      @fly += 0.5 * @fly_direction
    end
  end
  #--------------------------------------------------------------------------
  # œ ‰ñ“]XV
  #--------------------------------------------------------------------------
  def update_turning
    if @_turning_duration > 0 or @_turning != 0
      @_turning += @_turning_direction * @_turning_speed / 2.0
      # Žc‚è‰ñ“]”‚ðŒ¸‚ç‚·
      if @_turning_direction == -1
        if @_turning_duration > 0 and @_turning < 0
          @_turning_duration -= 1
        end
      elsif @_turning_direction == 1
        if @_turning_duration > 0 and @_turning >= 360
          @_turning_duration -= 1
        end
      end
      # ˆÈ‰º•â³
      while @_turning < 0
        @_turning += 360
      end
      if @_turning_duration <= 0
        @_turning = 0
      end
      @_turning %= 360
    end
  end
  #--------------------------------------------------------------------------
  # œ ¶‰E”½“]XV
  #--------------------------------------------------------------------------
  def update_reverse
    if @last_reverse != (@_reverse or @battler.reverse)
      self.mirror = (@_reverse or @battler.reverse)
      @last_reverse = (@_reverse or @battler.reverse)
    end
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®XV
  #--------------------------------------------------------------------------
  def update_moving
    @move_distance = (@_move_coordinates[2] - @_move_coordinates[0]).abs +
                     (@_move_coordinates[3] - @_move_coordinates[1]).abs
    if @move_distance > 0
      return if @_moving[0] == @_move_coordinates[0] and @_moving[1] == @_move_coordinates[1]
      array = @_move_coordinates
      x = (array[2] + 1.0 * (array[0] - array[2]) * (@move_distance - @_move_duration) / @move_distance.to_f).to_i
      y = (array[3] + 1.0 * (array[1] - array[3]) * (@move_distance - @_move_duration) / @move_distance.to_f).to_i
      @_moving = [x, y]
      if @_move_quick_return and @_move_duration == 0
        @_move_coordinates = [0,0,array[0],array[1]]
        @_move_duration = @move_distance
      end
      @_move_duration -= @_move_speed
      @_move_duration = [@_move_duration, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # œ ’Ç‰ÁƒAƒjƒXV (RTABŒÀ’è‹@”\)
  #--------------------------------------------------------------------------
  def update_add_anime
    if RTAB
    # ƒAƒjƒ[ƒVƒ‡ƒ“
    if @_add_anime_id != 0
      animation = $data_animations[@_add_anime_id]
      animation(animation, true)
      @_add_anime_id = 0
    end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒGƒtƒFƒNƒg‰Šú‰»
  #--------------------------------------------------------------------------
  def effect_clear
    @_effect_ox = 0
    @_effect_oy = 0
    @_shake_power = 0
    @_shake_speed = 0
    @_shake_duration = 0
    @_shake_direction = 1
    @_shake = 0
    @_upside_down = false
    @_reverse = false
    @_turning_direction = 1
    @_turning_speed = 0
    @_turning_duration = 0
    @_turning = 0
    @_move_quick_return = true
    @_move_speed = 0
    @_move_coordinates = [0,0,0,0]
    @_move_jump = false
    @_move_duration = 0
    @_moving = [0,0]
    @_add_anime_id = 0
  end
  #--------------------------------------------------------------------------
  # œ ƒVƒFƒCƒN‚ÌŠJŽn
  #     power    : ‹­‚³
  #     speed    : ‘¬‚³
  #     duration : ŽžŠÔ
  #--------------------------------------------------------------------------
  def start_shake(power, speed, duration)
    @_shake_power = power
    @_shake_speed = speed
    @_shake_duration = duration
  end
  #--------------------------------------------------------------------------
  # œ ã‰º”½“]‚ðŠJŽn
  #--------------------------------------------------------------------------
  def start_upside_down
    @_upside_down = @_upside_down ? false : true
  end
  #--------------------------------------------------------------------------
  # œ ¶‰E”½“]‚ðŠJŽn
  #--------------------------------------------------------------------------
  def start_reverse
    @_reverse = @_reverse ? false : true
  end
  #--------------------------------------------------------------------------
  # œ ‰ñ“]‚ðŠJŽn
  #     direction: •ûŒü
  #     speed    : ‘¬‚³
  #     duration : ŽžŠÔ
  #--------------------------------------------------------------------------
  def start_turning(direction, speed, duration)
    @_turning_direction = direction
    @_turning_speed = speed
    @_turning_duration = duration
    @_turning = @_turning_direction == 1 ? 0 : 360
  end
  #--------------------------------------------------------------------------
  # œ ˆÚ“®‚ðŠJŽn
  #     quick_return : –ß‚é‚©‚Ç‚¤‚©
  #     speed        : ‘¬‚³
  #     x            : X À•W
  #     y            : Y À•W
  #--------------------------------------------------------------------------
  def start_moving(quick_return, speed, x, y)
    @_move_quick_return = quick_return == 0 ? false : true
    @_move_speed = speed
    @_move_coordinates = [x,y,@_move_coordinates[0],@_move_coordinates[1]]
    distance = (@_move_coordinates[2] - @_move_coordinates[0]).abs +
               (@_move_coordinates[3] - @_move_coordinates[1]).abs
    @_move_duration = distance
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒjƒ’Ç‰Á‚ðŠJŽn
  #     id           : ID
  #     hit          : –½’†ƒtƒ‰ƒbƒO
  #--------------------------------------------------------------------------
  def start_add_anime(id)
    @_add_anime_id = id
  end
  #--------------------------------------------------------------------------
  # œ ŠeŽíƒGƒtƒFƒNƒg‚ÌŠJŽn”»’è
  #--------------------------------------------------------------------------
  if !method_defined?("side_view_animation_process_timing")
    alias side_view_animation_process_timing animation_process_timing
  end
  def animation_process_timing(timing, hit)
    side_view_animation_process_timing(timing, hit)
    if (timing.condition == 0) or
       (timing.condition == 1 and hit == true) or
       (timing.condition == 2 and hit == false)
      if timing.se.name =~ SHAKE_FILE
        names = timing.se.name.split(/#/)
        power    = names[1].nil? ? SHAKE_POWER    : names[1].to_i
        speed    = names[2].nil? ? SHAKE_SPEED    : names[2].to_i
        duration = names[3].nil? ? SHAKE_DURATION : names[3].to_i
        # ƒVƒFƒCƒN‚ðŠJŽn
        self.start_shake(power, speed, duration)
      end
      if timing.se.name == UPSIDE_DOWN_FILE
        # ã‰º”½“]‚ðŠJŽn
        self.start_upside_down
      end
      if timing.se.name == REVERSE_FILE
        # ¶‰E”½“]‚ðŠJŽn
        self.start_reverse
      end
      if timing.se.name =~ TURNING_FILE
        names = timing.se.name.split(/#/)
        direction = names[1].nil? ? TURNING_DIRECTION : names[1].to_i
        speed     = names[2].nil? ? TURNING_SPEED     : names[2].to_i
        duration  = names[3].nil? ? TURNING_DURATION  : names[3].to_i
        # ‰ñ“]‚ðŠJŽn
        self.start_turning(direction, speed, duration)
      end
      if timing.se.name =~ MOVE_FILE
        names = timing.se.name.split(/#/)
        quick_return= names[1].nil? ? MOVE_RETURN      : names[1].to_i
        speed       = names[2].nil? ? MOVE_SPEED       : names[2].to_i
        x           = names[3].nil? ? MOVE_COORDINATES[0] : names[3].to_i
        y           = names[3].nil? ? MOVE_COORDINATES[1] : names[4].to_i
        # ˆÚ“®‚ðŠJŽn
        self.start_moving(quick_return, speed, x, y)
      end
      if timing.se.name =~ ADD_ANIME_FILE
        names = timing.se.name.split(/#/)
        id = names[1].nil? ? ADD_ANIME_ID      : names[1].to_i
        # ƒAƒjƒ’Ç‰Á‚ðŠJŽn
        self.start_add_anime(id)
      end
    end
  end
end
#==============================================================================
# ¡ Sprite_Weapon
#------------------------------------------------------------------------------
# @ƒoƒgƒ‰[•\Ž¦—p‚ÌƒXƒvƒ‰ƒCƒg‚Å‚·BGame_Battler ƒNƒ‰ƒX‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ðŠÄŽ‹‚µA
# ƒXƒvƒ‰ƒCƒg‚Ìó‘Ô‚ðŽ©“®“I‚É•Ï‰»‚³‚¹‚Ü‚·B
#==============================================================================

class Sprite_Weapon < ::Sprite
  include Side_view
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_accessor :battler                  # ƒoƒgƒ‰[
  attr_reader   :cw                       # ƒOƒ‰ƒtƒBƒbƒN‚Ì•
  attr_reader   :ch                       # ƒOƒ‰ƒtƒBƒbƒN‚Ì‚‚³
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #     viewport : ƒrƒ…[ƒ|[ƒg
  #     battler  : ƒoƒgƒ‰[ (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
  end
  #--------------------------------------------------------------------------
  # œ ‰ð•ú
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update
    super
    # ƒoƒgƒ‰[‚ª nil ‚Ìê‡
    if @battler == nil or !@battler.is_a?(Game_Actor)
      self.bitmap = nil
      return
    end
    # ƒEƒGƒ|ƒ“ƒAƒjƒ‚Ìƒf[ƒ^Žæ“¾
    @weapon_anime_type = @battler.weapon_anime_type
    # Ý’è‚ªu”ñ•\Ž¦v‚Ìê‡
    if !@weapon_anime_type[1] or @weapon_anime_type[0].nil?
      self.visible = false
      return
    else
      self.visible = true
    end
    # ƒtƒ@ƒCƒ‹–¼‚ªŒ»Ý‚Ì‚à‚Ì‚ÆˆÙ‚È‚éê‡
    if @weapon_anime_type[0] != @weapon_name
      @weapon_name = @weapon_anime_type[0]
      # ƒrƒbƒgƒ}ƒbƒv‚ðŽæ“¾AÝ’è
      self.bitmap = RPG::Cache.icon(@weapon_name)
      @width = bitmap.width
      @height = bitmap.height
      @flag = true
    end
    # Œ»ÝƒAƒjƒƒpƒ^[ƒ“‚ªŒ»Ý‚Ì‚à‚Ì‚ÆˆÙ‚È‚éê‡
    if @pattern != @battler.pattern or @flag or @condition != @battler.condition
      @pattern = @battler.pattern
      @condition = @battler.condition
      self.ox = @width
      self.oy = @height
      self.z = battler.screen_z
      self.zoom_x = @battler.real_zoom * CHAR_ZOOM
      self.zoom_y = @battler.real_zoom * CHAR_ZOOM
      self.src_rect.set(0, 0, @width, @height)
      self.opacity = 255
      # ƒoƒgƒ‰[‚æ‚èŽè‘O‚É•\Ž¦
      if @weapon_anime_type[2]
        self.z += 10
      # ƒoƒgƒ‰[‚æ‚è‰œ‚É•\Ž¦
      else
        self.z -= 10
      end
      @flag = false
    end
  end
end

#==============================================================================
# ¡ Sprite_Flying
#------------------------------------------------------------------------------
# @ƒoƒgƒ‰[•\Ž¦—p‚ÌƒXƒvƒ‰ƒCƒg‚Å‚·BGame_Battler ƒNƒ‰ƒX‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ðŠÄŽ‹‚µA
# ƒXƒvƒ‰ƒCƒg‚Ìó‘Ô‚ðŽ©“®“I‚É•Ï‰»‚³‚¹‚Ü‚·B
#==============================================================================

class Sprite_Flying < RPG::Sprite
  include Side_view
  LATE_COUNT = 20
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_accessor :battler                  # ƒoƒgƒ‰[
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #     viewport : ƒrƒ…[ƒ|[ƒg
  #     battler  : ƒoƒgƒ‰[ (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @later = LATE_COUNT
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update
    super
    # ƒoƒgƒ‰[‚ª nil ‚Ìê‡
    if @battler == nil
      self.bitmap = nil
      loop_animation(nil)
      return
    end
    # ‰“‹——£ƒAƒjƒ
    flying_animation = @battler.flying_animation
    flying_start = flying_animation[0]
    flying_end   = flying_animation[1]
    # ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚ªŒ»Ý‚Ì‚à‚Ì‚ÆˆÙ‚È‚éê‡
    if @anime_id != @battler.flying_anime[0]
      @anime_id = @battler.flying_anime[0]
      @animation = $data_animations[@anime_id]
    end
    # ƒAƒjƒ[ƒVƒ‡ƒ“ ŠJŽn
    if flying_start
      animation(@animation,true)
    elsif flying_end
      # Á‹Ž‚ð’x‚ç‚¹‚Ä‚Ý‚½‚è‚·‚é
      @later -= 1
      if @later < 0
        animation(nil, true)
        @later = LATE_COUNT
      end
    end
    self.x = @battler.flying_x
    self.y = @battler.flying_y
    self.z = @battler.screen_z + 1000
  end
end
module RPG
  class Skill
    #--------------------------------------------------------------------------
    # œ –‚–@‚©‚Ç‚¤‚©‚Ì”»’f
    #--------------------------------------------------------------------------
    def magic?
      if @atk_f == 0
        return true
      else
        return false
      end
    end
  end
end

# ƒAƒ[ƒJ[ƒ\ƒ‹‚ÌˆÊ’uC³

class Arrow_Actor < Arrow_Base
  include Side_view
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  alias side_view_update update
  def update
    side_view_update
    # ƒXƒvƒ‰ƒCƒg‚ÌÀ•W‚ðÝ’è
    if self.actor != nil && (self.x != self.actor.screen_x + ARROW_OX or self.y != self.actor.screen_y + ARROW_OY)
      self.x = self.actor.screen_x + ARROW_OX
      self.y = self.actor.screen_y + ARROW_OY
    end
  end
end
class Arrow_Enemy < Arrow_Base
  include Side_view
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  alias side_view_update update
  def update
    side_view_update
    # ƒXƒvƒ‰ƒCƒg‚ÌÀ•W‚ðÝ’è
    if self.enemy != nil && (self.x != self.enemy.screen_x + ARROW_OX or self.y != self.enemy.screen_y + ARROW_OY)
      self.x = self.enemy.screen_x + ARROW_OX
      self.y = self.enemy.screen_y + ARROW_OY
    end
  end
end