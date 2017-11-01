# Seperate Item Lists for Multiple Parties 
# by RPG Advocate


#==============================================================================
# ** Game_ItemBag
#------------------------------------------------------------------------------
#  This class handles the item bags. It includes item list creation, merging &
#  other functions. Refer to "$game_itembag" for the instance of this class.
#==============================================================================

class Game_ItemBag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @itembags = []
    @itembags[0] = []
    for j in 1..10
      @itembags[j] = []
    end
    @itembags[0][0] = -1
    for j in 1..10
      @itembags[j][0] = -1
    end
  end
  #--------------------------------------------------------------------------
  # * Item List Creation
  #     id     : id of item bag
  #--------------------------------------------------------------------------
  def create(id)
    @itembags[id][0] = $game_party.gold
    for weapon in $data_weapons
      number = weapon.id
      @itembags[id][number] = $game_party.weapon_number(number)
    end
    for armor in $data_armors
      number = armor.id
      @itembags[id][number + 1000] = $game_party.armor_number(number)
    end
    for item in $data_items
      number = item.id
      @itembags[id][number + 2000] = $game_party.item_number(number)
    end
    $game_party.lose_gold(9999999)
    for weapon in 1..$data_weapons.size - 1
      $game_party.lose_weapon(weapon, 99)
    end
    for armor in 1..$data_armors.size - 1
      $game_party.lose_armor(armor, 99)
    end
    for item in 1..$data_items.size - 1
      $game_party.lose_item(item, 99)
    end
  end
  #--------------------------------------------------------------------------
  # * Item List Replace
  #     id         : id of item bag
  #     delete_bag : flag if deleting source bag
  #--------------------------------------------------------------------------
  def replace(id, delete_bag = true)
    if @itembags[id][0] == -1
      print("Warning: This item bag does not exist.")
      return
    end
    $game_party.lose_gold(9999999)
    $game_party.gain_gold(@itembags[id][0])
    for weapon in 1..$data_weapons.size - 1
      $game_party.lose_weapon(weapon, 99)
    end
    for armor in 1..$data_armors.size - 1
      $game_party.lose_armor(armor, 99)
    end
    for item in 1..$data_items.size - 1
      $game_party.lose_item(item, 99)
    end
    for weapon in 1..$data_weapons.size - 1
      $game_party.gain_weapon(weapon, @itembags[id][weapon])
    end
    for armor in 1..$data_armors.size - 1
      $game_party.gain_armor(armor, @itembags[id][armor + 1000])
    end
    for item in 1..$data_items.size - 1
      $game_party.gain_item(item, @itembags[id][item + 2000])
    end
    if delete_bag
      delete(id)
    end
  end
  #--------------------------------------------------------------------------
  # * Item List Merge
  #     id1    : id of item bag #1
  #     id2    : id of item bag #2
  #--------------------------------------------------------------------------
  def merge(id1, id2)
    if id2 != -1 && @itembags[id1][0] == -1 && @itembags[id2][0] == -1
      print("Warning: Neither item bag to be merged exists.")
      return
    end
    if @itembags[id1][0] == -1
      print("Warning: The first item bag to be merged does not exist")
      return
    end
    if id2 != -1
      if @itembags[id2][0] == -1
        print("Warning: The second item bag to be merged does not exist")
        return
      end
    end
    if id2 == -1
      $game_party.gain_gold(@itembags[id1][0])
      for weapon in 1..$data_weapons.size - 1
        $game_party.gain_weapon(weapon, @itembags[id1][weapon])
      end
      for armor in 1..$data_armors.size - 1
        $game_party.gain_armor(armor, @itembags[id1][armor + 1000])
      end
      for item in 1..$data_items.size - 1
        $game_party.gain_item(item, @itembags[id1][item + 2000])
      end
      delete(id1)
    end
    if id2 != -1
      @itembags[id1][0] += @itembags[id2][0]
      for weapon in 1..$data_weapons.size - 1
        @itembags[id1][weapon] += @itembags[id2][weapon]
      end
      for armor in 1..$data_armors.size - 1
        @itembags[id1][armor + 1000] += @itembags[id2][armor + 1000]
      end
      for item in 1..$data_items.size - 1
        @itembags[id1][item + 2000] += @itembags[id2][item + 2000]
      end
      delete(id2)
    end
  end
  #--------------------------------------------------------------------------
  # * Merge all bags
  #     mode   : mode of merging (1 = to party inventory /  2 = to all bags)
  #--------------------------------------------------------------------------
  def merge_all(mode)
    if mode != 1 && mode != 2
      print("Merge All: Invalid mode.")
      return
    end
    flag = true
    for j in 1..10
      if @itembags[j][0] != -1
        flag = false
      end
    end
    if flag
      print("Warning: No item bags to merge.")
      return
    end
    if mode == 1
      for j in 1..10
        print(j.to_s)
        if @itembags[j][0] == -1
          next
        end
        $game_party.gain_gold(@itembags[j][0])
        for weapon in 1..$data_weapons.size - 1
          $game_party.gain_weapon(weapon, @itembags[j][weapon])
        end
        for armor in 1..$data_armors.size - 1
          $game_party.gain_armor(armor, @itembags[j][armor + 1000])
        end
        for item in 1..$data_items.size - 1
          $game_party.gain_item(item, @itembags[j][item + 2000])
        end
        delete(j)
      end
    end
    if mode == 2
      if @itembags[1][0] == -1
        @itembags[1][0] = 0
      end
      for j in 2..10
        if @itembags[j][0] == -1
          next
        end
        @itembags[id1][0] += @itembags[id2][0]
        for weapon in 1..$data_weapons.size - 1
          @itembags[1][weapon] += @itembags[j][weapon]
        end
        for armor in 1..$data_armors.size - 1
          @itembags[1][armor + 1000] += @itembags[j][armor + 1000]
        end
        for item in 1..$data_items.size - 1
          @itembags[1][item + 2000] += @itembags[j][item + 2000]
        end
        delete(j)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Item List Copy
  #     source_id       : id of source item bag
  #     destination_id  : id of destination item bag
  #--------------------------------------------------------------------------
  def copy(source_id, destination_id)
    @itembags[destination_id][0] = @itembags[source_id][0]
    for j in 0..2999
      @itembags[destination_id][j] = @itembags[source_id][j]
    end
  end
  #--------------------------------------------------------------------------
  # * Item List Deletion
  #     id     : id of item bag
  #--------------------------------------------------------------------------
  def delete(id)
    for j in 0..2999
      @itembags[id][j] = 0
    end
    @itembags[id][0] = -1
  end
end



#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs title screen processing.
#==============================================================================

class Scene_Title
  #--------------------------------------------------------------------------
  # * Command: New Game
  #--------------------------------------------------------------------------
  alias silmp_cng command_new_game  
  def command_new_game
    # Perform the original call
    silmp_cng
    # Create the game bag 
    $game_itembag = Game_ItemBag.new
  end
end



#==============================================================================
# ** Scene_Save
#------------------------------------------------------------------------------
#  This class performs save screen processing.
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Write Save Data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  alias silmp_wsd write_save_data  
  def write_save_data(file)
    # Perform the original call
    silmp_wsd(file)
    # Save the game bag data
    Marshal.dump($game_itembag, file)
  end  
end


  
#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  This class performs load screen processing.
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Read Save Data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  alias silmp_rsd read_save_data
  def read_save_data(file)
    # Perform the original call
    silmp_rsd(file)
    # Load the game bag data
    $game_itembag = Marshal.load(file) 
    # Refresh party members
    $game_party.refresh
  end  
end