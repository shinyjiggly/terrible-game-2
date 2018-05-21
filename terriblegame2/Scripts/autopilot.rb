#--------------------------------------------------------------------------
# * Auto Command
# A simple script that adds an auto command to the Party Command bar
# in the default battle system
# Created by Racheal of Dragonfly
# DOES NOT WORK WITH CTB
#--------------------------------------------------------------------------
=begin
class Window_PartyCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 160
    @commands = ["Fight", "Surprise me", "Escape!"]
    @item_max = 3
    @column_max = 3
    draw_item(0, normal_color)
    draw_item(1, normal_color)
    draw_item(2, $game_temp.battle_can_escape ? normal_color : disabled_color)
    self.active = false
    self.visible = false
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  # index : item number
  # color : text character color
  #--------------------------------------------------------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(80 + index * 160 + 4, 0, 128 - 10, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index], 1)
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    self.cursor_rect.set(80 + index * 160, 0, 128, 32)
  end
end
  
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase)
  #--------------------------------------------------------------------------
  def update_phase2
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by party command window cursor position
      case @party_command_window.index
      when 0 # fight
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Start actor command phase
        start_phase3
      when 1 # auto
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Auto processing
        update_phase2_auto
      when 2 # escape
        # If it's not possible to escape
        if $game_temp.battle_can_escape == false
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Escape processing
        update_phase2_escape
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: auto)
  #--------------------------------------------------------------------------
  def update_phase2_auto
    # Clear all party member actions
    $game_party.clear_actions
    for actor in $game_party.actors
      if actor.inputable?
        # Set action
        actor.current_action.kind = 0
        actor.current_action.basic = 0
        actor.current_action.decide_random_target_for_actor
      end
    end
    # Start main phase
    start_phase4
  end
end
=end