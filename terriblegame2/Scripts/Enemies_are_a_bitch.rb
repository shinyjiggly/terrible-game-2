  #--------------------------------------------------------------------------
  # Enemies are a bitch - by shinyjiggly
  # With this, enemies will go after whomstever has a lower hp percentage... 
  # ...usually.
  #-------------------------------------------
  # * Random Selection of Target Actor
  #     hp0 : limited to actors with 0 HP
  #--------------------------------------------------------------------------
  class Game_Party
  alias  terrible_random_target_actor random_target_actor
  def random_target_actor(hp0 = false)
    # Initialize roulette
    roulette = []
    # Loop
    for actor in @actors
      # If it fits the conditions
      if (not hp0 and actor.exist?) or (hp0 and actor.hp0?)
        # Get actor hp percentage
        health_percent = actor.hp*10 / actor.maxhp*10 #p sprintf("%s", health_percent)
       
        #the lowest hp percentage is picked more
         n = (100 - health_percent)/2 #n = health_percent/100
        # Add actor to roulette n times
        if n < 1 then n=1 end
        n.times do
          roulette.push(actor)
        end
      end
    end
    # If roulette size is 0
    if roulette.size == 0
      return nil
    end
    # Spin the roulette, choose an actor
    
    return roulette[rand(roulette.size)] #p sprintf("%s", roulette) #debug
    
  end
  end