#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  This class performs shop screen processing.
#==============================================================================

class Scene_Shop < Scene_Base
  def setup
    @sprites = [
      # Make help sprite
      @help_window = Window_Help.new,
      # Make command sprite
      @command_window = Window_ShopCommand.new,
      # Make dummy sprite
      @dummy_window = Window_Base.new(0, 128, 640, 352),
      # Make gold sprite
      @gold_window = Window_Gold.new,
      # Make buy sprite
      @buy_window = Window_ShopBuy.new($game_temp.shop_goods),
      # Make sell sprite
      @sell_window = Window_ShopSell.new,
      # Make quantity input sprite
      @number_window = Window_ShopNumber.new,
      # Make status sprite
      @status_window = Window_ShopStatus.new,
    ]
    @gold_window.x = 480
    @gold_window.y = 64
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window
    @sell_window.active = false
    @sell_window.visible = false
    @sell_window.help_window = @help_window
    @number_window.active = false
    @number_window.visible = false
    @status_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If command sprite is active: call update_command
    if @command_window.active
      update_command
      return
    end
    # If buy sprite is active: call update_buy
    if @buy_window.active
      update_buy
      return
    end
    # If sell sprite is active: call update_sell
    if @sell_window.active
      update_sell
      return
    end
    # If quantity input sprite is active: call update_number
    if @number_window.active
      update_number
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when command sprite is active)
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
      # Branch by command sprite cursor position
      case @command_window.index
      when 0  # buy
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Change windows to buy mode
        @command_window.active = false
        @dummy_window.visible = false
        @buy_window.active = true
        @buy_window.visible = true
        @buy_window.refresh
        @status_window.visible = true
      when 1  # sell
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Change windows to sell mode
        @command_window.active = false
        @dummy_window.visible = false
        @sell_window.active = true
        @sell_window.visible = true
        @sell_window.refresh
      when 2  # quit
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Switch to map screen
        $scene = Scene_Map.new
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when buy sprite is active)
  #--------------------------------------------------------------------------
  def update_buy
    # Set status sprite item
    @status_window.item = @buy_window.item
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Change windows to initial mode
      @command_window.active = true
      @dummy_window.visible = true
      @buy_window.active = false
      @buy_window.visible = false
      @status_window.visible = false
      @status_window.item = nil
      # Erase help text
      @help_window.set_text("")
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Get item
      @item = @buy_window.item
      # If item is invalid, or price is higher than money possessed
      if @item == nil or @item.price > $game_party.gold
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Get items in possession count
      case @item
      when RPG::Item
        number = $game_party.item_number(@item.id)
      when RPG::Weapon
        number = $game_party.weapon_number(@item.id)
      when RPG::Armor
        number = $game_party.armor_number(@item.id)
      end
      # If 99 items are already in possession
      if number == 99
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Calculate maximum amount possible to buy
      max = @item.price == 0 ? 99 : $game_party.gold / @item.price
      max = [max, 99 - number].min
      # Change windows to quantity input mode
      @buy_window.active = false
      @buy_window.visible = false
      @number_window.set(@item, max, @item.price)
      @number_window.active = true
      @number_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when sell sprite is active)
  #--------------------------------------------------------------------------
  def update_sell
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Change windows to initial mode
      @command_window.active = true
      @dummy_window.visible = true
      @sell_window.active = false
      @sell_window.visible = false
      @status_window.item = nil
      # Erase help text
      @help_window.set_text("")
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Get item
      @item = @sell_window.item
      # Set status sprite item
      @status_window.item = @item
      # If item is invalid, or item price is 0 (unable to sell)
      if @item == nil or @item.price == 0
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Get items in possession count
      case @item
      when RPG::Item
        number = $game_party.item_number(@item.id)
      when RPG::Weapon
        number = $game_party.weapon_number(@item.id)
      when RPG::Armor
        number = $game_party.armor_number(@item.id)
      end
      # Maximum quanitity to sell = number of items in possession
      max = number
      # Change windows to quantity input mode
      @sell_window.active = false
      @sell_window.visible = false
      @number_window.set(@item, max, @item.price / 2)
      @number_window.active = true
      @number_window.visible = true
      @status_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when quantity input sprite is active)
  #--------------------------------------------------------------------------
  def update_number
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Set quantity input sprite to inactive / invisible
      @number_window.active = false
      @number_window.visible = false
      # Branch by command sprite cursor position
      case @command_window.index
      when 0  # buy
        # Change windows to buy mode
        @buy_window.active = true
        @buy_window.visible = true
      when 1  # sell
        # Change windows to sell mode
        @sell_window.active = true
        @sell_window.visible = true
        @status_window.visible = false
      end
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Play shop SE
      $game_system.se_play($data_system.shop_se)
      # Set quantity input sprite to inactive / invisible
      @number_window.active = false
      @number_window.visible = false
      # Branch by command sprite cursor position
      case @command_window.index
      when 0  # buy
        # Buy process
        $game_party.lose_gold(@number_window.number * @item.price)
        case @item
        when RPG::Item
          $game_party.gain_item(@item.id, @number_window.number)
        when RPG::Weapon
          $game_party.gain_weapon(@item.id, @number_window.number)
        when RPG::Armor
          $game_party.gain_armor(@item.id, @number_window.number)
        end
        # Refresh each sprite
        @gold_window.refresh
        @buy_window.refresh
        @status_window.refresh
        # Change windows to buy mode
        @buy_window.active = true
        @buy_window.visible = true
      when 1  # sell
        # Sell process
        $game_party.gain_gold(@number_window.number * (@item.price / 2))
        case @item
        when RPG::Item
          $game_party.lose_item(@item.id, @number_window.number)
        when RPG::Weapon
          $game_party.lose_weapon(@item.id, @number_window.number)
        when RPG::Armor
          $game_party.lose_armor(@item.id, @number_window.number)
        end
        # Refresh each sprite
        @gold_window.refresh
        @sell_window.refresh
        @status_window.refresh
        # Change windows to sell mode
        @sell_window.active = true
        @sell_window.visible = true
        @status_window.visible = false
      end
      return
    end
  end
end
