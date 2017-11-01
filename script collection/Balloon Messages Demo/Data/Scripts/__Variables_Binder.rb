module Variables_Binder
	class << self
		def init_binder
			system = load_data("Data/System.rxdata")
			@variables = system.variables
			@switches = system.switches
			@sw_counter = Hash.new(0)
			@var_counter = Hash.new(0)
			@need_save = false
		end

		def bind_sw(tag, const_name, name = "")
			@sw_counter[tag] += 1
			if tag.nil?
				tag_name = ""
			else
				tag_name = tag + "%02d" % @sw_counter[tag] + ":"
			end
			bind_from(@switches, const_name, tag_name, name)
		end
		
		def bind_var(tag, const_name, name = "")
			@var_counter[tag] += 1
			if tag.nil?
				tag_name = ""
			else
				tag_name = tag + "%02d" % @var_counter[tag] + ":"
			end
			bind_from(@variables, const_name, tag_name, name)
		end
		
		def bind_from(array, const_name, tag_name, name)
			begin
				unless tag_name.empty?
					# tag_name = tag + "%02d" % @counter[tag] + ":"
					r = Regexp.new(tag_name + "(.+)")
					for i in 1...array.size
						s = array[i]
						# Item found from tag	
						if s =~ r
							# print "Item #{name} found from tag"
							const_set(const_name, i)
							return
						end
					end
				end
				for i in 1...array.size
					s = array[i]
					# Item found from name
					if s == name
						# print "Item #{name} found from name"
						@need_save = true
						array[i] = tag_name + name
						const_set(const_name, i)
						return
					end
				end
				# If item could not be found, create it in first empty slot
				for i in 1...array.size
					s = array[i]
					if s.empty?
						# print "Item #{name} not found"
						@need_save = true
						array[i] = tag_name + name
						const_set(const_name, i)
						return
					end
				end
			rescue => exception
				print ([exception.inspect] + exception.backtrace).join("\n")
				exit
			end
		end
	
		def close_binder
			return unless @need_save
			system = load_data("Data/System.rxdata")
			system.variables.replace(@variables)
			system.switches.replace(@switches)
			f = File.open("Data/System.rxdata", 'wb')
			Marshal.dump(system, f)
			f.close
		end
	end
end

class Object
  include Variables_Binder
end
Variables_Binder.init_binder