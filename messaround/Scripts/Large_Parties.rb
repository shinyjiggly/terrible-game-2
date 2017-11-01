
#==============================================================================
# ** Large Party
#------------------------------------------------------------------------------
#  Author: Dargor
#  Version 1.4
#  16/05/2014
#==============================================================================
 
#==============================================================================
# ** Large Party Customization Module
#==============================================================================
 
module Dargor
  module Large_Party
    # Maximum number of actors allowed in the party
    Max_Size = 10
    # Battle status window refresh rate (used in phase5)
    Battle_Refresh_Rate = 32
  end
end
 
#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================
 
class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battle_actor_index  # @actor_index in battle scene
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_temp_initialize initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    large_party_temp_initialize
    @battle_actor_index = 0
  end
end
 
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================
 
class Game_Party
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :max_size   # Max number of actors allowed in the party
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_initialize initialize
  alias large_party_add_actor add_actor
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    large_party_initialize
    @max_size = Dargor::Large_Party::Max_Size
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    # Original method
    large_party_add_actor(actor_id)
    # Get actor
    actor = $game_actors[actor_id]
    # If the party has less than 4 members and this actor is not in the party
    if @actors.size < @max_size and not @actors.include?(actor)
      # Add actor
      @actors.push(actor)
      # Refresh player
      $game_player.refresh
    end
  end
end
 
#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================
 
class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_sprite_update update
  #--------------------------------------------------------------------------
  # * Frame Update #EDITED!!
  #--------------------------------------------------------------------------
  def update
    # Original method
    large_party_sprite_update
    # Set sprite coordinates
    if @battler.is_a?(Game_Actor)
    home_x= (@battler.screen_x / 4) - ($game_temp.battle_actor_index / 4) + 400
    home_y= (@battler.screen_x / 3)- ($game_temp.battle_actor_index / 4) + 150
      self.x = home_x #if "idle", go towards home until 
      self.y = home_y #aaaa
    end #the x is equal to the battler screen x 
    #(minus a quarter of the party member index) times screen size
  end
end
#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within
#  the Scene_Battle class.
#==============================================================================
 
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_spriteset_update update
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Cycle through all extra actors (4+)
    # Create/update sprites
    for i in 10...$game_party.actors.size #was 4
      if @actor_sprites[i].nil?
        @actor_sprites.push(Sprite_Battler.new(@viewport2))
      end
      @actor_sprites[i].battler = $game_party.actors[i]
    end
    # Original method
    large_party_spriteset_update
  end
end
 
#==============================================================================
# ** Window_MenuStatus #it's not over here stap messing with the window
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================
 
class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_menu_status_initialize initialize
  alias large_party_menu_status_refresh refresh
  alias large_party_menu_status_update_cursor_rect update_cursor_rect
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Original method
    large_party_menu_status_initialize
    # Adjust contents height
    @item_max = $game_party.actors.size
    height = @item_max * 120 #*120
    self.contents = Bitmap.new(width - 32, height - 32)
    # Refresh
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(*args)
    # Original method
    large_party_menu_status_refresh(*args)
    # Adjust default height
    self.height = 480 #480
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    large_party_menu_status_update_cursor_rect
    row = @index / @column_max
    if row < self.top_row
      self.top_row = row
    end
    if row > self.top_row + (self.page_row_max - 1)
      self.top_row = row - (self.page_row_max - 1)
    end
    cursor_width = self.width / @column_max - 32
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 116 - self.oy #116
    self.cursor_rect.set(x, y, cursor_width, 96) #96
  end
  #--------------------------------------------------------------------------
  # * Top Row
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / 116 #116
  end
  #--------------------------------------------------------------------------
  # * Set Top Row
  #     row : new row
  #--------------------------------------------------------------------------
  def top_row=(row)
    if row < 0
      row = 0
    end
    if row > row_max - 1
      row = row_max - 1
    end
    self.oy = row * 116 #116
  end
  #--------------------------------------------------------------------------
  # * Page Row Max
  #--------------------------------------------------------------------------
  def page_row_max
    return 4 #was4
  end
end
 
#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================
 
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_battle_status_initialize initialize
  alias large_party_battle_status_refresh refresh
  alias large_party_battle_status_update update
  #--------------------------------------------------------------------------
  # * Object Initialization #EDITED
  #--------------------------------------------------------------------------
  def initialize
    @column_max = 10 #10
    large_party_battle_status_initialize
    width = $game_party.actors.size * 180 #180
    self.contents = Bitmap.new(width - 32, height - 32)
    self.width = 640 #640
    @level_up_flags = []
    for i in 0...$game_party.actors.size
      @level_up_flags << false
    end
    @item_max = $game_party.actors.size
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Refresh contents when actors are added/removed in-battle
    if $game_party.actors.size != @item_max
      @item_max = $game_party.actors.size
      width = @item_max * 640 #edit
      self.contents = Bitmap.new(width - 32, height - 32)
      self.width = 640 #640
    end
    large_party_battle_status_refresh
    column = $game_temp.battle_actor_index / 10 #edit
    self.ox = column * 640 #640
  end
end
 
#==============================================================================
# ** Arrow_Actor
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose an actor. This class inherits from the
#  Arrow_Base class.
#==============================================================================
 
class Arrow_Actor < Arrow_Base
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Cursor right
    if Input.repeat?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      @index += 1
      @index %= $game_party.actors.size
    end
    # Cursor left
    if Input.repeat?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      @index += $game_party.actors.size - 1
      @index %= $game_party.actors.size
    end
        # Because of the large party script, we need to offset the X position
        # of the cursor to make sure it's at the right position
        ox_actor = $game_party.actors[@index % 10] #was 4
    # Set sprite coordinates
    if self.actor != nil
      self.x = ox_actor.screen_x
      self.y = ox_actor.screen_y
    end
  end
end
 
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================
 
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_phase3_setup_command_window phase3_setup_command_window
    alias large_party_update_phase3_actor_select update_phase3_actor_select
  alias large_party_update_phase4_step2 update_phase4_step2
  alias large_party_start_phase5 start_phase5
  alias large_party_update_phase5 update_phase5
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup #it's just the window
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    $game_temp.battle_actor_index = @actor_index
    @status_window.refresh
    large_party_phase3_setup_command_window
    @actor_command_window.x = 0 #(@actor_index%10) * 10 #was mod4, was 40
  end
#--------------------------------------------------------------------------
# * Frame Update (actor command phase : actor selection)
#--------------------------------------------------------------------------
def update_phase3_actor_select
    # Update status window scroll position
    $game_temp.battle_actor_index = @actor_arrow.index
    @status_window.refresh
    # Call the original method
    large_party_update_phase3_actor_select
end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase step 2 : start action)
  #--------------------------------------------------------------------------
  def update_phase4_step2
    if @active_battler.is_a?(Game_Actor)
      $game_temp.battle_actor_index = @active_battler.index
      @status_window.refresh
    end
    large_party_update_phase4_step2
  end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase step 4 : animation for target)
  #--------------------------------------------------------------------------
  def update_phase4_step4
    if @target_battlers[0] != nil
      $game_temp.battle_actor_index = @target_battlers[0].index
      @status_window.refresh
    end
    # Animation for target
    for target in @target_battlers
      target.animation_id = @animation2_id
      target.animation_hit = (target.damage != "Miss")
    end
    # Animation has at least 8 frames, regardless of its length
    @wait_count = 8
    # Shift to step 5
    @phase4_step = 5
  end
  #--------------------------------------------------------------------------
  # * Start After Battle Phase
  #--------------------------------------------------------------------------
  def start_phase5
    @actor_index = 0
    @status_wait = Graphics.frame_count
    large_party_start_phase5
  end
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  #--------------------------------------------------------------------------
  def update_phase5
    refresh_rate = Dargor::Large_Party::Battle_Refresh_Rate
    if Graphics.frame_count >= @status_wait + refresh_rate
      $game_temp.battle_actor_index = @actor_index
      @status_window.refresh
      @status_wait = Graphics.frame_count
      max = ($game_party.actors.size.to_f/10).ceil * 10 #was 4
      @actor_index = (@actor_index+1) % max
    end
    large_party_update_phase5
  end
end
