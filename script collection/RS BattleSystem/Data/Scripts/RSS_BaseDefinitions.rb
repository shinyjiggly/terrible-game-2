#============================================================
#-- BASIC DEFINITIONS for RomancingSaga-like Battle System --
#============================================================
#By Orochii Zouveleki C:.
#
# · Distribute freely, and for use on any game, doen't matters if is
# commercial.
# · Accreditations aren't necessary either. I DON'T CARE. But don't claim
# this as yours!
#       But if you want to thank me, you can share with me
#       a free copy of your game =D. Either if commercial or not.
#       I'll be pleased to see that this helped someone, and how
#       it was used.

=begin 
=============================================================
========================Classes Index========================
=============================================================

#----------------------------------------------
#Basic definitions. Data behaviour definitions.
#----------------------------------------------
module RPG
  def self.weapon_types
  
  class Weapon
    def weight
    def skill_cats
  
  class Armor
    def weight
  
  class Skill
    def skill_cat
    def skill_cats
      
  class Sprite < ::Sprite
    def animation_set_sprites(sprites, cell_data, position,offsetX=0,offsetY=0)
      
class Game_System
  attr_accessor :victory_bgm
  alias ozrssgs_initialize initialize unless $@
  def initialize

class Game_Battler
  attr_accessor :state_animation_id
  attr_accessor :collapse_type
  attr_accessor :curr_weap
  attr_accessor :last_index
  attr_reader   :lp
  attr_accessor :height
  alias ozrssgm_initialize initialize unless $@
  def initialize
  def maxlevel
  def change_lp(lp)
  def hp=(hp)
  alias ozrss_remove_state remove_state
  def remove_state(state_id, force = false)
  def hit(w=0)
  def atk(w=0)
  def eva
  def m_eva
  def hit_num
  def hit_mult
  def attack_effect(attacker,w=0)
  def skill_effect(user, skill,w=0)
  def w_raise_exp(scope)
  def attacking?

class Game_Actor < Game_Battler
  def weapon_id=(n)
  def weapon_id(x,n)
  def weapon_id(a=0)
  def armor4_id=(n)
  def armor4_id(x,n)
  def armor4_id(a=0)
  def setup(actor_id)
  def maxlp
  def base_maxlp
  def make_exp_list
  def make_wexp_list
  def element_rate(element_id)
  def state_guard?(state_id)
  def element_set(w=0)
  def plus_state_set(w=0)
  def minus_state_set(w=0)
  def base_maxhp
  def initialize_gains
  def hp_gain(lvl=@level)
  def base_maxsp
  def mp_gain(lvl=@level)
  def base_str
  def base_dex
  def base_agi
  def base_int
  def base_atk(w=0)
  def base_pdef
  def base_mdef
  def base_eva
  def hit(w=0)
  def hit_num
  def animation1_id(w=0)
  def animation2_id(w=0)
  def equip(equip_type, id)
  def exp=(exp)
  def level=(level)
  def w_level=(type, level)
  def ch_w_exp(type, exp)
  def ch_w_level_status
  def check_skill_learn(type)
  def learn_flag_off
  def class_id=(class_id)
  def w_raise_exp(scope)

class Game_Enemy < Game_Battler
  def initialize(troop_id, member_index, raise=0)
  def position
  def maxlp
  def base_maxlp
  def id
  def index
  def name
  def base_maxhp
  def base_maxsp
  def base_str
  def enemy_kind
  def base_dex
  def base_agi
  def base_int
  def base_atk(w=0)
  def base_pdef
  def base_mdef
  def base_eva
  def level
  def m_eva
  def animation1_id(w=0)
  def animation2_id(w=0)
  def element_rate(element_id)
  def state_ranks
  def state_guard?(state_id)
  def element_set
  def plus_state_set
  def minus_state_set
  def actions
  def exp
  def gold
  def item_id
  def weapon_id
  def armor_id
  def treasure_prob
  def screen_x
  def screen_y
  def screen_z
  def escape
  def transform(enemy_id)
  def make_action

class Game_Party
  attr_accessor :entered_battles
  alias ozrssgp_initialize initialize unless $@
  def initialize
  alias ozrssgp_setup_starting_members setup_starting_members
  def setup_starting_members
  def setup_battle_test_members
  def setup_starting_formations
  def add_formation(new)
  def remove_formation(old)
  def available_formation_names
  def available_formations
  def change_positions
  def global_level
  alias ozrssgp_refresh refresh unless $@
  def refresh
  def add_actor(actor_id)
  alias ozrssgp_remove_actor remove_actor unless $@
  def remove_actor(actor_id)

class Game_Troop
  def setup(troop_id)

class Sprite_Battler < RPG::Sprite
  def initialize(viewport, battler = nil)
  def dispose
  def update

class Spriteset_Battle
  def initialize
  alias ozrsssba_update update unless $@
  def update

#--------------------------------------
#Basic definitions. Window definitions.
#--------------------------------------

class Window_Base < Window
  alias ozrsswb_initialize initialize unless $@
  def initialize(x, y, width, height)
  alias ozrsswb_dispose dispose unless $@
  def dispose
  def customback_init(name,fix_x,fix_y)
  def self_opacity=n
  def visible=(n)
  def draw_icon(icon, x, y)
  def draw_actor_hp(actor, x, y, width = 144)
  def draw_actor_sp(actor, x, y, width = 144)
  def draw_actor_lp(actor, x, y, width = 144)
  def draw_actor_parameter(actor, x, y, type,w=0,width=120)
  def draw_actor_weaponlevel(actor, x, y, num,width=120)
  def draw_actor_magiclevel(actor, x, y, num,width=120)
  def draw_face(name,x,y)
  def draw_actor_face(actor,x,y)

class Window_Command < Window_Selectable
  attr_accessor :commands
  attr_accessor :align
  alias wc_init initialize
  def initialize(width, commands, align)
  def draw_item(index, color)
  def reset_item_max(max_size=480)

class Window_Item < Window_Selectable
  alias ozrsswi_initialize initialize unless $@
  def initialize
  def refresh
  def draw_item(index)

class Window_Help < Window_Base
  def draw_mp(actor)

class Window_EquipLeft < Window_Base
  def initialize(actor)
  def refresh(w=0)

class Window_EquipRight < Window_Selectable
  def initialize(actor)
  def refresh

class Window_EquipItem < Window_Selectable
  def initialize(actor, equip_type)
  def draw_item(index)

class Window_MenuStatus < Window_Selectable
  def refresh

class Window_Status < Window_Base
  def refresh
  def dummy

class Window_PartyCommand < Window_Selectable
  def initialize

class Window_BattleResult < Window_Base
  def initialize(exp, gold, treasures)
  def refresh

class Window_Formation < Window_Command
  def initialize(width)
  def selected_formation
  def active_index

class Window_BattleStatus < Window_Base
  def initialize
  def dispose
  def level_up(actor_index, text=[])
  def new_skill(actor_index)
  def restore_levelup_info
  def refresh
  def set_bulb(i)
  def update
    
#---------------------------------------------------------
#Basic definitions. Other interactive objects definitions.
#---------------------------------------------------------

class Arrow_Base < Sprite
  def update

class Arrow_Enemy < Arrow_Base
  def update
  def check_hypo_dist(indexes)
  def hypo_distance(x,y)
  def get_dir(angle)
  def calc_rad(x,y)

class Arrow_Actor < Arrow_Base
  def initialize(viewport)
  def index=(val)
  def f_matrix
  def search_vert(down=false,both=false)
  def search_horiz(right=false)
  def search_specific(number)
  def update

##
class Interpreter
  def recover_all_lp
  def victory_bgm=(name)

#-----------------------------------------------
#Basic definitions. Special screens definitions.
#-----------------------------------------------

class Scene_Equip
  def refresh(w=0)
  def update
  def update_right

class Scene_Formations
  def main
  def update

class Scene_Menu
  def main
  def update_command
  def update_status
=end

#----------------------------------------------
#Basic definitions. Data behaviour definitions.
#----------------------------------------------

module RPG
  
  def self.weapon_types
    return SKILL_CAT + [HIT_CAT]
  end
  
  class Weapon
    def weight
      return [(pdef-mdef),0].max
    end
    
    def skill_cats
      cats = []
      for i in element_set
        cats.push(i) if SKILL_CAT.include?(i)
        cats.push(i) if HIT_CAT == i
      end
      return cats
    end
  end
  
  class Armor
    def weight
      return [(pdef-mdef),0].max
    end
  end
  
  class Skill
    def skill_cat
      for i in SKILL_CAT
        return i if element_set.include?(i)
      end
      return HIT_CAT if element_set.include?(HIT_CAT)
      return MAGIC_CAT if element_set.include?(MAGIC_CAT)
    end
    def skill_cats
      cats = []
      for i in element_set
        cats.push(i) if SKILL_CAT.include?(i)
        cats.push(i) if MAGIC_LEVELS.include?(i)
        cats.push(i) if HIT_CAT == i
      end
      cats
    end
  end
  #This part can be examinated much more (animations have a lot of potential!)
  #I already added the offset, which could be used for setting a "moving" animation
  #from a custom origin spot (ex.: a fireball from the user).
  class Sprite < ::Sprite
    def animation_set_sprites(sprites, cell_data, position,offsetX=0,offsetY=0)
      for i in 0..15
        sprite = sprites[i]
        pattern = cell_data[i, 0]
        if sprite == nil or pattern == nil or pattern == -1
          sprite.visible = false if sprite != nil
          next
        end
        sprite.visible = true
        sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
        if position == 3
          sprite.x = 320
          sprite.y = 240
        else
          sprite.x = self.x - self.ox + self.src_rect.width / 2
          sprite.y = self.y - self.oy + self.src_rect.height / 2
          sprite.y -= self.src_rect.height / 4 if position == 0
          sprite.y += self.src_rect.height / 4 if position == 2
        end
        sprite.x += cell_data[i, 1]
        sprite.y += cell_data[i, 2]
        sprite.x += offsetX
        sprite.y += offsetY
        sprite.z = 2000
        sprite.ox = 96
        sprite.oy = 96
        sprite.zoom_x = cell_data[i, 3] / 100.0
        sprite.zoom_y = cell_data[i, 3] / 100.0
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
        sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
        sprite.blend_type = cell_data[i, 7]
      end
    end
  end
end
class Game_System
  attr_accessor :victory_bgm
  alias ozrssgs_initialize initialize unless $@
  def initialize
    ozrssgs_initialize 
    @victory_bgm = RPG::VICTORY_BGM
  end
end
#==============================================================================
# ** Game_Battler (part 1)
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  
  attr_accessor :state_animation_id
  attr_accessor :collapse_type
  attr_accessor :curr_weap
  attr_accessor :last_index
  attr_reader   :lp
  attr_accessor :height
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ozrssgm_initialize initialize unless $@
  def initialize
    ozrssgm_initialize
    @state_animation_id = 0
    @collapse_type = 0
    @curr_weap = 0
    @last_index = 0
    @lp = 1
    @height = 0
  end
  
  def maxlevel
    return 118
  end
  
  #--------------------------------------------------------------------------
  # * Change LP
  #     lp : new LP
  #--------------------------------------------------------------------------
  def change_lp(lp)
    @lp = [[@lp+lp, maxlp].min, 0].max
    # add or exclude incapacitation
    #if @lp == 0 && self.is_a?(Game_Actor)
      #$game_party.remove_actor(id)
    #end
  end
  
  #--------------------------------------------------------------------------
  # * Change HP
  #     hp : new HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    return if @lp==0 && self.is_a?(Game_Actor)
    @hp = [[hp, maxhp].min, 0].max
    # add or exclude incapacitation
    for i in 1...$data_states.size
      if $data_states[i].zero_hp
        if self.dead?
          add_state(i)
          change_lp(-1)
        else
          remove_state(i)
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Remove State
  #     state_id : state ID
  #     force    : forcefully removed flag (used to deal with auto state)
  #--------------------------------------------------------------------------
  alias ozrss_remove_state remove_state
  def remove_state(state_id, force = false)
    return if @lp==0 && self.is_a?(Game_Actor)
    ozrss_remove_state(state_id, force = false)
  end
  
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  def hit(w=0)
    n = 75+eva
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # * Get Attack Power
  #--------------------------------------------------------------------------
  def atk(w=0)
    n = base_atk(w)
    for i in @states
      n *= $data_states[i].atk_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # * Get Evasion Correction
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for i in @states
      n += $data_states[i].eva
    end
    return n
  end
  
  def m_eva
    n = eva*(int*1.0/str)
    return Integer(n)
  end
  
  def hit_num
    return [(1+((hit-25)/50))*hit_mult,1].max
  end
  
  def hit_mult
    n = 1
    n += 1 if @states.include?(RPG::SPEC_STATES[2])
    n -= 1 if @states.include?(RPG::SPEC_STATES[3])
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Applying Normal Attack Effects
  #    attacker : battler
  #--------------------------------------------------------------------------
  def attack_effect(attacker,w=0)
    # Clear critical flag
    self.critical = false
    # First hit detection
    hit_result = (rand(60) < (attacker.hit(w)*3 -self.eva/2))
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
          #STEP 1.
          vigor2=[(attacker.str*2),255].min
          attack=[(attacker.atk(w)+vigor2)-(self.dex/2),1].max
          gaunt=offer=false
          attacker.armor4_id(-1).each{|id|
            next if id==0
            gaunt = true if $data_armors[id].guard_element_set.include?(RPG::SPEC_ACCESSORIES[0])
            offer = true if $data_armors[id].guard_element_set.include?(RPG::SPEC_ACCESSORIES[1])
          }
          attack+=attacker.atk(w)*3/4 if gaunt #Gauntlet
          self.damage=attacker.atk(w)+((t_level*t_level*attack)/256)*3/2
          self.damage/=2 if offer #Offering
          wep_check=attacker.weapon_id(-1)
          wep_num = 0
          for i in attacker.weapon_id(-1)
            wep_num+=1 if wep_check[i]!=0
          end
          self.damage*=3/4 if (wep_num<=1) and attacker.armor4_id(-1).include?(3) #GenjiGlove
          #STEP 2. Atlas Armlet/Hero Ring
          extra = 0
          extra += self.damage/4 if attacker.armor4_id(0) != 0 && ($data_armors[attacker.armor4_id(0)].guard_element_set.include?(RPG::SPEC_ACCESSORIES[2]))
          extra += self.damage/4 if attacker.armor4_id(1) != 0 && ($data_armors[attacker.armor4_id(1)].guard_element_set.include?(RPG::SPEC_ACCESSORIES[2]))
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
        hit_result = (attacker.hit(w) * blockValue / 256 ) > r
        
      #TODO: Attack "from behind" support
        hit_result = true if self.restriction == 4
        hit_result = true if attacker.hit(w)==255
        
        if self.states.include?(RPG::SPEC_STATES[7])
          hit_result = false 
          remove_states_shock
        end
        
        hit_result = false if self.states.include?(RPG::SPEC_STATES[6]) #Clear
        hit_result = true if attacker.element_set.include?(RPG::SKILL_TAGS[1]) #Unblockable
        hit_result = false if attacker.element_set.include?(RPG::SKILL_TAGS[0]) and self.state_ranks[1]==6 #Deathblow
        total_damage +=self.damage
        attacker.w_raise_exp(0) if hit_result
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
    bck_w = w
    w = w>3 ? 0 : w
    if user.is_a?(Game_Actor)
      u_w = $data_weapons[user.weapon_id[w]]
      u_w = $data_weapons[RPG::PUNCHES_WEAPON_ID] if u_w==nil
      elm = bck_w>3 ? skill.skill_cats[0] : u_w.skill_cats[0]
      a = elm==nil ? 1 : user.w_level[elm]==nil ? 1 : user.w_level[elm]
      u_wlevel = 1 + ((a-1)/2)
    else
      u_wlevel = 1 + ((user.level-1)/2)
    end
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
      #STEP 1.
      power = (skill.power + user.atk(w) * skill.atk_f / 100) #*user.level
      power = (power*(32+u_wlevel) / 64.0).floor if skill.atk_f > 0
      power *= (1+(u_wlevel/33.0)).floor if skill.atk_f > 0      
      power += u_wlevel if skill.atk_f > 0 
      
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
        total_damage = skill_power*4 + (u_wlevel*(magic_power*3/2)*skill_power/32)
      else
        #STEP "0".Weapon level
        t_level = u_wlevel
        t_level *= (2+t_level)/3
        
        total_damage = skill_power*4 + (t_level*(magic_power)*skill_power/32)
      #STEP 2. Earring / Hero Ring
        extra = 0
        extra += self.damage/4 if user.armor4_id(0) != 0 && ($data_armors[user.armor4_id(0)].guard_element_set.include?(RPG::SPEC_ACCESSORIES[3]))
          extra += self.damage/4 if user.armor4_id(1) != 0 && ($data_armors[user.armor4_id(1)].guard_element_set.include?(RPG::SPEC_ACCESSORIES[3]))
        total_damage += extra
      end
      
      total_damage *= 1.5 if skill.atk_f == 0
      total_damage *= 1 + (100-u_wlevel)/100.0 if skill.atk_f > 0
      
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
        self.damage = (self.damage*170/256)+1 if self.states.include?(RPG::SPEC_STATES[1]) #Shell
        self.damage /= 2 if self.states.include?(RPG::SPEC_STATES[4]) #Morph
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
      
      hit_result = true if self.states.include?(RPG::SPEC_STATES[6]) #Clear
      
      hit_result = true if skill.element_set.include?(RPG::SKILL_TAGS[1]) #Unblockable
      hit_result = false if skill.element_set.include?(RPG::SKILL_TAGS[0]) and self.state_ranks[1]==6 #Deathblow
      
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
    user.w_raise_exp(skill.scope) if effective
    return effective
  end

  def w_raise_exp(scope)
    
  end
  
  def attacking?
    return (@current_action.kind==0 && @current_action.basic==0) ||
          (@current_action.kind==1)
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
  attr_reader   :w_level                  # Weapon level array
  attr_reader   :w_exp                    # Weapon EXP array
  attr_reader   :learn_flag               # Learn skill flag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def weapon_id=(n)
    @weapon_id[0] = n
  end
  
  def weapon_id(x,n)
    @weapon_id[x] = n
  end
  
  def weapon_id(a=0)
    return @weapon_id if a == -1
    return @weapon_id[a]
  end
  
  def armor4_id=(n)
    @armor4_id[0] = n
  end
  
  def armor4_id(x,n)
    @armor4_id[x] = n
  end
  def armor4_id(a=0)
    return @armor4_id if a == -1
    return @armor4_id[a]
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @name = actor.name
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @battler_name = actor.battler_name
    @battler_hue = actor.battler_hue
    @class_id = actor.class_id
    @weapon_id = [actor.weapon_id,0,0,0]
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = [actor.armor4_id,0]
    @level = actor.initial_level
    @w_level = []
    @w_exp = []
    #ASDTsutarja2525
    for i in 0...$data_system.elements.size-1
      @w_level[i] = 1
      @w_exp[i] = 0
    end
    @exp_list = Array.new(maxlevel+2)
    @w_exp_list = Array.new(maxlevel+2)
    make_exp_list
    make_wexp_list
    @exp = @exp_list[@level]
    
    #@w_exp = @w_exp_list[@level]
    
    @skills = []
    @hp = maxhp
    @sp = maxsp
    @lp = maxlp
    initialize_gains
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @maxlp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    @ban = false
    # Learn skill
    for each in @w_level
      for i in 1..each
        for j in $data_classes[@class_id].learnings
          if j.level == i
            learn_skill(j.skill_id)
          end
        end
      end
    end
    # Update auto state
    update_auto_state(nil, $data_armors[@armor1_id])
    update_auto_state(nil, $data_armors[@armor2_id])
    update_auto_state(nil, $data_armors[@armor3_id])
    update_auto_state(nil, $data_armors[@armor4_id[0]])
  end
  
  #--------------------------------------------------------------------------
  # * Get Maximum HP
  #--------------------------------------------------------------------------
  def maxlp
    @maxlp_plus = 0 if @maxlp_plus==nil
    n = [[base_maxlp + @maxlp_plus, 1].max, 999].min
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxlp
    n = CharacterInfo::ACTOR_LP[:default]
    n = CharacterInfo::ACTOR_LP[@actor_id] if CharacterInfo::ACTOR_LP.include?(@actor_id)
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Calculate EXP
  #--------------------------------------------------------------------------
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..maxlevel+1
      if i > maxlevel
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Calculate wEXP
  #--------------------------------------------------------------------------
  def make_wexp_list
    actor = $data_actors[@actor_id]
    @w_exp_list[1] = 0
    for i in 2..maxlevel+1
      if i > 16
        @w_exp_list[i] = 0
      else
        @w_exp_list[i] = @exp_list[i-1] + 100
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Element Revision Value
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    # Get values corresponding to element effectiveness
    table = [0,200,150,100,50,0,-100]
    result = table[$data_classes[@class_id].element_ranks[element_id]]
    # If this element is protected by armor, then it's reduced by half
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id[0],@armor4_id[1]]
      armor = $data_armors[i]
      if armor != nil and armor.guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # If this element is protected by states, then it's reduced by half
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # End Method
    return result
  end
  #--------------------------------------------------------------------------
  # * Determine State Guard
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id[0],@armor4_id[1]]
      armor = $data_armors[i]
      if armor != nil
        if armor.guard_state_set.include?(state_id)
          return true
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Element
  #--------------------------------------------------------------------------
  def element_set(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    return weapon != nil ? weapon.element_set : []
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack State Change (+)
  #--------------------------------------------------------------------------
  def plus_state_set(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    return weapon != nil ? weapon.plus_state_set : []
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack State Change (-)
  #--------------------------------------------------------------------------
  def minus_state_set(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    return weapon != nil ? weapon.minus_state_set : []
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    initialize_gains if @hp_gain==nil
    return $data_actors[@actor_id].parameters[0, 1] + @hp_gain
  end
  
  def initialize_gains
    @hp_gain = 0
    @mp_gain = 0
    for i in 1..@level
      @hp_gain += hp_gain(i)
      @mp_gain += mp_gain(i)
    end
  end
  
  def hp_gain(lvl=@level)
    gain = ($data_actors[@actor_id].parameters[0, 1] * (lvl/30.0))/4
    gain /= [(lvl-(maxlevel*2/3))/2,1].max
    return Integer(gain)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    @mp_gain = 0 if @mp_gain==nil
    return $data_actors[@actor_id].parameters[1, 1] + @mp_gain
  end
  
  def mp_gain(lvl=@level)
    gain = ($data_actors[@actor_id].parameters[1, 1] * (lvl/50.0))/4
    gain /= [(lvl-(maxlevel*2/3))/2,1].max
    return Integer(gain)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    n = $data_actors[@actor_id].parameters[2, 1]#@level]
    for i in @weapon_id
      weapon = $data_weapons[i]
      n += weapon != nil ? weapon.str_plus : 0
    end
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      n += armor4 != nil ? armor4.str_plus : 0
    end
    n += armor1 != nil ? armor1.str_plus : 0
    n += armor2 != nil ? armor2.str_plus : 0
    n += armor3 != nil ? armor3.str_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    n = $data_actors[@actor_id].parameters[3, 1]#@level]
    for i in @weapon_id
      weapon = $data_weapons[i]
      n += weapon != nil ? weapon.dex_plus : 0
    end
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      n += armor4 != nil ? armor4.dex_plus : 0
    end
    n += armor1 != nil ? armor1.dex_plus : 0
    n += armor2 != nil ? armor2.dex_plus : 0
    n += armor3 != nil ? armor3.dex_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    n = $data_actors[@actor_id].parameters[4, 1]#@level]
    for i in @weapon_id
      weapon = $data_weapons[i]
      n += weapon != nil ? weapon.agi_plus : 0
    end
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      n += armor4 != nil ? armor4.agi_plus : 0
    end
    n += armor1 != nil ? armor1.agi_plus : 0
    n += armor2 != nil ? armor2.agi_plus : 0
    n += armor3 != nil ? armor3.agi_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    n = $data_actors[@actor_id].parameters[5, 1]#@level]
    for i in @weapon_id
      weapon = $data_weapons[i]
      n += weapon != nil ? weapon.int_plus : 0
    end
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      n += armor4 != nil ? armor4.int_plus : 0
    end
    n += weapon != nil ? weapon.int_plus : 0
    n += armor1 != nil ? armor1.int_plus : 0
    n += armor2 != nil ? armor2.int_plus : 0
    n += armor3 != nil ? armor3.int_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  def base_atk(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    return weapon != nil ? weapon.atk : 5+(self.dex+self.agi)/4+(level/4)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  def base_pdef
    pdef1 = 0
    pdef5 = 0
    wep_num = 1
    for i in @weapon_id
      weapon = $data_weapons[i]
      pdef1 += weapon != nil ? weapon.pdef : 0
      wep_num += 1 if weapon != nil
    end
    pdef1 /= [wep_num-1,1].max
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      pdef5 += armor4 != nil ? armor4.pdef : 0
    end
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    nat_pdef = 10 + self.dex + @level
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5 + nat_pdef
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  def base_mdef
    mdef1 = 0
    mdef5 = 0
    wep_num = 1
    for i in @weapon_id
      weapon = $data_weapons[i]
      mdef1 += weapon != nil ? weapon.mdef : 0
      wep_num += 1 if weapon != nil
    end
    mdef1 /= [wep_num-1,1].max
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      mdef5 += armor4 != nil ? armor4.mdef : 0
    end
    mdef2 = armor1 != nil ? armor1.mdef : 0
    mdef3 = armor2 != nil ? armor2.mdef : 0
    mdef4 = armor3 != nil ? armor3.mdef : 0
    nat_mdef = self.dex + @level
    return mdef1 + mdef2 + mdef3 + mdef4 + mdef5 + nat_mdef
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  def base_eva
    eva4 = 0
    equip_weight = 0
    for i in @weapon_id
      weapon = $data_weapons[i]
      equip_weight += weapon != nil ? weapon.weight : 0
    end
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    for i in @armor4_id
      armor4 = $data_armors[i]
      eva4 += armor4 != nil ? armor4.eva : 0
      equip_weight += armor4 != nil ? armor4.weight : 0
    end
    eva1 = armor1 != nil ? armor1.eva : 0
    eva2 = armor2 != nil ? armor2.eva : 0
    eva3 = armor3 != nil ? armor3.eva : 0
    equip_weight += armor1 != nil ? armor1.weight : 0
    equip_weight += armor2 != nil ? armor2.weight : 0
    equip_weight += armor3 != nil ? armor3.weight : 0
    n_eva = 9 + agi/6
    return eva1 + eva2 + eva3 + eva4 + n_eva - equip_weight
  end
  
  def hit(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    equip_weight = weapon != nil ? weapon.weight : 0
    if @weapon_id[w] != 0
      n = 50+(@level/4)+($data_weapons[@weapon_id[w]].atk/2)-equip_weight
    else
      n = 25+self.dex+self.agi
    end
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n+20)
  end
  
  def hit_num
    return [(1+((hit-45)/50))*hit_mult,1].max
  end
  #--------------------------------------------------------------------------
  # * Get Offensive Animation ID for Normal Attacks
  #--------------------------------------------------------------------------
  def animation1_id(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    return weapon != nil ? weapon.animation1_id : 0
  end
  #--------------------------------------------------------------------------
  # * Get Target Animation ID for Normal Attacks
  #--------------------------------------------------------------------------
  def animation2_id(w=0)
    weapon = $data_weapons[@weapon_id[w]]
    return weapon != nil ? weapon.animation2_id : 4
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id    : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    case equip_type
    when 0  # Weapon
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id[0], 1)
        @weapon_id[0] = id
        $game_party.lose_weapon(id, 1)
      end
    when 1  # Weapon
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id[1], 1)
        @weapon_id[1] = id
        $game_party.lose_weapon(id, 1)
      end
    when 2  # Weapon
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id[2], 1)
        @weapon_id[2] = id
        $game_party.lose_weapon(id, 1)
      end
    when 3  # Weapon
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id[3], 1)
        @weapon_id[3] = id
        $game_party.lose_weapon(id, 1)
      end
    when 4  # Shield
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.gain_armor(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_armor(id, 1)
      end
    when 5  # Head
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.gain_armor(@armor2_id, 1)
        @armor2_id = id
        $game_party.lose_armor(id, 1)
      end
    when 6  # Body
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.gain_armor(@armor3_id, 1)
        @armor3_id = id
        $game_party.lose_armor(id, 1)
      end
    when 7  # Accessory
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id[0]], $data_armors[id])
        $game_party.gain_armor(@armor4_id[0], 1)
        @armor4_id[0] = id
        $game_party.lose_armor(id, 1)
      end
    when 8  # Accessory
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id[1]], $data_armors[id])
        $game_party.gain_armor(@armor4_id[1], 1)
        @armor4_id[1] = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Change EXP
  #     exp : new EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    @exp = [[exp, 9999999].min, 0].max
    # Level up
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      @hp_gain += hp_gain
      @mp_gain += mp_gain
      # Learn skill
      #for j in $data_classes[@class_id].learnings
      #  if j.level == @level
      #    learn_skill(j.skill_id)
      #  end
      #end
    end
    # Level down
    while @exp < @exp_list[@level]
      @hp_gain -= hp_gain
      @mp_gain -= mp_gain
      @level -= 1
    end
    # Correction if exceeding current max HP and max SP
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # * Change Level
  #     level : new level
  #--------------------------------------------------------------------------
  def level=(level)
    # Check up and down limits
    level = [[level, maxlevel].min, 1].max
    # Change EXP
    self.exp = @exp_list[level]
  end
  
  def w_level=(type, level)
    @w_level[type] = level
  end

  def ch_w_exp(type, exp)
    @w_exp[type] = [ [exp, 9999999].min , 0].max
    #ch_w_level_status(type)
  end
  
  def ch_w_level_status
    names = []
    @w_exp.each_index{|type|
      # Level up
      while @w_exp[type] >= @w_exp_list[@w_level[type]+1] and @w_exp_list[@w_level[type]+1] > 0
        @w_level[type] += 1
        @animation_id = RPG::SKILL_LVL[:default]
        @animation_id = RPG::SKILL_LVL[type] if RPG::SKILL_LVL[type] != nil
        names.push(RPG::LVL_ICON[type]) unless names.include?(RPG::LVL_ICON[type])
      end
      # Level down
      while @w_exp[type] < @w_exp_list[@w_level[type]]
        @w_level[type] -= 1
      end
    }
    names
  end
  
  def check_skill_learn(type)
    return unless attacking?
    used_w = type > 4 ? 0 : type
    type = used_w == 4 ? $data_skills[@current_action.skill_id].skill_cats[0] : $data_weapons[@weapon_id[used_w]].skill_cats[0]
    # Learn skill
    $data_classes[@class_id].learnings.each{|j|
      break if type==nil
      if j.level < @w_level[type]
        next if skill_learn?(j.skill_id)
        learning = RPG::SKILL_NEED[j.skill_id]==nil ? RPG::SKILL_NEED[:default] : RPG::SKILL_NEED[j.skill_id]
        next if learning[0] > $game_party.global_level
        if learning[1].is_a?(Array)
          learning[1].each{|id|
            if learning[2] == true
              a = skill_learn?(id)
            else
              a = true if skill_learn?(id)
            end
          }
          next unless a
        elsif learning[1].is_a?(Numeric)
          id = learning[1]
          if learning[2] == true
              a = skill_learn?(id)
            else
              a = true if skill_learn?(id)
            end
        end
        r = rand(@w_level[type] - j.level)
        if r > 0
          learn_skill(j.skill_id)
          @learn_flag = true
          @current_action.kind = 1
          @current_action.skill_id = j.skill_id
        end
      end
    }
  end
    
  def learn_flag_off
    @learn_flag = nil
  end
  #--------------------------------------------------------------------------
  # * Change Class ID
  #     class_id : new class ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      # Remove items that are no longer equippable
      unless equippable?($data_weapons[@weapon_id[0]])
        equip(0, 0)
      end
      unless equippable?($data_weapons[@weapon_id[1]])
        equip(1, 0)
      end
      unless equippable?($data_weapons[@weapon_id[2]])
        equip(2, 0)
      end
      unless equippable?($data_weapons[@weapon_id[3]])
        equip(3, 0)
      end
      unless equippable?($data_armors[@armor1_id])
        equip(4, 0)
      end
      unless equippable?($data_armors[@armor2_id])
        equip(5, 0)
      end
      unless equippable?($data_armors[@armor3_id])
        equip(6, 0)
      end
      unless equippable?($data_armors[@armor4_id[0]])
        equip(7, 0)
      end
      unless equippable?($data_armors[@armor4_id[1]])
        equip(8, 0)
      end
    end
  end
  
  def w_raise_exp(scope)
    return unless attacking?
    r_val = RPG::SKILL_GAIN[scope]*(100+rand(20))/100
    used_w = @curr_weap > 4 ? 0 : @curr_weap
    elm = used_w == 4 ? $data_skills[@current_action.skill_id].skill_cats[0] : $data_weapons[@weapon_id[used_w]].skill_cats[0]
    elm = (elm==nil)||(@w_exp[elm]==nil) ? 1 : elm
    ch_w_exp(elm , @w_exp[elm]+r_val)
  end
end



#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     troop_id     : troop ID
  #     member_index : troop member index
  #--------------------------------------------------------------------------
  
  def initialize(troop_id, member_index, raise=0)
    super()
    @troop_id = troop_id
    @troop_id += 1 if member_index > 7
    @member_index = member_index
    if troop_id > 0
      troop = $data_troops[@troop_id]
      @enemy_id = troop.members[@member_index%8].enemy_id
    else
      @enemy_id = member_index
    end
    
    level = $data_enemies[@enemy_id].eva + raise
    if $data_enemies[@enemy_id].str != EnemyInfo::BOSS_KIND
      candidates = []
      for i in 1...$data_enemies.size
        if $data_enemies[i].eva <= level
          candidates.push(i) if $data_enemies[i].str==$data_enemies[@enemy_id].str
        end
      end
      for i in candidates
        @enemy_id = i if $data_enemies[@enemy_id].eva <= $data_enemies[i].eva
      end
    end
    @level_raise = [level - $data_enemies[@enemy_id].eva , 0].max
    @level_raise += rand(2) + rand(@level_raise / 10)
    
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @maxlp_plus = 0
    @hp = maxhp
    @sp = maxsp
    @lp = maxlp
    @vigor = 60 + rand(4)
    if troop_id > 0
      @hidden = troop.members[@member_index%8].hidden
      @immortal = troop.members[@member_index%8].immortal
    else
      @hidden = false
      @immortal = false
    end
    @collapse_type = EnemyInfo::COLLAPSES[@enemy_id] if EnemyInfo::COLLAPSES.include?(@enemy_id)
    @position = Wep::Default_position
  end
  
  def position
    return @position
  end
  
  #--------------------------------------------------------------------------
  # * Get Maximum HP
  #--------------------------------------------------------------------------
  def maxlp
    n = [[base_maxlp + @maxlp_plus, 1].max, 999].min
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxlp
    return 1
  end
  
  #--------------------------------------------------------------------------
  # * Get Enemy ID
  #--------------------------------------------------------------------------
  def id
    return @enemy_id
  end
  #--------------------------------------------------------------------------
  # * Get Index
  #--------------------------------------------------------------------------
  def index
    return @member_index
  end
  #--------------------------------------------------------------------------
  # * Get Name
  #--------------------------------------------------------------------------
  def name
    return $data_enemies[@enemy_id].name
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    return $data_enemies[@enemy_id].maxhp
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    return $data_enemies[@enemy_id].maxsp
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    return @vigor
  end
  
  def enemy_kind
    return $data_enemies[@enemy_id].str
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    return $data_enemies[@enemy_id].dex
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    return $data_enemies[@enemy_id].agi
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    return $data_enemies[@enemy_id].int
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  def base_atk(w=0)
    return $data_enemies[@enemy_id].atk
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  def base_pdef
    return $data_enemies[@enemy_id].pdef
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  def base_mdef
    return $data_enemies[@enemy_id].mdef
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion
  #--------------------------------------------------------------------------
  def base_eva
    return (16 + agi/8)/2 #return $data_enemies[@enemy_id].eva
  end
  
  def level
    return $data_enemies[@enemy_id].eva + @level_raise
  end
  
  def m_eva
    n = eva*(int*1.0/str)
    return Integer(n)
  end
    
  #--------------------------------------------------------------------------
  # * Get Offensive Animation ID for Normal Attack
  #--------------------------------------------------------------------------
  def animation1_id(w=0)
    return $data_enemies[@enemy_id].animation1_id
  end
  #--------------------------------------------------------------------------
  # * Get Target Animation ID for Normal Attack
  #--------------------------------------------------------------------------
  def animation2_id(w=0)
    return $data_enemies[@enemy_id].animation2_id
  end
  #--------------------------------------------------------------------------
  # * Get Element Revision Value
  #     element_id : Element ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    # Get a numerical value corresponding to element effectiveness
    table = [0,200,150,100,50,0,-100]
    result = table[$data_enemies[@enemy_id].element_ranks[element_id]]
    # If protected by state, this element is reduced by half
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # End Method
    return result
  end
  #--------------------------------------------------------------------------
  # * Get State Effectiveness
  #--------------------------------------------------------------------------
  def state_ranks
    return $data_enemies[@enemy_id].state_ranks
  end
  #--------------------------------------------------------------------------
  # * Determine State Guard
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Element
  #--------------------------------------------------------------------------
  def element_set
    return []
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack State Change (+)
  #--------------------------------------------------------------------------
  def plus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack State Change (-)
  #--------------------------------------------------------------------------
  def minus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # * Aquire Actions
  #--------------------------------------------------------------------------
  def actions
    return $data_enemies[@enemy_id].actions
  end
  #--------------------------------------------------------------------------
  # * Get EXP
  #--------------------------------------------------------------------------
  def exp
    return $data_enemies[@enemy_id].exp
  end
  #--------------------------------------------------------------------------
  # * Get Gold
  #--------------------------------------------------------------------------
  def gold
    return $data_enemies[@enemy_id].gold
  end
  #--------------------------------------------------------------------------
  # * Get Item ID
  #--------------------------------------------------------------------------
  def item_id
    return $data_enemies[@enemy_id].item_id
  end
  #--------------------------------------------------------------------------
  # * Get Weapon ID
  #--------------------------------------------------------------------------
  def weapon_id
    return $data_enemies[@enemy_id].weapon_id
  end
  #--------------------------------------------------------------------------
  # * Get Armor ID
  #--------------------------------------------------------------------------
  def armor_id
    return $data_enemies[@enemy_id].armor_id
  end
  #--------------------------------------------------------------------------
  # * Get Treasure Appearance Probability
  #--------------------------------------------------------------------------
  def treasure_prob
    return $data_enemies[@enemy_id].treasure_prob
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    return $data_troops[@troop_id].members[@member_index%8].x
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    return $data_troops[@troop_id].members[@member_index%8].y + 96
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Z-Coordinate
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y
  end
  #--------------------------------------------------------------------------
  # * Escape
  #--------------------------------------------------------------------------
  def escape
    # Set hidden flag
    @hidden = true
    # Clear current action
    self.current_action.clear
  end
  #--------------------------------------------------------------------------
  # * Transform
  #     enemy_id : ID of enemy to be transformed
  #--------------------------------------------------------------------------
  def transform(enemy_id)
    # Change enemy ID
    @enemy_id = enemy_id
    # Change battler graphics
    @battler_name = $data_enemies[@enemy_id].battler_name
    @battler_hue = $data_enemies[@enemy_id].battler_hue
    # Remake action
    make_action
  end
  #--------------------------------------------------------------------------
  # * Make Action
  #--------------------------------------------------------------------------
  def make_action
    # Clear current action
    self.current_action.clear
    # If unable to move
    unless self.movable?
      # End Method
      return
    end
    # Extract current effective actions
    available_actions = []
    rating_max = 0
    for action in self.actions
      # Confirm turn conditions
      n = $game_temp.battle_turn
      a = action.condition_turn_a
      b = action.condition_turn_b
      if (b == 0 and n != a) or
         (b > 0 and (n < 1 or n < a or n % b != a % b))
        next
      end
      # Confirm HP conditions
      if self.hp * 100.0 / self.maxhp > action.condition_hp
        next
      end
      # Confirm level conditions
      if $game_party.max_level < action.condition_level
        next
      end
      # Confirm switch conditions
      switch_id = action.condition_switch_id
      if switch_id > 0 and $game_switches[switch_id] == false
        next
      end
      # Add this action to applicable conditions
      available_actions.push(action)
      if action.rating > rating_max
        rating_max = action.rating
      end
    end
    # Calculate total with max rating value at 3 (exclude 0 or less)
    ratings_total = 0
    for action in available_actions
      if action.rating > rating_max - 3
        ratings_total += action.rating - (rating_max - 3)
      end
    end
    # If ratings total isn't 0
    if ratings_total > 0
      # Create random numbers
      value = rand(ratings_total)
      # Set things that correspond to created random numbers as current action
      for action in available_actions
        if action.rating > rating_max - 3
          if value < action.rating - (rating_max - 3)
            self.current_action.kind = action.kind
            self.current_action.basic = action.basic
            self.current_action.skill_id = action.skill_id
            self.current_action.decide_random_target_for_enemy
            return
          else
            value -= action.rating - (rating_max - 3)
          end
        end
      end
    end
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  attr_accessor :entered_battles
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ozrssgp_initialize initialize unless $@
  def initialize
    ozrssgp_initialize
    @available_formations = []
    @party_size = 5
    @entered_battles = 0
  end
  #--------------------------------------------------------------------------
  # * Initial Party Setup
  #--------------------------------------------------------------------------
  alias ozrssgp_setup_starting_members setup_starting_members
  def setup_starting_members
    ozrssgp_setup_starting_members
    setup_starting_formations
    change_positions
  end
  #--------------------------------------------------------------------------
  # * Battle Test Party Setup
  #--------------------------------------------------------------------------
  def setup_battle_test_members
    @actors = []
    for battler in $data_system.test_battlers
      actor = $game_actors[battler.actor_id]
      actor.level = battler.level
      gain_weapon(battler.weapon_id[0], 1)
      gain_armor(battler.armor1_id, 1)
      gain_armor(battler.armor2_id, 1)
      gain_armor(battler.armor3_id, 1)
      gain_armor(battler.armor4_id(0), 1)
      actor.equip(0, battler.weapon_id[0])
      actor.equip(4, battler.armor1_id)
      actor.equip(5, battler.armor2_id)
      actor.equip(6, battler.armor3_id)
      actor.equip(7, battler.armor4_id(0))
      actor.recover_all
      @actors.push(actor)
    end
    @items = {}
    for i in 1...$data_items.size
      if $data_items[i].name != ""
        occasion = $data_items[i].occasion
        if occasion == 0 or occasion == 1
          @items[i] = 99
        end
      end
    end
    setup_starting_formations
    change_positions
  end
  
  def setup_starting_formations
    @available_formations = []
    @available_formations = FormationInfo::F_STARTING
    $game_system.abatxp_form_id = @available_formations[0]
  end
  
  def add_formation(new)
    @available_formations.push(new) if !(@available_formations.include?(new))
  end
  
  def remove_formation(old)
    @available_formations.delete(old) if !(@available_formations.include?(old))
  end
  
  def available_formation_names
    names = []
    for i in @available_formations
      names.push(FormationInfo::F_NAMES[i])
    end
    return names
  end
  
  def available_formations
    return @available_formations
  end
  
  def change_positions
    for i in 0..@actors.size-1
      @actors[i].position = FormationInfo::F_POS[$game_system.abatxp_form_id][i]
    end
  end
  
  def global_level
    return (@entered_battles / [RPG::GLOBAL_LEVELLING_BATTLES,1].max)
  end
  
  #--------------------------------------------------------------------------
  # * Refresh Party Members
  #--------------------------------------------------------------------------
  alias ozrssgp_refresh refresh unless $@
  def refresh
    ozrssgp_refresh
    change_positions
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    # Get actor
    actor = $game_actors[actor_id]
    # If the party has less than 4 members and this actor is not in the party
    if @actors.size < @party_size and not @actors.include?(actor)
      # Add actor
      @actors.push(actor)
      # Refresh player
      $game_player.refresh
    end
    change_positions
  end
  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias ozrssgp_remove_actor remove_actor unless $@
  def remove_actor(actor_id)
    ozrssgp_remove_actor(actor_id)
    change_positions
  end
  
end

#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  This class deals with troops. Refer to "$game_troop" for the instance of
#  this class.
#==============================================================================

class Game_Troop
  #--------------------------------------------------------------------------
  # * Setup
  #     troop_id : troop ID
  #--------------------------------------------------------------------------
  def setup(troop_id)
    # Set array of enemies who are set as troops
    @enemies = []
    troop = $data_troops[troop_id]
    
    #$game_party.global_level
    average = 0
    size = 0
    for i in 0...troop.members.size
      enemy = $data_enemies[troop.members[i].enemy_id]
      if enemy != nil
        average += enemy.eva
        size += 1 unless enemy.eva == 0
      end
    end    
    if EnemyInfo::DOUBLE_ENEMYTROOP.include?(troop_id) #ASDTsutarja
      troop = $data_troops[troop_id+1]
      for i in 0...troop.members.size
        enemy = $data_enemies[troop.members[i].enemy_id]
        if enemy != nil
          average += enemy.eva
          size += 1 unless enemy.eva == 0
        end
      end
    end
    average /= size
    raise = $game_party.global_level - average
    
    troop = $data_troops[troop_id]
    for i in 0...troop.members.size
      enemy = $data_enemies[troop.members[i].enemy_id]
      if enemy != nil
        @enemies.push(Game_Enemy.new(troop_id, i, raise - rand(3) - rand(2)))
      end
    end    
    if EnemyInfo::DOUBLE_ENEMYTROOP.include?(troop_id) and @enemies.size==8 #ASDTsutarja
      troop = $data_troops[troop_id+1]
      for i in 0...troop.members.size
        enemy = $data_enemies[troop.members[i].enemy_id]
        if enemy != nil
          @enemies.push(Game_Enemy.new(troop_id, i+8, raise))
        end
      end
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battler                  # battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #     battler  : battler (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @state_animation_id = 0
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If battler is nil
    if @battler == nil
      self.bitmap = nil
      loop_animation(nil)
      return
    end
    # If file name or hue are different than current ones
    if @battler.battler_name != @battler_name or
       @battler.battler_hue != @battler_hue
      # Get and set bitmap
      @battler_name = @battler.battler_name
      @battler_hue = @battler.battler_hue
      self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
      @width = bitmap.width
      @height = bitmap.height
      self.ox = @width / 2
      self.oy = @height
      # Change opacity level to 0 when dead or hidden
      if @battler.dead? or @battler.hidden
        self.opacity = 0
      end
    end
    # If animation ID is different than current one
    if @battler.damage == nil and
       @battler.state_animation_id != @state_animation_id
      @state_animation_id = @battler.state_animation_id
      loop_animation($data_animations[@state_animation_id])
    end
    # If actor which should be displayed
    if @battler.is_a?(Game_Actor) and @battler_visible
      # Bring opacity level down a bit when not in main phase
      if $game_temp.battle_main_phase
        self.opacity += 3 if self.opacity < 255
      else
        self.opacity -= 3 if self.opacity > 207
      end
    end
    # Blink
    if @battler.blink
      blink_on
    else
      blink_off
    end
    # If invisible
    unless @battler_visible
      # Appear
      if not @battler.hidden and not @battler.dead? and
         (@battler.damage == nil or @battler.damage_pop)
        appear
        @battler_visible = true
      end
    end
    # If visible
    if @battler_visible
      # Escape
      if @battler.hidden
        $game_system.se_play($data_system.escape_se)
        escape
        @battler_visible = false
      end
      # White flash
      if @battler.white_flash
        whiten
        @battler.white_flash = false
      end
      # Animation
      if @battler.animation_id != 0
        animation = $data_animations[@battler.animation_id]
        animation(animation, @battler.animation_hit)
        @battler.animation_id = 0
      end
      # Damage
      if @battler.damage_pop
        damage(@battler.damage, @battler.critical)
        @battler.damage = nil
        @battler.critical = false
        @battler.damage_pop = false
      end
      # Collapse
      if @battler.damage == nil and @battler.dead?
        if @battler.is_a?(Game_Enemy)
          $game_system.se_play($data_system.enemy_collapse_se)
        else
          $game_system.se_play($data_system.actor_collapse_se)
        end
        collapse
        @battler_visible = false
      end
    end
    # Set sprite coordinates
    self.x = @battler.screen_x unless @_collapse_duration != 0
    self.y = @battler.screen_y unless @_collapse_duration != 0
    self.z = @battler.screen_z
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
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Make viewports
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport4 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 101
    @viewport3.z = 200
    @viewport4.z = 5000
    # Make battleback sprite
    @battleback_sprite = Sprite.new(@viewport1)
    # Make enemy sprites
    @enemy_sprites = []
    for enemy in $game_troop.enemies.reverse
      @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
    end
    # Make actor sprites
    @actor_sprites = []
    $game_party.party_size.times do
      @actor_sprites.push(Sprite_Battler.new(@viewport1))
    end
    for each in @actor_sprites
      each.appear
    end
    # Make weather
    @weather = RPG::Weather.new(@viewport1)
    # Make picture sprites
    @picture_sprites = []
    for i in 51..100
      @picture_sprites.push(Sprite_Picture.new(@viewport3,
        $game_screen.pictures[i]))
    end
    # Make timer sprite
    @timer_sprite = Sprite_Timer.new
    # Frame update
    update
  end
  alias ozrsssba_update update unless $@
  def update
    ozrsssba_update
    @battleback_sprite.src_rect.set(0, 0, 640, 480)
  end
end

#--------------------------------------
#Basic definitions. Window definitions.
#--------------------------------------
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
  alias ozrsswb_initialize initialize unless $@
  def initialize(x, y, width, height)
    ozrsswb_initialize(x, y, width, height)
    @window_back = nil
    self.opacity = 160
    @fix_x = 0
    @fix_y = 0
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias ozrsswb_dispose dispose unless $@
  def dispose
    if @window_back != nil
      @window_back.bitmap.dispose
      @window_back.dispose
    end
    ozrsswb_dispose
  end
  
  def customback_init(name,fix_x,fix_y)
    self.self_opacity = 0
    @window_back.bitmap.dispose if @window_back !=nil
    @window_back = Sprite.new
    @window_back.bitmap = RPG::Cache.windowskin(name)
    @fix_x = fix_x
    @fix_y = fix_y
    @window_back.x = self.x + @fix_x
    @window_back.y = self.y + @fix_y
    @window_back.z = self.z - 1
  end
  
  def self_opacity=n
    self.opacity = n
    self.contents_opacity = 255
  end
  
  def visible=(n)
    @window_back.visible = n if @window_back != nil
    super
  end
  
  def draw_icon(icon, x, y)
    bitmap = RPG::Cache.icon(icon)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
  end
  #--------------------------------------------------------------------------
  # * Draw HP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 144)
    # Draw "HP" text string
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.hp)
    # Calculate if there is draw space for MaxHP
    if width - 32 >= 108
      hp_x = x + width - 108
      flag = true
    else#if width - 32 >= 48
      hp_x = x + width - 48
      flag = false
    end
    # Draw HP
    self.contents.font.color = actor.hp == 0 ? knockout_color :
      actor.hp <= actor.maxhp / 4 ? crisis_color : normal_color
    self.contents.draw_text(hp_x, y, 48, 32, actor.hp.to_s, 2)
    # Draw MaxHP
    if flag
      self.contents.font.color = normal_color
      self.contents.draw_text(hp_x + 48, y, 12, 32, "/", 1)
      self.contents.draw_text(hp_x + 60, y, 48, 32, actor.maxhp.to_s)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw SP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  def draw_actor_sp(actor, x, y, width = 144)
    # Draw "SP" text string
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.sp)
    # Calculate if there is draw space for MaxHP
    if width - 32 >= 108
      sp_x = x + width - 108
      flag = true
    else#if width - 32 >= 48
      sp_x = x + width - 48
      flag = false
    end
    # Draw SP
    self.contents.font.color = actor.sp == 0 ? knockout_color :
      actor.sp <= actor.maxsp / 4 ? crisis_color : normal_color
    self.contents.draw_text(sp_x, y, 48, 32, actor.sp.to_s, 2)
    # Draw MaxSP
    if flag
      self.contents.font.color = normal_color
      self.contents.draw_text(sp_x + 48, y, 12, 32, "/", 1)
      self.contents.draw_text(sp_x + 60, y, 48, 32, actor.maxsp.to_s)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw SP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  def draw_actor_lp(actor, x, y, width = 144)
    # Draw "LP" text string
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, RPG::LP_WORD)
    # Calculate if there is draw space for MaxLP
    if width - 32 >= 108
      sp_x = x + width - 108
      flag = true
    else#if width - 32 >= 48
      sp_x = x + width - 48
      flag = false
    end
    # Draw LP
    self.contents.font.color = actor.lp == 0 ? knockout_color :
      actor.lp <= actor.maxlp / 4 ? crisis_color : normal_color
    self.contents.draw_text(sp_x, y, 48, 32, actor.lp.to_s, 2)
    # Draw MaxLP
    if flag
      self.contents.font.color = normal_color
      self.contents.draw_text(sp_x + 48, y, 12, 32, "/", 1)
      self.contents.draw_text(sp_x + 60, y, 48, 32, actor.maxlp.to_s)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw Parameter
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : parameter type (0-6)
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type,w=0,width=120)
    case type
    when 0
      parameter_name = $data_system.words.atk      
      if w > 3
        parameter_value = actor.atk(0).to_s+"/"+actor.atk(1).to_s+"/"+actor.atk(2).to_s+"/"+actor.atk(3).to_s
      else
        parameter_value = actor.atk(w)
      end
      
    when 1
      parameter_name = $data_system.words.pdef
      parameter_value = actor.pdef
    when 2
      parameter_name = $data_system.words.mdef
      parameter_value = actor.mdef
    when 3
      parameter_name = $data_system.words.str
      parameter_value = actor.str
    when 4
      parameter_name = $data_system.words.dex
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[0]
      parameter_value = actor.eva
    when 8
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[1]
      parameter_value = actor.m_eva
    when 9
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[2]
      parameter_value = actor.hit
    when 10
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[3]
      parameter_value = actor.hit_num
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, width, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + width, y, width-32, 32, parameter_value.to_s, 2)
  end
  
  def draw_actor_weaponlevel(actor, x, y, num,width=120)
    parameter_value = actor.w_level[num]
    draw_icon(RPG::LVL_ICON[num], x, y-2)
    self.contents.font.color = system_color
    self.contents.draw_text(x+26, y, width-26, 32, "Weapon LV")
    self.contents.font.color = normal_color
    self.contents.draw_text(x+26, y, width-26, 32, parameter_value.to_s, 2)
  end
  
  def draw_actor_magiclevel(actor, x, y, num,width=120)
    parameter_value = actor.w_level[num]
    draw_icon(RPG::LVL_ICON[num], x, y-2)
    self.contents.font.color = system_color
    self.contents.draw_text(x+26, y, width-26, 32, "Magic LV")
    self.contents.font.color = normal_color
    self.contents.draw_text(x+26, y, width-26, 32, parameter_value.to_s, 2)
  end
  
  def draw_face(name,x,y)
    begin
      b = RPG::Cache.picture(name)
    rescue
      b = Bitmap.new(48,48)
    end
    rect = Rect.new(0,0,b.width,b.height)
    self.contents.blt(x,y,b,rect)
    [b.width,b.height]
  end
  
  def draw_actor_face(actor,x,y)
    draw_face("actorface_"+actor.id.to_s,x,y)
    #[b.width,b.height]
  end
end

#==============================================================================
# ** Window_Command
#------------------------------------------------------------------------------
#  This window deals with general command choices.
#==============================================================================

class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     width    : window width
  #     commands : command text string array
  #--------------------------------------------------------------------------
  attr_accessor :commands
  attr_accessor :align
  
  alias wc_init initialize
  def initialize(width, commands, align=0)
    @align = align
    wc_init(width, commands)
  end
  
  def draw_item(index, color)
    align = @align==nil ? 0 : @align
    self.contents.font.color = color
    rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index], align)
  end
  
  def reset_item_max(max_size=480)
    @item_max = commands.size
    self.height = [@item_max * 32 + 32, max_size].min
    self.contents = Bitmap.new(self.width - 32, @item_max * 32)
    refresh
  end
  
end

#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays items in possession on the item and battle screens.
#==============================================================================

class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias ozrsswi_initialize initialize unless $@
  def initialize
    ozrsswi_initialize
    if $game_temp.in_battle
      self.y = 64
      self.width = 256
      @column_max = 1
      self.height = 416
      self.back_opacity = 160
      refresh
    end
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    # Add item
    for i in 1...$data_items.size
      if $game_party.item_number(i) > 0
        @data.push($data_items[i])
      end
    end
    # Also add weapons and items if outside of battle
    unless $game_temp.in_battle
      for i in 1...$data_weapons.size
        if $game_party.weapon_number(i) > 0
          @data.push($data_weapons[i])
        end
      end
      for i in 1...$data_armors.size
        if $game_party.armor_number(i) > 0
          @data.push($data_armors[i])
        end
      end
    end
    # If item count is not 0, make a bit map and draw all items
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if item.is_a?(RPG::Item) and
       $game_party.item_can_use?(item.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % @column_max * (288 + 32)
    y = index / @column_max * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
  
end

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Set Text
  #  text  : text string displayed in window
  #  align : alignment (0..flush left, 1..center, 2..flush right)
  #--------------------------------------------------------------------------
  def draw_mp(actor)
    draw_actor_sp(actor, 544, 0, 64)
  end
end
#==============================================================================
# ** Window_EquipLeft
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================

class Window_EquipLeft < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 64, 272, 192)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(w=0)
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_level(@actor, 4, 32)
    draw_actor_parameter(@actor, 4, 64, 0,w,96)
    draw_actor_parameter(@actor, 4, 96, 1,w,96)
    draw_actor_parameter(@actor, 4, 128, 2,w,96)
    if @new_atk != nil
      a = 0
      a = 1 if @actor.atk < @new_atk
      a = 2 if @actor.atk > @new_atk
      self.contents.font.color = system_color
      self.contents.draw_text(160, 64, 40, 32, WindowInfo::CHANGE_SYMBOLS[a], 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(200, 64, 36, 32, @new_atk.to_s, 2)
    end
    if @new_pdef != nil
      a = 0
      a = 1 if @actor.pdef < @new_pdef
      a = 2 if @actor.pdef > @new_pdef
      self.contents.font.color = system_color
      self.contents.draw_text(160, 96, 40, 32, WindowInfo::CHANGE_SYMBOLS[a], 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(200, 96, 36, 32, @new_pdef.to_s, 2)
    end
    if @new_mdef != nil
      a = 0
      a = 1 if @actor.mdef < @new_mdef
      a = 2 if @actor.mdef > @new_mdef
      self.contents.font.color = system_color
      self.contents.draw_text(160, 128, 40, 32, WindowInfo::CHANGE_SYMBOLS[a], 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(200, 128, 36, 32, @new_mdef.to_s, 2)
    end
  end
  
end

#==============================================================================
# ** Window_EquipRight
#------------------------------------------------------------------------------
#  This window displays items the actor is currently equipped with on the
#  equipment screen.
#==============================================================================

class Window_EquipRight < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(272, 64, 368, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @data = []
    @data.push($data_weapons[@actor.weapon_id(0)])
    @data.push($data_weapons[@actor.weapon_id(1)])
    @data.push($data_weapons[@actor.weapon_id(2)])
    @data.push($data_weapons[@actor.weapon_id(3)])
    @data.push($data_armors[@actor.armor1_id])
    @data.push($data_armors[@actor.armor2_id])
    @data.push($data_armors[@actor.armor3_id])
    @data.push($data_armors[@actor.armor4_id(0)])
    @data.push($data_armors[@actor.armor4_id(1)])
    @item_max = @data.size
    self.contents.font.color = system_color
    self.contents.draw_text(4, 32 * 0, 92, 32, $data_system.words.weapon)
    self.contents.draw_text(4, 32 * 4, 92, 32, $data_system.words.armor1)
    self.contents.draw_text(4, 32 * 5, 92, 32, $data_system.words.armor2)
    self.contents.draw_text(4, 32 * 6, 92, 32, $data_system.words.armor3)
    self.contents.draw_text(5, 32 * 7, 92, 32, $data_system.words.armor4)
    draw_item_name(@data[0], 92, 32 * 0)
    draw_item_name(@data[1], 92, 32 * 1)
    draw_item_name(@data[2], 92, 32 * 2)
    draw_item_name(@data[3], 92, 32 * 3)
    draw_item_name(@data[4], 92, 32 * 4)
    draw_item_name(@data[5], 92, 32 * 5)
    draw_item_name(@data[6], 92, 32 * 6)
    draw_item_name(@data[7], 92, 32 * 7)
    draw_item_name(@data[8], 92, 32 * 8)
  end
  
end

#==============================================================================
# ** Window_EquipItem
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
#  equipment screen.
#==============================================================================

class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor      : actor
  #     equip_type : equip region (0-3)
  #--------------------------------------------------------------------------
  def initialize(actor, equip_type)
    super(0, 256, 272, 224)
    @actor = actor
    @equip_type = equip_type
    @column_max = 1
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    x = 4 #+ index % 2 * (288 + 32)
    y = index * 32
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
  
end

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================
#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_graphic(actor, x - 40, y + 80)
      draw_actor_name(actor, x, y+8)
      draw_actor_class(actor, x + 144, y+8)
      draw_actor_level(actor, x, y + 24)
      draw_actor_state(actor, x + 90, y + 24)
      draw_actor_exp(actor, x, y + 64)
      draw_actor_hp(actor, x + 236, y + 24)
      draw_actor_sp(actor, x + 236, y + 44)
      draw_actor_lp(actor, x + 236, y + 64)
    end
  end
end
class Window_Status < Window_Base
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_face(@actor, 0, 20)
    draw_actor_name(@actor, 4, 0)
    draw_actor_position(@actor, 96, 0)
    draw_actor_class(@actor, 128, 0)
    draw_actor_level(@actor, 128, 20)
    draw_actor_state(@actor, 256, 0)
    draw_actor_hp(@actor, 128, 40, 160)
    draw_actor_sp(@actor, 128, 60, 160)
    draw_actor_lp(@actor, 128, 80, 160)
    self.contents.font.color = system_color
    self.contents.draw_text(128, 104, 80, 32, WindowInfo::EXP_DISPLAY[0])
    self.contents.draw_text(128, 124, 80, 32, WindowInfo::EXP_DISPLAY[1])
    self.contents.font.color = normal_color
    self.contents.draw_text(256,104, 128, 32, @actor.exp_s, 2)
    self.contents.draw_text(256,124, 128, 32, @actor.next_rest_exp_s, 2)
    
    draw_actor_parameter(@actor, 4, 192, 3,0,160)
    draw_actor_parameter(@actor, 4, 212, 4,0,160)
    draw_actor_parameter(@actor, 4, 232, 5,0,160)
    
    draw_actor_parameter(@actor, 4, 252, 0,4,160)
    draw_actor_parameter(@actor, 4, 272, 1,0,160)
    draw_actor_parameter(@actor, 4, 292, 7,0,160)
    draw_actor_parameter(@actor, 4, 312, 6,0,160)
    draw_actor_parameter(@actor, 4, 332, 2,0,160)
    draw_actor_parameter(@actor, 4, 352, 8,0,160)
    draw_actor_parameter(@actor, 4, 372, 9,0,160)
    draw_actor_parameter(@actor, 4, 392, 10,0,160)
    #ASDTsutarja4545
    a = 0
    for i in 0...RPG::weapon_types.size
      draw_actor_weaponlevel(@actor, 320, 152+(20*i), RPG::weapon_types[i],160)
      a = i
      a+=1
    end
    for i in 0...RPG::MAGIC_LEVELS.size
      draw_actor_magiclevel(@actor, 320, 152+(20*(a+i)), RPG::MAGIC_LEVELS[i],160)
    end
    #self.contents.font.color = system_color
  end
  
  def dummy
    #self.contents.font.color = system_color
  end
end

#==============================================================================
# ** Window_PartyCommand
#------------------------------------------------------------------------------
#  This window is used to select whether to fight or escape on the battle
#  screen.
#==============================================================================

class Window_PartyCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 160
    @commands = [WindowInfo::PARTY_COMMAND_NAMES[0], WindowInfo::PARTY_COMMAND_NAMES[1]]
    @item_max = 2
    @column_max = 2
    draw_item(0, normal_color)
    draw_item(1, normal_color)
    #draw_item(1, $game_temp.battle_can_escape ? normal_color : disabled_color)
    self.active = false
    self.visible = false
    self.index = 0
  end
  
end

#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================

class Window_BattleResult < Window_Base
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  
  def initialize(exp, gold, treasures)
    @text_x = 640
    x = []
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 160
    self.visible = false
    refresh
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  
  def refresh
    self.contents.clear
    @text_x = [@text_x-16,0].max
    self.contents.font.color = normal_color
    self.contents.draw_text(0+@text_x, 0, 608, 32, WindowInfo::BATTLE_END,1)
  end
end

class Window_Formation < Window_Command
  def initialize(width)
    # Compute window height from command quantity
    @commands = $game_party.available_formation_names
    super(width, @commands)
    refresh
    self.height = [ self.height, 480 ].min
    self.index = active_index
  end
  
  def selected_formation
    return $game_party.available_formations[self.index]
  end
  
  def active_index
    for i in 0..$game_party.available_formations.size-1
      return i if $game_party.available_formations[i] == $game_system.abatxp_form_id
    end
    return 0
  end
end

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  Stylized to be like the status displaying used at Romancing SaGa.
#==============================================================================

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(16, -96, 640, 640)
    self.contents = Bitmap.new(width - 32, height - 32)
    restore_levelup_info
    self.opacity = 0
    self.contents.font.size = 16
    refresh
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Set Level Up Flag
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def level_up(actor_index, text=[])
    @level_up_flags[actor_index] = true
    @level_up_names[actor_index] = text
    self.visible=true
  end
  
  def new_skill(actor_index)
    @new_skill_flags[actor_index] = true
  end
  
  def restore_levelup_info
    @level_up_flags = []
    @new_skill_flags = []
    @level_up_names = []
    $game_party.party_size.times do 
      @level_up_flags.push(false)
      @level_up_names.push("")
      @new_skill_flags.push(false)
    end
    @only_levelup=false
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    @only_levelup = true if @level_up_flags.include?(true)
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      next if actor.lp==0
      actor_x = actor.screen_x+WindowInfo::OFF_X
      actor_y = actor.screen_y+WindowInfo::OFF_Y
      if @level_up_flags[i]
        self.contents.font.color = normal_color
        @level_up_names[i] = "" if (@level_up_names[i] == nil)||(@level_up_names[i].size == 0)
        lup_text = @level_up_names[i] == "" ? WindowInfo::LEVELUP : WindowInfo::SKILLUP
        if @level_up_names[i].size != 0
          @level_up_names[i].each{|icon|
            b = RPG::Cache.icon(icon)
            r = Rect.new(0,0,24,24)
            self.contents.blt(actor_x, actor_y,b,r)
            actor_x += 24
          }
        end
        self.contents.draw_text(actor_x, actor_y, 120, 32, lup_text)
      end
      unless @only_levelup==true
        #draw_actor_name_pos(actor, actor_x, actor_y)
        draw_actor_hp(actor, actor_x, actor_y, 48)
        draw_actor_lp(actor, actor_x, actor_y+16, 48)
      end
    end
  end
  
  def set_bulb(i)
    @only_levelup = true
    @new_skill_flags[i] = true
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Slightly lower opacity level during main phase
    if $game_temp.battle_main_phase
      self.contents_opacity -= 4 if self.contents_opacity > 191
    else
      self.contents_opacity += 4 if self.contents_opacity < 255
    end
  end
end

#---------------------------------------------------------
#Basic definitions. Other interactive objects definitions.
#---------------------------------------------------------

#==============================================================================
# ** Arrow_Base
#------------------------------------------------------------------------------
#  This sprite is used as an arrow cursor for the battle screen. This class
#  is used as a superclass for the Arrow_Enemy and Arrow_Actor classes.
#==============================================================================

class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update blink count
    @blink_count = (@blink_count + 1) % (RPG::ARROW_ANIMSPEED*2)
    # Set forwarding origin rectangle
    if @blink_count < RPG::ARROW_ANIMSPEED
      self.src_rect.set(128, 96, 32, 32)
    else
      self.src_rect.set(160, 96, 32, 32)
    end
    # Update help text (update_help is defined by the subclasses)
    if @help_window != nil
      update_help
    end
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
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Skip if indicating a nonexistant enemy
    $game_troop.enemies.size.times do
      break if self.enemy.exist?
      @index += 1
      @index %= $game_troop.enemies.size
    end
    # Cursor right
    if Input.repeat?(Input::DOWN)
      indexes = get_dir(:down)
      check_hypo_dist(indexes)
      #$game_system.se_play($data_system.cursor_se)
      #$game_troop.enemies.size.times do
      #  @index += 1
      #  @index %= $game_troop.enemies.size
      #  break if self.enemy.exist?
      #end
    end
    # Cursor left
    if Input.repeat?(Input::UP)
      indexes = get_dir(:up)
      check_hypo_dist(indexes)
      #$game_system.se_play($data_system.cursor_se)
      #$game_troop.enemies.size.times do
      #  @index += $game_troop.enemies.size - 1
      #  @index %= $game_troop.enemies.size
      #  break if self.enemy.exist?
      #end
    end
    # Cursor right
    if Input.repeat?(Input::RIGHT)
      indexes = get_dir(:right)
      check_hypo_dist(indexes)
      #$game_system.se_play($data_system.cursor_se)
      #@index -= 4
      #$game_troop.enemies.size.times do
      #  @index %= $game_troop.enemies.size
      #  break if self.enemy.exist?
      #  @index += 1
      #  @index %= $game_troop.enemies.size
      #end
    end
    # Cursor left
    if Input.repeat?(Input::LEFT)
      indexes = get_dir(:left)
      check_hypo_dist(indexes)
      #$game_system.se_play($data_system.cursor_se)
      #@index += 4
      #$game_troop.enemies.size.times do
      #  @index %= $game_troop.enemies.size
      #  break if self.enemy.exist?
      #  @index += $game_troop.enemies.size - 1
      #  @index %= $game_troop.enemies.size
      #end
    end
    # Set sprite coordinates
    if self.enemy != nil
      self.x = self.enemy.screen_x + RPG::ARROW_ENEMY_OFFSET[0]
      self.y = self.enemy.screen_y - self.enemy.height + RPG::ARROW_ENEMY_OFFSET[1]
      @r_x = self.enemy.screen_x
      @r_y = self.enemy.screen_y
    end
  end
  
  def check_hypo_dist(indexes)
    #print indexes
    dist_wi = [ 0 , @index ]
    indexes.each{|i|
      a = hypo_distance($game_troop.enemies[i].screen_x,$game_troop.enemies[i].screen_y)
      dist_wi = [a,i] if ((dist_wi[0] > a) || (dist_wi[0]==0))
      #print dist_wi
    }
    @index = dist_wi[1]
  end
  
  def hypo_distance(x,y)
    n_x = (@r_x - x).abs
    n_y = (@r_y - y).abs
    return Math.sqrt((n_x*n_x)+(n_y*n_y))
  end
  
  def get_dir(angle)
    indexes = []
    $game_troop.enemies.each_with_index{|enemy,i|
      next unless enemy.exist?
      # Check if enemy is below
      rad = calc_rad($game_troop.enemies[i].screen_x,$game_troop.enemies[i].screen_y)
      #print rad
      rad2 = (angle == :down || angle == :up) ? (rad>0.25) : (rad<0.25)
      case angle
      when :down
        indexes.push(i) if (enemy.screen_y > @r_y)&&(rad2)
      when :up
        indexes.push(i) if (enemy.screen_y < @r_y)&&(rad2)
      when :left
        indexes.push(i) if (enemy.screen_x < @r_x)&&(rad2)
      when :right
        indexes.push(i) if (enemy.screen_x > @r_x)&&(rad2)
      end
    }
    indexes
  end
  def calc_rad(x,y)
    n_x = (@r_x - x).abs
    n_y = (@r_y - y).abs
    return 0.5 if n_x==0
    return Math.atan(n_y/n_x).abs
  end
end

#==============================================================================
# ** Arrow_Actor
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose an actor. This class inherits from the
#  Arrow_Base class.
#==============================================================================

class Arrow_Actor < Arrow_Base
  
  def initialize(viewport)
    super(viewport)
    @hor_index = 0
    @vert_index = 0
    search_specific(@index+1)
  end
  
  def index=(val)
    @index = val
    search_specific(val+1)
  end
  
  def f_matrix
    return FormationInfo::F_MATRIX[$game_system.abatxp_form_id]
  end
  
  def search_vert(down=false,both=false)
    mat = f_matrix[@hor_index]
    tmp_index=0
    for i in 1..4
      tmp_index= down==true ? @vert_index+i : @vert_index-i
      tmp_index= [ [tmp_index , 4].min , 0].max
      @vert_index=tmp_index if mat[tmp_index] != 0 and $game_party.actors[mat[tmp_index]-1] != nil
      return true if mat[tmp_index] != 0 and $game_party.actors[mat[tmp_index]-1] != nil
      
      if both==true
        tmp_index= down==true ? @vert_index-i : @vert_index+i
        tmp_index= [[tmp_index , 4].min , 0].max
        
        @vert_index=tmp_index if mat[tmp_index] != 0 and $game_party.actors[mat[tmp_index]-1] != nil
        return true if mat[tmp_index] != 0 and $game_party.actors[mat[tmp_index]-1] != nil
        
      end
    end
    return true if mat[@vert_index] != 0
    return false
  end
  
  def search_horiz(right=false)
    bckup_index= @hor_index
    @hor_index= right==true ? @hor_index+1 : @hor_index-1
    @hor_index= [ [@hor_index, 2].min , 0].max
    change = search_vert(false,true)
    if change==false
      @hor_index= right==true ? @hor_index+1 : @hor_index-1
      @hor_index= [ [@hor_index, 2].min , 0].max
      change = search_vert(false,true)
    end
    @hor_index= bckup_index if change==false
  end
  
  def search_specific(number)
    mat = f_matrix
    for i in 0..f_matrix.size-1
      for j in 0..f_matrix[i].size-1
        if f_matrix[i][j]==number
          @hor_index = i
          @vert_index= j
        end
      end
    end
  end
  
  #index = matrix[@hor_index,@vert_index]
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Cursor right
    if Input.repeat?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      #@index += 1
      #@index %= $game_party.actors.size
      search_horiz(true)
      @index = ( f_matrix[@hor_index][@vert_index] ) - 1
    end
    # Cursor left
    if Input.repeat?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      #@index += $game_party.actors.size - 1
      #@index %= $game_party.actors.size
      search_horiz(false)
      @index = ( f_matrix[@hor_index][@vert_index] ) - 1
    end
    if Input.repeat?(Input::UP)
      $game_system.se_play($data_system.cursor_se)
      #@index += $game_party.actors.size - 1
      #@index %= $game_party.actors.size
      search_vert(false)
      @index = ( f_matrix[@hor_index][@vert_index] ) - 1
    end
    if Input.repeat?(Input::DOWN)
      $game_system.se_play($data_system.cursor_se)
      #@index += $game_party.actors.size - 1
      #@index %= $game_party.actors.size
      search_vert(true)
      @index = ( f_matrix[@hor_index][@vert_index] ) - 1
    end
    # Set sprite coordinates
    if self.actor != nil
      self.x = self.actor.screen_x + RPG::ARROW_ACTOR_OFFSET[0]
      self.y = self.actor.screen_y + RPG::ARROW_ACTOR_OFFSET[1]
    end
  end
  
end

##
class Interpreter
#--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all_lp
    # Process with iterator
    $game_party.actors.each{|actor|
      # Recover all LP for actor
      actor.lp = actor.maxlp
    }
    # Continue
    return true
  end
  def victory_bgm=(name)
    $game_system.victory_bgm = name
  end
end
##

#-----------------------------------------------
#Basic definitions. Special screens definitions.
#-----------------------------------------------

#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs equipment screen processing.
#==============================================================================

class Scene_Equip
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(w=0)
    # Set item window to visible
    @item_window1.visible = (@right_window.index <= 3)
    @item_window2.visible = (@right_window.index == 4)
    @item_window3.visible = (@right_window.index == 5)
    @item_window4.visible = (@right_window.index == 6)
    @item_window5.visible = (@right_window.index >= 7)
    # Get currently equipped item
    item1 = @right_window.item
    # Set current item window to @item_window
    case @right_window.index
    when 0..3
      @item_window = @item_window1
    when 4
      @item_window = @item_window2
    when 5
      @item_window = @item_window3
    when 6
      @item_window = @item_window4
    when 7..8
      @item_window = @item_window5
    end
    # If right window is active
    if @right_window.active
      # Erase parameters for after equipment change
      @left_window.set_new_parameters(nil, nil, nil)
    end
    # If item window is active
    if @item_window.active
      # Get currently selected item
      item2 = @item_window.item
      # Change equipment
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
      # Get parameters for after equipment change
      new_atk = @actor.atk(w)
      new_pdef = @actor.pdef
      new_mdef = @actor.mdef
      # Return equipment
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      @actor.hp = last_hp
      @actor.sp = last_sp
      # Draw in left window
      @left_window.set_new_parameters(new_atk, new_pdef, new_mdef)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update windows
    w = @right_window.index < 4 ? @right_window.index : 0
    @left_window.update
    @left_window.refresh(w)
    @right_window.update
    @item_window.update
    refresh(w)
    # If right window is active: call update_right
    if @right_window.active
      update_right
      return
    end
    # If item window is active: call update_item
    if @item_window.active
      update_item
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when right window is active)
  #--------------------------------------------------------------------------
  def update_right
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to menu screen
      $scene = Scene_Menu.new(2)
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # If equipment is fixed
      if @actor.equip_fix?(@right_window.index)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Activate item window
      @right_window.active = false
      @item_window.active = true
      @item_window.index = 0
      return
    end
    # If R button was pressed
    if Input.trigger?(Input::R)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To next actor
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      # Switch to different equipment screen
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
    # If L button was pressed
    if Input.trigger?(Input::L)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To previous actor
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      # Switch to different equipment screen
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
  end
  
end

#==============================================================================
# ** Scene_Formations
#------------------------------------------------------------------------------
#  Permits to change formations from the menu.
#==============================================================================

class Scene_Formations
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    #Create objects
    $game_temp.battleback_name = $game_map.battleback_name
    @spriteset = Spriteset_Battle.new
    
    #Formation-related stuff on main
    @form_window = Window_Formation.new(256)
    @form_window.visible = true
    @form_window.active = true
    active_f = @form_window.active_index
    @form_window.draw_item(active_f, @form_window.system_color)
    
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    @spriteset.dispose
    @form_window.dispose
    # Prepare for transition
    Graphics.freeze
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @spriteset.update
    @form_window.update
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      $game_system.abatxp_form_id = @form_window.selected_formation
      $game_party.change_positions
      active_f = @form_window.active_index
      @form_window.refresh
      @form_window.draw_item(active_f, @form_window.system_color)
      @spriteset = Spriteset_Battle.new
      return
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Menu.new
      return
    end
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
    s4 = WindowInfo::MENU_COMMAND_NAMES[0] #Status
    s5 = WindowInfo::MENU_COMMAND_NAMES[1] #Formations
    s6 = WindowInfo::MENU_COMMAND_NAMES[2] #Save
    s7 = WindowInfo::MENU_COMMAND_NAMES[3] #Exit
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
      when 4  # Formation
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Make status window active
        $scene = Scene_Formations.new
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
      end

      return
    end
  end
end