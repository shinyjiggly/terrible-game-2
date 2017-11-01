#--------------------------------------------------------------------------
# * FF V System II
#   system by Fomar0153
# This section is about the jobs themselves and the 
# actors but no interfaces
#--------------------------------------------------------------------------
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
Jobs = [
  {'name'=>"Knight", 'command'=>'!Defend',
  'max_lvl'=>6, 'lvl1'=>10, 'lvl2'=>20, 'lvl3'=>30, 'lvl4'=>40, 'lvl5'=>50, 'lvl6'=>100,
  'ability1'=>'!Defend', 'ability2'=>nil, 'ability3'=>nil, 'ability4'=>nil, 'ability5'=>nil, 'ability6'=>'Equip Sword', 
  'HP'=>20,'SP'=>0,'STR'=>20,'DEX'=>10,'INT'=>0,'AGI'=>0,
  'style1'=>'Sword', 'style2'=>'Shield', 'style3'=>'Armour'
  },
  {'name'=>"Mage", 'command'=>'!Ice-Skill',
  'max_lvl'=>6, 'lvl1'=>10, 'lvl2'=>20, 'lvl3'=>30, 'lvl4'=>40, 'lvl5'=>50, 'lvl6'=>100,
  'ability1'=>'!Skill', 'ability2'=>nil, 'ability3'=>nil, 'ability4'=>nil, 'ability5'=>nil, 'ability6'=>'Equip Staff', 
  'HP'=>0,'SP'=>20,'STR'=>0,'DEX'=>0,'INT'=>20,'AGI'=>10,
  'style1'=>'Staff', 'style2'=>'Robe', 'style3'=>'Cloak'
  },
  
  ]
  
  Unemployed = "Job-Free"             #The bare job
  
  Gain_stats = true
  Weapon_style_by_attribute = true #false will mean it is done individually by id
  Change_Graphics = false #if set to true you can specify differant character/battler images for each job
  #--------------------------------------------------------------------------
  # * Weapon/Armour Styles
  #    0 is weapons and 1 is armour
  #--------------------------------------------------------------------------
  def get_style(type, id)
    if Weapon_style_by_attribute == true
      # BY ATTRIBUTE
    if type == 0
      item = $data_weapons[id]
      if item.element_set.include?(17)
        #this element means it requires the ability to wield swords
        return 'Sword'
      end
      if item.element_set.include?(18)
        #this element means it requires the ability to wield staffs
        return 'Staff'
      end
      
    end
    if type == 1
      item = $data_armors[id]
      if item.element_set.include?(17)
        #you can re-use elements for armour for example this can mean shield when tagged on armour
        return 'Shield'
      end
      if item.element_set.include?(19)
        #or to avoid confusion you can use differant ones
        return 'Armour'
      end
    end
    return nil
  else
    # BY ID
    if type == 0
      case id
      when 1
        return 'Sword'
      when 29
         return 'Staff' 
      end
    end
    if type == 1
      case id
      when 1
        return 'Shield'
      end
    end
    return nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update actor_graphics
  #--------------------------------------------------------------------------
  def update_actor_graphics
    case @actor_id
    #note: most people won't know what to do with the hues so I'll leave as their default
      when 1
        
        case @job_current
          when Unemployed
            @battler_name = '001-Fighter01'
            @character_name = '001-Fighter01'
          when 'Knight'
            @battler_name = '001-Fighter01'
            @character_name = '001-Fighter01'
          when 'Mage'
            @battler_name = '001-Fighter01'
            @character_name = '001-Fighter01'
          end
          
      when 2
        
        case @job_current
          when Unemployed
            @battler_name = '010-Lancer02'
            @character_name = '010-Lancer02'
          when 'Knight'
            @battler_name = '010-Lancer02'
            @character_name = '010-Lancer02'
          when 'Mage'
            @battler_name = '010-Lancer02'
            @character_name = '010-Lancer02'
          end
    end
      
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # * Change Job
  #--------------------------------------------------------------------------
  def change_job(prospect)
    last_maxhp = self.maxhp
    last_maxsp = self.maxsp
    old_job = get_job
    @job_current = prospect
    new_job = get_job
    drop_active_abilities(old_job['name'])
    unless prospect == Unemployed
      @active_abilities.push(new_job['command'])
    else
      @active_abilities.push(' ')
    end
    @active_abilities.push(' ')
    if Change_Graphics == true
      update_actor_graphics
    end
    @hp = (@hp.to_f * (self.maxhp.to_f / last_maxhp.to_f)).to_i
    @sp = (@sp.to_f * (self.maxsp.to_f / last_maxsp.to_f)).to_i
  end
  #--------------------------------------------------------------------------
  # * Drop active abilities
  #--------------------------------------------------------------------------
  def change_active_abilities(ability, pos = 1)
    special_unequip(@active_abilities[pos])
    @active_abilities[pos] = ability
    special_equip(@active_abilities[pos])
  end
  #--------------------------------------------------------------------------
  # * Drop active abilities
  #--------------------------------------------------------------------------
  def drop_active_abilities(job_name)
    if job_name == Unemployed
      special_unequip(@active_abilities[0])
    end
    special_unequip(@active_abilities[1])
    @active_abilities = []
  end
  #--------------------------------------------------------------------------
  # * special equip
  #    This is for the non-normal abilities, there are no
  #    examples this is really for scripters rather than
  #    non-scripters
  #--------------------------------------------------------------------------
  def special_equip(ability_name)
      case ability_name
        when ' '
        #having no whens causes an error
        #you would type when and then the ability
        #this is if you have obscure but interesting
        #abilities like duel wielding
        #note:you don't need these for abilities like
        #equip or battle commands
      end
      return
    end
  #--------------------------------------------------------------------------
  # * special unequip
  #    This is for the non-normal abilities, there are no
  #    examples this is really for scripters rather than
  #    non-scripters
  #--------------------------------------------------------------------------
  def special_unequip(ability_name)
      case ability_name
        when ' '
        #having no whens causes an error
        #you would type when and then the ability
        #this is if you have obscure but interesting
        #abilities like duel wielding
        #note:you don't need these for abilities like
        #equip or battle commands
      end
      return
    end
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @job_history = []
    for job in Jobs
    @job_history.push({'name'=>job['name'], 'ap'=>0})
    end
    @job_current = Unemployed
    @abilities = [' ']
    @active_abilities = []
    @name = actor.name
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @battler_name = actor.battler_name
    @battler_hue = actor.battler_hue
    @class_id = actor.class_id
    @weapon_id = actor.weapon_id
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = actor.armor4_id
    @level = actor.initial_level
    @exp_list = Array.new(101)
    make_exp_list
    @exp = @exp_list[@level]
    @skills = []
    @hp = maxhp
    @sp = maxsp
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    # Learn skill
    for i in 1..@level
      for j in $data_classes[@class_id].learnings
        if j.level == i
          learn_skill(j.skill_id)
        end
      end
    end
    # Update auto state
    update_auto_state(nil, $data_armors[@armor1_id])
    update_auto_state(nil, $data_armors[@armor2_id])
    update_auto_state(nil, $data_armors[@armor3_id])
    update_auto_state(nil, $data_armors[@armor4_id])
  end
  
  def abilities(x = 0)
    if x == 0
      return @active_abilities
    elsif x == 1
      return @abilities
    end
  end
  #--------------------------------------------------------------------------
  # * Gain_ap
  #--------------------------------------------------------------------------
  def gain_ap(ap)
    unless @job_current == Unemployed
      for job in @job_history
        if job['name'] == @job_current
          job['ap'] += ap
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Unemployed_text
  #--------------------------------------------------------------------------
  def unemployed_text
    return Unemployed
  end
  #--------------------------------------------------------------------------
  # * Get Job
  #--------------------------------------------------------------------------
  def get_job(job_hunt = @job_current)
    unless job_hunt == Unemployed
    for job in Jobs
      if job['name'] == job_hunt
        return job
      end
    end
  end
  return   {'name'=>Unemployed, 'command'=>' ',
  'max_lvl'=>0, 'lvl1'=>0, 'lvl2'=>0, 'lvl3'=>0, 'lvl4'=>0, 'lvl5'=>0, 'lvl6'=>0,
  'ability1'=>nil, 'ability2'=>nil, 'ability3'=>nil, 'ability4'=>nil, 'ability5'=>nil, 'ability6'=>nil, 
  'HP'=>0,'SP'=>0,'STR'=>0,'DEX'=>0,'INT'=>0,'AGI'=>0,
  'style1'=>nil, 'style2'=>nil, 'style3'=>nil
  }

  end
  
  #--------------------------------------------------------------------------
  # * Job Level
  #--------------------------------------------------------------------------
  def job_level(job_hunt = @job_current)
    unless job_hunt == Unemployed
      for job in @job_history
        if job['name'] == job_hunt
          ap = job['ap']
          lvl = 0
          job_advert = get_job
          for i in 1...job_advert['max_lvl'] + 1
            key = 'lvl' + i.to_s
            if ap >= job_advert[key]
              ap -= job_advert[key]
              lvl += 1
            end
          end
          return lvl
        end
    end
  end
    return 0
  end
  #--------------------------------------------------------------------------
  # * Ap to next Job Level
  #--------------------------------------------------------------------------
  def ap_to_next_job_level(job_hunt = @job_current)
    unless job_hunt == Unemployed
      for job in @job_history
        if job['name'] == job_hunt
          ap = job['ap']
          lvl = 0
          job_advert = get_job
          for i in 1...job_advert['max_lvl'] + 1
            key = 'lvl' + i.to_s
            if ap >= job_advert[key]
              ap -= job_advert[key]
              lvl += 1
            end
          end
          if job_advert['max_lvl'] == lvl
            ap = 0
          end
          return ap
        end
    end
    return 0
  end

  end
  #--------------------------------------------------------------------------
  # * This method could be replaced with an accessor if 
  #    if you like them.
  #--------------------------------------------------------------------------
  def current_job
    return @job_current
  end
  
  #--------------------------------------------------------------------------
  # * Job Level Up
  #--------------------------------------------------------------------------
  def job_level_up(last_level)
    job = get_job
    while (last_level < job_level and last_level < job['max_lvl'])
      last_level += 1
       key = 'ability' + last_level.to_s
       unless job[key] == nil
       @abilities.push(job[key])
       end
       if Gain_stats == true
         @maxhp_plus += job['HP']
         @maxsp_plus += job['SP']
         @str_plus += (job['STR'] / 10)
         @dex_plus += (job['DEX'] / 10)
         @agi_plus += (job['AGI'] / 10)
         @int_plus += (job['INT'] / 10)
       end
    end
  end
  
  #--------------------------------------------------------------------------
  # * First Command
  #--------------------------------------------------------------------------
  def first_command
  if @active_abilities.size > 0
    x = @active_abilities[0]
    if x[0...1] == '!'
      return x[1...x.size]
    end
  end
  return ' '
  end

  #--------------------------------------------------------------------------
  # * Second Command
  #--------------------------------------------------------------------------
  def second_command
  if @active_abilities.size > 1
    x = @active_abilities[1]
    if x[0...1] == '!'
      return x[1...x.size]
    end
  end
  return ' '
  end
  #--------------------------------------------------------------------------
  # * Determine if Equippable
  #     item : item
  #--------------------------------------------------------------------------
  def equippable?(item)
    # If weapon
    if item.is_a?(RPG::Weapon)
      style = get_style(0, item.id)
      # If included among equippable weapons in current class
      if $data_classes[@class_id].weapon_set.include?(item.id)
        if style == nil or @job_current == Unemployed
          return true
        else
          #check if they have the style
          job = get_job
          for i in 1...3
              key = 'style' + i.to_s
              if job[key] == style
                return true
              end
            end
            if (first_command == 'Equip ' + style) or (second_command == 'Equip ' + style)
              return true
            end
        end
      end
    end
    # If armor
    if item.is_a?(RPG::Armor)
      style = get_style(1, item.id)
      # If included among equippable armor in current class
      if $data_classes[@class_id].armor_set.include?(item.id)
        if style == nil or @job_current == Unemployed
          return true
        else
          #check if they have the style
          job = get_job
          for i in 1...3
              key = 'style' + i.to_s
              if job[key] == style
                return true
              end
            end
            if (first_command == 'Equip ' + style) or (second_command == 'Equip ' + style)
              return true
            end
        end
      end
    end
    return false
  end

end






class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    # Add equippable weapons
    if @equip_type == 0
      weapon_set = $data_classes[@actor.class_id].weapon_set
      for i in 1...$data_weapons.size
        if ($game_party.weapon_number(i) > 0 and weapon_set.include?(i)) and (@actor.equippable?($data_weapons[i]))
          @data.push($data_weapons[i])
        end
      end
    end
    # Add equippable armor
    if @equip_type != 0
      armor_set = $data_classes[@actor.class_id].armor_set
      for i in 1...$data_armors.size
        if $game_party.armor_number(i) > 0 and armor_set.include?(i)
          if $data_armors[i].kind == @equip_type-1
            @data.push($data_armors[i])
          end
        end
      end
    end
    # Add blank page
    @data.push(nil)
    # Make a bit map and draw all items
    @item_max = @data.size
    self.contents = Bitmap.new(width - 32, row_max * 32)
    for i in 0...@item_max-1
      draw_item(i)
    end
  end
end

