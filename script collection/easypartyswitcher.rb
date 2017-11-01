#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# Easy Party Switcher by Blizzard
# Version 2.11b
# Type: Party Changing System
# Date: 21.05.2006
# Date v1.1: 25.05.2006
# Date v1.2b: 27.05.2006
# Date v1.5b: 3.11.2006
# Date v1.51b: 29.11.2006
# Date v1.52b: 6.12.2006
# Date v1.7b: 23.2.2007
# Date v1.8b: 30.4.2007
# Date v2.0b: 7.8.2007
# Date v2.1b: 24.8.2007
# Date v2.11b: 24.9.2007
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# 
# Special Thanks to:
# 
#   Zeriab for pointing out a few glitches and shortening the code in an
#   earlier version. =D
# 
# 
# IMPORTANT NOTE:
# 
#   Be sure to set the MAX_PARTY to the maximum size of your party. There is
#   already a preconfiguration of 4.
# 
# 
# Compatibility:
# 
#   98% compatible with SDK v1.x. 90% compatible with SDK 2.x. Can cause
#   incompatibility issued with other Party Change Systems. WILL corrupt your
#   old savegames. 
# 
# 
# Features:
# 
#   - set party members for "not _available" (shown transparent in the reserve)
#   - remove party members from the reserve list ("disabled_for_party")
#   - set party members, who MUST be in the party (shown transparent in the
#     current party, "must_be_in_party")
#   - set up forced positions for party members
#   - set up forced party size
#   - option either to wipe the party (for multi-party use) or only remove
#     every member (except 1) from the party.
#   - easy to use and easy to switch party members
#   - also supports small parties (2 or 3 members) and large parties (5 or
#     more)
#   - uses facesets optionally
# 
# v1.5b:
#   - better, shorter and more efficient code (less memory use, less CPU use)
#   - fixed potential bugs
# 
# v1.7b:
#   - improved coding
#   - facesets now optional
#   - no extra bitmap files needed anymore
#   - works now with Tons of Add-ons
# 
# v1.8b:
#   - added "forced position"
#   - added "forced party size"
# 
# v2.0b:
#   - fixed the bug where you could empty the party... again...
#   - fixed the bug that appeared when you pressed SHIFT
#   - added option to allow an empty party
#   - added "EXP for party members in reserve" option
#   - made the forced_size for party work more convenient
#   - improved coding
#   - slightly decreased lag
# 
# v2.1b:
#   - fixed a bug
#   - improved coding
#   - rewritten conditions using classic syntax to avoid RGSS conditioning bug
#   - now can serve as enhancement for CP Debug System
# 
# v2.11b:
#   - improved coding and performance
# 
# 
# How to use:
# 
#   To call this script, make a "Call script" command in an event.
# 
#   1. Syntax: $scene = Scene_PartySwitcher.new
#      No extra feature will be applied and you can switch the party as you
#      wish.
# 
#   2. Syntax: $scene = Scene_PartySwitcher.new(XXX)
#      You can replace XXX for 1 to remove all party members except one (either
#      one, who must be in the party or a random one), or replace XXX with 2,
#      to cause a wipe party. Wiping a party will disable the of the current
#      members and a NEW party of the remaining members must be formed. If you
#      replace it with 3, the current party configuration will be stored for a
#      later fast switch-back. If XXX is 10, all actors will be available for
#      party switching no matter if the are "not_available" or
#      "disabled_for_party". This feature if used by the CP Debug System. No
#      faceset will be used in this case for a more convenient working.
# 
#   3. Syntax: $scene = Scene_PartySwitcher.new(XXX, 1)
#      You can use the XXX as described above or just set it to 0 to disable
#      it. Also the "1" in the syntax will reset any disabled_for_party and is
#      made to be used after multi-party use.
# 
#   4. Syntax: $scene = Scene_PartySwitcher.new(XXX, YYY, ZZZ)
#      You can replace ZZZ with 1 to replace the party with a stored one AND
#      store the current or replace it with 2 to replace the party with a
#      stored one, but without storing the current. USE THIS ONLY IF YOU ASSUME
#      TO HAVE A STORED PARTY READY! You can simply test if there is a store
#      party by putting this code into the conditional branch script:
# 
#      $game_system.stored_party != nil
# 
#      This syntax will not open the Party Switcher and it will override the
#      commands XXX and YYY, so you can replace these with any number.
# 
#   Character faces go into the "Characters" folder and they have the same name
#   as the character spritesets have with _face added
# 
#   Example:
# 
#     sprite - Marlen.png
#     face   - Marlen_face.png
# 
#   Other syntaxes:
#     $game_actors[ID].not_available = true/false
#     $game_actors[ID].disabled_for_party = true/false
#     $game_actors[ID].must_be_in_party = true/false
#     $game_actors[ID].forced_position = nil/0/1/2/...
#   OR
#     $game_party.actors[POS].not_available = true/false
#     $game_party.actors[POS].disabled_for_party = true/false
#     $game_party.actors[POS].must_be_in_party = true/false
#     $game_party.actors[POS].forced_position = nil/0/1/2/...
# 
#   ID  - the actor's ID in the database
#   POS - the actor's position in the party (STARTS FROM 0, not 1!)
# 
#   not_available
#   - will disable the possibility of an already unlocked character to be in
#     the current party
# 
#   disabled_for_party
#   - will cause the character NOT to appear in the party switch screen at all
# 
#   must_be_in_party
#   - will cause the character to be automatically moved into the current party
#     and he also cannot be put in the reserve
# 
#   forced_position
#   - will enforce the player to be at a specific position in the party, set
#     this value to nil to disable this feature, use it in combination with
#     must_be_in_party and $game_party.forced_size or you might experience
#     bugs,
# 
#   $game_party.forced_size = nil/0/1/2/...
# 
#   Using this syntax will enforce a specific party size. The EPS won't exit
#   until this size is filled up or there are no more in the reserve. EPS will
#   automatically "correct" this number if there are not enough characters in
#   the reserve to fill up a party of forced_size. Set this value to nil to
#   disable the size requirement. Note that the actor DO NOT HAVE TO be set in
#   normal order without any empty position like in version 1.x.
# 
# 
# Additional note:
# 
#   For your own sake, do not apply the attribute "must_be_in_party" to a
#   character at the same time with "not_available" or "disabled_for_party" as
#   this WILL disrupt your party and party switch system. Use "forced_position"
#   together with "must_be_in_party" to avoid bugs. Be careful when using
#   "forced_position" with "$game_party.forced_size". Add actors at the very
#   end to be sure the player can't put others after them if the "forced_size"
#   is smaller than the maximum party size.
# 
# 
# If you find any bugs, please report them here:
# http://www.chaosproject.co.nr
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# START Conficuration
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# how many party members do you use
MAX_PARTY = 4
# set to true to use facesets instead of spritesets
FACESETS = false
# allows a party with 0 members
ALLOW_EMPTY_PARTY = false
# gives all other characters EXP (specify in %)
EXP_RESERVE = 50
# gives "not available" characters EXP (specify in %)
EXP_NOT_AVAILABLE = 0
# gives "disabled for party" characters EXP (specify in %)
EXP_DISABLED_FOR_PARTY = 0

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# END Conficuration
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# recognition variable for plug-ins
$easy_party_switcher = true

#==============================================================================
# Game_Actor
#==============================================================================

class Game_Actor < Game_Battler

 attr_accessor :must_be_in_party
 attr_accessor :disabled_for_party
 attr_accessor :not_available
 attr_accessor :forced_position
 
 alias setup_eps_later setup
 def setup(actor_id)
   setup_eps_later(actor_id)
   @must_be_in_party = @disabled_for_party = @not_available = false
 end
 
end

#==============================================================================
# Game_System
#==============================================================================

class Game_System

 attr_accessor :stored_party
 
end

#==============================================================================
# Game_Party
#==============================================================================

class Game_Party

 attr_accessor :actors
 attr_accessor :forced_size
 
 def any_forced_position
   return (@actors.any? {|actor| actor != nil && actor.forced_position != nil})
 end
 
end

#==============================================================================
# Window_Base
#==============================================================================

class Window_Base

 alias draw_actor_graphic_eps_later draw_actor_graphic
 def draw_actor_graphic(actor, x, y)
   if actor != nil && actor.character_name != ''
     classes = [Window_Current, Window_Reserve, Window_HelpStatus]
     if FACESETS && !$all_available && classes.include?(self.class)
       draw_actor_face_eps(actor, x, y)
     else
       if classes.include?(self.class)
         bitmap = RPG::Cache.character(actor.character_name, actor.character_hue)
         x += bitmap.width / 8 + 24
         y += bitmap.height / 4 + 16
       end
       draw_actor_graphic_eps_later(actor, x, y)
     end
   end
 end

 def draw_actor_face_eps(actor, x, y)
   if $tons_version == nil || $tons_version < 3.71 || !FACE_HUE
     hue = 0
   else
     hue = actor.character_hue
   end
   bitmap = RPG::Cache.character("#{actor.character_name}_face", hue)
   src_rect = Rect.new(0, 0, bitmap.width, bitmap.height)
   if actor.not_available || actor.must_be_in_party
     self.contents.blt(x, y, bitmap, src_rect, 128)
   else
     self.contents.blt(x, y, bitmap, src_rect)
   end
 end
 
end

#==============================================================================
# Window_BattleResult
#==============================================================================

class Window_BattleResult
 
 attr_reader :exp
 
end

#==============================================================================
# Window_Current
#==============================================================================

class Window_Current < Window_Selectable

 def initialize
   super(0, 0, 240 + 32, (MAX_PARTY > 4 ? 480 : MAX_PARTY * 120))
   self.contents = Bitmap.new(width - 32, 448 + (MAX_PARTY-4) * 120)
   @item_max = MAX_PARTY
   if $fontface != nil
     self.contents.font.name = $fontface
   elsif $defaultfonttype != nil
     self.contents.font.name = $defaultfonttype
   end
   self.contents.font.size = 24
   refresh
   self.active, self.index = false, -1
 end
 
 def refresh
   self.contents.clear
   $game_party.actors.each_index {|i|
       if $game_party.actors[i] != nil
         draw_actor_graphic($game_party.actors[i], 4, i*120+4)
         draw_actor_name($game_party.actors[i], 152, i*120-4)
         draw_actor_level($game_party.actors[i], 88, i*120-4)
         draw_actor_hp($game_party.actors[i], 88, i*120+28)
         draw_actor_sp($game_party.actors[i], 88, i*120+60)
       end}
 end

 def setactor(index_1, index_2)
   $game_party.actors[index_2], $game_party.actors[index_1] =
       $game_party.actors[index_1], $game_party.actors[index_2]
   refresh
 end

 def getactor(index)
   return $game_party.actors[index]
 end
 
 def update_cursor_rect
   if @index < 0
     self.cursor_rect.empty
     return
   end
   row = @index / @column_max
   self.top_row = row if row < self.top_row
   self.top_row = row - (page_row_max - 1) if row > top_row + (page_row_max - 1)
   y = (@index / @column_max) * 120 - self.oy
   self.cursor_rect.set(0, y, self.width - 32, 88)
 end

 def clone_cursor
   row = @index / @column_max
   self.top_row = row if row < self.top_row
   self.top_row = row - (page_row_max - 1) if row > top_row + (page_row_max - 1)
   y = (@index / @column_max) * 120
   src_rect = Rect.new(0, 0, self.width, 88)
   bitmap = Bitmap.new(self.width-32, 88)
   bitmap.fill_rect(0, 0, self.width-32, 88, Color.new(255, 255, 255, 192))
   bitmap.fill_rect(2, 2, self.width-36, 84, Color.new(255, 255, 255, 80))
   self.contents.blt(0, y, bitmap, src_rect, 192)
 end
 
 def top_row
   return self.oy / 116
 end

 def top_row=(row)
   self.oy = (row % row_max) * 120
 end

 def page_row_max
   return (self.height / 120)
 end

end

#==============================================================================
# Window_Reserve
#==============================================================================

class Window_Reserve < Window_Selectable
 
 attr_reader :actors
 
 def initialize
   super(0, 0, 368, 320)
   setup
   @column_max, rows = 3, @item_max / @column_max
   self.contents = Bitmap.new(width - 32, (rows >= 3 ? rows * 96 : height - 32))
   if $fontface != nil
     self.contents.font.name = $fontface
   elsif $defaultfonttype != nil
     self.contents.font.name = $defaultfonttype
   end
   self.contents.font.size = 24
   self.active, self.index = false, -1
   refresh
 end
 
 def setup
   @actors = []
   (1...$data_actors.size).each {|i|
       unless $game_party.actors.include?($game_actors[i]) ||
           $game_actors[i].disabled_for_party && !$all_available
         @actors.push($game_actors[i])
       end}
   @item_max = (@actors.size + $game_party.actors.size + 3) / 3 * 3
 end
 
 def refresh
   self.contents.clear
   @actors.each_index {|i| draw_actor_graphic(@actors[i], i%3*112+16, i/3*96+8)}
 end
 
 def getactor(index)
   return @actors[index]
 end
 
 def get_number
   return (@actors.find_all {|actor| actor != nil}).size if $all_available
   return (@actors.find_all {|actor| actor != nil && !actor.not_available}).size
 end
 
 def setactor(index_1, index_2)
   @actors[index_1], @actors[index_2] = @actors[index_2], @actors[index_1]
   refresh
 end

 def setparty(index_1, index_2)
   @actors[index_1], $game_party.actors[index_2] =
       $game_party.actors[index_2], @actors[index_1]
   refresh
 end

 def update_cursor_rect
   if @index < 0
     self.cursor_rect.empty
     return
   end
   row = @index / @column_max
   self.top_row = row if row < self.top_row
   self.top_row = row - (page_row_max-1) if row > top_row + (page_row_max-1)
   x, y = (@index % @column_max)*112 + 8, (@index / @column_max)*96 - self.oy
   self.cursor_rect.set(x, y, 96, 96)
 end

 def clone_cursor
   row = @index / @column_max
   self.top_row = row if row < self.top_row
   self.top_row = row - (page_row_max - 1) if row > top_row + (page_row_max - 1)
   x, y = (@index % @column_max) * 112 + 8, (@index / @column_max) * 96
   src_rect = Rect.new(0, 0, 96, 96)
   bitmap = Bitmap.new(96, 96)
   bitmap.fill_rect(0, 0, 96, 96, Color.new(255, 255, 255, 192))
   bitmap.fill_rect(2, 2, 92, 92, Color.new(255, 255, 255, 80))
   self.contents.blt(x, y, bitmap, src_rect, 192)
 end
 
 def top_row
   return self.oy / 96
 end

 def top_row=(row)
   row = row % row_max
   self.oy = row * 96
 end

 def page_row_max
   return (self.height - 32) / 96
 end

end

#==============================================================================
# Window_HelpStatus
#==============================================================================

class Window_HelpStatus < Window_Base

 def initialize(gotactor)
   super(0, 0, 400 - 32, 160)
   self.contents = Bitmap.new(width - 32, height - 32)
   if $fontface != nil
     self.contents.font.name = $fontface
   elsif $defaultfonttype != nil
     self.contents.font.name = $defaultfonttype
   end
   self.contents.font.size = 24
   refresh(gotactor)
   self.active = false
 end
 
 def refresh(actor)
   self.contents.clear
   if actor != nil
     self.contents.font.color = normal_color
     if actor.not_available && !$all_available
       self.contents.draw_text(8, 0, 160, 32, 'not available', 0)
     end
     draw_actor_graphic(actor, 0, 40)
     draw_actor_name(actor, 160, 32)
     draw_actor_level(actor, 96, 32)
     draw_actor_hp(actor, 96, 64)
     draw_actor_sp(actor, 96, 96)
   end
 end

end

#==============================================================================
# Window_Warning
#==============================================================================

class Window_Warning < Window_Base

 def initialize(mode, members)
   super(0, 0, 320, 96)
   self.contents = Bitmap.new(width - 32, height - 32)
   if $fontface != nil
     self.contents.font.name = $fontface
   elsif $defaultfonttype != nil
     self.contents.font.name = $defaultfonttype
   end
   self.contents.font.size = 24
   self.x, self.y, self.z = 320 - width/2, 240 - height/2, 9999
   self.contents.font.color = normal_color
   if mode
     self.contents.draw_text(0, 0, 288, 32, 'You need a party', 1)
     num = [$game_party.forced_size, members + $game_party.actors.nitems].min
     self.contents.draw_text(0, 32, 288, 32, "of #{num} members!", 1)
   else
     self.contents.draw_text(0, 0, 288, 32, 'You cannot remove', 1)
     self.contents.draw_text(0, 32, 288, 32, 'the last party member!', 1)
   end
 end

end

#==============================================================================
# Scene_PartySwitcher
#==============================================================================

class Scene_PartySwitcher
 
 def initialize(wipe_party = 0, reset = 0, store = 0)
   @wipe_party, @store, @reset = store, reset, wipe_party
   @current_window_temp = @reserve_window_temp = 0
   @scene_flag, @temp_window = false, ''
 end
 
 def main
   if @store != 0
     swap_parties
     $scene = Scene_Map.new
     $game_player.refresh
     return
   end
   case @wipe_party
   when 1 then setup_forced_party
   when 2 then wipe_party
   when 3
     $game_system.stored_party = $game_party.actors
     wipe_party
   when 10 then $all_available = true
   end
   if @reset == 1
     (1...$data_actors.size).each {|i| $game_actors[i].not_available = false}
   end
   @current_window = Window_Current.new
   @current_window.index, @current_window.active = 0, true
   @reserve_window = Window_Reserve.new
   @reserve_window.x, @reserve_window.y = 272, 160
   @help_window = Window_HelpStatus.new(@reserve_window.getactor(0))
   @help_window.x = 240 + 32
   Graphics.transition
   loop do
     Graphics.update
     Input.update
     update
     break if $scene != self
   end
   Graphics.freeze
   [@current_window, @reserve_window, @help_window].each {|win| win.dispose}
   $game_party.actors.compact!
   $game_player.refresh
   $all_available = nil
 end
 
 def update
   check = @reserve_window.index
   if @reserve_window.active
     reserve_update
     @reserve_window.update
   end
   if check != @reserve_window.index
     if @reserve_window.active
       actor = @reserve_window.getactor(@reserve_window.index)
     elsif @current_window.active 
       actor = @reserve_window.getactor(@reserve_window_temp)
     end
     @help_window.refresh(actor) if ['', 'Current'].include?(@temp_window)
   end
   current_update if @current_window.active
   if Input.trigger?(Input::B)
     if @scene_flag
       $game_system.se_play($data_system.cancel_se)
       @scene_flag, @temp_window = false, ''
       if @reserve_window.active
         actor = @reserve_window.getactor(@reserve_window.index)
       elsif @current_window.active
         actor = @reserve_window.getactor(@reserve_window_temp)
       end
       @help_window.refresh(actor) if ['', 'Current'].include?(@temp_window)
       [@current_window, @reserve_window].each {|win| win.refresh}
       return
     end
     if $game_party.forced_size != nil &&
         ($game_party.forced_size < $game_party.actors.nitems ||
         ($game_party.forced_size > $game_party.actors.nitems &&
         @reserve_window.get_number != 0))
       $game_system.se_play($data_system.buzzer_se)
       warning(true)
       return
     end
     $game_system.se_play($data_system.cancel_se)
     $scene = Scene_Map.new
   elsif Input.trigger?(Input::A)
     if $game_party.any_forced_position
       $game_system.se_play($data_system.buzzer_se)
     else
       $game_system.se_play($data_system.decision_se)
       $game_party.actors.compact! 
       @current_window.refresh
     end
   end
 end
   
 def current_update
   @current_window.update
   if Input.trigger?(Input::C)
     actor = @current_window.getactor(@current_window.index)
     if actor != nil && actor.forced_position != nil
       $game_system.se_play($data_system.buzzer_se)
     else
       if @scene_flag
         switch_members
       else
         $game_system.se_play($data_system.decision_se)
         @scene_flag, @temp_window = true, 'Current'
         @temp_actor_index = @current_window.index
         @current_window.clone_cursor
       end
     end
   elsif Input.trigger?(Input::RIGHT)
     $game_system.se_play($data_system.cursor_se)
     @current_window.active = false
     @reserve_window.active = true
     @current_window_temp = @current_window.index
     actor = @reserve_window.getactor(@reserve_window_temp)
     @current_window.index = -1
     @reserve_window.index = @reserve_window_temp
     @help_window.refresh(actor) unless @scene_flag
   end
 end
 
 def reserve_update
   if Input.trigger?(Input::C)
     if @scene_flag
       switch_members
     else
       $game_system.se_play($data_system.decision_se)
       @scene_flag, @temp_window = true, 'Reserve'
       @temp_actor_index = @reserve_window.index
       @reserve_window.clone_cursor
     end
   elsif @reserve_window.index % 3 == 0 && Input.repeat?(Input::LEFT)
     $game_system.se_play($data_system.cursor_se)
     @reserve_window.active = false
     @current_window.active = true
     @reserve_window_temp = @reserve_window.index
     @reserve_window.index = -1
     @current_window.index = @current_window_temp
   end
 end
 
 def switch_members
   if @temp_window == 'Reserve' && @reserve_window.active
     @reserve_window.setactor(@temp_actor_index, @reserve_window.index)
     actor = @reserve_window.getactor(@reserve_window.index)
     @help_window.refresh(actor)
   end
   if @temp_window == 'Current' && @current_window.active
     @current_window.setactor(@temp_actor_index, @current_window.index)
   end
   if @temp_window == 'Reserve' && @current_window.active
     actor1 = @current_window.getactor(@current_window.index)
     actor2 = @reserve_window.getactor(@temp_actor_index)
     if call_warning?(@current_window.index, actor2)
       if actor1 != nil && actor1.must_be_in_party
         $game_system.se_play($data_system.buzzer_se)
         @scene_flag, @temp_window = false, ''
         actor = @reserve_window.getactor(@reserve_window_temp)
         [@current_window, @reserve_window].each {|win| win.refresh}
         @help_window.refresh(actor)
         return
       end
       if actor2 != nil && actor2.not_available && !$all_available
         $game_system.se_play($data_system.buzzer_se)
         @scene_flag, @temp_window = false, ''
         actor = @reserve_window.getactor(@reserve_window_temp)
         [@current_window, @reserve_window].each {|win| win.refresh}
         @help_window.refresh(actor)
         return
       end
       @reserve_window.setparty(@temp_actor_index, @current_window.index)
       @current_window.refresh
       actor = @reserve_window.getactor(@reserve_window_temp)
       @help_window.refresh(actor)
     else
       warning
     end
   end
   if @temp_window == 'Current' && @reserve_window.active
     actor1 = @current_window.getactor(@temp_actor_index)
     actor2 = @reserve_window.getactor(@reserve_window.index)
     if call_warning?(@temp_actor_index, actor2)
       if actor1 != nil && actor1.must_be_in_party
         $game_system.se_play($data_system.buzzer_se)
         @scene_flag, @temp_window = false, ''
         actor = @reserve_window.getactor(@reserve_window.index)
         [@current_window, @reserve_window].each {|win| win.refresh}
         @help_window.refresh(actor)
         return
       end
       if actor2 != nil && actor2.not_available && !$all_available
         $game_system.se_play($data_system.buzzer_se)
         @scene_flag, @temp_window = false, ''
         actor = @reserve_window.getactor(@reserve_window.index)
         [@current_window, @reserve_window].each {|win| win.refresh}
         @help_window.refresh(actor)
         return
       end
       @reserve_window.setparty(@reserve_window.index, @temp_actor_index)
       @current_window.refresh
       actor = @reserve_window.getactor(@reserve_window.index)
       @help_window.refresh(actor)
     else
       warning
     end
   end
   $game_system.se_play($data_system.decision_se)
   @scene_flag, @temp_window = false, ''
 end
   
 def wipe_party
   $game_party.actors.each {|actor| actor.not_available = true if actor != nil}
   setup_forced_party(true)
   if $game_party.actors == []
     (1...$data_actors.size).each {|i|
         unless $game_actors[i].not_available ||
             $game_actors[i].disabled_for_party
           $game_party.actors.push($game_actors[i])
           return
         end}
   end
 end
 
 def setup_forced_party(flag = false)
   $game_party.actors, party = [], []
   (1...$data_actors.size).each {|i|
       if $game_actors[i] != nil && $game_actors[i].must_be_in_party &&
            (!$game_actors[i].disabled_for_party || flag) &&
            !$game_actors[i].not_available
         party.push($game_actors[i])
       end}
   party.clone.each {|actor|
       if actor.forced_position != nil
         $game_party.actors[actor.forced_position] = actor
         party.delete(actor)
       end}
   $game_party.actors.each_index {|i|
       $game_party.actors[i] = party.shift if $game_party.actors[i] == nil}
   $game_party.actors += party.compact
 end  
 
 def swap_parties
   $game_party.actors.compact!
   temp_actors = $game_party.actors
   temp_actors.each {|actor| actor.not_available = true}
   $game_system.stored_party.compact!
   $game_system.stored_party.each {|actor| actor.not_available = false}
   $game_party.actors = $game_system.stored_party
   $game_system.stored_party = (@store == 1 ? temp_actors : nil)
 end
 
 def call_warning?(index, actor2)
   return (ALLOW_EMPTY_PARTY || $game_party.actors[index] == nil ||
       actor2 != nil || $game_party.actors.nitems > 1)
 end
 
 def warning(flag = false)
   $game_system.se_play($data_system.buzzer_se)
   @warning_window = Window_Warning.new(flag, @reserve_window.get_number)
   loop do
     Graphics.update
     Input.update
     if Input.trigger?(Input::C)
       $game_system.se_play($data_system.decision_se) if flag
       [@current_window, @reserve_window].each {|win| win.refresh}
       @warning_window.dispose
       @warning_window = nil
       break
     end
   end
 end
 
end

#==============================================================================
# Scene_Battle
#==============================================================================
 
class Scene_Battle
 
 alias start_phase5_eps_later start_phase5
 def start_phase5
   start_phase5_eps_later
   (1...$data_actors.size).each {|i|
       unless $game_party.actors.include?($game_actors[i])
         if $game_actors[i].not_available
           $game_actors[i].exp += @result_window.exp * EXP_NOT_AVAILABLE/100
         elsif $game_actors[i].disabled_for_party
           $game_actors[i].exp += @result_window.exp * EXP_DISABLED_FOR_PARTY/100
         else
           $game_actors[i].exp += @result_window.exp * EXP_RESERVE/100
         end
       end}
 end
 
end