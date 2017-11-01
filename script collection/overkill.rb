    #===============================================================================
    # ** Battler : OverKill
    #===============================================================================
     
    #-------------------------------------------------------------------------------
    # * SDK Log
    #-------------------------------------------------------------------------------
    if Object.const_defined?(:SDK)
      SDK.log('Battler.OverKill', 'Kain Nobel ©', 3.5, '2009.09.09')
    end
     
    #===============================================================================
    # ** OverKill
    #===============================================================================
     
    module OverKill
      #-----------------------------------------------------------------------------
      # * String for Damage Pop when killing hit was a critical hit
      #-----------------------------------------------------------------------------
      Critical_String = "OverKill!!!"
      #-----------------------------------------------------------------------------
      # * Color for Overkill Damage Pop (Background)
      #-----------------------------------------------------------------------------
      Critical_ColorA  = Color.new(96, 64, 0)
      #-----------------------------------------------------------------------------
      # * Color for Overkill Damage Pop (Main)
      #-----------------------------------------------------------------------------
      Critical_ColorB  = Color.new(255, 64, 64)
      #-----------------------------------------------------------------------------
      # * Color for Overkill Damage Value (Background)
      #-----------------------------------------------------------------------------
      Damage_ColorA    = Color.new(128, 128, 128)
      #-----------------------------------------------------------------------------
      # * Color for Overkill Damage Value (Main)
      #-----------------------------------------------------------------------------
      Damage_ColorB    = Color.new(255, 32, 32)
      #-----------------------------------------------------------------------------
      # * Font Name for Overkill Damage
      #-----------------------------------------------------------------------------
      Font_Name        = "Arial Black"
      #-----------------------------------------------------------------------------
      # * Font Size for Overkill Damage
      #-----------------------------------------------------------------------------
      Font_Size        = 32
    end
     
    #===============================================================================
    # ** Game_Battler
    #===============================================================================
     
    class Game_Battler
      #-----------------------------------------------------------------------------
      # * Alias Listings
      #-----------------------------------------------------------------------------
      alias_method :overkill_gmbattler_attackeffect,:attack_effect
      #-----------------------------------------------------------------------------
      # * Attack Effect Critical Correction
      #-----------------------------------------------------------------------------
      def attack_effect(attacker)
        # Get old attack effect result
        result = overkill_gmbattler_attackeffect(attacker)
        # If damage is critical and fatal
        if self.critical && @hp < self.damage
          # Double the damage just for kicks
          self.damage *= 2
          # Set critical flag for overkill damage pop
          self.critical = OverKill::Critical_String
        end
        # Return attack effect's origional result
        result
      end
    end
     
    #===============================================================================
    # ** RPG::Sprite
    #===============================================================================
     
    class RPG::Sprite < ::Sprite
      #-----------------------------------------------------------------------------
      # * Alias Listings
      #-----------------------------------------------------------------------------
      alias_method :overkill_rpgsprite_damage, :damage
      #-----------------------------------------------------------------------------
      # * Damage
      #-----------------------------------------------------------------------------
      def damage(value, critical)
        # If critical is not set to overkill flag
        if critical != OverKill::Critical_String
          # The usual
          overkill_rpgsprite_damage(value, critical)
          # End the method
          return
        end
        # Dispose of current damage
        dispose_damage
        # Create bitmap to fit overkill damage display
        bitmap = Bitmap.new(160, 96)
        # Convert damage value to string
        damage_string = (value.is_a?(Numeric) ? value.abs.to_s : value.to_s)
        # Set custom overkill font name and size
        bitmap.font.name = OverKill::Font_Name
        bitmap.font.size = OverKill::Font_Size
        # Set overkill critical back color
        bitmap.font.color = OverKill::Critical_ColorA
        # Draw overkill critical background
        bitmap.draw_text(-1, 12-1, 160, 36, OverKill::Critical_String, 1)
        bitmap.draw_text(-1, 12-1, 160, 36, OverKill::Critical_String, 1)
        bitmap.draw_text(+1, 12+1, 160, 36, OverKill::Critical_String, 1)
        bitmap.draw_text(+1, 12+1, 160, 36, OverKill::Critical_String, 1)
        # Set overkill damage back color
        bitmap.font.color = OverKill::Damage_ColorA
        # Draw overkill damage background
        bitmap.draw_text(-1, 32-1, 160, 36, damage_string, 1)
        bitmap.draw_text(+1, 32-1, 160, 36, damage_string, 1)
        bitmap.draw_text(-1, 32+1, 160, 36, damage_string, 1)
        bitmap.draw_text(+1, 32+1, 160, 36, damage_string, 1)
        # Set overkill damage front color
        bitmap.font.color = OverKill::Critical_ColorB
        # Draw overkill damage foreground
        bitmap.draw_text(0, 12, 160, 36, OverKill::Critical_String, 1)
        # Set overkill damage forground
        bitmap.font.color = OverKill::Damage_ColorB
        # Draw overkill damage
        bitmap.draw_text(0, 32, 160, 36, damage_string, 1)
        # Create damage sprites
        @_damage_sprite = ::Sprite.new(self.viewport)
        @_damage_sprite.bitmap = bitmap
        @_damage_sprite.ox = 80
        @_damage_sprite.oy = 20
        @_damage_sprite.x = self.x
        @_damage_sprite.y = self.y - self.oy / 2
        @_damage_sprite.z = 10000
        @_damage_duration = 40
      end
    end

