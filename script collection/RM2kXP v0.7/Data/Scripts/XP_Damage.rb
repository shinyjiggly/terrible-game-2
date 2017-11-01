module RPG
  class Sprite < ::Sprite
    def damage(value, critical)
      dispose_damage
      if value.is_a?(Numeric)
        damage_string = value.abs.to_s
      else
        damage_string = value.to_s
      end
      bitmap = Bitmap.new(160, 48)
      bitmap.font.name = "Arial Black"
      bitmap.font.size = 32
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_xp_text(-1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_xp_text(+1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_xp_text(-1, 12+1, 160, 36, damage_string, 1)
      bitmap.draw_xp_text(+1, 12+1, 160, 36, damage_string, 1)
      if value.is_a?(Numeric) and value < 0
        bitmap.font.color.set(176, 255, 144)
      else
        bitmap.font.color.set(255, 255, 255)
      end
      bitmap.draw_xp_text(0, 12, 160, 36, damage_string, 1)
      if critical
        bitmap.font.size = 20
        bitmap.font.color.set(0, 0, 0)
        bitmap.draw_xp_text(-1, -1, 160, 20, Vocab::CRITICAL, 1)
        bitmap.draw_xp_text(+1, -1, 160, 20, Vocab::CRITICAL, 1)
        bitmap.draw_xp_text(-1, +1, 160, 20, Vocab::CRITICAL, 1)
        bitmap.draw_xp_text(+1, +1, 160, 20, Vocab::CRITICAL, 1)
        bitmap.font.color.set(255, 255, 255)
        bitmap.draw_xp_text(0, 0, 160, 20, Vocab::CRITICAL, 1)
      end
      @_damage_sprite = ::Sprite.new(self.viewport)
      @_damage_sprite.bitmap = bitmap
      @_damage_sprite.ox = 80
      @_damage_sprite.oy = 20
      @_damage_sprite.x = self.x
      @_damage_sprite.y = self.y - self.oy / 2
      @_damage_sprite.z = 3000
      @_damage_duration = 40
    end
  end
end
