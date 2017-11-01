#Setup

Variables_Binder.bind_sw('MPB', 'SW_ENABLE_BALLOONS',
							 'Enable Balloons')
Variables_Binder.bind_sw('MPB', 'SW_MESSAGE_SKIP',
							 'Skip Message')
Variables_Binder.bind_var('MPB', 'VAR_EVENT_ID_ANCHOR',
							 'Event ID Anchor')
Variables_Binder.bind_var('MPB', 'VAR_BALLOONSKIN',
							 'Balloonskin ID')
Variables_Binder.bind_var('MPB', 'VAR_CURRENT_EVENT_ID',
							 'Current Event ID')
Variables_Binder.close_binder

#Constants

# Game variables IDs

# Variable holding the event ID to which anchor the balloon
# VAR_EVENT_ID_ANCHOR = 2
# Variable holding the ID of the balloonskin to be used
# VAR_BALLOONSKIN = 3
# Variable holding the ID of the current processing event
# VAR_CURRENT_EVENT_ID = 4

# Game switches IDs

# Switch enabling ballon display
# SW_ENABLE_BALLOONS = 2
# Switch enabling message skip (mainly to display multiple balloons at once)
# SW_MESSAGE_SKIP = 3

# Default font for balloon text
FONT_BALLOON_TEXT = Font.new(Font.default_name, 16)
# Edit the following line for your own custom font, or remove it to keep the default
# FONT_BALLOON_TEXT = Font.new("OdaBalloon", 12)

# Edit the following line to custom the spacing between lines, or keep as is for
# automatic calculation
SPACING_BALLOON_TEXT = 32 - (Font.default_size - FONT_BALLOON_TEXT.size) * 2

# Specify whether you want lines cut in two for more square-shaped balloons
CUT_LINES_IN_TWO = true
# Max number of characters per line for smart line cutting (changing not
# recommended)
MAX_CHARACTERS_PER_LINE = 25

# For each balloonskin, number of frames needed to complete a blinking cycle
# Input nil to disable blinking for that balloonskin
FRAMES_BALLOON_BLINK = {
  "000" => 40,
  "001" => 80,
  "002" => 20
}
# Number of frames for the waiting sprite to animate
FRAMES_BALLOON_WAIT = 20

# Bubbles opacity
OPACITY_BALLOON = 192
# Right padding to avoid last character being out of the frame
PADDING_RIGHT = 16

# Setting this to false will cause small latencies upon using a balloonskin for
# the first time, because they need prior treatment before the can be used.
# Setting this to true makes the game compile all balloonskins upon launching
# the game, which avoids latencies in-game but causes latencies when the
# game starts.
PRECOMPILE_BALLOONSKINS = false#true