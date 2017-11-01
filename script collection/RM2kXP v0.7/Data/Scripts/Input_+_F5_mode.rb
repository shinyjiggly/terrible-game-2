module Input
  DOWN=2
  LEFT=4
  RIGHT=6
  UP=8
  A=11
  B=12
  C=13
  X=14
  Y=15
  Z=16
  L=17
  R=18
  SHIFT=21
  CTRL=22
  ALT=23
  F4=24
  F5=25
  F6=26
  F7=27
  F8=28
  F9=29
  @GetKeyState=Win32API.new("user32", "GetAsyncKeyState", "i", "i")
  
  def self.getstate(key)
    return (@GetKeyState.call(key)&0x8000)>0
  end
  
  def self.update
    if @keystate
      for i in 0...256
        @newstate=self.getstate(i)
        @triggerstate[i]=(@newstate&&@keystate[i]==0)
        @releasestate[i]=(!@newstate&&@keystate[i]>0)
        @keystate[i]=@newstate ? @keystate[i]+1 : 0
      end    
    else
      @keystate=[]
      @triggerstate=[]
      @releasestate=[]
      for i in 0...256
        @keystate[i]=self.getstate(i) ? 1 : 0
        @triggerstate[i]=false
        @releasestate[i]=false
      end
    end
  end
  
  def self.buttonToKey(button)
   case button # Teclas
    when Input::DOWN
     return [0x28] # Abajo
    when Input::LEFT
     return [0x25] # Izquierda
    when Input::RIGHT
     return [0x27] # Derecha
    when Input::UP
     return [0x26] # Arriba
    when Input::A
     return [0x5A,0x10] # Z, Shift
    when Input::B
     return [0x58,0x1B] # X, ESC 
    when Input::C
     return [0x43,0x0d,0x20] # C, ENTER, Espacio
    when Input::X
     return [0x41] # A
    when Input::Y
     return [0x53] # S
    when Input::Z
     return [0x44] # D
    when Input::L
     return [0x51,0x21] # Q, RePág
    when Input::R
     return [0x57,0x22] # W, AvPág
    when Input::SHIFT
     return [0x10] # Shift
    when Input::CTRL
     return [0x11] # Ctrl
    when Input::ALT
     return [0x12] # Alt
    when Input::F4 
     return [0x73] # F4
    when Input::F5
     return [0x74] # F5
    when Input::F6
     return [0x75] # F6
    when Input::F7
     return [0x76] # F7
    when Input::F8
     return [0x77] # F8
    when Input::F9
     return [0x78] # F9
    else
     return []
   end
  end
 
  def self.dir4
   button=0
   repeatcount=0
   if self.press?(Input::DOWN) && self.press?(Input::UP)
     return 0
   end
   if self.press?(Input::LEFT) && self.press?(Input::RIGHT)
     return 0
   end
   if $game_switches[26] == true
     return 0
   end

   for b in [Input::DOWN,Input::LEFT,Input::RIGHT,Input::UP]
    rc=self.count(b)
    if rc>0
     if repeatcount==0 || rc<repeatcount
      button=b
      repeatcount=rc
     end
    end
   end
   return button
  end
 
  def self.dir8
   buttons=[]
   for b in [Input::DOWN,Input::LEFT,Input::RIGHT,Input::UP]
    rc=self.count(b)
    if rc>0
     buttons.push([b,rc])
    end
   end
   if buttons.length==0
    return 0
   elsif buttons.length==1
    return buttons[0][0]
   elsif buttons.length==2
    if (buttons[0][0]==Input::DOWN && buttons[1][0]==Input::UP)
     return 0
    end
    if (buttons[0][0]==Input::LEFT && buttons[1][0]==Input::RIGHT)
     return 0
    end
   end
   buttons.sort!{|a,b| a[1]<=>b[1]}
   updown=0
   leftright=0
   for b in buttons
    if updown==0 && (b[0]==Input::UP || b[0]==Input::DOWN)
     updown=b[0]
    end
    if leftright==0 && (b[0]==Input::LEFT || b[0]==Input::RIGHT)
     leftright=b[0]
    end
   end
   if updown==Input::DOWN
    return 1 if leftright==Input::LEFT
    return 3 if leftright==Input::RIGHT
    return 2
   elsif updown==Input::UP
    return 7 if leftright==Input::LEFT
    return 9 if leftright==Input::RIGHT
    return 8
   else
    return 4 if leftright==Input::LEFT
    return 6 if leftright==Input::RIGHT
    return 0
   end
  end
  def self.count(button)
   for btn in self.buttonToKey(button)
     c=self.repeatcount(btn)
     return c if c>0
   end
   return 0
  end 
  def self.trigger?(button)
   return self.buttonToKey(button).any? {|item| self.triggerex?(item) }
  end
   def self.triggerex?(key)
    return false if !@triggerstate
    return @triggerstate[key]
  end

  def self.repeat?(button)
   return self.buttonToKey(button).any? {|item| self.repeatex?(item) }
  end
   def self.repeatex?(key)
    return false if !@keystate
    return @keystate[key]==1 || (@keystate[key]>5 && (@keystate[key]&3)==0)
  end

  def self.press?(button) 
    return self.count(button)>0
  end
  def self.pressex?(key)
    return self.repeatcount(key)>0
  end

  def self.release?(button)
    return self.buttonToKey(button).any? {|item| self.releaseex?(item) }
  end 

  def self.releaseex?(key)
    return false if !@releasestate
    return @releasestate[key]
  end
  
  def self.repeatcount(key)
    return 0 if !@keystate
    return @keystate[key]
  end
end

#------------------------------------------------------------------------------
# F5 mode (Edit by Wecoc)
# Original script by Zeus81
#------------------------------------------------------------------------------

class << Graphics
  CreateWindowEx            = Win32API.new('user32'  , 'CreateWindowEx'     , 'ippiiiiiiiii', 'i')
  GetClientRect             = Win32API.new('user32'  , 'GetClientRect'      , 'ip'          , 'i')
  GetDC                     = Win32API.new('user32'  , 'GetDC'              , 'i'           , 'i')
  GetSystemMetrics          = Win32API.new('user32'  , 'GetSystemMetrics'   , 'i'           , 'i')
  GetWindowRect             = Win32API.new('user32'  , 'GetWindowRect'      , 'ip'          , 'i')
  FillRect                  = Win32API.new('user32'  , 'FillRect'           , 'ipi'         , 'i')
  FindWindow                = Win32API.new('user32'  , 'FindWindow'         , 'pp'          , 'i')
  ReleaseDC                 = Win32API.new('user32'  , 'ReleaseDC'          , 'ii'          , 'i')
  SetWindowLong             = Win32API.new('user32'  , 'SetWindowLong'      , 'iii'         , 'i')
  SetWindowPos              = Win32API.new('user32'  , 'SetWindowPos'       , 'iiiiiii'     , 'i')
  ShowWindow                = Win32API.new('user32'  , 'ShowWindow'         , 'ii'          , 'i')
  SystemParametersInfo      = Win32API.new('user32'  , 'SystemParametersInfo', 'iipi'       , 'i')
  UpdateWindow              = Win32API.new('user32'  , 'UpdateWindow'       , 'i'           , 'i')
  CreateSolidBrush          = Win32API.new('gdi32'   , 'CreateSolidBrush'   , 'i'           , 'i')
  DeleteObject              = Win32API.new('gdi32'   , 'DeleteObject'       , 'i'           , 'i')
 
  HWND     = FindWindow.call('RGSS Player', 0)
  BackHWND = CreateWindowEx.call(0x08000008, 'Static', '', 0x80000000, 0, 0, 0, 0, 0, 0, 0, 0)
  
  alias rm2kxp_f5_update update unless $@
  def initialize_fullscreen
    @fullscreen = false
  end
  
private

  def initialize_rects
    @borders_size    ||= borders_size
    @fullscreen_rect ||= fullscreen_rect
    @workarea_rect   ||= workarea_rect
  end
  
  def borders_size
    GetWindowRect.call(HWND, wrect = [0, 0, 0, 0].pack('l4'))
    GetClientRect.call(HWND, crect = [0, 0, 0, 0].pack('l4'))
    wrect, crect = wrect.unpack('l4'), crect.unpack('l4')
    Rect.new(0, 0, wrect[2]-wrect[0]-crect[2], wrect[3]-wrect[1]-crect[3])
  end
  
  def fullscreen_rect
    Rect.new(0, 0, GetSystemMetrics.call(0), GetSystemMetrics.call(1))
  end
  
  def workarea_rect
    SystemParametersInfo.call(0x30, 0, rect = [0, 0, 0, 0].pack('l4'), 0)
    rect = rect.unpack('l4')
    Rect.new(rect[0], rect[1]+2, rect[2]-rect[0], rect[3]-rect[1])
  end
  
  def hide_borders
    SetWindowLong.call(HWND, -16, 0x14000000)
  end
  
  def show_borders
    SetWindowLong.call(HWND, -16, 0x14CA0000)
  end
  
  def hide_back
    ShowWindow.call(BackHWND, 0)
  end
  
  def show_back
    ShowWindow.call(BackHWND, 3)
    UpdateWindow.call(BackHWND)
    dc    = GetDC.call(BackHWND)
    rect  = [0, 0, @fullscreen_rect.width, @fullscreen_rect.height].pack('l4')
    brush = CreateSolidBrush.call(0)
    FillRect.call(dc, rect, brush)
    ReleaseDC.call(BackHWND, dc)
    DeleteObject.call(brush)
  end
  
  def resize_window(w, h)
    screen = @fullscreen ? @fullscreen_rect : @workarea_rect
    x, y = screen.x+(screen.width-w)/2, screen.y+(screen.height-h)/2
    SetWindowPos.call(HWND, @fullscreen ? -1 : -2, x, y, w, h, 0)
  end
  
public

  def fullscreen?
    @fullscreen
  end
  
  def toggle_fullscreen
    fullscreen? ? windowed_mode : fullscreen_mode
  end
  
  def fullscreen_mode
    initialize_rects
    @fullscreen = true
    if @fullscreen_ratio == 0
      w_max, h_max = @fullscreen_rect.width, @fullscreen_rect.height
      w, h = w_max, w_max * 640 / 480
      h, w = h_max, h_max * 640 / 480 if h > h_max
    else
      w, h = 640, 480
    end
    show_back
    hide_borders
    resize_window(w, h)
  end
  
  def windowed_mode
    initialize_rects
    @fullscreen = false
    if @windowed_ratio == 0
      w_max = @workarea_rect.width  - @borders_size.width
      h_max = @workarea_rect.height - @borders_size.height
      w, h = w_max, w_max * 480 / 640
      h, w = h_max, h_max * 640 / 480 if h > h_max
    else
      w, h = 640, 480
    end
    hide_back
    show_borders
    resize_window(w + @borders_size.width, h + @borders_size.height)
  end
  
  def update
    rm2kxp_f5_update
    if Input.trigger?(Input::F5)
      toggle_fullscreen
    end
  end
end