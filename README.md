# lunatic_whatever
An original RPG Maker XP game about pirates I think.

# How To Work On The Project

## Installing Stuff
1. Install git. Windows version located at https://git-scm.com/download/win
2. Install Ruby. Windows installer located at https://rubyinstaller.org/downloads/

## Working With Git
1. Do this tutorial: https://try.github.io
2. Any questions? PM Blaze and she'll try to help you.

## Cloning The Repository
1. Open Git Bash
2. type `git clone https://github.com/FallingStar-Games/lunatic_whatever.git` and hit enter.
3. Press Win+R
4. type `%USERPROFILE%\lunatic_whatever\Lunatic_Nautilus` and hit enter
5. You should now have an explorer window open in the RPG Maker project directory
6. Click on `Import.bat` and hit enter. This will build the game's files.
7. Open the project in RPG Maker XP, make any changes you want, and then save the project. Remember to close RPG Maker XP.
8. Run `Export.bat` again to prepare your changes to be committed.
9. go back to Git Bash, type `cd lunatic_whatever/Lunatic_Nautilus` and hit enter.
10. Still in Git Bash, run the command `git commit -A` and then run `git commit -m "[MESSAGE]"` NOTE: remember to replace `[MESSAGE]` with a description of what changes you've made. For example, if you changed MAP001, you would run the command `git commit -m "changed MAP001"`
11. Then, simply run `git push origin master` and you're done!