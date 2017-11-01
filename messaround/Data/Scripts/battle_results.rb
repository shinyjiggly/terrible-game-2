#==============================================================================
# Retro-Styled Battle Result Window
# By gerkrt/gerrtunk
# Version: 1.1
# License: GPL, credits
# Date: 22/08/2011
# IMPORTANT NOTE: to acces the more actualitzed or corrected version of this
# script check here: http://usuarios.multimania.es/kisap/english_list.html
#==============================================================================
 
=begin
 
--------Introduction-----------
 
This scripts lets you use a retro styled battle result window, like FFVI for
example, where a small window on the top shows line per line the information.
 
But i expanded that. You can configure what you want to show or not and how it will
be shown, grouped or not, and what number of lines will have the window.
 
Finally you can use a wait key mode or a wait time one.
 
------Instructions-------------
 
First you have to select what you want to see. To do that use the option
Things_to_show. This is a list of codes so if the code is here that option
will be shown. The codes are:
 
:level_up, :gain_skill, :win_phrase, :gold, :exp, :treasures
 
Later you can configure the number of lines of the window in Lines_to_show.
The retro games used 1, but you can add more lines to the window so the
messages are shown faster.
 
Show_levels_in_one_line = true
 
These options define if for example it says , actor level up! actor level up!
or actor level up!(2). true/false, active and inactive.
 
------Vocabulary-----
 
The last options are the words the system show in the window. You can changue
that.
 
Also you can configure battle wins phrases for each enemy troop.
 
  Battle_wins_phrases = {
    2=>'Wep winned again2',
    3=>'Wep winned again3',
  }
Where X=> is the troop id number and 'text' is th eprharse, respect the syntax.
Note that exist a default option for the ones that dont have a entry here.
 
-----Compatibility----
 
You can desactivate the modification of the battle status windows, thats the one
used for draw character info in battle.
 
Modify_window_battle_status = false
 
=end
 
module Wep
  Show_levels_in_one_line = true
  Lines_to_show = 1
  Things_to_show = [:level_up, :gain_skill, :win_phrase, :gold, :exp, :treasures]
  Modify_window_battle_status = true
  Gain_level_phrase = ' level up'
  Gain_skill_phrase = ' learned'
  Gain_gold_phrase = ' gained.'
  Treasure_gain_phrase = ' gained.'
  Gain_exp_phrase = ' Exp gained.'
  Battle_win_default_phrase = 'Wep! You win!.'
  Battle_wins_phrases = {
    2=>'Wep winned again2',
    3=>'Wep winned again3',
  }
 
end
 
 
if Wep::Modify_window_battle_status
#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================
 
class Window_BattleStatus < Window_Base
   #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actor_x = i * 160 + 4
      draw_actor_name(actor, actor_x, 0)
      draw_actor_hp(actor, actor_x, 32, 120)
      draw_actor_sp(actor, actor_x, 64, 120)
      if @level_up_flags[i]
        #self.contents.font.color = normal_color
        #self.contents.draw_text(actor_x, 96, 120, 32, "¡Sube Nivel!")
      else
        draw_actor_state(actor, actor_x, 96)
      end
    end
  end
end
 
end
 
 
#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================
 
 
class Window_BattleResult < Window_Base
  attr_reader   :messages_max
  attr_reader   :messages_index
 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  def initialize(br)
    @br = br # get battle result
    @messages_index = 0 # shows the actual mesage of the window
    @messages = [] # array of mesages: exp, gold,e tc
    super(0, 0, 640,  (Wep::Lines_to_show * 32) + 32)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.y = 0
    self.back_opacity = 160
    self.visible = false
    generate_messages
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Generate messages
  # This extracts all the information of the battle result and push it in the
  # messages list as phrases
  #--------------------------------------------------------------------------
  def generate_messages
    i = 0
   
    # Win phrase
    if Wep::Things_to_show.include? :win_phrase
      if Wep::Battle_wins_phrases[$game_temp.battle_troop_id] != nil
        @messages.push Wep::Battle_wins_phrases[$game_temp.battle_troop_id]
      else
        @messages.push Wep::Battle_win_default_phrase
      end
    end
   
    # Gold & exp
    @messages.push @br.exp.to_s + Wep::Gain_exp_phrase if Wep::Things_to_show.include? :exp
    @messages.push @br.gold.to_s + ' ' + $data_system.words.gold + Wep::Gain_gold_phrase  if Wep::Things_to_show.include? :gold
   
    # Actors iteration
    for br_actor in @br.actors_data
     
        # Check diff so can gain levels or exp
        if br_actor.gained_levels > 0
         
          # LEVEL UP. If actived to show levelup, use configurated method
          if Wep::Things_to_show.include? :level_up
            if Wep::Show_levels_in_one_line
              @messages.push (br_actor.actor.name + ' ' + Wep::Gain_level_phrase +
              "(#{br_actor.gained_levels}).")
            else
              for lv in 0...br_actor.gained_levels
                @messages.push (br_actor.actor.name + ' ' + Wep::Gain_level_phrase)
              end
            end
          end
         
         
          # SKILL GAIN UP. If actived to show skill learn, use configurated method
          if Wep::Things_to_show.include? :gain_skill
             for skill_id in br_actor.gained_skills
                @messages.push (br_actor.actor.name + ' ' + Wep::Gain_skill_phrase + ' ' +
                   $data_skills[skill_id].name + '.')
              end
     
          end
       
        end
       
      i += 1
    end
 
    # Tesoros
    if Wep::Things_to_show.include? :treasures
      b = Hash.new(0) # use this hash to count duplicates
     
      # iterate over the array, counting duplicate entries
      @br.treasures.each do |v|
        b[v] += 1
      end
     
      b.each do |k, v|
        @messages.push k.name + '(' + v.to_s + ')' + Wep::Treasure_gain_phrase
      end
    end
 
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  # Refresh with new messages each time.
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @messages[@messages_index] != nil
      # Use lines configuration
      if Wep::Lines_to_show == 1
         self.contents.draw_text(0, 0, 640, 32, @messages[@messages_index])
      else
         for i in 0...Wep::Lines_to_show
           # It adds the line count to message index to show more lines
           if @messages[@messages_index + i] != nil
             self.contents.draw_text(0, i * 32, 640, 32, @messages[@messages_index + i])
           end
         end
      end
      @messages_index += Wep::Lines_to_show
    end
    # When false, it will end battle
    if @messages_index >= @messages.size - 1
      return false
    else
      return true
    end
  end
 
end
 
 
module Wep
  Scripts_list = [] unless defined? Scripts_list
  Scripts_list.push ('Retro-Styled Battle Result Window')
end
 
 
#==============================================================================
# Battle Result
# By gerkrt/gerrtunk
# Version: 1.0
# License: GPL, credits
# Date: 22/08/2011
# IMPORTANT NOTE: to acces the more actualitzed or corrected version of this
# script check here: http://usuarios.multimania.es/kisap/english_list.html
#==============================================================================
 
=begin
 
--------Introduction-----------
 
I created this class so anyone can easily create a custom or more advanced
battle result window. This object gives you all the information need in a simplier
way and without a lot of trouble. It creates a array of party actors with:
 
-Array of learned skills ids of each actor
-Gained levels
-Actor referen ce
-Origin and ending exp and levels
-All the default info(gold,etc)
 
------Instructions-------------
 
You just need to give to it the initial levels of the party. For that, i put
here the sample code i use in scene battle start_phase5
 
    initial_levels = []
    for ac in $game_party.actors
      initial_levels.push (ac.level)
    end
   
    You only have to pass that array.
   
   
=end
 
 
 
ResultActor = Struct.new( :actor, :origin_level,  :gained_skills,
  :gained_levels)
 
class Battle_Result
 
  attr_reader :actors_data
  attr_reader :exp
  attr_reader :gold
  attr_reader :treasures
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(initial_levels, exp, gold, treasures)
    @actors_initals_levels = initial_levels
    @exp = exp
    @gold = gold
    @treasures = treasures
    @actors_data = []
    generate_data(initial_levels)
 
    #p @messages
  end
 
 
  #--------------------------------------------------------------------------
  # * Generate data
  # This method generates the object data.
  #--------------------------------------------------------------------------
  def generate_data(initial_levels)
    i = 0
    # Actors gain level
    for actor in $game_party.actors
      @actors_data.push (ResultActor.new(actor, initial_levels[i],  
      [], 0))
      count = 0
      # Valid actor?
      if actor.cant_get_exp? == false
        difference = actor.level - @actors_initals_levels[i]
        # Check diff so can gain levels or exp
        if difference > 0
         
          # LEVEL UP.
          @actors_data.last.gained_levels = difference
         
          # SKILL GAIN UP.
          for lv in 0...difference
            # If it have skills learning
            for lea in $data_classes[actor.class_id].learnings
              if lea.level ==  @actors_initals_levels[i] + lv
                @actors_data.last.gained_skills.push (lea.skill_id)
              end
            end
          end
        end
      end
      i += 1
    end
  end
 
end
 
 
 
module Wep
  Scripts_list = [] unless defined? Scripts_list
  Scripts_list.push ('Battle Result')
end
 
 
 
#==============================================================================
# ** Scene_Battle (part 1)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================
 
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias wep_rbr_sb_main main
  def main
    @br_mark_end = false
    wep_rbr_sb_main
  end
 
  #--------------------------------------------------------------------------
  # * Start After Battle Phase
  # moded to extract initial levels and call battle result
  #--------------------------------------------------------------------------
  def start_phase5
    # Obtain extra info for battle result object
    initial_levels = []
    for ac in $game_party.actors
      initial_levels.push (ac.level)
    end
    # Shift to phase 5
    @phase = 5
    # Play battle end ME
    $game_system.me_play($game_system.battle_end_me)
    # Return to BGM before battle started
    $game_system.bgm_play($game_temp.map_bgm)
    # Initialize EXP, amount of gold, and treasure
    exp = 0
    gold = 0
    treasures = []
    # Loop
    for enemy in $game_troop.enemies
      # If enemy is not hidden
      unless enemy.hidden
        # Add EXP and amount of gold obtained
        exp += enemy.exp
        gold += enemy.gold
        # Determine if treasure appears
        if rand(100) < enemy.treasure_prob
          if enemy.item_id > 0
            treasures.push($data_items[enemy.item_id])
          end
          if enemy.weapon_id > 0
            treasures.push($data_weapons[enemy.weapon_id])
          end
          if enemy.armor_id > 0
            treasures.push($data_armors[enemy.armor_id])
          end
        end
      end
    end
    # Treasure is limited to a maximum of 6 items
    treasures = treasures[0..5]
    # Obtaining EXP
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false
        last_level = actor.level
        actor.exp += exp
        if actor.level > last_level
          @status_window.level_up(i)
        end
      end
    end
    # Obtaining gold
    $game_party.gain_gold(gold)
    # Obtaining treasure
    for item in treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    # Make battle result
    br = Battle_Result.new(initial_levels, exp, gold, treasures)
    @result_window = Window_BattleResult.new(br)
    # Set wait count
    @phase5_wait_count = 100
  end
 
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  # moded so refresh battle result each time until it ends
  #--------------------------------------------------------------------------
  def update_phase5
    # If wait count is larger than 0
    if @phase5_wait_count > 0
      # Decrease wait count
      @phase5_wait_count -= 1
      # If wait count reaches 0
      if @phase5_wait_count == 0
        # Show result window
        @result_window.visible = true
        # Clear main phase flag
        $game_temp.battle_main_phase = false
        # Refresh status window
        @status_window.refresh
      end
      return
    end
   
   
 
    # If C button was pressed advance battleresutl info
    if Input.trigger?(Input::C)
 
     # Battle end only if +1 refresh of the window,so, the last have to
     # be pressed
     if @br_mark_end
       battle_end(0)
     end
     
     if not @result_window.refresh
       @br_mark_end = true
     end
     
    end
   
  end
end
 
 