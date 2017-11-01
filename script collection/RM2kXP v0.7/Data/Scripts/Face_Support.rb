#==============================================================================
# ** Face Support
#==============================================================================

module RPG
  class Actor
    # New accessor face_name
    attr_accessor :face_name
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    alias rm2kxp_face_initialize initialize unless $@
    def initialize
      rm2kxp_face_initialize
      @face_name = ""
    end
  end
end

class Game_Actor < Game_Battler
  attr_reader   :face_name
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias rm2kxp_face_setup setup unless $@
  def setup(actor_id)
    rm2kxp_face_setup(actor_id)
    # Face picture must have the same name as the character graphic.
    @face_name = $data_actors[actor_id].character_name
  end
end