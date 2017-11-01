#==============================================================================
# Main
#==============================================================================

begin
  unless $DEBUG
    $showm = Win32API.new 'user32', 'keybd_event', %w(l l l l), ''
    $showm.call(115,0,0,0) # F4
    $showm.call(115,0,2,0) # F4
  end
  $defaultname = 'Arial'#'PF Westa Seven Condensed'
  $defaultsize = 25
  Graphics.freeze
  $scene = Scene_Title.new
  while $scene != nil
    $scene.main
  end
  Graphics.transition(20)
rescue Errno::ENOENT
  filename = $!.message.sub("Not found - ", "")
  print("Error RGSS: #{filename}")
end