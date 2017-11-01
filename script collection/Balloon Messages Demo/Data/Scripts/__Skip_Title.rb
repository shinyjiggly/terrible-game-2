class Scene_Title < Scene_Base
  class << self
    alias mp_skip_new new
    def new
      # If very first scene to be called, load data and go to map instead
      if $scene.nil?
        RPG.load_database
        RPG.make_game_objects
        # Reset frame count for measuring play time
        Graphics.frame_count = 0
        # Set up initial party
        $game_party.setup_starting_members
        # Set up initial map position
        $game_map.setup($data_system.start_map_id)
        # Move player to initial position
        $game_player.moveto($data_system.start_x, $data_system.start_y)
        # Refresh player
        $game_player.refresh
        # Run automatic change for BGM and BGS set with map
        $game_map.autoplay
        # Update map (run parallel process event)
        $game_map.update
        # Switch to map screen
        $scene = Scene_Map.new
      else
        return mp_skip_new
      end
    end
  end
end