#==============================================================================
# Add-On: Skill Steal
# by Atoa
#==============================================================================
# This script was modified to work with SBS XP, it allows you to create
# skill that steal items/gold from enemies
# 
# To add the steal effect to an skill, go to the skill extension and add
# the extensio "STEAL".
#
# To add itens to enemies, go to the "module Atoa"
# Enemy_Steal[ID] = {"ITEM" => RATE}
# 
# ID = enemy ID
# ITEM = Type and Item ID. must be always show as "xY"
#  where: 
#  x = type of the item 
#  Y = item ID/amount of money
#  x must be "a" for armors, "w" for weapons, "i" for items, "g" for money
# PORCENTAGEM = % of getting the item, an value bettwen 0 and 100, can be decimal
#   Ex.: 5.4  = 5,4% rate
#
# Ex.: Enemy_Steal[15] = {"w6" => 22.5, "g900" => 12}
# That means the Enemy ID 15 (Enemy_Drops[15])
# Have 22,5% of droping the Weapon ID 6 ("w6" => 22.5)
# and have 12% of droping 900 Gold ("g900" => 12)
#
# You can only steal one item per steal attempt.
#
# You can add as many items you want to an enemy
# 
#==============================================================================


module Atoa
  Enemy_Steal = [] # don't remove/chage this line

  # Enemies can be stolen more than one time?
  Multi_Steal = false
  # If false, you can steal an enemy only once per battle, even if it 
  # have more items (like the old FF's)
    
  # Base Success Rate
  Steal_Rate = 50
  # Even if the rate is 100%, that dont't grants 100% of chance of getting an item
  # this value changes with the difference bettwen, the user and target's AGI, and
  # it still necessary to verify the drop rate of each item
  
  # Message if the target has no items
  No_Item = "Have nothing to Steal"
  
  # Message if the steal attempt fail
  Steal_Fail = "Steal Failed"
  
  # Message of Item steal sucess. {item} is the name of the item, you must add it
  # to the message, or the item name won't be shown
  Steal_Item = "Stole {item}"
  # E.g:
  # "Stole {item}" - Stole Potion
  # "{item} gained" - Potion gained
  
  #  Message of gold steal sucess. {gold}  is the amount of gold, you must add it
  # to the message, or the amount stole won't be shown
  # {unit} the money unit, use it only if you want
  Steal_Gold = "Stole {gold}{unit}"
  # Exemplos:
  # "Stole {gold}{unit}" - Stole 500G
  # "Stole {gold} coins" - Stole 500 coins
  
  # Add here the enemies ID and the items they have
  # Enemy_Steal[Enemy_ID] = {"ITEM" => RATE}
  Enemy_Steal[1] = {"g100" => 50, "w1" => 50, "a1" => 15}
  Enemy_Steal[2] = {"i3" => 22.5, "w2" => 5}

end


#==============================================================================
# RPG::Skill
#==============================================================================
class RPG::Skill
  alias atoa_steal_extension extension
  def extension
    case @id
    when 83
      return ["STEAL"]
    # Add here the skills IDs and the extension of them
    end
    atoa_steal_extension
  end
end

#==============================================================================
# Game_Battler
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  def stole_item_set(user)
    @steal_flag = true
    steal_success = rand(100) < (Steal_Rate + self.steal_attempt) * user.agi / self.agi
    self.steal_attempt += 1
    return false unless steal_success
    return nil if self.steal_items == nil or self.steal_items == []
    item_stole = []
    self.steal_items.each do |item, steal_rate|
      item = item.split('')
      if item[0] == "i"
        item = item.join
        item.slice!("i")
        item_stole.push($data_items[item.to_i]) if rand(1000) < (steal_rate * 10).to_i
      elsif item[0] == "a"
        item = item.join
        item.slice!("a")
        item_stole.push($data_armors[item.to_i]) if rand(1000) < (steal_rate * 10).to_i
      elsif item[0] == "w"
        item = item.join
        item.slice!("w")
        item_stole.push($data_weapons[item.to_i]) if rand(1000) < (steal_rate * 10).to_i
      elsif item[0] == "g"
        item = item.join
        item.slice!("g")
        item_stole.push(item.to_i) if rand(1000) < (steal_rate * 10).to_i
      end
    end
    return false if item_stole == []
    self.steal_attempt = 0
    stole_item_index = rand(item_stole.size)
    item_to_steal = [item_stole[stole_item_index]]
    self.steal_items.delete_at(stole_item_index) if Multi_Steal
    self.steal_items = [] unless Multi_Steal
    return item_to_steal
  end
end

#==============================================================================
# Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  attr_accessor :steal_items
  attr_accessor :steal_flag
  attr_accessor :stole_item 
  attr_accessor :steal_attempt
  #--------------------------------------------------------------------------
  alias initialize_atoa_steal_enemy initialize
  #--------------------------------------------------------------------------
  def initialize(troop_id, member_index)
    initialize_atoa_steal_enemy(troop_id, member_index)
    @steal_items = Enemy_Steal[@enemy_id].to_a
    @stole_item = nil
    @steal_flag = false
    @steal_attempt = 0
  end
end

#==============================================================================
# Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  def pop_steal_help(obj)
    @help_window.set_text(obj, 1)
    count = 0
    loop do
      update_basic
      count += 1
      break @help_window.visible = false if (Input.trigger?(Input::C) and count > 30) or count == 80
    end
  end
  #--------------------------------------------------------------------------
  alias atoa_steal_pop_damage pop_damage
  def pop_damage(target, obj, action)
    if obj.is_a?(RPG::Skill) && obj.extension.include?("STEAL") && ((obj.atk_f == 0 && 
       obj.str_f == 0 && obj.dex_f == 0 && obj.agi_f == 0 && obj.int_f == 0) or obj.power == 0)
      target.missed = target.evaded = false
      target.damage = ""
    end
    atoa_steal_pop_damage(target, obj, action)
  end
  #--------------------------------------------------------------------------
  alias atoa_steal_action_end action_end
  def action_end
    if @active_battler.current_action.kind == 1
      obj = $data_skills[@active_battler.current_action.skill_id]
      if obj.extension.include?("STEAL")
        @target_battlers.each do |battler|
          stole_item = battler.stole_item_set(@active_battler) and battler.is_a?(Game_Enemy)
          if battler.is_a?(Game_Enemy) && battler.steal_flag
            item_stole = stole_item[0] unless stole_item == false or stole_item == nil
            item_stole = nil if stole_item == nil
            item_stole = false if stole_item == false or battler.damage == "Errou!"
            case item_stole
            when nil
              text = No_Item
            when false
              text = Steal_Fail
            when Numeric
              $game_party.gain_gold(item_stole)
              text = Steal_Gold.dup
              text.gsub!(/{gold}/i) {"#{item_stole}"}
              text.gsub!(/{unit}/i) {"#{$data_system.words.gold}"}          
            else
              case item_stole
              when RPG::Item
                $game_party.gain_item(item_stole.id, 1)
                text = Steal_Item.dup
                text.gsub!(/{item}/i) {"#{item_stole.name}"}
              when RPG::Weapon
                $game_party.gain_weapon(item_stole.id, 1)
                text = Steal_Item.dup
                text.gsub!(/{item}/i) {"#{item_stole.name}"}
              when RPG::Armor
                $game_party.gain_armor(item_stole.id, 1)
                text = Steal_Item.dup
                text.gsub!(/{item}/i) {"#{item_stole.name}"}
              end
            end
            pop_steal_help(text)
            battler.steal_flag = false  
            wait(3)
          end
        end
      end
    end
    atoa_steal_action_end
  end
end
