#===============================================================================
# ** Battle : Retry
#===============================================================================
 
#-------------------------------------------------------------------------------
# * SDK Log
#-------------------------------------------------------------------------------
SDK.log('Battle.Retry', 'Kain Nobel  ©', 2.5, '12.10.2008')
#-------------------------------------------------------------------------------
# * SDK Enabled Test : BEGIN
#-------------------------------------------------------------------------------
if SDK.enabled?('Battle.Retry')
 
#===============================================================================
# ** BattleRetry
#===============================================================================
 
module BattleRetry
  #-----------------------------------------------------------------------------
  # * Customizable Constants
  #-----------------------------------------------------------------------------
  Filepath = "Data/BattleRetry.rxdata"
  Commands = nil
  #-----------------------------------------------------------------------------
  # * BattleRetry.commands
  #-----------------------------------------------------------------------------
  def self.commands
     c = Commands.is_a?(Array) && Commands.length == 3 ? Commands : [nil,nil,nil]
     c[0] = 'Restart Battle'                                     if !c[0].is_a?(String)
     c[1] = SDK::Scene_Commands::Scene_End::To_Title if !c[1].is_a?(String)
     c[2] = SDK::Scene_Commands::Scene_End::Shutdown if !c[2].is_a?(String)
     return c
  end
  #-----------------------------------------------------------------------------
  # * BattleRetry.save
  #-----------------------------------------------------------------------------
  def self.save
     $battle_retry_temp = $game_temp
     file = File.open(Filepath, 'wb')
     (Scene_Save.new).write_save_data(file)
     file.close
  end
  #-----------------------------------------------------------------------------
  # * BattleRetry.load
  #-----------------------------------------------------------------------------
  def self.load
     file = File.open(Filepath, 'rb')
     (Scene_Load.new).read_save_data(file)
     file.close
  end
  #-----------------------------------------------------------------------------
  # * BattleRetry.delete
  #-----------------------------------------------------------------------------
  def self.delete
     if FileTest.exist?(Filepath)
        File.delete(Filepath)
        $battle_retry_temp = nil
     end
  end
  #-----------------------------------------------------------------------------
  # * BattleRetry.start_battle
  #-----------------------------------------------------------------------------
  def self.start_battle
     BattleRetry.load
     $game_temp = $battle_retry_temp
     $game_temp.gameover = nil
     $game_system.bgm_play($battle_retry_BGM)
     $game_system.bgs_play($battle_retry_BGS)
     $scene = Scene_Battle.new
  end
  #-----------------------------------------------------------------------------
  # * BattleRetry.to_title
  #-----------------------------------------------------------------------------
  def self.to_title
     BattleRetry.delete
     $scene = Scene_Title.new
  end
  #-----------------------------------------------------------------------------
  # * BattleRetry.shutdown
  #-----------------------------------------------------------------------------
  def self.shutdown
     BattleRetry.delete
     Audio.bgm_fade(800)
     Audio.bgs_fade(800)
     Audio.me_fade(800)
     $scene = nil
  end
end
 
#===============================================================================
# ** Scene_Map
#===============================================================================
 
class Scene_Map < SDK::Scene_Base
  #-----------------------------------------------------------------------------
  # * Alias Listings
  #-----------------------------------------------------------------------------
  alias_method :btlrtry_scene_map_main,             :main
  alias_method :btlrtry_scene_map_update,          :update
  alias_method :btlrtry_scene_map_call_battle,   :call_battle
  #-----------------------------------------------------------------------------
  # * Main
  #-----------------------------------------------------------------------------
  def main
     $battle_retry_BGM = $battle_retry_BGS = nil
     btlrtry_scene_map_main
  end
  #-----------------------------------------------------------------------------
  # * Update
  #-----------------------------------------------------------------------------
  def update
     if $game_party.all_dead? || $scene.is_a?(Scene_Gameover)
        $battle_retry_temp |= nil
     end
     btlrtry_scene_map_update
  end
  #-----------------------------------------------------------------------------
  # * Call Battle
  #-----------------------------------------------------------------------------
  def call_battle
     btlrtry_scene_map_call_battle
     $battle_retry_BGM = $game_system.playing_bgm.clone
     $battle_retry_BGS = $game_system.playing_bgs.clone
  end
end
 
#===============================================================================
# ** Scene_Battle
#===============================================================================
 
class Scene_Battle < SDK::Scene_Base
  #-----------------------------------------------------------------------------
  # * Alias Listings
  #-----------------------------------------------------------------------------
  alias_method :btlrtry_scene_battle_main_variable,   :main_variable
  alias_method :btlrtry_scene_battle_main_end,          :main_end
  #-----------------------------------------------------------------------------
  # * Main Processing
  #-----------------------------------------------------------------------------
  def main_variable
     if !$battle_retry_temp && !$game_temp.battle_can_lose
        BattleRetry.save
     end
     btlrtry_scene_battle_main_variable
  end
  #-----------------------------------------------------------------------------
  # * Main End
  #-----------------------------------------------------------------------------
  def main_end
     btlrtry_scene_battle_main_end
     unless $scene.is_a?(Scene_Gameover)
        BattleRetry.delete
     end
  end
end
 
#===============================================================================
# ** Scene_Gameover
#===============================================================================
 
class Scene_Gameover < SDK::Scene_Base
  #-----------------------------------------------------------------------------
  # * Alias Listings
  #-----------------------------------------------------------------------------
  alias_method :btlrtry_scene_gameover_main_window, :main_window
  alias_method :btlrtry_scene_gameover_update,         :update
  #-----------------------------------------------------------------------------
  # * Main Method
  #-----------------------------------------------------------------------------
  def main_window
     btlrtry_scene_gameover_main_window
     super
     if $battle_retry_temp
        @battle_retry_window = Window_Command.new(192, BattleRetry.commands)
        @battle_retry_window.back_opacity = 160
        @battle_retry_window.x = 320 - (@battle_retry_window.width / 2)
        @battle_retry_window.y = 288
     end
  end
  #-----------------------------------------------------------------------------
  # * Main Update
  #-----------------------------------------------------------------------------
  def update
     btlrtry_scene_gameover_update
     if $battle_retry_temp
        if Input.trigger?(Input::C)
           $game_system.se_play($data_system.decision_se)
           case @battle_retry_window.index
           when 0 ; BattleRetry.start_battle
           when 1 ; BattleRetry.to_title
           when 2 ; BattleRetry.shutdown
           end
        end
     end
  end
end
 
#-------------------------------------------------------------------------------
# * SDK Enabled Test : END
#-------------------------------------------------------------------------------
end