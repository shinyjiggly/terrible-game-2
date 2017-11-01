#==============================================================================
# Battle Animated Faces
# by Atoa
#==============================================================================
# This script add animated faces to battle
# They change according to the action done.
#
# The faces must be on the Face folder of the Graphics folder
#
# The faces changes according to the battler pose, the name of the battler face
# must be equal the original name + the Pose ID.
#
# Ex.: An actor with an face named "Hero". To add an face for the Pose ID 7
#  (Attack pose on the Default settings), name the face file "Hero7"
#
# If an face don't exist, the original will be used.
#
# Needs the Script "ACBS | Battle Windows"
# The settings are done there.
# 
#==============================================================================

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Anime Faces'] = true

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_anim_face initialize
  def initialize
    @battler_face = []
    initialize_anim_face
  end
  #--------------------------------------------------------------------------
  # * Draw Face Graphic
  #     actor   : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     opacity : face opacity
  #--------------------------------------------------------------------------
  def draw_actor_battle_face(actor, x, y, opacity = 255)
    begin
      @battler_face[actor.id] = Sprite.new if @battler_face[actor.id].nil?
      face_hue = Use_Character_Hue ? actor.character_hue : 0
      begin
        face = RPG::Cache.faces(actor.character_name + actor.current_face.to_s, face_hue)
      rescue
        face = RPG::Cache.faces(actor.character_name + Face_Extension, face_hue)
      end
      @battler_face[actor.id].bitmap = face
      @battler_face[actor.id].x = self.x + 16 + x - face.width / 23
      @battler_face[actor.id].y = self.y + 16 + y - face.height
      @battler_face[actor.id].z = self.z
      @battler_face[actor.id].opacity = opacity
    rescue
    end
    revome_unused_faces
  end
  #--------------------------------------------------------------------------
  # * Update Battler Face
  #     actor : actor
  #--------------------------------------------------------------------------
  def update_battler_face(actor)
    if @battler_face[actor.id].nil?
      refresh
    else
      face_hue = Use_Character_Hue ? actor.character_hue : 0
      begin
        face = RPG::Cache.faces(actor.character_name + actor.current_face.to_s, face_hue)
      rescue
        face = RPG::Cache.faces(actor.character_name + Face_Extension, face_hue)
      end
      @battler_face[actor.id].bitmap = face
    end
  end
  #--------------------------------------------------------------------------
  # * Remove not used faces
  #--------------------------------------------------------------------------
  def revome_unused_faces
    actors_ids = []
    for actor in $game_party.actors
      actors_ids << actor.id
    end
    for i in 0..@battler_face.size
      next if @battler_face[i].nil? or actors_ids.include?(i)
      @battler_face[i].dispose
      @battler_face[i] = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_anim_face dispose
  def dispose
    for face in @battler_face
      next unless face.is_a?(Sprite)
      face.dispose
    end
    dispose_anim_face
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  alias visible_anim_face visible=
  def visible=(n)
    for face in @battler_face
      next unless face.is_a?(Sprite)
      face.visible = n
    end
    visible_anim_face(n)
  end
  #--------------------------------------------------------------------------
  # * Window opacity
  #     n : opacity
  #--------------------------------------------------------------------------
  alias opacity_anim_face opacity=
  def opacity=(n)
    for face in @battler_face
      next unless face.is_a?(Sprite)
      face.opacity = n
    end
    opacity_anim_face(n)
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
  attr_accessor :current_face
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------  
  # * Set intro animation
  #--------------------------------------------------------------------------  
  alias set_intro_anim_face set_intro
  def set_intro
    update_anim_face
    set_intro_anim_face
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_anim_face update
  def update
    update_anim_face
    update_face
  end
  #--------------------------------------------------------------------------
  # * Update faces
  #--------------------------------------------------------------------------
  def update_face
    for actor in $game_party.actors
      if actor.pose_id != actor.current_face
        actor.current_face = actor.pose_id
        @status_window.update_battler_face(actor)
      end
    end
  end
end