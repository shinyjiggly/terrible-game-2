#===================================================
#Romancing SaGa Battle System - Animated Battler Fix
#===================================================
#It's a core script, but it needs to be just below the 
#animated battlers script, along with the Animated 
#Battler formations.

class Game_Enemy < Game_Battler 
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    if self.index != nil
      if $game_system.sv_angle == 1
        return 640 - $data_troops[@troop_id].members[@member_index%8].x
      else
        return $data_troops[@troop_id].members[@member_index%8].x
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

class Sprite_Battler < RPG::Sprite  
  alias ozrs_update update
  def update
    ozrs_update
    @battler.height = self.oy if @battler != nil
  end
end

class Scene_Battle
  def make_skill_action_result(w=0,battler = @active_battler, plus_id = 0)
    @rtab = !@target_battlers
    if $game_system.mnk_det_rtab_attck
      make_skill_action_result_anim(w,battler, plus_id)
    else
      @rtab ? make_skill_action_result_anim(w,battler) : make_skill_action_result_anim(w)
    end
    battler.skill_used    = @skill.id
    battler.strike_skill  = @skill.id
    battler.casted = true if $game_system.mnk_det_para_spell == true
    for target in (@rtab ? battler.target : @target_battlers)
      target.struck_skill = @skill.id
    end
  end
  
  alias ozrs_update_phase4_step3 update_phase4_step3
  def update_phase4_step3(battler = @active_battler)
    if (@active_battler.is_a?(Game_Actor))&&(@active_battler.learn_flag)
      #@status_window.set_bulb(@active_battler.index)
      #@status_window.refresh
      #@status_window.visible = true
      @active_battler.learn_flag_off
      @active_battler.animation_id = RPG::LIGHTBULB_ANIM
      @active_battler.animation_hit = true
      @wait_count = 20
      return
    end
    ozrs_update_phase4_step3(battler = @active_battler)
  end
end