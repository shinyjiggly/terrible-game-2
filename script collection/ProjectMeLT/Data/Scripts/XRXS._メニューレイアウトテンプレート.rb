# ▼▲▼ XRXS. メニューレイアウトテンプレート ▼▲▼
# by 桜雅 在土
#
#==============================================================================
# カスタマイズポイント
#==============================================================================
module XRXS_MeLT
  #
  # メニューコマンド　シーン/文字
  #
  COMMANDS = [
    Scene_Item,
    Scene_Skill,
    Scene_Equip,
    Scene_Status,
    Scene_MonsterBook, 
    Scene_Save,
    Scene_End
  ]
  CAPTIONS = [
    "アイテム",
    "スキル",
    "装備",
    "ステータス",
    "魔物図鑑",
    "セーブ",
    "ゲーム終了"
  ]
  # アクター選択を用いるシーン
  ACTOR_INDEX_ADAPTED = [Scene_Skill, Scene_Equip, Scene_Status]
  #
  # カーソルファイル名 (Windowskin)
  #
  CURSOR_SKIN = "MenuCursor"
end
#==============================================================================
# --- XRXS. ウィンドウスライディング機構 ---
#==============================================================================
module XRXS_WindowSliding
  def initialize(x, y, w, h)
    super(x, y, w, h)
    self.contents_opacity = 0
    @slidein_count  = 4
    @slideout_count = 0
    @slide_x_speed = 8
    @slide_y_speed = 0
    @slide_x_limit = nil
    @slide_objects = [self]
  end
  def update
    super
    if @slidein_count > 0
      @slidein_count -= 1
      for object in @slide_objects
        object.x += @slide_x_speed
        object.y += @slide_y_speed
        object.x = [object.x, @slide_x_limit].min if @slide_x_limit != nil
        case object
        when Window
          object.contents_opacity += 64
        when Sprite
          object.opacity += 64
        end
      end
    elsif @slideout_count > 0
      @slideout_count -= 1
      for object in @slide_objects
        object.x -= @slide_x_speed
        object.y -= @slide_y_speed
        case object
        when Window
          object.contents_opacity -= 64
        when Sprite
          object.opacity -= 64
        end
      end
    end
  end
  def slideout!
    @slidein_count  = 0
    @slideout_count = 4
  end
end
#==============================================================================
# ■ Scene_Menu
#==============================================================================
class Scene_Menu
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    # コマンドウィンドウを作成
    @command_window = Window_MenuCommand.new
    @command_window.index = @menu_index
    # セーブ禁止の場合
    if $game_system.save_disabled
      # セーブを無効にする
      @command_window.disable_item(4)
    end
    # ステータスウィンドウを作成
    @status_window = Window_MenuStatus.new
    # 初期化
    @slideout_count= 0
    @next_scene_actor_index = nil
    # カーソルの作成
    @cursor = Sprite.new
    @cursor.bitmap = RPG::Cache.windowskin(XRXS_MeLT::CURSOR_SKIN)
    @cursor.ox = @cursor.bitmap.rect.width - 20
    @cursor.oy = @cursor.bitmap.rect.height / 2 - 16
    @cursor.x  = -64
    @cursor.y  =  64
    @cursor.z  = 205
    @sprites = []
    @sprites.push(@cursor)
    # ウィンドウを作成
    @windows = []
    @windows.push(@command_window)
    @windows.push(@status_window)
    make_windows
    # トランジション実行
    Graphics.transition
    # メインループ
    loop do
      # ゲーム画面を更新
      Graphics.update
      # 入力情報を更新
      Input.update
      # フレーム更新
      update
      # 画面が切り替わったらループを中断
      if $scene != self
        break
      end
    end
    # トランジション準備
    Graphics.freeze
    # ウィンドウを解放
    @windows.each{|window| window.dispose }
    @sprites.each{|sprite| sprite.dispose }
    dispose_windows
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウの作成 [拡張で定義]
  #--------------------------------------------------------------------------
  def make_windows
  end
  def dispose_windows
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # ウィンドウを更新
    @windows.each{|window| window.update }
    # アクティブなウィンドウを検索
    active_window = nil
    for window in @windows
      if window.active
        active_window = window
        break
      end
    end
    # カーソル位置の更新
    @cursor.visible = (active_window != nil)
    if active_window != nil
      cursor_dx = active_window.x + active_window.cursor_rect.x
      cursor_dy = active_window.y + active_window.cursor_rect.y + active_window.cursor_rect.height / 2
      distance_x = (cursor_dx - @cursor.x)
      distance_y = (cursor_dy - @cursor.y)
      speed = 24
      if distance_x.abs <= speed
        @cursor.x = cursor_dx
      else
        sign = (distance_x >= 0 ? 1 : -1)
        @cursor.x += speed * sign
      end
      if distance_y.abs <= speed
        @cursor.y = cursor_dy
      else
        sign = (distance_y >= 0 ? 1 : -1)
        @cursor.y += speed * sign
      end
      @cursor.visible = false if active_window.index == -1
    end
    # スライドアウト
    if @slideout_count > 0
      @slideout_count -= 1
      # 画面を切り替え
      if @slideout_count == 0
        if @next_scene_actor_index == nil
          $scene = @slideout_next_scene.new
        else
          $scene = @slideout_next_scene.new(@next_scene_actor_index)
        end
      end
      return
    end
    # コマンドウィンドウがアクティブの場合: update_command を呼ぶ
    if @command_window.active
      update_command
      return
    end
    # ステータスウィンドウがアクティブの場合: update_status を呼ぶ
    if @status_window.active
      update_status
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (コマンドウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_command
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # 
      @windows.each{|window| window.slideout! }
      @slideout_count = 8
      @slideout_next_scene = Scene_Map
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # パーティ人数が 0 人で、セーブ、ゲーム終了以外のコマンドの場合
      if $game_party.actors.size == 0 and @command_window.index < 4
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      scene = XRXS_MeLT::COMMANDS[@command_window.index]
      # セーブ禁止の場合
      if scene == Scene_Save and $game_system.save_disabled
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 
      if XRXS_MeLT::ACTOR_INDEX_ADAPTED.include?(scene)
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        # ステータスウィンドウをアクティブにする
        @command_window.active = false
        @command_window.decide!
        @status_window.active = true
        @status_window.index = 0
      elsif scene != nil
        # 決定  SE を演奏
        $game_system.se_play($data_system.decision_se)
        # 画面を切り替え
        @windows.each{|window| window.slideout! }
        @slideout_count = 8
        @slideout_next_scene = scene
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ステータスウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_status
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # コマンドウィンドウをアクティブにする
      @command_window.active = true
      @command_window.cancel!
      @status_window.active = false
      @status_window.index = -1
      @next_scene_actor_index = nil
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      #
      scene = XRXS_MeLT::COMMANDS[@command_window.index]
      # このアクターの行動制限が 2 以上の場合
      if scene == Scene_Skill and $game_party.actors[@status_window.index].restriction >= 2
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      @next_scene_actor_index = @status_window.index
      # 決定  SE を演奏
      $game_system.se_play($data_system.decision_se)
      # 画面を切り替え
      @windows.each{|window| window.slideout! }
      @slideout_count = 8
      @slideout_next_scene = scene
      return
    end
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
