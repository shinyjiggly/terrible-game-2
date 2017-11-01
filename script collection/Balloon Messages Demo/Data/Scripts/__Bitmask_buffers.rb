#==============================================================================
# BITMASK
#------------------------------------------------------------------------------
#  This class stores boolean information (true/false) as Integer bits, in
# order to save memory.
#==============================================================================

class Bitmask
  attr_reader :size
  
  def initialize(size = 1)
    @data = [0]
    resize(size)
  end
  
  def [](i)
    if i >= @size
      raise RangeError, "Bit ##{i} not defined (max = #{@size - 1}) in Bitmask#[]"
    end
    return @data[i >> 5][i % 32] == 1
  end
  
  def []=(i, b)
    case b
    when TrueClass, FalseClass
      if self[i] == b
        return nil
      else
        @data[i >> 5] ^= 2 ** (i % 32)
        return b
      end
    else
      raise TypeError, "TrueClass or FalseClass expected as parameters in Bitmask#[]="
    end
  end
	
  def &(other)
    bitmask = Bitmask.new(@size)
    for i in 0...@size
      bitmask[i] = self[i] & other[i]
    end
    return bitmask
  end
  
  def |(other)
    bitmask = Bitmask.new(@size)
    for i in 0...@size
      bitmask[i] = self[i] | other[i]
    end
    return bitmask
  end
  
  def each
    for i in 0...@size
      yield i if self[i]
    end
  end

	def each_false
    for i in 0...@size
      unless self[i]
        yield i
      end
    end
  end
  
  def resize(size)
    while (size >> 5) >= @data.size
      @data << 0
    end
    @size = size
  end
  
  def to_s
    str = String.new
    for i in 0...@size
      if i & 7 == 0
        str << " "
      end
      str << @data[i >> 5][i & 31].to_s
    end
    return str
  end
	
  def ==(other)
    case other
    when Bitmask
      #return true if @data == other.data
      return false unless @size == other.size
      for i in 0...@size
        return false unless self[i] == other[i]
      end
      return true
    end
    return false
  end
  
  alias :inspect :to_s
end

#==============================================================================
# BUFFERS
#------------------------------------------------------------------------------
#  This sets variables and switches to serve as buffers and hold temporary
# information.
#==============================================================================

# Retrieve the buffer variable
def temp
  return $game_variables[VAR_TEMP]
end

# Set the buffer variable
def set_temp(v)
  $game_variables[VAR_TEMP] = v
  return $game_variables[VAR_TEMP]
end

# Retrieve the buffer switch
def sw_temp
  return $game_switches[SW_TEMP]
end

# Set the buffer switch
def set_sw_temp(v)
  $game_switches[SW_TEMP] = v
  return $game_switches[SW_TEMP]
end