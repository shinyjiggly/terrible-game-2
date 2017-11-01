
#==============================================================================
# Enhanced position system
# By gerkrt/gerrtunk, orochii, wecoc, pokepik
# Version: 1.0
# Licence: MIT, credits
# Date: 27/06/2012
#
# Translated to english by Orochii Zouveleki
# (dunno if Gerkt did another translation)
#==============================================================================
=begin
 
--------Introduction-----------
 
This system enhances the default use for the default positions (which are only
seeable on the database, Classes tab).
It adds the following features:

-You can create all the positions you want (name it stances, or whatever you like).
-A menu that permits to change them in-game.
-Positions affect character attributes, damage dealt/received when attacking and 
using skills, and the ratio for being targeted by enemies (used at the roulette
step).

--------Instructions-----------

To create a new position, you use the following "template". Or you can take as 
example the positions included here.

Copy the next for each position:

    :new_pos => {  
      :name => "New position",      
      :icon => "047-Skill04",
      :attacker_physic_damage_mod => 1.0,
      :attacker_skill_damage_mod => 1.0,
      :defender_physic_damage_mod => 1.0,
      :defender_skill_damage_mod => 1.0,
      :impact_rate_value => 2, # As default one
      :agi_mod =>  1.0,
      :str_mod =>  1.0,
      :dex_mod =>  1.0,
      :int_mod =>  1.0,
      :pdef_mod =>  1.0,
      :mdef_mod =>  1.0,
      :atk_mod =>  1.0,
      :eva_mod =>  1.0,
      :hit_mod =>  1.0,

    },
    
Care for the sintaxis, and make sure that the {} are on place.

Here a little description of what each thing does:

    :new_pos => {  # Internal ID for script usage. Use _ instead of spaces,
                    # and always have a ':' at start (ex. :your_pos)
      :name => "New position",  # Displayed name at the menu
      :icon => "047-Skill04", # Icon used to display the position at battle.
      # Damage multipliers
      :attacker_physic_damage_mod => 1.0, # Multiplier for attacking
      :attacker_skill_damage_mod => 1.0, # Multiplier for magic
      :defender_physic_damage_mod => 1.0, # Multiplier for defender
      :defender_skill_damage_mod => 1.0, # Multiplier for magic target
      :impact_rate_value => 2, # Target ratio (used to determine a random target for enemies),
                              # when higher, character gets targetted more often.
      # Attribute multipliers
      :agi_mod =>  1.0, # Agility
      :str_mod =>  1.0, # Strenght
      :dex_mod =>  1.0, # Dexterity
      :int_mod =>  1.0, # Inteligence
      :pdef_mod =>  1.0, # Physical defense
      :mdef_mod =>  1.0, # Magical defense
      :atk_mod =>  1.0,  # Attack
      :eva_mod =>  1.0,  # Evasion
      :hit_mod =>  1.0,  # Hit rate

    },

Finally, Default_position = :m, defines the default position for characters when
they're added to the party (new characters).

-----Commands for changing and getting positions----
Call this script to change the position:
a = $game_actors[XX]
a.changue_position(ZZ)

Where XX is the character ID on the database, and ZZ is the position identifier
(ex. :m).

To get the position:
$game_actors[XX].position

And to compare it inside fork conditions commands:
$game_actors[XX].position == :identificador

=end

module Wep
  Positions_types = {
    :f => {
      :name => "Front",
      :icon => "048-Skill05",
      :attacker_physic_damage_mod => 1.5,
      :attacker_skill_damage_mod => 1.0,
      :defender_physic_damage_mod => 0.5,
      :defender_skill_damage_mod => 1.0,
      :impact_rate_value => 4, 
      :agi_mod =>  1.0,
      :str_mod =>  1.25,
      :dex_mod =>  1.0,
      :int_mod =>  1.0,
      :pdef_mod =>  1.0,
      :mdef_mod =>  1.0,
      :atk_mod =>  1.0,
      :eva_mod =>  1.0,
      :hit_mod =>  1.5,

    },
    
    :m => {
      :name => "Mid",
      :icon => "049-Skill06",
      :attacker_physic_damage_mod => 1.0,
      :attacker_skill_damage_mod => 1.0,
      :defender_physic_damage_mod => 1.0,
      :defender_skill_damage_mod => 1.0,
      :impact_rate_value => 3, 
      :agi_mod =>  1.25,
      :str_mod =>  1.0,
      :dex_mod =>  1.0,
      :int_mod =>  1.0,
      :pdef_mod =>  1.0,
      :mdef_mod =>  1.0,
      :atk_mod =>  1.0,
      :eva_mod =>  1.25,
      :hit_mod =>  1.25
    },
    
    :d => {
      :name => "Back",      
      :icon => "047-Skill04",
      :attacker_physic_damage_mod => 0.5,
      :attacker_skill_damage_mod => 1.0,
      :defender_physic_damage_mod => 1.5,
      :defender_skill_damage_mod => 1.0,
      :impact_rate_value => 2, 
      :agi_mod =>  1.0,
      :str_mod =>  1.0,
      :dex_mod =>  1.25,
      :int_mod =>  1.5,
      :pdef_mod =>  1.0,
      :mdef_mod =>  1.0,
      :atk_mod =>  1.0,
      :eva_mod =>  1.0,
      :hit_mod =>  1.0,

    },
  
  }
  
  
  Default_position = :m
end


#=============================================================
# Sistema de posiciones Simple by Pokepik
#=============================================================
#=============================================================
# Game_Actor (Orochii Zouveleki, Pokepik)
#=============================================================

class Game_Actor
  attr_accessor :position
 
  alias ozrow_setup setup unless $@
  def setup(actor_id)
    ozrow_setup(actor_id)
    @position = Wep::Default_position #$data_classes[@class_id].position
  end
 
  def position
    return @position
  end
  
  def change_position
    @position = @position == 0 ? 2 : 0
  end
  
  def change_position(pos) # ((pos va de 0 a 2))
    @position = pos
  end
end

#=============================================================
# Game_Party (Orochii Zouveleki)
#=============================================================

class Game_Party
  def random_target_actor(hp0 = false)
    roulette = []
    for actor in @actors
      if (not hp0 and actor.exist?) or (hp0 and actor.hp0?)
        position = actor.position
        n = Wep::Positions_types[position][:impact_rate_value]
        n.times do
          roulette.push(actor)
        end
      end
    end
    if roulette.size == 0
      return nil
    end
    return roulette[rand(roulette.size)]
  end
end

#==============================================================================
# ** Scene_Menu
#==============================================================================

class Scene_Menu
  def main
    s1 = $data_system.words.item
    s2 = $data_system.words.skill
    s3 = $data_system.words.equip
    s4 = "Status"
    s5 = "Positions"
    s6 = "Save"
    s7 = "Exit"
    @command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s6, s7])
    @command_window.index = @menu_index
    if $game_party.actors.size == 0
      @command_window.disable_item(0)
      @command_window.disable_item(1)
      @command_window.disable_item(2)
      @command_window.disable_item(3)
      @command_window.disable_item(4)
    end
    if $game_system.save_disabled
      @command_window.disable_item(5)
    end
    @playtime_window = Window_PlayTime.new
    @playtime_window.x = 0
    @playtime_window.y = 256
    @steps_window = Window_Steps.new
    @steps_window.x = 0
    @steps_window.y = 320
    @gold_window = Window_Gold.new
    @gold_window.x = 0
    @gold_window.y = 416
    @status_window = Window_MenuStatus.new
    @status_window.x = 160
    @status_window.y = 0
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @command_window.dispose
    @playtime_window.dispose
    @steps_window.dispose
    @gold_window.dispose
    @status_window.dispose
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update (when command window is active)
  #--------------------------------------------------------------------------
  def update_command
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # If command other than save or end game, and party members = 0
      if $game_party.actors.size == 0 and @command_window.index < 4
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end

      # Branch by command window cursor position
      case @command_window.index
      when 0  # item
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to item screen
        $scene = Scene_Item.new
      when 1  # skill
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 2  # equipment
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 3  # status
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 4  # pos
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 5  # save
        # If saving is forbidden
        if $game_system.save_disabled
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to save screen
        $scene = Scene_Save.new
      when 6  # end game
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to end game screen
        $scene = Scene_End.new
      end
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update (when status window is active)
  #--------------------------------------------------------------------------
  def update_status
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Make command window active
      @command_window.active = true
      @status_window.active = false
      @status_window.index = -1
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by command window cursor position
      case @command_window.index
      when 1  # skill
        # If this actor's action limit is 2 or more
        if $game_party.actors[@status_window.index].restriction >= 2
          # Play buzzer SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to skill screen
        $scene = Scene_Skill.new(@status_window.index)
      when 2  # equipment
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to equipment screen
        $scene = Scene_Equip.new(@status_window.index)
      when 3  # status
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to status screen
        $scene = Scene_Status.new(@status_window.index)
      when 4  # pos
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to status screen
        $scene = Scene_Position.new(@status_window.index)
      end

      return
    end
  end

end

#==============================================================================
# ** Scene_Position
#==============================================================================

class Scene_Position
  
  def initialize(actor_index = 0)
    @actor_index = actor_index
    @positions_keys = Wep::Positions_types.keys
  end
  
  def main
    s_list = []
    for key in @positions_keys 
      s_list.push Wep::Positions_types[key][:name]
    end
    @actor = $game_party.actors[@actor_index]
    s1 = "Front"
    s2 = "Mid"
    s3 = "Back"
    
    @command_window = Window_Command.new(192, s_list)
    @command_window.x = 320 - @command_window.width / 2
    @command_window.y = 240 - @command_window.height / 2
    
    # Make help window
    #@help_window = Window_Help.new
    #@command_window.help_window = @help_window

    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @command_window.dispose
  end
  
  def update
    @command_window.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Menu.new(3)
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      @actor.change_position(@positions_keys[@command_window.index])
      $scene = Scene_Menu.new(3)
      return
    end
  end
end

#==============================================================================
# Window_Base
#==============================================================================

class Window_Base < Window
  def draw_actor_position(actor, x, y)
    n = Wep::Positions_types[actor.position][:icon] 
    bitmap = RPG::Cache.icon(n)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
  end
  def draw_actor_name_pos(actor,x,y)
    draw_actor_position(actor, x+236, y)
    draw_actor_name(actor, x, y)
  end
end


#==============================================================================
# Window_MenuStatus
#==============================================================================

class Window_MenuStatus < Window_Selectable
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_position(actor, x+236, y)      
      draw_actor_graphic(actor, x - 40, y + 80)
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x + 90, y + 32)
      draw_actor_exp(actor, x, y + 64)
      draw_actor_hp(actor, x + 236, y + 32)
      draw_actor_sp(actor, x + 236, y + 64)
    end
  end
end

#==============================================================================
# Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Base
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actor_x = i * 160 + 4
      draw_actor_position(actor, actor_x + 92, 0)
      draw_actor_name(actor, actor_x, 0)
      draw_actor_sp(actor, actor_x, 64, 120)
      if @level_up_flags[i]
        self.contents.font.color = normal_color
        self.contents.draw_text(actor_x, 96, 120, 32, "¡Sube Nivel!")
      else
        draw_actor_state(actor, actor_x, 96)
      end
    end
  end
end

#==============================================================================
# ** Window_PlayTime
#------------------------------------------------------------------------------
#  Modified
#==============================================================================
 
class Window_PlayTime < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 160, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @total_sec = Graphics.frame_count / Graphics.frame_rate
    hour = @total_sec / 60 / 60
    min = @total_sec / 60 % 60
    sec = @total_sec % 60
    text = sprintf("%02d:%02d:%02d", hour, min, sec)
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 0, 120, 32, text, 2) # 4, -5 120, 32
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if Graphics.frame_count / Graphics.frame_rate != @total_sec
      refresh
    end
  end
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # Definição da Base de pdef
  #--------------------------------------------------------------------------
  alias base_pdef_wep_pos_sys base_pdef unless $@
  def base_pdef
    n = base_pdef_wep_pos_sys 
    n *= Wep::Positions_types[@position][:pdef_mod]
    return [[n, 1].max, 999].min
  end
  
  #--------------------------------------------------------------------------
  # Definição da Base de mdef
  #--------------------------------------------------------------------------
  alias base_mdef_wep_pos_sys base_mdef unless $@
  def base_mdef
    n = base_mdef_wep_pos_sys 
    n *= Wep::Positions_types[@position][:mdef_mod]
    return [[n, 1].max, 999].min
  end

  #--------------------------------------------------------------------------
  # Definição da Base de atk
  #--------------------------------------------------------------------------
  alias base_atk_wep_pos_sys base_atk unless $@
  def base_atk(w=0)
    n = base_atk_wep_pos_sys(w)
    n *= Wep::Positions_types[@position][:atk_mod]
    return [[n, 1].max, 999].min
  end
  
    #--------------------------------------------------------------------------
  # Definição da Base de hit
  #--------------------------------------------------------------------------
  alias hit_wep_pos_sys hit unless $@
  def hit
    n = hit_wep_pos_sys 
    n *= Wep::Positions_types[@position][:hit_mod]
    return Integer(n)
  end

      #--------------------------------------------------------------------------
  # Definição da Base de eva
  #--------------------------------------------------------------------------
  alias eva_wep_pos_sys eva unless $@
  def eva
    n = eva_wep_pos_sys 
    n *= Wep::Positions_types[@position][:eva_mod]
    return Integer(n)
  end
  

  #--------------------------------------------------------------------------
  # Definição da Base de str
  #--------------------------------------------------------------------------
  alias base_str_wep_pos_sys base_str unless $@
  def base_str
    n = base_str_wep_pos_sys 
    n *= Wep::Positions_types[@position][:str_mod]
    return [[n, 1].max, 999].min
  end
  
  #--------------------------------------------------------------------------
  # Definição da Base de Agi
  #--------------------------------------------------------------------------
  alias base_agi_wep_pos_sys base_agi unless $@
  def base_agi
    n = base_agi_wep_pos_sys 
    n *= Wep::Positions_types[@position][:agi_mod]
    return [[n, 1].max, 999].min
  end
  
    #--------------------------------------------------------------------------
  # Definição da Base de Int
  #--------------------------------------------------------------------------
  alias base_int_wep_pos_sys base_int unless $@
  def base_int
    n = base_int_wep_pos_sys 
    n *= Wep::Positions_types[@position][:int_mod]
    return [[n, 1].max, 999].min
  end
  
    #--------------------------------------------------------------------------
  # Definição da Base de Dex
  #--------------------------------------------------------------------------
  alias base_dex_wep_pos_sys base_dex unless $@
  def base_dex
    n = base_dex_wep_pos_sys 
    n *= Wep::Positions_types[@position][:dex_mod]
    return [[n, 1].max, 999].min
  end
end

class Game_Battler
    #--------------------------------------------------------------------------
  # * Applying Normal Attack Effects
  #    attacker : battler
  #--------------------------------------------------------------------------
  def attack_effect(attacker,w=0)
    # Clear critical flag
    self.critical = false
    # First hit detection
    hit_result = (rand(60) < (attacker.hit*3 -self.eva/2))
    # If hit occurs
    total_damage = 0
    
    if hit_result == true
      for i in 0..attacker.hit_num
        # Calculate basic damage
        #atk = [attacker.atk - self.pdef / 2, 0].max
        #self.damage = atk * (20 + attacker.str) / 20
        if attacker.is_a?(Game_Enemy)
          attack=(attacker.atk(w)*4+attacker.str)-self.dex
          self.damage=(attacker.level*attacker.level*attack)/512
        else
          #STEP 0.Calculate weapon level
          weapon_type = $data_weapons[attacker.weapon_id(-1)[w]].element_set
          t_level = attacker.w_level[weapon_type[0]]
          t_level *= (2+t_level)/3
          #STEP 1.Calculate vigor
          vigor2=[(attacker.str*2),255].min
          attack=[(attacker.atk(w)+vigor2)-(self.dex/2),1].max
          attack+=attacker.atk(w)*3/4 if attacker.armor4_id(-1).include?(1) #Gauntlet
          self.damage=attacker.atk(w)+((t_level*t_level*attack)/256)*3/2
          self.damage/=2 if attacker.armor4_id(-1).include?(2) #Offering
          wep_check=attacker.weapon_id(-1)
          wep_num = 0
          for i in attacker.weapon_id(-1)
            wep_num+=1 if wep_check[i]!=0
          end
          self.damage*=3/4 if (wep_num<=1) and attacker.armor4_id(-1).include?(3) #GenjiGlove
          
          #STEP 2. "Atlas Armlet"/"Hero Ring"
          extra = 0
          extra += self.damage/4 if attacker.armor4_id(0) != nil && ($data_armors[attacker.armor4_id(0)].guard_element_set.include?(RPG::PHYSICAL_BOOST))
          extra += self.damage/4 if attacker.armor4_id(1) != nil && ($data_armors[attacker.armor4_id(1)].guard_element_set.include?(RPG::PHYSICAL_BOOST))
          self.damage += extra
          #ASDTsutarja2525
        end
        
        self.damage *= (6.0 - (attacker.level/attacker.maxlevel*1.0))/6
        
        self.damage*= [2.0/(attacker.hit_num+1),1].min
        a = (30*(attacker.maxlevel-attacker.level)/attacker.maxlevel)
        self.damage = (self.damage*((70+a)/100.0)).floor#(self.damage*attacker.level / 64.0).floor #if skill.atk_f > 0
        
        self.damage = Integer(self.damage)
        # Element correction
        self.damage *= elements_correct(attacker.element_set)
        self.damage /= 100
        # If damage value is strictly positive
        if self.damage > 0
          # Critical correction
          if rand(100) < 4 * (attacker.dex / self.dex)+(attacker.level - self.level)
            self.damage *= 2
            self.critical = true
          end
          # Guard correction
          if self.guarding?
            self.damage /= 2
          end
          # Positions corrections
          if self.is_a?(Game_Actor)
            self.damage *= Wep::Positions_types[self.position][:defender_physic_damage_mod]
          end
          
          # Positions corrections
          if attacker.is_a?(Game_Actor)
            self.damage *= Wep::Positions_types[self.position][:attacker_physic_damage_mod]
          end
          
          #STEP 5. Damage Mult#1
          mult=0
          mult+=2 if attacker.states.include?(RPG::SPEC_STATES[4])
          #mult+=1 if user.states.include?(20)
          n = rand(32)
          mult+=2 if n==1
          self.damage *= (2+mult)/2
        
        end
        self.damage /= [attacker.hit_num/3,1].max
        #STEP 6. Damage modification
        # Dispersion
        if self.damage.abs > 0
          n = rand(31) + 224
          self.damage = (self.damage*n / 256) + 1
          self.damage = (self.damage*(255-self.pdef)/256)+1
          #14: Protect
          self.damage = (self.damage*170/256)+1 if self.states.include?(RPG::SPEC_STATES[0])
        end
        #Step 7.
      
        #self.damage *= 3/2 if self.states.include?(xx) #Attacked from behind <-it needs pincers and those stuff to work!!
        #STEP 8. Petrify damage
        self.damage = 0 if self.states.include?(RPG::SPEC_STATES[5]) #Petrify status
      # Second hit detection
      #  eva = 8 * self.agi / attacker.dex + self.eva
      #  hit = attacker.hit*1.5 - eva
      #  hit = self.cant_evade? ? 100 : hit
      #  hit_result = (rand(100) < hit)
        blockValue = [[(255 - self.eva*2)+1,1].max,255].min
        r = rand(99)
        hit_result = (attacker.hit * blockValue / 256 ) > r
        
      #TODO: Attack "from behind" support
        hit_result = true if self.restriction == 4
        hit_result = true if attacker.hit==255
        
        if self.states.include?(RPG::SPEC_STATES[7])
          hit_result = false 
          remove_states_shock
        end
        
        hit_result = false if self.states.include?(RPG::SPEC_STATES[6]) #Clear
        hit_result = true if attacker.element_set.include?(RPG::SKILL_TAGS[1])
        hit_result = false if attacker.element_set.include?(RPG::SKILL_TAGS[0]) and self.state_ranks[1]==6
        total_damage +=self.damage
      end
    end
    self.damage = total_damage
    # If hit occurs
    if hit_result == true
      # State Removed by Shock
      remove_states_shock
      # Substract damage from HP
      self.damage = self.damage.floor
      self.damage = [self.damage, 9999].min
      self.hp -= self.damage
      # State change
      @state_changed = false
      states_plus(attacker.plus_state_set)
      states_minus(attacker.minus_state_set)
    # When missing
    else
      # Set damage to "Miss"
      self.damage = "Miss"
      # Clear critical flag
      self.critical = false
    end
    # End Method
    return true
  end
  #--------------------------------------------------------------------------
  # * Apply Skill Effects
  #    user  : the one using skills (battler)
  #    skill : skill
  #--------------------------------------------------------------------------
  def skill_effect(user, skill,w=0)
    # Clear critical flag
    self.critical = false
    # If skill scope is for ally with 1 or more HP, and your own HP = 0,
    # or skill scope is for ally with 0, and your own HP = 1 or more
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
      ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      # End Method
      return false
    end
    # Clear effective flag
    effective = false
    # Set effective flag if common ID is effective
    effective |= skill.common_event_id > 0
    # First hit detection
    hit = skill.hit
    if skill.atk_f > 0
      hit = (user.hit*hit)/100
    end
    hit_result = (rand(60) < (hit*3 -self.eva/2))
    # Set effective flag if skill is uncertain
    effective |= hit < 100
    # If hit occurs
    if hit_result == true
      # Calculate power
      #STEP 1.Calculate power
      power = (skill.power + user.atk(w) * skill.atk_f / 100) #*user.level
      power = (power*(32+user.level) / 64.0).floor if skill.atk_f > 0
      power *= (1+(user.level/33.0)).floor if skill.atk_f > 0      
      
      # Calculate rate
      rate = 20
      rate += (user.str * skill.str_f / 100)
      rate += (user.dex * skill.dex_f / 100)
      rate += (user.agi * skill.agi_f / 100)
      # Calculate basic damage
      skill_power = power * rate / 20
      magic_power = (user.int * skill.int_f / 100)
      total_damage= 0
      if user.is_a?(Game_Enemy)
        total_damage = skill_power*4 + (user.level*(magic_power*3/2)*skill_power/32)
      else
      #STEP "0".Weapon level
        weapon_type = $data_weapons[attacker.weapon_id(-1)[w]].element_set
        t_level = user.w_level[weapon_type[0]]
        t_level *= (2+t_level)/3
        
        total_damage = skill_power*4 + (t_level*(magic_power)*skill_power/32)
      #STEP 2. Earring / Hero Ring
        extra = 0
        extra += total_damage/4 if user.armor4_id(0) != nil && ($data_armors[user.armor4_id(0)].guard_element_set.include?(RPG::MAGICAL_BOOST))
        extra += total_damage/4 if user.armor4_id(1) != nil && ($data_armors[user.armor4_id(1)].guard_element_set.include?(RPG::MAGICAL_BOOST))
        total_damage += extra
      end
      
      total_damage *= 1.5 if skill.atk_f == 0
      total_damage *= 1 + (100-user.level)/100.0 if skill.atk_f > 0
      
      # Element correction
      #if power > 0
      #  power -= self.pdef * skill.pdef_f / 200
      #  power -= self.mdef * skill.mdef_f / 200
      #  power = [power, 0].max
      #end
      #STEP 3. Multiple targets
      self.damage = total_damage
      self.damage /= 2 if [2,4,6].include?(skill.scope)
      
      self.damage *= elements_correct(skill.element_set)
      self.damage /= 100
      # If damage value is strictly positive
      if self.damage > 0
        # Guard correction
        if self.guarding?
          self.damage /= 2
        end
        #STEP 4. Attacker's row
        # Positions corrections
        if self.is_a? Game_Actor
          self.damage *= Wep::Positions_types[self.position][:defender_skill_damage_mod]
        end
        
        # Positions corrections
        if user.is_a? Game_Actor
          self.damage *= Wep::Positions_types[self.position][:attacker_skill_damage_mod]
        end
        
        #STEP 5. Damage Mult#1
        mult=0
        mult+=2 if user.states.include?(RPG::SPEC_STATES[4])
        #mult+=1 if user.states.include?(20)
        n = rand(32)
        mult+=2 if n==1
        self.damage *= (2+mult)/2
        
        self.damage /=2 if (self.is_a?(Game_Actor) and user.is_a?(Game_Actor))
      end
      # Dispersion
      if skill.variance > 0 and self.damage.abs > 0
        var= (255 * (skill.variance/100.0)).floor
        n = rand(var) + (256-var)
        self.damage = (self.damage*n / 256) + 1
        self.damage = (self.damage*(255-self.mdef)/256)+1
        #15: Shell
        self.damage = (self.damage*170/256)+1 if self.states.include?(RPG::SPEC_STATES[1])
        self.damage /= 2 if self.states.include?(RPG::SPEC_STATES[4])
      end
      #Step 7.
      
      #self.damage *= 3/2 if self.states.include?(xx) #Attacked from behind <-it needs pincers and those stuff to work!!
      #STEP 8. Petrify damage
      self.damage = 0 if self.states.include?(RPG::SPEC_STATES[5]) #Petrify status
      
      # Second hit detection
      
      #eva = 8 * self.agi / user.dex + self.eva
      #hit = user.hit*1.5 - eva * skill.eva_f / 100
      #hit = self.cant_evade? ? 100 : hit
      #hit_result = (rand(100) < hit)
      eva_val = skill.atk_f > 0 ? self.eva : self.m_eva
      blockValue = [[(255 - eva_val*2)+1,1].max,255].min
      r = rand(99)
      hit_result = (user.hit * blockValue / 256 ) > r
      
      hit_result = true if self.restriction == 4
      hit_result = true if user.hit==255
      
      hit_result = true if self.states.include?(RPG::SPEC_STATES[6])
      
      hit_result = true if skill.element_set.include?(RPG::SKILL_TAGS[1])
      hit_result = false if skill.element_set.include?(RPG::SKILL_TAGS[0]) and self.state_ranks[1]==6
      
      # Set effective flag if skill is uncertain
      effective |= hit < 100
    end
    # If hit occurs
    if hit_result == true
      # If physical attack has power other than 0
      if skill.power != 0 and skill.atk_f > 0
        # State Removed by Shock
        remove_states_shock
        # Set to effective flag
        effective = true
      end
      # Substract damage from HP
      last_hp = self.hp
      self.damage = self.damage.floor
      self.damage = [self.damage, 9999].min
      self.hp -= self.damage
      effective |= self.hp != last_hp
      # State change
      @state_changed = false
      effective |= states_plus(skill.plus_state_set)
      effective |= states_minus(skill.minus_state_set)
      # If power is 0
      if skill.power == 0
        # Set damage to an empty string
        self.damage = ""
        # If state is unchanged
        unless @state_changed
          # Set damage to "Miss"
          self.damage = "Miss"
        end
      end
    # If miss occurs
    else
      # Set damage to "Miss"
      self.damage = "Miss"
    end
    # If not in battle
    unless $game_temp.in_battle
      # Set damage to nil
      self.damage = nil
    end
    # End Method
    return effective
  end

end
