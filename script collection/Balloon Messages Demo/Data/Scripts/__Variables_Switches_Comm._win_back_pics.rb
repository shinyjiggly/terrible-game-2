# ==============================================================================
# VARIABLES & SWITCHES COMMANDS
# ------------------------------------------------------------------------------
# This allows to bind commands to changes in game variables by events.
# ------------------------------------------------------------------------------
# EXAMPLE: by entering the following, the first actor's HP will automatically
# change to the content of game variable #0001 each time the variable is
# changed via an event.
#   $variables_command[1] = Proc.new { |v| $game_actors[1].hp = v }
# ==============================================================================

$switches_command = {}
$variables_command = {}

class Interpreter
  alias mp_common_command_121 command_121
  def command_121
		game_switches = {}
    for i in @parameters[0]..@parameters[1]
			game_switches[i] = $game_switches[i]
		end
    mp_common_command_121
    for i in @parameters[0]..@parameters[1]
			unless $switches_command[i].nil?
				$switches_command[i].call($game_switches[i], game_switches[i])
			end
    end
  end

  alias mp_common_command_122 command_122
  def command_122
		game_variables = {}
    for i in @parameters[0]..@parameters[1]
			game_variables[i] = $game_variables[i]
		end
    mp_common_command_122
    for i in @parameters[0]..@parameters[1]
			unless $variables_command[i].nil?
				$variables_command[i].call($game_variables[i], game_variables[i])
			end
    end
  end
end

$switches_init = {}
$variables_init = {}

class Game_Switches
	alias mp_swinit_initialize initialize
	def initialize
		mp_swinit_initialize
		$switches_init.each do |id, v|
			self[id] = v
		end
	end
end

class Game_Variables
	alias mp_varinit_initialize initialize
	def initialize
		mp_varinit_initialize
		$variables_init.each do |id, v|
			self[id] = v
		end
	end
end

class Window_Base
	alias mp_winpic_initialize initialize
	def initialize(*args)
		mp_winpic_initialize(*args)
		@picture = nil
		if File.exist?("Graphics/Pictures/#{self.type.to_s}.png")
			self.windowskin_opacity = 0
			@picture = RPG::Sprite.new
			@picture.bitmap = RPG::Cache.picture(self.type.to_s)
			@picture.x = self.x + self.width / 2
			@picture.y = self.y + self.height / 2
			@picture.z = self.z + 1
			@picture.ox = @picture.bitmap.width / 2
			@picture.oy = @picture.bitmap.height / 2
			@picture.opacity = self.opacity
			@picture.visible = self.visible
		end
	end

	alias mp_winpic_dispose dispose
	def dispose
		if @picture
			@picture.dispose
		end
		return mp_winpic_dispose
	end

	alias windowskin_opacity= opacity=
	def opacity=(opacity)
		if @picture
			@picture.opacity = opacity
		else
			self.windowskin_opacity=(opacity)
		end
	end

	alias mp_winpic_visible= visible=
	def visible=(b)
		if @picture
			@picture.visible = b
		end
		return self.mp_winpic_visible=(b)
	end
	
	alias mp_winpic_x= x=
	def x=(x)
		if @picture
			@picture.x = x + self.width / 2
		end
		return self.mp_winpic_x=(x)
	end

	alias mp_winpic_y= y=
	def y=(y)
		if @picture
			@picture.y = y + self.height / 2
		end
		return self.mp_winpic_y=(y)
	end

	alias mp_winpic_z= z=
	def z=(z)
		if @picture
			@picture.z = z + 1
		end
		return self.mp_winpic_z=(z)
	end
end