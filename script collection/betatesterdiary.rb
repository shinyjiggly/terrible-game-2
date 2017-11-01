    #==============================================================================
    # Betatester Diary
    # By gerkrt / gerrtunk
    # Version: 1
    # License: GPL, credits
    #==============================================================================
     
    =begin
     
    ------- INTRODUCTION ----------
     
    This script allows you to keep a diary of the player's actions in the game
    with the purpose of being able to analyze the betatester playthrough.
     
    For this purpose the script gives you three tools:
     
    1-Game-Journal: The information is saved the current game, as
    the configuration and type you choose. This journal keep a new entry every
    once you call it with a call script.
     
    2 Save-Journal: This saves the save number, playing time and
    additional information. It is updated every time you save automatically.
     
    3-Write other data: Here you could enter values of variables or switches of
    within the game, for example, an indicator of % completed game. Scripts that are also
    compatible.
     
    ------ MAKE A GAME LOG ---------
     
    1-At the beginning of your project, calls this script&#058; $ game_party.start_diary
    This creates the initial file and a header with information about your project.
    Also create the save file, but until you save it will be empty.
     
    2-To add information to the file you have several options. This script lets you
    many configuration possibilities, it would be very long writing illegible
    skills of the characters each time, but instead, may be well
    write three times throughout the game.
     
      a) $game_party.simple("Chapter title", 1). This script call writes
      a more condensed version of the total of the departure information: date, time,
      money, steps, current map, names, kinds and levels of the characters.
     
      Need two arguments: "Title of chapter" Here I write
      the title that allows you to differentiate each entry
     
      1: This argument allows you to choose if you want to save the information for all
      characters (value 1) or only the actual group (value 0). This means that if you call
      $game_party.simple ("Chapter title", 1) will tell you only the group.
     
      b)$game_party.complex("Chapter title", 1). This method can record all
      group information.
      The first two arguments are the same as in the simple.
      You can set what you want to write about the characters in  call
      complex, from its attributes, equipment or skills, as well as objects.
      But this is defined in the configuration.
     
      c) $game_party.total("Chapter title", 1) This show absolutely all
      information. Even so, you can define all or group.
     
    3-At the end of your project, calls this script&#058; $game_party.end_diary
    This creates a header for the daily final.
     
     
    ------SAVE-LOG---------
     
    To save the log you have just selected the option Record_saves.
    Default it is on.
    You should also keep in mind that you need to do to call  start__diary to create
    the file.
     
    ------OTHER DATA STORAGE---------
     
    $game_party.my_data
    This will save the information you fill in the configuration
     
    To display event variables (due in the order in which they write):
     
    Game_variables.push ([ID variable, "Description"])
     
    To display switches (due in the order in which they write):
     
    Game_switches.push ([ID switch, "Description"])
     
    This will be added to the game log with a differentiator, but nothing else extra.
     
    ----OTHER TIPS-----
     
    a) To write long titles can use the following script as the basis for all:
     
    t = "Long Tree FoDext"
    $game_party.total(t, 0)
     
    b) To edit settings:
     
    "Texts": You must put the words in quotes, if you delete will fail.
    true / false: It means On or Off. Active/Inactive
     
    c) Default options:
     
    There are defaults for each type of argument in the calls, so they arent mandatory.
    If you dont put the number ($game_party.complex("Chapter title") it will be like it
    was a 0.
    If you dont put the title ($game_party.complex("Chapter title") it will use the title
    default.
    Also you can use without any.
     
    ------ CONFIGURATION ---------
     
    Game_title: Title Game
     
    Game_version: Your version
     
    Game_autor: The author
     
    Save_record_name: The name of the file where you save game-log
     
    Diary_name: The name of the file where you save-log
     
    Note: The version will be added to the name to improve it.
     
    Random_file_name: This option adds a small random value to the name of the game.
    What is the point? Well, imagine that you're dealing with a lot of these
    files. If it all were the same it will be very difficult to work with them in a
    folder. Version also is added, improving the identification:
    05D-675 487-Betatester Diary.txt
    05D-675 487-Save Record.txt
     
    Note: The random name is created when you run start_diary and will be maintained
    throughout the game, saved. But if the player starts a new game it will change.
     
    Compact_style: It aims to show the greatest things in a few lines. Could be
    less readable than normal.
     
    Upcase_titles: This option makes all the titles are processed letters
    capitalization, increasing their visibility.
     
    Record_saves_actors: If you want the save log  to show
    information about the characters or not.
     
    Record_saves_all_actors: If the information will be of all characters or not.
     
    Write_actor_equipment: Writes equipment in complex call.
     
    Write_actor_skills: Writes skills in complex call.
     
    Write_actor_parameters: Writes parameters in complex call.
     
    Write_items: Writes items in complex call.
     
    Introductory_note: You can write an initial text
     
    End_diary_note: Allows you to write a final text
     
    Start_diary_title: Define the first title game
     
    End_diary_title: Define the last title game
     
    My_data_title: Define the title of your data
     
    Save_name: The name of the titles of each saved game.
     
    -----------COMPATIBILITY----------
     
    In case of errors, especially with the saved, can provide off
    modification to this with the option: Modify_save. Disabling will make you lose
    the option to create the save-log.
     
    Another option is to disable the Game_System with this modification:
    Modify_game_system
    Disabling will make you lose the option random_filename
     
    =end
     
    module Wep
     
      # Vocabulary and information
      Game_title = "Alderhast"
      Game_version = "0.5z"
      Game_autor = "Wep"
      File_name = "Diary.txt"
      Save_record_name = "Record.txt"
      Default_title = "Defaul title"
      End_diary_note = "Good night"
      Start_diary_title = "GAME START"
      End_diary_title = "GAME END"
      My_data_title = "MY EXTRA DATA"
      Introductory_note = "Welcome!"
      Save_name = "Save"
     
      # Save-log config
      Record_saves = true
      Record_saves_all_actors = false
      Record_saves_actors = true
     
      # Game-log config
      Write_actor_parameters = true
      Write_actor_skills = true
      Write_actor_equipment = true
      Write_items = true
     
      # General config
      Random_file_name = true
      Upcase_titles = true
      Compact_style = true
     
      # Compatibality
      Modify_save = true
      Modify_game_system = true
     
      # My extra data
      Game_variables = []
      Game_switches = []
      Game_variables.push([1, "% completed game"])
      Game_switches.push([1, "Lime king killed"])
      Game_switches.push([2, "I survived the hard dungeon"])
    end
     
    class Game_Party
     
      #--------------------------------------------------------------------------
      # * My_Data
      #  Writes the creator game variables and switches
      #--------------------------------------------------------------------------
      def my_data
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::File_name
        else
          filename = Wep::Game_version+"-"+Wep::File_name
        end
        estado = open(filename, "a")
        estado.write("\n------------------------------------------\n")
        estado.write("||||"+Wep::My_data_title+"||||")
        estado.write("\n------------------------------------------\n")    
        # Write system time
        date = "\nDate: "
        date+= estado.mtime.to_s
       # If uses normal style
       if not Wep::Compact_style
        # Writes game variables descriptions and values
        for var in Wep::Game_variables
          estado.write(var[1]+": "+$game_variables[var[0]].to_s+"\n")
        end
        estado.write ("\n")
        for var in Wep::Game_switches
           estado.write(var[1]+": "+$game_switches[var[0]].to_s+"\n")
        end
      # If uses compact style
      else
        # Writes game variables descriptions and values
        for var in Wep::Game_variables
          estado.write(var[1]+": "+$game_variables[var[0]].to_s+"\n")
        end
        estado.write ("\n")
        for var in Wep::Game_switches
           estado.write(var[1]+": "+$game_switches[var[0]].to_s+"\n")
        end    
      end
        estado.write ("\n")
        estado.close
      end
     
      #--------------------------------------------------------------------------
      # * Record_Save
      #  Writes the save record
      #--------------------------------------------------------------------------
      def record_save
        # Load mapinfo for map name
        mapinfos = load_data("Data/MapInfos.rxdata")
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::Save_record_name
        else
          filename = Wep::Game_version+"-"+Wep::Save_record_name
        end
        estado = open(filename, "a")
        estado.write("------------------------------------------\n")
        estado.write("||||"+Wep::Save_name+" "+($game_system.save_count+1).to_s+"||||")
        estado.write("\n------------------------------------------\n")    
        # Write time
        @total_sec = Graphics.frame_count / Graphics.frame_rate
        hour = @total_sec / 60 / 60
        min = @total_sec / 60 % 60
        sec = @total_sec % 60
        text = sprintf("%02d:%02d:%02d", hour, min, sec)
        tiempo = "\nPlaytime: "
        tiempo+= text
        estado.write(tiempo)
        # Write money
        money = ". Money: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write actual map(and name)
        estado.write(". Map: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")\n")
      if  Wep::Record_saves_actors
       if Wep::Record_saves_all_actors == false
        for actor in $game_party.actors
          estado.write("\n"+actor.name+" ("+$data_classes[actor.class_id].name+") Nv"+actor.level.to_s+"\n")
        end
       else
     
        for i in 1...$data_actors.size
          estado.write("\n"+$game_actors[i].name+" ("+$data_classes[$game_actors[i].class_id].name+") Nv"+$game_actors[i].level.to_s+"\n")
        end
       
       end
      end
      estado.write ("\n")
      estado.close
     end
     
      #--------------------------------------------------------------------------
      # * Start_Diary
      #  Creates the file and write a header
      #--------------------------------------------------------------------------  
      def start_diary
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          $game_system.random_filename = rand(999999).to_s
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::Save_record_name
        else
          filename = Wep::Game_version+"-"+Wep::Save_record_name
        end
        file = open(filename, "w+")
        file.close
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::File_name
        else
          filename = Wep::Game_version+"-"+Wep::File_name
        end
        estado = open(filename, "w+")
        estado.write("------------------------------------------\n")
        estado.write("||||"+Wep::Start_diary_title+"||||")
        estado.write("\n------------------------------------------\n")    
        estado.write("Title: "+Wep::Game_title+"\n")
        estado.write("Autor: "+Wep::Game_autor+"\n")
        estado.write("Version: "+Wep::Game_version+"\n")
        date = "\Date: "
        date+= estado.mtime.to_s+"\n"
        estado.write(date)
        estado.write("Autor introduction: "+Wep::Introductory_note+"\n\n")
        estado.close
      end
     
      #--------------------------------------------------------------------------
      # * End_Diary
      #  Write ending info
      #--------------------------------------------------------------------------    
      def end_diary
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::File_name
        else
          filename = Wep::Game_version+"-"+Wep::File_name
        end
        estado = open(filename, "a")
        estado.write("------------------------------------------\n")
        estado.write("||||"+Wep::End_diary_title+"||||")
        estado.write("\n------------------------------------------\n")    
        estado.write("Title: "+Wep::Game_title+"\n")
        estado.write("Autor: "+Wep::Game_autor+"\n")
        estado.write("Version: "+Wep::Game_version+"\n")
        date = "\Date: "
        date+= estado.mtime.to_s+"\n"
        estado.write(date)
        estado.write("End note: "+Wep::End_diary_note+"\n")
        estado.close
      end
     
      #--------------------------------------------------------------------------
      # * Simple call
      #  Writes simplified information
      #     title: text to write in a identifing header
      #     all_actors: write all or group
      #--------------------------------------------------------------------------  
      def simple(title=Wep::Default_title,all_actors=1)
        # Check for upcase conversion
        if Wep::Upcase_titles
          title.upcase!
        end
        # Load mapinfo for map name
        mapinfos = load_data("Data/MapInfos.rxdata")
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::File_name
        else
          filename = Wep::Game_version+"-"+Wep::File_name
        end
       
        estado = open(filename, "a")
        estado.write("------------------------------------------\n")
        estado.write("||||"+title+"||||")
        estado.write("\n------------------------------------------\n")    
        # Writes System time
        date = "\nDate: "
       
        date+= estado.mtime.to_s
        estado.write(date)
        # Write time
        @total_sec = Graphics.frame_count / Graphics.frame_rate
        hour = @total_sec / 60 / 60
        min = @total_sec / 60 % 60
        sec = @total_sec % 60
        text = sprintf("%02d:%02d:%02d", hour, min, sec)
        tiempo = "\nPlaytime: "
        tiempo+= text
        estado.write(tiempo)
       # If uses normal style
       if not Wep::Compact_style
        # Write money
        money = "\nMoney: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write steps
        estado.write("\nSteps: "+$game_party.steps.to_s)
        # Write actual map(and name)
        estado.write(".\n Map: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")")
      # If uses compact style
      else
        # Write money
        money = "\nMoney: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write steps
        estado.write(". Steps: "+$game_party.steps.to_s)
        # Write actual map(and name)
        estado.write(". Map: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")")
       end
        # Write actors
        estado.write ("\n")
       # If its only for the actual group
       if all_actors == 1
        for actor in $game_party.actors
         # If uses normal style
         if not Wep::Compact_style
          estado.write ("-----------------\n")
          estado.write(actor.name)
          estado.write ("\n---------------\n")      
          estado.write($data_classes[actor.class_id].name)
          estado.write ("\nNv ")
          estado.write(actor.level)
          estado.write ("\n")  
         # If uses compact style
         else
          estado.write("\n"+actor.name+" ("+$data_classes[actor.class_id].name+") Nv"+actor.level.to_s+"\n")
         end
       end
       
      # If its for all actors
      else
        for i in 1...$data_actors.size
         # If uses normal style
         if not Wep::Compact_style
          estado.write ("-----------------\n")
          estado.write(actor.name)
          estado.write ("\n---------------\n")    
          estado.write($data_classes[$game_actors[i].class_id].name)
          estado.write ("\nNv ")
          estado.write($game_actors[i].level)
          estado.write ("\n")  
         # If uses compact style
         else
          estado.write("\n"+$game_actors[i].name+" ("+$data_classes[$game_actors[i].class_id].name+") Nv"+$game_actors[i].level.to_s+"\n")
         end
        end
       
      end
        estado.write ("\n")
        estado.close
      end
     
      #--------------------------------------------------------------------------
      # * Total call
      #  Writes all information
      #     title: text to write in a identifing header
      #     all_actors: write all or group
      #--------------------------------------------------------------------------  
      def total(title=Wep::Default_title,all_actors=0)
        # Check for upcase conversion
        if Wep::Upcase_titles
          title.upcase!
        end
        # Load mapinfo for map name
        mapinfos = load_data("Data/MapInfos.rxdata")
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::File_name
        else
          filename = Wep::Game_version+"-"+Wep::File_name
        end
        estado = open(filename, "a")
        estado.write("------------------------------------------\n")
        estado.write("||||"+title+"||||")
        estado.write("\n------------------------------------------\n")    
        # Write system time
        date = "\nDate: "
        date+= estado.mtime.to_s
        estado.write(date)
       
        # Write time
        @total_sec = Graphics.frame_count / Graphics.frame_rate
        hour = @total_sec / 60 / 60
        min = @total_sec / 60 % 60
        sec = @total_sec % 60
       
        text = sprintf("%02d:%02d:%02d", hour, min, sec)
        tiempo = "\nPlaytime: "
        tiempo+= text
        estado.write(tiempo)
       # If uses normal style
       if not Wep::Compact_style
        # Write money
        money = "\nMoney: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write steps
        estado.write("\nSteps: "+$game_party.steps.to_s)
        # Write actual map(and name)
        estado.write("\nMap: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")")
       # If uses compact style
       else
        # Write money
        money = "\nMoney: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write steps
        estado.write(". Steps: "+$game_party.steps.to_s)
        # Write actual map(and name)
        estado.write(". Map: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")")
       end
     
        # Write actors
        estado.write ("\n\n")
       # If its only for the actual group
       if all_actors == 1
        actor_id = 1
        for actor in $game_party.actors
         # If uses normal style
         if not Wep::Compact_style
          # Write actor basic Info
          estado.write ("\n---------------\n")
          estado.write(actor.name)
          estado.write ("\n---------------\n")    
          estado.write($data_classes[actor.class_id].name)
          estado.write ("\nNv ")
          estado.write(actor.level)
          estado.write ("\n")  
         # If uses compact style
         else
          # Write actor basic Info
          estado.write("\n------------------------\n"+actor.name+" ("+$data_classes[actor.class_id].name+") Nv"+actor.level.to_s+"\n------------------------\n")
        end
       
          # Write actor equipment (check if equipped)
          if true
          estado.write("\n\nEquipment:\n\n")
         
          if $game_actors[actor_id].weapon_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_weapons[$game_actors[actor_id].weapon_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor1_id != 0
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor1_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write("\n")
          end  
         
          if $game_actors[actor_id].armor2_id != 0
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor2_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write("\n")
          end    
         
          if $game_actors[actor_id].armor3_id != 0
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor3_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor4_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor4_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor4)
            estado.write(": ")
            estado.write("\n")
          end
        end
       
        # Write actor parameters
        if true
         # If uses normal style
         if not Wep::Compact_style
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write("\n  SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write("\n  Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write("\n  Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write("\n  PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write("\n  MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write("\n  Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         # If uses compact style
         else
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write(". SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write(". Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write(". Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write(". PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write(". MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write(". Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         end
        end
       
         # Write actor skills  
         if true
          estado.write("\nSkills:\n\n  ")  
          # If uses normal style
          if not Wep::Compact_style
          for i in 0...$game_actors[actor_id].skills.size        
             skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
                estado.write(skill.name+"\n  ")
            end
          end
         # If uses compact style
         else
          c=0
          for i in 0...$game_actors[actor_id].skills.size
            skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
              if c == 0
                estado.write(skill.name+". ")    
                c += 1
              elsif c == 1
                estado.write(skill.name+"\n  ")
                c = 0
              end
             
          end
         
         end
       
       end
         
        end
     
       
       
       
       
       
        estado.write("\n")
        actor_id += 1
      end
         
      # If is for all actors
      else
        for i in 1...$data_actors.size
          actor_id = i
          actor = $game_actors[i]
         # If uses normal style
         if not Wep::Compact_style
          # Write actor basic Info
          estado.write ("\n---------------\n")
          estado.write(actor.name)
          estado.write ("\n---------------\n")    
          estado.write($data_classes[actor.class_id].name)
          estado.write ("\nNv ")
          estado.write(actor.level)
          estado.write ("\n")  
         # If uses compact style
         else
          # Write actor basic Info
          estado.write("\n------------------------\n"+actor.name+" ("+$data_classes[actor.class_id].name+") Nv"+actor.level.to_s+"\n------------------------\n")
        end
       
          # Write actor equipment (check if equipped)
          if true
          estado.write("\n\nEquipment:\n\n")
         
          if $game_actors[actor_id].weapon_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_weapons[$game_actors[actor_id].weapon_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor1_id != 0
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor1_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write("\n")
          end  
         
          if $game_actors[actor_id].armor2_id != 0
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor2_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write("\n")
          end    
         
          if $game_actors[actor_id].armor3_id != 0
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor3_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor4_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor4_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor4)
            estado.write(": ")
            estado.write("\n")
          end
        end
       
        # Write actor parameters
        if true
         # If uses normal style
         if not Wep::Compact_style
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write("\n  SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write("\n  Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write("\n  Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write("\n  PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write("\n  MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write("\n  Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         # If uses compact style
         else
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write(". SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write(". Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write(". Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write(". PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write(". MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write(". Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         end
        end
       
         # Write actor skills  
         if true
          estado.write("\nSkills:\n\n  ")  
          # If uses normal style
          if not Wep::Compact_style
          for i in 0...$game_actors[actor_id].skills.size        
             skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
                estado.write(skill.name+"\n  ")
            end
          end
         # If uses compact style
         else
          c=0
          for i in 0...$game_actors[actor_id].skills.size
            skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
              if c == 0
                estado.write(skill.name+". ")    
                c += 1
              elsif c == 1
                estado.write(skill.name+"\n  ")
                c = 0
              end
             
          end
         
         end
       
       end
         
        end
     
        estado.write("\n")
       
      end
         
      end
        estado.write ("\n")
       
     
        # Write normal style      
        if not Wep::Compact_style
         # Write actor items
         if true
          estado.write("--------------\nInventary:\n--------------\n  ")  
          estado.write("\nItems:\n\n  ")  
          c=0
          for i in 1...$data_items.size
            if $game_party.item_number(i) > 0
              estado.write($data_items[i].name+": "+$game_party.item_number(i).to_s+"\n  ")
            end
          end
         # Write actor weapons
          estado.write("\nWeapons:\n\n  ")
          c=0
          for i in 1...$data_weapons.size
            if $game_party.weapon_number(i) > 0
              estado.write($data_weapons[i].name+": "+$game_party.weapon_number(i).to_s+"\n  ")
            end
          end
         # Write actor armors
          estado.write("\nArmors:\n\n  ")
          c=0
          for i in 1...$data_armors.size
            if $game_party.armor_number(i) > 0
              estado.write($data_armors[i].name+": "+$game_party.armor_number(i).to_s+"\n  ")
            end
          end
        end
       
       # Write compact style
       else
     
         # Write items
         if true
          estado.write("--------------\nInventary:\n--------------\n  ")  
          estado.write("\nItems:\n\n  ")  
          c=0
          for i in 1...$data_items.size
            if $game_party.item_number(i) > 0
              if c == 0
                estado.write($data_items[i].name+": "+$game_party.item_number(i).to_s+". ")            
                c += 1
              elsif c == 1  
                estado.write($data_items[i].name+": "+$game_party.item_number(i).to_s+"\n  ")
              end
            end
          end
         # Write weapons
          estado.write("\nWeapons:\n\n  ")
          c=0
          for i in 1...$data_weapons.size
            if $game_party.weapon_number(i) > 0
              if c == 0
                estado.write($data_weapons[i].name+": "+$game_party.weapon_number(i).to_s+". ")            
                c += 1
              elsif c == 1  
                estado.write($data_weapons[i].name+": "+$game_party.weapon_number(i).to_s+"\n  ")
              end        
            end
          end
         # Write armors
          estado.write("\n\nArmors:\n\n  ")
          c=0
          for i in 1...$data_armors.size
            if $game_party.armor_number(i) > 0
              if c == 0
                estado.write($data_armors[i].name+": "+$game_party.armor_number(i).to_s+". ")            
                c += 1
              elsif c == 1  
                estado.write($data_armors[i].name+": "+$game_party.armor_number(i).to_s+"\n  ")
              end
            end
          end
        end    
         
         
         
         
       end
          estado.write ("\n")
          estado.close
      end
     
       
    end
     
     
     
     
      #--------------------------------------------------------------------------
      # * Complex call
      #  Writes complex information(configured)
      #     title: text to write in a identifing header
      #     all_actors: write all or group
      #--------------------------------------------------------------------------  
      def complex(title=Wep::Default_title,all_actors=0)
        # Check for upcase conversion
        if Wep::Upcase_titles
          title.upcase!
        end
        # Load mapinfo for map name
        mapinfos = load_data("Data/MapInfos.rxdata")
        # Make the filename
        if Wep::Random_file_name and Wep::Modify_game_system
          filename = Wep::Game_version+"-"+$game_system.random_filename+"-"+Wep::File_name
        else
          filename = Wep::Game_version+"-"+Wep::File_name
        end
        estado = open(filename, "a")
        estado.write("------------------------------------------\n")
        estado.write("||||"+title+"||||")
        estado.write("\n------------------------------------------\n")    
        # Write system time
        date = "\nDate: "
        date+= estado.mtime.to_s
        estado.write(date)
       
        # Write time
        @total_sec = Graphics.frame_count / Graphics.frame_rate
        hour = @total_sec / 60 / 60
        min = @total_sec / 60 % 60
        sec = @total_sec % 60
       
        text = sprintf("%02d:%02d:%02d", hour, min, sec)
        tiempo = "\nPlaytime: "
        tiempo+= text
        estado.write(tiempo)
       # If uses normal style
       if not Wep::Compact_style
        # Write money
        money = "\nMoney: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write steps
        estado.write("\nSteps: "+$game_party.steps.to_s)
        # Write actual map(and name)
        estado.write("\nMap: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")")
       # If uses compact style
       else
        # Write money
        money = "\nMoney: "
        money += $game_party.gold.to_s
        estado.write(money)
        # Write steps
        estado.write(". Steps: "+$game_party.steps.to_s)
        # Write actual map(and name)
        estado.write(". Map: "+$game_map.map_id.to_s+" ("+mapinfos[$game_map.map_id].name+")")
       end
     
        # Write actors
        estado.write ("\n\n")
       # If its only for the actual group
       if all_actors == 1
        actor_id = 1
        for actor in $game_party.actors
         # If uses normal style
         if not Wep::Compact_style
          # Write actor basic Info
          estado.write ("\n---------------\n")
          estado.write(actor.name)
          estado.write ("\n---------------\n")    
          estado.write($data_classes[actor.class_id].name)
          estado.write ("\nNv ")
          estado.write(actor.level)
          estado.write ("\n")  
         # If uses compact style
         else
          # Write actor basic Info
          estado.write("\n------------------------\n"+actor.name+" ("+$data_classes[actor.class_id].name+") Nv"+actor.level.to_s+"\n------------------------\n")
        end
       
          # Write actor equipment (check if equipped)
          if Wep::Write_actor_equipment
          estado.write("\n\nEquipment:\n\n")
         
          if $game_actors[actor_id].weapon_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_weapons[$game_actors[actor_id].weapon_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor1_id != 0
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor1_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write("\n")
          end  
         
          if $game_actors[actor_id].armor2_id != 0
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor2_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write("\n")
          end    
         
          if $game_actors[actor_id].armor3_id != 0
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor3_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor4_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor4_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor4)
            estado.write(": ")
            estado.write("\n")
          end
        end
       
        # Write actor parameters
        if Wep::Write_actor_parameters
         # If uses normal style
         if not Wep::Compact_style
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write("\n  SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write("\n  Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write("\n  Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write("\n  PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write("\n  MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write("\n  Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         # If uses compact style
         else
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write(". SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write(". Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write(". Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write(". PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write(". MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write(". Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         end
        end
       
         # Write actor skills  
         if Wep::Write_actor_skills
          estado.write("\nSkills:\n\n  ")  
          # If uses normal style
          if not Wep::Compact_style
          for i in 0...$game_actors[actor_id].skills.size        
             skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
                estado.write(skill.name+"\n  ")
            end
          end
         # If uses compact style
         else
          c=0
          for i in 0...$game_actors[actor_id].skills.size
            skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
              if c == 0
                estado.write(skill.name+". ")    
                c += 1
              elsif c == 1
                estado.write(skill.name+"\n  ")
                c = 0
              end
             
          end
         
         end
       
       end
         
        end
     
       
       
       
       
       
        estado.write("\n")
        actor_id += 1
      end
         
      # If is for all actors
      else
        for i in 1...$data_actors.size
          actor_id = i
          actor = $game_actors[i]
         # If uses normal style
         if not Wep::Compact_style
          # Write actor basic Info
          estado.write ("\n---------------\n")
          estado.write(actor.name)
          estado.write ("\n---------------\n")    
          estado.write($data_classes[actor.class_id].name)
          estado.write ("\nNv ")
          estado.write(actor.level)
          estado.write ("\n")  
         # If uses compact style
         else
          # Write actor basic Info
          estado.write("\n------------------------\n"+actor.name+" ("+$data_classes[actor.class_id].name+") Nv"+actor.level.to_s+"\n------------------------\n")
        end
       
          # Write actor equipment (check if equipped)
          if Wep::Write_actor_equipment
          estado.write("\n\nEquipment:\n\n")
         
          if $game_actors[actor_id].weapon_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_weapons[$game_actors[actor_id].weapon_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor1_id != 0
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor1_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor1)
            estado.write(": ")
            estado.write("\n")
          end  
         
          if $game_actors[actor_id].armor2_id != 0
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor2_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor2)
            estado.write(": ")
            estado.write("\n")
          end    
         
          if $game_actors[actor_id].armor3_id != 0
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor3_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor3)
            estado.write(": ")
            estado.write("\n")
          end
         
          if $game_actors[actor_id].armor4_id != 0
            estado.write("  "+$data_system.words.weapon)
            estado.write(": ")
            estado.write($data_armors[$game_actors[actor_id].armor4_id].name)
            estado.write("\n")
          else
            estado.write("  "+$data_system.words.armor4)
            estado.write(": ")
            estado.write("\n")
          end
        end
       
        # Write actor parameters
        if Wep::Write_actor_parameters
         # If uses normal style
         if not Wep::Compact_style
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write("\n  SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write("\n  Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write("\n  Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write("\n  PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write("\n  MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write("\n  Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         # If uses compact style
         else
          estado.write ("\n\nParameters:\n\n  HP ")      
          estado.write($game_actors[actor_id].hp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxhp)
          estado.write(". SP ")
          estado.write($game_actors[actor_id].sp)
          estado.write("\\")
          estado.write($game_actors[actor_id].maxsp)
          estado.write( "\n  Str ")        
          estado.write($game_actors[actor_id].base_str)
          estado.write(". Dex ")  
          estado.write($game_actors[actor_id].base_dex)
          estado.write(". Agi ")
          estado.write($game_actors[actor_id].base_agi)
          estado.write("\n  Int ")
          estado.write($game_actors[actor_id].base_int)
          estado.write(". PDef ")
          estado.write($game_actors[actor_id].base_pdef)
          estado.write(". MDef ")
          estado.write($game_actors[actor_id].base_mdef)
          estado.write("\n  Atk ")
          estado.write($game_actors[actor_id].base_atk)
          estado.write(". Eva ")
          estado.write($game_actors[actor_id].base_eva)
          estado.write("\n")
         end
        end
       
         # Write actor skills  
         if Wep::Write_actor_skills
          estado.write("\nSkills:\n\n  ")  
          # If uses normal style
          if not Wep::Compact_style
          for i in 0...$game_actors[actor_id].skills.size        
             skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
                estado.write(skill.name+"\n  ")
            end
          end
         # If uses compact style
         else
          c=0
          for i in 0...$game_actors[actor_id].skills.size
            skill = $data_skills[$game_actors[actor_id].skills[i]]
            if skill != nil
              if c == 0
                estado.write(skill.name+". ")    
                c += 1
              elsif c == 1
                estado.write(skill.name+"\n  ")
                c = 0
              end
             
          end
         
         end
       
       end
         
        end
     
        estado.write("\n")
       
      end
         
      end
        estado.write ("\n")
       
     
        # Write normal style      
        if not Wep::Compact_style
         # Write actor items
         if Wep::Write_items
          estado.write("--------------\nInventary:\n--------------\n  ")  
          estado.write("\nItems:\n\n  ")  
          c=0
          for i in 1...$data_items.size
            if $game_party.item_number(i) > 0
              estado.write($data_items[i].name+": "+$game_party.item_number(i).to_s+"\n  ")
            end
          end
         # Write actor weapons
          estado.write("\nWeapons:\n\n  ")
          c=0
          for i in 1...$data_weapons.size
            if $game_party.weapon_number(i) > 0
              estado.write($data_weapons[i].name+": "+$game_party.weapon_number(i).to_s+"\n  ")
            end
          end
         # Write actor armors
          estado.write("\nArmors:\n\n  ")
          c=0
          for i in 1...$data_armors.size
            if $game_party.armor_number(i) > 0
              estado.write($data_armors[i].name+": "+$game_party.armor_number(i).to_s+"\n  ")
            end
          end
        end
       
       # Write compact style
       else
     
         # Write items
         if Wep::Write_items
                 estado.write("--------------\nInventary:\n--------------\n  ")  
          estado.write("\nItems:\n\n  ")  
          c=0
          for i in 1...$data_items.size
            if $game_party.item_number(i) > 0
              if c == 0
                estado.write($data_items[i].name+": "+$game_party.item_number(i).to_s+". ")            
                c += 1
              elsif c == 1  
                estado.write($data_items[i].name+": "+$game_party.item_number(i).to_s+"\n  ")
              end
            end
          end
         # Write weapons
          estado.write("\nWeapons:\n\n  ")
          c=0
          for i in 1...$data_weapons.size
            if $game_party.weapon_number(i) > 0
              if c == 0
                estado.write($data_weapons[i].name+": "+$game_party.weapon_number(i).to_s+". ")            
                c += 1
              elsif c == 1  
                estado.write($data_weapons[i].name+": "+$game_party.weapon_number(i).to_s+"\n  ")
              end        
            end
          end
         # Write armors
          estado.write("\n\nArmors:\n\n  ")
          c=0
          for i in 1...$data_armors.size
            if $game_party.armor_number(i) > 0
              if c == 0
                estado.write($data_armors[i].name+": "+$game_party.armor_number(i).to_s+". ")            
                c += 1
              elsif c == 1  
                estado.write($data_armors[i].name+": "+$game_party.armor_number(i).to_s+"\n  ")
              end
            end
          end
        end    
         
         
         
         
       end
          estado.write ("\n")
          estado.close
      end
     
     
     
     
    # Check for compatibality option
    if Wep::Modify_save
     
     class Scene_Save < Scene_File
      #--------------------------------------------------------------------------
      # * Decision Processing
      #--------------------------------------------------------------------------
      alias diary_on_decision on_decision
      def on_decision(filename)
        $game_party.record_save
        diary_on_decision(filename)
      end
     end
    end
     
    # Check for compatibality option
    if Wep::Modify_game_system
     
     class Game_System
      attr_accessor :random_filename
      alias bd_initialize initialize
      def initialize
        @random_filename = 0    
        bd_initialize
      end
     end
    end