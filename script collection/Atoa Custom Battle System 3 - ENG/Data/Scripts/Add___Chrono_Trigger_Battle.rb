#=============================================================================
# Chrono Trigger Battle
# By Atoa
#==============================================================================
# This scripts emulates an battle thats occurs on map, very similar to
# Chrono Trigger
#
# Also this system adds an caterpillar system, that is vital to the system.
#
#--------------------------------------------------------------------------
#
# IMPORTANT: 
# - If using the scripts "Atoa ATB" or "Atoa CTB", place this script
#   bellow them.
# - The Anti-lag script must be placed above all custom scripts
#   right bellow the script "Scene_Debug"  
#
#--------------------------------------------------------------------------
# The Battle:
# For the battle you won't need to make any change on the script.
# The only thing necessary will be the battler graphics in all directions.
# You will need an basic battler for the lateral movement. (right and left)
# You will also need graphics for the up and down movement.
# These graphics must have the same file name as the normal graphic 
# plus '_down' for the face down battler, and '_up' for the face up battler.
#
# E.g.:
#  - Normal graphic: 'Crono'
#  - Face down graphic: 'Crono_down'
#  - Face down graphic:  'Crono_up'
# 
# The 'up' and 'down' graphics must have the same size and patterns as the
# normal graphics.
# Analize the demos examples.
#
#--------------------------------------------------------------------------
# Starting the battle
# To start a battle you must make an *Script Call*
# The default battle call won't work anymore.
# On the 'Script Call' you must add the following code:
#
# can_escape = true/false
# enemies = [[event, enemy, permanent]]
# start_pos = [x, y]
# end_pos = [x, y]
# escape_pos = [x, y]
# actors_pos = [[x, y],[x, y],[x, y],[x, y]]
# can_lose = true/false
# troop = enemy troop
# $scene.call_ct_battle(can_escape, enemies, start_pos, end_pos, escape_pos, actors_pos, can_lose, troop)
#
# Where:
#   can_escape: set if will be possible to escape from battle
#     must be true or false
#
#   enemies: set the events that will be enemies, the enemies ID on the
#     database and if the enemy death will be permanent
#       
#     - event: ID of the event that will be an eneny, the enemy postion is
#       set by the event postion.
#     - enemy: ID of the enemy on the database, the status and battle graphic
#       of the enemy are set by this value
#     - permanent: defines if the enemy death will be permantent.
#       - true: the death will be 'permanent' (will turn ON the Local Switch 'D')
#       - false: the death won't be permanent (the enemy will return if you leave the map)
#     E.g.: enemies = [[1, 10, false],[2, 10, false],[3, 10, false]]
#
#   start_pos: position x/y on the map where the battle will start.
#     the screen will move to the coordinates on the map before the battle begin.
#     
#   end_pos: position x/y on the map where the battle will end.
#     map coordinate where the actors will move if the battle end or if it's aborted.
#
#   escape_pos: position x/y on the map where the battle will end in case of escape.
#     map coordinate where the actors will move if escape from battle
#     (note: rememeber to set this coordinate outside the area of the start
#      battle events, or the party will be 'stuck' until they win)
#
#   actors_pos = postion x/y on the map that each actor will stay during battle.
#     remember to add the position of all actors, or will occurs errors.
#     E.g.: actors_pos = [[20,21],[18,23],[23,20],[24,21]]
#
#   can_lose: set if battle can be lost, must be true or false
#
#   troop: Enemy Troop on the database, used for in-battle events. Pode ser omitido.
#
#   IMPORTANT: All postions values are *MAP COORDINATES*
#    
#--------------------------------------------------------------------------
# Caterpillar:
#
# The battle system haves an built-in caterpillar system, this system allows
# to show all actors on the map, and they follow the party leader.
#
# You can also control the movement of the actorns on the caterpillar
# with event commands, using the 'Script Call'
#
# $game_player.caterpillar[index].x = posição X no mapa
# $game_player.caterpillar[index].y = posição Y no mapa
#
# To gather the party members: $game_player.caterpillar_gather
#
# Don't allow the actor movement if the party is separated.
# So use the gather party events before.
#==============================================================================
# Beta testers:
# Seshomaru (mundorpgmaker.com)
# DarkLuar (santuariorpgmaker.com)
#==============================================================================

module Atoa
  
  # Do not change or remove these lines
  Battle_Style = 3
  Show_Graphics_Transition = true
  # Do not change or remove these lines
    
  # Revive battlers dead in the end of battle (With 1 HP)
  Auto_Revive = true
  
  # Hide dead party members
  Hide_Dead = true

  # Max members shown on the screen
  Max_Caterpillar_Actor = 4
 
  # ID of the ID do switch that hides de caterpillar vizualization
  Caterpillar_Hide_Switch = 2
 
  # Allow to change party order with Q or W?
  Allow_Reorder = true
     
  # Max distance between the party members. (Value in pixels)
  # Leave 0 to desactivate
  Max_Distance = 30
  
end


#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Chrono Trigger Battle'] = true
$atoa_script['Atoa Caterpillar'] = true

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
  attr_accessor :in_ct_battle
  attr_accessor :enemies_position
  attr_accessor :actors_position
  attr_accessor :battle_end_transition
  attr_accessor :lock_map_postions
  attr_accessor :enemy_troop
  attr_accessor :event_troop
  attr_accessor :event_delete
  attr_accessor :battle_result
  attr_accessor :end_pos
  attr_accessor :escape_pos
  attr_accessor :start_pos
  attr_accessor :end_direction
  attr_accessor :battle_settings
  attr_accessor :actors_start_position
  attr_accessor :battle_move
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ctbattle_initialize initialize
  def initialize
    ctbattle_initialize
    @in_ct_battle = false
    @lock_map_postions = false
    @battle_end_transition = false
    @battle_move = false
    @enemies_position = []
    @actors_position = []
    @actors_start_position =[]
    @escape_pos = []
    @enemy_troop = []
    @event_troop = []
    @event_delete = []
    @end_pos = []
    @battle_settings = []
    @end_direction = 0
    @battle_result = 0
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles the map. It includes scrolling and passable determining
#  functions. Refer to "$game_map" for the instance of this class.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  def battle_start_scroll(direction, distance, speed)
    @scroll_direction = direction
    @scroll_rest = distance
    @scroll_speed = speed
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
  # * Increase Steps
  #--------------------------------------------------------------------------
  alias increase_steps_ctbattle increase_steps
  def increase_steps
    unless $game_temp.lock_map_postions or $game_temp.battle_end_transition
      increase_steps_ctbattle
    end
  end
end

#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character  
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :direction
  attr_accessor :x
  attr_accessor :y
  #--------------------------------------------------------------------------
  # * Turn Down
  #--------------------------------------------------------------------------
  alias ctbattle_turn_down turn_down
  def turn_down
    ctbattle_turn_down
    @diagonal = false unless @direction_fix
  end
  #--------------------------------------------------------------------------
  # * Turn Left
  #--------------------------------------------------------------------------
  alias ctbattle_turn_left turn_left
  def turn_left
    ctbattle_turn_left
    @diagonal = false unless @direction_fix
  end
  #--------------------------------------------------------------------------
  # * Turn Right
  #--------------------------------------------------------------------------
  alias ctbattle_turn_right turn_right
  def turn_right
    ctbattle_turn_right
    @diagonal = false unless @direction_fix
  end
  #--------------------------------------------------------------------------
  # * Turn Up
  #--------------------------------------------------------------------------
  alias ctbattle_turn_up turn_up
  def turn_up
    ctbattle_turn_up
    @diagonal = false unless @direction_fix
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
#  switching via condition determinants, and running parallel process events.
#  It's used within the Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :erased
  attr_accessor :step_anime
  attr_accessor :direction
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias ctbattle_event_update update
  def update
    @transparent = battle_event
    ctbattle_event_update
  end
  #--------------------------------------------------------------------------
  # * Check battle event
  #--------------------------------------------------------------------------
  def battle_event
    return true if $game_temp.in_ct_battle and $game_temp.event_troop.include?(@id)
    return false
  end
end

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :caterpillar
  attr_accessor :old_x
  attr_accessor :old_y
  attr_accessor :move_speed
  attr_accessor :alive_actors
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias ctbattle_refresh refresh
  def refresh
    caterpillar_update
    ctbattle_refresh
  end
  #--------------------------------------------------------------------------
  # * Update caterpillar
  #--------------------------------------------------------------------------
  def caterpillar_update
    if @caterpillar.nil?
      @caterpillar = []
      for i in 1...Max_Caterpillar_Actor
        @caterpillar << Atoa_Caterpillar.new(i)
      end
    end
    for cat in @caterpillar
      cat.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Get Screen X center
  #--------------------------------------------------------------------------
  def center_x
    return CENTER_X
  end
  #--------------------------------------------------------------------------
  # * Get Screen Y center
  #--------------------------------------------------------------------------
  def center_y
    return CENTER_Y
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    for cat in @caterpillar
      cat.update
    end
    last_moving = moving?
    update_movement
    last_real_x = @real_x
    last_real_y = @real_y
    super
    unless $game_temp.lock_map_postions
      if @real_y > last_real_y and @real_y - $game_map.display_y > CENTER_Y
        $game_map.scroll_down(@real_y - last_real_y)
      end
      if @real_x < last_real_x and @real_x - $game_map.display_x < CENTER_X
        $game_map.scroll_left(last_real_x - @real_x)
      end
      if @real_x > last_real_x and @real_x - $game_map.display_x > CENTER_X
        $game_map.scroll_right(@real_x - last_real_x)
      end
      if @real_y < last_real_y and @real_y - $game_map.display_y < CENTER_Y
        $game_map.scroll_up(last_real_y - @real_y)
      end
    end
    unless moving? or $game_temp.battle_move
      if last_moving
        result = check_event_trigger_here([1,2])
        if result == false
          unless $DEBUG and Input.press?(Input::CTRL)
            @encounter_count -= 1 if @encounter_count > 0
          end
        end
      end
      if Input.trigger?(Input::C)
        check_event_trigger_here([0])
        check_event_trigger_there([0,1,2])
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update movement
  #--------------------------------------------------------------------------
  def update_movement
    unless moving? or $game_system.map_interpreter.running? or @move_route_forcing or
            $game_temp.message_window_showing or $game_temp.lock_map_postions
      input = $atoa_script['Atoa 8 Directions'] ? Input.dir8 : Input.dir4
      case input
        when 1; move_lower_left
        when 2; move_down
        when 3; move_lower_right
        when 4; move_left
        when 6; move_right
        when 7; move_upper_left
        when 8; move_up
        when 9; move_upper_right
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Straighten Position
  #--------------------------------------------------------------------------
  def straighten
    for cat in @caterpillar
      cat.straighten
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  alias ctbattle_moveto moveto
  def moveto(x, y)
    ctbattle_moveto(x, y)
    caterpillar_update if @caterpillar.nil? or @move_update.nil?
    for i in 0...@caterpillar.size
      @caterpillar[i].moveto(x, y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Down
  #--------------------------------------------------------------------------
  def move_down
    passable = passable?(@x, @y, 2)
    caterpillar_update if @caterpillar.nil? or @move_update.nil?
    super
    add_move_update('move_down') if passable
  end
  #--------------------------------------------------------------------------
  # * Move Left
  #--------------------------------------------------------------------------
  def move_left
    passable = passable?(@x, @y, 4)
    caterpillar_update if @caterpillar.nil? or @move_update.nil?
    super
    add_move_update('move_left') if passable
  end
  #--------------------------------------------------------------------------
  # * Move Right
  #--------------------------------------------------------------------------
  def move_right
    passable = passable?(@x, @y, 6)
    caterpillar_update if @caterpillar.nil? or @move_update.nil?
    super
    add_move_update('move_right') if passable
  end
  #--------------------------------------------------------------------------
  # * Move up
  #--------------------------------------------------------------------------
  def move_up
    passable = passable?(@x, @y, 8)
    caterpillar_update if @caterpillar.nil? or @move_update.nil?
    super
    add_move_update('move_up') if passable
  end
  #--------------------------------------------------------------------------
  # * Gather actors
  #--------------------------------------------------------------------------
  def caterpillar_gather
    for i in 0...@caterpillar.size   
      @caterpillar[i].gather_party
    end
  end
  #--------------------------------------------------------------------------
  # * Add movement upodate
  #     move : next move
  #--------------------------------------------------------------------------
  def add_move_update(move)
    if @caterpillar[0] != nil
      @caterpillar[0].move_update << move
    end
  end
  #--------------------------------------------------------------------------
  # * Set alive actors
  #--------------------------------------------------------------------------
  def set_alive_actors
    @alive_actors = []
    for actor in $game_party.actors
      @alive_actors << actor unless actor.dead?
    end
  end
end

#==============================================================================
# ** Atoa_Caterpillar
#------------------------------------------------------------------------------
#  This class handles the players on the caterpillar
#==============================================================================

class Atoa_Caterpillar < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :move_update
  attr_accessor :member
  attr_accessor :next_x
  attr_accessor :next_y
  attr_accessor :x
  attr_accessor :y
  attr_accessor :move_speed
  attr_accessor :running
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     mamber : actor
  #--------------------------------------------------------------------------
  def initialize(member)
    super()
    @move_update = []
    @member = member
    moveto($game_player.x, $game_player.y)
    @running = false
    @through = true
    refresh
    @next_x = @x
    @next_y = @y
  end
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def moveto(x, y)
    super(x, y)
    @move_update.clear
  end
  #--------------------------------------------------------------------------
  # * Straighten Position
  #--------------------------------------------------------------------------
  def straighten
    @pattern = 0 if @walk_anime or @step_anime
    @anime_count = 0
    @prelock_direction = 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    $game_player.set_alive_actors
    party = Hide_Dead ? $game_player.alive_actors.dup : $game_party.actors
    if party.size < @member
      @character_name = ""
      @character_hue = 0
      return
    end
    actor = party[@member]
    if actor == nil
      @character_name = ""
      @character_hue = 0
      return
    end
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @opacity = 255
    @blend_type = 0
  end
  #--------------------------------------------------------------------------
  # * Get Screen Z-Coordinates
  #     height : character height
  #--------------------------------------------------------------------------
  def screen_z(height = 0)
    if $game_player.x == @x and $game_player.y == @y
      return $game_player.screen_z - 1
    end
    super(height)
  end
  #--------------------------------------------------------------------------
  # * Same Position Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    return false
  end
  #--------------------------------------------------------------------------
  # * Front Envent Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    return false
  end
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    member = @member == 1 ? $game_player : $game_player.caterpillar[@member - 2]
    move_player(member)
    super
    @transparent = $game_player.transparent
    @transparent = @transparent ? @transparent : $game_switches[Caterpillar_Hide_Switch]
  end
  #--------------------------------------------------------------------------
  # * Get player distance
  #     member : actor
  #--------------------------------------------------------------------------
  def player_distance(member)
    dist_x = (member.screen_x - self.screen_x).abs
    dist_y = (member.screen_y - self.screen_y).abs
    return (dist_x + dist_y < Max_Distance + 30)
  end
  #--------------------------------------------------------------------------
  # * Move player
  #     member : actor
  #--------------------------------------------------------------------------
  def move_player(member)
    refresh
    @move_update.clear if member.x == @x and member.y == @y
    @start_moving = false if @move_update.size <= 1
    return if moving?
    return unless need_update(member)
    move = @move_update.shift
    eval(move) if move != nil
  end
  #--------------------------------------------------------------------------
  # * Check if need updade
  #     member : actor
  #--------------------------------------------------------------------------
  def need_update(member)
    return false if (member.x == @x and member.y == @y) 
    return false if player_distance(member) and not @start_moving
    return false if @move_update.empty?
    @start_moving = true
    if @move_update[0] == 'move_left'
      return false if (member.x + 1 == @x and member.y == @y)
    elsif @move_update[0] == 'move_right'
      return false if (member.x - 1 == @x and member.y == @y)
    elsif @move_update[0] == 'move_up'
      return false if (member.y + 1 == @y and member.x == @x)
    elsif @move_update[0] == 'move_down'
      return false if (member.y - 1 == @y and member.x == @x)
    elsif @move_update[0] == 'move_upper_left'
      return false if (member.x + 1 == @x and member.y + 1 == @y)
    elsif @move_update[0] == 'move_upper_right'
      return false if (member.x - 1 == @x and member.y + 1 == @y)
   elsif @move_update[0] == 'move_lower_left'
      return false if (member.x + 1 == @x and member.y - 1 == @y)
    elsif @move_update[0] == 'move_lower_right'
      return false if (member.x - 1 == @x and member.y - 1 == @y)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Add move to update
  #     move : move option
  #--------------------------------------------------------------------------
  def add_move_update(move)
    member = $game_player.caterpillar[@member]
    if member != nil
      member.move_update << move
    end
  end
  #--------------------------------------------------------------------------
  # * Gather party
  #--------------------------------------------------------------------------
  def gather_party
    for i in 0...$game_party.actors.size
      move_toward_player
    end
    @x = $game_player.x
    @y = $game_player.y
    @move_update.clear
  end
  #--------------------------------------------------------------------------
  # * Move Down
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_down(turn_enabled = true)
    @y += 1 if passable?(@x, @y, 2)
    turn_down if turn_enabled
    add_move_update('move_down')
  end
  #--------------------------------------------------------------------------
  # * Move Left
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_left(turn_enabled = true)
    @x -= 1 if passable?(@x, @y, 4)
    turn_left  if turn_enabled
    add_move_update('move_left')
  end
  #--------------------------------------------------------------------------
  # * Move Right
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_right(turn_enabled = true)
    @x += 1 if passable?(@x, @y, 6)
    turn_right if turn_enabled
    add_move_update('move_right')
  end
  #--------------------------------------------------------------------------
  # * Move Up
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_up(turn_enabled = true)
    @y -= 1 if passable?(@x, @y, 8)
    turn_up if turn_enabled
    add_move_update('move_up')
  end
  #--------------------------------------------------------------------------
  # * Move Down-Left
  #--------------------------------------------------------------------------
  def move_lower_left
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
      @x -= 1
      @y += 1
    end
    turn_lower_left if $atoa_script['Atoa 8 Directions']
    add_move_update('move_lower_left')
  end
  #--------------------------------------------------------------------------
  # * Move Down-Right
  #--------------------------------------------------------------------------
  def move_lower_right
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
      @x += 1
      @y += 1
    end
    turn_lower_right if $atoa_script['Atoa 8 Directions']
    add_move_update('move_lower_right')
  end
  #--------------------------------------------------------------------------
  # * Move Up-Left
  #--------------------------------------------------------------------------
  def move_upper_left
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
      @x -= 1
      @y -= 1
    end
    turn_upper_left if $atoa_script['Atoa 8 Directions']
    add_move_update('move_upper_left')
  end
  #--------------------------------------------------------------------------
  # * Move Up-Right
  #--------------------------------------------------------------------------
  def move_upper_right
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
      @x += 1
      @y -= 1
    end
    turn_upper_right if $atoa_script['Atoa 8 Directions']
    add_move_update('move_upper_right')
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc.
#  It's used within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ctbattle_initialize initialize
  def initialize
    ctbattle_initialize
    for caterpillar in $game_player.caterpillar.reverse
      sprite = Sprite_Character.new(@viewport1, caterpillar)
      @character_sprites.push(sprite)
    end
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
  # * Set sprites
  #--------------------------------------------------------------------------
  alias ctbattle_set_sprites set_sprites
  def set_sprites
    if $game_temp.in_ct_battle
      @tilemap = Tilemap.new(@viewport2)
      @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
      for i in 0..6
        autotile_name = $game_map.autotile_names[i]
        @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
      end
      @tilemap.map_data = $game_map.data
      @tilemap.priorities = $game_map.priorities
      @panorama = Plane.new(@viewport2)
      @panorama.z = -1000
      @fog = Plane.new(@viewport2)
      @fog.z = 3000
      @character_sprites = []
      for i in $game_map.events.keys.sort
        sprite = Sprite_Character.new(@viewport2, $game_map.events[i])
        @character_sprites.push(sprite)
      end
    end
    ctbattle_set_sprites
  end
  #--------------------------------------------------------------------------
  # * Sprites update
  #--------------------------------------------------------------------------
  alias ctbattle_update_sprites update_sprites
  def update_sprites
    if $game_temp.in_ct_battle
      if @panorama_name != $game_map.panorama_name or
        @panorama_hue != $game_map.panorama_hue
        @panorama_name = $game_map.panorama_name
        @panorama_hue = $game_map.panorama_hue
        if @panorama.bitmap != nil
          @panorama.bitmap.dispose
          @panorama.bitmap = nil
        end
        if @panorama_name != ""
          @panorama.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue)
        end
        Graphics.frame_reset
      end
      if @fog_name != $game_map.fog_name or @fog_hue != $game_map.fog_hue
        @fog_name = $game_map.fog_name
        @fog_hue = $game_map.fog_hue
        if @fog.bitmap != nil
          @fog.bitmap.dispose
          @fog.bitmap = nil
        end
        if @fog_name != ""
          @fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
        end
        Graphics.frame_reset
      end
      @tilemap.ox = $game_map.display_x / 4
      @tilemap.oy = $game_map.display_y / 4
      @tilemap.update
      @panorama.ox = $game_map.display_x / 8
      @panorama.oy = $game_map.display_y / 8
      @fog.zoom_x = $game_map.fog_zoom / 100.0
      @fog.zoom_y = $game_map.fog_zoom / 100.0
      @fog.opacity = $game_map.fog_opacity
      @fog.blend_type = $game_map.fog_blend_type
      @fog.ox = $game_map.display_x / 4 + $game_map.fog_ox
      @fog.oy = $game_map.display_y / 4 + $game_map.fog_oy
      @fog.tone = $game_map.fog_tone
    end
    ctbattle_update_sprites
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias ctbattle_dispose dispose
  def dispose
    if $game_temp.in_ct_battle
      @tilemap.tileset.dispose
      for i in 0..6
        @tilemap.autotiles[i].dispose
      end
      @tilemap.dispose
      @panorama.dispose
      @fog.dispose
    end
    ctbattle_dispose
  end
end

#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  This class deals with troops. Refer to "$game_troop" for the instance of
#  this class.
#==============================================================================

class Game_Troop
  #--------------------------------------------------------------------------
  # * Setup
  #     troop_id    : troop ID
  #     enemy_troop : enemies in troop
  #--------------------------------------------------------------------------
  alias ctbattle_setup setup
  def setup(troop_id, enemy_troop = nil)
    if enemy_troop.nil?
      ctbattle_setup(troop_id) unless $data_troops[troop_id].nil?
    else
      @enemies = []
      troop = $data_troops[troop_id]
      for i in 0...enemy_troop.size
        @enemies.push(Game_Enemy.new(troop_id, i, enemy_troop[i]))
      end
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
  attr_accessor :battler_character
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  alias ctbattle_screen_x screen_x
  def screen_x
    if self.index != nil and not $game_temp.battle_settings.empty?
      return $game_temp.actors_position[self.index][0]
    else
      return ctbattle_screen_x
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  alias ctbattle_screen_y screen_y
  def screen_y
    if self.index != nil and not $game_temp.battle_settings.empty?
      return $game_temp.actors_position[self.index][1]
    else
      return ctbattle_screen_y
    end
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Set initial position
  #--------------------------------------------------------------------------
  def battler_position_setup
    if $game_temp.enemies_position[self.index] != nil
      base_x = $game_temp.enemies_position[self.index][0]
      base_y = $game_temp.enemies_position[self.index][1]
    else
      base_x = $data_troops[@troop_id].members[@member_index].x + Enemy_Position_AdjustX
      base_y = $data_troops[@troop_id].members[@member_index].y + Enemy_Position_AdjustY
    end
    @base_x = @original_x = @actual_x = @target_x = @initial_x = @hit_x = @damage_x = base_x
    @base_y = @original_y = @actual_y = @target_y = @initial_y = @hit_y = @damage_y = base_y
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    if $game_temp.enemies_position[self.index] != nil
      return $game_temp.enemies_position[self.index][0]
    else
      return $data_troops[@troop_id].members[@member_index].x + Enemy_Position_AdjustX
    end 
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    if $game_temp.enemies_position[self.index] != nil
      return $game_temp.enemies_position[self.index][1]
    else
      return $data_troops[@troop_id].members[@member_index].y + Enemy_Position_AdjustY
    end
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @spriteset = Spriteset_Map.new
    @message_window = Window_Message.new
    $game_player.refresh
    @in_ct_battle = false
    @battle_move = false
    if $game_temp.battle_end_transition
      set_screen_postion($game_temp.start_pos)
      Graphics.transition(0)
      wait(2)
      retutn_map_postions
      set_screen_postion($game_temp.start_pos, true)
      $game_temp.battle_end_transition = false
    else
      Graphics.transition
    end
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
    Graphics.freeze
    @spriteset.dispose
    @message_window.dispose
    Graphics.transition if $scene.is_a?(Scene_Title)
    Graphics.freeze if $scene.is_a?(Scene_Title)
    $game_temp.in_ct_battle = true if @in_ct_battle
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias ctbattle_update update
  def update
    ctbattle_update
    if (Input.trigger?(Input::L) or Input.trigger?(Input::R)) and Allow_Reorder
      $game_system.se_play($data_system.decision_se)
      reorder_party(Input.trigger?(Input::L))
    end
    if $game_party.actors[0].dead?
      reorder_party(true)
    end
  end
  #--------------------------------------------------------------------------
  # * Reorder party
  #     invert : invert flag
  #--------------------------------------------------------------------------
  def reorder_party(invert)
    if invert
      party = $game_party.actors.shift
      $game_party.actors << party
    else
      party = $game_party.actors.pop
      $game_party.actors.unshift(party)
    end
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # * Battle Call
  #--------------------------------------------------------------------------
  alias call_battle_ctbattle call_battle
  def call_battle
    $game_temp.battle_settings = []
    call_battle_ctbattle
  end
  #--------------------------------------------------------------------------
  # * Start map battle
  #     can_escape : can escape
  #     enemies    : enemies list
  #     start_pos  : start position
  #     end_pos    : end position
  #     escape_pos : escape position
  #     actors_pos : actors position
  #     can_lose   : can lose
  #     troop      : enemy troop
  #--------------------------------------------------------------------------
  def call_ct_battle(can_escape, enemies, start_pos, end_pos, escape_pos, actors_pos, can_lose = false, troop = 1)
    set_enemies(enemies)
    return if @enemy_party.empty?
    $game_temp.battle_can_escape = can_escape
    $game_temp.battle_can_lose = can_lose
    $game_temp.lock_map_postions = true
    $game_player.straighten
    $game_temp.battle_calling = $game_temp.menu_calling = $game_temp.menu_beep = false
    $game_temp.end_pos = end_pos
    $game_temp.escape_pos = escape_pos
    $game_temp.start_pos = start_pos
    set_screen_postion(start_pos)
    set_actor_postions(actors_pos)
    set_enemy_postions
    get_end_ecape_positions(end_pos, escape_pos)
    $game_temp.battle_settings = [$game_temp.enemy_troop, troop, @end_pos, @escape_pos]
    $scene = Scene_Battle.new
    @in_ct_battle = $game_temp.hide_windows = true
    prepare_for_battle
  end
  #--------------------------------------------------------------------------
  # * Set battle end positions
  #     end_pos    : battle end position
  #     escape_pos : escape end position
  #--------------------------------------------------------------------------
  def get_end_ecape_positions(end_pos, escape_pos)
    base_pos = [$game_player.x, $game_player.y]
    base_screen = [$game_player.screen_x, $game_player.screen_y]
    @end_pos = set_pos(base_pos, base_screen, end_pos)
    @escape_pos = set_pos(base_pos, base_screen, escape_pos)
  end
  #--------------------------------------------------------------------------
  # * Set positions
  #     base_pos    : map postion
  #     base_screen : screen position
  #     set_pos     : final position
  #--------------------------------------------------------------------------
  def set_pos(base_pos, base_screen, set_pos)
    diff_x = (base_screen[0] + ((set_pos[0] - base_pos[0]) * 32))
    diff_y = (base_screen[1] + ((set_pos[1] - base_pos[1]) * 32))
    return [diff_x, diff_y]
  end
  #--------------------------------------------------------------------------
  # * Set Screen positions
  #     start_pos : start position
  #     resetar   : restart position flag
  #--------------------------------------------------------------------------
  def set_screen_postion(start_pos, reset = false)
    position = reset ? [$game_player.x,$game_player.y] : start_pos 
    pos = set_screen_move_postion(position)
    set_screen(pos[0], $game_map.display_x, true)
    set_screen(pos[1], $game_map.display_y, false)
  end
  #--------------------------------------------------------------------------
  # * Set move position on screen
  #     pos : position
  #--------------------------------------------------------------------------
  def set_screen_move_postion(pos)
    max_x = ($game_map.width - 20) * 128
    max_y = ($game_map.height - 15) * 128
    pos_x = [0, [pos[0] * 128 - $game_player.center_x, max_x].min].max
    pos_y = [0, [pos[1] * 128 - $game_player.center_y, max_y].min].max
    return [pos_x, pos_y]
  end
  #--------------------------------------------------------------------------
  # * Set actor move position on screen
  #     pos : position
  #--------------------------------------------------------------------------
  def set_actors_screen_postion(pos)
    base_pos = [pos[0] - $game_player.x, pos[1] - $game_player.y]
    pos_x = $game_player.screen_x + (base_pos[0] * 32)
    pos_y = $game_player.screen_y + (base_pos[1] * 32)
    return [pos_x, pos_y]
  end
  #--------------------------------------------------------------------------
  # * Set screen position
  #     pos : initial position
  #     set : final position
  #     x   : direction
  #--------------------------------------------------------------------------
  def set_screen(pos, set, x)
    if pos != set
      dist = pos - set
      dir = dist > 0 ? (x ? 6 : 2) : (x ? 4 : 8)
      $game_map.battle_start_scroll(dir, dist.abs, 4)
    end
    update_scroll
  end
  #--------------------------------------------------------------------------
  # * Update screen scroll
  #--------------------------------------------------------------------------
  def update_scroll
    loop do
      update_basic(false, true, true)
      break unless $game_map.scrolling?
    end
    update_basic(false, true, true)
  end
  #--------------------------------------------------------------------------
  # * Wait time
  #     duration : wait duration in frames
  #--------------------------------------------------------------------------
  def wait(duration)
    for i in 0...duration
      update_basic(false, true, true)
    end
  end
  #--------------------------------------------------------------------------
  # * Set enemies
  #     enemies : enemy list
  #--------------------------------------------------------------------------
  def set_enemies(enemies)
    @enemy_party = []
    for i in 0...enemies.size
      next if $game_self_switches[[$game_map.map_id, enemies[i][0], 'D']] or 
        $game_map.events[enemies[i][0]].erased
      @enemy_party << enemies[i]
    end
  end
  #--------------------------------------------------------------------------
  # * Set enemies positions
  #--------------------------------------------------------------------------
  def set_enemy_postions
    $game_temp.enemies_position.clear
    $game_temp.enemy_troop.clear
    $game_temp.event_troop.clear
    for i in 0...@enemy_party.size
      x = $game_map.events[@enemy_party[i][0]].screen_x
      y = $game_map.events[@enemy_party[i][0]].screen_y
      $game_temp.enemies_position[i] = [x, y]
      $game_temp.event_troop[i] = @enemy_party[i][0]
      $game_temp.enemy_troop[i] = @enemy_party[i][1]
      $game_temp.event_delete[i] = @enemy_party[i][2]
    end
  end
  #--------------------------------------------------------------------------
  # * Set actors positions
  #     actor_pos : position
  #--------------------------------------------------------------------------
  def set_actor_postions(actors_pos)
    $game_temp.battle_move = true
    $game_temp.actors_start_position = []
    @moving_actors = []
    for i in 0...$game_party.actors.size
      $game_temp.actors_position[i] = set_actors_screen_postion(actors_pos[i])
      @moving_actors[i] = i == 0 ? $game_player : $game_player.caterpillar[i-1]
      @moving_actors[i].move_update.clear if i > 0
    end
    loop do
      for i in 0...$game_party.actors.size
        set_battle_position(@moving_actors[i], actors_pos[i])
        $game_temp.actors_position[i] = set_actors_screen_postion(actors_pos[i])
      end
      update_basic(false, true, true)
      break if all_in_postion(actors_pos)
    end
    $game_temp.battle_move = false
    wait(10)
  end
  #--------------------------------------------------------------------------
  # * Return to map positions
  #--------------------------------------------------------------------------
  def retutn_map_postions
    $game_temp.battle_move = true
    pos = $game_temp.battle_result == 1 ? $game_temp.escape_pos : $game_temp.end_pos
    @moving_actors = []
    for i in 0...$game_party.actors.size
      @moving_actors[i] = i == 0 ? $game_player : $game_player.caterpillar[i-1]
      @moving_actors[i].move_update.clear if i > 0
    end
    started_moving = false
    loop do
      if started_moving == true
        for i in 0...$game_party.actors.size
          set_battle_position(@moving_actors[i], @actors_pos[i])
        end
      else
        for i in 0...$game_party.actors.size
          set_battle_position(@moving_actors[i], pos)
        end
        @actors_pos = set_end_postion(pos)
      end
      started_moving = true
      update_basic(false, true, true)
      break if all_in_postion(@actors_pos)
    end
    set_plus_postion
    $game_temp.battle_move = false
    wait(10)
  end
  #--------------------------------------------------------------------------
  # * Set end position
  #     pos : position
  #--------------------------------------------------------------------------
  def set_end_postion(pos)
    actor_pos = []
    dir = $game_player.direction
    for i in 0...$game_party.actors.size
      if i == 0
        actor_pos[i] = pos
      else
        cat = $game_player.caterpillar[i - 1]
        case dir
        when 2 then actor_pos[i] = [pos[0], pos[1] - cat.member]
        when 4 then actor_pos[i] = [pos[0] + cat.member, pos[1]]
        when 6 then actor_pos[i] = [pos[0] - cat.member, pos[1]]
        when 8 then actor_pos[i] = [pos[0], pos[1] + cat.member]
        end
      end
    end
    return actor_pos
  end
  #--------------------------------------------------------------------------
  # * Set plus postion
  #--------------------------------------------------------------------------
  def set_plus_postion
    dir = $game_player.direction
    for cat in $game_player.caterpillar
      cat.move_update.clear
      cat.turn_toward_player
      case cat.direction
      when 2 then cat.move_update << 'move_down'
      when 4 then cat.move_update << 'move_left'
      when 6 then cat.move_update << 'move_right'
      when 8 then cat.move_update << 'move_up'
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Check if all in position
  #     actor_pos : actors position
  #--------------------------------------------------------------------------
  def all_in_postion(actors_pos)
    for i in 1...$game_party.actors.size
      actor = i == 0 ? $game_player : $game_player.caterpillar[i-1]
      return false if actors_pos[i] != [actor.x, actor.y]
    end
    return true
  end  
  #--------------------------------------------------------------------------
  # * Set battle postin
  #     actor : actor
  #     pos   : position
  #--------------------------------------------------------------------------
  def set_battle_position(actor, pos)
    return if actor.moving? or pos == [actor.x, actor.y]
    if actor.x == pos[0] and actor.y > pos[1]
      actor.y -= 1
      actor.turn_up
    elsif actor.x == pos[0] and actor.y < pos[1]
      actor.y += 1
      actor.turn_down
    elsif actor.x > pos[0] and actor.y == pos[1]
      actor.x -= 1
      actor.turn_left
    elsif actor.x < pos[0] and actor.y == pos[1]
      actor.x += 1
      actor.turn_right
    elsif actor.x < pos[0] and actor.y > pos[1]
      actor.turn_up
      actor.y -= 1
      actor.x += 1
    elsif actor.x > pos[0] and actor.y < pos[1]
      actor.turn_down
      actor.y += 1
      actor.x -= 1
    elsif actor.x > pos[0] and actor.y > pos[1]
      actor.turn_left
      actor.y -= 1
      actor.x -= 1
    elsif actor.x < pos[0] and actor.y < pos[1]
      actor.turn_right
      actor.y += 1
      actor.x += 1
    end
    actor.increase_steps
  end
  #--------------------------------------------------------------------------
  # * Prepare for battle
  #--------------------------------------------------------------------------
  def prepare_for_battle
    $game_player.straighten
    update_basic(false, true, true)
  end
end


#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    unless $game_temp.battle_settings.empty?
      @enemies = $game_temp.battle_settings[0]
      @enemy_troop_id = $game_temp.battle_settings[1]
      @end_pos = $game_temp.battle_settings[2]
      @escape_pos = $game_temp.battle_settings[3]
      @hide_bars = true
    end
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias ctbattle_main main
  def main
    ctbattle_main
    $game_temp.in_ct_battle = false
    $game_temp.lock_map_postions = false
    $game_temp.battle_end_transition = true unless $game_temp.battle_settings.empty?
  end
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias ctbattle_start start
  def start
    ctbattle_start
    unless $game_temp.battle_settings.empty?
      $game_troop.setup(@enemy_troop_id, @enemies)
      @troop_id = @enemy_troop_id
    end
  end
  #--------------------------------------------------------------------------
  # * Create Display Viewport
  #--------------------------------------------------------------------------
  alias create_viewport_ctbattle create_viewport
  def create_viewport
    map_update
    for battler in $game_party.actors + $game_troop.enemies
      battler.battler_position_setup
    end
    create_viewport_ctbattle
  end
  #--------------------------------------------------------------------------
  # * Show transition
  #--------------------------------------------------------------------------
  alias show_transition_ctbattle show_transition
  def show_transition
    unless $game_temp.battle_settings.empty?
      Graphics.transition(0)
    else
      show_transition_ctbattle
    end
  end
  #--------------------------------------------------------------------------
  # * Update Map
  #--------------------------------------------------------------------------
  def map_update
    $game_map.update
    $game_player.update
  end
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  alias ctbattle_update_graphics update_graphics
  def update_graphics
    map_update unless $game_temp.battle_settings.empty?
    ctbattle_update_graphics
  end
  #--------------------------------------------------------------------------
  # * Basic Update Processing
  #--------------------------------------------------------------------------
  alias ctbattle_update_basic update_basic
  def update_basic
    ctbattle_update_basic
    map_update unless $game_temp.battle_settings.empty?
  end
  #--------------------------------------------------------------------------
  # * Set intro battlecry
  #--------------------------------------------------------------------------
  alias ctbattle_set_intro set_intro
  def set_intro
    ctbattle_set_intro
    intro_finish
  end
  #--------------------------------------------------------------------------
  # * Process intro animation
  #--------------------------------------------------------------------------
  alias ctbattle_intro_anime intro_anime
  def intro_anime
    ctbattle_intro_anime
    wait(10)
    @battle_start = false
  end
  #--------------------------------------------------------------------------
  # * Finsish Intro
  #--------------------------------------------------------------------------
  def intro_finish
    unless $game_temp.battle_settings.empty?
      $game_temp.hide_windows = false
      @status_window.visible = true
      @status_window.update
      $game_temp.map_bgm = $game_system.playing_bgm
      $game_system.bgm_play($game_system.battle_bgm)
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose 3:abort)
  #--------------------------------------------------------------------------
  alias ctbattle_battle_end battle_end
  def battle_end(result)
    set_dead_enemies_self_switches
    ctbattle_battle_end(result)
    $game_temp.battle_result = result
    auto_revive if Auto_Revive and not $scene.is_a?(Scene_Gameover)
  end
  #--------------------------------------------------------------------------
  # * Set dead enemies self switches
  #--------------------------------------------------------------------------
  def set_dead_enemies_self_switches
    for i in 0...$game_temp.enemy_troop.size
      event_id = $game_temp.event_troop[i]
      delete = $game_temp.event_delete[i]
      enemy = $game_troop.enemies[i]
      if enemy != nil and enemy.dead? and delete
        key = [$game_map.map_id, event_id, 'D']
        $game_self_switches[key] = true
      elsif enemy != nil and enemy.dead? and not delete
        $game_map.events[event_id].erase
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Auto revive
  #--------------------------------------------------------------------------
  def auto_revive
    for actor in $game_party.actors
      actor.hp = 1 if actor != nil and actor.dead?
    end
  end
end