#==============================================================================
# Atoa Custom Battle System / Random Monster Groups Patch
# based on the works by Atoa & RPG Advocate
# 
# The script can be found at:
# http://www.save-point.org/showthread.php?tid=2039
#
#------------------------------------------------------------------------------
#    Edit/Patch by DerVVulfman
#    version 1.0
#    08-17-2009
#    RGSS / RMXP - Involves Rewrites
#    Requires:  Atoa's Custom Battle System
#               & Random Monster Groups v 1.1 (Revision by DerVVulfman)
#
#==============================================================================
 
 
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================
 
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     troop_id     : troop ID
  #     member_index : troop member index
  #     random_index : random troop index  
  #--------------------------------------------------------------------------
  def initialize(troop_id, member_index, random_index = -1)
    super()
    @troop_id = troop_id
    @member_index = member_index
    troop = $data_troops[@troop_id]
    @enemy_id = troop.members[@member_index].enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @maxhp = maxhp
    @maxsp = maxsp
    @hp = @maxhp
    @sp = @maxsp
    @str = base_str
    @dex = base_dex
    @agi = base_agi
    @int = base_int
    @gold = gold
    @exp = exp
    @hidden = troop.members[@member_index].hidden
    @immortal = troop.members[@member_index].immortal
    @random_index = member_index
    @random_index = member_index
    if random_index >= 0
      @random_index = random_index
      @member_index = random_index
    end    
    battle_setup
    @steal_items = Enemy_Steal[@enemy_id].to_a
    @steal_attempt = 0
    @moving = @sp_damage = false
  end
end