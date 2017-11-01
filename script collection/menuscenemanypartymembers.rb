#  KMOGITMOD - Kyonides's MOG Hunter's Scene Menu Itigo MOD - KMOGITMOD
#  08.13.2010
 
#  Scene Menu Itigo Original Author : MOG Hunter
 
#  Plug & Play Script
 
#  This script modification lets you include more than 4 actors in your party
#  if deemed necessary and lets the menu screen show all of them no matter how
#  many actors are in your party now.
 
#  Instructions
 
#  To change the maximum number of actors in your party make this script call:
 
#    $game_party.maximum = 8
 
#  or just enter any other positive number instead.
 
class Game_Party
  alias kyon_gm_party_init initialize
  def initialize
    @maximum = 8
    kyon_gm_party_init
  end
 
  def maximum=(value)
    @maximum = value if value > 0
  end
 
  def add_actor(actor_id)
    actor = $game_actors[actor_id]
    # If the party has less than the maximum number of members
    # and this actor is not in the party
    if @actors.size < @maximum and !@actors.include?(actor)
      @actors.push(actor)
      $game_player.refresh
    end
  end
end
 
class Window_MenuStatus
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 20
      y = self.index < 4 ? i * 62 : (i - (self.index - 3)) * 62
      actor = $game_party.actors[i]
      self.contents.font.name = MOG::MAIN_FONT
      if $mogscript["TP_System"] == true
        draw_actor_tp(actor, x + 285, y - 5, 4)  
        draw_actor_state(actor, x + 190, y - 5)
      else  
        draw_actor_state(actor, x + 220, y - 5)
      end
      drw_face(actor, x, y + 50)
      draw_maphp3(actor, x + 40, y - 5)
      draw_mapsp3(actor, x + 40, y + 20)
      draw_mexp2(actor, x + 140, y + 15)
    end
  end
end
 
class Scene_Menu
  def update_status
    @status_window.refresh
    @mnsel.x = 180
    case @status_window.index
    when 0..3
      @mnsel.y = 130 + (@status_window.index * 65)
    when $game_party.actors.size-1
      @mnsel.y = 320
    end  
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @command_window.active = true
      @status_window.active = false
      @status_window.index = -1
      return
    end
    if Input.trigger?(Input::C)
      case @command_window.index
      when 1
        if $game_party.actors[@status_window.index].restriction >= 2
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Skill.new(@status_window.index)
      when 2  
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Equip.new(@status_window.index)
      when 3  
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Status.new(@status_window.index)
        end
      return
    end
  end
end