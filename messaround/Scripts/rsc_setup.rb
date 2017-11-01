#==============================================================================
# ** Method and Class Library - RSC Setup
#------------------------------------------------------------------------------
# Build Date - 9-17-2006
# Version 1.0 - Trickster - 9-17-2006
# Version 1.1 - Trickster - 10-03-2006
# Version 1.2 - Trickster - Selwyn - 11-01-2006
# Version 1.3 - Trickster - 11-10-2006
# Version 1.4 - Trickster - 12-1-2006
# Version 1.5 - Trickster - Yeyinde - Lobosque - 1-1-2007
# Version 2.0 - MACL Authors - 4-26-2007
# Version 2.1 - MACL Authors - 7-22-2007
#==============================================================================

#============================================================================== 
# ** General Method & Class Library Settings
#==============================================================================

module MACL
  #-------------------------------------------------------------------------
  # * Pose Names for Charactersets
  #-------------------------------------------------------------------------
  Poses = ['down', 'left', 'right', 'up']
  #-------------------------------------------------------------------------
  # * Number of Frames Per Pose for charactersets
  #-------------------------------------------------------------------------
  Frames = 4
  #--------------------------------------------------------------------------
  # * Real Elements
  #--------------------------------------------------------------------------
  Real_Elements = 1, 2, 3, 4, 5, 6, 7, 8
  #-------------------------------------------------------------------------
  # * Version Number (Do not Touch)
  #-------------------------------------------------------------------------
  Version   = 2.1
  #-------------------------------------------------------------------------
  # * Loaded Libraries (Do not Touch)
  #-------------------------------------------------------------------------
  Loaded = []
end

#============================================================================== 
# ** Action Test Setup
#==============================================================================

class Game_BattleAction
  #-------------------------------------------------------------------------
  # * Attack Using
  #   - Set this to the basic ids that perform an attack effect
  #-------------------------------------------------------------------------
  ATTACK_USING = [0]
  #-------------------------------------------------------------------------
  # * Skill Using
  #   - Set this to the kinds that perform an skill effect
  #-------------------------------------------------------------------------
  SKILL_USING  = [1]
  #-------------------------------------------------------------------------
  # * Defend Using
  #   - Set this to the basic ids that perform an defend effect
  #-------------------------------------------------------------------------
  DEFEND_USING = [1]
  #-------------------------------------------------------------------------
  # * Item Using
  #   - Set this to the kinds that perform a item using effect
  #-------------------------------------------------------------------------
  ITEM_USING   = [2]
  #-------------------------------------------------------------------------
  # * Escape Using
  #   - Set this to the basic ids that perform an escape effect
  #-------------------------------------------------------------------------
  ESCAPE_USING = [2]
  #-------------------------------------------------------------------------
  # * Wait Using
  #   - Set this to the basic ids that perform a wait effect
  #-------------------------------------------------------------------------
  WAIT_USING  = [3]
end

#============================================================================== 
# ** Animated Autotile Settings
#==============================================================================

RPG::Cache::Animated_Autotiles_Frames = 16

#============================================================================== 
# ** Bitmap Settings
#==============================================================================

class Bitmap
  #--------------------------------------------------------------------------
  # * Bitmap.draw_equip settings
  #
  #   Icon Type Settings When Item Not Equipped
  #    - Draw_Equipment_Icon_Settings = { type_id => icon_name, ... }
  #
  #   Default Type Icons
  #    - Draw_Equipment_Icon_Settings.default = icon_name
  #--------------------------------------------------------------------------
  Draw_Equipment_Icon_Settings = { 0 => '001-Weapon01', 1 => '009-Shield01', 
    2 => '010-Head01', 3 => '014-Body02', 4 => '016-Accessory01'
  }
  Draw_Equipment_Icon_Settings.default = '001-Weapon01'
  #--------------------------------------------------------------------------
  # * Bitmap.draw_blur settings
  #
  #   Master Default Settings
  #    - Default_Blur_Settings   = { setting_key => setting, ... }
  #
  #   Class Default Settings
  #    - @@default_blur_settings = { setting_key => setting, ... }
  #
  #   Settings
  #    'offset'  - Pixels to be offseted when bluring
  #    'spacing' - Number of times to offset blur
  #    'opacity' - Max Opacity of blur
  #--------------------------------------------------------------------------
  Default_Blur_Settings   = {'offset' => 2, 'spacing' => 1, 'opacity' => 255}
  @@default_blur_settings = {'offset' => 2, 'spacing' => 1, 'opacity' => 255}
  #--------------------------------------------------------------------------
  # * Bitmap.draw_anim_sprite settings
  #
  #   Master Default Settings
  #    - Default_Anim_Sprite_Settings   = { setting_key => setting, ... }
  #
  #   Class Default Settings
  #    - @@default_anim_sprite_settings = { setting_key => setting, ... }
  #
  #   Settings
  #    'f' - Frame count reset
  #    'w' - Number of frames wide in sprite set
  #    'h' - Height of frames wide in sprite set
  #--------------------------------------------------------------------------
  Default_Anim_Sprite_Settings   = {'f' => 8, 'w' => 4, 'h' => 4}
  @@default_anim_sprite_settings = {'f' => 8, 'w' => 4, 'h' => 4}
end

#============================================================================== 
# ** RPG::State
#==============================================================================

class RPG::State
  #--------------------------------------------------------------------------
  # * Normal Icon (Filename for normal (no states))
  #--------------------------------------------------------------------------
  Normal_Icon = '050-Skill07'
  #--------------------------------------------------------------------------
  # * Icon Names
  #
  #   Icon_Name = { state_id => 'filename', ... }
  #
  #   Use Nil to default back to state name
  #--------------------------------------------------------------------------
  Icon_Name = {
    1  => '046-Skill03',
    2  => 'Stop',
    3  => 'Venom',
    4  => 'Darkness',
    5  => 'Mute',
    6  => 'Confused',
    7  => 'Sleep',
    8  => 'Paralysis',
    9  => '047-Skill04',
    10 => '047-Skill04',
    11 => 'Slow',
    12 => '047-Skill04',
    13 => '045-Skill06',
    14 => '045-Skill06',
    15 => '045-Skill06',
    16 => '045-Skill06'
  }
  Icon_Name.default = nil
end

#------------------------------------------------------------------------------
# ** Reqire MACL 2.1
#------------------------------------------------------------------------------

require 'Data/The Method and Class Library 2.1'

#------------------------------------------------------------------------------
# ** SDK Log
#------------------------------------------------------------------------------

if Object.const_defined?(:SDK)
  SDK.log('Method & Class Library', 'MACL Authors', 2.1, '??????????')
end