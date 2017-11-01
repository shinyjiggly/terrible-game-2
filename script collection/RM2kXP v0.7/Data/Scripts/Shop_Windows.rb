#==============================================================================
# ** Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     shop_goods : goods
  #--------------------------------------------------------------------------
  def initialize(shop_goods)
    super(0, 64, 370, 288)
    @shop_goods = shop_goods
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    # Get items in possession
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    # If price is less than money in possession, and amount in possession is
    # not 99, then set to normal text color. Otherwise set to disabled color
    if item.price <= $game_party.gold and number < 99
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4
    y = index * 32
    rect = Rect.new(x, y, self.width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.draw_icon(x, y + 4, 24, 24, item.icon_name, opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 88, 32, item.price.to_s, 2)
  end
end

#==============================================================================
# ** Window_ShopSell
#==============================================================================

class Window_ShopSell < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 640, 288)
    @column_max = 2
    refresh
    self.index = 0
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
    # If items are sellable, set to valid text color.
    if item.price > 0
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.draw_icon(x, y + 4, 24, 24, item.icon_name, opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, "x", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end

#==============================================================================
# ** Window_ShopNumber
#==============================================================================

class Window_ShopNumber < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 368, 288)
    self.contents = Bitmap.new(width - 32, height - 32)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
  end
end

#==============================================================================
# ** Window_ShopStatus
#==============================================================================

class Game_System
  # New accessor shop_price_based, when true the shop comprovation is based in
  # the difference between the price of the equipped item and the shop item
  # When false, the shop comprovation is based in all the items parameters
  attr_accessor :shop_price_based
  alias rm2kxp_shopprice initialize unless $@
  def initialize
    rm2kxp_shopprice
    @shop_price_based = false
  end
end

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(370, 64, 270, 288-64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @item = nil
    @sprite1 = nil
    @sprite2 = nil
    @sprite3 = nil
    @sprite4 = nil
    @count = 0
    @arrow1 = nil
    @arrow2 = nil
    @arrow3 = nil
    @arrow4 = nil
    @count2 = 0
    @walk = [false, false, false, false]
    refresh
  end
  #--------------------------------------------------------------------------
  # * Dispose Window
  #--------------------------------------------------------------------------
  def dispose
    # Dispose Character Sprites
    if @sprite1 != nil
      @sprite1.dispose
      @sprite1 = nil
    end
    if @sprite2 != nil
      @sprite2.dispose
      @sprite2 = nil
    end
    if @sprite3 != nil
      @sprite3.dispose
      @sprite3 = nil
    end
    if @sprite4 != nil
      @sprite4.dispose
      @sprite4 = nil
    end
    # Dispose Arrow Sprites
    if @arrow1 != nil
      @arrow1.dispose
      @arrow1 = nil
    end
    if @arrow2 != nil
      @arrow2.dispose
      @arrow2 = nil
    end
    if @arrow3 != nil
      @arrow3.dispose
      @arrow3 = nil
    end
    if @arrow4 != nil
      @arrow4.dispose
      @arrow4 = nil
    end
    # Dispose Contents
    super
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    # Dispose Character Sprites
    if @sprite1 != nil
      @sprite1.dispose
      @sprite1 = nil
    end
    if @sprite2 != nil
      @sprite2.dispose
      @sprite2 = nil
    end
    if @sprite3 != nil
      @sprite3.dispose
      @sprite3 = nil
    end
    if @sprite4 != nil
      @sprite4.dispose
      @sprite4 = nil
    end
    # Dispose Arrow Sprites
    if @arrow1 != nil
      @arrow1.dispose
      @arrow1 = nil
    end
    if @arrow2 != nil
      @arrow2.dispose
      @arrow2 = nil
    end
    if @arrow3 != nil
      @arrow3.dispose
      @arrow3 = nil
    end
    if @arrow4 != nil
      @arrow4.dispose
      @arrow4 = nil
    end
    return if @item == nil
    # Return walk variable to the default value
    @walk = [false, false, false, false]
    # Get items in possession count
    case @item
    when RPG::Item
      number = $game_party.item_number(@item.id)
      numberB = 0
    when RPG::Weapon
      number = $game_party.weapon_number(@item.id)
      numberB = 0
      for i in 0...$game_party.actors.size
        actor = $game_party.actors[i]
        numberB += 1 if actor.weapon_id == @item.id
      end
    when RPG::Armor
      number = $game_party.armor_number(@item.id)
      numberB = 0
      for i in 0...$game_party.actors.size
        actor = $game_party.actors[i]
        numberB += 1 if actor.armor1_id == @item.id
        numberB += 1 if actor.armor2_id == @item.id
        numberB += 1 if actor.armor3_id == @item.id
        numberB += 1 if actor.armor4_id == @item.id
      end
    end
    # Draw how many items the party has
    self.contents.draw_text(4, 96, 200, 32, Vocab::OWN, 0, 1)
    self.contents.draw_text(204, 96, 32, 32, number.to_s, 2, 0)
    # Draw how many items the party uses
    self.contents.draw_text(4, 128, 200, 32, Vocab::OWNB, 0, 1)
    self.contents.draw_text(204, 128, 32, 32, numberB.to_s, 2, 0)
    # Item restriction
    if @item.is_a?(RPG::Item)
      if Wep::Restricted_items != nil and Wep::Active_restricted_aplication == true
        for i in 0...$game_party.actors.size
          actor = $game_party.actors[i]
          # If actor can use the item
          if $game_party.item_can_apply?(@item.id, actor.id)
            # Normal actor graphic
            @walk[i] = true
            draw_actor_graphic(actor, 640, 480, i, 1)
          # If actor can't use the item 
          else
            # Disabled actor graphic
            @walk[i] = false
            draw_actor_graphic(actor, 640, 480, i, 0)
          end
        end
      end
      return
    end
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      # If item is a Weapon
      if @item.is_a?(RPG::Weapon)
        # item1 is the weapon actor is using and it will be compared with item
        item1 = $data_weapons[actor.weapon_id]
      else
        # If item is an Armor
        case @item.kind
        when 0 # Shield
          item1 = $data_armors[actor.armor1_id]
        when 1 # Head
          item1 = $data_armors[actor.armor2_id]
        when 2 # Body
          item1 = $data_armors[actor.armor3_id]
        when 3 # Acc
          item1 = $data_armors[actor.armor4_id]
        end
      end
      # If actor can't equip the item
      if not actor.equippable?(@item)
        # Disabled actor graphic
        @walk[i] = false
        draw_actor_graphic(actor, 640, 480, i, 0)
        next
      end
      # If actor can equip the item
      # Normal actor graphic
      @walk[i] = true
      draw_actor_graphic(actor, 640, 480, i, 1)
      
      # If Item difference is not based on price so in all other parameters
      if $game_system.shop_price_based == false
        
      # str1 is the item1 str_plus and str2 is the item str_plus
      # The same with all other parameters
      atk1=0 ; atk2=0 ; eva1=0 ; eva2=0
      str1 = item1 != nil ? item1.str_plus : 0
      str2 = @item != nil ? @item.str_plus : 0
      dex1 = item1 != nil ? item1.dex_plus : 0
      dex2 = @item != nil ? @item.dex_plus : 0
      agi1 = item1 != nil ? item1.agi_plus : 0
      agi2 = @item != nil ? @item.agi_plus : 0
      int1 = item1 != nil ? item1.int_plus : 0
      int2 = @item != nil ? @item.int_plus : 0
      pdf1 = item1 != nil ? item1.pdef : 0
      pdf2 = @item != nil ? @item.pdef : 0
      mdf1 = item1 != nil ? item1.mdef : 0
      mdf2 = @item != nil ? @item.mdef : 0
      if @item.is_a?(RPG::Weapon)
        atk1 = item1 != nil ? item1.atk : 0
        atk2 = @item != nil ? @item.atk : 0
      else
        eva1 = item1 != nil ? item1.eva : 0
        eva2 = @item != nil ? @item.eva : 0
      end
      # str_change is the difference between str2 and str1
      # The same with all other parameters
      str_change = str2 - str1
      dex_change = dex2 - dex1
      agi_change = agi2 - agi1
      int_change = int2 - int1
      pdf_change = pdf2 - pdf1
      mdf_change = mdf2 - mdf1
      atk_change = atk2 - atk1
      eva_change = eva2 - eva1
      # result gets all the changes together to check which item is better
      result = atk_change + eva_change + pdf_change + str_change + dex_change +
      agi_change + int_change
      
      else # If Item difference is based only on price
      
      # price1 is the item1 price and price2 is the item price
      price1 = item1 != nil ? item1.price : 0
      price2 = @item != nil ? @item.price : 0
      # result is the difference between price1 and price2
      result = price2 - price1
      
      end
      
      # if result > 0, the shop item is better than the actor item (arrow up)
      # if result < 0, the actor item is better than the shop item (arrow down)
      # if result is 0 items can be the same (E) or not the same (point)
      if item1 == nil
        name1 = ""
      else
        name1 = item1.name
      end
      if @item == nil
        name2 = ""
      else
        name2 = @item.name
      end
      draw_arrow_graphic(actor, 640, 480, i, 3) if name1 == name2
      draw_arrow_graphic(actor, 640, 480, i, 0) if result > 0 and name1 != name2
      draw_arrow_graphic(actor, 640, 480, i, 1) if result == 0 and name1 != name2
      draw_arrow_graphic(actor, 640, 480, i, 2) if result < 0 and name1 != name2
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Graphic
  #     actor   : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     id      : actor position from 0 to 3
  #     tone_id : 0 - Grey (Disabled) | 1 - Normal
  #--------------------------------------------------------------------------
  def draw_actor_graphic(actor, x, y, id, tone_id)
    # by actor id
    case id
    when 0
      @v1 = Viewport.new(390, 98, 32, 48)
      @v1.z = 9999
      @sprite1 = Sprite.new(@v1)
      @sprite1.bitmap = RPG::Cache.character(actor.character_name,
      actor.character_hue)
      if tone_id == 0
        @sprite1.tone = Tone.new(0, 0, 0, 255) # Grey (Disabled) Graphic
      else
        @sprite1.tone = Tone.new(0, 0, 0, 0) # Normal Graphic
      end
      @sprite1.visible = true
    when 1
      @v2 = Viewport.new(450, 98, 32, 48)
      @v2.z = 9999
      @sprite2 = Sprite.new(@v2)
      @sprite2.bitmap = RPG::Cache.character(actor.character_name,
      actor.character_hue)
      if tone_id == 0
        @sprite2.tone = Tone.new(0, 0, 0, 255) # Grey (Disabled) Graphic
      else
        @sprite2.tone = Tone.new(0, 0, 0, 0) # Normal Graphic
      end
      @sprite2.visible = true
    when 2
      @v3 = Viewport.new(510, 98, 32, 48)
      @v3.z = 9999
      @sprite3 = Sprite.new(@v3)
      @sprite3.bitmap = RPG::Cache.character(actor.character_name,
      actor.character_hue)
      if tone_id == 0
        @sprite3.tone = Tone.new(0, 0, 0, 255) # Grey (Disabled) Graphic
      else
        @sprite3.tone = Tone.new(0, 0, 0, 0) # Normal Graphic
      end
      @sprite3.visible = true
    when 3
      @v4 = Viewport.new(570, 98, 32, 48)
      @v4.z = 9999
      @sprite4 = Sprite.new(@v4)
      @sprite4.bitmap = RPG::Cache.character(actor.character_name,
      actor.character_hue)
      if tone_id == 0
        @sprite4.tone = Tone.new(0, 0, 0, 255) # Grey (Disabled) Graphic
      else
        @sprite4.tone = Tone.new(0, 0, 0, 0) # Normal Graphic
      end
      @sprite4.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Arrow Graphic
  #     actor   : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     id      : actor position from 0 to 3
  #     type    : 0 - Up | 1 - Point | 2 - Down | 3 - E
  #--------------------------------------------------------------------------
  def draw_arrow_graphic(actor, x, y, id, type=0)
    case id
    when 0
      @a1 = Viewport.new(390+32, 98+42, 8, 8)
      @a1.z = 9999
      @arrow1 = Sprite.new(@a1)
      @arrow1.bitmap = RPG::Cache.system($game_system.windowskin_name)
      @arrow1.ox = 128
      @arrow1.oy = type*8
      @arrow1.visible = true
    when 1
      @a2 = Viewport.new(450+32, 98+42, 8, 8)
      @a2.z = 9999
      @arrow2 = Sprite.new(@a2)
      @arrow2.bitmap = RPG::Cache.system($game_system.windowskin_name)
      @arrow2.ox = 128
      @arrow2.oy = type*8
      @arrow2.visible = true
    when 2
      @a3 = Viewport.new(510+32, 98+42, 8, 8)
      @a3.z = 9999
      @arrow3 = Sprite.new(@a3)
      @arrow3.bitmap = RPG::Cache.system($game_system.windowskin_name)
      @arrow3.ox = 128
      @arrow3.oy = type*8
      @arrow3.visible = true
    when 3
      @a4 = Viewport.new(570+32, 98+42, 8, 8)
      @a4.z = 9999
      @arrow4 = Sprite.new(@a4)
      @arrow4.bitmap = RPG::Cache.system($game_system.windowskin_name)
      @arrow4.ox = 128
      @arrow4.oy = type*8
      @arrow4.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    @sprite1.visible = self.visible if @sprite1 != nil
    @sprite2.visible = self.visible if @sprite2 != nil
    @sprite3.visible = self.visible if @sprite3 != nil
    @sprite4.visible = self.visible if @sprite4 != nil
    @arrow1.visible = self.visible if @arrow1 != nil
    @arrow2.visible = self.visible if @arrow2 != nil
    @arrow3.visible = self.visible if @arrow3 != nil
    @arrow4.visible = self.visible if @arrow4 != nil
    case @count2
    when 0,4,8,12
      @arrow1.ox = 128+(@count2*2) if @arrow1 != nil
      @arrow2.ox = 128+(@count2*2) if @arrow2 != nil
      @arrow3.ox = 128+(@count2*2) if @arrow3 != nil
      @arrow4.ox = 128+(@count2*2) if @arrow4 != nil
    when 16
      @count2 = -1
    end
    for i in 0..@walk.size
      if @walk[i] == false
        case i
        when 0
          @sprite1.ox = 0 if @sprite1 != nil
        when 1
          @sprite2.ox = 0 if @sprite2 != nil
        when 2
          @sprite3.ox = 0 if @sprite3 != nil
        when 3
          @sprite4.ox = 0 if @sprite4 != nil
        end
      end
    end
    case @count
    when 0, 10, 20, 30
      for i in 0..@walk.size
        if @walk[i] == true
          case i
          when 0
            @sprite1.ox = (@count/10)*32 if @sprite1 != nil
          when 1
            @sprite2.ox = (@count/10)*32 if @sprite2 != nil
          when 2
            @sprite3.ox = (@count/10)*32 if @sprite3 != nil
          when 3
            @sprite4.ox = (@count/10)*32 if @sprite4 != nil
          end
        end
      end
    when 40
      @count = -1
    end
    @count += 1
    @count2 += 1
  end
end