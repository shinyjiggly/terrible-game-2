#===============================================================================
# * Clothes Changing System
# * By Crazyninjaguy
# * http://www.planetdev.net
#===============================================================================
# * You can call this script via call script command $scene = ClothesChanger.new
# * Or by pressing the S key on the map
#===============================================================================
 
module Clothes
 
  # Sprites that are used for the system. Add new sprites on a new line, seperated
  # by a comma.
  # All sprites should be in Graphics/Characters
  SPRITES = [
  \"001-Fighter01\",
  \"010-Lancer02\",
  \"013-Warrior01\",
  \"019-Thief04\",
  \"022-Hunter03\",
  \"023-Gunner01\",
  \"029-Cleric05\",
  \"038-Mage06\"]
 
  # Names are the values that will show instead of the filename
  NAMES = [
  \"Aluxes\",
  \"Basil\",
  \"Cyrus\",
  \"Dorothy\",
  \"Estelle\",
  \"Felix\",
  \"Gloria\",
  \"Hilda\"]
 
end
 
class ClothesChanger
  def main
    @spriteset = Spriteset_Map.new
    @clothes = Window_Clothes.new
    @oldsprite = Window_OldSprite.new
    @command_window = Window_Command.new(160, Clothes::NAMES)
    @command_window.y = 64
        @command_window.height = (480 - 64)
    @command_2 = Window_Command.new(160, [\"Yes\", \"No\"])
    @command_2.x = (640 - 160) / 2
    @command_2.y = (@oldsprite.y + @oldsprite.height)
    @command_2.active = false
    @command_2.visible = false
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
    @command_2.dispose
    @spriteset.dispose
    @clothes.dispose
    @oldsprite.dispose
    if @newsprite != nil
      @newsprite.dispose
    end
  end
  def update
    if @command_window.active
      @command_window.update
      update_command
    elsif @command_2.active
      @command_2.update
      update_command2
    end
  end
  def update_command
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      if @newsprite != nil
        @newsprite.dispose
      end
      @newsprite = Window_NewSprite.new(@command_window.index)
      @command_window.active = false
      @command_2.active = true
      @command_2.visible = true
      @clothes.set_text(\"Are you sure you want to change into these?\")
    end
  end
  def update_command2
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @command_2.active = false
      @command_2.visible = false
      @clothes.set_text(\"Which clothes would you like to change into?\")
      if @newclothes != nil
        @newclothes.dispose
      end
      @command_window.active = true
    elsif Input.trigger?(Input::C)
      case @command_2.index
      when 0
        $game_system.se_play($data_system.decision_se)
        $game_party.actors[0].set_graphic(Clothes::SPRITES[@command_window.index], 0, Clothes::SPRITES[@command_window.index], 0)
        $game_player.refresh
        $scene = Scene_Map.new
      when 1
        $game_system.se_play($data_system.cancel_se)
        @command_2.active = false
        @command_2.visible = false
        @clothes.set_text(\"Which clothes would you like to change into?\")
        if @newclothes != nil
          @newclothes.dispose
        end
        @command_window.active = true
      end
    end
  end
end
 
class Window_Clothes < Window_Base
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, width - 32, 32, \"Which clothes would you like to change into?\", 1)
  end
  def set_text(text)
    self.contents.clear
    self.contents.draw_text(0, 0, width - 32, 32, text, 1)
  end
end
 
class Window_OldSprite < Window_Base
  def initialize
    super(160, 64, 240, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, width - 32, 32, \"Old Clothes\", 1)
    draw_actor_graphic($game_party.actors[0], 100, 100)
  end
end
 
class Window_NewSprite < Window_Base
  def initialize(actor)
    @actor = actor
    super(400, 64, 240, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, width - 32, 32, \"New Clothes\", 1)
    draw_clothes_graphic(Clothes::SPRITES[@actor], 100, 100)
  end
end
 
class Window_Base < Window
  def draw_clothes_graphic(actor, x, y)
    bitmap = RPG::Cache.character(actor, 0)
    cw = bitmap.width / 4
    ch = bitmap.height / 4
    src_rect = Rect.new(0, 0, cw, ch)
    self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
  end
end
 
class Scene_Map
  alias cng_map_clothes_update update
  def update
    cng_map_clothes_update
    if Input.trigger?(Input::Y)
      $scene = ClothesChanger.new
    end
  end
end