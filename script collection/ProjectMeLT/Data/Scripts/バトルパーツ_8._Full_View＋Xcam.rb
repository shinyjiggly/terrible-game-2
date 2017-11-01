# ▼▲▼ XRXS_BP 8. バトルバック・Full-View＋可動カメラ ver.2 ▼▲▼ built 221612
# by 桜雅 在土

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
module XRXS_BP8
  #
  # カメラ移動速度
  #  ( SPEED1 : 距離分割数。小さいほど早い
  #    SPEED2 : 最低移動速度[単位:px/F])
  #
  SPEED1 =  8
  SPEED2 =  5
  #
  # GAの横幅サイズを設定 ( 1024:XGAサイズ、640:VGAサイズ)
  #
  GA_W = 640
end
#------------------------------------------------------------------------------
# ▽ 可動カメラの動き設定
#------------------------------------------------------------------------------
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● パーティコマンドフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs_bp8_start_phase2 start_phase2
  def start_phase2
    # カメラ：センタリング
    $xcam.centering
    # 呼び戻す
    xrxs_bp8_start_phase2
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : エネミー選択)
  #--------------------------------------------------------------------------
  alias xrxs_bp8_update_phase3_enemy_select update_phase3_enemy_select
  def update_phase3_enemy_select
    # 現在選択中のエネミーを取得
    enemy = $game_troop.enemies[@enemy_arrow.index]
    # カメラ：注目
    if @last_enemy_arrow != enemy
      $xcam.watch(enemy)
      @last_enemy_arrow = enemy
    end
    # 戻す
    xrxs_bp8_update_phase3_enemy_select
  end
  #--------------------------------------------------------------------------
  # ● エネミー選択終了
  #--------------------------------------------------------------------------
  alias xrxs_bp8_end_enemy_select end_enemy_select
  def end_enemy_select
    # カメラ：センタリング
    $xcam.centering
    @last_enemy_arrow = nil
    # 呼び戻す
    xrxs_bp8_end_enemy_select
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 2 : アクション開始)
  #--------------------------------------------------------------------------
  alias xrxs_bp8_update_phase4_step2 update_phase4_step2
  def update_phase4_step2
    # 戻す
    xrxs_bp8_update_phase4_step2
    # ステップ 3 に移行する予定の場合
    if @phase4_step == 3
      # アクティブなバトラーがバトルフィールドに居る場合
      if @active_battler.in_battlefield?
        # カメラ：注目
        $xcam.watch(@active_battler)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 3 : 行動側アニメーション)
  #--------------------------------------------------------------------------
  alias xrxs_bp8_update_phase4_step3 update_phase4_step3
  def update_phase4_step3
    # 戻す
    xrxs_bp8_update_phase4_step3
    # カメラターゲットとなりうるターゲットの X 平均値を計算
    x_average  = 0
    number     = 0
    cam_target = nil
    for target in @target_battlers
      if target.in_battlefield?
        x_average += target.x
        number    += 1
        cam_target = target
      end
    end
    # カメラターゲットが見つかった場合
    if number > 0
      # もし対象アニメが「位置：画面」の場合
      animation = $data_animations[@animation2_id]
      if animation != nil and animation.position == 3
        # カメラ：センタリング
        $xcam.centering
        # カメラ：ズームアウト
        $xcam.zoomout
      elsif number == 1
        # カメラ：注目
        $xcam.watch(cam_target)
      else
        # カメラ：指定 X 位置を注目
        $xcam.watch_at(x_average / number)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アフターバトルフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs_bp8_start_phase5 start_phase5
  def start_phase5
    # カメラ：センタリング
    $xcam.centering
    # 呼び戻す
    xrxs_bp8_start_phase5
  end
end
#------------------------------------------------------------------------------
# カスタマイズポイントここまで
#==============================================================================

#------------------------------------------------------------------------------
#
#    ▽ 可動カメラ システム ▽
#
#==============================================================================
# □ XCam
#------------------------------------------------------------------------------
#   可動カメラを扱うクラスです。
#==============================================================================
class XCam
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :x
  attr_reader   :y
  attr_reader   :z
  attr_accessor :x_destination
  attr_accessor :y_destination
  attr_accessor :z_destination
  attr_accessor :watch_battler
  attr_accessor :freeze_count
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    # カメラ初期位置決定
    @x = 320
    @y = 240
    @z = 185
    # 最大範囲の計算
    @x_max = 0
    @y_max = 0
    @z_max = XRXS_BP8::GA_W * 37 / 128
    # Zの最大制限
    @z = @z_max if @z > @z_max
    # カメラ：センタリング
    self.centering
    # 初期化
    @freeze_count = 0
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新
  #--------------------------------------------------------------------------
  def update
    @moved = false
    # カメラ位置の更新
    if @freeze_count > 0
      # フリーズカウントを減らす
      @freeze_count -= 1
      return
    end
    # 座標取得
    z_dest = @z_destination
    x_dest = @watch_battler == nil ? @x_destination : @watch_battler.x
    y_dest = @watch_battler == nil ? @y_destination : 88 + @watch_battler.y/2
    # カメラ: Z 座標 (優先)
    if @z != z_dest
      @z     = slide(@z, z_dest, @z_speed, 37, @z_max)
      @x_max = (@z_max - @z) * 64 / 37
      @y_max = (@z_max - @z) * 48 / 37
      @moved = true
    end
    # カメラ: X 座標
    if @x != x_dest or @moved
      @x = slide(@x, x_dest, @x_speed, 320 - @x_max, 320 + @x_max)
      @moved = true
    end
    # カメラ: Y 座標
    if @y != y_dest or @moved
      @y = slide(@y, y_dest, @y_speed, 240 - @y_max, 240 + @y_max)
      @moved = true
    end
  end
  #--------------------------------------------------------------------------
  # ○ スライド (現在地・目的地から行くべき現在地を返す)
  #--------------------------------------------------------------------------
  def slide(from, to, move_speed, to_min, to_max)
    # 結果を判別
    if (to - from).abs < move_speed
      result = to 
    else
      sign   = from > to ? -1 : 1
      result = from + sign * move_speed
    end
    # 範囲によって返却
    return [[result, to_min].max, to_max].min
  end
  #--------------------------------------------------------------------------
  # ○ 動いたかどうか？
  #--------------------------------------------------------------------------
  def moved?
    return @moved
  end
  #--------------------------------------------------------------------------
  # ○ カメラ速度設定
  #--------------------------------------------------------------------------
  def set_speed
    x_dest = @watch_battler == nil ? @x_destination : @watch_battler.x
    y_dest = @watch_battler == nil ? @y_destination : 88 + @watch_battler.y/2
    z_dest = @z_destination
    @x_speed = [[(x_dest - @x).abs / XRXS_BP8::SPEED1, 1].max, XRXS_BP8::SPEED2].min
    @y_speed = [[(y_dest - @y).abs / XRXS_BP8::SPEED1, 1].max, XRXS_BP8::SPEED2].min
    @z_speed = [[(z_dest - @z).abs / XRXS_BP8::SPEED1, 1].max, XRXS_BP8::SPEED2].min
  end
  #--------------------------------------------------------------------------
  # ○ センタリング
  #--------------------------------------------------------------------------
  def centering
    @watch_battler = nil
    @x_destination = 320
    @y_destination = 240
    @z_destination = 185
    set_speed
  end
  #--------------------------------------------------------------------------
  # ○ ズームアウト
  #--------------------------------------------------------------------------
  def zoomout
    @z_destination = 222
    set_speed
  end
  #--------------------------------------------------------------------------
  # ○ バトラーを注目
  #--------------------------------------------------------------------------
  def watch(battler)
    @watch_battler = battler
    @z_destination = 166
    set_speed
  end
  #--------------------------------------------------------------------------
  # ○ 指定 X 位置を注目
  #--------------------------------------------------------------------------
  def watch_at(x)
    @watch_battler = nil
    @x_destination =   x
    @y_destination = 240
    @z_destination = 185
    set_speed
  end
  #--------------------------------------------------------------------------
  # ○ ズーム倍率の取得
  #--------------------------------------------------------------------------
  def zoom
    return 185.00 / self.z
  end
end
#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :x                        # バトルフィールド　横　位置(+が右　)
  attr_reader   :y                        # バトルフィールド 高さ 位置(+が下　)
  attr_reader   :z                        # バトルフィールド奥行き位置(+が手前)
  #--------------------------------------------------------------------------
  # ○ バトルフィールド上に居るか？
  #--------------------------------------------------------------------------
  def in_battlefield?
    return false
  end
end
#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ バトルフィールド上に居るか？ [オーバーライド]
  #--------------------------------------------------------------------------
  def in_battlefield?
    return true
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs_bp8_initialize initialize
  def initialize(troop_id, member_index)
    @z = 0
    xrxs_bp8_initialize(troop_id, member_index)
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 X 座標の取得
  #--------------------------------------------------------------------------
  alias x screen_x
  def screen_x
    return self.x if $xcam == nil
    return 320 + (self.x - $xcam.x) * 185 / $xcam.z
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Y 座標の取得
  #--------------------------------------------------------------------------
  alias y screen_y
  def screen_y
    return self.y if $xcam == nil
    return 240 + (self.y - $xcam.y) * 185 / $xcam.z
  end
end
#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ○ フレーム更新 (可動カメラ)
  #--------------------------------------------------------------------------
  def update_xcam
    # カメラ位置が動いた場合
    if $xcam.moved?
      # カメラ位置からズーム率を計算
      zoom = 185.00 / $xcam.z
      w = XRXS_BP8::GA_W / 2
      h = w * 3 / 4
      # 背景の設定更新
      @battleback_sprite.zoom_x = zoom
      @battleback_sprite.zoom_y = zoom
      @battleback_sprite.x      = (320 - $xcam.x) * zoom - w * (zoom - 1)
      @battleback_sprite.y      = (240 - $xcam.y) * zoom - h * (zoom - 1)
    end
  end
end
#==============================================================================
# --- バトラースプライト・可動カメラ適用 ---
#==============================================================================
module XRXS_Cam_Deal
  def update
    # 呼び戻す
    super
    # バトラーがバトルフィールドにいない場合は終了
    return if @battler == nil or not @battler.in_battlefield?
    # グラフィックが未設定な場合は終了
    return if self.bitmap == nil
    # ズーム率の変更 ( スプライト座標の再設定は元のメソッドに任せる )
    zoom = 1.00 * 185 / (185 - @battler.z)
    self.zoom_x = zoom * $xcam.zoom
    self.zoom_y = zoom * $xcam.zoom
  end
end
class Sprite_Battler < RPG::Sprite
  include XRXS_Cam_Deal
end
#==============================================================================
# --- ダメージフォロー モジュール ---
#==============================================================================
module XRXS_DamageFollow
  def update
    # 呼び戻す
    super
    # カメラが存在しない場合
    return if $xcam == nil
    # バトラーが nil またはバトルフィールドにいない場合
    return if @battler == nil or not @battler.in_battlefield?
    # 直前カメラ位置から、移動量を算出
    x_moved = @last_cam_x == nil ? 0 : $xcam.x - @last_cam_x
    y_moved = @last_cam_y == nil ? 0 : $xcam.y - @last_cam_y
    # ダメージスプライト配列の作成
    damage_sprites  = [@_damage_sprite]
    damage_sprites += @damage_sprites if @damage_sprites != nil
    # カメラをフォロー
    for sprite in damage_sprites
      next if sprite == nil
      next if sprite.disposed?
      sprite.x -= x_moved
      sprite.y -= y_moved
    end
    # 直前カメラ位置の保持
    @last_cam_x = $xcam.x
    @last_cam_y = $xcam.y
  end
end
class Sprite_Battler < RPG::Sprite
  include XRXS_DamageFollow
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  alias xrxs_bp8_main main
  def main
    # 可動カメラの生成
    $xcam = XCam.new
    # 戻す
    xrxs_bp8_main
    # 可動カメラの解放
    $xcam = nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias xrxs_bp8_update update
  def update
    # 可動カメラのフレーム更新
    $xcam.update
    # 呼び戻す
    xrxs_bp8_update
  end
end
#------------------------------------------------------------------------------
#
#    ▽ Full-View システム ▽
#
#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs_bp8_initialize initialize
  def initialize
    # 呼び戻す
    xrxs_bp8_initialize
    # グラフィックスアレイを取得
    # ビューポート 0 を作成
    w = XRXS_BP8::GA_W
    h = w * 3 / 4
    x = 320 - w / 2
    y = 240 - h / 2
    @viewport0 = Viewport.new(x, y, w, h)
    @viewport0.z  = 0
    # ビューポート 1 の設定を変更
    @viewport1.z += 1
    @viewport1.rect.height = 480
    # バトルバックスプライトを再作成 (ビューポート 0 を使用)
    @battleback_sprite.dispose
    @battleback_sprite = Sprite.new(@viewport0)
    @battleback_name = ""
    # バトルバックのフレーム更新
    update_battleback
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias xrxs_bp8_dispose dispose
  def dispose
    # 呼び戻す
    xrxs_bp8_dispose
    # ビューポートを解放
    @viewport0.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias xrxs_bp8_update update
  def update
    # フレーム更新 (バトルバック)
    update_battleback
    # フレーム更新 (可動カメラ)
    update_xcam if defined? update_xcam
    # 呼び戻す
    xrxs_bp8_update
    # 画面のシェイク位置を設定
    @viewport0.ox = $game_screen.shake if @viewport0 != nil
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新 (バトルバック)
  #--------------------------------------------------------------------------
  def update_battleback
    # バトルバックのファイル名が現在のものと違う場合
    if @battleback_name != $game_temp.battleback_name
      @battleback_name = $game_temp.battleback_name
      if @battleback_sprite.bitmap != nil
        @battleback_sprite.bitmap.dispose
      end
      # グラフィックスアレイを取得
      w = XRXS_BP8::GA_W
      h = w * 3 / 4
      # バトルバックの取得と拡大
      bg   = RPG::Cache.battleback(@battleback_name)
      xga  = Bitmap.new(w, h)
      xga.stretch_blt(xga.rect, bg, bg.rect)
      # XGAをバトルバックに設定
      @battleback_sprite.bitmap = xga
    end
  end
end
#==============================================================================
# ---「戦闘中の"画面"アニメの位置修正」モジュール ---
#==============================================================================
module XRXS_FullScreen_AnimationOffset
  def animation_set_sprites(sprites, cell_data, position)
    super
    for i in 0..15
      sprite = sprites[i]
      pattern = cell_data[i, 0]
      if sprite == nil or pattern == nil or pattern == -1
        next
      end
      if position == 3
        if self.viewport != nil
          sprite.y = 160 # この一行だけ変更
          sprite.y += cell_data[i, 2]
        end
      end
    end
  end
end
class Sprite_Battler < RPG::Sprite
  include XRXS_FullScreen_AnimationOffset
end
