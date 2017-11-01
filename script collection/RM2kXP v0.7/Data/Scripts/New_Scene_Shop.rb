#==============================================================================
# Scene_Shop
#==============================================================================

class Game_System
  # New accessor shop_type defines if shop is default or is a only buy / sell shop
  attr_accessor :shop_type
  alias rm2kxp_shop_ini initialize unless $@
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize
    rm2kxp_shop_ini
    @shop_type = "Default" # "Default" | "OnlyBuy" | "OnlySell"
  end
end

class Scene_Shop
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make help window
    @help_window = Window_Help.new
    # Make spriteset background
    @spriteset = Spriteset_Map.new
    # Make command window
    s1 = Vocab::BUY_SHOP
    s2 = Vocab::SELL_SHOP
    s3 = Vocab::QUIT_SHOP
    @command_window = Window_Command.new(640, [s1, s2, s3])
    @command_window.x = 0
    @command_window.y = 352
    # Control Shop Type
    @buy_enabled = true
    @sell_enabled = true
    case $game_system.shop_type
    when "Default"
      @buy_enabled = true
      @sell_enabled = true
    when "OnlyBuy"
      @buy_enabled = true
      @sell_enabled = false
    when "OnlySell"
      @buy_enabled = true
      @sell_enabled = false
    end
    if @buy_enabled == false
      @command_window.disable_item(0)
    end
    if @sell_enabled == false
      @command_window.disable_item(1)
    end    
    # Make dummy window
    @dummy_window = Window_Base.new(0, 64, 640, 288)
    # Make gold window
    @gold_window = Window_Gold.new(90)
    @gold_window.x = 370
    @gold_window.y = 288
    @gold_window.visible = false
    # Make back window
    @back_window = Window_Back.new
    # Make buy window
    @buy_window = Window_ShopBuy.new($game_temp.shop_goods)
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window
    # Make sell window
    @sell_window = Window_ShopSell.new
    @sell_window.active = false
    @sell_window.visible = false
    @sell_window.help_window = @help_window
    # Make quantity input window
    @number_window = Window_ShopNumber.new
    @number_window.active = false
    @number_window.visible = false
    # Make status window
    @status_window = Window_ShopStatus.new
    @status_window.visible = false
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
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @spriteset.dispose
    @help_window.dispose
    @command_window.dispose
    @gold_window.dispose
    @dummy_window.dispose
    @buy_window.dispose
    @sell_window.dispose
    @number_window.dispose
    @status_window.dispose
    @back_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
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
      # Branch by command window cursor position
      case @command_window.index
      when 0  # buy
        if @buy_enabled == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Change windows to buy mode
        @gold_window.visible = true
        @command_window.active = false
        @dummy_window.visible = false
        @buy_window.active = true
        @buy_window.visible = true
        @buy_window.refresh
        @status_window.visible = true
      when 1  # sell
        if @sell_enabled == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Change windows to sell mode
        @command_window.active = false
        @dummy_window.visible = false
        @sell_window.active = true
        @sell_window.visible = true
        @gold_window.visible = false
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
  # * Frame Update (when buy window is active)
  #--------------------------------------------------------------------------
  def update_buy
    # Set status window item
    @status_window.item = @buy_window.item
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Change windows to initial mode
      @command_window.active = true
      @dummy_window.visible = true
      @gold_window.visible = false
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
  # * Frame Update (when sell window is active)
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
      # Set status window item
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
      @gold_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when quantity input window is active)
  #--------------------------------------------------------------------------
  def update_number
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Set quantity input window to inactive / invisible
      @number_window.active = false
      @number_window.visible = false
      # Branch by command window cursor position
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
        @gold_window.visible = false
      end
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Play shop SE
      $game_system.se_play($data_system.shop_se)
      # Set quantity input window to inactive / invisible
      @number_window.active = false
      @number_window.visible = false
      # Branch by command window cursor position
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
        # Refresh each window
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
        # Refresh each window
        @gold_window.refresh
        @sell_window.refresh
        @status_window.refresh
        # Change windows to sell mode
        @sell_window.active = true
        @sell_window.visible = true
        @status_window.visible = false
        @gold_window.visible = false
      end
      return
    end
  end
end
