#==============================================================================
# ■ Arcane Alchemy's Battle Result Window
#==============================================================================
#Version 0.9?
#This script should be pretty compatible with most others. 
#No configuration yet, I'll get to that at some point. 
#
#==============================================================================
# ■ Features
#
# * Animated Exp Bar
# * Conditional Items Dropped Section
# * Level up sound and text
# * Not much really, but I like it. 
#
#==============================================================================
# ■ CONFIGURATION
# 
# set to false by default. If not using ATOA_HP/SP bars, it will make
# your experience numbers just go apeshit so it's not suggested unless
# you're gonna code it yourself. 
  USING_ATOA_HP_SP_BARS = false
  
# you can adjust this to your liking. The bigger the number, the faster
# the speed. This is pretty close to what you'd want it though but, yeah. 
  EXP_GAIN_SPEED = 0.005
  
# if for some reason you don't want to press a button to make the exp points
# animate, then go ahead and set this to true. 
  ANIMATE_WITHOUT_BUTTON = false
#==============================================================================
# * Work in progress. Need to do some more debugging to be sure. 
#==============================================================================
# ■ This part is originally Atoa's EXPMeter
#============================================================================== 
#Atoa should get credit for this part. I wasn't in the mood to make my own bars
#so these are his. If you are using his script, then this part down to
#END ATOA's EXP BAR can be omitted/commented out/deleted. 

if USING_ATOA_HP_SP_BARS == false
  $exp_meter = 'EXPMeter'
  $exp_pos_adjust = [0, 8]
#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  def now_exp
    return @exp - @exp_list[@level]
  end
  #--------------------------------------------------------------------------
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
end
#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  def draw_actor_exp(actor, x, y)
    bar_x = $exp_pos_adjust[0] + x
    bar_y = $exp_pos_adjust[1] + y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin($exp_meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect)    
    @line   = (actor.now_exp == actor.next_exp ? 2 : 1)
    @amount = (actor.next_exp == 0 ? 0 : 100 * actor.now_exp / actor.next_exp)
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect2)
  end
end

end #end if USING_ATOA_HP_SP_BARS contidition. 
#==============================================================================
# ■ END ATOA's EXP BAR
#==============================================================================

class Window_Base < Window 

  def draw_actor_level_up(actor, x, y)
    self.contents.font.color = Color.new(255, 50, 50)
    #cx = contents.text_size("Level Up!").width
    self.contents.draw_text(x + 160, y + 32, 64, 32, "Level Up!")
    Audio.se_play("Audio/SE/056-Right02", 90)
  end

end#endclass
#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================
class Scene_Battle
  $start_exp_animation = false
  $close_exp_anime_window = false
  $play_exp_sound = 0
  $draw_new_level = false
  $draw_level_up = [false, false, false, false]
  
  alias animate_exp_start_phase1 start_phase1
  def start_phase1
    animate_exp_start_phase1
    
    #pushing/storing exp values in an array at beginning of battle
    $anim_exp_old_value = []
    $current_level_old_value = []
    
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      $anim_exp_old_value.push(actor.exp)
      $current_level_old_value.push(actor.level)
    end
  end

  alias custom_start_phase5 start_phase5
  def start_phase5
   custom_start_phase5

   
  #Figuring out the gained exp value for each character. 
   $gained_exp = 0
   for enemy in $game_troop.enemies
     $gained_exp += enemy.exp
   end

     #Temporarily making the exp the old value
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actor.exp = $anim_exp_old_value[i]

    end
    
    #if using ATOA ATB Script, this will remove the bars in the battle result
    #window. 
   if defined? self.remove_bars
   remove_bars#for removal of Atoa ATB bars in battle result window
   end
 
    @status_window.z = 0
    
 end#end start_phase5
  
  def update_phase5

    # If wait count is larger than 0
    if @phase5_wait_count > 0
      # Decrease wait count
      @phase5_wait_count -= 1
      # If wait count reaches 0
      if @phase5_wait_count == 0
        # Show result window
        @result_window.visible = true
        # Clear main phase flag
        $game_temp.battle_main_phase = false
        @status_window.visible = false
        $game_party.clear_actions
        
      end
      return
    end
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 110
      actor = $game_party.actors[i]
      @result_window.draw_actor_exp(actor, x + 60, y + 64)
        if actor.level == $current_level_old_value[i]
          if $draw_new_level == false 
            $draw_old_level_once = true
          @result_window.draw_actor_level(actor, x + 60, y + 32)
          elsif $draw_old_level_once == true
          end
        elsif actor.level > $current_level_old_value[i]
          $draw_level_up[i] = true
          $draw_new_level = true
          @result_window.refresh
          $current_level_old_value[i] = actor.level
        end
      end 
        if ANIMATE_WITHOUT_BUTTON == true
          $start_exp_animation = true
        elsif ANIMATE_WITHOUT_BUTTON == false
          # If C button was pressed
          if Input.trigger?(Input::C)
          $start_exp_animation = true
          end
        end
  
    if $start_exp_animation == true
    #animate the exp growth
        for i in 0...$game_party.actors.size
         actor = $game_party.actors[i]
           if actor.cant_get_exp? == false
             if @result_window != nil

               if actor.exp < ($anim_exp_old_value[i] + $gained_exp)
                actor.exp += ($gained_exp * EXP_GAIN_SPEED)
                $play_exp_sound += 1
                 if $play_exp_sound == 10
                   $game_system.se_play($data_system.cursor_se)
                   $play_exp_sound = 0
                 end
               end
             end
           
             if actor.exp >= ($anim_exp_old_value[i] + $gained_exp)
               actor.exp = ($anim_exp_old_value[i] + $gained_exp)
               $start_exp_animation = false
               $close_exp_anime_window = true
             end
           end
        end
    end
    
    if Input.trigger?(Input::C)
      if $close_exp_anime_window == true
        #Battle ends
        battle_end(0)
        $close_exp_anime_window = false
      $draw_new_level = false
      $draw_level_up = [false, false, false, false]
      end
    end
    
  end#end phase5 update
end#end of class here
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
    super(0,0,640,480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 200
    self.z = 101
    self.visible = false
    refresh
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
 
  def refresh
    self.contents.clear
    
    x = 300
    self.contents.font.color = normal_color
    cx = contents.text_size(@exp.to_s).width
    self.contents.draw_text(x + 140, 0, cx, 32, @exp.to_s)
    x += cx + 4
    self.contents.font.color = system_color
    cx = contents.text_size("EXP").width
    self.contents.draw_text(x, 0, 64, 32, "EXP")
    #x += cx + 16
    self.contents.font.color = system_color
    self.contents.draw_text(x, 40, 128, 32, $data_system.words.gold)
    x += cx + 4
    self.contents.font.color = normal_color
    cx = contents.text_size(@gold.to_s).width
    self.contents.draw_text(x + 32, 40, cx, 32, @gold.to_s)
    y = 64  
    if @treasures.size > 0
    self.contents.font.color = Color.new(255, 255, 100)
    cx = contents.text_size("Dropped Items: ").width
    self.contents.draw_text(x - 30, y - 20, 128, 180, "Dropped Items: ")
    end
    for item in @treasures
      draw_item_name(item, 300, y + 90)
      y += 32
    end
    
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 110
      actor = $game_party.actors[i]
        if $draw_level_up[i] == true
          #print($draw_level_up[i].to_s)
          draw_actor_level_up(actor, x, y)

        end
      draw_actor_graphic(actor, x - 40, y + 80)
      #draw_actor_face(actor, x - 40, y + 80)
      draw_actor_name(actor, x + 60, y)
      if $draw_new_level == true
        draw_actor_level(actor, x + 60, y + 32)     
      end

    end
  end
end