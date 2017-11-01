$data_mapinfos = load_data("Data/MapInfos.rxdata")

module RPG
	class MapInfo
		def parents
			result = []
			mapinfo = self
			while mapinfo.parent_id != 0
				result.unshift(mapinfo.parent_id)
				mapinfo = $data_mapinfos[mapinfo.parent_id]
			end
			return result
		end
	end
end

class Bitmap
	alias mp_common_eql ==
	def ==(other)
		if other.is_a?(Bitmap)
			if self.width != other.width or self.height != other.height
				return false
			end
			for y in 0...height
				for x in 0...width
					if self.get_pixel(x, y) != other.get_pixel(x, y)
						return false
					end
				end
			end
			return true
		end
		return mp_common_eql(other)
	end
	
	def cut_out(other)
		for x in 0...self.width
			for y in 0...self.height
				if get_pixel(x, y) == other.get_pixel(x, y)
					self.set_pixel(x, y, Color::TRANSPARENT)
				end
			end
		end
	end
	
	def _dump
		a = []
		for y in 0...self.height
			for x in 0...self.width
				color = self.get_pixel(x, y)
				a << color.red << color.green << color.blue << color.alpha
			end
		end
		return [self.width, self.height].pack('II') + a.pack('C*')
	end
	
	def self._load(s)
		width = s.slice![0, 4].unpack('I')
		height = s.slice![0, 4].unpack('I')
		bitmap = Bitmap.new(width, height)
		color = Color.new(0, 0, 0)
		for y in 0...height
			for x in 0...width
				color.set(*s.slice![0, 4].unpack('CCCC'))
				bitmap.set_pixel(color)
			end
		end
		return bitmap
	end
end

class Color
	alias mp_common_eql ==
	def == (other)
		if other.is_a?(Color)
			if self.alpha == 0 and other.alpha == 0
				return true
			elsif self.red != other.red
				return false
			elsif self.blue != other.blue
				return false
			elsif self.green != other.green
				return false
			elsif self.alpha != other.alpha
				return false
			end
			return true
		end
		return mp_common_eql(other)
	end
	
	TRANSPARENT = Color.new(0, 0, 0, 0)
end


# ==============================================================================
# RUBY EXPANSION
# ------------------------------------------------------------------------------
# Adds new functions to existing Ruby classes. Each new feature is commented
# individually.
# ==============================================================================

class Object
	# Make all objects respond to :display for compatibility purposes
  alias :display :inspect
end

class Array
	# Cuts array in portions of n items
	def each_slice(n)
		for i in 0...self.size / n
			yield self[i * n, n]
		end
	end
	
	# Returns an item selected at random
  def sample
    return self[rand(self.size)]
  end
	
	# Return a copy with items shuffled
	def shuffle
		src = self.clone
		ary = Array.new()
		until src.empty?
			ary << src.delete(src.sample)
		end
		return ary
	end
	
	# Shuffle items
	def shuffle!
		self.replace(self.shuffle)
	end
end

class Dir
  # Returns all files matching given extensions in specified directory as an array
  #  - directory: directory to be searched
  #  - filters: strings representing extensions to be kept
  def self.files(directory = self.pwd, *filters)
    ary = []
    for filename in self.entries(directory)
      next if File.directory?(filename) or filename == "." or filename == ".."
      if filters.empty? or filters.include?(File.extname(filename))
        ary << filename
      end
    end
    return ary
  end
  
  # Returns all subdirectories in specified directory as an array
  def self.subdirectories(directory = self.pwd)
    ary = []
    for filename in self.entries(directory)
      if File.directory?(filename)
        ary << filename
      end
    end
    return ary
  end
end

class File
  # Assess whether a filename is a directory name or not
  def self.directory?(filename)
    return false if filename == "."
    return true if self.extname(filename) == ""
    return false
  end
	
	def copy(target_name)
		target = File.open(target_name, 'w+')
		target.write( self.read(64) ) while not self.eof?
		target.close
	end
end

class Integer
	# Computes self factorial
  def factorial
    f = 1
    for i in 1..self
      f *= i
    end
    return f
  end
  
	# Compute number of combinations from k in self
	#  - k: a positive integer less than or equal to self
  def combin(k)
    return self.factorial / (k.factorial * (n - k).factorial)
  end
end

class String
	# Breaks string into several lines
	#  - amount: max number of characters per line
  def break_into_lines(amount)
    if self.size <= amount
      yield self
    else
      i = 0
      until i >= self.size
        n = self[i, amount].reverse.index(" ")
        n = amount - (n.nil? ? 0 : n)
        yield self[i, n]
        i += n
      end
    end
  end
  
	# Make string into a symbol name
  def symbolize
    return :empty if self.empty?
    return self.downcase.gsub(" ", "_").to_sym
  end
	
	def split_for_display(width, bitmap)
		current_width = 0
		m = 0
		k = 0
		a = []
		loop do
			n = (self[m...self.size] =~ /[ -]/)
			if n.nil?
				a << self[k...self.size]
				return a
			end
			# say self[m, n + 1].inspect
			if ( (w = bitmap.text_size(self[m, n + 1]).width) + current_width > width)
				# say self[k...m].inspect
				a << self[k...m]
				k = m
				current_width = 0
			end
			current_width += w
			m += n + 1
		end
	end
end

class Symbol
	# Make symbol into a string ready fot display
  def display
    str = ""
    name = self.to_s
    name.split("_").each { |s| str += s.capitalize + " " }
    str = str.rstrip
    return str
  end
  
	# Comparison functions, included for compatiblity purposes
  def ===(other)
    return (self <=> other) == 0
  end

  def >(other)
    case other
    when Numeric
      return nil
    end
    return (self <=> other) == 1
  end

  def <(other)
    case other
    when Numeric
      return nil
    end
    return (self <=> other) == -1
  end
  
  def <=>(other)
    return self.to_s <=> other.to_s
  end
end