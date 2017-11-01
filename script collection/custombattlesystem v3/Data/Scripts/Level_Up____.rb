# ▼▲▼ XRXS_BP10. LEVEL UP!能力上昇表示ウィンドウ plus!! ▼▲▼
# by 桜雅 在土

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
class Scene_Battle
  LEVEL_UP_SE   = ""                       # レベルアップSE。""で無し。 
  LEVEL_UP_ME   = "Audio/ME/007-Fanfare01" # レベルアップME
end
class Window_SkillLearning < Window_Base
  SKILLLEARN_SE = "Audio/SE/106-Heal02"    # スキル習得SE。
end
#==============================================================================
# ■ Window_LevelUpWindow
#------------------------------------------------------------------------------
# 　バトル終了時、レベルアップした場合にステータスを表示するウィンドウです。
#==============================================================================
class Window_LevelUpWindow < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, actor, last_lv, up_hp, up_sp, up_str, up_dex, up_agi, up_int)
    super(x, y, 160, 192)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = $fontface
    self.contents.font.size = $fontsize
    self.visible = false
    self.back_opacity = 160
    refresh(actor, last_lv, up_hp, up_sp, up_str, up_dex, up_agi, up_int)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, last_lv, up_hp, up_sp, up_str, up_dex, up_agi, up_int)
    self.contents.clear
    self.contents.font.color = system_color
    self.contents.font.size = 14
    self.contents.draw_text( 0,   0, 160, 24, "LEVEL UP!!")
    self.contents.font.size = 18
    self.contents.draw_text( 0,  28, 160, 24, $data_system.words.hp)
    self.contents.draw_text( 0,  50, 160, 24, $data_system.words.sp)
    self.contents.font.size = 14
    self.contents.draw_text( 0,  72,  80, 24, $data_system.words.str)
    self.contents.draw_text( 0,  94,  80, 24, $data_system.words.dex)
    self.contents.draw_text( 0, 116,  80, 24, $data_system.words.agi)
    self.contents.draw_text( 0, 138,  80, 24, $data_system.words.int)
    self.contents.draw_text(92,   0, 128, 24, "→")
    self.contents.draw_text(76,  28, 128, 24, "=")
    self.contents.draw_text(76,  50, 128, 24, "=")
    self.contents.draw_text(76,  72, 128, 24, "=")
    self.contents.draw_text(76,  94, 128, 24, "=")
    self.contents.draw_text(76, 116, 128, 24, "=")
    self.contents.draw_text(76, 138, 128, 24, "=")
    self.contents.font.color = normal_color
    self.contents.draw_text( 0,   0,  88, 24, last_lv.to_s, 2)
    self.contents.draw_text( 0,  28,  72, 24, "+" + up_hp.to_s, 2)
    self.contents.draw_text( 0,  50,  72, 24, "+" + up_sp.to_s, 2)
    self.contents.draw_text( 0,  72,  72, 24, "+" + up_str.to_s, 2)
    self.contents.draw_text( 0,  94,  72, 24, "+" + up_dex.to_s, 2)
    self.contents.draw_text( 0, 116,  72, 24, "+" + up_agi.to_s, 2)
    self.contents.draw_text( 0, 138,  72, 24, "+" + up_int.to_s, 2)
    self.contents.font.size = 20
    self.contents.draw_text( 0,   0, 128, 24, actor.level.to_s, 2)
    self.contents.draw_text( 0,  26, 128, 24, actor.maxhp.to_s, 2)
    self.contents.draw_text( 0,  48, 128, 24, actor.maxsp.to_s, 2)
    self.contents.draw_text( 0,  70, 128, 24, actor.str.to_s, 2)
    self.contents.draw_text( 0,  92, 128, 24, actor.dex.to_s, 2)
    self.contents.draw_text( 0, 114, 128, 24, actor.agi.to_s, 2)
    self.contents.draw_text( 0, 136, 128, 24, actor.int.to_s, 2)
  end
end
#==============================================================================
# ■ Window_SkillLearning
#------------------------------------------------------------------------------
# 　レベルアップ時などにスキルを習得した場合にそれを表示するウィンドウです。
#==============================================================================
class Window_SkillLearning < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
    attr_reader   :learned                  # スキルを習得したかどうか
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(class_id, last_lv, now_lv)
    super(160,  64, 320, 64)
    self.contents = Bitmap.new(width - 32, height - 28) # わざと▽を表示
    self.contents.font.name = $fontface
    self.contents.font.size = $fontsize
    self.visible  = false
    self.back_opacity = 160
    @learned      = false
    refresh(class_id, last_lv, now_lv)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(class_id, last_lv, now_lv)
    for i in 0...$data_classes[class_id].learnings.size
      learn_lv = $data_classes[class_id].learnings[i].level
      # 今回のレベルアップ範囲で習得するスキルの場合
      if learn_lv > last_lv and learn_lv <= now_lv
        @learned = true
        # SEの再生
        if SKILLLEARN_SE != ""
          Audio.se_play(SKILLLEARN_SE)
        end
        # 各描写
        skill_name = $data_skills[$data_classes[class_id].learnings[i].skill_id].name
        self.contents.clear
        self.contents.draw_text(0,0,448,32, skill_name + " Learned!!")
        self.visible  = true
        # メインループ
        loop do
          # ゲーム画面を更新
          Graphics.update
          # 入力情報を更新
          Input.update
          # フレーム更新
          update
          # 画面が切り替わったらループを中断
          if @learned == false
            break
          end
        end
        # メインループここまで
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      @learned = false
      self.visible  = false
    end
  end
end
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● 追加・公開インスタンス変数
  #--------------------------------------------------------------------------
    attr_accessor :level_up_flags             # LEVEL UP!表示
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● アフターバトルフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs_bp10_start_phase5 start_phase5
  def start_phase5
    xrxs_bp10_start_phase5
    # 獲得 EXPを取得
    @exp_gained = battle_exp
    # EXP 獲得を取り消す
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      $noanimation = true
      @spriteset.actor_sprites[i].pose(7) unless actor.dead?
      if actor.cant_get_exp? == false
        last_level = actor.level
        actor.exp -= @exp_gained
        if actor.level < last_level
          @status_window.level_up_flags[i] = false
        end
      end
    end
    # 設定
    @exp_gain_actor    = -1
    # リザルトウィンドウを表示
    @result_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 獲得する戦闘経験値の取得
  #--------------------------------------------------------------------------
  unless defined? battle_exp
  def battle_exp
    bexp = 0
    # ループ
    for enemy in $game_troop.enemies
      # エネミーが隠れ状態でない場合
      unless enemy.hidden
        # 獲得を追加
        bexp += enemy.exp
      end
    end
    return bexp
  end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アフターバトルフェーズ)
  #--------------------------------------------------------------------------
  alias xrxs_bp10_update_phase5 update_phase5
  def update_phase5
    @level_up_phase_done = false if @level_up_phase_done != true
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # ウィンドウを閉じて次のアクターへ
      @levelup_window.visible = false if @levelup_window != nil
      @status_window.level_up_flags[@exp_gain_actor] = false
      @level_up_phase_done = phase5_next_levelup
    end
    if @level_up_phase_done
      if @phase5_wait_count < 2
        # リザルトウィンドウをvisible=trueでも不可視に
        @result_window.opacity = 0
        @result_window.back_opacity = 0
        @result_window.contents_opacity = 0
      end
      # 呼び戻す
      xrxs_bp10_update_phase5
      # レベルアップしている場合は強制バトル終了
      battle_end(0) if @levelup_window != nil and @phase5_wait_count <= 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のアクターのレベルアップ表示へ
  #--------------------------------------------------------------------------
  def phase5_next_levelup
    begin
      # 次のアクターへ
      @exp_gain_actor += 1
      # 最後のアクターの場合
      if @exp_gain_actor >= $game_party.actors.size
        # アフターバトルフェーズ開始
        return true
      end
      actor = $game_party.actors[@exp_gain_actor]
      if actor.cant_get_exp? == false
        # 現在の能力値を保持
        last_level = actor.level
        last_maxhp = actor.maxhp
        last_maxsp = actor.maxsp
        last_str = actor.str
        last_dex = actor.dex
        last_agi = actor.agi
        last_int = actor.int
        # 戦闘経験値の再取得
        actor.exp += @exp_gained
        # 判定
        if actor.level > last_level
          # レベルアップした場合
          @status_window.level_up(@exp_gain_actor)
          # リザルトウィンドウを消す
          @result_window.visible = false
          # SEの再生
          if LEVEL_UP_SE != ""
            Audio.se_play(LEVEL_UP_SE)
          end
          # MEの再生
          if LEVEL_UP_ME != ""
            Audio.me_stop
            Audio.me_play(LEVEL_UP_ME)
          end
          # LEVEL-UPウィンドウの設定
          actors_size = [$game_party.actors.size, 4].max
          x_shift = 160 + (640 - 160*actors_size)/(actors_size - 1)
          x = x_shift * @exp_gain_actor
          y = 128
          @levelup_window = Window_LevelUpWindow.new(x, y, actor, last_level,
            actor.maxhp - last_maxhp, actor.maxsp - last_maxsp, actor.str - last_str,
            actor.dex - last_dex, actor.agi - last_agi, actor.int - last_int)
          @levelup_window.visible = true
          # ステータスウィンドウをリフレッシュ
          @status_window.refresh
          # スキル習得ウィンドウの設定
          @skilllearning_window = Window_SkillLearning.new(actor.class_id, last_level, actor.level)
          # ウェイトカウントを設定
          @phase5_wait_count = 40
          return false
        end
      end
    end until false
  end
end