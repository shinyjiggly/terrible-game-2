class Game_Temp
  attr_accessor :transfer_move_route      
  # what train actor to transfer move route to

  alias train_init initialize
  def initialize
    train_init
    @transfer_move_route = 0
  end
end
