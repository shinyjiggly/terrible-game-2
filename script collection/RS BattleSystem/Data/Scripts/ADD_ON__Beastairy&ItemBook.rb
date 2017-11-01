################################################################################
################################################################################
######################## Cold Books System #####################################
################################################################################
################################################################################
#===============================================================================
# By Cold Strong
#===============================================================================
# Bestiary and Item Book Script
#-------------------------------------------------------------------------------
# ***Necessary Cold Module
#===============================================================================
# How to use:
# To call the Items Menu:
#   - $scene = Scene_ItemsBook.new
# To call the Bestiary Menu:
#   - $scene = Bestiary.new
#-------------------------------------------------------------------------------
# Bugs: cold.strong@hotmail.com
#===============================================================================

$ColdScript ||= {}
$ColdScript["Books System"] = true

if $ColdScript["Books System"]
#===============================================================================
# Overall Customization
#===============================================================================
module Options
  #-----------------------------------------------------------------------------
  # Scope Information
  #-----------------------------------------------------------------------------
  SCOPE_INFO = ["Nothing", "Enemies", "All Enemies", "Ally", "All Alies",
  "Ally (HP 0)", "All Allies (HP 0)", "Hero"]
  #-----------------------------------------------------------------------------
  # Treasure System Active? It's important that you disable if you'll not use it.
  #-----------------------------------------------------------------------------
  TREASURE_ACTIVE = true
  #-----------------------------------------------------------------------------
  # Name of the Atribute that the Treasure item have to has.
  #-----------------------------------------------------------------------------
  TREASURE_ATRIBUTE = "Treasure"
  #-----------------------------------------------------------------------------
  # Animated Background Picture (It must be in past: Graphics/Pictures)
  #-----------------------------------------------------------------------------
  COLD_MENU_PLANE = "item_back"
  
  #=============================================================================
  # Don't touch here
  ENEMY_ITEMS = []
  for i in 1...$data.enemies.size
    ENEMY_ITEMS[i] = []
  end
  #=============================================================================

  #-----------------------------------------------------------------------------
  # Items dropped by monsters, to add a new item you have
  # to use this code:
  # Enemy_items[enemy_id].push([type, id, prob])
  # -------------------------------
  # enemy_id    : ID of the enemy
  # type        : Kind of item (0:Item, 1:Weapon, 2:Armor)
  # id          : ID of the item
  # prob        : Probability of being dropped (%)
  #-----------------------------------------------------------------------------
  ENEMY_ITEMS[1].push( [0, 10, 50] )
  
  #=============================================================================
  # Don't touch here
  ENEMY_DESCRIPTION = []
  for i in 1...$data.enemies.size
    ENEMY_DESCRIPTION[i] = ""
  end
  #=============================================================================

  #-----------------------------------------------------------------------------
  # Enemy Description, to customize:
  # ENEMY_DESCRIPTION[enemy_id] = description
  # -------------------------------
  # enemy_id    : ID of the enemy
  # description : String with the description
  #-----------------------------------------------------------------------------
  ENEMY_DESCRIPTION[1] = "Moles have been always in front of a conspiration to erradicate humanity."
  
  #=============================================================================
  # CUSTOMIZATION END
  #=============================================================================
  ENEMIES_ORDER = {}
  ENEMIES_ORDER["By type"] = []
  for i in 1...$data.enemies.size
    ENEMIES_ORDER["By type"].push(i)
  end
  order = []
  for i in 1...$data.enemies.size
    order.push($data.enemies[i].name)
  end
  ENEMIES_ORDER["Alphabetical"] = order.sort
  for i in 0...ENEMIES_ORDER["Alphabetical"].size
    ENEMIES_ORDER["Alphabetical"][i] = order.index(ENEMIES_ORDER["Alphabetical"][i]) + 1
  end
  ITEMS_ORDER = {}
  order = []
  t_order = []
  for i in 1...$data.items.size
    t_order.push([0,i])
    order.push($data.items[i].name)
  end
  for i in 1...$data.weapons.size
    t_order.push([1,i])
    order.push($data.weapons[i].name)
  end
  for i in 1...$data.armors.size
    t_order.push([2,i])
    order.push($data.armors[i].name)
  end
  ITEMS_ORDER["By type"] = t_order
  order_i = order.sort
  for i in 0...order_i.size
    index = order.index(order_i[i])
    if index >= $data.items.size + $data.weapons.size - 2
      type = 2
      id = order.index(order_i[i]) + 3 - $data.items.size - $data.weapons.size
    elsif index >= $data.items.size - 1
      type = 1
      id = order.index(order_i[i]) + 2 - $data.items.size
    else
      type = 0
      id = order.index(order_i[i]) + 1
    end
    order[order.index(order_i[i])] = "nil!@$%"
    order_i[i] = [type,id]
  end
  ITEMS_ORDER["Alphabetical"] = order_i
  LAYOUTB = true
end

#==============================================================================
# Modulo RPG
#==============================================================================

module RPG
  
  class Item
    def treasure
      treasure_i = $data.system.elements.index(Options::TREASURE_ATRIBUTE) 
      if @element_set.include?(treasure_i)
        return true
      end
      return false   
    end
  end
  
  class Weapon
    
    def treasure
      treasure_i = $data.system.elements.index(Options::TREASURE_ATRIBUTE) 
      if @element_set.include?(treasure_i)
        return true
      end
      return false   
    end
  end
  
  class Armor
    
    def treasure
      treasure_i = $data.system.elements.index(Options::TREASURE_ATRIBUTE) 
      if @guard_element_set.include?(treasure_i)
        return true
      end
      return false   
    end
  end
  
  class Enemy
    def items
      @items ||= []
      return @items
    end
  end
  
end

#==============================================================================
# Modulo Opções
#==============================================================================

module Options
  
  for i in 1...$data.enemies.size
    if $data.enemies[i].item_id > 0
      item_id = $data.enemies[i].item_id
      prob = $data.enemies[i].treasure_prob 
      $data.enemies[i].items.push([0,item_id,prob])
    end
    if $data.enemies[i].weapon_id > 0
      item_id = $data.enemies[i].weapon_id
      prob = $data.enemies[i].treasure_prob 
      $data.enemies[i].items.push([1,item_id,prob])
    end
    if $data.enemies[i].armor_id > 0
      item_id = $data.enemies[i].armor_id
      prob = $data.enemies[i].treasure_prob 
      $data.enemies[i].items.push([1,item_id,prob])
    end
    unless ENEMY_ITEMS[i].nil?
      for item in ENEMY_ITEMS[i]
        $data.enemies[i].items.push(item)
      end
    end
  end
  
end

#==============================================================================
# Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # - Selecionar items que podem dropar 
  #--------------------------------------------------------------------------
  
  def items
    return $data.enemies[@enemy_id].items
  end
  
  #--------------------------------------------------------------------------
  # - Informação para o Bestiário
  #--------------------------------------------------------------------------
  
  def info
    if @info.new
      @info = Game_Info_Enemy.new(id)
    end
  end
end

#==============================================================================
# Window_BattleResult
#------------------------------------------------------------------------------
# Esta janela exibe os tesouros e o dinheiro ganho após uma batalha.
#==============================================================================

class Window_BattleResult < Window_Base
  
  #--------------------------------------------------------------------------
  # - Inicialização dos Objetos
  #
  #     exp       : EXP
  #     gold      : quantidade de dinheiro
  #     treasures : tesouros
  #--------------------------------------------------------------------------
  
  def initialize(exp, gold, treasures)
    @exp = exp
    @gold = gold
    @treasures = treasures
    @text_x = 640
    x = []#treasures.uniq
    super(0, 0, 640, 64)
    #super(0, 0, 320, [x.size, 7].min * 32 + 64)
    #self.width = [(x.size + 7) / 7 * 320, 640].min
    #self.x = (640 - self.width) / 2
    self.contents = Bitmap.new(width - 32, height - 32)
    #self.y = 160 - height / 2
    self.back_opacity = 160
    self.visible = false
    refresh
  end
  
  #--------------------------------------------------------------------------
  # - Atualização
  #--------------------------------------------------------------------------
  
  def refresh
    self.contents.clear
    @text_x = [@text_x-16,0].max
    #x = ((self.width - 32) - 246) / 2
    #self.contents.font.color = normal_color
    #cx = contents.text_size(@exp.to_s).width
    #self.contents.draw_text(x, 0, cx, 32, @exp.to_s)
    #x += cx + 4
    #self.contents.font.color = system_color
    #cx = contents.text_size("EXP").width
    #self.contents.draw_text(x, 0, 64, 32, "EXP")
    #x += cx + 16
    #self.contents.font.color = normal_color
    #cx = contents.text_size(@gold.to_s).width
    #self.contents.draw_text(x, 0, cx, 32, @gold.to_s)
    #x += cx + 4
    #self.contents.font.color = system_color
    #self.contents.draw_text(x, 0, 128, 32, $data_system.words.gold)
    #i = 0
    #t = @treasures.uniq
    #for item in t
    #  number = @treasures.rindex(item) + 1
    #  @treasures.delete(item)
    #  x = i / 7 * (320 - 16) + 4
    #  y = i % 7 * 32 + 32
    #  draw_item_name(item, x, y)
    #  self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    #  self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
    #  i += 1
    #end
    self.contents.font.color = normal_color
    self.contents.draw_text(0+@text_x, 0, 608, 32, "¡Batalla finalizada!",1)
  end
end

#==============================================================================
# Scene_Battle
#==============================================================================

class Scene_Battle    
  
  #--------------------------------------------------------------------------
  # - Processamento Principal
  #--------------------------------------------------------------------------
  
  alias cold_menu_main main unless $@
  def main
    troop = $data.troops[$game_temp.battle_troop_id]
    map_name = $data.map_infos[$game_map.map_id].name
    $game_system.maps_battled.push(map_name)
    for enemy in troop.members
      $game_system.info_enemy(enemy.enemy_id).battled += 1
      unless $game_system.info_enemy(enemy.enemy_id).habitat.include?(map_name)
        $game_system.info_enemy(enemy.enemy_id).habitat.push(map_name)
      end
    end
    cold_menu_main
  end
  
  #--------------------------------------------------------------------------
  # - Fim da Batalha
  #
  #     result : resultado (0=vitória, 1=derrota e 2=fuga)
  #--------------------------------------------------------------------------
  
  alias cold_menu_battle_end battle_end unless $@
  def battle_end(result)
    for enemy in $game_troop.enemies
      if enemy.dead?
        $game_system.info_enemy(enemy.id).killed += 1
      end
    end
    $actor_index = nil
    # Added for RTAB Patch version
    #@party_command_window.dispose
    #@help_window.dispose
    #@status_window.dispose
    #@message_window.dispose
    # End of RTAB Patch Version
    cold_menu_battle_end(result)
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame
  #--------------------------------------------------------------------------
  
  alias cold_menu_update update unless $@
  def update
    $actor_index = @actor_index
    unless @active_battler.nil? 
      $actor_index = @active_battler.index
    end
    cold_menu_update
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame (Fase de Pós-Batalha)
  #--------------------------------------------------------------------------
  
  def start_phase5
    # Alternar para a fase 5
    @phase = 5
    # Reproduzir ME de fim de Batalha
    $game_system.me_play($game_system.battle_end_me)
    # Retornar para BGM de antes da Batalha ser iniciada
    #$game_system.bgm_play($game_temp.map_bgm)
    # Inicializar EXP, quantidade de dinheiro e tesouros
    exp = 0
    gold = 0
    treasures = []
    # Loop
    for enemy in $game_troop.enemies
      # Se o Inimigo não estiver escondido
      unless enemy.hidden
        # Adicionar a EXP e a quantidade de dinheiro obtidos
        exp += enemy.exp
        gold += enemy.gold
        # Determinar se aparece algum tesouro
        for item in enemy.items
          if rand(100) < item[2]
            case item[0]
            when 0
              treasures.push($data_items[item[1]])
              $game_system.info_enemy(enemy.id).gained_item(item[1])
            when 1
              treasures.push($data_weapons[item[1]])
              $game_system.info_enemy(enemy.id).gained_weapon(item[1])
            when 2
              treasures.push($data_armors[item[1]])
              $game_system.info_enemy(enemy.id).gained_armor(item[1])
            end
          end
        end
      end
    end
    old_treasures = [] + treasures
    treasures.clear
    i = 0
    for treasure in old_treasures
      treasures[i] = Array.new(old_treasures.rindex(treasure), treasure)
      old_treasures.delete(treasure)
      i += 1
    end
    # o Limite de tesouros é de 14 Itens
    treasures = treasures[0..13]
    treasures.flatten!
    # Obtendo a EXP
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
    # Obtendo o dinheiro
    $game_party.gain_gold(gold)
    # Obtendo os tesouros
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
    # Criar janela de resultado de Batalha
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    # Definir Espera
    @phase5_wait_count = 50
  end
end

#==============================================================================
# Game_Info_Enemy
#==============================================================================

class Game_Info_Enemy
  
  attr_accessor :battled
  attr_accessor :killed
  attr_reader   :id
  attr_reader   :name
  attr_reader   :items
  attr_reader   :armors
  attr_reader   :weapons
  attr_accessor :habitat
  attr_reader   :description
  
  def initialize(id)
    @battled = 0
    @killed = 0
    @enemy = $data_enemies[id]
    @name = @enemy.name
    @id = id
    @items = {}
    for i in 1...$data.items.size
      @items[i] = 0
    end
    @weapons = {}
    for i in 1...$data.weapons.size
      @weapons[i] = 0
    end
    @armors = {}
    for i in 1...$data.armors.size
      @armors[i] = 0
    end
    @habitat = []
  end

  def exp
    return @enemy.exp if @killed
  end
  
  def gold
    return @enemy.gold if @killed
  end
  
  def gained_item(id)
    @items[id] = @items[id] + 1
  end
  
  def gained_weapon(id)
    @weapons[id] = @weapons[id] + 1
  end
  
  def gained_armor(id)
    @armors[id] = @armors[id] + 1
  end
end

#==============================================================================
# Game_System
#==============================================================================

class Game_System
  
  #--------------------------------------------------------------------------
  # - Mapas que ocorreram batalhas
  #--------------------------------------------------------------------------
  
  def maps_battled
    @maps_battled ||= []
    return @maps_battled
  end
  
  #--------------------------------------------------------------------------
  # - info_enemy(id)
  #
  #     retorna as informações de um inimigo para ser usado no bestiario.
  #--------------------------------------------------------------------------
  
  def info_enemy(id)
    if id > 999 or $data_enemies[id].nil?
      return nil
    end
    @info_enemies ||= []
    if @info_enemies[id].nil?
      @info_enemies[id] = Game_Info_Enemy.new(id)
    end
    return @info_enemies[id]
  end
  
  #--------------------------------------------------------------------------
  # - Item Obtidos
  #--------------------------------------------------------------------------
  
  def items_obtained
    if @items_obtained.nil?
      @items_obtained = []
      for i in 1...$data_items.size
        @items_obtained[i] = false
      end
    end
    return @items_obtained
  end
  
  #--------------------------------------------------------------------------
  # - Equipamentos de def. obtidos
  #--------------------------------------------------------------------------
  
  def armors_obtained
    if @armors_obtained.nil?
      @armors_obtained = []
      for i in 1...$data_armors.size
        @armors_obtained[i] = false
      end
    end
    return @armors_obtained
  end
  
  #--------------------------------------------------------------------------
  # - Armas obtidas
  #--------------------------------------------------------------------------
  
  def weapons_obtained
    if @weapons_obtained.nil?
      @weapons_obtained = []
      for i in 1...$data_weapons.size
        @weapons_obtained[i] = false
      end
    end
    return @weapons_obtained
  end
  
  #--------------------------------------------------------------------------
  # - Hash para armazenar dados
  #--------------------------------------------------------------------------
  
  def save_hash
    @save_hash ||= {}
    return @save_hash
  end
end

#==============================================================================
# Game_Party
#==============================================================================

class Game_Party
  
  alias cold_bs_gain_item gain_item unless $@
  def gain_item(id, n)
    $game_system.items_obtained[id] = true
    cold_bs_gain_item(id, n)
  end
  
  alias cold_bs_gain_armor gain_armor unless $@
  def gain_armor(id, n)
    $game_system.armors_obtained[id] = true
    cold_bs_gain_armor(id, n)
  end
  
  alias cold_bs_gain_weapon gain_weapon unless $@
  def gain_weapon(id, n)
    $game_system.weapons_obtained[id] = true
    cold_bs_gain_weapon(id, n)
  end
end

#==============================================================================
# Game_Actor
#==============================================================================

class Game_Actor
  
  alias cold_bs_setup setup unless $@
  def setup(id)
    cold_bs_setup(id)
    $game_system.weapons_obtained[@weapon_id[0]] = true
    $game_system.armors_obtained[armor1_id] = true
    $game_system.armors_obtained[armor2_id] = true
    $game_system.armors_obtained[armor3_id] = true
    $game_system.armors_obtained[armor4_id[0]] = true
  end
  
end

#==============================================================================
# Window_BookCommand
#==============================================================================

class Window_BookCommand < Window_Base
  
  attr_reader   :index
  
  def initialize
    super(0,0,128+32,64)
    self.contents = Bitmap.new(640-32,480-32)
    self.contents.font.size = 14
    self.contents.font.color = normal_color
    self.z = 999999
    self.opacity = 0
    @line_max = 12
    @column_max = 2
    @index = 0
    @type_index = 0
    @item_max = 0
    @type_max = 0
  end
  
  def command
    return @commands[@index]
  end
  
  def type
    return @types[@type_index]
  end
  
  def refresh(text,types, commands)
    self.contents.clear
    self.height = commands.size*22 + 86 + 24
    self.x = (640-self.width)/2
    if Options::LAYOUTB
      self.y = 50+48
    else
      self.y = (480-self.height)/2
    end
    self.contents = Bitmap.new(128, commands.size*22+54+24)
    self.contents.font.size = 14
    self.contents.font.color = normal_color
    @types = types
    @commands = commands
    @item_max = commands.size
    @type_max = types.size
    for i in 0...commands.size
      x = 0
      y = i * 22 + 32 + 24
      self.contents.draw_text(x,y,128,22,@commands[i],1)
    end
    width = define_width(@types)
    x = (128-width)/2
    self.contents.draw_text(x-22, 24, 14, 22, "??")
    self.contents.draw_text(x+width+8, 24, 14, 22, "??")
    self.contents.draw_text(x-22, 0, width - 20, 24, text,2)
    draw_type
  end
  
  def define_width(array)
    contents = Bitmap.new(640,480)
    contents.font.size = 14
    width = 0
    for command in array
      p_width = contents.text_size(command).width
      if p_width > width
        width = p_width
      end
    end
    return [width, 128-44].max
  end
  
  def draw_type
    if @type_index != @last_t_index
      @last_t_index = @type_index
      width = define_width(@types)
      x = (128-width)/2
      rect = Rect.new(x, 24, width, 22)
      self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
      self.contents.draw_text(rect, @types[@type_index],1)
    end
  end
  
  def update
    super
    if self.active and @item_max > 0 and @index >= 0
      if Input.repeat?(Input::DOWN)
        if Input.trigger?(Input::DOWN) or @index < @item_max - 1
          $game_system.se_play($data_system.cursor_se)
          @index = (@index + 1) % @item_max
        end
      end
      if Input.repeat?(Input::UP)
        if Input.trigger?(Input::UP) or @index >= 1
          $game_system.se_play($data_system.cursor_se)
          @index = (@index - 1 + @item_max) % @item_max
        end
      end
      if Input.repeat?(Input::RIGHT)
        $game_system.se_play($data_system.cursor_se)
        @type_index = (@type_index + 1) % @type_max
      end
      if Input.repeat?(Input::LEFT)
        $game_system.se_play($data_system.cursor_se)
        @type_index = (@type_index - 1) % @type_max
      end
    end
    draw_type
    update_cursor_rect
  end
  
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.clear
      return
    end
    y = @index * 22 + 32 + 24
    self.cursor_rect.set(0, y, self.width-32, 22)
  end
end

#==============================================================================
# Window_Book
#==============================================================================

class Window_Book < Window_Base
  
  attr_reader   :index
  
  def initialize
    super(0,0,160*2+32,12*22+37+32)
    self.contents = Bitmap.new(640-32,480-32)
    self.contents.font.size = 14
    self.contents.font.color = normal_color
    self.opacity = 0
    self.x = (640 - self.width) / 2
    self.y = (480 - (12*22+32)) / 2
    self.z = 999999
    self.active = false
    self.visible = false
    @line_max = 12
    @column_max = 2
    @item_max = 1
    @page = 0
    self.index = 0
    commands = []
    for i in 1..500
      if $data.items[i].nil?
        commands.push("???")
      else
        commands.push($data.items[i].name)
      end
    end
    #refresh(commands)
  end
  
  def define_width(array)
    contents = Bitmap.new(640,480)
    contents.font.size = 14
    width = 0
    for command in array
      p_width = contents.text_size(command).width
      if p_width > width
        width = p_width
      end
    end
    return [width, 128-44].max
  end
  
  def index=(index)
    @index = index
    self.page = (@index/item_max_per_pag) if index >= 0
    self.page = 0 if index < 0
    if self.active and @help_window != nil
      update_help
    end
    update_cursor_rect
  end
  
  def page=(page)
    @page = page
  end
  
  def page_max
    page = (@item_max / (@column_max * @line_max))
    page += 1 if (@item_max % (@column_max * @line_max)) > 0
    return page
  end
  
  def item_max_per_pag
    return (@column_max * @line_max)
  end
  
  def column_total
    column_total = (@column_max * (page_max - 1))
    i = [@item_max - item_max_per_pag, @column_max].min
    column_total += i
    return column_total
  end
  
  def show_page
    self.ox = @page * (self.width - 32)
  end

  def help_window=(help_window)
    @help_window = help_window
    if self.active and @help_window != nil
      update_help
    end
  end
  
  def refresh(commands)
    self.contents.clear
    @commands = commands
    @item_max = commands.size
    self.contents = Bitmap.new(160*2*[page_max, 1].max,height-32)
    self.contents.font.size = 14
    self.contents.font.color = normal_color
    for i in 0...commands.size
      x = i / 12 * 160
      y = i % 12 * 22
      self.contents.draw_text(x+4,y+4,160,18,@commands[i])
    end
    for pag in 0...page_max
      rect = Rect.new(pag*320, 22*12+4, 320, 1)
      self.contents.fill_rect(rect, normal_color)
      x = (self.width-32)/2 + pag*320
      y = 22*12+5
      self.contents.draw_text(x-28-22, y, 14, 32, "??")
      self.contents.draw_text(x+28, y, 14, 32, "??")
      p = pag + 1
      text = "Pag  " + p.to_s + "/" + page_max.to_s
      self.contents.draw_text(x-32, y, 56, 32, text, 1)
    end
  end
  
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
      return
    end
    show_page
    x = @index / 12 * 160 - self.ox
    y = @index % 12 * 22
    self.cursor_rect.set(x, y, 160, 22)
  end
  
  def update
    super
    if self.active and @item_max > 0 and @index >= 0
      x = @index - ((item_max_per_pag) * @page)
      if Input.repeat?(Input::DOWN)
        if @index % @line_max < @line_max - 1 and
          @index + 1 < @item_max
          $game_system.se_play($data_system.cursor_se)
          @index += 1
        end
      end
      if Input.repeat?(Input::UP)
        if @index > 0 and @index % @line_max > 0
          $game_system.se_play($data_system.cursor_se)
          @index -= 1
        end
      end
      if Input.repeat?(Input::RIGHT)
        if @index + @line_max < (@page+1) * item_max_per_pag and 
          @index / 24 == @page and @index + @line_max < @item_max
          $game_system.se_play($data_system.cursor_se)
          @index += @line_max
        elsif ((@index / @line_max) % @column_max == @column_max - 1 and Input.trigger?(Input::RIGHT)) or
              ((@index / @line_max) % @column_max == @column_max - 1 and @page < page_max - 1)
          $game_system.se_play($data_system.cursor_se)
          if @page == page_max - 1
            self.index = (@index + item_max_per_pag) % (page_max * item_max_per_pag)
          else
            self.index = [@index + item_max_per_pag, @item_max-1].min
          end
        end
      end
      if Input.repeat?(Input::LEFT)
        if @index - @line_max >= @page * item_max_per_pag
          $game_system.se_play($data_system.cursor_se)
          @index -= @line_max
        elsif ((@index / @line_max) % @column_max == 0 and Input.trigger?(Input::LEFT)) or
              ((@index / @line_max) % @column_max == 0 and @page > 0)
          $game_system.se_play($data_system.cursor_se)
          if @page == 0
            #x = @index - 24
            self.index = [@index + ((page_max - 1) * item_max_per_pag), @item_max-1].min
            #self.index = [(page_max - 1) * item_max_per_pag - x, @item_max-1].min
          else
            self.index = [@index - item_max_per_pag, 0].max
          end
        end
      end
    end
    if self.active and @help_window != nil
      update_help
    end
    update_cursor_rect
  end
end

#==============================================================================
# Window_Enemy
#==============================================================================

class Window_Enemy < Window_Base
  
  attr_reader   :enemy_id
  
  def initialize(enemy_id)
    super(48,52,544,398-32)
    self.opacity = 0
    self.z = 1000
    @self_active = true
    self.active = false
    self.visible = false
    refresh(enemy_id)
  end
  
  def need_refresh?(killed)
    return (@need_refresh[0] != killed)
  end
  
  def visible=(value)
    super(value)
    @view.visible = value unless @view.nil?
  end
  
  def dispose
    super
    @view.dispose if @view != nil #unless @view.nil? #//= value 
  end
  
  def refresh(enemy_id)
    @enemy_id = enemy_id
    @enemy = $game_system.info_enemy(enemy_id)
    @index = 0
    @items = []
    for i in 1...$data.items.size
      if @enemy.items[i] > 0
        @items.push($data_items[i])
      end
    end
    for i in 1...$data.weapons.size
      if @enemy.weapons[i] > 0
        @items.push($data_weapons[i])
      end
    end
    for i in 1...$data.armors.size
      if @enemy.armors[i] > 0
        @items.push($data_armors[i])
      end
    end
    @maps = @enemy.habitat
    i_m = [@items.size, 6 - [@maps.size, 3].min].min
    @max_items = [[[@items.size, 0].max, 6].min - @maps.size, i_m].max
    m_m = [@maps.size, 6 - @max_items].min
    @max_maps = [[[@maps.size, 0].max, 6].min - @items.size, m_m].max
    @need_refresh = [0 + @enemy.killed,0 + @enemy.battled]
    self.contents = Bitmap.new(self.width-32,self.height-32)
    self.contents.font.size = 14
    self.contents.font.color = normal_color
    draw_name(0, 0)
    draw_battler(0,22)
    draw_exp(384, 22)
    draw_gold(384, 44)
    draw_killed(384, 66)
    draw_parameters(256,0)
    self.contents.draw_text(384, 88, 124, 18, "Obtained Items :")
    rect = Rect.new(380,106,130,1)
    self.contents.fill_rect(rect, normal_color)
    draw_items(380, 107)
    i_size = @max_items*21
    self.contents.draw_text(384, 110+i_size, 124, 18, "Habitat:")
    rect = Rect.new(380,128+i_size,130,1)
    self.contents.fill_rect(rect, normal_color)
    draw_maps(380, 129+i_size)
    y = 67+67+23+23+88+4
    if Options::ENEMY_DESCRIPTION[@enemy.id] != ""
      self.contents.draw_text(4, y-20, 68, 22, "Description:")
      rect = Rect.new(0, y-1, 68, 1)
      self.contents.fill_rect(rect, normal_color)
    end
    draw_description(0,y)
  end

  def draw_name(x,y)
    id = sprintf("%03d", @enemy.id.to_s)
    name = id + ": " + @enemy.name
    width = self.contents.text_size(name).width
    self.contents.draw_text(x + 4, y, width, 22, name)
    rect = Rect.new(x,y+19,width+8,1)
    self.contents.fill_rect(rect, normal_color)
  end
  
  def draw_enemy_parameter(x, y, type)
    enemy=Game_Enemy.new(-1,@enemy_id)
    case type
    when 0
      parameter_name = $data_system.words.atk
      parameter_value = enemy.atk
    when 1
      parameter_name = $data_system.words.pdef
      parameter_value = enemy.pdef
    when 2
      parameter_name = $data_system.words.mdef
      parameter_value = enemy.mdef
    when 3
      parameter_name = $data_system.words.str
      parameter_value = enemy.str
    when 4
      parameter_name = $data_system.words.dex
      parameter_value = enemy.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = enemy.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = enemy.int
    when 7
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[0]
      parameter_value = enemy.eva
    when 8
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[1]
      parameter_value = enemy.m_eva
    when 9
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[2]
      parameter_value = enemy.hit
    when 10
      parameter_name = WindowInfo::EXTRA_ATTRIBUTES[3]
      parameter_value = enemy.hit_num
    end
    
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 0, y, 96, 32, parameter_value.to_s, 2)
  end
  def draw_parameters(x,y)
    self.contents.fill_rect(x-8,y,112,LINE_HEIGHT*11+8,Color.new(0,0,0,128))
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*0, 3)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*1, 4)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*2, 5)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*3, 6)
    
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*4, 0)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*5, 1)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*6, 7)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*7, 2)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*8, 8)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*9, 9)
    draw_enemy_parameter(x, y+WindowInfo::LINE_HEIGHT*10, 10)
  end
  
  def draw_exp(x,y)
    self.contents.draw_text(x, y, 64, 22, "Exp: ")
    if @enemy.killed > 0
      exp = @enemy.exp.to_s
      self.contents.draw_text(x + 64, y, 60, 22, exp, 2)
    else
      self.contents.draw_text(x + 64, y, 60, 22, "???", 2)
    end
  end
  
  def draw_gold(x,y)
    g = $data_system.words.gold
    self.contents.draw_text(x, y, 64, 22, g)
    if @enemy.killed > 0
      gold = @enemy.gold.to_s
      self.contents.draw_text(x + 64, y, 60, 22, gold, 2)
    else
      self.contents.draw_text(x + 64, y, 60, 22, "???", 2)
    end
  end
  
  def draw_killed(x,y)
    self.contents.draw_text(x, y, 64, 22, "Defeated:")
    #if @enemy.killed > 0
    self.contents.draw_text(x + 64, y, 60, 22, @enemy.killed.to_s, 2)
    #end
  end
  
  def draw_items(x,y)
    @items_x = x
    @items_y = y
    @items_index = 0
    @items_active = false
    @items_oy = 0
    y2 = 0
    z = [@items.size * 21, (@max_items - 1)*21].min
    for item in @items
      if y2.between?(@items_oy, z) 
        draw_item(item, x+4, y + y2)
        y2 += 21
      end
    end
  end
  
  def draw_item(item, x, y)
    rect = Rect.new(x, y, 124, 21)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    name = item.name
    self.contents.draw_text(x+2, y, 100, 20, name)
    case item
    when RPG::Item
      number = @enemy.items[item.id]
    when RPG::Weapon
      number = @enemy.weapons[item.id]
    when RPG::Armor
      number = @enemy.armors[item.id]
    end
    self.contents.draw_text(x+104, y, 18, 20, number.to_s, 2)
    rect = Rect.new(x, y + 20, 124, 1)
    self.contents.fill_rect(rect, normal_color)
  end
  
  def refresh_items
    row = @items_index
    if row < @items_oy / 21
      @items_oy = self.top_row(row, @items.size)
    end
    if row > @items_oy / 21 + (@max_items - 1)
      @items_oy = self.top_row(row - (@max_items - 1), @items.size)
    end
    x = @items_x
    y = @items_y
    y2 = 0
    y3 = 0
    z = [@items.size * 21, (@max_items - 1)*21].min + @items_oy
    for item in @items
      if y2.between?(@items_oy, z) 
        draw_item(item, x+4, y + y3)
        y3 += 21
      end
      y2 += 21
    end
  end
  
  def draw_maps(x,y)
    @maps_x = x
    @maps_y = y
    @maps_index = 0
    @maps_active = false
    @maps_oy = 0
    y2 = 0
    z = [@maps.size * 21, (@max_maps - 1)*21].min
    for map in @maps
      if y2.between?(@maps_oy, z)
        draw_map(map, x, y + y2)
        y2 += 21
      end
    end
  end
  
  def draw_map(map, x, y)
    rect = Rect.new(x + 4, y, 124, 21)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(x + 6, y, 122, 20, map)
    rect = Rect.new(x + 4, y + 20, 124, 1)
    self.contents.fill_rect(rect, normal_color)
  end
  
  def refresh_maps
    row = @maps_index
    if row < @maps_oy / 21
      @maps_oy = self.top_row(row, @maps.size)
    end
    if row > @maps_oy / 21 + (@max_maps - 1)
      @maps_oy = self.top_row(row - (@max_maps - 1), @maps.size)
    end
    x = @maps_x
    y = @maps_y
    y2 = 0
    y3 = 0
    z = [@maps.size * 21, (@max_maps - 1)*21].min + @maps_oy
    for map in @maps
      if y2.between?(@maps_oy, z)
        draw_map(map, x, y + y3)
        y3 += 21
      end
      y2 += 21
    end
  end
  
  def draw_description(x, y)
    e_description = Options::ENEMY_DESCRIPTION[@enemy.id]
    description = lines(e_description, self.width - 32)
    for i in 0...description.size
      self.contents.draw_text(x+4, y+2+i*20, self.width - 32, 20, description[i])
    end
  end
  
  def line(text)
    words = text.split(" ")
    return_text = ""
    for word in words
      x = "!@$%¨&*()"
      return_text += word + x + " "
      return_text2 = return_text.gsub(x,"")
      t_width = self.contents.text_size(return_text2).width
      if t_width > self.width - 32
        return return_text.gsub(" "+word+x, "")
      else
        return_text.gsub!(word+x, word)
      end
    end
  end
  
  def draw_battler(x, y)
    enemy = $data.enemies[@enemy.id]
    bitmap = RPG::Cache.battler(enemy.battler_name, enemy.battler_hue)
    @view = Viewport.new(0, 0, 640, 480)
    @view.z = self.z - 10
    @view.visible = self.visible
    @sprite = Sprite.new(@view)
    @sprite.bitmap =  bitmap
    w = bitmap.width
    h = bitmap.height
    @sprite.x = x + (256 - w)/2 + self.x + 16
    @sprite.y = y + (256 - h)/2 + self.y + 16
  end
  
  def update
    super
    if @self_active and self.active
      if Input.repeat?(Input::DOWN)
        $game_system.se_play($data_system.cursor_se)
        @index = (@index + 1) % 2
      end
      if Input.repeat?(Input::UP)
        $game_system.se_play($data_system.cursor_se)
        @index = (@index - 1 + 2) % 2
      end
      if Input.repeat?(Input::RIGHT)
        case @index
        when 0
          if @items.size > 0
            $game_system.se_play($data_system.cursor_se)
            @self_active = false
            @items_active = true
          end
        when 1
          if @maps.size > 0
            $game_system.se_play($data_system.cursor_se)
            @self_active = false
            @maps_active = true
          end
        end
      end
    elsif @items_active and self.active and @items.size > 0
      if Input.repeat?(Input::DOWN)
        $game_system.se_play($data_system.cursor_se)
        @items_index = (@items_index + 1) % @items.size
        refresh_items
      end
      if Input.repeat?(Input::UP)
        $game_system.se_play($data_system.cursor_se)
        @items_index = (@items_index - 1 + @items.size) % @items.size
        refresh_items
      end
      if Input.repeat?(Input::LEFT)
        $game_system.se_play($data_system.cursor_se)
        @self_active = true
        @items_active = false
      end
    elsif @maps_active and self.active and @maps.size > 0
      if Input.repeat?(Input::DOWN)
        $game_system.se_play($data_system.cursor_se)
        @maps_index = (@maps_index + 1) % @maps.size
        refresh_maps
      end
      if Input.repeat?(Input::UP)
        $game_system.se_play($data_system.cursor_se)
        @maps_index = (@maps_index - 1 + @maps.size) % @maps.size
        refresh_maps
      end
      if Input.repeat?(Input::LEFT)
        $game_system.se_play($data_system.cursor_se)
        @self_active = true
        @maps_active = false
      end
    end
    update_cursor
  end
  
  def update_cursor
    if @self_active and self.active
      i_size = @max_items * 21 + 22
      y = 88 + i_size * @index
      self.cursor_rect.set(384, y, 128, 18)
    elsif @items_active and self.active
      y = 88 + 21*@items_index + 19 - @items_oy
      self.cursor_rect.set(380, y, 124, 20)
    elsif @maps_active and self.active
      i_size = @max_items * 21 + 22
      y = 88 + 21*@maps_index + 19 - @maps_oy + i_size
      self.cursor_rect.set(380, y, 124, 20)
    elsif !self.active
      self.cursor_rect.empty
    end
  end
  
  def top_row(row, row_max)
    if row < 0
      row = 0
    end
    if row > row_max - 1
      row = row_max - 1
    end
    return row * 21
  end
end


#==============================================================================
# Window_Enemies
#==============================================================================

class Window_Enemies
  
  attr_accessor :active
  
  def initialize
    @index = 0
    @windows = []
    @last_index = 0
    @active = false
    self.visible = false
  end 
    
  def visible=(value)
    @visible = value
    @windows[@index].visible = value if @windows[@index].is_a?(Window)
  end
  
  def refresh(windows)
    @windows[@index].visible = false if @windows[@index].is_a?(Window)
    @windows[@index].active = false if @windows[@index].is_a?(Window)
    @windows = windows
    @index = 0
    @windows[@index].visible = true if @windows[@index].is_a?(Window)
  end
  
  def index=(i)
    @windows[@index].visible = false
    @windows[@index].active = false
    @index = i % @windows.size
    @windows[@index].visible = true
  end

  def update
    for window in @windows
      window.update if window.is_a?(Window)
    end
    if self.active and !@windows[@index].active
      if Input.repeat?(Input::RIGHT)
        if Input.trigger?(Input::RIGHT) or @index + 1 < @windows.size
          $game_system.se_play($data_system.cursor_se)
          @windows[@index].visible = false
          @windows[@index].active = false
          @index = (@index + 1) % @windows.size
          @windows[@index].visible = true
        end
      end
      if Input.repeat?(Input::LEFT)
        if Input.trigger?(Input::LEFT) or @index > 0 
          $game_system.se_play($data_system.cursor_se)
          @windows[@index].visible = false
          @windows[@index].active = false
          @index = (@index - 1 + @windows.size) % @windows.size
          @windows[@index].visible = true
        end
      end
      if Input.repeat?(Input::C)
        $game_system.se_play($data_system.decision_se)
        @windows[@index].active = true
      end
    elsif self.active and @windows[@index].active
      if Input.repeat?(Input::B)
        $game_system.se_play($data_system.cancel_se)
        @windows[@index].active = false
      end
    end
  end
  
  def window
    return @windows[@index]
  end
end

#==============================================================================
# Window_BookItem
#==============================================================================

class Window_BookItem < Window_Base
  
  def initialize(item)
    super(116, 0, 408, 100)
    @item = item
    self.visible = false
    self.contents = Bitmap.new(188*2, 68)
    self.contents.font.size = 14
    self.contents.font.color = normal_color
    refresh
  end
  
  def item_id
    return @item.id
  end
  
  def all_opacity=(value)
    self.contents_opacity = value
    self.opacity = value
  end
  
  def refresh
    # Desenhar nome do item 
    name = @item.name
    self.contents.draw_text(41, 1, 256-32-68-12, 22, name)
    bitmap = RPG::Cache.icon(@item.icon_name)
    self.contents.blt(8, 11, bitmap, Rect.new(0, 0, 24, 24))
    rect = Rect.new(36, 4, 1, 38)
    self.contents.fill_rect(rect ,normal_color)
    rect = Rect.new(0, 45, 376, 1)
    self.contents.fill_rect(rect ,normal_color)
    if @item.price > 0
      draw_price(300, 0)
    end
    x = 41
    if @item.treasure
      self.contents.draw_text(x, 22, 72, 22, "Important Item")
      x += 76
    end
    if !@item.is_a?(RPG::Item)
      if @item.is_a?(RPG::Weapon) and @item.atk > 0
        x += draw_atk(x, 22)
      end
      if @item.pdef > 0
        x += draw_pdef(x, 22)
      end
      if @item.mdef > 0
        x += draw_mdef(x, 22)
      end
      if @item.is_a?(RPG::Armor) and @item.eva > 0
        x += draw_eva(x, 22)
      end
      if @item.str_plus > 0
        x += draw_for(x, 22)
      end
      if @item.dex_plus > 0
        x += draw_dex(x, 22)
      end
      if @item.agi_plus > 0
        x += draw_agi(x, 22)
      end
      if @item.int_plus > 0
        draw_int(x, 22)
      end
    else
      if @item.scope > 0
        x += draw_scope(x, 22)
      end
      if @item.recover_hp_rate > 0
        x += draw_rec_hp(x, 22, true)
      elsif @item.recover_hp > 0
        x += draw_rec_hp(x, 22)
      end
      if @item.recover_sp_rate > 0
        x += draw_rec_sp(x, 22, true)
      elsif @item.recover_sp > 0
        x += draw_rec_sp(x, 22)
      end
      if @item.parameter_type > 0 and @item.parameter_points > 0
        x += draw_parameter(x, 22)
      end
      if @item.pdef_f > 0
        x += draw_pdef_f(x, 22)
      end
      if @item.mdef_f > 0
        x += draw_mdef_f(x, 22)
      end
    end
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 68-22, 368, 22, @item.description, 0)
  end

  def draw_price(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 34, 22, "Price: ")
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 34, y, 42, 22, @item.price.to_s, 2)
  end
  
  def draw_atk(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 22, 22, "Atk:")
    self.contents.font.color = normal_color
    w = @item.atk.to_s.size * 6
    self.contents.draw_text(x + 22, y, w, 22, @item.atk.to_s, 2)
    return 22 + w + 4
  end
  
  def draw_pdef(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 33, 22, "P. Def:")
    self.contents.font.color = normal_color
    w = @item.pdef.to_s.size * 6
    self.contents.draw_text(x + 33, y, w, 22, @item.pdef.to_s, 2)
    return 33 + w + 4
  end
  
  def draw_mdef(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 35, 22, "M. Def:")
    self.contents.font.color = normal_color
    w = @item.mdef.to_s.size * 6
    self.contents.draw_text(x + 35, y, w, 22, @item.mdef.to_s, 2)
    return 35 + w + 4
  end
  
  def draw_slots(x, y)
    y_slot = (y) + ((5 - @item.slot) * 5/2)
    for i in 0...@item.slot
      bitmap = RPG::Cache.picture("empty_slot")
      self.contents.blt(x , y_slot + (i*5), bitmap, Rect.new(0, 0, 4, 4))
    end
  end
  
  def draw_eva(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 23, 22, "Eva:")
    self.contents.font.color = normal_color
    w = @item.eva.to_s.size * 6
    self.contents.draw_text(x + 23, y, w, 22, @item.eva.to_s, 2)
    return 23 + w + 4
  end
  
  def draw_for(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 24, 22, "Str:")
    self.contents.font.color = normal_color
    w = @item.str_plus.to_s.size * 6
    self.contents.draw_text(x + 21, y, w, 22, @item.str_plus.to_s, 2)
    return 25 + w
  end
  
  def draw_dex(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 25, 22, "Dex:")
    self.contents.font.color = normal_color
    w = @item.dex_plus.to_s.size * 6
    self.contents.draw_text(x + 25, y, w, 22, @item.dex_plus.to_s, 2)
    return 29 + w
  end
  
  def draw_agi(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 22, 22, "Agi:")
    self.contents.font.color = normal_color
    w = @item.agi_plus.to_s.size * 6
    self.contents.draw_text(x + 22, y, w, 22, @item.agi_plus.to_s, 2)
    return 26 + w
  end
  
  def draw_int(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 18, 22, "Int:")
    self.contents.font.color = normal_color
    w = @item.int_plus.to_s.size * 6
    self.contents.draw_text(x + 16, y, w, 22, @item.int_plus.to_s, 2)
    return w + 29
  end
  
  def draw_scope(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 35, 22, "Affect:")
    self.contents.font.color = normal_color
    w = self.contents.text_size(Options::SCOPE_INFO[@item.scope]).width
    self.contents.draw_text(x + 35, y, w, 22, Options::SCOPE_INFO[@item.scope], 2)
    return w + 39
  end
  
  def draw_rec_hp(x, y, rate=false)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 41, 22, "Rec. HP:")
    self.contents.font.color = normal_color
    if rate
      w = self.contents.text_size(@item.recover_hp_rate.to_s + "%").width
      self.contents.draw_text(x + 43, y, w, 22, @item.recover_hp_rate.to_s + "%", 2)
      return w + 47
    elsif @item.recover_hp >= 9999
      w = self.contents.text_size("100%").width
      self.contents.draw_text(x + 43, y, w, 22, "100%", 2)
      return w + 47
    else
      w = @item.recover_hp.to_s.size * 6
      self.contents.draw_text(x + 43, y, w, 22, @item.recover_hp.to_s, 2)
      return w + 47
    end
  end
  
  def draw_rec_sp(x, y, rate=false)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 41, 22, "Rec. SP:")
    self.contents.font.color = normal_color
    if rate
      w = self.contents.text_size(@item.recover_sp_rate.to_s + "%").width
      self.contents.draw_text(x + 43, y, w, 22, @item.recover_sp_rate.to_s + "%", 2)
      return w + 47
    elsif @item.recover_sp >= 9999
      w = self.contents.text_size("100%").width
      self.contents.draw_text(x + 43, y, w, 22, "100%", 2)
      return w + 47
    else
      w = @item.recover_sp.to_s.size * 6
      self.contents.draw_text(x + 43, y, w, 22, @item.recover_sp.to_s, 2)
      return w + 47
    end
  end
  
  def draw_parameter(x, y)
    text_parameter = ["", "HP Max:", "SP Max:", "Str:", "Dex:", "Agi:", "Int:"]
    w1 = self.contents.text_size(text_parameter[@item.parameter_type]).width
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, w1, 22, text_parameter[@item.parameter_type])
    self.contents.font.color = normal_color
    w2 = self.contents.text_size("+" + @item.parameter_points.to_s).width
    self.contents.draw_text(x + w1 + 2, y, w2, 22, "+" + @item.parameter_points.to_s, 2)
    return w2 + w1 + 6
  end
  
  def draw_mdef_f(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 33, 22, "M. Def:")
    self.contents.font.color = normal_color
    w = self.contents.text_size("+" + @item.mdef_f.to_s).width
    self.contents.draw_text(x + 33, y, w, 22, "+" + @item.mdef_f.to_s, 2)
    return w + 37
  end
  
  def draw_pdef_f(x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 31, 22, "P. Def:")
    self.contents.font.color = normal_color
    w = self.contents.text_size("+" + @item.pdef_f.to_s).width
    self.contents.draw_text(x + 31, y, w, 22, "+" + @item.pdef_f.to_s, 2)
    return w + 35
  end
end

#==============================================================================
# Window_Items
#==============================================================================

class Window_Items
  
  attr_accessor :index
  attr_accessor :active
  attr_reader   :visible
  
  def initialize
    @index = -1
    @windows = []
    @row = 0
    @windows_visible = []
    @active = false
    @sprite = Sprite.new
    @sprite.visible = false
    @sprite.bitmap = Bitmap.new(640, 480)
    self.visible = false
  end
  
  def visible=(value)
    for window in @windows_visible
      window.visible = value if window.is_a?(Window)
    end
    #@sprite.visible = value
    @visible = value
  end
    
  def refresh(windows)
    #if @windows =! windows
      for window in @windows_visible
        window.visible = false if window.is_a?(Window)
      end
      @index = 0
      @windows = windows
      update_show
    #end
  end
  
  def dispose
    for window in @windows
      window.dispose
    end
  end
  
  def update
    for window in @windows
      window.update
    end
    if self.active
      if Input.repeat?(Input::DOWN)
        if Input.trigger?(Input::DOWN) or @index + 1 < @windows.size
          $game_system.se_play($data_system.cursor_se)
          @index = (@index + 1) % @windows.size
        end
      end
      if Input.repeat?(Input::UP)
        if Input.trigger?(Input::UP) or @index > 0 
          $game_system.se_play($data_system.cursor_se)
          @index = (@index - 1 + @windows.size) % @windows.size
        end
      end
    end
    update_show
  end
  
  def row_max
    return @windows.size
  end
 
  def top_row
    return @row
  end
 
  def top_row=(row)
    if row < 0
      row = 0
    end
    if row > row_max - 1
      row = row_max - 1
    end
    @row = [row, 0].max
  end
  
  def page_row_max
    return 3
  end
  
  def page_item_max
    return page_row_max
  end
  
  def update_show
    if @index != @last_index
      row = @index
      if row <= self.top_row
        self.top_row = row
      end
      if row > self.top_row + (self.page_row_max - 1)
        self.top_row = row - (self.page_row_max - 1)
      end
      new_windows_visible = [@windows[@row], @windows[@row+1], @windows[@row+2]]
      windows_visiblefalse = @windows_visible - new_windows_visible
      for window in windows_visiblefalse
        window.visible = false if window.is_a?(Window)
      end
      @windows_visible = new_windows_visible
      for i in 0...@windows_visible.size
        next if @windows_visible[i].nil?
        @windows_visible[i].y = 66 + i*116 + 8
        @windows_visible[i].visible = self.visible
        if @windows_visible[i] == @windows[@index]
          @windows_visible[i].all_opacity = 255
        else
          @windows_visible[i].all_opacity = 128
        end
      end
      @last_index = @index
      update_row
    end
  end
  
  def update_row
    @sprite.bitmap.clear
    return if @sprite.visible
    x = 540
    y = 66 + 8
    width = 4
    height = 116*3 - 16
    rect = Rect.new(x, y, width, height)
    @sprite.bitmap.fill_rect(rect, Color.new(255, 255, 255, 255))
    rect = Rect.new(x+1, y+1, width-2, height-2)
    @sprite.bitmap.fill_rect(rect, Color.new(0, 0, 0, 0))
    oy = (height - 2) / [@windows.size, 1].max
    rect = Rect.new(x+1, y + 1 + oy*@row, width-2, oy*3)
    @sprite.bitmap.fill_rect(rect, Color.new(192, 224, 255, 255))
  end
  
end

#==============================================================================
# Scene_Bestiary
#==============================================================================

class Scene_Bestiary
  attr_accessor :spriteset
  
  def main
    view = Viewport.new(0, 0, 640, 480)
    view.z = -500
    @plane = Plane.new(view)
    @plane.bitmap = RPG::Cache.picture(Options::COLD_MENU_PLANE)
    @base = Window_Base.new(32,32,640-64,480-64)
    @base.contents = Bitmap.new(640-96,480-96)
    @base.contents.font.size = 14
    @command_window = Window_BookCommand.new
    @cw_types = Options::ENEMIES_ORDER.keys.reverse
    @cw_commands = ["All", "By habitat"]
    @command_window.refresh("Order:",@cw_types,@cw_commands)
    $game_system.save_hash["Bestiary Windows"] ||= []
    @enemy_windows = $game_system.save_hash["Bestiary Windows"]
    for i in 1...$data_enemies.size
      if @enemy_windows[i].is_a?(Window_Enemy)
        if @enemy_windows[i].need_refresh?($game_system.info_enemy(i).killed)
          @enemy_windows[i].refresh(i)
        end
        next
      end
      if $game_system.info_enemy(i).battled > 0
        @enemy_windows[i] = Window_Enemy.new(i)
      end
    end
    @enemies = []
    draw_base_book
    @enemies_window = Window_Enemies.new
    
    @book_enemies = Window_Book.new
    @maps_window = Window_Book.new
    
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
    
    for i in 1...$data_enemies.size
      @enemy_windows[i].dispose if @enemy_windows[i] != nil
      @enemy_windows[i] = nil
    end
    @base.dispose
    @command_window.dispose
    @book_enemies.dispose
    @maps_window.dispose
    @plane.dispose
  end
  
  def update
    @plane.ox -= 2
    @plane.oy -= 2
    #update_draw_enemy_window
    @base.update
    @command_window.update
    @book_enemies.update
    can_update_ew = !@enemies_window.window.active if !@enemies_window.window.nil?
    @enemies_window.update
    @maps_window.update
    if @command_window.active
      update_command
      return
    end
    if @book_enemies.active
      update_book_enemies
      return
    end
    if @enemies_window.active and can_update_ew
      update_enemies
      return
    end
    if @maps_window.active
      update_maps
      return
    end
  end
  
  def update_command
    if Input.trigger?(Input::B)
      $scene = Scene_Menu.new
      return
    end
    if Input.trigger?(Input::C)
      case @command_window.command
      when @cw_commands[0]
        $game_system.se_play($data_system.decision_se)
        @command_window.visible = false
        @command_window.active = false
        @enemies = []
        @enemies_names = []
        for i in Options::ENEMIES_ORDER[@command_window.type]
          if $game_system.info_enemy(i).battled > 0
            @enemies.push(i)
            @enemies_names.push($data_enemies[i].name)
          else
            @enemies_names.push("???")
            @enemies.push(i)
          end
        end
        draw_base_text("Show All Monsters")
        @book_enemies.refresh(@enemies_names)
        @book_enemies.index = 0
        @book_enemies.active = true
        @book_enemies.visible = true
      when @cw_commands[1]
        if $game_system.maps_battled.size > 0
          $game_system.se_play($data_system.decision_se)
          @command_window.visible = false
          @command_window.active = false
          @maps_window.refresh($game_system.maps_battled)
          @maps_window.active = true
          @maps_window.visible = true
          @maps_window.index = 0
          draw_base_text("Select the map which you want to see the monsters")
        else
          $game_system.se_play($data_system.buzzer_se)
        end
      end
      return
    end
  end
  
  def update_book_enemies
    if Input.trigger?(Input::B)
      case @command_window.command
      when @cw_commands[0]
        $game_system.se_play($data_system.cancel_se)
        @base.contents.clear
        @book_enemies.visible = false
        @book_enemies.active = false
        @command_window.active = true
        @command_window.visible = true
        draw_base_book
        return
      when @cw_commands[1]
        $game_system.se_play($data_system.cancel_se)
        @base.contents.clear
        @book_enemies.visible = false
        @book_enemies.active = false
        @maps_window.visible = true
        @maps_window.active = true
        draw_base_text("Select the map which you want to see monsters")
        return
      end
      return
    end
    if Input.trigger?(Input::C)
      index = @enemies[@book_enemies.index]
      if @enemies_names[@book_enemies.index] == "???"
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      @e_windows = []
      for i in Options::ENEMIES_ORDER[@command_window.type]#1...$data_enemies.size
        unless @map.nil?
          next unless $game_system.info_enemy(i).habitat.include?(@map)
        end
        if $game_system.info_enemy(i).battled > 0
          @e_windows.push(@enemy_windows[i])
        end
      end
      @enemies_window.refresh(@e_windows)
      @enemies_window.index = @e_windows.index(@enemy_windows[index])
      @book_enemies.visible = false
      @book_enemies.active = false
      @base.contents.clear
      @enemies_window.visible = true
      @enemies_window.active = true
      return
    end
  end
  
  def update_enemies
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @enemies_window.visible = false
      @enemies_window.active = false
      case @command_window.command
      when @cw_commands[0]
        @book_enemies.visible = true
        @book_enemies.active = true
        draw_base_text("Show All Monsters")
      when @cw_commands[1]
        @book_enemies.visible = true
        @book_enemies.active = true
        draw_base_text(@map_text)
      end
      return
    end
  end
  
  def update_maps
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @base.contents.clear
      @maps_window.visible = false
      @maps_window.active = false
      @command_window.active = true
      @command_window.visible = true
      @map = nil
      draw_base_book
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      @maps_window.visible = false
      @maps_window.active = false
      @enemies = []
      @enemies_names = []
      ind = @maps_window.index
      for i in Options::ENEMIES_ORDER[@command_window.type]#1...$data_enemies.size
        next unless $game_system.info_enemy(i).habitat.include?($game_system.maps_battled[ind])
        if $game_system.info_enemy(i).battled > 0 
          @enemies.push(i)
          @enemies_names.push($data_enemies[i].name)
        else
          @enemies.push(i)
          @enemies_names.push("???")
        end
      end
      @map = $game_system.maps_battled[ind]
      @map_text = "Monsters that live #{@map}"
      draw_base_text(@map_text)
      @book_enemies.refresh(@enemies_names.compact)
      @book_enemies.index = 0
      @book_enemies.active = true
      @book_enemies.visible = true
      return
    end
  end
  
  def draw_base_text(text)
    @base.contents.clear
    x = (640 - 352) / 2 - 48 + 16
    y = (480 - (12*22+32)) / 2 - 48 + 16 - 5
    @base.contents.draw_text(x, y - 23, 320, 22, text, 1)
    rect = Rect.new(x, y - 1, 320, 1)
    @base.contents.fill_rect(rect, @base.normal_color)
  end
  
  def draw_base_book
    if Options::LAYOUTB
      @base.contents.clear
      x = (640-96-128) / 2
      y = 40
      @base.contents.font.size = 14
      @base.contents.font.bold = false
      @base.contents.draw_text(x, y, 128, 18, "Bestiary", 1)
      rect = Rect.new(x - 2, y + 17, 132, 1)
      @base.contents.fill_rect(rect, @base.normal_color)
      total = $data_enemies.size - 1
      sub_total = @enemy_windows.compact.size
      number = sub_total.to_s + "/" + total.to_s
      @base.contents.font.color = @base.system_color
      @base.contents.draw_text(544-114-24, 380-38-24, 114, 22, "Monsters found:")
       @base.contents.font.color = @base.normal_color
      @base.contents.draw_text(544-114-24, 380-22-24, 114, 22, number, 2)
      rect = Rect.new(544-114-28, 380-24-3, 122, 1)
      @base.contents.fill_rect(rect, @base.normal_color)
    end
  end
end

#==============================================================================
# Scene_ItemsBook
#------------------------------------------------------------------------------
# Esta classe processa a Tela do livro de itens
#==============================================================================

class Scene_ItemsBook
  
  #--------------------------------------------------------------------------
  # - Processamento Principal
  #--------------------------------------------------------------------------
  
  def main
    # Criar plano de fundo
    view = Viewport.new(0, 0, 640, 480)
    view.z = -500
    @plane = Plane.new(view)
    @plane.bitmap = RPG::Cache.picture(Options::COLD_MENU_PLANE)
    # Janela Base
    @base = Window_Base.new(32,32,640-64,480-64)
    @base.contents = Bitmap.new(640-96,480-96)
    @base.contents.font.size = 14
    @base.z = -10
    # Menu de opções
    @command_window = Window_BookCommand.new
    # Ordens
    @cw_types = Options::ITEMS_ORDER.keys.reverse
    # Tipos de itens
    @cw_commands = ["All"]
    @cw_commands[1] = $data_system.words.weapon
    @cw_commands[2] = $data_system.words.armor1 + "s"
    @cw_commands[3] = "Cascos" #$data_system.words.armor2 + "s"
    @cw_commands[4] = "Vestiduras" #$data_system.words.armor3 + "s"
    @cw_commands[5] = "Accesorios" #$data_system.words.armor4 + "s"
    @cw_commands[6] = "Objetos" #$data_system.words.item + "s"
    @cw_commands[7] = "Únicos" if Options::TREASURE_ACTIVE #+ $data_system.words.item + "s"
    # Refrescar menu de opções
    @command_window.refresh("Order:",@cw_types,@cw_commands)
    # Janelas dos itens
    $game_system.save_hash["Book Item Windows"] ||= []
    @items_windows = $game_system.save_hash["Book Item Windows"]
    for i in 1...$data_items.size
      next if !@items_windows[i].nil?
      if $game_system.items_obtained[i]
        @items_windows[i] = Window_BookItem.new($data_items[i])
      end
    end
    for i in 1...$data_weapons.size
      next if !@items_windows[i + $data_items.size].nil?
      if $game_system.weapons_obtained[i]
        w_item = Window_BookItem.new($data_weapons[i])
        @items_windows[i + $data_items.size] = w_item
      end
    end
    for i in 1...$data_armors.size
      next if !@items_windows[i + $data_items.size + $data_weapons.size].nil?
      if $game_system.armors_obtained[i]
        w_item = Window_BookItem.new($data_armors[i])
        @items_windows[i + $data_items.size + $data_weapons.size] = w_item
      end
    end
    draw_base_book
    # Janela para escolha do item
    @book_items = Window_Book.new
    # Janela que mostra as janelas do items
    @items_window = Window_Items.new
    # Executar transição
    Graphics.transition
    # Loop principal
    loop do
      # Atualizar a tela de jogo
      Graphics.update
      # Atualizar a entrada de informações
      Input.update
      # Atualizar Frame
      update
      # Abortar loop se a tela for alterada
      if $scene != self
        break
      end
    end
    # Preparar para transição
    Graphics.freeze
    # Exibição das janelas
    for i in 0...@items_windows.size
      @items_windows[i].dispose if @items_windows[i] != nil
      @items_windows[i] = nil
    end
    @base.dispose
    @command_window.dispose
    @book_items.dispose
    @items_window.visible = false
    @plane.dispose
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update
    # Atualizar fundo
    @plane.ox -= 2
    @plane.oy -= 2
    # Atualizar janelas
    @command_window.update
    @book_items.update
    @items_window.update
    # Se a janela de Menu das opções estiver ativa
    if @command_window.active
      update_command
      return
    end
    # Se a janela para escolha dos itens estiver ativa
    if @book_items.active
      update_book
      return
    end
    # Se a janela que processa as janelas de itens estiver ativa
    if @items_window.active
      update_items
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame (Quando a janela de Menu das opções estiver ativa)
  #--------------------------------------------------------------------------
  
  def update_command
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela do menu
      $scene = Scene_Menu.new
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Reproduzir SE de OK
      $game_system.se_play($data_system.decision_se)
      # Ramificação por posição do cursor na janela de comandos
      case @command_window.command
      when @cw_commands[0] # Quando for 0
        # Todos itens
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Todos items
        for item in Options::ITEMS_ORDER[@command_window.type]
          case item[0] # Ramitificação do tipo de item
          when 0 # Quando for item
            # Se item já foi obtido
            if $game_system.items_obtained[item[1]]
              @item_names.push($data_items[item[1]].name)
              @item_index.push(item[1])
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          when 1 # Quando for arma
            # Se arma já foi obtida
            if $game_system.weapons_obtained[item[1]]
              @item_names.push($data_weapons[item[1]].name)
              @item_index.push(item[1] + $data_items.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          when 2 # Quando for equip. de def.
            # Se equip. de def. já foi obtido
            if $game_system.armors_obtained[item[1]]
              @item_names.push($data_armors[item[1]].name)
              @item_index.push(item[1] + $data_items.size + $data_weapons.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show All Items")
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[1] # Quando for 1
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas armas
        for item in Options::ITEMS_ORDER[@command_window.type]
          if item[0] == 1
            if $game_system.weapons_obtained[item[1]]
              @item_names.push($data_weapons[item[1]].name)
              @item_index.push(item[1] + $data_items.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[2] # Quando for 2
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas escudos
        for item in Options::ITEMS_ORDER[@command_window.type]
          if item[0] == 2
            next if $data_armors[item[1]].kind != 0
            if $game_system.armors_obtained[item[1]]
              @item_names.push($data_armors[item[1]].name)
              @item_index.push(item[1] + $data_items.size + $data_weapons.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[3] # Quando for 3
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas elmos
        for item in Options::ITEMS_ORDER[@command_window.type]
          if item[0] == 2
            next if $data_armors[item[1]].kind != 1
            if $game_system.armors_obtained[item[1]]
              @item_names.push($data_armors[item[1]].name)
              @item_index.push(item[1] + $data_items.size + $data_weapons.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[4] # Quando for 4
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas armaduras
        for item in Options::ITEMS_ORDER[@command_window.type]
          if item[0] == 2
            next if $data_armors[item[1]].kind != 2
            if $game_system.armors_obtained[item[1]]
              @item_names.push($data_armors[item[1]].name)
              @item_index.push(item[1] + $data_items.size + $data_weapons.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[5] # Quando for 5
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas acessorios
        for item in Options::ITEMS_ORDER[@command_window.type]
          if item[0] == 2
            next if $data_armors[item[1]].kind != 3
            if $game_system.armors_obtained[item[1]]
              @item_names.push($data_armors[item[1]].name)
              @item_index.push(item[1] + $data_items.size + $data_weapons.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[6] # Quando for 6
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas items
        for item in Options::ITEMS_ORDER[@command_window.type]
          if item[0] == 0
            if $game_system.items_obtained[item[1]]
              @item_names.push($data_items[item[1]].name)
              @item_index.push(item[1])
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      when @cw_commands[7] # Quando for 8
        # Apenas treasures
        @item_index = [] # Index daa janela dos itens
        @item_names = [] # Nome dos items
        # Apenas treasures
        for item in Options::ITEMS_ORDER[@command_window.type]
          case item[0] # Ramitificação do tipo de item
          when 0 # Quando for item
            next if !$data_items[item[1]].treasure
            # Se item já foi obtido
            if $game_system.items_obtained[item[1]]
              @item_names.push($data_items[item[1]].name)
              @item_index.push(item[1])
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          when 1 # Quando for arma
            next if !$data_weapons[item[1]].treasure
            # Se arma já foi obtida
            if $game_system.weapons_obtained[item[1]]
              @item_names.push($data_weapons[item[1]].name)
              @item_index.push(item[1] + $data_items.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          when 2 # Quando for equip. de def.
            next if !$data_armors[item[1]].treasure
            # Se equip. de def. já foi obtido
            if $game_system.armors_obtained[item[1]]
              @item_names.push($data_armors[item[1]].name)
              @item_index.push(item[1] + $data_items.size + $data_weapons.size)
            else
              @item_names.push("???")
              @item_index.push(nil)
            end
          end
        end
        draw_base_text("Show Only " + @cw_commands[@command_window.index])
        @book_items.refresh(@item_names)
        # Ativar janela para escolha do item
        @command_window.active = false
        @command_window.visible = false
        @book_items.active = true
        @book_items.visible = true
        @book_items.index = 0
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update_book
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Ativar menu de opções
      @book_items.active = false
      @book_items.visible = false
      @command_window.active = true
      @command_window.visible = true
      @base.contents.clear
      draw_base_book
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Verificar se o item foi obtido 
      if @item_index[@book_items.index] == nil
        # Reproduzir SE de erro
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Reproduzir SE de OK
      $game_system.se_play($data_system.decision_se)
      @i_windows = []
      for i in @item_index#0...@items_windows.size
        if !i.nil?#@item_index.include?(i)
          @i_windows.push(@items_windows[i])
        end
      end
      @base.visible = false
      @book_items.active = false
      @book_items.visible = false
      @items_window.refresh(@i_windows)
      ind = @i_windows.index(@items_windows[@item_index[@book_items.index]])
      @items_window.index = ind + 1
      @items_window.update_show
      @items_window.index = ind
      @items_window.active = true
      @items_window.visible = true
    end
  end
  
  #--------------------------------------------------------------------------
  # - Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update_items
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Ativar menu de opções
      @items_window.active = false
      @items_window.visible = false
      @base.visible = true
      @book_items.active = true
      @book_items.visible = true
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # - Mostrar texto na janela base
  #--------------------------------------------------------------------------
  
  def draw_base_text(text)
    @base.contents.clear
    x = (640 - 352) / 2 - 48 + 16
    y = (480 - (12*22+32)) / 2 - 48 + 16 - 5
    @base.contents.font.size = 14
    @base.contents.font.bold = false
    @base.contents.draw_text(x, y - 23, 320, 22, text, 1)
    rect = Rect.new(x, y - 1, 320, 1)
    @base.contents.fill_rect(rect, @base.normal_color)
  end
  
  def draw_base_book
    if Options::LAYOUTB
      @base.contents.clear
      x = (640-96-128) / 2
      y = 40
      @base.contents.font.size = 14
      @base.contents.font.bold = false
      @base.contents.draw_text(x, y, 128, 18, "Items Book", 1)
      rect = Rect.new(x - 2, y + 17, 132, 1)
      @base.contents.fill_rect(rect, @base.normal_color)
      total = $data_items.size + $data_weapons.size + $data_armors.size - 3
      sub_total = @items_windows.compact.size
      number = sub_total.to_s + "/" + total.to_s
      @base.contents.font.color = @base.system_color
      @base.contents.draw_text(544-96-24, 380-38-24, 96, 22, "Known Items:")
      @base.contents.font.color = @base.normal_color
      @base.contents.draw_text(544-96-24, 380-22-24, 96, 22, number, 2)
      rect = Rect.new(544-96-28, 380-24-3, 100, 1)
      @base.contents.fill_rect(rect, @base.normal_color)
    end
  end
  
end
end