#-------------------------
#   Game_TrainActor
#    Makes the caterpillar thingie work.
#------------------------


class Game_TrainActor < Game_Character
  attr_accessor :move_speed
  attr_accessor :return_to_player
  attr_accessor :move_route_forcing
  
  def initialize(actor_index)
    super()
    # they should be able to be walked through
    @through = true
    @actor_index = actor_index
    @return_to_player = false

    refresh
  end
  
  # refresh the character sprite
  def refresh
    actor = $game_party.actors[@actor_index]
    if actor == nil
      @character_name = ""
    else
      @character_name = actor.character_name
      @character_hue = actor.character_hue
      @direction = $game_player.direction
      if $game_switches[TRANSPARENT_SWITCH]
        @transparent = false
      else
        @transparent = $game_player.transparent
      end
    end
    @opacity = 255
    @blend_type = 0
    @through = true
    @curr_terrain = terrain_tag
  end
  
  # frame update
  def update
    if @return_to_player
      if self.x == $game_player.x and self.y == $game_player.y
        @return_to_player = false
        @move_route_forcing = false
      else
        move_toward_player
      end
    end

    if $game_switches[TRANSPARENT_SWITCH]
      @transparent = true
    else
      @transparent = $game_player.transparent
    end
    
    super
  end
  
  # z coord of train actor
  def screen_z(height = 0)
    # place the train actor under the player if on the same square
    if $game_player.x == @x and $game_player.y == @y
      return $game_player.screen_z(height) - 1
    end
    # nope, use normal z
    super(height)
  end
end