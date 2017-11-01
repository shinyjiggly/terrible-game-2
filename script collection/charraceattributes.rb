#===============================================================================
# Character Races
# Author game_guy
# Version 1.0
#-------------------------------------------------------------------------------
# Intro:
# Adds character races to your game. If you've played oblivion its a lot like 
# that. Pretty much each race has its own stat bonuses, skill bonuses, and
# name.
#
# Features:
# Have unlimited races
# Have stat bonuses
# Have skill bonuses
#
# Instructions:
# Go down to Config. Follow the instructions there.
#
# To change a class of any actor use this.
# $game_actors[actor id].race = race id
#
# Credits:
# game_guy ~ for making it
# Bethesda ~ for making oblvion which this script is based from
#===============================================================================
module GameGuy
  #=========================================================
  # Config
  #=========================================================
  #==========================================
  # DefaultRace ~ The id of the race that 
  # every actor starts with.
  #==========================================
  DefaultRace   = 1 # Default Race for every actor
  def self.racen(id) # Race Names
    case id
    #==========================================
    # Race Name
    # when race_id then return "Name of Race"
    # Example:
    # when 1 then return "Human"
    # Race 1 is called human now
    #==========================================
    when 1 then return "Human"
    when 2 then return "Orc"
    when 3 then return "Elf"
    end
    return "Human"
  end
  def self.raceb(id) # Race Bonus Attributes
    case id
    #==========================================
    # Race Stat Bonuses
    # when race_id then return [hp+, sp+, str+, dex+, agi+, int+]
    # Example:
    # when 1 then return [10, 0, 5, 0, 0, 0]
    # So 'Human' would have a 10 bonus hp and 5 bonus of strength.
    #==========================================
    when 1 then return [10, 0, 5, 0, 0, 0]
    when 2 then return [0, 0, 10, 5, 0, 0]
    when 3 then return [0, 20, 0, 0, 10, 5]
    end
    return [0, 0, 0, 0, 0, 0]
  end
  def self.races(id) # Race Bonus Skills
    case id
    #==========================================
    # Race Bonus Skills
    # when 1 then return [skill 1, skill 2, ect]
    # Example:
    # when 1 then return [1, 2]
    # So 'Human' would know the skills Heal and Greater Heal
    #==========================================
    when 1 then return [1, 2]
    when 2 then return [57, 58]
    when 3 then return [4, 5, 6, 7, 8, 9]
    end
    return []
  end
end
class Game_Actor
  attr_accessor :race_id
  attr_accessor :race_name
  alias gg_add_races_act_later setup
  def setup(actor_id)
    @race_id = 0
    gg_add_races_act_later(actor_id)
    setup_race(GameGuy::DefaultRace)
  end
  def setup_race(id = 0)
    old_id = @race_id
    stats = GameGuy.raceb(old_id)
    @maxhp_plus -= stats[0]
    @maxsp_plus -= stats[1]
    @str_plus -= stats[2]
    @dex_plus -= stats[3]
    @agi_plus -= stats[4]
    @int_plus -= stats[5]
    @race_id = id
    skills = GameGuy.races(old_id)
    skills2 = []
    for i in $data_classes[@class_id].learnings
      skills2.push(i.skill_id)
    end
    for i in skills
      unless skills2.include?(i)
        forget_skill(i)
      end
    end
    stats = GameGuy.raceb(@race_id)
    @maxhp_plus += stats[0]
    @maxsp_plus += stats[1]
    @str_plus += stats[2]
    @dex_plus += stats[3]
    @agi_plus += stats[4]
    @int_plus += stats[5]
    @race_name = GameGuy.racen(@race_id)
    skills = GameGuy.races(@race_id)
    @hp = maxhp
    @sp = maxsp
    for i in skills
      learn_skill(i)
    end
  end
  def race=(id)
    setup_race(id)
  end
end