#-----------------------------------
# Typing quirks
# By shinyJiggly
#-----------------------------------
# How to install:
# Put it somewhere under your message script but still above main.
#
# How to use:
# Change the in-game variable associated with it to whichever quirk 
# value you wish to be active.
#
# Example:
#--------------------------------------------
# @>Control Variables: [0015: quirk] = 1
# @>Text: blablablabla
# -------------------------------------------
# With quirk 1 set to replace all lwercase a's with 4's, 
# @now_text.gsub!(/A/) { "4" } <== like that,
#
# the text will look like this in game:
# "bl4bl4bl4"
#
# All caps: @now_text.upcase! 
# Prefix quirk: @now_text.insert(0, "prefix here") 
# Suffix quirk: @now_text.insert(@now_text.length-1, "suffix here") 
#
# Important note! \c style color codes do not work here!!
# with some RegEx magic, you could probably make way more complicated typing 
# quirks than just simple replace, but this is probably good for most of them.
#----------------------------------------------------------------------------
=begin
class Window_Message < Window_Selectable  
  
alias  quirky_refresh refresh #am I even using these correctly
def refresh
quirky_refresh  
  
if $game_temp.message_text != nil
@now_text = $game_temp.message_text
quirk = $game_variables[21] 
  
  case quirk
		when 1; @now_text.gsub!(/l/) { "w" } #hewwo?  
      @text.gsub!(/poss/) { "paws" } #cat pun suite
      @text.gsub!(/per/) { "purr" }
		when 2; @text.gsub!(/b/) { "8" } #changes the letter b into 8
		else; #if it's not one of those, it's this
  end 
 end
 
 end
 
end
=end