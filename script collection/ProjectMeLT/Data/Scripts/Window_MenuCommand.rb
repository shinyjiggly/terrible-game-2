# ▼▲▼ XRXS_MeLT. プラグインA1 : コマンドストリーム ▼▲▼
#
#
#==============================================================================
# □ Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # --- ウィンドウスライディングを搭載 ---
  #--------------------------------------------------------------------------
  include XRXS_WindowSliding
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @sprites = []
    max = XRXS_MeLT::COMMANDS.size
    super(16, 64, 160, max * 32 + 32)
    self.opacity = 0
    self.index   = 0
    @item_max    = max
    @column_max  = 1
    @slide_objects = @sprites
    @slide_x_limit = 16
    @slidein_count  = 4 + @item_max
    @slideout_count = 0
    w = 160
    h =  32
    z = 101
    x = self.x - 32
    y = self.y + 16
    color = Color.new(0,48,96,255)
    for caption in XRXS_MeLT::CAPTIONS
      sprite = Sprite.new
      sprite.bitmap = Bitmap.new(w,h)
      sprite.bitmap.draw_hemming_text(0,0,w,h,caption,1,color)
      sprite.opacity = 0
      sprite.z = z
      sprite.x = x
      sprite.y = y
      x -=  8
      y += 32
      @sprites.push(sprite)
    end
    self.z = z + 1
  end
  #--------------------------------------------------------------------------
  # ○ 解放とスライドアウト
  #--------------------------------------------------------------------------
  def dispose
    @sprites.each{|sprite| sprite.dispose }
    super
  end
  def slideout!
    self.index = -1
    super
  end
  #--------------------------------------------------------------------------
  # ○ 決定とキャンセル
  #--------------------------------------------------------------------------
  def decide!
    @decision_index = self.index
    @sprites.each{|sprite| sprite.opacity =  96 }
    @sprites[@decision_index].opacity = 255
  end
  def cancel!
    @decision_index = nil
    @sprites.each{|sprite| sprite.opacity = 255 }
  end
end

#==============================================================================
# □ Bitmapライブラリ □ 
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # ○ 縁文字の描画
  #--------------------------------------------------------------------------
  def draw_hemming_text(x, y, w, h, text, align = 0, black_color = Color.new(0,0,0,255))
    original_color = self.font.color.dup
    self.font.color = black_color
    self.draw_text(x  , y  , w, h, text, align)
    self.draw_text(x  , y+2, w, h, text, align)
    self.draw_text(x+2, y+2, w, h, text, align)
    self.draw_text(x+2, y  , w, h, text, align)
    self.font.color = original_color
    self.draw_text(x+1, y+1, w, h, text, align)
  end
end
