=begin

# ▼▲▼ XRXS_MeLT. プラグインC7 : ヴァリアブルD ▼▲▼
#
#
#==============================================================================
# Window_MenuVariable4
#==============================================================================
class Window_MenuVariable4 < Window_Base
  #
  # アイコンファイル名 (Icons)
  #
  ICON = "skill_024"
  #
  # 描画内容 変数ID
  #
  VARIABLE_ID = 14
  #
  # 縁取り色
  #
  HEMCOLOR = Color.new(96,48,0,255)
  #--------------------------------------------------------------------------
  # --- ウィンドウスライディングを搭載 ---
  #--------------------------------------------------------------------------
  include XRXS_WindowSliding
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(500, 436, 140, 56)
    @slide_x_speed = -8
    self.opacity = 0
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.color = normal_color
    self.contents.font.size = 21
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    icon = RPG::Cache.icon(ICON)
    self.contents.blt(0,0,icon,icon.rect)
    self.contents.draw_hemming_text(24, 0, 80, 24, $game_variables[VARIABLE_ID].to_s, 2, HEMCOLOR)
  end
end
#==============================================================================
# --- メニューレイアウト 拡張定義 ---
#==============================================================================
class Scene_Menu
  alias xrxs_melt_pi7_make_windows make_windows
  def make_windows
    xrxs_melt_pi7_make_windows
    @windows.push(Window_MenuVariable4.new)
  end
end

=end
