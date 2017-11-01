#==============================================================================
#  ** RSC Require
#------------------------------------------------------------------------------
#  Version 1.4.0
#  ? Yeyinde, 2007
#------------------------------------------------------------------------------
#  Usage: require('My_RSCFile') or rsc_require('My_RSCFile')
#==============================================================================

#-----------------------------------------------------------------------------
#  * Aliasing
#-----------------------------------------------------------------------------
if @rsc_original_require.nil?
  alias rsc_original_require require
  @rsc_original_require = true
end
#-----------------------------------------------------------------------------
#  * require
#       file : the file to load, rsc files will be handled in it's own method
#-----------------------------------------------------------------------------
def require(file)
  begin
    rsc_original_require file
  rescue LoadError
    rsc_require file
  end
end
#-----------------------------------------------------------------------------
#  * rsc_require
#           file : the RSC file which will be loaded. The .rsc extension may
#                   be ommited
#-----------------------------------------------------------------------------
def rsc_require(file)
  # Create error object
  load_error = LoadError.new("No such file to load -- #{file}")
  # Tack on the extension if the argument does not already include it.
  file += '.rsc' unless file.split('.')[-1] == 'rsc'
  # Iterate over all require directories
  $:.each do |dir|
    # Make the rout-to-file
    filename = dir + '/' + file
    # If load was successful
    if load_rsc(filename)
      # Load was successful
      return true
    end
  end
  # Raise the error if there was no file to load
  raise load_error
end
#-----------------------------------------------------------------------------
#  * load_rsc
#    file_name : the file to be evaluated
#-----------------------------------------------------------------------------
def load_rsc(file_name)
  file_name = file_name[2..file_name.length] if file_name[0..1] == './'
  # If the file exists and so does the encypted archive
  if File.exists?(file_name) && File.exists?('Game.rgssad')
    raise RSCSecurityError.new("Potential security breach:
#{File.basename(file_name)} is a real file")
  end
  # Start a begin-rescue block
  begin
    # Load the data from the file
    script_data = load_data(file_name)
    # Iterate over each data entry in the array
    script_data.each_with_index do |data|
      # Store the script name
      script_name = data[0][0]
      # Store the script data after inflating it
      script = Zlib::Inflate.inflate(data[0][1])
      # Start a begin-rescue block
      begin
        # Evaluate the script data
        eval(script)
      # If there is an error with the script
      rescue Exception => error
        # Remove the (eval): from the start of the message
        error.message.gsub!('(eval):', '')
        # Get the line number
        line = error.message.sub(/:[\w \W]+/) {$1}
        # Get the error details
        message = error.message.sub(/\d+:in `load_rsc'/) {''}
        # Print the error and details
        print "File '#{file_name}' script '#{script_name}' line #{line}: #{error.type} occured.

#{message}"

        # Exit with value 1 (standard error)
        exit 1
      end
    end
    # Load was a success
    return true
  # No file to load
  rescue Errno::ENOENT
    # Load was a failure
    return false
  end
end
#==============================================================================
#  ** RSCSecurityError
#==============================================================================
class RSCSecurityError < StandardError; end


# Insert Game.exe's base folder into require array
$: << '.' unless $:.include?('.')
# Remove all nil objects
$:.compact!