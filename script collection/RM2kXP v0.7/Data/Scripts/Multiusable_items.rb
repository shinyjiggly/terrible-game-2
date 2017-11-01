#==============================================================================
# Multiusable items
# By gerkrt/gerrtunk
# Version: 1.5
#==============================================================================
=begin
 
--------Instructions-----------
 
Just add new items in the variable Multiusable_items. You have to do this to
add a new item every time.
 
Ex: If you wanted to add the item number 5 of the database with 3 uses:
 
Multiusable_items = {1=>3, 3=>2, 5=>3}
 
First goes the item id, then the uses. Note that you can remove the two examples
i have add:
 
Multiusable_items = {5=>3}
 
This works like in old Rpgmakers. Internally it will be used the item with less
number of uses left.
 
----------Options-------------
 
Show_uses: If you turn this option on it will add to every multiusable descriptions
the number of uses left, example:
 
Super Potion
Description: 2/2 uses. Recovers 300 HP.
 
Uses_text: You can modify here the text that is add before the uses ratio.
 
 
----------Compatibality-------------
 
The show uses option modifies the shop and item menu, if you have some script
that changue that it can give you problems. Turn this option off if something goes
wrong.
=end 

module Wep
  # By uses. {Item_id=> number of uses}
  Multiusable_items = {3=>2, 4=>2}
  Show_uses = true
  Uses_text = ' uses. '
end

class Game_Party
  attr_reader :multiusable_items
  alias wep_gm_par_init initialize unless $@
  def initialize
    wep_gm_par_init
    @multiusable_items = []
  end

  #--------------------------------------------------------------------------
  # * Gain Items (or lose)
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def gain_item(item_id, n)
    # Update quantity data in the hash.
    if item_id > 0
      # Check if multiusable
      if multiusable?(item_id) and n > 0
        for i in 0...n
          # Push a new item with uses and item id
          uses = Wep::Multiusable_items[item_id]
          @multiusable_items.push([item_id,uses])
        end
      end
      @items[item_id] = [[item_number(item_id) + n, 0].max, 99].min
    end
  end

  #--------------------------------------------------------------------------
  # * Lose Items
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def lose_item(item_id, n)
    if multiusable?(item_id) and have_multiusables?(item_id) and not $scene.is_a?(Scene_Shop)
      # Sort by uses
      @multiusable_items.sort! {|a,b|a[1]<=> b[1]}
      # Iterate over all items in search of what have the lowest uses
      i=0
      for item in @multiusable_items
        if item[0] == item_id
          @multiusable_items[i][1]-=1
          # If have no more uses, delete it
          if @multiusable_items[i][1] == 0
            @multiusable_items.delete(item)
            @items[item_id] = [[item_number(item_id) -1, 0].max, 99].min
          end
          break
        end
        i+=1
      end
    elsif $scene.is_a?(Scene_Shop) and multiusable?(item_id)
      i=0
      to_lose = n
      @multiusable_items.sort! {|a,b|a[1]<=> b[1]}
      for item in @multiusable_items
        if to_lose == 0
          break
        end
        if item[0] == item_id
          @multiusable_items.delete_at(i)
          to_lose-=1
        end
        i+=1
      end
      @items[item_id] = [[item_number(item_id) -n, 0].max, 99].min
    else
      # Reverse the numerical value and call it gain_item
      gain_item(item_id, -n)
    end
  end

  #--------------------------------------------------------------------------
  # * Have Multiusables?
  #--------------------------------------------------------------------------
  def have_multiusables?(item_id)
    for item in @multiusable_items
      if item[0] == item_id
        return true
      end
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * Multiusables?
  #--------------------------------------------------------------------------
  def multiusable?(item_id)
    return Wep::Multiusable_items[item_id]
  end
end

if Wep::Show_uses
  
class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    if Wep::Multiusable_items[self.item.id] and self.item != nil
      for item in $game_party.multiusable_items
        if item[0] == self.item.id
          uses=item[1]
          break
        end
      end
      description = uses.to_s+'/'+Wep::Multiusable_items[self.item.id].to_s+Wep::Uses_text+self.item.description
      @help_window.set_text(description)
    else
      @help_window.set_text(self.item == nil ? "" : self.item.description)
    end
  end
end

class Window_ShopSell < Window_Selectable
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    if Wep::Multiusable_items[self.item.id] and self.item != nil
      for item in $game_party.multiusable_items
        if item[0] == self.item.id
          uses=item[1]
          break
        end
      end
      description = uses.to_s+'/'+Wep::Multiusable_items[self.item.id].to_s+Wep::Uses_text+self.item.description
      @help_window.set_text(description)
    else
      @help_window.set_text(self.item == nil ? "" : self.item.description)
    end
  end
end  

end
