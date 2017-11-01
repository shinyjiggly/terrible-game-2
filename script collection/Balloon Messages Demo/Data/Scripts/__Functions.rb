#==============================================================================
# FUNCTIONS
#------------------------------------------------------------------------------
#  These classes allow to compute a variable from another using a particular
# mathematical formula. Typically used to simulate movements (compute x/y from
# a time factor)
#==============================================================================

#==============================================================================
# ** Function_Affine
#------------------------------------------------------------------------------
#  This class handles constant functions (type y = a)
#==============================================================================
class Function_Constant
	attr_reader	:a

	#-----------------------------------------------------------------------------
	# * Initialize parameters
	#-----------------------------------------------------------------------------
	def initialize(a)
		@a = a
	end
	
	#-----------------------------------------------------------------------------
	# * Compute image
	#-----------------------------------------------------------------------------
	def [](x)
		return @a
	end
	
	#-----------------------------------------------------------------------------
	# * Check for equality
	#-----------------------------------------------------------------------------
	def ==(function)
		if not function.is_a?(Function_Constant)
			return false
		end
		if function.a == @a
			return true
		end
		return false
	end
end

#==============================================================================
# ** Function_Affine
#------------------------------------------------------------------------------
#  This class handles 1st degree polynomial functions (type y = ax + b)
#==============================================================================
class Function_Affine
	attr_reader	:a
	attr_reader	:b

	#-----------------------------------------------------------------------------
	# * Initialize parameters
	#-----------------------------------------------------------------------------
	def initialize(a, b)
		@a, @b = a, b
	end

	#-----------------------------------------------------------------------------
	# * Compute image
	#-----------------------------------------------------------------------------
	def [](x)
		return @a * x + @b
	end
	
	#-----------------------------------------------------------------------------
	# * Display function
	#-----------------------------------------------------------------------------
	def to_s
		s = "f(x) = #{@a}x"
		s += " + #{@b}" unless @b == 0
		return s
	end
	
	#-----------------------------------------------------------------------------
	# * Check for equality
	#-----------------------------------------------------------------------------
	def ==(function)
		# Return false if other function is not affine
		if not function.is_a?(Function_Affine)
			return false
		end
		# Return true if all parameters are equal
		if @a == function.a and @b == function.b
			return true
		end
		# In any other cases, return false
		return false
	end
	
	#-----------------------------------------------------------------------------
	# * Compute intersection point with another affine function
	#-----------------------------------------------------------------------------
	def inter(function)
		# Return nil if other function is not affine
		if not function.is_a?(Function_Affine)
			return nil
		end
		return (function.b - @b).to_f / (@a - function.a)
	end
	
	#-----------------------------------------------------------------------------
	# * Compute solution
	#-----------------------------------------------------------------------------
	def solve(y = 0)
		return (y - @b).to_f / @a
	end

	#-----------------------------------------------------------------------------
	# * Compute derivative
	#-----------------------------------------------------------------------------
	def derive
		# Return a new Function_Constant function
		return Function_Constant.new(@a)
	end
end

#==============================================================================
# ** Function_Trinome
#------------------------------------------------------------------------------
#  This class handles 2nd degree polynomial functions (type y = ax² + bx + c)
#==============================================================================
class Function_Trinome
	attr_reader	:a
	attr_reader	:b
	attr_reader	:c

	#-----------------------------------------------------------------------------
	# * Initialize parameters
	#-----------------------------------------------------------------------------
	def initialize(a, b, c)
		@a, @b, @c = a, b, c
	end
	
	#-----------------------------------------------------------------------------
	# * Compute image
	#-----------------------------------------------------------------------------
	def [](x)
		return @a * x ** 2 + @b * x + @c
	end

	#-----------------------------------------------------------------------------
	# * Display function
	#-----------------------------------------------------------------------------
	def to_s
		s = "f(x) = #{@a}x^2"
		s += " + #{@b}x" unless @b == 0
		s += " + #{@c}" unless @c == 0
		return s
	end
	
	#-----------------------------------------------------------------------------
	# * Check for equality
	#-----------------------------------------------------------------------------
	def ==(function)
		# Return false if other function is not a trinome
		if not function.is_a?(Function_Trinome)
			return false
		end
		# Return true if all parameters are equal
		if @a == function.a and @b == function.b and @c == function.c
			return true
		end
		# Return false in any other cases
		return false
	end
	
	#-----------------------------------------------------------------------------
	# * Comput delta
	#-----------------------------------------------------------------------------
	def delta
		return @b ** 2 - 4 * @a * @c
	end
	
	#-----------------------------------------------------------------------------
	# * Compute solutions
	#-----------------------------------------------------------------------------
	def solve(y = 0)
		if y != 0
			return Function_Trinome.new(@a, @b, @c - y).solve
		end
		# Compute delta
		d = delta
		# If positive delta, return two solutions
		if d > 0
			x1 = (-@b - Math::sqrt(d)).to_f / (2 * @a)
			x2 = (-@b + Math::sqrt(d)).to_f / (2 * @a)
			return x1, x2
		# If null delta, return one solution
		elsif d == 0
			x = -@b.to_f / (2 * @a)
			return x
		end
		# If negative delta, return nil
		return nil
	end
	
	#-----------------------------------------------------------------------------
	# * Compute derivative
	#-----------------------------------------------------------------------------
	def derive
		# Return a new affine function
		return Function_Affine.new(2 * @a, @b)
	end
end

#==============================================================================
# ** Function_Polynome
#------------------------------------------------------------------------------
#  This class handles polynomial functions of any arbitrary degree
#==============================================================================
class Function_Polynome
	attr_reader	:coeffs
	
	class << self
    #---------------------------------------------------------------------------
    # * Return an object of a more specific Function class if appropriate
    #---------------------------------------------------------------------------
		alias old_new new
		def new(*coeffs)
			while coeffs.last == 0
				coeffs.pop
			end
			case coeffs.size
			when 0
				return Function_Constant.new(0)
			when 1
				return Function_Constant.new(coeffs[0])
			when 2
				return Function_Affine.new(coeffs[1], coeffs[0])
			when 3
				return Function_Trinome.new(coeffs[2], coeffs[1], coeffs[0])
			end
			return old_new(*coeffs)
		end
	end

	#-----------------------------------------------------------------------------
	# * Initialize parameters
	#-----------------------------------------------------------------------------
	def initialize(*coeffs)
		coeffs.flatten! if coeffs[0].is_a?(Array)
		while coeffs.last == 0
			coeffs.pop
		end
		@coeffs = coeffs
	end

	#-----------------------------------------------------------------------------
	# * Compute image
	#-----------------------------------------------------------------------------
	def [](x)
		i = 0
		self.each { |n, coeff| i += coeff * x ** n }
		return i
	end

	#-----------------------------------------------------------------------------
	# * Display function
	#-----------------------------------------------------------------------------
	def to_s
		s = "f(x) = "
		a = []
		self.each { |n, coeff|
			next if coeff == 0
			a.push(case n
				when 0
					coeff.to_s
				when 1
					"#{coeff}x"
				else
					"#{coeff}x^#{n}"
				end
			)
		}
		s += a.join(" + ")
		return s
	end
	
	def degree
		return @coeffs.size - 1
	end
	
	def each
		for i in 0...@coeffs.size
			yield i, @coeffs[i]
		end
	end
  
  def derive
    coeffs = []
    for i in 1..@coeffs.size
      coeffs.push(i * @coeffs[i])
    end
    return Function_Polynome.new(*coeffs)
  end
end

class Function_Composite
  def initialize(data)
    @data = data
  end
  
  def [](x)
    function = function_at(x)
		if function.nil?
			return nil
		end
		return function[x]
  end
	
	def function_at(x)
    @data.each do |range, function|
      if range.include?(x)
        return function
      end
    end
	end
end

class Function_Sinusoide
	attr_reader	:period
	attr_reader	:amplitude

	def initialize(period = 1, amplitude = 1)
		@period = 2 * Math::PI / period
		@amplitude = amplitude
	end
	
	def [](t)
		return Math::sin(period * t) * amplitude
	end
end