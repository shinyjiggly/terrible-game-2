#-----------------
#CCOA Caterpillar
#-----------------

DOWN_LEFT  = 1
DOWN       = 2
DOWN_RIGHT = 3
LEFT       = 4
JUMP       = 5
RIGHT      = 6
UP_LEFT    = 7
UP         = 8
UP_RIGHT   = 9

TRANSPARENT_SWITCH = 23

class Game_MoveCommand
  attr_accessor :code
  attr_accessor :args
  
  def initialize(code, args)
    @code = code
    @args = args
  end
end