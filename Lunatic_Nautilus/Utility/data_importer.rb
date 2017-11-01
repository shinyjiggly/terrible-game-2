#===============================================================================
# Filename:    data_importer.rb
#
# Developer:   Raku (rakudayo@gmail.com)
#
# Description: This script imports the previously-exported plain text files back
#    into RMXP's .rxdata files.  This script requires the text files previously
#    exported by data_exporter.rb to generate the .rxdata files.
#
# Usage:       ruby data_importer.rb <project_directory>
#===============================================================================

require_relative 'rmxp/rgss'
require 'yaml'

require_relative 'common'

# Make sure RMXP isn't running
exit if check_for_rmxp

# Set up the directory paths
$INPUT_DIR  = $PROJECT_DIR + "/" + $YAML_DIR + '/'
$OUTPUT_DIR = $PROJECT_DIR + "/" + $RXDATA_DIR + '/'

print_separator(true)
puts "  RMXP Data Import"
print_separator(true)

# Check if the input directory exists
if not (File.exist? $INPUT_DIR and File.directory? $INPUT_DIR)
  puts "Input directory #{$INPUT_DIR} does not exist."
  puts "Nothing to import...skipping import."
  puts
  exit
end

# Create the output directory if it doesn't exist
if not (File.exist? $OUTPUT_DIR and File.directory? $OUTPUT_DIR)
  puts "Error: Output directory #{$OUTPUT_DIR} does not exist."
  puts "Hint: Check that the $RXDATA_DIR variable in paths.rb is set to the correct path."
  puts
  exit
end

# Create the list of rxdata files to export
files = Dir.entries( $INPUT_DIR )
files = files.select { |e| File.extname(e) == '.yaml' }
files.sort!

if files.empty?
  puts_verbose "No data files to import."
  puts_verbose
  exit
end

total_start_time = Time.now
total_load_time  = 0.0
total_dump_time  = 0.0

# For each yaml file, load it and dump the objects to rxdata file
files.each_index do |i|
  data = nil 
  
  # Load the data from yaml file
  start_time = Time.now
  File.open( $INPUT_DIR + files[i], "r+" ) do |yamlfile|
    data = YAML::load( yamlfile )
  end

  # Calculate the time to load the .yaml file
  load_time = Time.now - start_time
  total_load_time += load_time
  
  # Dump the data to .rxdata file
  start_time = Time.now
  File.open( $OUTPUT_DIR + File.basename(files[i], ".yaml") + ".rxdata", "w+" ) do |rxdatafile|
    Marshal.dump( data['root'], rxdatafile )
  end

  # Calculate the time to dump the .rxdata file
  dump_time = Time.now - start_time
  total_dump_time += dump_time
  
  # Update the user on the status
  str =  "Imported "
  str += "#{files[i]}".ljust(30)
  str += "(" + "#{i+1}".rjust(3, '0')
  str += "/"
  str += "#{files.size}".rjust(3, '0') + ")"
  str += "    #{load_time + dump_time} seconds"
  puts_verbose str
end

# Calculate the total elapsed time
total_elapsed_time = Time.now - total_start_time

# Report the times
print_separator
puts_verbose "YAML load time:   #{total_load_time} seconds."
puts_verbose "RXDATA dump time: #{total_dump_time} seconds."
puts_verbose "Total import time:  #{total_elapsed_time} seconds."
print_separator
puts_verbose
