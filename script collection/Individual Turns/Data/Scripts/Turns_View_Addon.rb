#==============================================================================
# ●● Turns View Addon
#------------------------------------------------------------------------------
# Trickster (tricksterguy@hotmail.com)
# Version 1.1
# Date 9/2/07
# Goto rmxp.org for updates/support/bug reports
#==============================================================================
#--------------------------------------------------------------------------
# Begin SDK Log
#--------------------------------------------------------------------------
SDK.log('Turns View Addon', 'Trickster', 1.1, '9/2/07')
#--------------------------------------------------------------------------
# Begin SDK Requirement Check
#--------------------------------------------------------------------------
SDK.check_requirements(2.3, [1, 3], ['Individual Turns Battle System'])
#--------------------------------------------------------------------------
# Begin SDK Enabled Check
#--------------------------------------------------------------------------
if SDK.enabled?('Turns View Addon')
  
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :active_battler
  attr_reader :spriteset
  #--------------------------------------------------------------------------
  # * Main Variable
  #--------------------------------------------------------------------------
  alias_method :trick_turns_battle_main_variable, :main_variable
  def main_variable
    # The Usual
    trick_turns_battle_main_variable
    # Setup Action Battlers Array (One Reference)
    @action_battlers = []
  end
  #--------------------------------------------------------------------------
  # * Main Spriteset
  #--------------------------------------------------------------------------
  alias_method :trick_turns_battle_main_spriteset, :main_spriteset
  def main_spriteset
    # The Usual
    trick_turns_battle_main_spriteset
    # Create Battle Turns Spriteset
    @spriteset_battleturns = Spriteset_BattleTurns.new(@action_battlers)
  end
  #--------------------------------------------------------------------------
  # * Start Phase 2
  #--------------------------------------------------------------------------
  alias_method :trick_turns_battle_start_phase2, :start_phase2
  def start_phase2
    # The Usual
    trick_turns_battle_start_phase2
    # Set Spriteset to be visible
    @spriteset_battleturns.visible = false
  end
  #--------------------------------------------------------------------------
  # * Start Phase 5
  #--------------------------------------------------------------------------
  alias_method :trick_turns_battle_start_phase5, :start_phase5
  def start_phase5
    # Set Spriteset to be visible
    @spriteset_battleturns.visible = false
    # The Usual
    trick_turns_battle_start_phase5
  end
  #--------------------------------------------------------------------------
  # * Start Phase 3
  #--------------------------------------------------------------------------
  alias_method :trick_turns_battle_start_phase3, :start_phase3
  def start_phase3
    # Set Spriteset to be visible
    @spriteset_battleturns.visible = true
    # The Usual
    trick_turns_battle_start_phase3
  end
  #--------------------------------------------------------------------------
  # * Make Action Orders
  #--------------------------------------------------------------------------
  def make_action_orders
    # Clear @action_battlers array
    @action_battlers.clear
    # Add enemy to @action_battlers array
    $game_troop.enemies.each {|enemy| @action_battlers << enemy}
    # Add actor to @action_battlers array
    $game_party.actors.each {|actor| @action_battlers << actor}
    # Decide action speed for all
    @action_battlers.each {|battler| battler.make_action_speed}
    # Line up action speed in order from greatest to least
    @action_battlers.sort! {|a,b|
      b.current_action.speed - a.current_action.speed }
  end
end
  
class Spriteset_BattleTurns
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :viewport
  attr_reader :visible
  attr_reader :party_sprites
  attr_reader :troop_sprites
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(action_battlers)
    # Create Viewport
    @viewport = Viewport.new(0, 0, 640, 480)
    # Setup Z
    @viewport.z = 100
    # Setup Instance Variables
    @action_battlers = action_battlers
    # Create Sprites Hashes
    @party_sprites = {}
    @troop_sprites = {}
    # Create Picture Sprites for All Actors and Enemies
    $game_party.actors.each do |actor|
      @party_sprites[actor] = Sprite_TurnPicture.new(actor, @viewport)
    end
    $game_troop.enemies.each do |enemy| 
      @troop_sprites[enemy] = Sprite_TurnPicture.new(enemy, @viewport)
    end
    # Set As Invisible
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # Dispose Party and Troop Sprites
    @party_sprites.each_value {|sprite| sprite.dispose}
    @troop_sprites.each_value {|sprite| sprite.dispose}
  end
  #--------------------------------------------------------------------------
  # * Set Visibility
  #--------------------------------------------------------------------------
  def visible=(visible)
    # Update Visible Flag
    @visible = visible
    # Update Party and Troop Sprites
    @party_sprites.each_value {|sprite| sprite.visible = visible}
    @troop_sprites.each_value {|sprite| sprite.visible = visible}
    # Refresh
    refresh if @visible
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    # Skip if not visible
    return if not self.visible
    # Update Party and Troop Sprites
    @party_sprites.each_value {|sprite| sprite.update}
    @troop_sprites.each_value {|sprite| sprite.update}
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Update Objects
    ($game_party.actors - @party_sprites.keys).each do |battler|
      # Create Sprite for battler
      @party_sprites[battler] = Sprite_TurnPicture.new(battler, @viewport)
    end
    ($game_party.actors - ($game_party.actors & 
      @party_sprites.keys)).each do |battler|
      # Dispose Sprite for battler
      @party_sprites[battler].dispose
      # Delete Sprite
      @party_sprites.delete(battler)
    end
    ($game_troop.enemies - @troop_sprites.keys).each do |battler|
      # Create Sprite for battler
      @troop_sprites[battler] = Sprite_TurnPicture.new(battler, @viewport)
    end
    ($game_troop.enemies - ($game_troop.enemies & 
      @troop_sprites.keys)).each do |battler|
      # Dispose Sprite for battler
      @troop_sprites[battler].dispose
      # Delete Sprite
      @troop_sprites.delete(battler)
    end
    # Set Active Battler
    @active_battler = $scene.active_battler
    # Get Battlers
    battlers = @action_battlers.collect do |actor| 
      # Return Actor if actor exists
      actor if actor.exist?
    end
    # Compact
    battlers.compact!
    # Update Positions
    battlers.each_with_index do |battler, index|
      # If Battler is an actor
      if battler.is_a?(Game_Actor)
        # Set Y
        @party_sprites[battler].y = 32 * (index + 1) + 32
        # Set Visible
        @party_sprites[battler].visible = true
      # If Battler is an enemy
      elsif battler.is_a?(Game_Enemy)
        # Set Y
        @troop_sprites[battler].y = 32 * (index + 1) + 32
        # Set Visible
        @troop_sprites[battler].visible = true
      end
    end
    # Get Invisible Battlers
    invisible = (@party_sprites.keys | @troop_sprites.keys) - @action_battlers
    # Set Sprites to Invisible
    invisible.each do |battler|
      # If Battler is an actor
      if battler.is_a?(Game_Actor)
        # Set Visible
        @party_sprites[battler].visible = false
      # If Battler is an enemy
      elsif battler.is_a?(Game_Enemy)
        # Set Visible
        @troop_sprites[battler].visible = false
      end
    end
  end
end

class Sprite_TurnPicture < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(battler, viewport)
    # Call Sprite
    super(viewport)
    # Set Instance Variable
    @battler = battler
    @battler_name, @battler_hue = battler.battler_name, battler.battler_hue
    # Set Bitmap
    self.bitmap = RPG::Cache.turn(@battler_name, @battler_hue)
    # Set Visibility
    self.visible = visible && @battler.exist?
    # Set X
    self.x = 480
  end
  #--------------------------------------------------------------------------
  # * Set Visibility
  #--------------------------------------------------------------------------
  def visible=(visible)
    super(visible && @battler.exist?)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    # If Battler or hue changed
    if (@battler_name != @battler.battler_name || 
        @battler_hue != @battler.battler_hue)
      # Setup Battler Name and hue
      @battler_name, @battler_hue = battler.battler_name, battler.battler_hue
      # Set Bitmap
      self.bitmap = RPG::Cache.turn(@battler_name, @battler_hue)
    end
  end
end

module RPG::Cache
  #--------------------------------------------------------------------------
  # * Turn Sprite
  #--------------------------------------------------------------------------
  def self.turn(filename, hue)
    self.load_bitmap("Graphics/Turns/", filename, hue)
  end
end
#--------------------------------------------------------------------------
# End SDK Enabled Check
#--------------------------------------------------------------------------
end