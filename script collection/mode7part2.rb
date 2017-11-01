#============================================================================
# This script adds a kind of depth for the maps.
# Written by MGCaladtogel
# English version (24/04/08)
#============================================================================
# Ã¢ €“   Game_Map
#----------------------------------------------------------------------------
# Methods modifications to handle map looping
#============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Scroll Down
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias scroll_down_mode7_game_map scroll_down
  def scroll_down(distance)
    if !$game_system.mode7
      scroll_down_mode7_game_map(distance)
      return
    end
    if $game_system.loop_y or $game_system.always_scroll
      @display_y = @display_y + distance # always scroll
    else
      @display_y = [@display_y + distance, (self.height - 15) * 128].min
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Left
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias scroll_left_mode7_game_map scroll_left
  def scroll_left(distance)
    if !$game_system.mode7
      scroll_left_mode7_game_map(distance)
      return
    end
    if $game_system.loop_x or $game_system.always_scroll
      @display_x = @display_x - distance # always scroll
    else
      @display_x = [@display_x - distance, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Right
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias scroll_right_mode7_game_map scroll_right
  def scroll_right(distance)
    if !$game_system.mode7
      scroll_right_mode7_game_map(distance)
      return
    end
    if $game_system.loop_x or $game_system.always_scroll
      @display_x = @display_x + distance # always scroll
    else
      @display_x = [@display_x + distance, (self.width - 20) * 128].min
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Up
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  alias scroll_up_mode7_game_map scroll_up
  def scroll_up(distance)
    if !$game_system.mode7
      scroll_up_mode7_game_map(distance)
      return
    end
    if $game_system.loop_y or $game_system.always_scroll
      @display_y = @display_y - distance # always scroll
    else
      @display_y = [@display_y - distance, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Valid Coordinates
  #     x          : x-coordinate
  #     y          : y-coordinate
  #   Allow the hero to go out of the map when map looping
  #--------------------------------------------------------------------------
  alias valid_mode7_game_map? valid?
  def valid?(x, y)
    if !$game_system.mode7
      return (valid_mode7_game_map?(x, y))
    end
    if $game_system.loop_x
      if $game_system.loop_y
        return true
      else
        return (y >= 0 and y < height)
      end
    elsif $game_system.loop_y
      return (x >= 0 and x < width)
    end
    return (x >= 0 and x < width and y >= 0 and y < height)
  end
  #--------------------------------------------------------------------------
  # * Determine if Passable
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     d          : direction (0,2,4,6,8,10)
  #                  *  0,10 = determine if all directions are impassable
  #     self_event : Self (If event is determined passable)
  #--------------------------------------------------------------------------
  alias passable_mode7_game_map? passable?
  def passable?(x, y, d, self_event = nil)
    if !$game_system.mode7
      passable_mode7_game_map?(x, y, d, self_event)
      return(passable_mode7_game_map?(x, y, d, self_event))
    end
    unless valid?(x, y)
      return false
    end
    bit = (1 << (d / 2 - 1)) & 0x0f
    for event in events.values
      if event.tile_id >= 0 and event != self_event and
         event.x == x and event.y == y and not event.through
        if @passages[event.tile_id] & bit != 0
          return false
        elsif @passages[event.tile_id] & 0x0f == 0x0f
          return false
        elsif @priorities[event.tile_id] == 0
          return true
        end
      end
    end
    for i in [2, 1, 0]
      tile_id = data[x % width, y % height, i] # handle map looping
      if tile_id == nil
        return false
      elsif @passages[tile_id] & bit != 0
        return false
      elsif @passages[tile_id] & 0x0f == 0x0f
        return false
      elsif @priorities[tile_id] == 0
        return true
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  alias old_setup_mode7 setup
  def setup(map_id)
    old_setup_mode7(map_id)
    if !$game_switches[$enable_mode7_number]
      $game_system.mode7 = false
      $game_system.mode7 = false
      $game_system.loop_x = false
      $game_system.loop_y = false
      $game_system.always_scroll = false
      $game_system.animated = false
      $game_system.white_horizon = false
      $game_system.angle = 0
      $game_system.fixed_panorama = false
      $game_system.ov = false
      $game_system.ov_zoom = 0.6
      $game_system.reset
      return
    end
    map_data = $data_maps[$game_map.map_id]
    for keyword in $mode7_maps_settings.keys
      if map_data.name2.include?(keyword)
        command_list = $mode7_maps_settings[keyword]
        $game_system.mode7 = true
        $game_system.loop_x = command_list.include?("X")
        $game_system.loop_y = command_list.include?("Y")
        $game_system.always_scroll = command_list.include?("C")
        $game_system.animated = command_list.include?("A")
        $game_system.white_horizon = command_list.include?("H")
        $game_system.fixed_panorama = command_list.include?("P")
        $game_system.ov = command_list.include?("OV")
        for command in command_list
          if command.include?("#")
            $game_system.angle = (command.slice(1, 2)).to_i
            $game_system.angle = [[$game_system.angle, 0].max, 89].min
            break
          end
        end
        return
      end
    end
    $game_system.mode7 = map_data.name2.include?("[M7]")
    $game_system.loop_x = map_data.name2.include?("[X]")
    $game_system.loop_y = map_data.name2.include?("[Y]")
    $game_system.always_scroll = map_data.name2.include?("[C]")
    $game_system.animated = map_data.name2.include?("[A]")
    $game_system.white_horizon = map_data.name2.include?("[H]")
    $game_system.fixed_panorama = map_data.name2.include?("[P]")
    $game_system.ov = map_data.name2.include?("[OV]")
    if $game_system.mode7
      map_data.name2 =~ /\[#[ ]*([00-99]+)\]/i
      $game_system.angle = $1.to_i
      $game_system.angle = [[$game_system.angle, 0].max, 89].min
    end
  end
end

#============================================================================
# Ã¢ €“   Game_Character
#----------------------------------------------------------------------------
# "update" method modifications to handle map looping
#============================================================================

class Game_Character
  attr_accessor :x
  attr_accessor :y
  attr_accessor :real_x
  attr_accessor :real_y
  attr_reader   :flat
  attr_reader   :height
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_mode7_game_character initialize
  def initialize
    initialize_mode7_game_character
    @flat = false
    @height = 0.0
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias update_mode7_game_character update
  def update
    if !$game_system.mode7
      update_mode7_game_character
      return
    end
    # if x-coordinate is out of the map
    if !(x.between?(0, $game_map.width - 1))
      difference = 128 * x - real_x
      if self.is_a?(Game_Player)
        # increase or decrease map's number
        self.map_number_x += difference / (difference.abs)
      end
      # x-coordinate is equal to its equivalent in the map
      self.x %= $game_map.width
      self.real_x = 128 * x - difference
    end
    # if y-coordinate is out of the map
    if !(y.between?(0, $game_map.height - 1))
      difference = 128 * y - real_y
      if self.is_a?(Game_Player)
        # increase or decrease map's number
        self.map_number_y += difference / (difference.abs)
      end
      # y-coordinate is equal to its equivalent in the map
      self.y %= $game_map.height
      self.real_y = 128 * y - difference
    end
    update_mode7_game_character
  end
end

#==============================================================================
# Ã¢ €“   Game_Event
#----------------------------------------------------------------------------
# Add methods to handle flat events and altitude for vertical event
#============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * scan the event's commands list
  #     page : the scanned page (RPG::Event::Page)
  #--------------------------------------------------------------------------
  def check_commands(page)
    @height = 0.0
    command_list = page.list
    for k in 0..command_list.length - 2
      command = command_list[k]
      if (command.parameters[0].to_s).include?("Height")
        @height = (command.parameters[0][7,command.parameters[0].length-1]).to_f
      end
      @flat = (command.parameters[0].to_s).include?("Flat")
    end
  end
  #--------------------------------------------------------------------------
  # * scan the event's commands list of the current page when refreshed
  #--------------------------------------------------------------------------
  alias refresh_mode7_game_character refresh
  def refresh
    refresh_mode7_game_character
    check_commands(@page) if @page != nil
  end
end

#============================================================================
# Ã¢ €“   Game_Player
#----------------------------------------------------------------------------
# Add attributes to have a well-working panorama's scrolling
#============================================================================

class Game_Player < Game_Character
  attr_accessor :map_number_x # map's number with X-looping
  attr_accessor :map_number_y # map's number with Y-looping
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_mode7_game_player initialize
  def initialize
    initialize_mode7_game_player
    self.map_number_x = 0
    self.map_number_y = 0
  end
  #--------------------------------------------------------------------------
  # * Handle the option : center around the hero
  #--------------------------------------------------------------------------
  alias center_mode7_game_player center
  def center(x, y)
    if !$game_system.loop_y and !$game_system.always_scroll#!$game_system.mode7
      center_mode7_game_player(x, y)
      return
    end
    $game_map.display_x = x * 128 - CENTER_X
    $game_map.display_y = y * 128 - CENTER_Y
  end
end

#============================================================================
# Ã¢ €“   Sprite
#----------------------------------------------------------------------------
# Add attributes to work efficiently with scanlines sprites
#============================================================================

class Sprite
  attr_accessor :y_origin_bitmap # bitmap's y-coordinate for the "src_rect.set"
  #method (float)
  attr_accessor :x_origin_bitmap # bitmap's x-coordinate for the "src_rect.set"
  #method (float)
  attr_accessor :y_origin_bitmap_i # bitmap's y-coordinate for the
  #"src_rect.set" method (integer)
  attr_accessor :x_origin_bitmap_i # bitmap's x-coordinate for the
  #"src_rect.set" method (integer)
  attr_accessor :length # sprite's width
end

#============================================================================
# Ã¢ €“   Sprite_Character
#----------------------------------------------------------------------------
# Calculate x-coordinate and y-coordinate for a mode7 map 
#============================================================================

class Sprite_Character < RPG::Sprite
  attr_reader   :flat_indicator # true if the event is flat-drawn
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_mode7_sprite_character initialize
  def initialize(viewport, character = nil)
    @flat_indicator = false
    initialize_mode7_sprite_character(viewport, character)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias update_mode7_sprite_character update
  def update
    if !$game_system.mode7
      update_mode7_sprite_character
      return
    end
    if @flat_indicator
      if (!@character.flat or @character.moving? or
        @tile_id != @character.tile_id or
        @character_name != @character.character_name or
        @character_hue != @character.character_hue)
        @flat_indicator = @character.flat
        # redraw the original ground
        maps_list = $scene.spriteset.tilemap.maps_list
        map_ground = $scene.spriteset.tilemap.map_ground
        rect = Rect.new(@flat_x_map, @flat_y_map, @flat_width, @flat_height)
        for map in maps_list
          map.blt(@flat_x_map, @flat_y_map, map_ground, rect)
          if $game_system.loop_x and @flat_x_map.between?(0, 19 * 32)
            map.blt(@flat_x_map + 32 * $game_map.width, @flat_y_map, map_ground,
            rect)
          end
        end
      else
        return
      end
    end
    super
    if @tile_id != @character.tile_id or
       @character_name != @character.character_name or
       @character_hue != @character.character_hue
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_hue = @character.character_hue
      if @tile_id >= 384
        self.bitmap = RPG::Cache.tile($game_map.tileset_name,
          @tile_id, @character.character_hue)
        self.src_rect.set(0, 0, 32, 32)
        self.ox = 16
        self.oy = 32
      else
        self.bitmap = RPG::Cache.character(@character.character_name,
          @character.character_hue)
        @cw = bitmap.width / 4
        @ch = bitmap.height / 4
        self.ox = @cw / 2
        self.oy = @ch
        # pivot correction (intersection between the map and this sprite)
        self.oy -= 4
      end
    end
    self.visible = (not @character.transparent)
    if @tile_id == 0
      sx = @character.pattern * @cw
      sy = (@character.direction - 2) / 2 * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
    if @character.flat # event must be flat drawn
      return if $scene.spriteset == nil
      if @tile_id == 0
        @flat_x_map = @character.real_x / 4 - (@cw - 32) / 2
        @flat_y_map = @character.real_y / 4 - @ch + 32
        @flat_x0 = sx
        @flat_y0 = sy
        @flat_width = @cw
        @flat_height = @ch
      else
        @flat_x_map = @character.real_x / 4
        @flat_y_map = @character.real_y / 4
        @flat_x0 = 0
        @flat_y0 = 0
        @flat_width = 32
        @flat_height = 32
      end
      # modify the maps graphics
      maps_list = $scene.spriteset.tilemap.maps_list
      rect = Rect.new(@flat_x0, @flat_y0, @flat_width, @flat_height)
      for map in maps_list
        map.blt(@flat_x_map, @flat_y_map, bitmap, rect, @character.opacity)
        if $game_system.loop_x and @flat_x_map.between?(0, 19 * 32)
          map.blt(@flat_x_map + 32 * $game_map.width, @flat_y_map, bitmap, rect,
          @character.opacity)
        end
      end
      @flat_indicator = true
      self.opacity = 0
      return
    end
    x_intermediate = @character.screen_x
    y_intermediate = @character.screen_y
    y_intermediate -= $game_temp.pivot + 4 if $game_system.mode7
    # if vertical looping
    if $game_system.loop_y
      h = 32 * $game_map.height
      y_intermediate = (y_intermediate + h / 2) % h - h / 2
    end
    # coordinates in a mode7 map
    self.y = (($game_temp.distance_h * y_intermediate *
    $game_temp.cos_angle).to_f / ($game_temp.distance_h - y_intermediate *
    $game_temp.sin_angle) + $game_temp.pivot)
    self.zoom_x = $game_temp.slope_value * y + $game_temp.corrective_value
    self.zoom_y = zoom_x
    self.x = 320 + zoom_x * (x_intermediate - 320)
    # if horizontal looping
    if $game_system.loop_x
      offset = ($game_map.width >= 24 ? 64 * zoom_x : 0)
      l = 32 * $game_map.width * zoom_x
      self.x = (x + offset) % l - offset
    end
    if @character.is_a?(Game_Player)
      # Overworld Sprite Resize
      if $game_system.ov
        self.zoom_x *= $game_system.ov_zoom
        self.zoom_y *= $game_system.ov_zoom
      end
    end    
    self.z = @character.screen_z(@ch)
    # hide the sprite if it is beyond the horizon's line
    self.opacity = (y < $game_temp.height_limit ? 0 : @character.opacity)
    self.y -= 32 * @character.height * zoom_y # height correction
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      animation(animation, true)
      @character.animation_id = 0
    end
  end
end

#============================================================================
# Ã¢ €“   Sprite_V (Vertical Sprites)
#----------------------------------------------------------------------------
#  Sprites corresponding to the vertical elements formed by tiles
#============================================================================

class Sprite_V < Sprite
  attr_accessor :x_map # sprite's x_coordinates (in squares) (Float)
  attr_accessor :y_map # sprite's y_coordinates (in squares) (Float)
  attr_accessor :square_y # sprite's y_coordinates (in squares) (Integer)
  attr_accessor :priority # sprite's priority
  attr_accessor :animated # True if animated
  attr_accessor :list_bitmap # list of sprite's bitmaps (Bitmap)
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    square_y_corrected = square_y
    y_intermediate = 32 * y_map - $game_temp.pivot - $game_map.display_y / 4
    y_intermediate_reference = y_intermediate
    # if vertical looping
    if $game_system.loop_y
      y_intermediate = (y_intermediate + $game_temp.height / 2) %
      $game_temp.height - $game_temp.height / 2
      if y_intermediate_reference < y_intermediate
        square_y_corrected = square_y + $game_map.height
      elsif y_intermediate_reference > y_intermediate
        square_y_corrected = square_y - $game_map.height
      end
    end
    self.y = ($game_temp.distance_h * y_intermediate *
    $game_temp.cos_angle).to_f / ($game_temp.distance_h - y_intermediate *
    $game_temp.sin_angle) + $game_temp.pivot
    if y < $game_temp.height_limit
      # hide the sprite if it is beyond the horizon's line
      self.opacity = 0
      return
    end
    self.opacity = 255
    if $scene.spriteset != nil and $scene.spriteset.tilemap.is_a?(Tilemap_mode7)
      opacity_values = $scene.spriteset.tilemap.opacity_values
      tone_values = $scene.spriteset.tilemap.tone_values
      if opacity_values.has_key?(y)
        self.opacity = opacity_values[y]
        self.tone = tone_values[y]
      end
    end
    self.zoom_x = $game_temp.slope_value * y + $game_temp.corrective_value
    self.zoom_y = zoom_x
    x_intermediate = 32 * x_map - $game_map.display_x / 4
    self.x = 320 + (zoom_x * (x_intermediate - 320))
    # if horizontal looping
    if $game_system.loop_x
      offset = ($game_map.width >= 24 ? 64 * zoom_x : 0)
      l = 32 * $game_map.width * self.zoom_x
      self.x = (self.x + offset) % l - offset
    end
    self.z = (128 * square_y_corrected - $game_map.display_y + 3) / 4 +
    32 + 32 * priority
    return
  end
  #--------------------------------------------------------------------------
  # * Update bitmap for animation
  #     index  : 0..3 : animation's index
  #--------------------------------------------------------------------------
  def update_animated(index)
    self.bitmap = @list_bitmap[index]
  end
end

#============================================================================
# Ã¢ €“   Spriteset_Map
#----------------------------------------------------------------------------
#  Modifications to call a mode7 map
#============================================================================

class Spriteset_Map
  attr_accessor :tilemap # just to be able to access the tilemap
  #--------------------------------------------------------------------------
  # * Initialize Object
  #   Rewritten to call a map with mode7
  #--------------------------------------------------------------------------
  alias initialize_mode7_spriteset_map initialize
  def initialize
    if !$game_system.mode7
      initialize_mode7_spriteset_map
      return
    end
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 200
    @viewport3.z = 5000
    # mode7 map
    @tilemap = Tilemap_mode7.new(@viewport1, self)
    @panorama = Plane.new(@viewport1)
    # sprites drawn at the horizon's level have a negative z, and with a z value
    # of -100000 the panorama is still below
    @panorama.z = ($game_system.mode7 ? -100000 : -1000)
    @fog = Plane.new(@viewport1)
    @fog.z = 3000
    @character_sprites = []
    for i in $game_map.events.keys.sort
      sprite = Sprite_Character.new(@viewport1, $game_map.events[i])
      @character_sprites.push(sprite)
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    @weather = RPG::Weather.new(@viewport1)
    @picture_sprites = []
    for i in 1..50
      @picture_sprites.push(Sprite_Picture.new(@viewport2,
        $game_screen.pictures[i]))
    end
    @timer_sprite = Sprite_Timer.new
    update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    if @tilemap.tileset != nil
      @tilemap.tileset.dispose
      for i in 0..6
        @tilemap.autotiles[i].dispose
      end
    end
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose
    for sprite in @character_sprites
      sprite.dispose
    end
    @weather.dispose
    for sprite in @picture_sprites
      sprite.dispose
    end
    @timer_sprite.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias update_mode7_spriteset_map update
  def update
    if !$game_system.mode7
      update_mode7_spriteset_map
      return
    end
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
    # update animated tiles each 20 frames
    if Graphics.frame_count % 20 == 0 and $game_system.animated
      @tilemap.update_animated
    end
    @tilemap.update
    # if the panorama is fixed
    if $game_system.fixed_panorama
      @panorama.ox = 0
      @panorama.oy = 0
    # if it is a mode7 map
    else
      # to have a fluent panorama scrolling
      @panorama.ox = (128 * $game_map.width * $game_player.map_number_x +
      $game_player.real_x) / 8
      @panorama.oy = - (128 * $game_map.height * $game_player.map_number_y +
      $game_player.real_y) / 32
    end
    @fog.zoom_x = $game_map.fog_zoom / 100.0
    @fog.zoom_y = $game_map.fog_zoom / 100.0
    @fog.opacity = $game_map.fog_opacity
    @fog.blend_type = $game_map.fog_blend_type
    @fog.ox = $game_map.display_x / 4 + $game_map.fog_ox
    @fog.oy = $game_map.display_y / 4 + $game_map.fog_oy
    @fog.tone = $game_map.fog_tone
    for sprite in @character_sprites
      sprite.update
    end
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.ox = $game_map.display_x / 4
    @weather.oy = $game_map.display_y / 4
    @weather.update
    for sprite in @picture_sprites
      sprite.update
    end
    @timer_sprite.update
    @viewport1.tone = $game_screen.tone
    @viewport1.ox = $game_screen.shake
    @viewport3.color = $game_screen.flash_color
    @viewport1.update
    @viewport3.update
  end
end