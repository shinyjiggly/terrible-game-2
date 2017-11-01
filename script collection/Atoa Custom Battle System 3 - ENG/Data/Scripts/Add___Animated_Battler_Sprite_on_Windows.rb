#==============================================================================
# Animated Battler Sprite on Windows
# by Atoa
#==============================================================================
# This script allows to show animated sprites of the battlers on standy pose in
# menu windows.
# to do so, replace the code 'draw_actor_graphic(actor, x, y)' with
# 'draw_animated_actor(actor, x, y, z, dir, fade)'
#
# Where:
#  'actor' = is the instace that have the actor information, just use the same
#    one with the 'draw_actor_graphic', normally it's just '@actor' or 'actor'
#   x = position x of the sprite on the window, you can also use the same value
#    of 'draw_actor_graphic', maybe it will need an small adjust
#   y = position y of the sprite on the window, you can also use the same value
#    of 'draw_actor_graphic', maybe it will need an small adjust
#   z = 'height' of the image on the window, can be omited or 0, in that case
#    the sprite will stay bellow any text, higher values will make the sprite
#    stay above the text on the window
#   dir = battler face direction, can be omited, in that case the actor will face
#     right. You can set one of the following values:
#      2 = actor faces down (only if 'Battle_Style' = 2 or 3)
#      4 = actor faces left (only if 'Battle_Style' is different from 2)
#      6 = actor faces right (only if 'Battle_Style' is different from 2)
#      8 = actor faces up (only if 'Battle_Style' = 2 or 3)
#   fade = fade effect when the battlers are shown, can be omited
#     if true there will be an fade effect when showing the battlers.
# 
# IMPORTANT:
#   If the battler don't appear/don't move it's because the window isn't updating.
#   this happens on the Scene_Status and some custom menus. In that case
#   you will need to add the update *manually*.
#   Go to the "def update" of the Scene and adds an "update" for the class
#   of the window you wish to update.
#
#  Example: Window_Status instance on Scene_Status is "@status_window", so
#   to update the Scene_Status, go to the 'def update' of the Scene_Status and
#   adds an "@status_window.update"
#
#   Since the instance of each window can change, it's not possible to create
#   an automatic method for that.
#
#==============================================================================

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Animated Sprite on Windows'] = true

#==============================================================================
# ** Sprite_Animated_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler on windows
#==============================================================================

class Sprite_Animated_Battler < Sprite_Battler
  #--------------------------------------------------------------------------
  # Inicialização do Objeto
  #     viewport : viewport
  #     battler  : battler (Game_Battler)
  #     x        : draw spot x-coordinate
  #     y        : draw spot y-coordinate
  #     dir      : battler direction
  #     fade     : fade effect
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil, x = 0, y = 0, dir = 6, fade = false)
    super(viewport, battler)
    @fast_appear = false
    self.opacity = 0
    @x = x + 32
    @y = y + 32
    @dir = dir
    unless fade
      fast_appear
      @battler_visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    battler_position_setup
    super
  end
  #--------------------------------------------------------------------------
  # * Set initial position
  #--------------------------------------------------------------------------
  def battler_position_setup
    @battler.base_x = @battler.original_x = @battler.actual_x = @battler.target_x = @x
    @battler.initial_x = @battler.hit_x = @battler.damage_x = @x
    @battler.base_y = @battler.original_y = @battler.actual_y = @battler.target_y = @y
    @battler.initial_y = @battler.hit_y = @battler.damage_y = @y
  end
  #--------------------------------------------------------------------------
  # * Get idle pose ID
  #--------------------------------------------------------------------------
  def set_idle_pose
    default_battler_direction
    if @battler.dead? and check_include(@battler, 'NOCOLLAPSE')
      return set_pose_id('Dead') 
    end
    for i in @battler.states
      return States_Pose[i] unless States_Pose[i].nil? 
    end
    if @battler.in_danger? and not check_include(@battler, 'NODANGER')
      return set_pose_id('Danger') 
    end
    return set_pose_id('Idle')
  end
  #--------------------------------------------------------------------------
  # * Set default battler direction
  #--------------------------------------------------------------------------
  def default_battler_direction
    @battler.direction = @dir
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x      : window x-coordinate
  #     y      : window y-coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  alias initialize_draw_animated_battlers initialize
  def initialize(x, y, width, height)
    initialize_draw_animated_battlers(x, y, width, height)
    @animate_battlers = []
  end
  #--------------------------------------------------------------------------
  # Desenhar Gráfico Animado
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     z     : gaphic Z axis
  #     dir   : battler direction
  #     fade  : fade effect
  #--------------------------------------------------------------------------
  def draw_animated_actor(actor, x, y, z = 0, dir = 6, fade = false)
    if @animate_battlers[actor.id].nil? or actor.character_name != @animated_character_name
      @animate_battlers[actor.id].dispose if @animate_battlers[actor.id] != nil
      viewport = Viewport.new(0, 0, 640, 480)
      viewport.z = self.z + z
      @animate_battlers[actor.id] = Sprite_Animated_Battler.new(viewport, actor, x , y, dir, fade)
      @animate_battlers[actor.id].update
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_draw_animated_battlers update
  def update
    update_draw_animated_battlers
    for i in 0...@animate_battlers.size
      next if @animate_battlers[i].nil?
      @animate_battlers[i].update
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_draw_animated_battlers dispose
  def dispose
    dispose_draw_animated_battlers
    for i in 0...@animate_battlers.size
      next if @animate_battlers[i].nil?
      @animate_battlers[i].dispose
    end
  end
end