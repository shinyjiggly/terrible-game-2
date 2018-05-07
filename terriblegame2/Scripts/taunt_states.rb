#===============================================================================
# Taunt States
# Version 1.0
# Author game_guy
#-------------------------------------------------------------------------------
# Intro:
# When Taunting an enemy, the taunter has a higher chance of being attacked
# by all enemies. This script, rather than using skills, it uses states to
# control the taunt levels.
#
# Features:
# Customizable Taunt States
# Can Even Be Used to Avoid Attacks
#
# Instructions:
# Hop down to the CONFIGURE STATES area and you'll add your state and taunt
# configurations there. Taunt can be reversed to also Avoid attacks. To do
# this, simply set the taunt level to a negative number. The number you assign
# to the state, is the number of times it'll add/remove the member to the
# roullette when being attacked by enemies.
#
# Now to have an actor "taunt" the enemies, all you need to do is give him a
# taunt state, which can easily be done through skills or items.
#
# Credits:
# game_guy ~ Creation of this fine script.
# GrimTrigger ~ For requesting it.
#===============================================================================
=begin
module TauntStates
  STATES = {
  #=========================
  # CONFIGURE STATES
  # -Add new lines.
  # state_id => taunt_level,
  #=========================
    20 => 1,
    21 => 2,
    22 => 4,
    23 => -4,
  }
end

class Game_Actor < Game_Battler
  def calculate_taunt
    taunt = 0
    TauntStates::STATES.each {|key, value|
      taunt += value if @states.include(key)}
    return taunt
  end
end

class Game_Party
  def random_target_actor(hp0 = false)
    roulette = []
    for actor in @actors
      if (not hp0 and actor.exist?) or (hp0 and actor.hp0?)
        position = $data_classes[actor.class_id].position
        n = [4 - position + actor.calculate_taunt, 1].max
        n.times do
          roulette.push(actor)
        end
      end
    end
    if roulette.size == 0
      return nil
    end
    return roulette[rand(roulette.size)]
  end
end
=end