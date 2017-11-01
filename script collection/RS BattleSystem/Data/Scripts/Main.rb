#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  After defining each class, actual processing begins here.
#==============================================================================

begin
  # Prepare for transition
  Graphics.freeze
  Font.default_name=["Arial"]
  Font.default_size=20
  # Make scene object (title screen)
  $scene = Scene_Title.new
  # Call main method as long as $scene is effective
  while $scene != nil
    $scene.main
  end
  # Fade out
  Graphics.transition(20)
rescue Errno::ENOENT
  # Supplement Errno::ENOENT exception
  # If unable to open file, display message and end
  filename = $!.message.sub("No se encontó el archivo o directorio - ", "")
  print("Error RGSS: #{filename}")
end