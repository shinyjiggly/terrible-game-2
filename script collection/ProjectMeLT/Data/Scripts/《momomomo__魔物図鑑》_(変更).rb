#魔物図鑑
#
#エネミーの遭遇情報は、戦闘終了時(経験値などを獲得する所)で追加されます。
#よって、敵から逃げた場合や負けイベントでの戦闘敗北などでは
#図鑑に登録されません。
#このタイミングを変えたい場合は各自書き換えて下さい。
#(class Scene_Battle の start_phase5 で追加してます。)
#
#また、所々「アナライズ」という単語がありますが、
#現在、この魔物辞典だけでは機能しておりません。(自ゲームでの名残)
#Window_MonsterBook_Info の DROP_ITEM_NEED_ANALYZE が true になっていると
#ドロップアイテムが表示されなくなりますので、通常は false にしておいて下さい。
#
#注意
#このまま使うと、データベースのトループの1番に
#何も設定していないと、エラー吐きます。
#対処策としては
#1.素直にデータベースのトループの1番に何でもいいから設定する。
#2.Game_Enemy_Book の 「super(1, 1)#ダミー」 の左側の数字の部分を
#  存在するトループIDに書き換える。
#のどちらかになります。
#
#2005.2.6 機能追加
#図鑑完成度の表示機能を追加
#SHOW_COMPLETE_TYPE で設定できます。
#イベントコマンドの「スクリプト」で
#$game_party.enemy_book_max で図鑑の総魔物数(最大数)
#$game_party.enemy_book_now で図鑑の現在登録数(現在数)
#$game_party.complete_percentage で図鑑の完成率(小数点切捨て)
#を取得できます。
#
#2005.2.17
#complete_percentageのメソッド名を
#enemy_book_complete_percentageに変更(他の図鑑と区別できるように)
#イベントコマンドの「スクリプト」で最大数等の取得を短縮できるようになりました。
#enemy_book_max で図鑑の総魔物数(最大数)
#enemy_book_now で図鑑の現在登録数(現在数)
#enemy_book_compで図鑑の完成率(小数点切捨て)
#
#2005.2.18 バグ修正
#complete_percentageのメソッド名を
#enemy_book_complete_percentageに変更したのに
#complete_percentageって呼び出してました。(単なる書き換え漏れですね)
#
#2005.7.4 機能追加
#コメント機能に対応。
#全体的に色々いじりました。
#
#2005.7.4 バグ修正
#細かいバグを修正。


module Enemy_Book_Config
  #ドロップアイテム表示にアナライズが必要かどうか
  DROP_ITEM_NEED_ANALYZE = false 
  #回避修正の名前
  EVA_NAME = "回避"              
  #図鑑完成率の表示方法
  #0:表示なし 1:現在数/最大数 2:％表示 3:両方
  SHOW_COMPLETE_TYPE = 3         
  #コメント機能を使うかどうか(要・コメント追加スクリプト導入)
  COMMENT_SYSTEM = false
end

class Game_Temp
  attr_accessor :enemy_book_data
  alias temp_enemy_book_data_initialize initialize
  def initialize
    temp_enemy_book_data_initialize
    @enemy_book_data = Data_MonsterBook.new
  end
end

class Game_Party
  attr_accessor :enemy_info               # 出会った敵情報(図鑑用)
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias book_info_initialize initialize
  def initialize
    book_info_initialize
    @enemy_info = {}
  end
  #--------------------------------------------------------------------------
  # ● エネミー情報の追加(図鑑用)
  #     type : 通常遭遇かアナライズか 0:通常 1:アナライズ -1:情報削除
  #     0:無遭遇 1:遭遇済 2:アナライズ済
  #--------------------------------------------------------------------------
  def add_enemy_info(enemy_id, type = 0)
    case type
    when 0
      if @enemy_info[enemy_id] == 2
        return false
      end
      @enemy_info[enemy_id] = 1
    when 1
      @enemy_info[enemy_id] = 2
    when -1
      @enemy_info[enemy_id] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 魔物図鑑の最大登録数を取得
  #--------------------------------------------------------------------------
  def enemy_book_max
    return $game_temp.enemy_book_data.id_data.size - 1
  end
  #--------------------------------------------------------------------------
  # ● 魔物図鑑の現在登録数を取得
  #--------------------------------------------------------------------------
  def enemy_book_now
    now_enemy_info = @enemy_info.keys
    # 登録無視の属性IDを取得
    no_add = $game_temp.enemy_book_data.no_add_element
    new_enemy_info = []
    for i in now_enemy_info
      enemy = $data_enemies[i]
      next if enemy.name == ""
      if enemy.element_ranks[no_add] == 1
        next
      end
      new_enemy_info.push(enemy.id)
    end
    return new_enemy_info.size
  end
  #--------------------------------------------------------------------------
  # ● 魔物図鑑の完成率を取得
  #--------------------------------------------------------------------------
  def enemy_book_complete_percentage
    e_max = enemy_book_max.to_f
    e_now = enemy_book_now.to_f
    comp = e_now / e_max * 100
    return comp.truncate
  end
end

class Interpreter
  def enemy_book_max
    return $game_party.enemy_book_max
  end
  def enemy_book_now
    return $game_party.enemy_book_now
  end
  def enemy_book_comp
    return $game_party.enemy_book_complete_percentage
  end
end

class Scene_Battle
  alias add_enemy_info_start_phase5 start_phase5
  def start_phase5
    for enemy in $game_troop.enemies
      # エネミーが隠れ状態でない場合
      unless enemy.hidden
        # 敵遭遇情報追加
        $game_party.add_enemy_info(enemy.id, 0)
      end
    end
    add_enemy_info_start_phase5
  end
end

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● エネミーの戦闘後獲得アイテムの描画
  #--------------------------------------------------------------------------
  def draw_enemy_drop_item(enemy, x, y)
    self.contents.font.color = normal_color
    treasures = []
    if enemy.item_id > 0
      treasures.push($data_items[enemy.item_id])
    end
    if enemy.weapon_id > 0
      treasures.push($data_weapons[enemy.weapon_id])
    end
    if enemy.armor_id > 0
      treasures.push($data_armors[enemy.armor_id])
    end
    # 現状ではとりあえず1つのみ描画
    if treasures.size > 0
      item = treasures[0]
      bitmap = RPG::Cache.icon(item.icon_name)
      opacity = 255
      self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
      name = treasures[0].name
    else
      self.contents.font.color = disabled_color
      name = "No Item"
    end
    self.contents.draw_text(x+28, y, 212, 32, name)
  end
  #--------------------------------------------------------------------------
  # ● エネミーの図鑑IDの描画
  #--------------------------------------------------------------------------
  def draw_enemy_book_id(enemy, x, y)
    self.contents.font.color = normal_color
    id = $game_temp.enemy_book_data.id_data.index(enemy.id)
    self.contents.draw_text(x, y, 32, 32, id.to_s)
  end
  #--------------------------------------------------------------------------
  # ● エネミーの名前の描画
  #     enemy : エネミー
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_enemy_name(enemy, x, y)
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 152, 32, enemy.name)
  end
  #--------------------------------------------------------------------------
  # ● エネミーグラフィックの描画(アナライズ)
  #     enemy : エネミー
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_enemy_graphic(enemy, x, y, opacity = 255)
    bitmap = RPG::Cache.battler(enemy.battler_name, enemy.battler_hue)
    cw = bitmap.width
    ch = bitmap.height
    src_rect = Rect.new(0, 0, cw, ch)
    x = x + (cw / 2 - x) if cw / 2 > x
    self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect, opacity)
  end
  #--------------------------------------------------------------------------
  # ● エネミーの獲得EXPの描画
  #     enemy : エネミー
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_enemy_exp(enemy, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, "EXP")
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 120, y, 36, 32, enemy.exp.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # ● エネミーの獲得GOLDの描画
  #     enemy : エネミー
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_enemy_gold(enemy, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, $data_system.words.gold)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 120, y, 36, 32, enemy.gold.to_s, 2)
  end
end

class Game_Enemy_Book < Game_Enemy
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(enemy_id)
    super(1, 1)#ダミー
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @hp = maxhp
    @sp = maxsp
  end
end

class Data_MonsterBook
  attr_reader :id_data
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @id_data = enemy_book_id_set
  end
  #--------------------------------------------------------------------------
  # ● 図鑑用登録無視属性取得
  #--------------------------------------------------------------------------
  def no_add_element
    no_add = 0
    # 登録無視の属性IDを取得
    for i in 1...$data_system.elements.size
      if $data_system.elements[i] =~ /図鑑登録無効/
        no_add = i
        break
      end
    end
    return no_add
  end
  #--------------------------------------------------------------------------
  # ● 図鑑用敵ID設定
  #--------------------------------------------------------------------------
  def enemy_book_id_set
    data = [0]
    no_add = no_add_element
    # 登録無視の属性IDを取得
    for i in 1...$data_enemies.size
      enemy = $data_enemies[i]
      next if enemy.name == ""
      if enemy.element_ranks[no_add] == 1
        next
      end
      data.push(enemy.id)
    end
    return data
  end
end


class Window_MonsterBook < Window_Selectable
  attr_reader   :data
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(index=0)
    super(0, 64, 640, 416)
    @column_max = 2
    @book_data = $game_temp.enemy_book_data
    @data = @book_data.id_data.dup
    @data.shift
    #@data.sort!
    @item_max = @data.size
    self.index = 0
    refresh if @item_max > 0
  end
  #--------------------------------------------------------------------------
  # ● 遭遇データを取得
  #--------------------------------------------------------------------------
  def data_set
    data = $game_party.enemy_info.keys
    data.sort!
    newdata = []
    for i in data
      next if $game_party.enemy_info[i] == 0
      # 図鑑登録無視を考慮
      if book_id(i) != nil
        newdata.push(i)
      end
    end
    return newdata
  end
  #--------------------------------------------------------------------------
  # ● 表示許可取得
  #--------------------------------------------------------------------------
  def show?(id)
    if $game_party.enemy_info[id] == 0 or $game_party.enemy_info[id] == nil
      return false
    else
      return true
    end
  end
  #--------------------------------------------------------------------------
  # ● 図鑑用ID取得
  #--------------------------------------------------------------------------
  def book_id(id)
    return @book_data.index(id)
  end
  #--------------------------------------------------------------------------
  # ● エネミー取得
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    self.contents = Bitmap.new(width - 32, row_max * 32)
    #項目数が 0 でなければビットマップを作成し、全項目を描画
    if @item_max > 0
      for i in 0...@item_max
       draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    enemy = $data_enemies[@data[index]]
    return if enemy == nil
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.font.color = normal_color
    draw_enemy_book_id(enemy, x, y)
    if show?(enemy.id)
      self.contents.draw_text(x + 28+16, y, 212, 32, enemy.name, 0)
    else
      self.contents.draw_text(x + 28+16, y, 212, 32, "－－－－－", 0)
      return
    end
    if analyze?(@data[index])
      self.contents.font.color = text_color(3)
      self.contents.draw_text(x + 256, y, 24, 32, "済", 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● アナライズ済かどうか
  #--------------------------------------------------------------------------
  def analyze?(enemy_id)
    if $game_party.enemy_info[enemy_id] == 2
      return true
    else
      return false
    end
  end
end


class Window_MonsterBook_Info < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0+64, 640, 480-64)
    self.contents = Bitmap.new(width - 32, height - 32)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(enemy_id)
    self.contents.clear
    self.contents.font.size = 22
    enemy = Game_Enemy_Book.new(enemy_id)
    draw_enemy_graphic(enemy, 96, 240+48+64, 200)
    draw_enemy_book_id(enemy, 4, 0)
    draw_enemy_name(enemy, 48, 0)
    draw_actor_hp(enemy, 288, 0)
    draw_actor_sp(enemy, 288+160, 0)
    draw_actor_parameter(enemy, 288    ,  32, 0)
    self.contents.font.color = system_color
    self.contents.draw_text(288+160, 32, 120, 32, Enemy_Book_Config::EVA_NAME)
    self.contents.font.color = normal_color
    self.contents.draw_text(288+160 + 120, 32, 36, 32, enemy.eva.to_s, 2)
    draw_actor_parameter(enemy, 288    ,  64, 3)
    draw_actor_parameter(enemy, 288+160,  64, 4)
    draw_actor_parameter(enemy, 288    ,  96, 5)
    draw_actor_parameter(enemy, 288+160,  96, 6)
    draw_actor_parameter(enemy, 288    , 128, 1)
    draw_actor_parameter(enemy, 288+160, 128, 2)
    draw_enemy_exp(enemy, 288, 160)
    draw_enemy_gold(enemy, 288+160, 160)
    if analyze?(enemy.id) or !Enemy_Book_Config::DROP_ITEM_NEED_ANALYZE
      self.contents.draw_text(288, 192, 96, 32, "Drop Item")
      draw_enemy_drop_item(enemy, 288+96+4, 192)
      self.contents.font.color = normal_color
      #draw_element_guard(enemy, 320-32, 160-16+96)
    end
  end
  #--------------------------------------------------------------------------
  # ● アナライズ済かどうか
  #--------------------------------------------------------------------------
  def analyze?(enemy_id)
    if $game_party.enemy_info[enemy_id] == 2
      return true
    else
      return false
    end
  end
end


class Scene_MonsterBook
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    $game_temp.enemy_book_data = Data_MonsterBook.new
    # ウィンドウを作成
    @title_window = Window_Base.new(0, 0, 640, 64)
    @title_window.contents = Bitmap.new(640 - 32, 64 - 32)
    @title_window.contents.draw_text(4, 0, 320, 32, "魔物図鑑", 0)
    if Enemy_Book_Config::SHOW_COMPLETE_TYPE != 0
      case Enemy_Book_Config::SHOW_COMPLETE_TYPE
      when 1
        e_now = $game_party.enemy_book_now
        e_max = $game_party.enemy_book_max
        text = e_now.to_s + "/" + e_max.to_s
      when 2
        comp = $game_party.enemy_book_complete_percentage
        text = comp.to_s + "%"
      when 3
        e_now = $game_party.enemy_book_now
        e_max = $game_party.enemy_book_max
        comp = $game_party.enemy_book_complete_percentage
        text = e_now.to_s + "/" + e_max.to_s + "　" + comp.to_s + "%"
      end
      if text != nil
        @title_window.contents.draw_text(320, 0, 288, 32,  text, 2)
      end
    end
    @main_window = Window_MonsterBook.new
    @main_window.active = true
    # インフォウィンドウを作成 (不可視・非アクティブに設定)
    @info_window = Window_MonsterBook_Info.new
    @info_window.z = 110
    @info_window.visible = false
    @info_window.active = false
    @visible_index = 0
    if Enemy_Book_Config::COMMENT_SYSTEM
      # コメントウィンドウを作成 (不可視・非アクティブに設定)
      @comment_window = Window_Monster_Book_Comment.new
      @comment_window.z = 120
      @comment_window.visible = false
      @comment_on = false # コメントフラグ
    end
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
    @main_window.dispose
    @info_window.dispose
    @title_window.dispose
    @comment_window.dispose if @comment_window != nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # ウィンドウを更新
    @main_window.update
    @info_window.update
    if @info_window.active
      update_info
      return
    end
    # メインウィンドウがアクティブの場合: update_target を呼ぶ
    if @main_window.active
      update_main
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_main
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
    #      $scene = Scene_Map.new
      # メニュー画面に切り替え
      $scene = Scene_Menu.new(4)
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      if @main_window.item == nil or @main_window.show?(@main_window.item) == false
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      @main_window.active = false
      @info_window.active = true
      @info_window.visible = true
      @visible_index = @main_window.index
      @info_window.refresh(@main_window.item)
      if @comment_window != nil
        @comment_window.refresh(@main_window.item)
        if @comment_on
          @comment_window.visible = true
        else
          @comment_window.visible = false
        end
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (インフォウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_info
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @main_window.active = true
      @info_window.active = false
      @info_window.visible = false
      @comment_window.visible = false if @comment_window != nil
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      if @comment_window != nil
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        if @comment_on
          @comment_on = false
          @comment_window.visible = false
        else
          @comment_on = true
          @comment_window.visible = true
        end
        return
      end
    end
    if Input.trigger?(Input::L)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      loop_end = false
      while loop_end == false
        if @visible_index != 0
          @visible_index -= 1
        else
          @visible_index = @main_window.data.size - 1
        end
        loop_end = true if @main_window.show?(@main_window.data[@visible_index])
      end
      id = @main_window.data[@visible_index]
      @info_window.refresh(id)
      @comment_window.refresh(id) if @comment_window != nil
      return
    end
    if Input.trigger?(Input::R)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      loop_end = false
      while loop_end == false
        if @visible_index != @main_window.data.size - 1
          @visible_index += 1
        else
          @visible_index = 0
        end
        loop_end = true if @main_window.show?(@main_window.data[@visible_index])
      end
      id = @main_window.data[@visible_index]
      @info_window.refresh(id)
      @comment_window.refresh(id) if @comment_window != nil
      return
    end
  end
end

