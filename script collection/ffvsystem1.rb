#--------------------------------------------------------------------------
# * FF V System I
#   system by Fomar0153
# This section is about accumulating ap
#--------------------------------------------------------------------------

class Game_Enemy < Game_Battler

#--------------------------------------------------------------------------
# * Get Name
#--------------------------------------------------------------------------
def name
#get the name
name = $data_enemies[@enemy_id].name
#remove the 0s from the start of the name
while name[0] == 48
name = name[1...name.size]
end
#now i get the number and make it into a string so I can see how
#long it is
x = name.to_i
x = x.to_s
name = name[x.size...name.size]
return name
end

#--------------------------------------------------------------------------
# * Get AP
#--------------------------------------------------------------------------
def ap
#get the name where the ap is entered to help people uncomfortable
#with scripts
name = $data_enemies[@enemy_id].name
#lets just have the nice number
name = name.to_i
if name == nil
name = 0
end
return name
end

end



class Scene_Battle

#--------------------------------------------------------------------------
# * Start After Battle Phase
#--------------------------------------------------------------------------
def start_phase5
# Shift to phase 5
@phase = 5
# Play battle end ME
$game_system.me_play($game_system.battle_end_me)
# Return to BGM before battle started
$game_system.bgm_play($game_temp.map_bgm)
# Initialize EXP, amount of gold, and treasure
exp = 0
gold = 0
#oh and AP
ap = 0
treasures = []
# Loop
for enemy in $game_troop.enemies
# If enemy is not hidden
unless enemy.hidden
# Add EXP and amount of gold obtained
exp += enemy.exp
gold += enemy.gold
ap += enemy.ap
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
last_level = actor.job_level
actor.gain_ap(ap)
if actor.job_level > last_level
actor.job_level_up(last_level)
actor.damage = "Job Level Up"
actor.damage_pop = true
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
# Make battle result window
@result_window = Window_BattleResult.new(exp, gold, treasures, ap)
# Set wait count
@phase5_wait_count = 100
end
end

class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  def initialize(exp, gold, treasures, ap = 0)
    @exp = exp
    @gold = gold
    @treasures = treasures
    @ap = ap
    super(160, 0, 320, @treasures.size * 32 + 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.y = 160 - height / 2
    self.back_opacity = 160
    self.visible = false
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    x = 4
    self.contents.font.color = normal_color
    cx = contents.text_size(@exp.to_s).width
    self.contents.draw_text(x, 0, cx, 32, @exp.to_s)
    x += cx + 4
    self.contents.font.color = system_color
    cx = contents.text_size("EXP").width
    self.contents.draw_text(x, 0, 64, 32, "EXP")
    x += cx + 16
    self.contents.font.color = normal_color
    cx = contents.text_size(@gold.to_s).width
    self.contents.draw_text(x, 0, cx, 32, @gold.to_s)
    x += cx + 4
    self.contents.font.color = system_color
    self.contents.draw_text(x, 0, 128, 32, $data_system.words.gold)
    x += cx + 16
    self.contents.font.color = normal_color
    cx = contents.text_size(@ap.to_s).width
    self.contents.draw_text(x, 0, cx, 32, @ap.to_s)
    x += cx + 4
    self.contents.font.color = system_color
    self.contents.draw_text(x, 0, 128, 32, "AP")
    y = 32
    for item in @treasures
      draw_item_name(item, 4, y)
      y += 32
    end
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
