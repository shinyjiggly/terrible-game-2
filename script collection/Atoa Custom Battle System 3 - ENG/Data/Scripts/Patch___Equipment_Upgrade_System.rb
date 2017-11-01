#==============================================================================
# Atoa Custom Battle System / Equipment Upgrade System Patch
# Equipment Upgrade System by Charlie Fleed
#==============================================================================
# Patch for Charlies Fleed's Equipment Upgrade System 
#
# The scripts of the upgrade system must be added bellow the
# Battle Main Code and all add-ons. This patch must be added bellow
# the upgrade scripts
#
# The script can be found at:
# http://www.save-point.org/showthread.php?tid=2299
#==============================================================================

#==============================================================================
# ** Object
#------------------------------------------------------------------------------
# Superclass of all other classes.
#==============================================================================

class Object
  #--------------------------------------------------------------------------
  # * Action ID verification
  #     action : action that will have the ID verified
  #--------------------------------------------------------------------------
  def action_id(action)
    return action.nil? ? 0 : (action.is_a?(Enhanced_Weapon) or action.is_a?(Enhanced_Armor)) ? action.ref_id : action.id
  end
end

#==============================================================================
# ** Window_EquipItem
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
#  equipment screen.
#==============================================================================

class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :data
  #--------------------------------------------------------------------------
  # * Refresh (if using 'Add | Equipment Multi Slots')
  #--------------------------------------------------------------------------
  if $atoa_script['Atoa Multi Slot'] 
    def refresh
      if self.contents != nil
        self.contents.dispose
        self.contents = nil
      end
      @data = []
      if @equip_type == 0 or ($atoa_script['Atoa Two Hands'] and 
         @equip_type == 1 and @actor.two_swords_style)
        weapon_set = $data_classes[@actor.class_id].weapon_set
        for i in 1...$data_weapons.size
          next if $atoa_script['Atoa Two Hands'] and Two_Hands_Weapons.include?(i) and @equip_type == 1
          next if $atoa_script['Atoa Two Hands'] and Right_Hand_Weapons.include?(i) and @equip_type == 1
          next if $atoa_script['Atoa Two Hands'] and Left_Hand_Weapons.include?(i) and @equip_type == 0
          if $game_party.weapon_number(i) > 0 and weapon_set.include?(i)
            @data.push($data_weapons[i])
          end
          if i > $game_party.max_database_weapon_id
            if $game_party.weapon_number(i) > 0 and weapon_set.include?($data_weapons[i].ref_id)
              @data.push($data_weapons[i])
            end
          end
        end
      end
      if @equip_type > 0 and not ($atoa_script['Atoa Two Hands'] and @equip_type == 1 and @actor.two_swords_style)
        armor_set = $data_classes[@actor.class_id].armor_set
        for i in 1...$data_armors.size
          if $game_party.armor_number(i) > 0 and armor_set.include?(i)
            if $data_armors[i].type_id == @equip_type
              @data.push($data_armors[i])
            end
          end
          if i > $game_party.max_database_armor_id
            if $game_party.armor_number(i) > 0 and armor_set.include?($data_armors[i].ref_id)
              if $data_armors[i].kind == @equip_type - 1
                @data.push($data_armors[i])
              end
            end
          end
        end
      end
      @data.push(nil) unless @actor.lock_equip(@equip_type)
      @item_max = @data.size
      self.contents = Bitmap.new(width - 32, [row_max, 1].max * 32)
      self.opacity = Equip_Window_Opacity if $atoa_script['Atoa New Status']
      for i in 0...(@actor.lock_equip(@equip_type) ? @item_max : @item_max - 1)
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh (if using 'Add | Two Hands' and not using 'Add | Equipment Multi Slots')
  #--------------------------------------------------------------------------
  if $atoa_script['Atoa Two Hands'] and not $atoa_script['Atoa Multi Slot'] 
    alias refresh_twohands_patch refresh
    def refresh
      if @actor.two_swords_style
        if self.contents != nil
          self.contents.dispose
          self.contents = nil
        end
        @data = []
        if @equip_type == 0 or (@equip_type == 1 and @actor.two_swords_style)
          weapon_set = $data_classes[@actor.class_id].weapon_set
          for i in 1...$data_weapons.size
            next if Two_Hands_Weapons.include?(i) and @equip_type == 1
            next if Right_Hand_Weapons.include?(i) and @equip_type == 1
            next if Left_Hand_Weapons.include?(i) and @equip_type == 0
            if $game_party.weapon_number(i) > 0 and weapon_set.include?(i)
              @data.push($data_weapons[i])
            end
            if i > $game_party.max_database_weapon_id
              if $game_party.weapon_number(i) > 0 and weapon_set.include?($data_weapons[i].ref_id)
                @data.push($data_weapons[i])
              end
            end
          end
        end
        if @equip_type > 1 or (@equip_type == 1 and not @actor.two_swords_style)
          armor_set = $data_classes[@actor.class_id].armor_set
          for i in 1...$data_armors.size
            if $game_party.armor_number(i) > 0 and armor_set.include?(i)
              if $data_armors[i].type_id == @equip_type
                @data.push($data_armors[i])
              end
            end
            if i > $game_party.max_database_armor_id
              if $game_party.armor_number(i) > 0 and armor_set.include?($data_armors[i].ref_id)
                if $data_armors[i].kind == @equip_type - 1
                  @data.push($data_armors[i])
                end
              end
            end
          end
        end
        @data.push(nil)
        @item_max = @data.size
        self.contents = Bitmap.new(width - 32, row_max * 32)
        for i in 0...@item_max-1
          draw_item(i)
        end
      else
        refresh_twohands_patch
      end
    end
  end
end