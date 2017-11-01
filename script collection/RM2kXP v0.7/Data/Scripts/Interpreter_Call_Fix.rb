#==============================================================================
# Interpreter Script Call Fix
#==============================================================================

class Interpreter
  SCRIPT_WAIT_RESULTS = [:wait, FalseClass]
  #-------------------------------------------------------------------
  # * Script
  #-------------------------------------------------------------------
  def command_355
    # Set first line to script
    script = @list[@index].parameters[0] + "\n"
    # Store index in case we need to wait.
    current_index = @index
    # Loop
    loop do
      # If next event command is second line of script or after
      if @list[@index+1].code == 655
        # Add second line or after to script
        script += @list[@index+1].parameters[0] + "\n"
      # If event command is not second line or after
      else
        # Abort loop
        break
      end
      # Advance index
      @index += 1
    end
    # Evaluation
    result = eval(script)
    # If return value is false
    if SCRIPT_WAIT_RESULTS.include?(result)
      # Set index back (If multi-line script call)
      @index = current_index
      # End and wait
      return false
    end
    # Continue
    return true
  end
end