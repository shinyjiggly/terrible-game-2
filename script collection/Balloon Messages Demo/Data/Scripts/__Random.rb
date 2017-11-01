class Random
	def initialize(seed = Kernel.rand)
		@vector = []
    if seed.is_a?(Float)
      seed = [seed].pack('F').unpack('I').first
    end
		self.seed = seed
	end
	
	def seed=(seed)
		@index = 0
		@vector.clear
		@vector << seed
		623.times do |i|
			@vector << (0xFFFFFFFF & (0x6c078965 * (@vector.last ^ ( (@vector.last) >> 30)) + i))
		end
	end
	
	def rand(max = nil)
		if @index == 0
			generate_numbers
		end
    y = @vector[@index]
		y ^= y >> 11
		y ^= y << 7 & 0x9d2c5680
		y ^= y << 15 & 0xefc60000
		y ^= y >> 18
		@index += 1
		@index %= 624
    if max
      y *= max
      y /= 2 ** 32
      y = y.to_i
    else
      y = y.to_f
      y /= 2 ** 32
    end
		return y
	end
	
	def generate_numbers
		624.times do |i|
			y = (@vector[i] & 0x80000000) + (@vector[ (i + 1) % 264 ] & 0x7fffffff)
			@vector[i] = @vector[ (i + 397) % 624] ^ (y >> 1)
			if (y % 2) != 0
				@vector[i] ^= 0x9908b0df
			end
		end
	end
end

class Game_System
	alias mp_random_initialize initialize
	def initialize
		mp_random_initialize
		@random = Random.new
	end
	
	def rand(max = nil)
		return @random.rand(max)
	end
end