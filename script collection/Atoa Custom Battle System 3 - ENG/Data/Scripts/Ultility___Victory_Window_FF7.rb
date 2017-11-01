#==============================================================================
# Victory Window 3
# by Atoa
# Based on Illustrationism Victory Window Script
#==============================================================================
# This scripts changes the victory window
# 
# Don't use with others 'Victory Windows' script.
#===============================================================================
 
module Atoa
  
  # Show faces on the result window?
  Use_Faces_Result = true

  # Exp bar filling speed
  Filling_Speed = 10.0
  
  # Time in frames that level up windows stay on screen
  Level_Window_Duration = 40
  
  # Name of the EXP meter graphic file
  EXP_Meter_Result = 'EXPMeter'
  
  # Settings of the texts
  Exp_Text_Name = 'Exp Gained:'
  Next_Text_Name = 'Next:'
  Level_Name_Result = 'Level:'
  Level_Up_Msg_Result = 'Level Up!'
  Learn_Msg = 'Learned:'
  Item_Get = 'Items Get:'

  # Use Victury BGM instead of ME, use if you want an victory fanfarre with loop.
  Use_Victory_BGM = true
  Victory_BGM = '050-Positive08'
  
  # SE filenames, leave nil for no sound
  Learn_SE = '105-Heal01'
  Level_Up_SE = '056-Right02'
  
  # BGS filenames, leave nil for no sound
  Exp_BGS = '032-Switch01'
  
end

#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================

class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  def initialize(exp, gold, treasures)
    @exp = exp
    @gold = gold
    @treasures = treasures
    super(0, 64, 256, 480 - 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4000
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = system_color
    self.contents.draw_text(0, 0, width - 32, 32, $data_system.words.gold, 2)
    self.contents.draw_text(0, 32, width - 32, 32, Item_Get)
    self.contents.font.color = normal_color
    self.contents.draw_text(0, 0,  width - 64, 32, @gold.to_s, 0)
    y = 64
    for item in @treasures
      draw_item_name(item, 4, y)
      y += 32
    end
  end
  #--------------------------------------------------------------------------
  # * Add extra item drops
  #--------------------------------------------------------------------------
  def add_multi_drops
    @extra_treasures = []
    for enemy in $game_troop.enemies
      @extra_treasures << enemy.multi_drops
    end
    @extra_treasures.flatten!
    for item in @extra_treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    @treasures << @extra_treasures
    @treasures.flatten!
    @treasures.sort! {|a, b| a.id <=> b.id}
    @treasures.sort! do |a, b|
      a_class = a.is_a?(RPG::Item) ? 0 : a.is_a?(RPG::Weapon) ? 1 : 2
      b_class = b.is_a?(RPG::Item) ? 0 : b.is_a?(RPG::Weapon) ? 1 : 2
      a_class <=> b_class
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
  end
end

#==============================================================================
# ** Window_BattleResultExp
#------------------------------------------------------------------------------
#  This window displays the EXP gained.
#==============================================================================

class Window_BattleResultExp < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp : EXP
  #--------------------------------------------------------------------------
  def initialize(exp)
    @exp = exp
    super(0, 0, 256, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.color = system_color
    cx = contents.text_size(Exp_Text_Name).width
    self.contents.draw_text(0, 0, 64, 32, Exp_Text_Name)
    self.contents.font.color = normal_color
    self.contents.draw_text(cx + 8, 0, width - 32, 32, @exp.to_s)
    self.z = 4000
  end
end

#==============================================================================
# ** Window_LevelUP
#------------------------------------------------------------------------------
#  This window displays the level up information
#==============================================================================

class Window_LevelUP < Window_Base
  #----------------------------------------------------------------
  # * Object Initialization
  #     y : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def initialize(y)
    super(0, y, 320, 80)
    self.visible = false
    self.z = 4100
    @time = 0
  end
  #----------------------------------------------------------------
  # * Refresh
  #     skill : skill
  #----------------------------------------------------------------
  def refresh(skill = nil)
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    fake_contents = Bitmap.new(320 - 32, 80 - 32)
    if skill.nil?
      self.width = [fake_contents.text_size(Level_Up_Msg_Result).width + 48, 320].min
      self.height = 56
    else
      self.width = [fake_contents.text_size(Learn_Msg + ' ' + skill.name).width + 48, 320].min       
      self.height = 80
    end
    fake_contents.dispose
    self.visible = true
    self.contents = Bitmap.new(width - 32, height - 32)
    self.x = 288 + ((384 - width) / 2)
    @time = Level_Window_Duration
    self.contents.draw_text(0, -4, width - 32, 32, Level_Up_Msg_Result, 1)
    if skill != nil
      self.contents.draw_text(0, 20, width - 32, 32, Learn_Msg + ' ' + skill.name, 1)
    end
  end
  #----------------------------------------------------------------
  # * Frame Update
  #----------------------------------------------------------------
  def update
    super
    @time = [@time - 1, 0].max
    self.visible = @time > 0
  end
end

#==============================================================================
# ** Actor_Result_Window
#------------------------------------------------------------------------------
#  This window displays the actor information
#==============================================================================

class Actor_Result_Window < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #     y     : draw spot y-coordinate
  #     h     : height
  #--------------------------------------------------------------------------
  def initialize(actor, y, h)
    super(256, y, 384, h)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 4000
    @actor = actor
    @base_h = h / 3
    refresh 
  end
  #----------------------------------------------------------------
  # * Refresh
  #----------------------------------------------------------------
  def refresh
    self.contents.clear
    return if @actor == nil
    draw_actor_window_face(@actor, 0,0)
    draw_actor_name(@actor, @base_h * 3 - 24, 0)
    draw_actor_level(@actor, @base_h * 3 + 72, 0)
    show_current_exp = @actor.level == @actor.final_level ? '-----' : @actor.exp.to_s
    show_next_exp = @actor.level == @actor.final_level ? '-----' : @actor.next_rest_exp_s.to_s
    min_bar = @actor.level == @actor.final_level ? 1 : @actor.now_exp
    max_bar = @actor.level == @actor.final_level ? 1 : @actor.next_exp
    draw_actor_exp_bar(@actor, @base_h * 3 - 24, @base_h * 3 / 2)
    self.contents.draw_text(@base_h * 3 - 24, @base_h / 2, 300, 32, Exp_Text_Name)
    self.contents.draw_text(0, @base_h / 2, width - 48, 32, show_current_exp, 2)
    self.contents.draw_text(@base_h * 3 - 24, @base_h, 300, 32, Next_Text_Name)
    self.contents.draw_text(0, @base_h, width - 48, 32, show_next_exp, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw EXP bar
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_exp_bar(actor, x, y)
    bar_y = y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin(EXP_Meter_Result)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(x , bar_y, @skin, src_rect)    
    @line   = (actor.now_exp == actor.next_exp ? 2 : 1)
    @amount = (actor.next_exp == 0 ? 0 : 100 * actor.now_exp / actor.next_exp)
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(x , bar_y, @skin, src_rect2)
  end
  #--------------------------------------------------------------------------
  # * Draw actor face
  #     actor   : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     opacity : opacity
  #--------------------------------------------------------------------------
  def draw_actor_window_face(actor, x, y, opacity = 255)
    begin
      face = RPG::Cache.faces(actor.character_name, actor.character_hue)
      fw = face.rect.width
      fh = face.rect.height
      src_rect = Rect.new(0, 0, fw, fh)
      dest_rect = Rect.new(0, 0, [fw, height - 32].min, [fh, height - 32].min)
      self.contents.stretch_blt(dest_rect, face, src_rect)
    rescue
    end
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :old_exp
  attr_accessor :max_exp
  attr_accessor :plus_exp
  #--------------------------------------------------------------------------
  # * Set current exp
  #--------------------------------------------------------------------------
  def now_exp
    return @exp - @exp_list[@level]
  end
  #--------------------------------------------------------------------------
  # * Set ext exp
  #--------------------------------------------------------------------------
  def next_exp
    return @exp_list[@level + 1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  #--------------------------------------------------------------------------
  def update_phase5
    return if not_in_position($game_party.actors) or collapsing
    unless $game_temp.battle_victory
      set_result_window
    end
    if @phase5_wait_count > 0 and $game_temp.battle_victory
      @phase5_wait_count -= 1
      update_result_window
      return
    end
    if @level_windows != nil
      for i in 0...@level_windows.size
        @level_windows[i].update
      end
    end
    battle_end(0) if Input.trigger?(Input::C) and $game_temp.battle_victory
  end
  #--------------------------------------------------------------------------
  # * Show result window
  #--------------------------------------------------------------------------
  def set_result_window
    if Use_Victory_BGM
      $game_system.bgm_play(RPG::AudioFile.new(Victory_BGM, 100, 100))
    else
      $game_system.me_play($game_system.battle_end_me)
      play_map_bmg
    end
    treasures = []
    for enemy in $game_troop.enemies
      gold = gold.nil? ? enemy.gold : gold + enemy.gold
      treasures << treasure_drop(enemy) unless enemy.hidden
    end
    exp = exp_gained
    @gained_exp = exp
    treasures = treasures.compact
    gain_battle_spoil(gold, treasures)
    $game_temp.battle_victory = true
    battle_cry_set = []
    set_victory_battlecry
    battle_cry_basic(@victory_battlercry_battler, 'VICTORY') if @victory_battlercry_battler != nil
    wait(Victory_Time)
    windows_size = [$game_party.actors.size, Max_Party].max
    windows_height = 480 / [Max_Party, 4].min
    @result_windows = []
    @level_windows = []
    for i in 0...windows_size
      @result_windows[i] = Actor_Result_Window.new($game_party.actors[i], i * windows_height, windows_height)
      @level_windows[i] = Window_LevelUP.new(i * windows_height + 18)
    end
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    @result_window.add_multi_drops
    @result_window_exp = Window_BattleResultExp.new(exp)
    @phase5_wait_count = 1
  end
  #--------------------------------------------------------------------------
  # * Update Result Window
  #--------------------------------------------------------------------------
  def update_result_window
    for actor in $game_party.actors
      if actor.cant_get_exp? == false
        actor.old_exp = actor.exp
        actor.max_exp = actor.exp + @gained_exp
        actor.plus_exp = [actor.next_exp * Filling_Speed  /  250.0, 1].max.to_i
      end
    end
    old_bgs = $game_system.playing_bgs
    $game_system.bgs_play(RPG::AudioFile.new(Exp_BGS, 70, 150)) if Exp_BGS != nil
    loop do
      @all_max = true
      for i in 0...$game_party.actors.size
        actor = $game_party.actors[i]
        update_actor_exp(actor, i, false)
        if Input.trigger?(Input::C)
          for index in 0...$game_party.actors.size
            battler = $game_party.actors[index]
            update_actor_exp(battler, index, true)
          end
        elsif actor.level == actor.final_level
          update_actor_exp(actor, i, true)
        else
          update_actor_exp(actor, i, false)
        end
        update_graphics
      end
      if @all_max
        Audio.bgs_stop
        $game_system.bgs_play(old_bgs)
        break
      end
    end
    @phase5_wait_count = 0
  end
  #----------------------------------------------------------------
  # * Update actor exp
  #     actor : actor
  #     index : index
  #     skip  : skip flag
  #----------------------------------------------------------------
  def update_actor_exp(actor, index, skip)
    if actor.cant_get_exp? == false and actor.exp < actor.max_exp
      last_level = actor.level
      last_skill = actor.skills.dup
      if actor.exp + actor.plus_exp > actor.max_exp or skip
        actor.exp = actor.max_exp
      else
        actor.exp += actor.plus_exp
        @all_max = false
      end
      if actor.level > last_level
        $game_system.se_play(RPG::AudioFile.new(Level_Up_SE, 80, 100)) if Level_Up_SE != nil
        @level_windows[index].refresh
        actor.plus_exp =  [actor.next_exp * Filling_Speed  / 250.0, 1].max.to_i
      end
      if actor.skills.size > last_skill.size
        $game_system.se_play(RPG::AudioFile.new( earn_SE, 80, 100)) if Learn_SE != nil
        skills = actor.skills.dup - last_skill
        for id in skills
          @level_windows[index].refresh($data_skills[id])
        end
      end
      @level_windows[index].update
      @result_windows[index].refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose 3:abort)
  #--------------------------------------------------------------------------
  alias atoa_battle_end_ffresult battle_end
  def battle_end(result)
    play_map_bmg if Use_Victory_BGM
    atoa_battle_end_ffresult(result)
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias atoa_terminate_ffresult terminate
  def terminate
    atoa_terminate_ffresult
    if @result_windows != nil
      for i in 0...@result_windows.size
        @result_windows[i].dispose if @result_windows[i] != nil
        @result_windows[i] = nil
      end
    end
    if @level_windows != nil
      for i in 0...@level_windows.size
        @level_windows[i].dispose if @level_windows[i] != nil
        @level_windows[i] = nil
      end
    end
    @result_window_exp.dispose if @result_window_exp != nil
  end
end