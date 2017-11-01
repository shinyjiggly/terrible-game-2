# ▼▲▼ XRXS_MeLT. プラグインC3 : マップネームヘッダー ▼▲▼
#
#
#==============================================================================
# Window_MenuMapName
#==============================================================================
class Window_MenuMapName < Window_Base
  #
  # ヘッダーピクチャ (Windowskin)
  #
  HEADER = "MenuHeader"
  #
  # 縁取り色
  #
  HEMCOLOR = Color.new(96,96,0,255)
  #--------------------------------------------------------------------------
  # --- ウィンドウスライディングを搭載 ---
  #--------------------------------------------------------------------------
  include XRXS_WindowSliding
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    #
    @header = Sprite.new
    @header.bitmap = RPG::Cache.windowskin(HEADER)
    @header.y = -32
    @header.z = 102
    @header.opacity = 0
    #
    super(0, -48, 256, 64)
    @slide_x_speed = 0
    @slide_y_speed = 8
    @slide_objects.push(@header)
    self.opacity = 0
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.color = normal_color
    self.contents.font.size = 21
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュと解放
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_hemming_text(0, 0, 224, 32, $game_map.name, 1, HEMCOLOR)
  end
  def dispose
    @header.dispose
    super
  end
end
#==============================================================================
# --- メニューレイアウト 拡張定義 ---
#==============================================================================
class Scene_Menu
  alias xrxs_melt_pi3_make_windows make_windows
  def make_windows
    xrxs_melt_pi3_make_windows
    @windows.push(Window_MenuMapName.new)
  end
end
#==============================================================================
# □ XRXS. マップ名取得機構
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ○ マップ名を取得
  #--------------------------------------------------------------------------
  def name
    $data_mapinfos = load_data("Data/MapInfos.rxdata") if $data_mapinfos.nil?
    $data_mapinfos[@map_id].name
  end
end
