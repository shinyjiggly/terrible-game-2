#==============================================================================
# Battle Camera
# by Atoa
#==============================================================================
# This script allow you to add an camera movement and zoom system
# during battle
# 
# Don't work with the Add-On 'Chrono Trigger Battle'
#==============================================================================

module Atoa
  
  # Do not remove these lines
  Zoom_Actions = {}
  Zoom_Skills = {}
  Zoom_Items = {}
  Zoom_Weapons = {}
  # Do not remove these lines
  
  # Add zoom effect to target arrows?
  Arrow_Zoom = true
  
  # Add zoom effect to damage exhibition?
  Damage_Zoom = false
  
  # Zoom transition speed, the lower, the faster
  Zoom_Speed = 10.0
  
  #=============================================================================
  # Basic Camera Movement Settings
  #=============================================================================
  # Here you can set the default movement and zoom settings
  # These settings are applied to *all* actions of an set type, unless it
  # has it's own settings
  # 
  # Zoom_Actions['Condition'] = ['Type', intensity, adjust x, adjust y]
  #
  # 'Condition' = Condition that the zoom will be applied
  #    Must be one of the following values:
  #    'reset' = Default Setting, uConfiguração padrão, usado quando nenhuma ação está sendo feita.
  #    'active_battler' = used during the actor action selection
  #    'select_ally' = used during the selection of single target actor
  #    'select_enemy' = used during the selection of single target enemy
  #    'select_self' = used during the selection of user
  #    'select_all_allies' = used during the selection of all allies
  #    'select_all_enemies' = used during the selection of all enemies
  #    'select_all_battlers' = used during the selection of all battlers
  #    'action_active' = used during the battler action start
  #    'action_ally' = used during actions wich the target is a single ally
  #    'action_enemy' = used during actions wich the target is a single enemy
  #    'action_self' = used during action wich the target is the user
  #    'action_all_allies' = used during action wich the targets are all allies
  #    'action_all_enemies' = used during action wich the targets are all enemies
  #    'action_all_battlers' = used during action wich the targets are all battlers
  #    'intro_lock_on' = used during the battle intro, centering the camera on an battler
  #    'victory_lock_on' = used during the battle end, centering the camera on an battler
  #
  # 'Type' = type of zoom applied
  #    Must be one of the following value:
  #    'lock_on_screen' = center the move on the screen
  #    'lock_on_group' = center the move on the group (allies on enemies) depending
  #       on the action
  #    'lock_on_battler' = center the move on the battler, using as reference the
  #       "base" of the battler, don't following him during jumps or lauchs.
  #    'lock_on_move' = center the move on the battler, following all movements.
  #
  # intensity = zoom intensity. Numeric value, can be decilams. Defualt = 1.0 
  #    if the value is 1.0, the camera returns to the original size
  #    values lower than 1.0 reduces the sprites size, causing an zoom out.
  #    values higher than 1.0 increases the sprites size, causing an zoom in.
  # 
  # adjust x = camera movement X position adjust
  # adjust y = camera movement Y position adjust
  #
  # IMPORTANTE: Don't remove any of these settings.
  # If you don't want that an zoom effect to be used, change the valoe of the
  # setting to: Zoom_Actions['type'] = nil
  
  Zoom_Actions['reset'] = ['lock_on_screen', 1.0, 0, 0]
  Zoom_Actions['active_battler'] = ['lock_on_battler', 1.2, 0, 0]
  Zoom_Actions['select_ally'] = ['lock_on_battler', 1.2, 0, 0]
  Zoom_Actions['select_enemy'] = ['lock_on_battler', 0.9, 0, 0]
  Zoom_Actions['select_self'] = ['lock_on_battler', 1.5, 0, 0]
  Zoom_Actions['select_all_allies'] = ['lock_on_group', 0.8, 0, 0]
  Zoom_Actions['select_all_enemies'] = ['lock_on_group', 0.8, 0, 0]
  Zoom_Actions['select_all_battlers'] = ['lock_on_screen', 0.7, 0, 0]
  Zoom_Actions['action_active'] = ['lock_on_battler', 1.1, 0, 0]
  Zoom_Actions['action_ally'] = ['lock_on_battler', 1.1, 0, 0]
  Zoom_Actions['action_enemy'] = ['lock_on_battler', 1.1, 0, 0]
  Zoom_Actions['action_self'] = ['lock_on_battler', 1.5, 0, 0]
  Zoom_Actions['action_all_allies'] = ['lock_on_group', 0.8, 0, 0]
  Zoom_Actions['action_all_enemies'] = ['lock_on_group', 0.8, 0, 0]
  Zoom_Actions['action_all_battlers'] = ['lock_on_screen', 0.7, 0, 0]
  Zoom_Actions['intro_lock_on'] = ['lock_on_battler', 2.0, 0, 0]
  Zoom_Actions['victory_lock_on'] = ['lock_on_battler', 2.0, 0, 0]
  
  # OBS.: the options 'intro_lock_on' and 'victory_lock_on', if used together with
  #   the "Battle Cry" functions, will make the camera center on the battler
  #   selected to execute the battle cry, otherwise the battler will be random.
  #   You can use 'Script Calls' to specify one battler to be the target or
  #   cancel this effect for the next battle.
  #
  #   Lock the camera on the battle intro on the actor with ID = X
  #   $game_temp.lock_actor_intro = X
  #
  #   Lock the camera on the battle end on the actor with ID = X
  #   $game_temp.lock_actor_victory = X
  #
  #   Lock the camera on the battle intro on the actor with INDEX = X
  #   $game_temp.lock_enemy_intro = X
  #
  #   Travar movimento de câmera  de vitória no inimigo de INDEX igual a X
  #   $game_temp.lock_enemy_victory = X
  #
  #  OBS.: for enemies, the value are NOT the enemy ID, it's the INDEX.
  #   the value according to his position on the Enemy Troop
  #
  #  Cancel the battle intro camera movement
  #   $game_temp.no_intro_lock = true
  #
  #  Cancel the battle end camera movement
  #   $game_temp.no_victory_lock = true

  #=============================================================================

  #=============================================================================
  # Specific Camera Movement Settings
  #=============================================================================
  # Here you can set specific camera movement for each action.
  # The values here igonres the settings of the basic settings.
  # You only need to add the values that will be changed, for the values not added
  # the default values will be used
  #
  # Zoom_Skills[ID da Skill] = { 'Condition' => ['Type', intensity, adjust x, adjust y] }
  # Zoom_Items[ID da Skill] = { 'Condition' => ['Type', intensity, adjust x, adjust y] }
  # Zoom_Weapons[ID da Skill] = { 'Condition' => ['Type', intensity, adjust x, adjust y] }
  
  
  Zoom_Skills[57] = {'action_active'=> ['lock_on_battler', 2.0, 0, 0],
                      'action_enemy' => ['lock_on_battler', 2.0, 0, 0]}
  Zoom_Skills[126] = {'action_active'=> ['lock_on_battler', 2.0, 0, -48],
                       'action_enemy' => ['lock_on_move', 2.0, 0, -48]}
  Zoom_Skills[127] = {'action_active'=> ['lock_on_battler', 2.0, 0, -48],
                       'action_enemy' => ['lock_on_move', 2.0, 0, -48]}
  Zoom_Skills[128] = {'action_active'=> ['lock_on_battler', 2.0, 0, -48],
                       'action_enemy' => ['lock_on_move', 2.0, 0, -48]}
                       
  Zoom_Weapons[17] = {'action_active'=> nil}
  Zoom_Weapons[18] = {'action_active'=> nil}
  Zoom_Weapons[19] = {'action_active'=> nil}
  Zoom_Weapons[20] = {'action_active'=> nil}
  Zoom_Weapons[21] = {'action_active'=> nil}
  Zoom_Weapons[22] = {'action_active'=> nil}
  Zoom_Weapons[23] = {'action_active'=> nil}
                       
  #=============================================================================

  #=============================================================================
  # Settings for Camera Movement Priority
  #=============================================================================
  # To avoid tha certain camera movements cancel other movements that
  # you might consider more important, this settings was added.
  # Effects with values higher or equal to the current effect overlaps it.
  # If the value is lower, the current movement effect isn't applied
  Zoom_Priority = {
    'reset' => 8,
    'active_battler' => 4,
    'select_ally' => 5,
    'select_enemy' => 5,
    'select_self' => 5,
    'select_all_allies' => 6,
    'select_all_enemies' => 6,
    'select_all_battlers' => 6,
    'action_active' => 1,
    'action_ally' => 2,
    'action_enemy' => 2,
    'action_self' => 2,
    'action_all_allies' => 3,
    'action_all_enemies' => 3,
    'action_all_battlers' => 3,
    'intro_lock_on' => 7,
    'victory_lock_on' => 7
  }

end
  
#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Battle Camera'] = true

#==============================================================================
# ** RPG::Sprite
#------------------------------------------------------------------------------
# Class that manages Sprites exhibition
#==============================================================================

class RPG::Sprite < ::Sprite
  #--------------------------------------------------------------------------
  # * Set animation frame info
  #     sprite      : animation sprite
  #     cell_data   : cell info
  #     index       : index
  #     anim_mirror : invert animation
  #--------------------------------------------------------------------------
  def set_sprite_cell_data(sprite, cell_data, index, anim_mirror = false)
    sprite.x += (anim_mirror ? - cell_data[index, 1] : cell_data[index, 1])  * $game_temp.temp_zoom_value
    sprite.y += cell_data[index, 2] * $game_temp.temp_zoom_value
    sprite.zoom_x = (cell_data[index, 3] / 100.0) * $game_temp.temp_zoom_value
    sprite.zoom_y = (cell_data[index, 3] / 100.0) * $game_temp.temp_zoom_value
    sprite.angle = cell_data[index, 4]
    sprite.mirror = (cell_data[index, 5] == 1)
    sprite.opacity = cell_data[index, 6] * self.opacity / 255.0
    sprite.blend_type = cell_data[index, 7]
  end  
end

#==============================================================================
# ** Object
#------------------------------------------------------------------------------
# Superclass of all other classes.
#==============================================================================

class Object
  #--------------------------------------------------------------------------
  # * Adjust position X according to the Zoom
  #     value : adjust value
  #--------------------------------------------------------------------------
  def adjust_x_to_zoom(value)
    return (value * $game_temp.temp_zoom_value) + $game_temp.temp_zoom_adj_x - ($game_temp.center_adj_x / 2)
  end
  #-------------------Y according to the Zoom
  #     value : adjust value
  #--------------------------------------------------------------------------
  def adjust_y_to_zoom(value)
    return (value * $game_temp.temp_zoom_value) + $game_temp.temp_zoom_adj_y - ($game_temp.center_adj_y / 2)
  end
end

#==============================================================================
# ** Sprite_Damage
#------------------------------------------------------------------------------
# Classe que gerencia a exibição de dano
#==============================================================================

class Sprite_Damage < Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     sprite   : damage sprite
  #     init_x   : initial X postion
  #     init_y   : initial Y position
  #     duration : damage duration
  #     mirror   : invert movement
  #     index    : index
  #--------------------------------------------------------------------------
  alias initialize_zoom initialize
  def initialize(sprite, init_x, init_y, duration, mirror, index)
    initialize_zoom(sprite, init_x, init_y, duration, mirror, index)
    adj_x = Damage_Zoom ? sprite.x - index *  Dmg_Space : sprite.x
    @sprite_x = (adj_x - $game_temp.temp_zoom_adj_x + ($game_temp.center_adj_x / 2)) / $game_temp.temp_zoom_value
    @sprite_y = (sprite.y - $game_temp.temp_zoom_adj_y + ($game_temp.center_adj_y / 2)) / $game_temp.temp_zoom_value
    self.zoom_x = $game_temp.temp_zoom_value if Damage_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if Damage_Zoom
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_zoom update
  def update
    update_zoom
    unless self.nil? or self.disposed?
      self.zoom_x = $game_temp.temp_zoom_value if Damage_Zoom
      self.zoom_y = $game_temp.temp_zoom_value if Damage_Zoom
      adj_x = Damage_Zoom ? @sprite_x + @index * Dmg_Space : @sprite_x
      self.x = adjust_x_to_zoom(adj_x)
      self.y = adjust_y_to_zoom(@sprite_y)
    end
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
  attr_accessor :zoom_value
  attr_accessor :zoom_adj_x
  attr_accessor :zoom_adj_y
  attr_accessor :temp_zoom_value
  attr_accessor :temp_zoom_adj_x
  attr_accessor :temp_zoom_adj_y
  attr_accessor :center_adj_x
  attr_accessor :center_adj_y
  attr_accessor :zoom_plus_x
  attr_accessor :zoom_plus_y
  attr_accessor :zoom_plus_z
  attr_accessor :lock_actor_intro
  attr_accessor :lock_enemy_intro
  attr_accessor :lock_actor_victory
  attr_accessor :lock_enemy_victory
  attr_accessor :no_intro_lock
  attr_accessor :no_victory_lock
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_zoom initialize
  def initialize
    @zoom_value = 1.0
    @zoom_adj_x = 0
    @zoom_adj_y = 0
    @temp_zoom_value = 1.0
    @temp_zoom_adj_x = 0
    @temp_zoom_adj_y = 0
    @center_adj_x = 0
    @center_adj_y = 0
    @zoom_plus_x = 0
    @zoom_plus_y = 0
    @zoom_plus_z = 0
    initialize_zoom
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :zoom_value
  attr_accessor :zoom_adj_x
  attr_accessor :zoom_adj_y
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_zoom initialize
  def initialize
    @zoom_value = $game_temp.zoom_value
    @zoom_adj_x = $game_temp.zoom_adj_x
    @zoom_adj_y = $game_temp.zoom_adj_y
    $game_temp.zoom_value = 1.0
    $game_temp.zoom_adj_x = 0
    $game_temp.zoom_adj_y = 0
    initialize_zoom
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_zoom update
  def update
    zoom_update
    update_zoom
  end
  #--------------------------------------------------------------------------
  # * Update Zoom
  #--------------------------------------------------------------------------
  def zoom_update
    update_zoom_value
    @battleback_sprite.zoom_x = @zoom_value
    @battleback_sprite.zoom_y = @zoom_value
    @battleback_sprite.x = @zoom_adj_x - ($game_temp.center_adj_x / 2)
    @battleback_sprite.y = @zoom_adj_y - ($game_temp.center_adj_y / 2)
    if @panorama != nil
      @panorama.zoom_x = @zoom_value
      @panorama.zoom_y = @zoom_value
      @panorama.x = @zoom_adj_x - ($game_temp.center_adj_x / 2)
      @panorama.y = @zoom_adj_y - ($game_temp.center_adj_y / 2)
    end
    if @fog != nil
      @fog.zoom_x = $game_map.fog_zoom *  @zoom_value / 100.0
      @fog.zoom_y = $game_map.fog_zoom *  @zoom_value / 100.0
      @fog.x = @zoom_adj_x - ($game_temp.center_adj_x / 2)
      @fog.y = @zoom_adj_y - ($game_temp.center_adj_y / 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Update zoom values
  #--------------------------------------------------------------------------
  def update_zoom_value
    if @zoom_value < $game_temp.zoom_value
      @zoom_value = [@zoom_value + $game_temp.zoom_plus_z, $game_temp.zoom_value].min
    elsif @zoom_value > $game_temp.zoom_value
      @zoom_value = [@zoom_value - $game_temp.zoom_plus_z, $game_temp.zoom_value].max
    end
    if @zoom_adj_x < $game_temp.zoom_adj_x
      @zoom_adj_x = [@zoom_adj_x + $game_temp.zoom_plus_x, $game_temp.zoom_adj_x].min
    elsif @zoom_adj_x > $game_temp.zoom_adj_x
      @zoom_adj_x = [@zoom_adj_x - $game_temp.zoom_plus_x, $game_temp.zoom_adj_x].max
    end
    if @zoom_adj_y < $game_temp.zoom_adj_y
      @zoom_adj_y = [@zoom_adj_y + $game_temp.zoom_plus_y, $game_temp.zoom_adj_y].min
    elsif @zoom_adj_y > $game_temp.zoom_adj_y
      @zoom_adj_y = [@zoom_adj_y - $game_temp.zoom_plus_y, $game_temp.zoom_adj_y].max
    end
    $game_temp.temp_zoom_value = @zoom_value
    $game_temp.temp_zoom_adj_x = @zoom_adj_x
    $game_temp.temp_zoom_adj_y = @zoom_adj_y
    $game_temp.center_adj_x = 640 * (@zoom_value - 1.0)
    $game_temp.center_adj_y = 560 * (@zoom_value - 1.0)
  end
  #--------------------------------------------------------------------------
  # * Battleback update
  #--------------------------------------------------------------------------
  alias update_battleback_zoom update_battleback
  def update_battleback
    update_battleback_zoom
    if @battleback_sprite.bitmap != nil
      @battleback_sprite.ox = (@battleback_width  - 640) / 2
      @battleback_sprite.oy = (@battleback_height - 480) / 2
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
  # * Battler position update
  #--------------------------------------------------------------------------
  alias update_position_zoom update_position
  def update_position
    self.zoom_x = $game_temp.temp_zoom_value
    self.zoom_y = $game_temp.temp_zoom_value
    update_position_zoom
    if @shadow != nil
      @shadow.x = adjust_x_to_zoom(@battler.actual_x)
      @shadow.y = adjust_y_to_zoom(@battler.actual_y)
      @shadow.zoom_x = (@frame_width * 0.5 / @shadow.bitmap.width) * $game_temp.temp_zoom_value
      @shadow.zoom_y = $game_temp.temp_zoom_value
    end
  end
  #--------------------------------------------------------------------------
  # * Get battler real X postion
  #--------------------------------------------------------------------------
  def actual_x_position
    return adjust_x_to_zoom(@actual_x + set_adjust[0])
  end
  #--------------------------------------------------------------------------
  # * Get battler real Y postion
  #--------------------------------------------------------------------------
  def actual_y_position
    return adjust_y_to_zoom(@actual_y + set_adjust[1])
  end
end

#==============================================================================
# ** Throw_Sprite
#------------------------------------------------------------------------------
#  This sprite is used to display throw animations.
#==============================================================================

class Throw_Sprite < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Current position update
  #--------------------------------------------------------------------------
  def update_current_position
    self.x = adjust_x_to_zoom(@actual_x)
    actual_y = adjust_y_to_zoom(@actual_y)
    arc_ajdust = (@arc_ajdust * $game_temp.temp_zoom_value).to_i
    if @boomerang
      self.y = [actual_y + arc_ajdust, actual_y].max
    else
      self.y = [actual_y - arc_ajdust, actual_y].min
    end
    self.z = self.y + 100
    self.zoom_x = $game_temp.temp_zoom_value
    self.zoom_y = $game_temp.temp_zoom_value
  end
end

#==============================================================================
# ** Arrow_Enemy
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose enemies. This class inherits from the 
#  Arrow_Base class.
#==============================================================================

class Arrow_Enemy < Arrow_Base
  #--------------------------------------------------------------------------
  # * Update cursor position
  #--------------------------------------------------------------------------
  def update_arrows
    self.x = adjust_x_to_zoom(self.enemy.actual_x)
    self.y = adjust_y_to_zoom(self.enemy.actual_y)
    self.zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
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
  # * Update cursor position
  #--------------------------------------------------------------------------
  def update_arrows
    self.x = adjust_x_to_zoom(self.actor.actual_x)
    self.y = adjust_y_to_zoom(self.actor.actual_y)
    self.zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
  end 
end

#==============================================================================
# ** Arrow_Self
#------------------------------------------------------------------------------
# This arrow cursor is used to choose the user.
#==============================================================================

class Arrow_Self < Arrow_Base
  #--------------------------------------------------------------------------
  # * Update cursor position
  #--------------------------------------------------------------------------
  def update_arrows
    self.x = adjust_x_to_zoom(self.actor.actual_x)
    self.y = adjust_y_to_zoom(self.actor.actual_y)
    self.zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    self.zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
  end 
end

#==============================================================================
# ** Arrow_Actor_All
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose all actors.
#==============================================================================

class Arrow_Actor_All < Arrow_Base
  #--------------------------------------------------------------------------
  # * Update cursor position
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows(index)
    @arrows[index].x = adjust_x_to_zoom(@arrows[index].actor.actual_x)
    @arrows[index].y = adjust_y_to_zoom(@arrows[index].actor.actual_y)
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
  end
end

#==============================================================================
# ** Arrow_Enemy_All
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose all enemies.
#==============================================================================

class Arrow_Enemy_All < Arrow_Base
  #--------------------------------------------------------------------------
  # * Update cursor position
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows(index)
    @arrows[index].x = adjust_x_to_zoom(@arrows[index].enemy.actual_x)
    @arrows[index].y = adjust_y_to_zoom(@arrows[index].enemy.actual_y)
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
  end
end

#==============================================================================
# ** Arrow_Battler_All
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose all battlers.
#==============================================================================

class Arrow_Battler_All < Arrow_Base
  #--------------------------------------------------------------------------
  # * Update cursor position for actors
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows_actor(index)
    @arrows[index].x = adjust_x_to_zoom(@arrows[index].actor.actual_x)
    @arrows[index].y = adjust_y_to_zoom(@arrows[index].actor.actual_y)
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
    @arrows[index].z = 3000
  end
  #--------------------------------------------------------------------------
  # * Update cursor position for enemies
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows_enemy(index)
    @arrows[index].x = adjust_x_to_zoom(@arrows[index].enemy.actual_x)
    @arrows[index].y = adjust_y_to_zoom(@arrows[index].enemy.actual_y)
    @arrows[index].zoom_x = $game_temp.temp_zoom_value if Arrow_Zoom
    @arrows[index].zoom_y = $game_temp.temp_zoom_value if Arrow_Zoom
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :sprite_x
  attr_accessor :sprite_y
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_zoom initialize
  def initialize
    initialize_zoom
    @sprite_x = 0
    @sprite_y = 0
  end
  #--------------------------------------------------------------------------
  # * Set target center action
  #--------------------------------------------------------------------------
  def action_target_center
    @target_x = $scene.spriteset.battleback_width / 2
    @target_y = $scene.spriteset.battleback_height / 2
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_zoom terminate
  def terminate
    terminate_zoom
    $game_temp.zoom_value = 1.0
    $game_temp.zoom_adj_x = 0
    $game_temp.zoom_adj_y = 0
  end
  #--------------------------------------------------------------------------
  # * Set intro battlecry
  #--------------------------------------------------------------------------
  alias set_intro_battlecry_zoom set_intro_battlecry
  def set_intro_battlecry
    @zoom_postion_adj = [0, 0]
    set_zoom_postion('reset')
    set_intro_battlecry_zoom
    if Zoom_Actions['intro_lock_on'] != nil and not $game_temp.no_intro_lock
      actors = []
      battler_zoom = nil
      for i in 0...$game_party.actors.size
        actors << $game_party.actors[i] unless $game_party.actors[i].restriction == 4
      end
      actor = actors[rand(actors.size)]
      battler_zoom = actor if actor != nil
      if @intro_battlercry_battler != nil
        battler_zoom = @intro_battlercry_battler
      end
      if $game_temp.lock_enemy_intro != nil
        enemy = $game_troop.enemies[$game_temp.lock_enemy_intro]
        battler_zoom = enemy if enemy != nil and enemy.exist?
      end
      if $game_temp.lock_actor_intro != nil
        battler = $game_actors[$game_temp.lock_actor_intro]
        battler_zoom = battler if battler != nil and $game_party.actors.include?(battler) and not battler.restriction == 4
      end
      set_zoom_postion('intro_lock_on', battler_zoom, battler_zoom) if battler_zoom != nil
    end
    update_graphics
    @spriteset.zoom_value = $game_temp.zoom_value
    @spriteset.zoom_adj_x = $game_temp.zoom_adj_x
    @spriteset.zoom_adj_y = $game_temp.zoom_adj_y
    update_graphics
  end
  #--------------------------------------------------------------------------
  # * Set allies victory battlecry
  #--------------------------------------------------------------------------
  alias set_victory_battlecry_zoom set_victory_battlecry
  def set_victory_battlecry
    set_zoom_postion('reset')
    set_victory_battlecry_zoom
    if Zoom_Actions['victory_lock_on'] != nil and not $game_temp.no_victory_lock
      battler_zoom = nil
      battler_zoom = @last_active_actor if @last_active_actor != nil
      battler_zoom = @victory_battlercry_battler if @victory_battlercry_battler != nil
      if $game_temp.lock_actor_victory != nil
        battler = $game_actors[$game_temp.lock_actor_victory]
        battler_zoom = battler if battler != nil and $game_party.actors.include?(battler) and not battler.restriction == 4
      end
      set_zoom_postion('victory_lock_on', battler_zoom, battler_zoom) if battler_zoom != nil
    end
  end
  #--------------------------------------------------------------------------
  # * Set Victory battlecry for enemies
  #--------------------------------------------------------------------------
  alias set_enemy_victory_battlecry_zoom set_enemy_victory_battlecry
  def set_enemy_victory_battlecry
    set_zoom_postion('reset')
    set_enemy_victory_battlecry_zoom
    if Zoom_Actions['victory_lock_on'] != nil and not $game_temp.no_victory_lock
      battler_zoom = nil
      battler_zoom = @last_active_enemy if @last_active_enemy != nil
      battler_zoom = @victory_battlercry_enemy if @victory_battlercry_enemy != nil
      if $game_temp.lock_enemy_victory != nil
        battler = $game_troop.enemies[$game_temp.lock_enemy_victory]
        battler_zoom = battler if battler != nil and battler.exist? and
            $game_troop.enemies.include?(battler) and not battler.restriction == 4
      end
      set_zoom_postion('victory_lock_on', battler_zoom, battler_zoom) if battler_zoom != nil
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose 3:abort)
  #--------------------------------------------------------------------------
  alias battle_end_zoom battle_end
  def battle_end(result)
    battle_end_zoom(result)
    $game_temp.lock_actor_intro = nil
    $game_temp.lock_enemy_intro = nil
    $game_temp.lock_actor_victory = nil
    $game_temp.lock_enemy_victory = nil
    $game_temp.no_intro_lock = nil
    $game_temp.no_victory_lock = nil
  end
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  alias start_phase2_zoom start_phase2
  def start_phase2
    start_phase2_zoom
    set_zoom_postion('reset') unless $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB'] 
  end
  #--------------------------------------------------------------------------
  # * Start Main Phase
  #--------------------------------------------------------------------------
  alias start_phase4_zoom start_phase4
  def start_phase4
    start_phase4_zoom
    set_zoom_postion('reset')
  end  
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  alias update_graphics_zoom update_graphics
  def update_graphics
    update_graphics_zoom
    update_zoom
  end
  #--------------------------------------------------------------------------
  # * Update ATB
  #--------------------------------------------------------------------------
  alias atb_update_zoom atb_update if $atoa_script['Atoa ATB']
  def atb_update
    if @active_battler.nil? and @input_battler.nil? and @active_battlers.empty? and
       @input_battlers.empty?
      set_zoom_postion('reset')
    end
    atb_update_zoom
  end
  #--------------------------------------------------------------------------
  # * Update CTB
  #--------------------------------------------------------------------------
  alias ctb_update_zoom ctb_update if $atoa_script['Atoa CTB']
  def ctb_update
    if @active_battler.nil? and @input_battler.nil? and @active_battlers.empty? and
       @input_battlers.empty?
      set_zoom_postion('reset')
    end
    ctb_update_zoom
  end
  #--------------------------------------------------------------------------
  # * Update zoom
  #--------------------------------------------------------------------------
  def update_zoom
    plus_x = @zoom_postion_adj[0]
    plus_y = @zoom_postion_adj[1]
    zoom_spd = @zoom_postion_adj[4].nil? ? Zoom_Speed.to_f : @zoom_postion_adj[4].to_f
    case @zoom_type
    when 'lock_on_battler'
      if @locked_battler != nil
       $game_temp.zoom_value = @zoom_effect
        $game_temp.zoom_adj_x = (320 * $game_temp.zoom_value) - ((@locked_battler.actual_x + plus_x) * $game_temp.zoom_value)
        $game_temp.zoom_adj_y = (240 * $game_temp.zoom_value) - ((@locked_battler.actual_y + plus_y) * $game_temp.zoom_value)
      end
    when 'lock_on_move'
      if @locked_battler != nil
        sprite = @spriteset.battler(@locked_battler)
        $game_temp.zoom_value = @zoom_effect
        $game_temp.zoom_adj_x = (320 * $game_temp.zoom_value) - ((sprite.x + plus_x) * $game_temp.zoom_value)
        $game_temp.zoom_adj_y = (240 * $game_temp.zoom_value) - ((sprite.y + plus_y) * $game_temp.zoom_value)
      end
    when 'lock_on_group'
      party_x = 0
      party_y = 0
      @locked_party = @locked_party.nil? ? (@locked_battler.actor? ? $game_party.actors.dup : $game_troop.enemies.dup) : @locked_party
      for member in @locked_party
        party_x += member.base_x
        party_y += member.base_y
      end
      party_x /= [@locked_party.size, 1].max
      party_y /= [@locked_party.size, 1].max
      $game_temp.zoom_value = @zoom_effect
      $game_temp.zoom_adj_x = (320 * $game_temp.zoom_value) - ((party_x + plus_x) * $game_temp.zoom_value)
      $game_temp.zoom_adj_y = (240 * $game_temp.zoom_value) - ((party_y + plus_y) * $game_temp.zoom_value)
    when 'lock_on_screen'
      $game_temp.zoom_value = @zoom_effect
      $game_temp.zoom_adj_x = plus_x
      $game_temp.zoom_adj_y = plus_y
    end
    max_zoom_x = 640.0 / @spriteset.battleback_width
    max_zoom_y = 480.0 / @spriteset.battleback_height
    $game_temp.zoom_value = [$game_temp.zoom_value, (max_zoom_x > max_zoom_y ? max_zoom_x : max_zoom_y)].max
    max_x = [(@spriteset.battleback_width.to_f * $game_temp.zoom_value) - 640, 0].max
    max_y = [(@spriteset.battleback_height.to_f * $game_temp.zoom_value) - 480, 0].max
    $game_temp.zoom_adj_x = [[$game_temp.zoom_adj_x, - max_x / 2].max, max_x / 2].min
    $game_temp.zoom_adj_y = [[$game_temp.zoom_adj_y, - max_y / 2].max, max_y / 2].min
    if @old_type != @zoom_type or @old_zoom_adj_x != $game_temp.zoom_adj_x or @old_zoom_adj_y != $game_temp.zoom_adj_y
      @old_type = @zoom_type
      @old_zoom_adj_x = $game_temp.zoom_adj_x
      @old_zoom_adj_y = $game_temp.zoom_adj_y
      @min_move = @zoom_type == 'lock_on_battler' ? @min_move + 2.0 : 1.0
      @zoom_adj_z = [(($game_temp.temp_zoom_value - $game_temp.zoom_value) / zoom_spd).abs, 0.01].max
      @zoom_adj_x = [(($game_temp.temp_zoom_adj_x - $game_temp.zoom_adj_x) / zoom_spd).abs, @min_move].max
      @zoom_adj_y = [(($game_temp.temp_zoom_adj_y - $game_temp.zoom_adj_y) / zoom_spd).abs, @min_move].max
    end
    $game_temp.zoom_plus_z = @zoom_adj_z
    $game_temp.zoom_plus_x = @zoom_adj_x
    $game_temp.zoom_plus_y = @zoom_adj_y
    update_sprite_position
  end
  #--------------------------------------------------------------------------
  # * Update sprites position
  #--------------------------------------------------------------------------
  def update_sprite_position
    for battler in $game_party.actors + $game_troop.enemies
      sprite = @spriteset.battler(battler)
      next if sprite.nil? or sprite.disposed?
      battler.sprite_x = sprite.x
      battler.sprite_y = sprite.y
    end
  end
  #--------------------------------------------------------------------------
  # * Set zoom postion
  #     type   : zoom type
  #     target : target position
  #     active : active battler
  #--------------------------------------------------------------------------
  def set_zoom_postion(type, target = nil, active = nil)
    if active != nil and active.now_action != nil
      case active.now_action
      when RPG::Weapon
        if Zoom_Weapons[now_id(active)] != nil and 
           Zoom_Weapons[now_id(active)].keys.include?(type)
          zoom_settings(Zoom_Weapons[now_id(active)][type], target)
          return
        end
      when RPG::Skill
        if Zoom_Skills[now_id(active)] != nil and 
           Zoom_Skills[now_id(active)].keys.include?(type)
          zoom_settings(Zoom_Skills[now_id(active)][type], target)
          return
        end
      when RPG::Item
        if Zoom_Items[now_id(active)] != nil and 
           Zoom_Items[now_id(active)].keys.include?(type)
          zoom_settings(Zoom_Items[now_id(active)][type], target)
          return
        end
      end
    end
    zoom_settings(Zoom_Actions[type], target)
  end
  #--------------------------------------------------------------------------
  # * Set zoom settings
  #     type   : zoom type
  #     target : target position
  #--------------------------------------------------------------------------
  def zoom_settings(type, target)
    return if type.nil? 
    return if Zoom_Priority[@zoom_type] != nil and Zoom_Priority[@zoom_type] > Zoom_Priority[type]
    @zoom_type = type[0]
    @zoom_effect = type[1]
    @zoom_postion_adj = [type[2].nil? ? 0.0 : type[2], type[3].nil? ? 0.0 : type[3]]
    if target.nil?
      @locked_battler = nil
      @locked_party = nil
      @min_move = 1.0
      return
    elsif target.is_a?(Game_Battler)
      @locked_battler = target
      @locked_party = nil
      @min_move = (type == 'lock_on_battler' or type == 'lock_on_battler') ? 2.0 : 1.0
      return
    elsif target.is_a?(Array)
      @locked_battler = nil
      @locked_party = target
      @min_move = 1.0
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_zoom phase3_setup_command_window
  def phase3_setup_command_window
    phase3_setup_command_window_zoom
    set_zoom_postion('active_battler', @active_battler, @active_battler)
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : actor selection)
  #--------------------------------------------------------------------------
  alias update_phase3_actor_select_zoom update_phase3_actor_select
  def update_phase3_actor_select
    set_zoom_postion('select_ally', $game_party.actors[@actor_arrow.index], @active_battler)
    set_zoom_postion('active_battler', @active_battler) if Input.trigger?(Input::B)
    update_phase3_actor_select_zoom
  end
  #--------------------------------------------------------------------------
  # * Frame Updat (actor command phase : enemy selection)
  #--------------------------------------------------------------------------
  alias update_phase3_enemy_select_zoom update_phase3_enemy_select
  def update_phase3_enemy_select
    set_zoom_postion('select_enemy', $game_troop.enemies[@enemy_arrow.index], @active_battler)
    set_zoom_postion('active_battler', @active_battler) if Input.trigger?(Input::B)
    update_phase3_enemy_select_zoom
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all enemies selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_all_enemies_zoom update_phase3_select_all_enemies
  def update_phase3_select_all_enemies
    set_zoom_postion('select_all_enemies', $game_troop.enemies, @active_battler)
    set_zoom_postion('active_battler', @active_battler) if Input.trigger?(Input::B)
    update_phase3_select_all_enemies_zoom
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all actors selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_all_actors_zoom update_phase3_select_all_actors
  def update_phase3_select_all_actors
    set_zoom_postion('select_all_allies', $game_party.actors, @active_battlerr)
    set_zoom_postion('active_battler', @active_battler) if Input.trigger?(Input::B)
    update_phase3_select_all_actors_zoom
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all battlers selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_all_battlers_zoom update_phase3_select_all_battlers
  def update_phase3_select_all_battlers
    set_zoom_postion('select_all_battlers', $game_party.actors + $game_troop.enemies, @active_battler)
    set_zoom_postion('active_battler', @active_battler) if Input.trigger?(Input::B)
    update_phase3_select_all_battlers_zoom
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_zoom step2_part1
  def step2_part1(battler)
    @current_zoom_battler = battler
    step2_part1_zoom(battler)
    set_zoom_postion('action_active', battler, battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part2_zoom step3_part2
  def step3_part2(battler)
    camera_targets = set_camera_target(battler)
    set_zoom_postion(camera_targets[0], camera_targets[1], battler)
    step3_part2_zoom(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_zoom step5_part4
  def step5_part4(battler)
    step5_part4_zoom(battler)
    set_zoom_postion('reset') if battler == @current_zoom_battler
    @current_zoom_battler = nil
  end
  #--------------------------------------------------------------------------
  # * Combination update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias combination_step3_part2_zoom combination_step3_part2 if $atoa_script['Atoa Combination']
  def combination_step3_part2(active)
    camera_targets = set_camera_target(active)
    set_zoom_postion(camera_targets[0], camera_targets[1], active)
    combination_step3_part2_zoom(battler)
  end
  #--------------------------------------------------------------------------
  # * Set movement init
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_move_init_zoom set_move_init
  def set_move_init(battler)
    set_move_init_zoom(battler)
    set_zoom_postion('action_active', battler, battler) if battler.moving?
  end
  #--------------------------------------------------------------------------
  # * Update movement return
  #     battler : battler
  #--------------------------------------------------------------------------
  alias update_move_return_init_zoom update_move_return_init
  def update_move_return_init(battler)
    update_move_return_init_zoom(battler)
    set_zoom_postion('action_active', battler, battler) if battler.moving?
  end
  #--------------------------------------------------------------------------
  # * Set camera position
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_camera_target(battler)
    return ['action_enemy', battler.target_battlers[0]] if battler.now_action.nil?
    ext = check_extension(battler_action(battler), 'TARGET/')
    ext.slice!('TARGET/') unless ext.nil?
    if ext == 'ALLBATTLERS'
      return ['action_all_battlers', battler.target_battlers]
    elsif ext == 'ALLENEMIES' or battler.now_action.scope == 2 or
       (battler.now_action.scope == 1 and 
       check_include(battler.now_action, 'RANDOM'))
      return ['action_all_enemies', battler.target_battlers]
    elsif ext == 'ALLALLIES' or battler.now_action.scope == 4 or
       (battler.now_action.scope == 3 and 
       check_include(battler.now_action, 'RANDOM'))
      return ['action_all_allies', battler.target_battlers]
    end
    if battler.now_action.scope == 1
      return ['action_enemy', battler.target_battlers[0]]
    elsif battler.now_action.scope == 3
      return ['action_ally', battler.target_battlers[0]]
    elsif battler.now_action.scope == 7
      return ['action_self', battler.target_battlers[0]]
    end
    return ['action_self', battler]
  end
end