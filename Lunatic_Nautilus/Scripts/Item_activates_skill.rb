=begin
#
# Item activates skill
# By: Game_Guy

module GGSI
  def self.item_skill(id)
    case id
    #when item_id then return skill_id
    # pretty much
    # when item then return skill it casts
    
    when 4 then return 11 # heal-y food uses conditional heal
      
    end
    return nil
  end
end
class Game_Battler
  alias gg_link_skill_item_eff_lat item_effect
  def item_effect(item, user = nil)
    s = GGSI.item_skill(item.id)
    return gg_link_skill_item_eff_lat(item) if s == nil || user == nil
    return skill_effect(user, $data_skills[s])
  end
end
class Scene_Battle
  def make_item_action_result
    # Get item
    @item = $data_items[@active_battler.current_action.item_id]
    # If unable to use due to items running out
    unless $game_party.item_can_use?(@item.id)
      # Shift to step 1
      @phase4_step = 1
      
      #update_phase4
      return
    end
    # If consumable
    if @item.consumable
      # Decrease used item by 1
      $game_party.lose_item(@item.id, 1)
    end
    # Display item name on help window
    @help_window.set_text(@item.name, 1)
    # Set animation ID
    @animation1_id = @item.animation1_id
    @animation2_id = @item.animation2_id
    # Set common event ID
    @common_event_id = @item.common_event_id
    # Decide on target
    index = @active_battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    # Set targeted battlers
    set_target_battlers(@item.scope)
    # Apply item effect
    for target in @target_battlers
      target.item_effect(@item, @active_battler)
    end
  end
end
=end