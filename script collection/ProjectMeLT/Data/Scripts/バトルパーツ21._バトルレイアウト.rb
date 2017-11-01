# ▼▲▼ XRXS_BP21. バトルレイアウト・ベーシックセッティング ▼▲▼
# by 桜雅 在土

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
module XRXS_BP21
  #
  # 「位置揃え」(0:左寄せ　1:中央　2:右寄せ)
  #
  ALIGN = 1
  #
  # 確保するサイズ[単位:～人分] 
  #
  MAX = 4
end
#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● バトル画面 X 座標の取得 [再定義]
  #--------------------------------------------------------------------------
  def screen_x
    # 最大確保人数の取得
    max = XRXS_BP21::MAX
    # パーティ内の並び順から X 座標を計算して返す
    if self.index != nil
      i = self.index
      space = 640 / max
      case XRXS_BP21::ALIGN
      when 0
        actor_x = i * space
      when 1
        actor_x = (space * ((max - $game_party.actors.size)/2.0 + i)).floor
      when 2
        actor_x = (i + max - $game_party.actors.size) * space
      end
      return actor_x + space/2
    else
      return 0
    end
  end
end
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● リフレッシュ [再定義]
  #--------------------------------------------------------------------------
  def refresh
    # 最大確保人数の取得
    max = XRXS_BP21::MAX
    #
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      width = [self.width*3/4 / max, 80].max
      space = self.width / max
      case XRXS_BP21::ALIGN
      when 0
        actor_x = i * space + 4
      when 1
        actor_x = (space * ((max - $game_party.actors.size)/2.0 + i)).floor
      when 2
        actor_x = (i + max - $game_party.actors.size) * space + 4
      end
      # バトルステータスの描写
      draw_battlestatus(i, actor_x, width)
    end
  end
  #--------------------------------------------------------------------------
  # ○ バトルステータスの描写
  #--------------------------------------------------------------------------
  def draw_battlestatus(i, x, width)
    actor = $game_party.actors[i]
    draw_actor_name(actor, x, 0)
    draw_actor_hp(actor, x, 32, width)
    draw_actor_sp(actor, x, 64, width)
    if @level_up_flags[i]
      self.contents.font.color = normal_color
      self.contents.draw_text(x, 96, width, 32, "LEVEL UP!")
    else
      draw_actor_state(actor, x, 96)
    end
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウのセットアップ
  #--------------------------------------------------------------------------
  alias xrxs_bp21_phase3_setup_command_window phase3_setup_command_window
  def phase3_setup_command_window
    # 呼び戻す
    xrxs_bp21_phase3_setup_command_window
    # 最大確保人数の取得
    max = XRXS_BP21::MAX
    # アクターコマンドウィンドウの位置を設定
    space = @status_window.width / max
    i = @actor_index
    case XRXS_BP21::ALIGN
    when 0
      cx = i * space + 4
    when 1
      cx = (space * ((max - $game_party.actors.size)/2.0 + i)).floor
    when 2
      cx = (i + max - $game_party.actors.size) * space + 4
    end
    cx += space/2
    cx += @status_window.x
    w = @actor_command_window.width/2
    @actor_command_window.x = [[cx, w].max, 640-w].min - w
  end
end
