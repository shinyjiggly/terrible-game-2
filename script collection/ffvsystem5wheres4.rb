
#--------------------------------------------------------------------------
# * FF V System V
#   system by Fomar0153
# This section is the most annoying part to write
#  and probably the part you will mess with least
#  this section is about the windows and their "scenes"
#--------------------------------------------------------------------------
class Scene_Abilities_Change

  def initialize(actor_pos)
    @actor_pos = actor_pos
    @actor = $game_party.actors[actor_pos]
  end
  
    def main    
    # Make command window
    command_window_make

    @command_window.active = true
    # Make status window
    @actor_window = Window_Job_Status.new(@actor_pos)
    @actor_window.x = 0
    @actor_window.y = 0
    @actor_window.refresh(@actor.current_job)
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @command_window.dispose
    @actor_window.dispose
  end

  def update
    @command_window.update
    unless @abilities_window == nil
      @abilities_window.update
    end
    
        # If C button was pressed
      if Input.trigger?(Input::C)
        
        if @command_window.active == true
          if @command_window.index == 2 or (@command_window.index == 1 and @actor.current_job == @actor.unemployed_text)
          @abilities_window = Window_Command.new(160 * 2 - 90, @actor.abilities(1))
          @abilities_window.x = (640 - @abilities_window.width)/2
          @abilities_window.height = 32 * 6
          @abilities_window.y = (480 - @abilities_window.height)/2
          @abilities_window.z = 500
          @command_window.active = false
          @abilities_window.active = true
        else
          # Play cancel SE
          $game_system.se_play($data_system.cancel_se)
        end
        else
          x = @actor.abilities(1)
          @actor.change_active_abilities(x[@abilities_window.index], (@command_window.index - 1))
          @abilities_window.dispose
          @abilities_window = nil
          @command_window.dispose
          command_window_make
          @command_window.active = true
        end
      end
      
        # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
        if @command_window.active == true
            # Switch to menu screen
           $scene = Scene_Menu.new
           return
         else
          @abilities_window.dispose
          @abilities_window = nil
          @command_window.active = true
        end
    end
    # If R button was pressed
    if Input.trigger?(Input::R)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To next actor
      @actor_pos += 1
      @actor_pos %= $game_party.actors.size
      # Switch to different status screen
      $scene = Scene_Abilities_Change.new(@actor_pos)
      return
    end
    # If L button was pressed
    if Input.trigger?(Input::L)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To previous actor
      @actor_pos += $game_party.actors.size - 1
      @actor_pos %= $game_party.actors.size
      # Switch to different status screen
      $scene = Scene_Abilities_Change.new(@actor_pos)
      return
    end

  end

  def command_window_make
    y = @actor.abilities(0)
    if y[0] == nil
      y[0] = ' '
    end
    if y[1] == nil
      y[1] = ' '
    end
    @ability_list = ['Attack', y[0], y[1], 'Item']
    @command_window = Window_Command.new(210, @ability_list)
    @command_window.height = 480
    @command_window.x = 430
    @command_window.y = 0
    @command_window.index = 0
  end
  
  
end

class Scene_Job_Change
  
  def initialize(actor_pos)
    @actor_pos = actor_pos
    @actor = $game_party.actors[actor_pos]
  end
  
  
    def main
    y = $game_party.job_adverts.clone
    @job_list = [@actor.unemployed_text]
    for i in 0...(y.size)
      @job_list.push(y[i])
    end
    
    # Make command window
    
    @command_window = Window_Command.new(210, @job_list)
    @command_window.height = 480
    @command_window.x = 430
    @command_window.y = 0
    @command_window.index = 0
    @command_window.active = true
    # Make status window
    @actor_window = Window_Job_Status.new(@actor_pos)
    @actor_window.x = 0
    @actor_window.y = 0
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @command_window.dispose
    @actor_window.dispose
  end
  
  def update
    @command_window.update
    @actor_window.refresh(@job_list[@command_window.index])
    
    
        # If C button was pressed
      if Input.trigger?(Input::C)
        @actor.change_job(@job_list[@command_window.index])
        if @actor.hp > @actor.maxhp
          @actor.hp = @actor.maxhp
        end
        if @actor.sp > @actor.maxsp
          @actor.sp = @actor.maxsp
        end
        for x in 0...4
          @actor.equip(x, 0)
        end
      $scene = Scene_Abilities_Change.new(@actor_pos)
      end
      
        # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to menu screen
      $scene = Scene_Menu.new
      return
    end
    # If R button was pressed
    if Input.trigger?(Input::R)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To next actor
      @actor_pos += 1
      @actor_pos %= $game_party.actors.size
      # Switch to different status screen
      $scene = Scene_Job_Change.new(@actor_pos)
      return
    end
    # If L button was pressed
    if Input.trigger?(Input::L)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # To previous actor
      @actor_pos += $game_party.actors.size - 1
      @actor_pos %= $game_party.actors.size
      # Switch to different status screen
      $scene = Scene_Job_Change.new(@actor_pos)
      return
    end

  end
end


class Window_Job_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor_pos)
    super(0, 0, 430, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = $game_party.actors[actor_pos]
    @unemployed = @actor.unemployed_text
    refresh(@unemployed)
    end
    
    def refresh(job_name)
      
      self.contents.clear
      x = 64
      y = 0
      draw_actor_graphic(@actor, x - 40, y + 80)
      draw_actor_name(@actor, x, y)
      draw_actor_class(@actor, x + 90, y)
      draw_actor_level(@actor, x, y + 32)
      draw_actor_state(@actor, x + 90, y + 32)
      draw_actor_exp(@actor, x, y + 64)
      unless @actor.get_job == @unemployed
      draw_job_level(@actor, x + 190 , y + 32, job_name)
      draw_ap(@actor, x + 190, y + 64, job_name)
      end
      unless job_name == @unemployed
      job = @actor.get_job(job_name)
      self.contents.font.color = normal_color
      self.contents.draw_text( x - 40, y + 180, 230, 32, job_name)
      self.contents.font.color = system_color
      draw_job_level(@actor, x + 190 , y + 32, job_name)
      self.contents.draw_text( x - 40, y + 244, 230, 32, 'HP Bonus')
      self.contents.font.color = normal_color
      self.contents.draw_text( x + 50, y + 244, 230, 32, job['HP'].to_s)
      self.contents.font.color = system_color
      self.contents.draw_text( x + 75, y + 244, 230, 32, 'SP Bonus')
      self.contents.font.color = normal_color
      self.contents.draw_text( x + 165, y + 244, 230, 32, job['SP'].to_s)
      self.contents.font.color = system_color
      self.contents.draw_text( x - 40, y + 276, 230, 32, 'STR Bonus')
      self.contents.font.color = normal_color
      self.contents.draw_text( x + 50, y + 276, 230, 32, job['STR'].to_s)
      self.contents.font.color = system_color
      self.contents.draw_text( x + 75, y + 276, 230, 32, 'DEX Bonus')
      self.contents.font.color = normal_color
      self.contents.draw_text( x + 165, y + 276, 230, 32, job['DEX'].to_s)
      self.contents.font.color = system_color
      self.contents.draw_text( x - 40, y + 308, 230, 32, 'INT Bonus')
      self.contents.font.color = normal_color
      self.contents.draw_text( x + 50, y + 308, 230, 32, job['INT'].to_s)
      self.contents.font.color = system_color
      self.contents.draw_text( x + 75, y + 308, 230, 32, 'AGL Bonus')
      self.contents.font.color = normal_color
      self.contents.draw_text( x + 165, y + 308, 230, 32, job['AGI'].to_s)
      end
    end
    
end

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Class
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y)
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 236, 32, actor.current_job)
  end
  #--------------------------------------------------------------------------
  # * Draw Job Level
  #--------------------------------------------------------------------------
  def draw_job_level(actor, x, y, job = nil)
    if job == nil
      job == actor.current_job
    end
    unless job == actor.unemployed_text
    lvl = actor.job_level(job)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, 'Job Level')
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 80, y, 36, 32, lvl.to_s, 2)
  else
    return #nothing to draw
  end
  end
  #--------------------------------------------------------------------------
  # * Draw Ap to next Job Level
  #--------------------------------------------------------------------------
  def draw_ap(actor, x, y, job_name = nil)
    if job_name == nil
      job_name == actor.current_job
    end
    unless job_name == actor.unemployed_text
    ap = actor.ap_to_next_job_level(job_name)
    lvl = actor.job_level(job_name)
    lvl += 1
    job = actor.get_job(job_name)
    key = 'lvl' + lvl.to_s
    lvl = job[key]
    if lvl == nil
      return
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, 'AP')
    self.contents.font.color = normal_color
    msg = ap.to_s + '/' + lvl.to_s
    self.contents.draw_text(x + 80, y, 56, 32, msg, 2)
  else
    return #nothing to draw
  end
end

end


class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor, element = 0)
    super(0, 128, 640, 352)
    @actor = actor
    @column_max = 2
    @element = element
    refresh
    self.index = 0
    # If in battle, move window to center of screen
    # and make it semi-transparent
    if $game_temp.in_battle
      self.y = 64
      self.height = 256
      self.back_opacity = 160
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    for i in 0...@actor.skills.size
      skill = $data_skills[@actor.skills[i]]
      if skill != nil and (@element == 0 or skill.element_set.include?(@element))
        @data.push(skill)
      end
    end
    # If item count is not 0, make a bit map and draw all items
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  
end