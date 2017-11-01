# Remodeled Damage Display (Normal Variant) ver 1.02b
# Distribution original support URL
# http://members.jcom.home.ne.jp/cogwheel/

=begin

 Usually,  the damage is displayed on the screen using the default font in white
 lettering.   This system is different in that  it applies images on screen,  in
 place of the generic text.

 To install this system,  the graphics MUST  be placed in the "pictures" folder,
 instead of the  "String"  folder as originally designed by the original author.
 This is so a fully encrypted version will work (wouldn't the other way...).

 With line 32 and 33, you can change or set the height & width of the numbers in
 the .png file holding the individual numbers displayed during battle.
 
 NOTE BY DERVVULFMAN:
 Besides changing the directory where the .png files are kept,  I added a condi-
 tional branch for displaying damage.  This fix (required for effects that don't
 display damage)  only activates the damage display  if there IS a damage bitmap
 to show.  
 
=end


class Scene_Battle
  alias :main_damage :main
  def main
    for path in ["num", "critical", "miss"]
      RPG::Cache.numeric(path)
    end
    main_damage
  end
end

module RPG 
  class Sprite < ::Sprite
    WIDTH = 18                  # Width of individual number in number image.
    HEIGHT = 12                 # Height of individual number in number image.
    
    def damage(value, critical)
      dispose_damage
      if value.is_a?(Numeric)
        damage_string = value.abs.to_s
      else
        damage_string = value.to_s
      end
      if value.is_a?(Numeric)
        damage_string = value.abs.to_s
      else
        damage_string = value.to_s
      end
      if value.is_a?(Numeric)
        if value >= 0
          if critical
            d_bitmap = draw_damage(value, 1)
          else
            d_bitmap = draw_damage(value, 0)
          end
        else
          d_bitmap = draw_damage(value, 2)
        end
      else
        d_bitmap = draw_damage(value, 3)
      end 
      # Added Fix (Only show damage if there IS a damage value to show.)
      if d_bitmap != nil
        @_damage_sprite = ::Sprite.new
        @_damage_sprite.bitmap = d_bitmap
        @_damage_sprite.ox = d_bitmap.width / 2
        @_damage_sprite.oy = d_bitmap.height / 2
        @_damage_sprite.x = self.x + self.viewport.rect.x
        @_damage_sprite.y = self.y - self.oy / 2 + self.viewport.rect.y
        @_damage_sprite.z = 3000
        @_damage_duration = 40
      end
    end
    
    def draw_damage(value, element)
      width = 0
      if value.is_a?(Numeric)
        value = value.abs
        fig = value.to_s.size - 1
        file = RPG::Cache.numeric("num")
        d_width = WIDTH * fig + file.rect.width / 10
        if element == 1
          critical = RPG::Cache.numeric("critical")
          d_width = [d_width, critical.rect.width].max
          d_bitmap = Bitmap.new(d_width, HEIGHT + file.rect.height / 3)
          d_x = (width - critical.rect.width / 10) / 2
          d_bitmap.blt(d_x, 0, critical, critical.rect)
        else
          d_bitmap = Bitmap.new(d_width, HEIGHT + file.rect.height / 3)
        end
        d_x = ((d_width) - (WIDTH * fig + file.rect.width / 10)) / 2
        while fig >= 0
          d_bitmap.blt(d_x, HEIGHT, file, Rect.new((value / (10 ** fig)) *
            file.rect.width / 10, element * file.rect.height / 3,
            file.rect.width / 10, file.rect.height / 3))
          d_x += WIDTH
          value %= 10 ** fig
          fig -= 1
        end
      else
        case value
        when ""
          return
        when "Miss"
          file = RPG::Cache.numeric("miss")
        else
          file = RPG::Cache.numeric(value)
        end
        d_bitmap = file
      end
      return d_bitmap
    end
  end
  
  module Cache
    def self.numeric(filename)
      self.load_bitmap("Graphics/Pictures/", filename)
    end
  end
end