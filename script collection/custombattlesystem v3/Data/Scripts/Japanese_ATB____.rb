# ▼▲▼ XRXS_BP 1. CP制導入 ver..16 ▼▲▼
# by 桜雅 在土, 和希

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
class Scene_Battle
  # ここに効果音を設定すると、アクターコマンドがポップしたときに効果音を再生
  DATA_SYSTEM_COMMAND_UP_SE = ""
  # 消費CP
  CP_COST_BASIC_ACTIONS =     0 # 攻撃･防御・逃げる・何もしない時の共通消費値
  CP_COST_SKILL_ACTION  = 65535 # スキル
  CP_COST_ITEM_ACTION   = 65535 # アイテム
  CP_COST_BASIC_ATTACK  = 65535 # 攻撃
  CP_COST_BASIC_GUARD   = 32768 # 防御
  CP_COST_BASIC_NOTHING = 65535 # なにもしない
  CP_COST_BASIC_ESCAPE  = 65535 # 「逃げる」時
end
class Scene_Battle_CP
  # ここの 1.0を変えることで↓スピードを変更可能。(数値が高いほど早い)
  # ただし小数点は使用すること。(1の場合も1.0とすること)#Thx - Jack-R
  # 「バトルスピード」
  BATTLE_SPEED = 1.0
  # 「戦闘開始時初期CPの占有率に対する%」
  START_CP_PERCENT = 100
end
#==============================================================================
# ■ Scene_Battle_CP
#==============================================================================
class Scene_Battle_CP
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :stop                   # CP加算ストップ
  #----------------------------------------------------------------------------
  # ● オブジェクトの初期化
  #----------------------------------------------------------------------------
  def initialize
    @battlers = []
    @cancel = false
    @stop = false
    @agi_total = 0
    # 配列 count_battlers を初期化
    count_battlers = []
    # エネミーを配列 count_battlers に追加
    for enemy in $game_troop.enemies
      count_battlers.push(enemy)
    end
    # アクターを配列 count_battlers に追加
    for actor in $game_party.actors
      count_battlers.push(actor)
    end
    for battler in count_battlers
      @agi_total += battler.agi
    end
    for battler in count_battlers
      battler.cp = [[65535 * START_CP_PERCENT * (rand(15) + 85) * 4 * battler.agi / @agi_total / 10000, 0].max, 65535].min
    end
  end
  #----------------------------------------------------------------------------
  # ● CPカウントアップ
  #----------------------------------------------------------------------------
  def update
    # ストップされているならリターン
    return if @stop
    # 
    for battler in $game_party.actors + $game_troop.enemies
      # 行動出来なければ無視
      if battler.dead? == true
        battler.cp = 0
        next
      end
      battler.cp = [[battler.cp + BATTLE_SPEED * 4096 * battler.agi / @agi_total, 0].max, 65535].min
    end
  end
  #----------------------------------------------------------------------------
  # ● CPカウントの開始
  #----------------------------------------------------------------------------
  def stop
    @cancel = true
    if @cp_thread != nil then
      @cp_thread.join
      @cp_thread = nil
    end
  end
end
#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler
  attr_accessor :now_guarding             # 現在防御中フラグ
  attr_accessor :cp                       # 現在CP
  attr_accessor :slip_state_update_ban    # スリップ・ステート自動処理の禁止
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #--------------------------------------------------------------------------
  alias xrxs_bp1_inputable? inputable?
  def inputable?
    bool = xrxs_bp1_inputable?
    return (bool and (@cp >= 65535))
  end
  #--------------------------------------------------------------------------
  # ● ステート [スリップダメージ] 判定
  #--------------------------------------------------------------------------
  alias xrxs_bp1_slip_damage? slip_damage?
  def slip_damage?
    return false if @slip_state_update_ban
    return xrxs_bp1_slip_damage?
  end
  #--------------------------------------------------------------------------
  # ● ステート自然解除 (ターンごとに呼び出し)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_remove_states_auto remove_states_auto
  def remove_states_auto
    return if @slip_state_update_ban
    xrxs_bp1_remove_states_auto
  end
end
#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias xrxs_bp1_setup setup
  def setup(actor_id)
    xrxs_bp1_setup(actor_id)
    @hate = 100  # init-value is 100
    @cp = 0
    @now_guarding = false
    @slip_state_update_ban = false
  end
end
#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs_bp1_initialize initialize
  def initialize(troop_id, member_index)
    xrxs_bp1_initialize(troop_id, member_index)
    @hate = 100  # init-value is 100
    @cp = 0
    @now_guarding = false
    @slip_state_update_ban = false
  end
end
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :update_cp_only                   # CPメーターのみの更新
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs_bp1_initialize initialize
  def initialize
    @update_cp_only = false
    xrxs_bp1_initialize
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  alias xrxs_bp1_refresh refresh
  def refresh
    unless @update_cp_only
      xrxs_bp1_refresh
    end
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actors_size = [$game_party.actors.size, 4].max
      max_width = [600 / (actors_size + 1), 80].max
      x_shift = max_width + (600 - max_width*actors_size)/(actors_size - 1)
      actor_x = i * x_shift + 4
      draw_actor_cp_meter(actor, actor_x, 96, max_width, 0)
    end
  end
  #--------------------------------------------------------------------------
  # ● CPメーター の描画
  #--------------------------------------------------------------------------
  def draw_actor_cp_meter(actor, x, y, width = 156, type = 0)
    self.contents.font.color = system_color
    self.contents.fill_rect(x-1, y+27, width+2,6, Color.new(0, 0, 0, 255))
    if actor.cp == nil
      actor.cp = 0
    end
    w = width * [actor.cp,65535].min / 65535
    self.contents.fill_rect(x, y+28, w,1, Color.new(255, 255, 128, 255))
    self.contents.fill_rect(x, y+29, w,1, Color.new(255, 255, 0, 255))
    self.contents.fill_rect(x, y+30, w,1, Color.new(192, 192, 0, 255))
    self.contents.fill_rect(x, y+31, w,1, Color.new(128, 128, 0, 255))
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias xrxs_bp1_update update
  def update
    xrxs_bp1_update
    # CP更新
    @cp_thread.update
  end
  #--------------------------------------------------------------------------
  # ● バトル終了
  #     result : 結果 (0:勝利 1:敗北 2:逃走)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_battle_end battle_end
  def battle_end(result)
    # CPカウント停止
    @cp_thread.stop
    xrxs_bp1_battle_end(result)
  end
  #--------------------------------------------------------------------------
  # ● プレバトルフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs_bp1_start_phase1 start_phase1
  def start_phase1
    @agi_total = 0
    # CP加算を開始する
    @cp_thread = Scene_Battle_CP.new
    # アクターコマンドウィンドウを再作成
    s1 = $data_system.words.attack
    s2 = $data_system.words.skill
    s3 = $data_system.words.guard
    s4 = $data_system.words.item
    @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4, "Escape"])
    @actor_command_window.y = 128
    @actor_command_window.back_opacity = 160
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @actor_command_window.draw_item(4, $game_temp.battle_can_escape ? @actor_command_window.normal_color : @actor_command_window.disabled_color)
    # 呼び戻す
    xrxs_bp1_start_phase1
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンドフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs_bp1_start_phase2 start_phase2
  def start_phase2
    xrxs_bp1_start_phase2
    @party_command_window.active = false
    @party_command_window.visible = false
    # 次へ
    start_phase3
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウのセットアップ
  #--------------------------------------------------------------------------
  alias xrxs_bp1_phase3_setup_command_window phase3_setup_command_window
  def phase3_setup_command_window
    # CPスレッドを一時停止
    @cp_thread.stop = true
    # @active_battlerの防御を解除
    @active_battler.now_guarding = false
    # 効果音の再生
    Audio.se_play(DATA_SYSTEM_COMMAND_UP_SE) if DATA_SYSTEM_COMMAND_UP_SE != ""
    # 呼び戻す
    xrxs_bp1_phase3_setup_command_window
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : 基本コマンド)
  #--------------------------------------------------------------------------
  alias xrxs_bsp1_update_phase3_basic_command update_phase3_basic_command
  def update_phase3_basic_command
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # アクターコマンドウィンドウのカーソル位置で分岐
      case @actor_command_window.index
      when 4  # 逃げる
        if $game_temp.battle_can_escape
          # 決定 SE を演奏
          $game_system.se_play($data_system.decision_se)
          # アクションを設定
          @active_battler.current_action.kind = 0
          @active_battler.current_action.basic = 4
          # 次のアクターのコマンド入力へ
          phase3_next_actor
        else
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
        end
        return
      end
    end
    xrxs_bsp1_update_phase3_basic_command
  end
  #--------------------------------------------------------------------------
  # ● メインフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs_bp1_start_phase4 start_phase4
  def start_phase4
    # 呼び戻す
    xrxs_bp1_start_phase4
    # CP加算を再開する
    @cp_thread.stop = false
  end
  #--------------------------------------------------------------------------
  # ● 行動順序作成
  #--------------------------------------------------------------------------
  alias xrxs_bp1_make_action_orders make_action_orders
  def make_action_orders
    xrxs_bp1_make_action_orders
    # 全員のCPを確認
    exclude_battler = []
    for battler in @action_battlers
      # CPが不足している場合は @action_battlers から除外する
      if battler.cp < 65535
        exclude_battler.push(battler)
      end
    end
    @action_battlers -= exclude_battler
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 1 : アクション準備)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_update_phase4_step1 update_phase4_step1
  def update_phase4_step1
    # 初期化
    @phase4_act_continuation = 0
    # 勝敗判定
    if judge
      @cp_thread.stop
      # 勝利または敗北の場合 : メソッド終了
      return
    end
    # 未行動バトラー配列の先頭から取得
    @active_battler = @action_battlers[0]
    # ステータス更新をCPだけに限定。
    @status_window.update_cp_only = true
    # ステート更新を禁止。
    @active_battler.slip_state_update_ban = true if @active_battler != nil
    # 戻す
    xrxs_bp1_update_phase4_step1
    # @status_windowがリフレッシュされなかった場合は手動でリフレッシュ(CPのみ)
    if @phase4_step != 2
      # リフレッシュ
      @status_window.refresh
      # 軽量化：たったコレだけΣ(･ｗ･
      Graphics.frame_reset
    end
    # 禁止を解除
    @status_window.update_cp_only = false
    @active_battler.slip_state_update_ban = false if @active_battler != nil 
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 2 : アクション開始)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_update_phase4_step2 update_phase4_step2
  def update_phase4_step2
    # 強制アクションでなければ
    unless @active_battler.current_action.forcing
      # 制約が [敵を通常攻撃する] か [味方を通常攻撃する] の場合
      if @active_battler.restriction == 2 or @active_battler.restriction == 3
        # アクションに攻撃を設定
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
      end
      # 制約が [行動できない] の場合
      if @active_battler.restriction == 4
        # アクション強制対象のバトラーをクリア
        $game_temp.forcing_battler = nil
        if @phase4_act_continuation == 0 and @active_battler.cp >= 65535
          # ステート自然解除
          @active_battler.remove_states_auto
          # CP消費
          @active_battler.cp = [(@active_battler.cp - 65535),0].max
          # ステータスウィンドウをリフレッシュ
          @status_window.refresh
        end
        # ステップ 1 に移行
        @phase4_step = 1
        return
      end
    end
    # アクションの種別で分岐
    case @active_battler.current_action.kind
    when 0
      # 攻撃･防御・逃げる・何もしない時の共通消費CP
      @active_battler.cp -= CP_COST_BASIC_ACTIONS if @phase4_act_continuation == 0
    when 1
      # スキル使用時の消費CP
      @active_battler.cp -= CP_COST_SKILL_ACTION if @phase4_act_continuation == 0
    when 2
      # アイテム使用時の消費CP
      @active_battler.cp -= CP_COST_ITEM_ACTION if @phase4_act_continuation == 0
    end
    # CP加算を一時停止する
    @cp_thread.stop = true
    # ステート自然解除
    @active_battler.remove_states_auto
    # 呼び戻す
    xrxs_bp1_update_phase4_step2
  end
  #--------------------------------------------------------------------------
  # ● 基本アクション 結果作成
  #--------------------------------------------------------------------------
  alias xrxs_bp1_make_basic_action_result make_basic_action_result
  def make_basic_action_result
    # 攻撃の場合
    if @active_battler.current_action.basic == 0 and @phase4_act_continuation == 0
      @active_battler.cp -= CP_COST_BASIC_ATTACK # 攻撃時のCP消費
    end
    # 防御の場合
    if @active_battler.current_action.basic == 1 and @phase4_act_continuation == 0
      @active_battler.cp -= CP_COST_BASIC_GUARD # 防御時のCP消費
    end
    # 敵の逃げるの場合
    if @active_battler.is_a?(Game_Enemy) and
       @active_battler.current_action.basic == 2 and @phase4_act_continuation == 0
      @active_battler.cp -= CP_COST_BASIC_ESCAPE # 逃走時のCP消費
    end
    # 何もしないの場合
    if @active_battler.current_action.basic == 3 and @phase4_act_continuation == 0
      @active_battler.cp -= CP_COST_BASIC_NOTHING # 何もしない時のCP消費
    end
    # 逃げるの場合
    if @active_battler.current_action.basic == 4 and @phase4_act_continuation == 0
      @active_battler.cp -= CP_COST_BASIC_ESCAPE # 逃走時のCP消費
      # 逃走可能ではない場合
      if $game_temp.battle_can_escape == false
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # 逃走処理
      update_phase2_escape
      return
    end
    xrxs_bp1_make_basic_action_result
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 3 : 行動側アニメーション)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_update_phase4_step3 update_phase4_step3
  def update_phase4_step3
    # 呼び戻す
    xrxs_bp1_update_phase4_step3
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 5 : ダメージ表示)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_update_phase4_step5 update_phase4_step5
  def update_phase4_step5
    # スリップダメージ
    if @active_battler.hp > 0 and @active_battler.slip_damage?
      @active_battler.slip_damage_effect
      @active_battler.damage_pop = true
    end
    xrxs_bp1_update_phase4_step5
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 6 : リフレッシュ)
  #--------------------------------------------------------------------------
  alias xrxs_bp1_update_phase4_step7 update_phase4_step7
  def update_phase4_step7
    # CP加算を再開する
    @cp_thread.stop = false
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    xrxs_bp1_update_phase4_step7
  end
end