#SLIP DAMAGE MODIFIER
#Made by Orochii, as a replace for a existing one that didn't worked as I wanted.
#No need for acreditation.

#Instructions:
#Use the next hash to define the state ID and its respective percentage that you
#want to change. The stat HAS to have "Slip Damage" marked on the database.
#If the stat has "Slip Damage" marked on DB and it doesn't appears here, it will
#use a default value, defineable here too, as ID 0.

#Modified methods:
#The following are the "affected" classes inside this script.

#CREATED
#-module OROCHII_SLIP_STATE

#MODIFIED
#-class Game_Battler:
# -Owerwritten
#  slip_damage?
#  slip_damage_effect
# -Aliased
#  initialize

#EXAMPLE:
#SLIP_DAMAGE = {0=>5, 3=>3}
module OROCHII_SLIP_STATE
  SLIP_DAMAGE = {
                0=>5, #defaul value
                1=>1500, #if status doesn't has the check at DB, it will do NOTHIN' desu~
                3=>3  #value for state # 3 on DB
                }
end

class Game_Battler
  include OROCHII_SLIP_STATE unless $@
  
  alias oz_initialize initialize unless $@
  def initialize
    @slip_id_asd = 0
    oz_initialize
  end
  
  def slip_damage?
    for i in @states
      if $data_states[i].slip_damage
        @slip_id_asd = i
        return true
      end
    end
    @slip_id_asd = 0
    return false
  end
  
  def slip_damage_effect
    # Set damage
    if OROCHII_SLIP_STATE::SLIP_DAMAGE.include?(@slip_id_asd)
      self.damage = (self.maxhp / 100) * OROCHII_SLIP_STATE::SLIP_DAMAGE[@slip_id_asd]
    elsif @slip_id_asd!=0
      self.damage = (self.maxhp / 100) * OROCHII_SLIP_STATE::SLIP_DAMAGE[0]
    else
      self.damage = 0
    end
    # Dispersion
    if self.damage.abs > 0
      amp = [self.damage.abs * 15 / 100, 1].max
      self.damage += rand(amp+1) + rand(amp+1) - amp
    end
    # Subtract damage from HP
    self.hp -= self.damage
    # End Method
    return true
  end
end