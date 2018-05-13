#-------------------------
#   Game_Train
#    Makes the caterpillar thingie work.
#------------------------

class Game_Train
  attr_reader :actors
  attr_accessor :returning_to_player
  
  def initialize
    @returning_to_player = false
    
    @move_list = []
    @actors = []
    
    @actors.push(Game_TrainActor.new(1))
    @actors.push(Game_TrainActor.new(2))
    @actors.push(Game_TrainActor.new(3))
    @actors.push(Game_TrainActor.new(4))
    @actors.push(Game_TrainActor.new(5))
    @actors.push(Game_TrainActor.new(6))
    @actors.push(Game_TrainActor.new(7))
    @actors.push(Game_TrainActor.new(8))
    @actors.push(Game_TrainActor.new(9))
  end
  
  def add_move(command)
    unless @move_list.empty?
      move_actors
    end
    @move_list.unshift(command)
    if @move_list.size > @actors.size
      @move_list.pop
    end
  end
  
  def refresh
    for actor in @actors
      actor.refresh
    end
  end
  
  def move_actors
    @move_list.each_index do |i|
      if @actors[i] != nil and !@actors[i].move_route_forcing
        case @move_list[i].code
          when DOWN
            @actors[i].move_down(@move_list[i].args[0])
          when LEFT
            @actors[i].move_left(@move_list[i].args[0])
          when RIGHT
            @actors[i].move_right(@move_list[i].args[0])
          when UP
            @actors[i].move_up(@move_list[i].args[0])
          when DOWN_LEFT
            @actors[i].move_lower_left
          when DOWN_RIGHT
            @actors[i].move_lower_right
          when UP_LEFT
            @actors[i].move_upper_left
          when UP_RIGHT
            @actors[i].move_upper_right
          when JUMP
            @actors[i].jump(@move_list[i].args[0], @move_list[i].args[1])
        end
      end
    end
  end
  
  def clear_movelist
    @move_list = []
  end
  
  def return_to_player
    clear_movelist
    @returning_to_player = true
  end
end