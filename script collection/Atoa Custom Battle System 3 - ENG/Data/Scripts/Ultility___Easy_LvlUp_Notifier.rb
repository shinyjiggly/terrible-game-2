#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# Easy LvlUp Notifier by Blizzard - ACBS ver.
# This version was modified by Atoa to work with the ACBS
# Version: 2.11b
# Type: Battle Report Display
# Date: 27.8.2006
# Date v1.2b: 3.11.2006
# Date v1.3b: 11.3.2007
# Date v1.4b: 22.8.2007
# Date v2.0: 25.9.2007
# Date v2.1: 4.12.2009
# Date v2.1b: 15.3.2010
# Date v2.11b: 19.3.2010
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#   
#  This work is protected by the following license:
# #----------------------------------------------------------------------------
# #  
# #  Creative Commons - Attribution-NonCommercial-ShareAlike 3.0 Unported
# #  ( http://creativecommons.org/licenses/by-nc-sa/3.0/ )
# #  
# #  You are free:
# #  
# #  to Share - to copy, distribute and transmit the work
# #  to Remix - to adapt the work
# #  
# #  Under the following conditions:
# #  
# #  Attribution. You must attribute the work in the manner specified by the
# #  author or licensor (but not in any way that suggests that they endorse you
# #  or your use of the work).
# #  
# #  Noncommercial. You may not use this work for commercial purposes.
# #  
# #  Share alike. If you alter, transform, or build upon this work, you may
# #  distribute the resulting work only under the same or similar license to
# #  this one.
# #  
# #  - For any reuse or distribution, you must make clear to others the license
# #    terms of this work. The best way to do this is with a link to this web
# #    page.
# #  
# #  - Any of the above conditions can be waived if you get permission from the
# #    copyright holder.
# #  
# #  - Nothing in this license impairs or restricts the author's moral rights.
# #  
# #----------------------------------------------------------------------------
# 
#==============================================================================

module Atoa
  #          ['Nome', Volume, Velocidade]
  Lvlup_SE = ['087-Action02', 80, 100] # SE para subida de nível
  Learn_SE = ['106-Heal02', 80, 100]   # SE para aprendizado de skill
  Old_Exp_Display = false # Mostrar exp no estilo antigo
  Center_Battlers = true  # Centralizar Battles
end

#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================

class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias easy_lvlup_notfier_refresh refresh
  def refresh
    if Old_Exp_Display
      easy_lvlup_notfier_refresh
    else
      self.contents.clear
      x = 4
      self.contents.font.color = system_color
      cx = contents.text_size('Ganhou').width
      self.contents.draw_text(x, 0, cx+4, 32, 'Ganhou')
      x += cx + 4
      self.contents.font.color = normal_color
      cx = contents.text_size(@gold.to_s).width
      self.contents.draw_text(x, 0, cx + 4, 32, @gold.to_s)
      x += cx + 4
      self.contents.font.color = system_color
      self.contents.draw_text(x, 0, 128, 32, $data_system.words.gold)
      (0...@treasures.size).each {|i| draw_item_name(@treasures[i], 4, (i+1)*32)}
      self.y = 176 - (@treasures.size * 32)
    end
  end
end

#==============================================================================
# ** Window_LevelUp
#------------------------------------------------------------------------------
#  This window displays the level up information
#==============================================================================

class Window_LevelUp < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :limit
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     a : actor
  #     d : old values
  #--------------------------------------------------------------------------
  def initialize(a, d)
    if Center_Battlers
      x = ((640 / Max_Party) * ((4 - $game_party.actors.size)/2.0 + a.index)).floor
    else
      x = a.index * 160
    end
    text = []
    text.push(['Nível:', d[0], a.level]) if d[0] != a.level
    text.push([$data_system.words.hp[0, 3], d[1], a.maxhp]) if d[1] != a.maxhp
    text.push([$data_system.words.sp[0, 3], d[2], a.maxsp]) if d[2] != a.maxsp
    text.push([$data_system.words.str[0, 3], d[3], a.str]) if d[3] != a.str
    text.push([$data_system.words.dex[0, 3], d[4], a.dex]) if d[4] != a.dex
    text.push([$data_system.words.agi[0, 3], d[5], a.agi]) if d[5] != a.agi
    text.push([$data_system.words.int[0, 3], d[6], a.int]) if d[6] != a.int
    h = text.size * 24 + (Old_Exp_Display ? 56 : 80)
    @limit = 320 - h
    y = 480 - h + (h / 64 + 1) * 64
    super(x, y, 160, h)
    self.z, self.back_opacity = 4500, Base_Opacity
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
    if $fontface != nil
      self.contents.font.name = $fontface
    elsif $defaultfonttype != nil
      self.contents.font.name = $defaultfonttype
    end
    self.contents.font.size, self.contents.font.bold = 20, true
    unless Old_Exp_Display
      self.contents.font.color = normal_color
      self.contents.draw_text(0, 24, 128, 24, "#{a.exp - d[7]} EXP", 1)
    end
    self.contents.font.color = system_color
    self.contents.draw_text(0,0, 128, 24, "#{a.name}",1)
    text.each_index {|i|
    index = Old_Exp_Display ? i : i + 1
    self.contents.draw_text(0, (index * 24) + 24, 128, 24, text[i][0])
    self.contents.draw_text(80, (index * 24) + 24, 32, 24, '»')
    self.contents.font.color = normal_color
    self.contents.draw_text(0, (index * 24) + 24, 76, 24, text[i][1].to_s, 2)
    if text[i][1] > text[i][2]
      self.contents.font.color = Color.new(255, 64, 0)
    else
      self.contents.font.color = Color.new(0, 255, 64)
    end
    self.contents.draw_text(0, (index * 24) + 24, 128, 24, text[i][2].to_s, 2)}
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias main_lvlup_later main
  def main
    @lvlup_data = {}
    @actors_windos = []
    @moving_windows, @pending_windows = [], []
    (1...$data_actors.size).each {|i|
      actor = $game_actors[i]
      @lvlup_data[actor] = [actor.level, actor.maxhp, actor.maxsp, actor.str, actor.dex, actor.agi, actor.int, actor.exp, actor.skills.clone]}
    main_lvlup_later
    (@moving_windows + @pending_windows).each {|win| win.dispose if win != nil}
  end
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  #--------------------------------------------------------------------------
  def update_phase5
    return if not_in_position($game_party.actors) or collapsing
    unless $game_temp.battle_victory
      set_result_window
      @skill_texts = []
      $game_party.actors.each {|actor|
      actor.remove_states_battle
      if @lvlup_data[actor][0, 7] != [actor.level, actor.maxhp, actor.maxsp, actor.str, actor.dex, actor.agi, actor.int]
        @pending_windows.push(Window_LevelUp.new(actor, @lvlup_data[actor]))
        @skill_texts.push('')
        new_skills = actor.skills - @lvlup_data[actor][8]
        if new_skills.size > 0
          new_skills.each {|id| @skill_texts.push("#{actor.name} aprendeu #{$data_skills[id].name}!")}
        end
      elsif @lvlup_data[actor][7] != actor.exp && !Old_Exp_Display
        @moving_windows.push(Window_LevelUp.new(actor, @lvlup_data[actor]))
      end}
    end
    if @phase5_wait_count > 0
      @phase5_wait_count -= 1
      if @phase5_wait_count == 0
        @result_window.visible, $game_temp.battle_main_phase = true, false
        @status_window.refresh
      end
      return
    end
    @moving_windows.each {|win| win.y -= [win.y - win.limit].min}
    if Input.trigger?(Input::C)
      if @skill_texts.size > 0
        text = @skill_texts.shift
        if text == ''
          $game_system.se_play(RPG::AudioFile.new(Lvlup_SE[0], Lvlup_SE[1], Lvlup_SE[2]))
          @moving_windows.push(@pending_windows.shift)
          @help_window.visible = false
        else
          $game_system.se_play(RPG::AudioFile.new(Learn_SE[0], Learn_SE[1], Learn_SE[2]))
          @help_window.set_text(text, 1)
        end
      else
        battle_end(0)
      end
    end
  end
end