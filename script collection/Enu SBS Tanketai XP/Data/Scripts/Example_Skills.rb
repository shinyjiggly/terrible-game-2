#==============================================================================
# Add-On: Example skills and Special Effects
#==============================================================================
# These are just a few example skills for your better understand of how can you
# add new skills with new or already made effects
#==============================================================================

#==============================================================================
# Special Effects
# HP and SP Regeneration, SP Poisoning, Auto-Life
# Damage Reflection, Nullify Damage
#==============================================================================
class RPG::State
  alias special_state_extension extension
  def extension
    case @id
    when 21 #HP Regeneration
      return ["REGENERATION"]
    when 22 #SP Regeneration
      return ["REGENERATION"]
    when 23 #SP Poisoning
      return ["SLIPDAMAGE"]
    when 24 #Auto-Life, recovers 25% of maximum HP
      return ["AUTOLIFE/25"]
    when 25 #Reflects physical damage. Shows the animation 106
      return ["PHYREFLECT/105"]
    when 26 #Reflects magical damage. Shows the animation 106
      return ["MAGREFLECT/105"]
    when 27 #Nullifys physical damage. Shows the animation 106
      return ["PHYNULL/105"]
    when 28 #Nullifys magical damage. Shows the animation 106
      return ["MAGNULL/105"]
    end
    special_state_extension
  end
  #--------------------------------------------------------------------------
  alias special_state_slip_extension slip_extension
  def slip_extension
    case @id
    when 21 #HP Regeneration
      return [["hp", 0, -10, true, true]]
    when 22 #SP Regeneration
      return [["mp", 0, -10, true, true]]
    when 23 #SP Poisoning
      return [["mp", 0, 10, true, true]]
    end
    special_state_slip_extension
  end
end

#==============================================================================
# Special Skills
# Damage Drain, SP damage, Speedy Attack
#==============================================================================
class RPG::Skill
  alias special_skill_extension extension
  def extension
    case @id
    when 116 #Converts 50% in HP to the user
      return ["%DMGABSORB/50"]
    when 117 #Causes damage to the SP and converts 50% of the damage in SP to the user
      return ["SPDAMAGE", "%DMGABSORB/50"]
    when 118 #Speedy Attack, always the first action in the turn.
      return ["FAST"]
    end
    special_skill_extension
  end
end

