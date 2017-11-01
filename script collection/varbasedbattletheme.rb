=begin
????????????????????????????????????????????????????????????????????????????????
? Variable-based Battle Themes v1.1                                            ?
? by PK8                                                                       ?
? September 29th, 2009                                                         ?
? http://rmvxp.com                                                             ?
????????????????????????????????????????????????????????????????????????????????
? ? Table of Contents                                                          ?
? ?? Author's Notes                - Line 17?19                                ?
? ?? Introduction & Description    - Line 21?24                                ?
? ?? Features                      - Line 26,27                                ?
? ?? How to Use                    - Line 29?37                                ?
? ?? Methods Aliased               - Line 39?41                                ?
? ?? Thanks                        - Line 43?46                                ?
? ?? Methods Aliased               - Line 48?50                                ?
????????????????????????????????????????????????????????????????????????????????
? ? Author's Notes                                                             ?
? After working on Individual Troop Themes, I wanted to work on this script. I ?
? was pretty bored so yeah.                                                    ?
????????????????????????????????????????????????????????????????????????????????
? ? Introduction & Description                                                 ?
? This script allows developers to set battle themes depending on the value of ?
? a game variable. Useful if you want your project's battle theme changed when ?
? the player has progressed pretty far in the game.                            ?
????????????????????????????????????????????????????????????????????????????????
? ? Features                                                                   ?
? ? Set variable ID and control battle themes through the variable's value.    ?
????????????????????????????????????????????????????????????????????????????????
? ? How to Use                                                                 ?
? Varba_Var: Set game variable ID.                                             ?
?                                                                              ?
? Varba_Theme[variable id value] = ["file", volume, pitch]                     ?
? ^ Sets battle theme based on the value of the variable ID (Varba_Theme).     ?
?                                                                              ?
? Note: If you're using Individual Troop Themes, please paste this script above?
?       Individual Troop Themes. It's so Individual Troop Themes can override  ?
?       the Variable-Based Battle Theme script.                                ?
????????????????????????????????????????????????????????????????????????????????
? ? Methods Aliased                                                            ?
? ? initialize of Spriteset_Battle (RMXP)                                      ?
? ? call_battle of Scene_Map (RMVX)                                            ?
????????????????????????????????????????????????????????????????????????????????
? ? Thanks                                                                     ?
? ? If it weren't for JoeYoung's original "Individual Troop Themes" request, I ?
?   wouldn't have worked on this script.                                       ?
? ? Lowell helping me out in terms of explaining this.                         ?
????????????????????????????????????????????????????????????????????????????????
? ? Changelog (MM/DD/YYYY)                                                     ?
? v1.0 (09/29/2009): Initial release.                                          ?
? v1.1 (11/24/2009): "Merged" the RMXP and RMVX versions of this script.       ?
????????????????????????????????????????????????????????????????????????????????
=end

#------------------------------------------------------------------------------
# * Customise
#------------------------------------------------------------------------------
class PK8
  Varba_Theme = {} # Do not touch this.
  
  Varba_RMXP = true # true if using RMXP, false if using RMVX.
  Varba_Var = 1 # Set variable ID.
  
  # The value of Varba_Var controls the battle theme.
  #          [id] = [Music File, Volume, Pitch]
  Varba_Theme[1] = ["003-Battle03", 100, 100]
  Varba_Theme[2] = ["009-LastBoss01", 100, 100]
end

if PK8::Varba_RMXP == true # If using RMXP
  #=============================================================================
  # ** Spriteset_Battle
  #-----------------------------------------------------------------------------
  #  This class brings together battle screen sprites. It's used within
  #  the Scene_Battle class.
  #=============================================================================

  class Spriteset_Battle
    #--------------------------------------------------------------------------
    # * Alias Listings
    #--------------------------------------------------------------------------
    alias_method(:pk8_var_battle_theme_initialize, :initialize)
    
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize
      pk8_var_battle_theme_initialize
      start_var_battle_theme
    end
  
    #---------------------------------------------------------------------------
    # * Start Variable-based Battle Theme
    #---------------------------------------------------------------------------
    def start_var_battle_theme
      PK8::Varba_Theme.each_key { | i |
      # If Variable ID Value equals the key.
      if $game_variables[PK8::Varba_Var] == i
        # If specified BGM isn't nil or empty.
        if PK8::Varba_Theme[i][0] != nil and !PK8::Varba_Theme[i][0].empty?
          # Sets BGM volume to 100 if nil.
          PK8::Varba_Theme[i][1] = 100 if PK8::Varba_Theme[i][1] == nil
          # Sets BGM pitch to 100 if nil.
          PK8::Varba_Theme[i][2] = 100 if PK8::Varba_Theme[i][2] == nil
          # Plays BGM.
          Audio.bgm_play("Audio/BGM/#{PK8::Varba_Theme[i][0]}",
          PK8::Varba_Theme[i][1], PK8::Varba_Theme[i][2])
        end
        break
      end }
    end
  end
end

if PK8::Varba_RMXP == false # If using RMVX
  #=============================================================================
  # ** Scene_Map
  #-----------------------------------------------------------------------------
  #  This class performs the map screen processing.
  #=============================================================================

  class Scene_Map
    #---------------------------------------------------------------------------
    # * Alias Listings
    #---------------------------------------------------------------------------
    alias_method(:pk8_var_battle_theme_call_battle, :call_battle)
    
    #---------------------------------------------------------------------------
    # * Switch to Battle Screen
    #---------------------------------------------------------------------------
    def call_battle
      pk8_var_battle_theme_call_battle
      start_var_battle_theme
    end
    
    #---------------------------------------------------------------------------
    # * Start Variable-based Battle Theme
    #---------------------------------------------------------------------------
    def start_var_battle_theme
      PK8::Varba_Theme.each_key { | i |
      # If Variable ID Value equals the key.
      if $game_variables[PK8::Varba_Var] == i
        # If specified BGM isn't nil or empty.
        if PK8::Varba_Theme[i][0] != nil and !PK8::Varba_Theme[i][0].empty?
          # Sets BGM volume to 100 if nil.
          PK8::Varba_Theme[i][1] = 100 if PK8::Varba_Theme[i][1] == nil
          # Sets BGM pitch to 100 if nil.
          PK8::Varba_Theme[i][2] = 100 if PK8::Varba_Theme[i][2] == nil
          # Plays BGM.
          Audio.bgm_play("Audio/BGM/#{PK8::Varba_Theme[i][0]}",
          PK8::Varba_Theme[i][1], PK8::Varba_Theme[i][2])
        end
        break
      end }
    end
  end
end