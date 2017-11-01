#==============================================================================
# Skill Drain
# By Atoa
#==============================================================================
# This script allow to create skills and equips that adds the effect 'drain'
# of HP and SP.
# That way attacks and skills can absorb part of the damage caused
#==============================================================================

module Atoa
  # Do not remove this line
  Drain_Action = {'Skill' => {}, 'Weapon' => {}, 'Item' => {}}
  # Do not remove this line
  
  # Drain_Action[action_type][id] = {drain_type => [success, rate, anim_id, pop, show_excedent],...}
  # action_type = action type
  #   action_type = 'Skill' for skills, 'Weapon' for weapons, 'Item' for items
  # id = ID of the skill/weapon/item
  # drain_type = drain type
  #   'hp' for HP drain, 'sp' for SP drain
  # success = absorb success rate
  # rate = % of damage converted in HP/SP
  # anim_id = ID of the animation shown when absorb HP/SP, leave nil or 0 for
  #   no animation
  # 
  
  Drain_Action['Skill'][116] = {'hp' => [100, 50, nil, true, false], 
                                'sp' =>[100, 50, 18, true, false]}
  
  Drain_Action['Weapon'][43] = {'hp' => [50, 50, nil, true, true]}
  
  
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Drain'] = true

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# Esta classe gerencia os jogadores da batalha.
# Esta classe identifica os Aliados ou Heróis como (Game_Actor) e
# os Inimigos como (Game_Enemy).
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # Variáveis Públicas
  #--------------------------------------------------------------------------
  attr_accessor :base_absorb
  #--------------------------------------------------------------------------
  # Inicialização do Objeto
  #--------------------------------------------------------------------------
  alias initialize_drain initialize
  def initialize
    initialize_drain
    @base_absorb = 0
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# Esta classe processa a tela de Batalha
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # Atualização da fase 4 do personagem (parte 1)
  #     battler : Battler ativo
  #--------------------------------------------------------------------------
  alias step4_part1_drain step4_part1
  def step4_part1(battler)
    step4_part1_drain(battler)
    set_drain_damage(battler)
  end
  #--------------------------------------------------------------------------
  # Atualização da fase 4 do personagem (parte 3)
  #     battler : Battler ativo
  #--------------------------------------------------------------------------
  alias step4_part3_drain step4_part3
  def step4_part3(battler)
    step4_part3_drain(battler)
    action = battler.now_action
    if action != nil and Drain_Action[action.type_name] != nil and
       Drain_Action[action.type_name].include?(action_id(action))
      absorb_damage(battler, battler.base_absorb, Drain_Action[action.type_name][action_id(action)].dup)
    end
  end
  #--------------------------------------------------------------------------
  # Definir dano do dreno
  #     battler : Battler ativo
  #--------------------------------------------------------------------------
  def set_drain_damage(battler)
    battler.base_absorb = 0
    for target in battler.target_battlers
      battler.base_absorb += target.damage if target.damage.numeric?
    end
  end
  #--------------------------------------------------------------------------
  # Absover dano
  #     battler : Battler ativo
  #     absorb  : valor de absorção
  #     action  : Ação
  #--------------------------------------------------------------------------
  def absorb_damage(battler, absorb, action)
    for type in action.keys
      if type == 'hp' and (action[type][0] >= rand(100))
        base_absorb = ((absorb * action[type][1]) / 100).to_i
        if base_absorb > 0
          difference = battler.maxhp - battler.hp
          base_absorb = [base_absorb, difference].min
        elsif base_absorb < 0 
          base_absorb = [base_absorb, - battler.hp].max
        end
        if base_absorb != 0
          battler.damage = - base_absorb
          battler.hp -= battler.damage
          battler.animation_id = action[type][2].nil? ? 0 : action[type][2]
          battler.damage_pop = action[type][3]
          wait(3) if battler.damage != 0
        end
      end
      if type == 'sp' and (action[type][0] >= rand(100))
        base_absorb = ((absorb * action[type][1]) / 100).to_i
        if base_absorb > 0
          difference = battler.maxsp - battler.sp
          base_absorb = [base_absorb, difference].min
        elsif base_absorb < 0 
          base_absorb = [base_absorb, - battler.sp].max
        end
        if base_absorb != 0
          battler.damage = - base_absorb
          battler.sp -= battler.damage
          battler.animation_id = action[type][2].nil? ? 0 : action[type][2]
          battler.damage_pop = action[type][3]
          battler.sp_damage = action[type][3]
          wait(3) if battler.damage != 0
        end
      end
    end
  end
end