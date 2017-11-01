#==============================================================
# Vehicle System XP
# By Orochii Zouveleki
#==============================================================
# HOW TO USE
# To position a vehicle in a place on a map:
# $game_map.set_vehicle(idVehículo,idMapa,x,y)
# 
# To change vehicle graphic in game:
# $game_map.vehicle_names[idVehiculo] = "nuevonombre"
#==============================================================

module VehicleConfig
  #=============================================================================
  # ==Configuration==
  #=============================================================================
  VEHICLE_MUSIC = ["012-Theme01","045-Positive03","014-Theme03"]
  VEHICLE_TYPE  = [0,1,2] # 0=Earth 1=Water 2=Air
  VEHICLE_ADD_SPEED = [0.5 , 0.2 , 1] # It can be negative
  INITIAL_GRAPHICS = ["Panzer","Ship","Airship"]

  PASSABILITY={ # This uses terrains
    :earth=>[0,2,5,6,7,8],
    :water=>[4],
    :air=>[0,1,2,3,4,5,6,7,8],
  }
  VEHICLE_PASS=[:earth,:water,:air]
  NO_LAND = 7 # Terrain where you can't land.
  #=============================================================================
  DIR8 = false # 8 directions movement (without diagonal graphics)
  DASH = false # Run with Z key
  EXTRA_ANIM = false # Extra grafics to run, jump and blink.
  
  # File extensions for extra animations
  #(name_run.png, name_jump.png)
  #(name__blink.png, name_run_blink.png, name_jump_blink.png)
  EXT_CONFIG = ["_run","_jump","_blink"] #Run, jump, blink
  ANIM_EXTENSIONS = ["","_run","_jump","_blink"]
  EXT_VAR = 1 # Variable to control extra animations
  
  def self.anim_ext(val)
    return ANIM_EXTENSIONS[val]==nil ? "" : ANIM_EXTENSIONS[val]
  end
end

class Game_Temp
  attr_accessor :prevehicle_bgm
end

class Game_Character
  attr_accessor :through
  attr_accessor :vehicle_wait
  
  alias gc_init initialize unless $@
  def initialize
    @vehicle_wait = false
    @offset_y = 0
    @get_off = false
    gc_init
  end
  
  #--------------------------------------------------------------------------
  # * Get Screen Y-Coordinates
  #--------------------------------------------------------------------------
  def screen_y
    # Get screen coordinates from real coordinates and map display position
    y = (@real_y - $game_map.display_y + 3) / 4 + 32
    # Make y-coordinate smaller via jump count
    if @jump_count >= @jump_peak
      n = @jump_count - @jump_peak
    else
      n = @jump_peak - @jump_count
    end
    @offset_y = 0 if @offset_y == nil
    return y - @offset_y - (@jump_peak * @jump_peak - n * n) / 2
  end
  
  #--------------------------------------------------------------------------
  # * Get Screen Z-Coordinates
  #     height : character height
  #--------------------------------------------------------------------------
  def screen_z(height = 0)
    # If display flag on closest surface is ON
    if @always_on_top
      # 999, unconditional
      return 999
    end
    # Get screen coordinates from real coordinates and map display position
    z = (@real_y - $game_map.display_y + 3) / 4 + 32
    # If tile
    if @tile_id > 0
      # Add tile priority * 32
      return z + $game_map.priorities[@tile_id] * 32
    # If character
    else
      @offset_y = 0 if @offset_y == nil
      return z + ((height > 32) ? 31 : 0) - 1 + (@offset_y*8)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Get Terrain Tag
  #--------------------------------------------------------------------------
  def terrain_tag
    return $game_map.terrain_tag(@x, @y)
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
  
  attr_accessor :move_speed
  #--------------------------------------------------------------------------
  # * Passable Determinants
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,2,4,6,8)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #--------------------------------------------------------------------------
  def reset_graphic
    @character_name = $game_party.actors[0].character_name
  end
  
  def passable?(x, y, d)
    # Get new coordinates
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    # If coordinates are outside of map
    unless $game_map.valid?(new_x, new_y)
      # Impassable
      return false
    end
    # If debug mode is ON and ctrl key was pressed
    if $DEBUG and Input.press?(Input::CTRL)
      # Passable
      return true
    end
    
    if @through == true
      return true
    end
    
    if check_event(new_x,new_y) == true
      return false if ($game_map.on_vehicle? != -1)&&($game_map.on_vehicle?(true) != 2)
    end
    
    if $game_map.on_vehicle? != -1
      kind = VehicleConfig::VEHICLE_PASS[$game_map.on_vehicle?]
      return VehicleConfig::PASSABILITY[kind].include?($game_map.terrain_tag(new_x, new_y))
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Same Position Starting Determinant
  #--------------------------------------------------------------------------
  alias gp_ceth check_event_trigger_here unless $@
  def check_event_trigger_here(triggers)
    return false if $game_map.on_vehicle? != -1
    gp_ceth (triggers)
  end
  
  def check_event_here
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # All event loops
    for event in $game_map.events.values
      # If event coordinates and triggers are consistent
      if event.x == @x and event.y == @y
        result = true
      end
    end
    return result
  end
  
  def check_event(cx,cy)
    result = false
    # If event is running
    #if $game_system.map_interpreter.running?
    #  return result
    #end
    # All event loops
    for event in $game_map.events.values
      # If event coordinates and triggers are consistent
      if event.x == cx and event.y == cy
        result = true
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Front Envent Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_there
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Calculate front event coordinates
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    # All event loops
    for event in $game_map.events.values
      # If event coordinates and triggers are consistent
      if event.x == new_x and event.y == new_y
        result = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Front Envent Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    result = false
    # If event is running
    if $game_system.map_interpreter.running?
      return result
    end
    # Calculate front event coordinates
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    # All event loops
    for event in $game_map.events.values
      # If event coordinates and triggers are consistent
      if event.x == new_x and event.y == new_y and
         triggers.include?(event.trigger)
        # If starting determinant is front event (other than jumping)
        if not event.jumping? and not event.over_trigger?
          #If event is a Vehicle
          if event.is_a?(Game_Vehicle)
            #$game_map.get_on_vehicle(event.id)
            result = true
          else
            event.start
            result = true
          end
          event.start
          result = true
        end
      end
    end
    # If fitting event is not found
    if result == false
      # If front tile is a counter
      if $game_map.counter?(new_x, new_y)
        # Calculate 1 tile inside coordinates
        new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
        new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
        # All event loops
        for event in $game_map.events.values
          # If event coordinates and triggers are consistent
          if event.x == new_x and event.y == new_y and
             triggers.include?(event.trigger)
            # If starting determinant is front event (other than jumping)
            if not event.jumping? and not event.over_trigger?
              event.start
              result = true
            end
          end
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  alias gp_cett check_event_trigger_touch unless $@
  def check_event_trigger_touch(x, y)
    return false if $game_map.on_vehicle? != -1
    gp_cett(x, y)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Remember whether or not moving in local variables
    last_moving = moving?
    # Remember coordinates in local variables
    last_real_x = @real_x
    last_real_y = @real_y
    super
    update_scroll(last_real_x,last_real_y)
    # If not moving
    if $game_map.on_vehicle? > -1
      update_vehicle
    else
      update_player_sprite
    end
    
    if not moving?
      # If player was moving last time
      if last_moving
        # Event determinant is via touch of same position event
        result = check_event_trigger_here([1,2])
        # If event which started does not exist
        if result == false
          # Disregard if debug mode is ON and ctrl key was pressed
          unless $DEBUG and Input.press?(Input::CTRL)
            # Encounter countdown
            if @encounter_count > 0
              @encounter_count -= 1
            end
          end
        end
      end
      # If C button was pressed
      if Input.trigger?(Input::C)
        if $game_map.on_vehicle? == -1
          # Same position and front event determinant
          check_event_trigger_here([0])
          check_event_trigger_there([0,1,2])
        else
          pass = $game_map.passable?($game_player.x, $game_player.y, 10)
          if $game_map.on_vehicle? == 1
            pass = $game_map.f_passable?($game_player.x, $game_player.y, 10)
            pass = false if ($game_map.f_terrain_tag($game_player.x, $game_player.y) == VehicleConfig::NO_LAND)
            pass = false if $game_player.check_event_there == true
          else
            pass = false if ($game_player.terrain_tag==7)
            pass = false if $game_player.check_event_here == true
          end
          #pass = false if $game_map
          if pass == true
            @get_off = true
            $game_system.bgm_play($game_temp.prevehicle_bgm)
          end
        end
      end
    end
    # If moving, event running, move route forcing, and message window
    # display are all not occurring
    unless moving? or $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_temp.menu_calling
      update_move_input
    end
  end
  
  def update_move_input
    return if (@offset_y > 0)&&(@offset_y < 32) or @vehicle_wait == true
    # Move player in the direction the directional button is being pressed
    if VehicleConfig::DIR8
      case Input.dir8
      when 1
        move_lower_left
      when 2
        move_down
      when 3
        move_lower_right
      when 4
        move_left
      when 6
        move_right
      when 7
        move_upper_left
      when 8
        move_up
      when 9
        move_upper_right
      end
    else
      case Input.dir4
      when 2
        move_down
      when 4
        move_left
      when 6
        move_right
      when 8
        move_up
      end
    end
  end
  
  def update_scroll(last_real_x,last_real_y)
    # If character moves down and is positioned lower than the center
    # of the screen
    if @real_y > last_real_y and @real_y - $game_map.display_y > CENTER_Y
      # Scroll map down
      $game_map.scroll_down(@real_y - last_real_y)
    end
    # If character moves left and is positioned more let on-screen than
    # center
    if @real_x < last_real_x and @real_x - $game_map.display_x < CENTER_X
      # Scroll map left
      $game_map.scroll_left(last_real_x - @real_x)
    end
    # If character moves right and is positioned more right on-screen than
    # center
    if @real_x > last_real_x and @real_x - $game_map.display_x > CENTER_X
      # Scroll map right
      $game_map.scroll_right(@real_x - last_real_x)
    end
    # If character moves up and is positioned higher than the center
    # of the screen
    if @real_y < last_real_y and @real_y - $game_map.display_y < CENTER_Y
      # Scroll map up
      $game_map.scroll_up(last_real_y - @real_y)
    end
  end
  
  def update_vehicle
    case $game_map.on_vehicle?(true)
    when 0 #Vehicle
      unless moving?
        @vehicle_wait = false
        $game_map.erase_vehicle($game_map.on_vehicle?)
        @character_name = $game_map.vehicle_names[$game_map.on_vehicle?]
        @step_anime = true
      end
      return if moving? and @vehicle_wait==true
      if @get_off == true
        $game_map.set_vehicle($game_map.on_vehicle?,$game_map.map_id,$game_player.x, $game_player.y)
        $game_player.move_forward
        @get_off = false
      end
    when 1 #Ship
      unless moving?
        @vehicle_wait = false
        $game_map.erase_vehicle($game_map.on_vehicle?)
        @character_name = $game_map.vehicle_names[$game_map.on_vehicle?]
        
        @step_anime = true
      end      
      return if moving? and @vehicle_wait==true
      
      if @get_off == true
        $game_map.set_vehicle($game_map.on_vehicle?,$game_map.map_id,$game_player.x, $game_player.y)
        $game_player.through = true
        $game_player.move_forward
        $game_player.through = false
        @get_off = false
      end
    when 2 #Aircraft
      return if moving? and @offset_y == 0
      @vehicle_wait = false
      if @offset_y == 0
        $game_map.erase_vehicle($game_map.on_vehicle?)
        @character_name = $game_map.vehicle_names[$game_map.on_vehicle?]
        @step_anime = true
      end
      
      if @get_off == false
        @always_on_top = true
        @offset_y = [@offset_y + 1, 32].min
        return if @offset_y != 32
      elsif @get_off == true
        @offset_y = [@offset_y - 1, 0].max
        return if @offset_y != 0
        @always_on_top = false
        $game_map.set_vehicle($game_map.on_vehicle?,$game_map.map_id,$game_player.x, $game_player.y)
        $game_player.move_down
        @get_off = false
      end
    end
  end
  
  def update_player_sprite
    unless $game_system.map_interpreter.running?
      @step_anime = false
    end
    return if VehicleConfig::EXTRA_ANIM==false
    extension = ((@move_speed > 4)&&(moving? or Input.dir4 > 0)) ? VehicleConfig::EXT_CONFIG[0] : ""
    extension = jumping? ? VehicleConfig::EXT_CONFIG[1] : extension
    extension += VehicleConfig::EXT_CONFIG[2] if (Graphics.frame_count % 200) >= 1 && (Graphics.frame_count % 200) < 5
    if $game_variables[1] != 0
      extension = VehicleConfig.anim_ext($game_variables[VehicleConfig::EXT_VAR])
    end
    if $game_variables[1] != -1
      @character_name = $game_party.actors[0].character_name + extension if $game_party.actors[0] != nil
    end
  end
  
  #Movement
  def move_down(turn=true)
    super(turn)
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_left(turn=true)
    super(turn)
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_up(turn=true)
    super(turn)
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_right(turn=true)
    super(turn)
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_lower_left
    super
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_lower_right
    super
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_upper_left
    super
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
  end
  
  def move_upper_right
    super
    unless $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing or $game_map.on_vehicle? >= 1
      check_event_trigger_there([1,2])
    end
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
  # * Temporarily Erase
  #--------------------------------------------------------------------------
  #def erase
  #  @erased = true
  #  moveto(-15,-15)
  #  refresh
  #end
  
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  alias ge_check_touch check_event_trigger_touch unless $@
  def check_event_trigger_touch(x, y)
    # If event is running
    return if $game_map.on_vehicle? != -1
    ge_check_touch(x, y)
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles the map. It includes scrolling and passable determining
#  functions. Refer to "$game_map" for the instance of this class.
#==============================================================================

class Game_Map
  
  attr_reader   :vehicle_x
  attr_reader   :vehicle_y
  attr_reader   :vehicle_map
  attr_accessor :vehicle_names
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias gm_init initialize unless $@
  def initialize
    gm_init
    @vehicle_x = [0,0,0]
    @vehicle_y = [0,0,0]
    @vehicle_map = [0,0,0]
    @using_vehicle = -1
    @vehicle_names = VehicleConfig::INITIAL_GRAPHICS
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  alias gm_set setup unless $@
  def setup(map_id)
    gm_set(map_id)
    for i in 0...@vehicle_map.size
      set_vehicle(i,@vehicle_map[i],@vehicle_x[i],@vehicle_y[i])
    end
  end
  
  def f_passable?(x,y,d)
    case $game_player.direction
    when 2
      y += 1
    when 4
      x -= 1
    when 6
      x += 1
    when 8
      y -= 1
    end
    passable?(x,y,d)
  end
  
  def f_terrain_tag(x,y)
    case $game_player.direction
    when 2
      y += 1
    when 4
      x -= 1
    when 6
      x += 1
    when 8
      y -= 1
    end
    terrain_tag(x, y)
  end
  
  def on_vehicle?(type=false)
    #VehicleConfig::VEHICLE_TYPE
    return type ? VehicleConfig::VEHICLE_TYPE[@using_vehicle] : @using_vehicle
  end
  
  def get_on_vehicle(id)
    through_vehicle(id)
    $game_player.through = true
    $game_player.move_forward
    $game_player.through = false
    $game_player.vehicle_wait
    @using_vehicle = id
    $game_temp.prevehicle_bgm = $game_system.playing_bgm
    vehicle = RPG::AudioFile.new(VehicleConfig::VEHICLE_MUSIC[$game_map.on_vehicle?], 80, 100)
    $game_system.bgm_play(vehicle)
  end
  
  def get_off_vehicle(id)
    erase_vehicle(id)
    @using_vehicle = -1
    $game_player.move_speed = 4
    $game_player.reset_graphic if VehicleConfig::EXTRA_ANIM==false
  end
  
  def through_vehicle(id)
    found_id = false
    for i in 20000...(20000+@vehicle_map.size)
      event = @events[i]
      if event.is_a?(Game_Vehicle)
        if event.id == id
          found_id = event.id
          break
        end
      end
    end
    @events[found_id+20000].through=true unless found_id==false
  end
  
  def erase_vehicle(id)
    found_id = false
    for i in 20000...(20000+@vehicle_map.size)
      event = @events[i]
      if event.is_a?(Game_Vehicle)
        if event.id == id
          found_id = event.id
          break
        end
      end
    end
    unless found_id==false
      @events[found_id+20000].erase
      @events[found_id+20000].moveto(-15,-15)
    end
  end
  
  def set_vehicle(id,map_id,x,y)
    get_off_vehicle(id)
    @vehicle_x[id] = x
    @vehicle_y[id] = y
    @vehicle_map[id] = map_id
    create_vehicle(id) if map_id == @map_id
    need_refresh = true
  end
  
  def create_vehicle(id)
    @events[(id+20000)] = Game_Vehicle.new(id)
    $scene.spriteset.create_vehicle_sprite(@events[(id+20000)]) if $scene.is_a?(Scene_Map)
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
#  switching via condition determinants, and running parallel process events.
#  It's used within the Game_Map class.
#==============================================================================

class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :trigger                  # trigger
  attr_reader   :list                     # list of event commands
  attr_reader   :starting                 # starting flag
  attr_accessor :through
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     map_id : map ID
  #     event  : event (RPG::Event)
  #--------------------------------------------------------------------------
  def initialize(id)
    super()
    @map_id = $game_map.map_id
    #@event = event
    @id = id #@event.id
    @erased = false
    @starting = false
    @through = true
    # Move to starting position @event
    moveto($game_map.vehicle_x[id], $game_map.vehicle_y[id])
    refresh
  end
  #--------------------------------------------------------------------------
  # * Clear Starting Flag
  #--------------------------------------------------------------------------
  def clear_starting
    @starting = false
  end
  #--------------------------------------------------------------------------
  # * Determine if Over Trigger
  #    (whether or not same position is starting condition)
  #--------------------------------------------------------------------------
  def over_trigger?
    # If not through situation with character as graphic
    if @character_name != "" and not @through
      # Starting determinant is face
      return false
    end
    # If this position on the map is impassable
    unless $game_map.passable?(@x, @y, 0)
      # Starting determinant is face
      return false
    end
    # Starting determinant is same position
    return true
  end
  #--------------------------------------------------------------------------
  # * Start Event
  #--------------------------------------------------------------------------
  def start
    # If list of event commands is not empty
    #if @list.size > 1
    #  @starting = true
    #end
    $game_map.get_on_vehicle(@id)
  end
  #--------------------------------------------------------------------------
  # * Temporarily Erase
  #--------------------------------------------------------------------------
  def erase
    @erased = true
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Clear starting flag
    clear_starting
    # Set each instance variable
    @tile_id = 0
    @character_name = @erased==true ? "" : $game_map.vehicle_names[id]
    @character_hue = 0
    @direction = 4 if @id == 1
    @move_type = 0
    @opacity = 255
    @through = false
    @trigger = 0
    @list = nil
    @interpreter = nil
    @step_anime = true if @id == 1
    # End method
  end
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    # If event is running
    if $game_system.map_interpreter.running? or $game_map.on_vehicle? != -1
      return
    end
    # If trigger is [touch from event] and consistent with player coordinates
    if @trigger == 2 and x == $game_player.x and y == $game_player.y
      # If starting determinant other than jumping is front event
      if not jumping? and not over_trigger?
        start
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Automatic Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    # If trigger is [touch from event] and consistent with player coordinates
    if @trigger == 2 and @x == $game_player.x and @y == $game_player.y
      # If starting determinant other than jumping is same position event
      if not jumping? and over_trigger?
        start
      end
    end
    # If trigger is [auto run]
    if @trigger == 3
      start
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @character_name = @erased==true ? "" : $game_map.vehicle_names[id]
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc.
#  It's used within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  attr_reader :vehicle_sprites
  attr_reader :tilemap
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias sm_init initialize unless $@
  def initialize
    @vehicle_sprites = []
    sm_init
  end
  
  def create_vehicle_sprite(event)
    sprite = Sprite_Character.new(@viewport1, event)
    @character_sprites.push(sprite)
    #shadow = Sprite_Shadow.new(@viewport1, event)
    #@character_sprites.push(shadow)
    @vehicle_sprites.push(event.id)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias sm_upd update unless $@
  def update
    for i in 0...@character_sprites.size
      @character_sprites[i].dispose if @character_sprites[i].character == nil
    end
    sm_upd
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================

class Scene_Map
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Loop
    loop do
      # Update map, interpreter, and player order
      # (this update order is important for when conditions are fulfilled 
      # to run any event, and the player isn't provided the opportunity to
      # move in an instant)
      $game_map.update
      $game_system.map_interpreter.update
      $game_player.update
      # Update system (timer), screen
      $game_system.update
      $game_screen.update
      # Abort loop if player isn't place moving
      unless $game_temp.player_transferring
        break
      end
      # Run place move
      transfer_player
      #if !(Zones::EXTERIORS.include?($game_map.map_id))
      #  $game_screen.tone = $game_screen.tone_target
      #end
      # Abort loop if transition processing
      if $game_temp.transition_processing
        break
      end
    end
    # Update sprite set
    @spriteset.update
    # Update message window
    @message_window.update
    # If game over
    if $game_temp.gameover
      # Switch to game over screen
      #$scene = Scene_Map.new
      #ASDTsutarja2525
      $game_temp.player_new_map_id = 9
      $game_temp.player_new_x = 9
      $game_temp.player_new_y = 7
      #$game_temp.transition_processing = true
      $game_temp.player_transferring = true
      $game_temp.gameover = false
      return
    end
    # If returning to title screen
    if $game_temp.to_title
      # Change to title screen
      $scene = Scene_Title.new
      return
    end
    # If transition processing
    if $game_temp.transition_processing
      # Clear transition processing flag
      $game_temp.transition_processing = false
      # Execute transition
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    # If showing message window
    if $game_temp.message_window_showing
      return
    end
    # If encounter list isn't empty, and encounter count is 0
    if $game_player.encounter_count == 0 and $game_map.encounter_list != []
      # If event is running or encounter is not forbidden
      unless $game_system.map_interpreter.running? or
             $game_system.encounter_disabled
        # Confirm troop
        n = rand($game_map.encounter_list.size)
        troop_id = $game_map.encounter_list[n]
        # If troop is valid
        if $data_troops[troop_id] != nil
          # Set battle calling flag
          $game_temp.battle_calling = true
          $game_temp.battle_troop_id = troop_id
          $game_temp.battle_can_escape = true
          $game_temp.battle_can_lose = false
          $game_temp.battle_proc = nil
        end
      end
    end
    # If B button was pressed
    if Input.trigger?(Input::B)
      # If event is running, or menu is not forbidden
      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
        # Set menu calling flag or beep flag
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
      end
    end
    
    if VehicleConfig::DASH
      if Input.press?(Input::A) and not $game_system.map_interpreter.running?
        $game_player.move_speed = 5
      else
        $game_player.move_speed = 4 unless $game_system.map_interpreter.running?
      end
      $game_player.move_speed += VehicleConfig::VEHICLE_ADD_SPEED[$game_map.on_vehicle?] if $game_map.on_vehicle? > -1
      else
      $game_player.move_speed = 4 + VehicleConfig::VEHICLE_ADD_SPEED[$game_map.on_vehicle?] if $game_map.on_vehicle? > -1
    end
    # If debug mode is ON and F9 key was pressed
    if $DEBUG and Input.press?(Input::F9)
      # Set debug calling flag
      $game_temp.debug_calling = true
    end
    # If player is not moving
    unless $game_player.moving?
      # Run calling of each screen
      if $game_temp.battle_calling
        call_battle
      elsif $game_temp.shop_calling
        call_shop
      elsif $game_temp.name_calling
        call_name
      elsif $game_temp.menu_calling
        call_menu
      elsif $game_temp.save_calling
        call_save
      elsif $game_temp.debug_calling
        call_debug
      end
    end
  end
end

#==============================================================================
# ** Game_Character (part 3)
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
  #=======================
  #CUSTOM MOVEMENT OPTIONS
  #=======================
  
  #--------------------------------------------------------------------------
  # * Is event/player within x range from char 
  #--------------------------------------------------------------------------
  def in_range?(id,n)
    event = id == 0 ? $game_player : $game_map.events.include?(id) ? $game_map.events[id] : nil
    return false if event==nil
    # Get difference in coordinates
    sx = @x - event.x
    sy = @y - event.y
    return (sx.abs+sy.abs) <= n
  end
  #--------------------------------------------------------------------------
  # * Face event
  #--------------------------------------------------------------------------
  def face_event(id)
    event = id == 0 ? $game_player : $game_map.events.include?(id) ? $game_map.events[id] : nil
    return if event==nil
    # Get difference in coordinates
    sx = @x - event.x
    sy = @y - event.y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards player
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards player
      sy > 0 ? turn_up : turn_down
    end
  end
  
  def can_see_event(id)
    event = id == 0 ? $game_player : $game_map.events.include?(id) ? $game_map.events[id] : nil
    return if event==nil
    sx = @x - event.x
    sy = @y - event.y
    return false if (@direction==2)&&(sy>0)
    return false if (@direction==4)&&(sx<0)
    return false if (@direction==6)&&(sx>0)
    return false if (@direction==8)&&(sy<0)
    return true
  end
  #--------------------------------------------------------------------------
  # * Face event if it's inside range n
  #--------------------------------------------------------------------------
  def range_face(id,n,check_seeing=true,face=0)
    seen = check_seeing ? can_see_event(id) : true
    if in_range?(id, n) && seen
      face_event(id)
    else
      case face
      when 2 then turn_down
      when 4 then turn_left
      when 6 then turn_right
      when 8 then turn_up
      else turn_random
      end
    end
  end
  
  def g_v(n)
    return $game_variables[n]
  end
  def g_s(n)
    return $game_switches[n]
  end
  def party_char(n)
    @character_name = $game_party.actors[n].character_name
  end
end

class Game_Event
  def set_self(switch, n)
    key = [@map_id, @event.id, switch]
    $game_self_switches[key] = n
  end
end