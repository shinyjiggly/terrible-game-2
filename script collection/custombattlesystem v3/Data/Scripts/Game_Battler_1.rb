#==============================================================================
# ■ Game_Battler (分割定義 1)
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :battler_name             # バトラー ファイル名
  attr_reader   :battler_hue              # バトラー 色相
  attr_reader   :hp                       # HP
  attr_reader   :sp                       # SP
  attr_reader   :states                   # ステート
  attr_accessor :hidden                   # 隠れフラグ
  attr_accessor :immortal                 # 不死身フラグ
  attr_accessor :damage_pop               # ダメージ表示フラグ
  attr_accessor :damage                   # ダメージ値
  attr_accessor :critical                 # クリティカルフラグ
  attr_accessor :animation_id             # アニメーション ID
  attr_accessor :animation_hit            # アニメーション ヒットフラグ
  attr_accessor :white_flash              # 白フラッシュフラグ
  attr_accessor :blink                    # 明滅フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battler_name = ""
    @battler_hue = 0
    @hp = 0
    @sp = 0
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    @hidden = false
    @immortal = false
    @damage_pop = false
    @damage = nil
    @critical = false
    @animation_id = 0
    @animation_hit = false
    @white_flash = false
    @blink = false
    @current_action = Game_BattleAction.new
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の取得
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 999999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● MaxSP の取得
  #--------------------------------------------------------------------------
  def maxsp
    n = [[base_maxsp + @maxsp_plus, 0].max, 9999].min
    for i in @states
      n *= $data_states[i].maxsp_rate / 100.0
    end
    n = [[Integer(n), 0].max, 9999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 腕力の取得
  #--------------------------------------------------------------------------
  def str
    n = [[base_str + @str_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].str_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 器用さの取得
  #--------------------------------------------------------------------------
  def dex
    n = [[base_dex + @dex_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].dex_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 素早さの取得
  #--------------------------------------------------------------------------
  def agi
    n = [[base_agi + @agi_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].agi_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 魔力の取得
  #--------------------------------------------------------------------------
  def int
    n = [[base_int + @int_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].int_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の設定
  #     maxhp : 新しい MaxHP
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -9999].max, 9999].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● MaxSP の設定
  #     maxsp : 新しい MaxSP
  #--------------------------------------------------------------------------
  def maxsp=(maxsp)
    @maxsp_plus += maxsp - self.maxsp
    @maxsp_plus = [[@maxsp_plus, -9999].max, 9999].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ● 腕力の設定
  #     str : 新しい腕力
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 器用さの設定
  #     dex : 新しい器用さ
  #--------------------------------------------------------------------------
  def dex=(dex)
    @dex_plus += dex - self.dex
    @dex_plus = [[@dex_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 素早さの設定
  #     agi : 新しい素早さ
  #--------------------------------------------------------------------------
  def agi=(agi)
    @agi_plus += agi - self.agi
    @agi_plus = [[@agi_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 魔力の設定
  #     int : 新しい魔力
  #--------------------------------------------------------------------------
  def int=(int)
    @int_plus += int - self.int
    @int_plus = [[@int_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得
  #--------------------------------------------------------------------------
  def hit
    n = 100
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 攻撃力の取得
  #--------------------------------------------------------------------------
  def atk
    n = base_atk
    for i in @states
      n *= $data_states[i].atk_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 物理防御の取得
  #--------------------------------------------------------------------------
  def pdef
    n = base_pdef
    for i in @states
      n *= $data_states[i].pdef_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 魔法防御の取得
  #--------------------------------------------------------------------------
  def mdef
    n = base_mdef
    for i in @states
      n *= $data_states[i].mdef_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 回避修正の取得
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for i in @states
      n += $data_states[i].eva
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ● HP の変更
  #     hp : 新しい HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = [[hp, maxhp].min, 0].max
    # 戦闘不能を付加または解除
    for i in 1...$data_states.size
      if $data_states[i].zero_hp
        if self.dead?
          add_state(i)
        else
          remove_state(i)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● SP の変更
  #     sp : 新しい SP
  #--------------------------------------------------------------------------
  def sp=(sp)
    @sp = [[sp, maxsp].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #--------------------------------------------------------------------------
  def recover_all
    @hp = maxhp
    @sp = maxsp
    for i in @states.clone
      remove_state(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● カレントアクションの取得
  #--------------------------------------------------------------------------
  def current_action
    return @current_action
  end
  #--------------------------------------------------------------------------
  # ● アクションスピードの決定
  #--------------------------------------------------------------------------
  def make_action_speed
    @current_action.speed = agi + rand(10 + agi / 4)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能判定
  #--------------------------------------------------------------------------
  def dead?
    return (@hp == 0 and not @immortal)
  end
  #--------------------------------------------------------------------------
  # ● 存在判定
  #--------------------------------------------------------------------------
  def exist?
    return (not @hidden and (@hp > 0 or @immortal))
  end
  #--------------------------------------------------------------------------
  # ● HP 0 判定
  #--------------------------------------------------------------------------
  def hp0?
    return (not @hidden and @hp == 0)
  end
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #--------------------------------------------------------------------------
  def inputable?
    return (not @hidden and restriction <= 1)
  end
  #--------------------------------------------------------------------------
  # ● 行動可能判定
  #--------------------------------------------------------------------------
  def movable?
    return (not @hidden and restriction < 4)
  end
  #--------------------------------------------------------------------------
  # ● 防御中判定
  #--------------------------------------------------------------------------
  def guarding?
    return (@current_action.kind == 0 and @current_action.basic == 1)
  end
  #--------------------------------------------------------------------------
  # ● 休止中判定
  #--------------------------------------------------------------------------
  def resting?
    return (@current_action.kind == 0 and @current_action.basic == 3)
  end
end
