#===============================================================================
# Filename:    start_rmxp.rb
#
# Developer:   Raku (rakudayo@gmail.com)
#
# Description: This script starts RPG Maker XP using the commandline. An 
# argument may be passed to the script which is the relative path to the 
# utility scripts directory.
#===============================================================================

require_relative 'common'

# Make sure RMXP isn't running
exit if check_for_rmxp(true)

# Allow the user to specify the project directory in case they are sharing the
# utility directory with multiple RMXP projects.
$PROJECT_DIR = ARGV[0]

# Log the current system time
command = 'RUBY logtime.rb "' + $PROJECT_DIR + '"'
system(command)

# Definitely do not want the user to close the command window
puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
puts "!!!DO NOT CLOSE THIS COMMAND WINDOW!!!"
puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
puts_verbose

# Start RMXP
command = 'START /WAIT ' + $PROJECT_DIR + '/Game.rxproj'
system(command)