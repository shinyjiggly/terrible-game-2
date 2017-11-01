#==============================================================================
# ** Animated Battlers - Enhanced   ver. 13.8                      (01-07-2012)
#
#------------------------------------------------------------------------------
#  * (4) Miscellaneous:  Formations, Viewport and various Detection routines.
#==============================================================================  
 
#==============================================================================
# ** RPG::Cache
#------------------------------------------------------------------------------
#  This is a module that loads each of RPGXP's graphic formats, creates a 
#  Bitmap object, and retains it.
#==============================================================================

module RPG::Cache
  #--------------------------------------------------------------------------
  # * Test Cache File #2 (existing hue option)
  #     type     : cache type (character, battler, panorama, etc.)
  #     filename : filename of the cached bitmap
  #--------------------------------------------------------------------------  
  def self.test_2(type, filename)
    failed = false
    begin
      bitmap = eval("self.#{type}(filename, 0)")
    rescue Errno::ENOENT      
      failed = true
    end
    return !failed
  end
end



#============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :advantage_set            # holds value for sideview systems  
  attr_accessor :mnk_battlers_reloaded    # if battler spriteset resets
  
end


#============================================================================== 
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  # Auto-Detection Values
  attr_accessor :mnk_det_abs_detect       # Trickster's ATB System Detection
  attr_accessor :mnk_det_acb_detect       # Action Cost Battlesystem Detection
  attr_accessor :mnk_det_claihms_ts       # Claihm's Tactical Skills Detection
  attr_accessor :mnk_det_para_spell       # ParaDog Detection
  attr_accessor :mnk_det_cfc_detect       # Charlie Fleed's CTB Detection
  attr_accessor :mnk_det_rtab_attck       # Connected Attacking Detection
  attr_accessor :mnk_det_rtab_systm       # RTAB Detection
  attr_accessor :mnk_det_trtab_syst       # TRTAB Detection  
  attr_accessor :mnk_det_sd_casting       # DBS Skill Delay Detection
  # Inter-Class variables
  attr_accessor :sv_angle                 # sideview system angle  
  attr_accessor :victory                  # victory boolean
  attr_accessor :defeat                   # defeat boolean
  # Additional values for the $global's save/load feature
  attr_accessor :mnk_sm                   # sideview mirror
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias mnk_init initialize
  def initialize
    # Perform the original call
    mnk_init
    # Create the savable values
    @mnk_sm  = 0
  end  
end  



#==============================================================================
# ** Interpreter
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #-------------------------------------------------------------------------
  # * Change Party Member
  #--------------------------------------------------------------------------
  alias mnk_c129 command_129
  def command_129
    $game_temp.mnk_battlers_reloaded = nil
    mnk_c129
  end
end



#===================================================\==========================
# ** Scene_Save
#------------------------------------------------------------------------------
#  This class performs save screen processing.
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Write Save Data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  alias mnk_wsd write_save_data
  def write_save_data(file)
    # Store the globals
    $game_system.mnk_sm  = $sideview_mirror
    # Perform the original call
    mnk_wsd(file)
  end
end


#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  This class performs load screen processing.
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Read Save Data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  alias mnk_rsd read_save_data
  def read_save_data(file)
    #Perform the original call
    mnk_rsd(file)
    # ReStore the globals
    $sideview_mirror      = $game_system.mnk_sm
  end
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
  attr_accessor :attacking                # if attacking
  attr_accessor :casted                   # if spell is casted
  attr_accessor :casting                  # if currently casting
  attr_accessor :skill_casted             # ID of skill used
  attr_accessor :strike_skill
  attr_accessor :strike_item
  attr_accessor :struck_weapon
  attr_accessor :struck_skill
  attr_accessor :struck_item
  attr_accessor :skill_used
  attr_accessor :item_used  
  attr_accessor :jump
  attr_accessor :wait
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias mnk_init initialize
  def initialize
    @attacking      = false
    @casted         = false 
    @casting        = false
    @skill_casted   = 0
    @strike_skill   = 0
    @strike_item    = 0
    @struck_weapon  = 0
    @struck_skill   = 0
    @struck_item    = 0
    @skill_used     = 0
    @item_used      = 0   
    @jump           = nil
    mnk_init
    # Detection (ParaDog, DBS Delay, Fomar, Trickster's AT, Charlie, TRTAB)
    $game_system.mnk_det_para_spell = true  if defined?(spelling?)
    $game_system.mnk_det_sd_casting = true  if @sd_casting != nil
    $game_system.mnk_det_acb_detect = true  if @vitality != nil
    $game_system.mnk_det_abs_detect = true  if @at_bonus != nil
    $game_system.mnk_det_cfc_detect = true  if $charlie_lee_ctb
    $game_system.mnk_det_trtab_syst = true  if defined?(SDK.enabled?('RTAB Battle System'))
  end
end



#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor
  alias mnk_ini initialize
  def initialize(actor_id)
    mnk_ini(actor_id)
    $game_system.mnk_det_rtab_attck = true if defined?(change_weapon)
  end    
  #--------------------------------------------------------------------------
  # * Actor X Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    return 0 if self.index == nil
    if $game_system.sv_angle == 1
      if self.index > 3
        return 640 - ((self.index - 2) * 45 + 360)
      else
        return 640 - (self.index * 45 + 360)
      end
    else
      if self.index > 3
        return (self.index - 2) * 45 + 360
      else
        return self.index * 45 + 360
      end
    
    end
  end
  #-------------------------------------------------------------------------- 
  # * Actor Y Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    return 0 if self.index == nil
    if self.index > 3
      return (self.index - 4) * 35 + 200
    else
      return self.index * 35 + 200
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Z Coordinate
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y
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
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    if self.index != nil
      if $game_system.sv_angle == 1
        return 640 - $data_troops[@troop_id].members[@member_index].x
      else
        return $data_troops[@troop_id].members[@member_index].x
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Z Coordinate
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y
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
  attr_reader   :party_size
end


#============================================================================== 
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within
#  the Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Change Enemy Viewport
  #--------------------------------------------------------------------------
  alias mnk_initialize initialize
  def initialize
    mnk_initialize
    # Determine if RTAB system in use
    $game_system.mnk_det_rtab_systm = true if @real_zoom != nil
    # Reset Screentones
    @enemy_sprites = []
    for enemy in $game_troop.enemies.reverse
      if SCREENTONE_ENEMY_MATCH
        @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
      else
        @enemy_sprites.push(Sprite_Battler.new(@viewport2, enemy))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias mnk_update update
  def update
    # Set current number of battlers
    mnkps = 4
    mnkps = $game_party.party_size if $game_party.party_size != nil
    # Added routine to load battlers during combat
    unless $game_temp.mnk_battlers_reloaded
      @actor_sprites = []
      @viewport1.update
      @viewport2.update
      for i in 0...mnkps
        if SCREENTONE_ACTOR_MATCH
          @actor_sprites.push(Sprite_Battler.new(@viewport1))
        else
          @actor_sprites.push(Sprite_Battler.new(@viewport2))
        end
      end
      $game_temp.mnk_battlers_reloaded = true
    end      
    # Perform the original call    
    mnk_update
    # 'Re-'Update actor sprite contents (corresponds with actor switching)
    for i in 0...mnkps
      @actor_sprites[i].battler = $game_party.actors[i]
    end    
  end
  #--------------------------------------------------------------------------
  # * Find Sprite From Battler Handle
  #--------------------------------------------------------------------------
  def battler(handle)
    for sprite in @actor_sprites + @enemy_sprites
      return sprite if sprite.battler == handle
    end
  end
end


#==============================================================================
# ** Arrow_Base
#------------------------------------------------------------------------------
#  This sprite is used as an arrow cursor for the battle screen. This class
#  is used as a superclass for the Arrow_Enemy and Arrow_Actor classes.
#==============================================================================

class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  # * Reposition Arrows
  #--------------------------------------------------------------------------
  alias mnk_initialize initialize
  def initialize(viewport)
    mnk_initialize(viewport)
    self.ox = MNK_ARROW_X
    self.oy = MNK_ARROW_Y
  end
end
