=begin

Romancing SaGa Battle System
By Orochii Zouveleki, this one is Version 1.01

For contact, please search for me at mundo-maker.com, universo-maker.com and
planetarpg.com.ar, mostly if you talk spanish.
You can also find me at rpgmaker.net (for english-speakers).

I have accounts at a lot of communities, but these are the ones I check everyday.

You can also send me an e-mail at 'arcboundcrusher@gmail.com' although I don't 
check it that often (ohohohoho).

Changelog:
1.00 - Initial release. Main systems complete and fully functional.
1.01 - Added some vocabulary config options. Also enemy double troops are 
now explained, and much easier to set up.
     - Menu now has Formation option instead of RowStuff's Position. Still, you
will need to reset it by yourself if you want to use a non-default menu.
     - Changed some stuff here and there on the damage formulae. Be warned, now it
is way more dependable of the Enhanced Positions script!
     -Fixed some non-game-breaking, mostly annoying bugs.

================================================================================
For people that asks "WHAT THE HECK IS ROMANCING SAGA?"
--Please, play it. At least the third one. Is a SNES game, and you will enjoy it.

The Romancing SaGa battles are a kind of side-view turn-based battles, focused
entirely on strategy. Normally you start with lots of characters, from 5 to 6.

Characters can use formations, or different group positions at battle, giving them
bonuses depending on what formation are there, and where are they positioned inside
the formation.

On this script, this have been done for you. A really nice formation system, ready 
for you to mess with it.
  
By default, in this script a character can be in one of these three settings: "front" (f),
"middle" (m) and "back" (represented with d, which means "detras" -back in spanish-).
But this is made in a way that is easily (and infinitely) expandible just with the
things that the script gives to you.

Also, there's a little change in how skills and stuff are presented to you. Instead of
"attack, skill, items, defend, flee" options, you have weapons, skills, and the other ones that
are still useful (items, defense, flee).

Battle is turn-based (ex.DragonQuest, Pokémon), that means you select all actions for
all your characters, and then all battlers take that "turn", depending on their agility.

The battle flow is as follows:
-Select either Fight and Formations. Selecting Fight will let you start with the
character action selection.
When selecting an action with a character, you do the following.
  -Select a weapon first (each character can have up to 4 weapons at the same time)
  using left and right.
  -Select then an action related to that weapon. Depending on weapon-type (refer to
  the database to see how it is done), a set of skills are shown (categories).
    *Categories are set by the database. To set which skill categories haves one weapon 
    available, you use the elements.
    *Second, you set a category for the skill. A skill can only fall into one category.
    If it has two or more, it will use the first one.
-When selecting a formation, just use up and down to select the desired formation.
Press C and it will be the active one.

==================================================================================

IMPORTANT! - SCRIPT ORDER

All scripts have to be under the script entry "Scene_Debug", and above main of 
course.
Scripts order are as follows...
*This mark means that these are external scripts, not mantained by me. Still, 
they're part of the core, so don't forget them!
If you find a newer version of them, you can change it, and it will still work.
However, remember to check their configurations after that!
And also remember to put them at the same place!

RSS Readme! (although you can delete it if you want, it does nothing!)
RowStuff*
RSS Config
RSS BaseDefinitions
RSS BattleScene
>> ANIMATED BATTLERS <<*
    1 - Configuration*
    2 - Sprite System*
    3 - Battle System*
    4 - Misc Code*
    5 - RTAB Patch* (you can delete this one C:)
Animated Battler Formations*
AnimBattlerFix

Those scripts whose names are "lots of ====", "lots of ----" and 
"asd GOES HERE/ENDS HERE", are just sepparators. I like to have things with some
order C:.

Also remember! The Animated Battlers scripts were configurated to be static. 
But YOU can make them animated again! I mean, it's not capped or anything, it's 
just that I didn't wanted to do a lot of battlers :'D.

==================================================================================

Names for actor faces (used in the Status screen)
'''''''''''''''''''''''''''''''''''''''''''''''''
The face graphic name has to be actorface_ID, where ID is the actor Id in the 
database. It was preferred to actor name due to the fact that names CAN be changed
in-game. So this way it lets you change them freely ;).
Faces have to be in the Picture folder.

Ex.: 
Graphics/Picture/actorface_1.png

I made an add-on for Window_Message, to enamble face graphics support.
RECOMMENDED size is 96x96.

==================================================================================

ADD ONS!

So, probably you have noticed those "ADD-ON: xxx" scripts below main. What are those?
Well, simply put, are add-ons. Things that aren't part of the core, that either
I did them randomly while doing this monster C:, or I found them also randomly from
some sites I frequented at the time.

For those I don't take credit, unless I get to specify it in them.

Here's a list of authors:
-FF Damage Display (MultiPop): Made by Squall, and I did some changes on it adding 
            the advanced collapses from Atoa's Custom Battle Script. Code is like, 
            99% of them, so credit them, not me :#). This script adds a nice 
            visual touch at damage display.

-SkillPreview: Made by Pokepic, and with some little visual changes by me.
            What it does is to add a window where you can visualize the selected
            skill animation.

-SlipDmg Modifier: by me. Lets change slip damage percentages on status.

-Actor Percental EXP: by me. Makes actors to level up by percentage, as in
            Live a Live. It also "fixes" enemy experience to depend on the 
            character level, sepparately.

-Beastairy & Item Book: Not only a beastairy and item book really. It has also a
            nice multidrop feature C:! That's why, I love this little monster. 
            Made by ColdStrong.

==================================================================================

===== THANKS! =====
· Piltrafa aka Aarl. For ideasand encouragement, and a nice battle remix! YAY!

· Of course, Squaresoft, for his nice RomaSaGa titles, which was used as 
  inspiration for this thing. Hope they remake 2 & 3 in english someday in 
  the future.

==================================================================================

Further information, please see the RSS Config.
Also see RowStuff configuration, and Animated Battlers Configuration, and each
add-on if you use them. Because most of them have a CONFIGURATION ohohohoho!

Hope you enjoy it! And see ya folks!
Orochii Zouveleki, 2012
=end