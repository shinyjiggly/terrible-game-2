# ▼▲▼ XRXS_MeLT. プラグインC2 : プレイタイムクロック ▼▲▼
#
#
#==============================================================================
# メニューレイアウトプラグイン「　Window_MenuPlayTime　」
#==============================================================================
class Window_MenuPlayTime < Window_Base
  #
  # タイム表示 ファイル名 (Windowskins)
  #
  TIMESET = "TimeSet"
  #
  # 位置 (0:左寄せ, 2:右寄せ)
  #
  ALIGN = 2
  #--------------------------------------------------------------------------
  # --- ウィンドウスライディングを搭載 ---
  #--------------------------------------------------------------------------
  include XRXS_WindowSliding
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @skin   = RPG::Cache.windowskin(TIMESET)
    @skin_w = @skin.width / 12
    w = 32 + @skin_w * 9
    h = 32 + @skin.height
    x = (ALIGN == 2 ? 664 - w : -32)
    y = 428
    super(x, y, w, h)
    @slide_x_speed = (1 - ALIGN) * 8
    self.opacity = 0
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュと更新
  #--------------------------------------------------------------------------
  def refresh
    # 準備
    self.contents.clear
    rect = Rect.new(0, 0, @skin_w, @skin.height)
    @total_sec = Graphics.frame_count / Graphics.frame_rate
    n = @total_sec / 60 / 60
    hour1 = n / 10
    hour2 = n % 10
    n = @total_sec / 60 % 60
    min1 = n / 10
    min2 = n % 10
    n = @total_sec % 60
    sec1 = n / 10
    sec2 = n % 10
    plan = [11, hour1, hour2,10,min1,min2,10,sec1,sec2]
    # 描画
    x = 0
    for ox in plan
      rect.x = @skin_w * ox
      self.contents.blt(x, 0, @skin, rect)
      x += @skin_w
    end
  end
  def update
    super
    if Graphics.frame_count / Graphics.frame_rate != @total_sec
      refresh
    end
  end
end
#==============================================================================
# --- メニューレイアウト 拡張定義 ---
#==============================================================================
class Scene_Menu
  alias xrxs_melt_pi2_make_windows make_windows
  def make_windows
    xrxs_melt_pi2_make_windows
    @windows.push(Window_MenuPlayTime.new)
  end
end
