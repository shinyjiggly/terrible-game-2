# ▼▲▼ XRXS26. パーティメンバー拡張機構 ver..05 ▼▲▼ built 082422
# by 桜雅 在土

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
module XRXS26
  FRONT_MEMBER_LIMIT    = 4        # 戦闘参加パーティ最大数
  BACKWARD_MEMBER_LIMIT = 2        # 待機メンバー最大数
  BACKWARD_EXP_GAINABLE = true     # 待機メンバー経験値獲得(true：する、false：しない)
end
#------------------------------------------------------------------------------
#
# 解説
#    Game_Partyの @actors のうち先頭から↑FRONT_MEMBER_LIMIT番目までのアクターを
#   戦闘メンバーとして、それ以上を待機メンバーとして扱います。
#
#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party
  #--------------------------------------------------------------------------
  # ○ インクルード
  #--------------------------------------------------------------------------
  include XRXS26
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :backword_actors          # 待機アクター
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs26_initialize initialize
  def initialize
    xrxs26_initialize
    # 待機メンバー配列を初期化
    @backword_actors = []
  end
  #--------------------------------------------------------------------------
  # ● アクターを加える
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    # アクターを取得
    actor = $game_actors[actor_id]
    # このアクターがパーティにいない場合
    if not @actors.include?(actor)
      # 満員でないならメンバーに追加
      if @actors.size < (FRONT_MEMBER_LIMIT + BACKWARD_MEMBER_LIMIT)
        # アクターを追加
        @actors.push(actor)
        # プレイヤーをリフレッシュ
        $game_player.refresh
      end
    end
  end
end
#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● インクルード
  #--------------------------------------------------------------------------
  include XRXS26
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs26_initialize initialize
  def initialize
    xrxs26_initialize
    #
    # 以下、五人目以降のアクタースプライトの追加処理---
    #
    # アクターが表示されるビューポートを、とりあえず先頭の人から取得しとく(素
    actor_viewport = @actor_sprites[0].viewport
    # 戦闘参加メンバーが5人以上の場合
    if FRONT_MEMBER_LIMIT > 4
      for i in 5..FRONT_MEMBER_LIMIT
        # アクタースプライトを追加
        @actor_sprites.push(Sprite_Battler.new(actor_viewport))
        @actor_sprites[i-1].battler = $game_party.actors[i-1]
      end
    end
    # ビューポートを更新
    actor_viewport.update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias xrxs26_update update
  def update
    # アクタースプライトの内容を更新 (アクターの入れ替えに対応)
    for i in 4...$game_party.actors.size
      next if @actor_sprites[i].nil?
      @actor_sprites[i].battler = $game_party.actors[i]
    end
    # 呼び戻す
    xrxs26_update
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● インクルード
  #--------------------------------------------------------------------------
  include XRXS26
  #--------------------------------------------------------------------------
  # ● メイン処理　をパーティメンバー処理ではさむ
  #--------------------------------------------------------------------------
  alias xrxs26_main main
  def main
    # 待機メンバーへ退避----------
    $game_party.backword_actors[0,0] = $game_party.actors[FRONT_MEMBER_LIMIT, BACKWARD_MEMBER_LIMIT]
    $game_party.actors[FRONT_MEMBER_LIMIT, BACKWARD_MEMBER_LIMIT] = nil
    $game_party.actors.compact!
    # メイン処理
    xrxs26_main
    # 待機メンバーから復帰
    $game_party.actors[$game_party.actors.size,0] = $game_party.backword_actors
    $game_party.backword_actors.clear
  end
  #--------------------------------------------------------------------------
  # ● アフターバトルフェーズ開始
  #--------------------------------------------------------------------------
  alias xrxs26_start_phase5 start_phase5
  def start_phase5
    # 「待機メンバー経験値獲得」が有効 and 待機アクターが一人以上いる
    if BACKWARD_EXP_GAINABLE and $game_party.backword_actors.size >= 1
      # 待機メンバーから復帰
      $game_party.actors[$game_party.actors.size,0] = $game_party.backword_actors
      $game_party.backword_actors.clear
      # 呼び戻す
      xrxs26_start_phase5
      # 待機メンバーへ退避----------
      $game_party.backword_actors[0,0] = $game_party.actors[FRONT_MEMBER_LIMIT, BACKWARD_MEMBER_LIMIT]
      $game_party.actors[FRONT_MEMBER_LIMIT, BACKWARD_MEMBER_LIMIT] = nil
      $game_party.actors.compact!
    else
      # 呼び戻す
      xrxs26_start_phase5
    end
  end
end
