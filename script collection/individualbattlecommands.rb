#==============================================================================
# ** Individual Battle Commands (IBC) by Charlie Fleed 
#
# Version: 1.1 RTAB(1.16)
# Author: Charlie Fleed
#==============================================================================

#==============================================================================
# INTRUCTIONS
#==============================================================================

# Configuration of Individual Battle Commands
# Let us assume that you want to create "Black Magic" and "White Magic".
# Well, create two elements named "CMD White Magic" and "CMD Black Magic",
# and add the proper element to all the skills in your database that belong
# to either of the two "categories".
# Finished. Yes. Simple, isn't it?
# Remember, if "name" is you category, use an element called "CMD name".
# "name" will end up in the command window of the actors, and it will be
# displayed only if that actor has at least one skill of that category.
# Enjoy!

#==============================================================================
# SUPPORT FOR INDIVIDUAL BATTLE COMMANDS
#==============================================================================
class Game_Actor
attr_accessor :individual_commands

alias individual_commands_setup setup
def setup(actor_id)
# original call
individual_commands_setup(actor_id)
@individual_commands=[]
end

def refresh_commands
@individual_commands=[]
#print("refresh_commands, actor: ",id.to_s)
#for c in @individual_commands
# print("command: ",c)
#end
for i in 0...@skills.size
skill = $data_skills[@skills[i]]
if skill != nil
for elem_id in skill.element_set
if $data_system.elements[elem_id][0,3]=="CMD"
if !@individual_commands.include?($data_system.elements[elem_id])
@individual_commands.
push(String.new($data_system.elements[elem_id]))
end
end
end
end
end
for c in @individual_commands
# remove "CMD " substring
c[0,4]=""
end
end
end

class Game_Party
#--------------------------------------------------------------------------
# * Add an Actor
# actor_id : actor ID
#--------------------------------------------------------------------------
alias individual_commands_add_actor add_actor
def add_actor(actor_id)
# original call
individual_commands_add_actor(actor_id)
# Get actor
actor = $game_actors[actor_id]
actor.refresh_commands
end
end

class Scene_Battle
#--------------------------------------------------------------------------
# * Actor Command Window Setup
#--------------------------------------------------------------------------
alias ibc_phase3_setup_command_window phase3_setup_command_window
def phase3_setup_command_window
# Original call
ibc_phase3_setup_command_window
# Refresh commands
$game_party.actors[@actor_index].refresh_commands
#@active_battler.refresh_commands
# Make a new window
s1 = $data_system.words.attack
s2 = $data_system.words.skill
s3 = $data_system.words.guard
s4 = $data_system.words.item
#@individual_battle_commands=[s1]+@active_battler.individual_commands+[s3, s4]
@individual_battle_commands=[s1]+$game_party.actors[@actor_index].individual_commands+[s3, s4,ESCAPE_TEXT]
@actor_command_window.dispose
@actor_command_window = Window_Command.new(160, @individual_battle_commands)
# Set actor command window position
@actor_command_window.x = @actor_index * 160
@actor_command_window.y = 320 - 32 - 32*4
@actor_command_window.height = 320 - 32 - 32*4
@actor_command_window.back_opacity = 255
@actor_command_window.opacity = 255
@actor_command_window.active = true
@actor_command_window.visible = true
# Set index to 0
@actor_command_window.index = 0
# show the turn window (shown in start phase 2 only when the enemy attacks)
end

#--------------------------------------------------------------------------
# * Frame Update (actor command phase : basic command)
#--------------------------------------------------------------------------
alias ibc_update_phase3_basic_command update_phase3_basic_command
def update_phase3_basic_command
# If C button was pressed
if Input.trigger?(Input::C)
@party=false
# Branch by actor command window command name
case @actor_command_window.commands[@actor_command_window.index]
# attack
when $data_system.words.attack
# Play decision SE
$game_system.se_play($data_system.decision_se)
# Set action
@active_actor.current_action.kind = 0
@active_actor.current_action.basic = 0
# Start enemy selection
start_enemy_select
return
# Guard
when $data_system.words.guard
# Play decision SE
$game_system.se_play($data_system.decision_se)
# Set action
@active_actor.current_action.kind = 0
@active_actor.current_action.basic = 1
# Go to command input for next actor
phase3_next_actor
return
# item
when $data_system.words.item
# Play decision SE
$game_system.se_play($data_system.decision_se)
# Set action
@active_actor.current_action.kind = 2
# Start item selection
start_item_select
return
end
### SUPPORT FOR INDIVIDUAL BATTLE COMMANDS ###
if @active_actor!=nil and @active_actor.individual_commands.
include?(@actor_command_window.commands[@actor_command_window.index])
# Play decision SE
$game_system.se_play($data_system.decision_se)
@active_actor.current_action.kind = 1
@individual_battle_commands_skill_category=@actor_command_window.commands[@actor_command_window.index]
start_skill_select
return
end
else
ibc_update_phase3_basic_command
end
end

#--------------------------------------------------------------------------
# * Start Skill Selection
#--------------------------------------------------------------------------
alias ibc_start_skill_select start_skill_select
def start_skill_select
# Original call
ibc_start_skill_select
# Make a new skill window
@skill_window.dispose
@skill_window = Window_Skill.new(@active_actor,@individual_battle_commands_skill_category)
# Associate help window
@skill_window.help_window = @help_window
end
end

class Window_Skill < Window_Selectable
#--------------------------------------------------------------------------
# * Object Initialization
# actor : actor
#--------------------------------------------------------------------------
def initialize(actor, skill_command_type = "")
if skill_command_type != ""
@skill_command_element_id = $data_system.elements.
index("CMD " + skill_command_type)
else
@skill_command_element_id = -1
end

super(0, 128, 640, 352)
@actor = actor
@column_max = 2
refresh
self.index = 0
# If in battle, move window to center of screen
# and make it semi-transparent
if $game_temp.in_battle
self.y = 64
self.height = 256
self.back_opacity = 160
end
end

#--------------------------------------------------------------------------
# * Refresh
#--------------------------------------------------------------------------
def refresh
if self.contents != nil
self.contents.dispose
self.contents = nil
end
@data = []
for i in 0...@actor.skills.size
skill = $data_skills[@actor.skills[i]]
if skill != nil
if @skill_command_element_id == -1 or skill.element_set.include?(
@skill_command_element_id)
@data.push(skill)
end
end
end
# If item count is not 0, make a bit map and draw all items
@item_max = @data.size
if @item_max > 0
self.contents = Bitmap.new(width - 32, row_max * 32)
for i in 0...@item_max
draw_item(i)
end
end
end
end

class Window_Command
attr_accessor :commands
end