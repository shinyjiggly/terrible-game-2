module RPG
  class << self
    def load_database
      # Load database
      $data_actors        = load_data("Data/Actors.rxdata")
      $data_classes       = load_data("Data/Classes.rxdata")
      $data_skills        = load_data("Data/Skills.rxdata")
      $data_items         = load_data("Data/Items.rxdata")
      $data_weapons       = load_data("Data/Weapons.rxdata")
      $data_armors        = load_data("Data/Armors.rxdata")
      $data_enemies       = load_data("Data/Enemies.rxdata")
      $data_troops        = load_data("Data/Troops.rxdata")
      $data_states        = load_data("Data/States.rxdata")
      $data_animations    = load_data("Data/Animations.rxdata")
      $data_tilesets      = load_data("Data/Tilesets.rxdata")
      $data_common_events = load_data("Data/CommonEvents.rxdata")
      $data_system        = load_data("Data/System.rxdata")
    end
    
    def make_game_objects
      # Make each game object
      $game_system        = Game_System.new
      $game_temp          = Game_Temp.new
      $game_switches      = Game_Switches.new
      $game_variables     = Game_Variables.new
      $game_self_switches = Game_SelfSwitches.new
      $game_screen        = Game_Screen.new
      $game_actors        = Game_Actors.new
      $game_party         = Game_Party.new
      $game_troop         = Game_Troop.new
      $game_map           = Game_Map.new
      $game_player        = Game_Player.new
    end
  end
end
