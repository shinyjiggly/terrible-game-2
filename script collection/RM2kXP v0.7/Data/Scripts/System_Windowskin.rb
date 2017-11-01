#==============================================================================
# ** System Windowskin (based on Poccil's Window module)
#==============================================================================

# System cache support
# (System equals to Windowskin by default but you can change the folder here)

module RPG
  module Cache
    def self.system(filename)
      self.load_bitmap("Graphics/Windowskins/", filename)
    end
  end
end

# Game_System Double Window

class Game_System
  # New accessor double_window makes the borders of the windows 2x sized.
  attr_accessor :double_window
  alias rm2kxp_doublewindow initialize unless $@
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    rm2kxp_doublewindow
    @double_window = true
  end
end

#==============================================================================
# ** WindowCursorRect
#==============================================================================

class WindowCursorRect < Rect
  attr_reader :x,:y,:width,:height
  #--------------------------------------------------------------------------
  # * Initialize Cursor Rect
  #--------------------------------------------------------------------------
  def initialize(window)
    @window = window
    @x = 0
    @y = 0
    @width = 0
    @height = 0
  end
  #--------------------------------------------------------------------------
  # * Empty
  #--------------------------------------------------------------------------
  def empty
    set(0,0,0,0)
  end
  #--------------------------------------------------------------------------
  # * Check if empty
  #--------------------------------------------------------------------------
  def isEmpty?
    return @x == 0 && @y == 0 && @width == 0 && @height == 0
  end
  #--------------------------------------------------------------------------
  # * Set Cursor Coordinates
  #--------------------------------------------------------------------------
  def set(x,y,width,height)
    needupdate = @x != x || @y != y || @width != width || @height != height
    if needupdate
      @x=x
      @y=y
      @width=width
      @height=height
      @window.priv_ref
    end
  end
  #--------------------------------------------------------------------------
  # * Set Cursor x
  #--------------------------------------------------------------------------
  def x=(value)
    if @x != value
      @x = value
      @window.priv_ref
    end
  end
  #--------------------------------------------------------------------------
  # * Set Cursor y
  #--------------------------------------------------------------------------
  def y=(value) 
    if @y != value
      @y = value
      @window.priv_ref
    end
  end
  #--------------------------------------------------------------------------
  # * Set Cursor width
  #--------------------------------------------------------------------------
  def width=(value)
    if @width != value
      @width = value
      @window.priv_ref
    end
  end
  #--------------------------------------------------------------------------
  # * Set Cursor height
  #--------------------------------------------------------------------------
  def height=(value)
    if @height != value
      @height = value
      @window.priv_ref
    end
  end
end


#==============================================================================
# ** Window
#==============================================================================

class Window
  attr_reader :tone
  attr_reader :color
  attr_reader :blend_type
  attr_reader :contents_blend_type
  attr_reader :viewport
  attr_reader :contents
  attr_reader :ox
  attr_reader :oy
  attr_reader :x
  attr_reader :y
  attr_reader :z
  attr_reader :width
  attr_reader :height
  attr_reader :active
  attr_reader :opacity
  attr_reader :back_opacity
  attr_reader :contents_opacity
  attr_reader :visible
  attr_reader :cursor_rect
  attr_reader :openness
  attr_reader :stretch
  #--------------------------------------------------------------------------
  # * Initialize Window
  #--------------------------------------------------------------------------
  def initialize(viewport=nil)
    # Define Sprite types
    @sprites={}
    @spritekeys=[
      "back",
      "corner0","side0","scroll0",
      "corner1","side1","scroll1",
      "corner2","side2","scroll2",
      "corner3","side3","scroll3",
      "cursor","contents"
    ]
    # Side Bitmaps
    @sidebitmaps=[nil,nil,nil,nil]
    # Cursor Bitmap
    @cursorbitmap=nil
    # Background Bitmap
    @bgbitmap=nil
    # Viewport
    @viewport=viewport
    # Define Sprites
    for i in @spritekeys
      @sprites[i]=Sprite.new(@viewport)
    end
    @disposed=false
    # Default Tone & Color
    @tone=Tone.new(0,0,0,0)
    @color=Color.new(0,0,0,0)
    # Contents
    @blankcontents=Bitmap.new(1,1)
    @contents=@blankcontents
    # Windowskin
    @_windowskin=nil
    # Coordinates
    @x=0
    @y=0
    @width=0
    @height=0
    @ox=0
    @oy=0
    @z=0
    # Openness set to max (it's never used so always equals 255)
    @openness=255
    # Background is stretched
    @stretch=true
    # Window's visibility 
    @visible=true
    # Cursor blink status
    @active=true
    # Normal blend type
    @blend_type=0
    @contents_blend_type=0
    # Opacity
    @opacity=255
    @back_opacity=255
    @contents_opacity=255
    # Cursor rect features
    @cursor_rect=WindowCursorRect.new(self)
    @cursorblink=0
    @cursoropacity=255
    @cursorcount=0
    # Private Refresh
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    if !self.disposed?
      # Dispose all sprites
      for i in @sprites
        i[1].dispose if i[1]
        @sprites[i[0]]=nil
      end
      for i in 0...@sidebitmaps.length
        @sidebitmaps[i].dispose if @sidebitmaps[i]
        @sidebitmaps[i]=nil
      end
      @blankcontents.dispose
      @cursorbitmap.dispose if @cursorbitmap
      @backbitmap.dispose if @backbitmap
      @sprites.clear
      @sidebitmaps.clear
      @_windowskin=nil
      @_contents=nil
      @disposed=true
    end
  end
  #--------------------------------------------------------------------------
  # * Check if disposed
  #--------------------------------------------------------------------------
  def disposed?
    return @disposed
  end
  #--------------------------------------------------------------------------
  # * Return Windowskin
  #--------------------------------------------------------------------------
  def windowskin
    @_windowskin
  end
  #--------------------------------------------------------------------------
  # * Private Refresh Shortcut
  #--------------------------------------------------------------------------
  def priv_ref
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Viewport
  #--------------------------------------------------------------------------
  def viewport=(value)
    @viewport=value
    for i in @spritekeys
      @sprites[i].dispose
      if @sprites[i].is_a?(Sprite)
        @sprites[i]=Sprite.new(@viewport)
      elsif @sprites[i].is_a?(Plane)
        @sprites[i]=Plane.new(@viewport)
      else
        @sprites[i]=nil
      end
    end
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Openness
  #--------------------------------------------------------------------------
  def openness=(value)
    @openness=value
    @openness=0 if @openness<0
    @openness=255 if @openness>255
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Stretch
  #--------------------------------------------------------------------------
  def stretch=(value)
    @stretch=value
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Visible
  #--------------------------------------------------------------------------
  def visible=(value)
    @visible=value
    privRefresh
  end

  #--------------------------------------------------------------------------
  # * Contents
  #--------------------------------------------------------------------------
  def contents=(value)
    @contents=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Windowskin
  #--------------------------------------------------------------------------
  def windowskin=(value)
    @_windowskin=value
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * OX coordinate
  #--------------------------------------------------------------------------
  def ox=(value)
    @ox=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * OY Coordinate
  #--------------------------------------------------------------------------
  def oy=(value)
    @oy=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * X coordinate
  #--------------------------------------------------------------------------
  def x=(value)
    @x=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Y coordinate
  #--------------------------------------------------------------------------
  def y=(value)
    @y=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Z coordinate
  #--------------------------------------------------------------------------
  def z=(value)
    @z=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Width
  #--------------------------------------------------------------------------
  def width=(value)
    @width=value
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Height
  #--------------------------------------------------------------------------
  def height=(value)
    @height=value
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Active
  #--------------------------------------------------------------------------
  def active=(value)
    @active=value
    privRefresh(true)
  end
  #--------------------------------------------------------------------------
  # * Cursor Rect
  #--------------------------------------------------------------------------
  def cursor_rect=(value)
    if !value
      @cursor_rect.empty
    else
      @cursor_rect.set(value.x,value.y,value.width,value.height)
    end
  end
  #--------------------------------------------------------------------------
  # * Window Opacity
  #--------------------------------------------------------------------------
  def opacity=(value)
    @opacity=value
    @opacity=0 if @opacity<0
    @opacity=255 if @opacity>255
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Window Background Opacity
  #--------------------------------------------------------------------------
  def back_opacity=(value)
    @back_opacity=value
    @back_opacity=0 if @back_opacity<0
    @back_opacity=255 if @back_opacity>255
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Contents Opacity
  #--------------------------------------------------------------------------
  def contents_opacity=(value)
    @contents_opacity=value
    @contents_opacity=0 if @contents_opacity<0
    @contents_opacity=255 if @contents_opacity>255
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Tone
  #--------------------------------------------------------------------------
  def tone=(value)
    @tone=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Color
  #--------------------------------------------------------------------------
  def color=(value)
    @color=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Blend Type
  #--------------------------------------------------------------------------
  def blend_type=(value)
    @blend_type=value
    privRefresh
  end
  #--------------------------------------------------------------------------
  # * Flash
  #--------------------------------------------------------------------------
  def flash(color,duration)
    return if disposed?
    for i in @sprites
      i[1].flash(color,duration)
    end
  end

  
  
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    return if disposed?
    mustchange=true
    if @active
      # Update Cursor
      @cursoropacity=255
      if @cursorblink==0
    
        @cursorcount+=1
        if @cursorcount==4
          @cursorblink=1
        end
        
        # Cursor Graphic 1
        
        @side1 = Rect.new(64+8, 0+0, 16, 16)
        @side2 = Rect.new(64+0, 0+8, 16, 16)
        @side3 = Rect.new(64+16, 0+8, 16, 16)
        @side4 = Rect.new(64+8, 0+16, 16, 16)
        @corner1 = Rect.new(64+0, 0+0, 16, 16)
        @corner2 = Rect.new(64+16, 0+0, 16, 16)
        @corner3 = Rect.new(64+0, 0+16, 16, 16)
        @corner4 = Rect.new(64+16, 0+16, 16, 16)
        @back = Rect.new(64+16, 0+16, 1, 1)
       
      else
        @cursorcount-=1
        if @cursorcount==0
          @cursorblink=0
        end

        # Cursor Graphic 2
        
        @side1 = Rect.new(96+8, 0+0, 16, 16)
        @side2 = Rect.new(96+0, 0+8, 16, 16)
        @side3 = Rect.new(96+16, 0+8, 16, 16)
        @side4 = Rect.new(96+8, 0+16, 16, 16)
        @corner1 = Rect.new(96+0, 0+0, 16, 16)
        @corner2 = Rect.new(96+16, 0+0, 16, 16)
        @corner3 = Rect.new(96+0, 0+16, 16, 16)
        @corner4 = Rect.new(96+16, 0+16, 16, 16)
        @back = Rect.new(96+16, 0+16, 1, 1)   
      end
      mustchange=true if !@cursor_rect.isEmpty?
    else # If not active
      
      # Cursor Graphic 1
      
      mustchange=true if @cursoropacity!=128
      @cursorcount = 0
      @cursoropacity = 255
     
      @side1 = Rect.new(64+8, 0+0, 16, 16)
      @side2 = Rect.new(64+0, 0+8, 16, 16)
      @side3 = Rect.new(64+16, 0+8, 16, 16)
      @side4 = Rect.new(64+8, 0+16, 16, 16)
      @corner1 = Rect.new(64+0, 0+0, 16, 16)
      @corner2 = Rect.new(64+16, 0+0, 16, 16)
      @corner3 = Rect.new(64+0, 0+16, 16, 16)
      @corner4 = Rect.new(64+16, 0+16, 16, 16)
      @back = Rect.new(64+16, 0+16, 1, 1)   
    end
 
    # Draw the cursor parts 
    
    width=@cursor_rect.width
    height=@cursor_rect.height
    margin=16
    fullmargin=32

    @cursorbitmap = ensureBitmap(@cursorbitmap, width, height)
    @cursorbitmap.clear
    @sprites["cursor"].bitmap=@cursorbitmap
    @sprites["cursor"].src_rect.set(0,0,width,height)
    
    # CURSOR BACK
    
    rect = Rect.new(margin,margin,
                    width - fullmargin, height - fullmargin)
    @cursorbitmap.stretch_blt(rect, @_windowskin, @back)
  
    # CURSOR CORNER1 (up left)
    
    @cursorbitmap.blt(0, 0, @_windowskin, @corner1)
    
    # CURSOR CORNER2 (up right)
    
    if @cursor_rect.width < 32
      @cursorbitmap.fill_rect(width-margin, 0, width-margin, height-margin,
                              Color.new(0,0,0,0))
    end
  
    @cursorbitmap.blt(width-margin, 0, @_windowskin, @corner2)
    
    # CURSOR CORNER3 (down left)
    
    if @cursor_rect.height < 32
      @cursorbitmap.fill_rect(0, height-margin, width-margin, height-margin,
                              Color.new(0,0,0,0))
    end
  
    @cursorbitmap.blt(0, height-margin, @_windowskin, @corner3)
    
    # CURSOR CORNER4 (down right)
    
    if @cursor_rect.width < 32
      @cursorbitmap.fill_rect(width-margin, height-margin,width-margin,height-margin,
                              Color.new(0,0,0,0))
    end
    if @cursor_rect.height < 32
      @cursorbitmap.fill_rect(width-margin, height-margin,width-margin,height-margin,
                              Color.new(0,0,0,0))
    end
  
    @cursorbitmap.blt(width-margin, height-margin, @_windowskin, @corner4)
    
    # CURSOR SIDE1 (up)
    
    rect = Rect.new(margin, 0,
                    width - fullmargin, margin)
    @cursorbitmap.stretch_blt(rect, @_windowskin, @side1)
    
    # CURSOR SIDE2 (left)
    
    rect = Rect.new(0, margin,
                    margin, height - fullmargin)
    @cursorbitmap.stretch_blt(rect, @_windowskin, @side2)
    
    # CURSOR SIDE3 (right)
    
    if @cursor_rect.width < 32
      @cursorbitmap.fill_rect(width-margin,margin,margin,height-fullmargin,
                              Color.new(0,0,0,0))
    end
    
    rect = Rect.new(width - margin, margin,
                    margin, height - fullmargin)
    @cursorbitmap.stretch_blt(rect, @_windowskin, @side3)
  
    # CURSOR SIDE4 (down)
    
    if @cursor_rect.height < 32
      @cursorbitmap.fill_rect(margin,height-margin,width-fullmargin,margin,
                              Color.new(0,0,0,0))
    end
    
    rect = Rect.new(margin, height-margin,
                    width - fullmargin, margin)
    @cursorbitmap.stretch_blt(rect, @_windowskin, @side4)
  
    # Private Refresh
    privRefresh if mustchange
    for i in @sprites
      i[1].update
    end
  end
  
  private
  
  # Ensure Bitmap
  def ensureBitmap(bitmap,dwidth,dheight)
    if !bitmap||bitmap.disposed?||bitmap.width<dwidth||bitmap.height<dheight
      bitmap.dispose if bitmap
      bitmap=Bitmap.new([1,dwidth].max,[1,dheight].max)
    end
    return bitmap
  end
  
  # Tile Bitmap
  def tileBitmap(dstbitmap,dstrect,srcbitmap,srcrect)
    return if !srcbitmap || srcbitmap.disposed?
    left=dstrect.x
    top=dstrect.y
    y=0;loop do break unless y<dstrect.height
      x=0;loop do break unless x<dstrect.width
        dstbitmap.blt(x+left,y+top,srcbitmap,srcrect)
        x+=srcrect.width
      end
      y+=srcrect.height
    end
  end
  
  # Private Refresh
  def privRefresh(changeBitmap=false)
    return if self.disposed?
    # Get opacity
    backopac=self.back_opacity*self.opacity/255
    contopac=self.contents_opacity
    cursoropac=@cursoropacity*contopac/255
    # Draw all the Window parts
    for i in 0...4
      @sprites["corner#{i}"].bitmap=@_windowskin
      @sprites["scroll#{i}"].bitmap=@_windowskin
    end
    @sprites["contents"].bitmap=@contents
    if @_windowskin && !@_windowskin.disposed?
      for i in 0...4
        @sprites["corner#{i}"].opacity=@opacity
        @sprites["corner#{i}"].tone=@tone
        @sprites["corner#{i}"].color=@color
        @sprites["corner#{i}"].blend_type=@blend_type
        @sprites["corner#{i}"].visible=@visible
        @sprites["side#{i}"].opacity=@opacity
        @sprites["side#{i}"].tone=@tone
        @sprites["side#{i}"].color=@color
        @sprites["side#{i}"].blend_type=@blend_type
        @sprites["side#{i}"].visible=@visible
        @sprites["scroll#{i}"].opacity=@opacity
        @sprites["scroll#{i}"].tone=@tone
        @sprites["scroll#{i}"].blend_type=@blend_type
        @sprites["scroll#{i}"].color=@color
        @sprites["scroll#{i}"].visible=@visible
      end
      for i in ["back","cursor","contents"]
        @sprites[i].color=@color
        @sprites[i].tone=@tone
        @sprites[i].blend_type=@blend_type
      end
      @sprites["contents"].blend_type=@contents_blend_type
      @sprites["back"].opacity=backopac
      @sprites["contents"].opacity=contopac
      @sprites["cursor"].opacity=cursoropac
      @sprites["back"].visible=@visible
      @sprites["contents"].visible=@visible && @openness==255
      @sprites["cursor"].visible=@visible && @openness==255
      hascontents=(@contents && !@contents.disposed?)
      @sprites["scroll0"].visible = @visible && hascontents && @oy > 0
      @sprites["scroll1"].visible = @visible && hascontents && @ox > 0
      @sprites["scroll2"].visible = @visible && hascontents && (@contents.width - @ox) > @width-32
      @sprites["scroll3"].visible = @visible && hascontents && (@contents.height - @oy) > @height-32
    else
      for i in 0...4
        @sprites["corner#{i}"].visible=false
        @sprites["side#{i}"].visible=false
        @sprites["scroll#{i}"].visible=false
      end
      @sprites["contents"].visible=@visible && @openness==255
      @sprites["contents"].color=@color
      @sprites["contents"].tone=@tone
      @sprites["contents"].blend_type=@contents_blend_type
      @sprites["contents"].opacity=contopac
      @sprites["back"].visible=false
      @sprites["cursor"].visible=false
    end
    for i in @sprites
      i[1].z=@z
    end
  
    @sprites["cursor"].z=@z+1
    @sprites["contents"].z=@z+2
    trimX=32
    trimY=0
    backRect=Rect.new(0,0,32,32)
    blindsRect=nil

    #  @sprites["back"].src_rect.set(0,0,640,480)
    
    @sprites["corner0"].src_rect.set(trimX,trimY+0,8,8);
    @sprites["corner1"].src_rect.set(trimX+24,trimY+0,8,8);
    @sprites["corner2"].src_rect.set(trimX,trimY+24,8,8);
    @sprites["corner3"].src_rect.set(trimX+24,trimY+24,8,8);
    
    @sprites["scroll0"].src_rect.set(trimX+8, trimY+8, 16, 8) # up
    @sprites["scroll3"].src_rect.set(trimX+8, trimY+16, 16, 8) # down
    @sprites["scroll1"].src_rect.set(trimX+8, trimY+12, 0, 0) # left
    @sprites["scroll2"].src_rect.set(trimX+20, trimY+12, 0, 0) # right

    sideRects=[
      Rect.new(trimX+8,trimY+0,16,8),
      Rect.new(trimX,trimY+8,8,16),
      Rect.new(trimX+24,trimY+8,8,16),
      Rect.new(trimX+8,trimY+24,16,8)
    ]

    if @width>16 && @height>16
      @sprites["contents"].src_rect.set(@ox,@oy,@width-16,@height-32)
    else
      @sprites["contents"].src_rect.set(0,0,0,0)
    end

    @sprites["contents"].x=@x+16
    @sprites["contents"].y=@y+16

    # Double Window
    
    if $game_system.double_window == false
      @sprites["corner0"].x=@x
      @sprites["corner0"].y=@y
      @sprites["corner1"].x=@x+@width-8
      @sprites["corner1"].y=@y
      @sprites["corner2"].x=@x
      @sprites["corner2"].y=@y+@height-8
      @sprites["corner3"].x=@x+@width-8
      @sprites["corner3"].y=@y+@height-8

      @sprites["side0"].x=@x+8
      @sprites["side0"].y=@y
      @sprites["side1"].x=@x
      @sprites["side1"].y=@y+8
      @sprites["side2"].x=@x+@width-8
      @sprites["side2"].y=@y+8
      @sprites["side3"].x=@x+8
      @sprites["side3"].y=@y+@height-8
    else
      @sprites["corner0"].x=@x
      @sprites["corner0"].y=@y
      @sprites["corner1"].x=@x+@width-16
      @sprites["corner1"].y=@y
      @sprites["corner2"].x=@x
      @sprites["corner2"].y=@y+@height-16
      @sprites["corner3"].x=@x+@width-16
      @sprites["corner3"].y=@y+@height-16

      @sprites["side0"].x=@x+8
      @sprites["side0"].y=@y
      @sprites["side1"].x=@x
      @sprites["side1"].y=@y+8
      @sprites["side2"].x=@x+@width-16
      @sprites["side2"].y=@y+8
      @sprites["side3"].x=@x+8
      @sprites["side3"].y=@y+@height-16

      @sprites["corner0"].zoom_x = 2.0
      @sprites["corner0"].zoom_y = 2.0
      @sprites["corner1"].zoom_x = 2.0
      @sprites["corner1"].zoom_y = 2.0
      @sprites["corner2"].zoom_x = 2.0
      @sprites["corner2"].zoom_y = 2.0
      @sprites["corner3"].zoom_x = 2.0
      @sprites["corner3"].zoom_y = 2.0
      @sprites["side0"].zoom_x = 1.0
      @sprites["side0"].zoom_y = 2.0
      @sprites["side1"].zoom_x = 2.0
      @sprites["side1"].zoom_y = 1.0
      @sprites["side2"].zoom_x = 2.0
      @sprites["side2"].zoom_y = 1.0
      @sprites["side3"].zoom_x = 1.0
      @sprites["side3"].zoom_y = 2.0
      @sprites["scroll0"].zoom_x = 2.0
      @sprites["scroll0"].zoom_y = 2.0
      @sprites["scroll1"].zoom_x = 2.0
      @sprites["scroll1"].zoom_y = 2.0  
      @sprites["scroll2"].zoom_x = 2.0
      @sprites["scroll2"].zoom_y = 2.0
      @sprites["scroll3"].zoom_x = 2.0
      @sprites["scroll3"].zoom_y = 2.0
    end

    @sprites["scroll0"].x = @x+@width / 2 - 8
    @sprites["scroll0"].y = @y+8
    @sprites["scroll1"].x = @x+8
    @sprites["scroll1"].y = @y+@height / 2 - 8
    @sprites["scroll2"].x = @x+@width - 16
    @sprites["scroll2"].y = @y+@height / 2 - 8
    @sprites["scroll3"].x = @x+@width / 2 - 8
    @sprites["scroll3"].y = @y+@height - 16
    @sprites["back"].x=@x+2
    @sprites["back"].y=@y+2
    @sprites["cursor"].x=@x+16+@cursor_rect.x
    @sprites["cursor"].y=@y+16+@cursor_rect.y
    
    if changeBitmap && @_windowskin && !@_windowskin.disposed?
      for i in 0..3
        dwidth=(i==0||i==3) ? @width-16 : 8
        dheight=(i==0||i==3) ? 8 : @height-16
        @sidebitmaps[i]=ensureBitmap(@sidebitmaps[i],dwidth,dheight)
        @sprites["side#{i}"].bitmap=@sidebitmaps[i]
        @sprites["side#{i}"].src_rect.set(0,0,dwidth,dheight)
        @sidebitmaps[i].clear
        if sideRects[i].width>0 && sideRects[i].height>0
          @sidebitmaps[i].stretch_blt(@sprites["side#{i}"].src_rect,
          @_windowskin,sideRects[i])
        end
      end
      backwidth=@width-4
      backheight=@height-4
      if backwidth>0 && backheight>0
        @backbitmap=ensureBitmap(@backbitmap,backwidth,backheight)
        @sprites["back"].bitmap=@backbitmap
        @sprites["back"].src_rect.set(0,0,backwidth,backheight)
        @backbitmap.clear
        if @stretch
          @backbitmap.stretch_blt(@sprites["back"].src_rect,@_windowskin,backRect)
        else
          tileBitmap(@backbitmap,@sprites["back"].src_rect,@_windowskin,backRect)
        end
        if blindsRect
          tileBitmap(@backbitmap,@sprites["back"].src_rect,@_windowskin,blindsRect)
        end
      else
        @sprites["back"].visible=false
        @sprites["back"].src_rect.set(0,0,0,0)
      end
    end
    if @openness!=255
      opn=@openness/255.0
      for k in @spritekeys
        sprite=@sprites[k]
        ratio=(@height<=0) ? 0 : (sprite.y-@y)*1.0/@height
        sprite.oy=0
        sprite.y=(@y+(@height/2.0)+(@height*ratio*opn)-(@height/2*opn)).floor
      end
    else
      for k in @spritekeys
        sprite=@sprites[k]
      end
    end
    i=0
    for k in @spritekeys
      sprite=@sprites[k]
      y=sprite.y
      sprite.y=i
      sprite.oy=(sprite.zoom_y<=0) ? 0 : (i-y)/sprite.zoom_y
    end
  end
end