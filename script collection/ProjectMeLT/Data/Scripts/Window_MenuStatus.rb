# ▼▲▼ XRXS_MeLT. プラグインB2 : シャープハンターズ ▼▲▼
#
#
#==============================================================================
# カスタマイズポイント
#==============================================================================
module XRXS_MeLT
  # 背景画像 (Titles)
  BG_TITLE = "MenuBack"
  #
  # 各種ファイル名 (Windowskins)
  #
  NUM_SKIN_L = "NumberL"
  NUM_SKIN_S = "NumberS"
  HP         = "HP"
  SP         = "SP"
  HPBAR      = "MenuHPBar"
  SPBAR      = "MenuSPBar"
  STATUS_BACK= "MenuStatusBack"
  # ステートID=>アイコン名 関連付けハッシュ
  STATE_ICON = {3=>"skill_024",5=>"skill_027",7=>"skill_026",8=>"skill_025"}
  #
  # アクターID => シャープフェイス ファイル名 ハッシュ (Battlers)
  #
  ACTOR_FACE = {5=>"fd1", 6=>"fd2", 7=>"fd3", 8=>"fd4", 9=>"fd5"}
end
#==============================================================================
# ■ Window_MenuStatus [再定義]
#==============================================================================
class Window_MenuStatus < Window_Selectable
  # ステータスバー描画座標
  EACH_X_OFFSET =  0 # 各行毎の横ずれ
  EVEN_X_OFFSET =  0 # 偶数行の横ずれ
  # 名前部分 描画色
  NAMECOLOR = Color.new( 32, 48, 64,255)
  # 名前部分 縁取り色
  HEMCOLOR  = Color.new(128,192,256,255)
  #--------------------------------------------------------------------------
  # --- ウィンドウスライディングを搭載 ---
  #--------------------------------------------------------------------------
  include XRXS_WindowSliding
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(192 + 32, 96, 464, 384)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    @slide_x_speed = -8
    refresh
    self.active = false
    self.index = -1
    @column_max = 1
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      draw_menustatus(i)
    end
  end
  #--------------------------------------------------------------------------
  # ○ メニューステータスの描写
  #--------------------------------------------------------------------------
  def draw_menustatus(i)
    # アクターの取得
    actor = $game_party.actors[i]
    #
    x = i * EACH_X_OFFSET + i % 2 * EVEN_X_OFFSET
    y = i * 48 + 4
    back = RPG::Cache.windowskin(XRXS_MeLT::STATUS_BACK)
    self.contents.blt(x, y, back, back.rect)
    facefile = XRXS_MeLT::ACTOR_FACE[actor.id]
    if facefile != nil
      face = RPG::Cache.battler(facefile, 0)
      opacity = actor.dead? ? 96 : 255
      self.contents.blt(x, y + 4, face, face.rect, opacity)
    end
    #
    num_skin_l = RPG::Cache.windowskin(XRXS_MeLT::NUM_SKIN_L)
    num_skin_s = RPG::Cache.windowskin(XRXS_MeLT::NUM_SKIN_S)
    hp_bitmap  = RPG::Cache.windowskin(XRXS_MeLT::HP)
    sp_bitmap  = RPG::Cache.windowskin(XRXS_MeLT::SP)
    hpbar_skin = RPG::Cache.windowskin(XRXS_MeLT::HPBAR)
    spbar_skin = RPG::Cache.windowskin(XRXS_MeLT::SPBAR)
    #
    self.contents.font.color = NAMECOLOR
    self.contents.font.size  = 14
    self.contents.draw_hemming_text(x + 160, y + 4, 96, 18, actor.name, 0, HEMCOLOR)
    #
    state_icon_names = []
    for state_id in actor.states.sort
      icon_name = XRXS_MeLT::STATE_ICON[state_id]
      if icon_name != nil
        state_icon_names.push(icon_name)
      end
    end
    if state_icon_names.empty?
      self.contents.font.color = Color.new(0,48,96,255)
      self.contents.font.size  = 14
      self.contents.draw_text(x + 160, y + 22, 76, 24, "Lv." + actor.level.to_s, 2)
    else
      ix = x + 160
      for icon_name in state_icon_names
        icon = RPG::Cache.icon(icon_name)
        self.contents.blt(ix, y + 22, icon, icon.rect)
        ix += 24
      end
    end
    #
    self.contents.blt_number(x +  272, y +  6, num_skin_l, actor.hp)
    self.contents.blt_number(x +  288, y + 26, num_skin_s, actor.sp)
    self.contents.blt(       x +  256, y + 14, hp_bitmap, hp_bitmap.rect)
    self.contents.blt(       x +  256, y + 30, sp_bitmap, sp_bitmap.rect)
    # HP バーの描画
    h = 10
    rect = Rect.new(0,0,96,h)
    self.contents.blt(x + 330, y + 14, hpbar_skin, rect)
    rect.y     = (actor.hp == actor.maxhp ? 2 * h : h)
    rect.width = 96 * actor.hp / actor.maxhp
    self.contents.blt(x + 330, y + 14, hpbar_skin, rect)
    # SP バーの描画
    h = 8
    rect = Rect.new(0,0,96,h)
    self.contents.blt(x + 330, y + 28, spbar_skin, rect)
    rect.y     = (actor.sp == actor.maxsp ? 2 * h : h)
    rect.width = 96 * actor.sp / actor.maxsp
    self.contents.blt(x + 330, y + 28, spbar_skin, rect)
  end
  #--------------------------------------------------------------------------
  # ● カーソルの矩形更新
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, @index * 48 + 8, 200, 40)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 解放とスライドアウト
  #--------------------------------------------------------------------------
  def slideout!
    self.index = -1
    super
  end
end
#==============================================================================
# --- メニューレイアウト 拡張定義 ---
#==============================================================================
class Scene_Menu
  #--------------------------------------------------------------------------
  # ○ ウィンドウの作成
  #--------------------------------------------------------------------------
  def make_windows
    @bg_sprite = Spriteset_Map.new
    sprite = Sprite.new
    sprite.bitmap = RPG::Cache.title(XRXS_MeLT::BG_TITLE)
    sprite.z = 1
    sprite.opacity = 160
    @sprites.push(sprite)
  end
  def dispose_windows
    @bg_sprite.dispose
  end
end
