class Font
  alias font_fix_initialize initialize unless $@
  def initialize
    font_fix_initialize
#    self.name = 'PF Westa Seven Condensed'
#    self.size = 25
    self.name = $defaultname # Defined on main
    self.size = $defaultsize
  end
end
