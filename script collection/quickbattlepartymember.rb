#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Battle a Party Member Script
#-----------------------------
# Made by Brewmeister
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Uses:
#------
#  *Transfer the stats of an actor in the party to an enemy.
#  *Battle a party member.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Things that are not possible with this script:
#-----------------------------------------------
#  *Name input for the character that will become an enemy.  The script must
#   read the graphic from the resource manager that corresponds to the
#   character's name.
#  *Skill transfer because characters have skills and enemies have actions.
#   The AI needs the priority setting for actions.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Instructions:
#--------------
#  *Copy this script and paste it in a new section above Main.
#  *Create an enemy for the party member.  The name, graphic, and stats will
#   be transferred, but any actions, experience, and gold you want the
#   character to have will have to be set here.
#  *Create a troop that contains the character.
#  *Change the numbers in the script for enemy_num to the enemy's position in
#   the database and actor_num to the character's position in the party.
#   The first member in the party would be 0, so the second member would be
#   1, the third member would be 2, etc.
#  *Import a battler of the character the player will fight with the name
#   of the character.
#  *Make an event that will contain the fight.  Before removing the character,
#   insert the command, Script: Actor2Enemy.transfer_stats.  Then remove the
#   character and begin battle processing with the troop that contains the
#   party member.
#  *Please make sure that you give Brewmeister credit for making this wonderful
#   script.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Script Editing:
#----------------
# If you have any additions or changes to the script, please contact
# Brewmeister before releasing the script change.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module Actor2Enemy
  def self.transfer_stats(enemy_num = 33, actor_num = 1)
    $data_enemies[enemy_num].name = $game_party.actors[actor_num].name
    $data_enemies[enemy_num].maxhp = $game_party.actors[actor_num].maxhp
    $data_enemies[enemy_num].maxsp = $game_party.actors[actor_num].maxsp
    $data_enemies[enemy_num].str = $game_party.actors[actor_num].base_str
    $data_enemies[enemy_num].dex = $game_party.actors[actor_num].base_dex
    $data_enemies[enemy_num].agi = $game_party.actors[actor_num].base_agi
    $data_enemies[enemy_num].int = $game_party.actors[actor_num].base_int
    $data_enemies[enemy_num].atk = $game_party.actors[actor_num].base_atk
    $data_enemies[enemy_num].pdef = $game_party.actors[actor_num].base_pdef
    $data_enemies[enemy_num].mdef = $game_party.actors[actor_num].base_mdef
    $data_enemies[enemy_num].eva = $game_party.actors[actor_num].base_eva
    $data_enemies[enemy_num].battler_name = $game_party.actors[actor_num].battler_name
    weapon = $game_party.actors[actor_num].weapon_id
    $data_enemies[enemy_num].animation1_id = $data_weapons[weapon].animation1_id
    $data_enemies[enemy_num].animation2_id = $data_weapons[weapon].animation2_id
  end
end