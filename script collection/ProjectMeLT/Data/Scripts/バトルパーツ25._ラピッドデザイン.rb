# ▼▲▼ バトルパーツ25.. バトルステータス・ラピッドデザイン ▼▲▼
# by 桜雅 在土

#==============================================================================
# □ カスタマイズポイント
#==============================================================================
module XRXS73
  #
  # 「位置揃え」(0:左寄せ　1:中央　2:右寄せ)
  #
  ALIGN = 1
  #
  # 確保するサイズ[単位:～人分]
  #
  MAX = 4
  #
  # ステートID=>アイコン名 関連付けハッシュ (Icons)
  #
  STATE_ICON = {3=>"skill_024",5=>"skill_027",7=>"skill_026",8=>"skill_025"}
  #
  # メータースキン (Windowskins)
  #
  NUM_HP  = "NumberL"
  NUM_SP  = "NumberS"
  HP_BAR  = "BattleHPBar"
  AS_BACK = "AS_Back"
end
#==============================================================================
# --- ラピッドナンバー スプライトシステム ---
#==============================================================================
class RapidNumber
  def initialize(x, y, skin)
    @skin = skin
    @x = x
    @y = y
    @w = skin.rect.width / 10
    @h = skin.rect.height
    @sprites = [Sprite.new, Sprite.new, Sprite.new, Sprite.new]
    # ビットマップ生成
    @number_bitmaps = []
    rect = Rect.new(0, 0, @w, @h)
    for i in 0..9
      rect.x = i * @w
      bitmap = Bitmap.new(@w, @h)
      bitmap.blt(0,0,skin, rect)
      @number_bitmaps[i] = bitmap
    end
    #
    reset
  end
  def set(number)
    numbers = [number/1000%10, number/100%10, number/10%10, number%10]
    display = false
    for i in 0..3
      n = numbers[i]
      display |= (n != 0 or i == 3)
      @sprites[i].bitmap = display ? @number_bitmaps[n] : nil
    end
  end
  def reset
    n = @x
    for sprite in @sprites
      sprite.x = n
      sprite.y = @y
      sprite.z = 601
      n += @w
    end
  end
  def x=(n)
    @x = n
    reset
  end
  def y=(n)
    @y = n
    reset
  end
  def dispose
    @sprites.each{|sprite| sprite.dispose }
  end
end
class ActorStatus_SpriteSet
  def initialize(actor)
    num_skin_l = RPG::Cache.windowskin(XRXS73::NUM_HP)
    num_skin_s = RPG::Cache.windowskin(XRXS73::NUM_SP)
    @sprite_hp = RapidNumber.new(0,0, num_skin_l)
    @sprite_sp = RapidNumber.new(0,0, num_skin_s)
    @bar_skin   = RPG::Cache.windowskin(XRXS73::HP_BAR)
    @w = @bar_skin.rect.width
    @h = @bar_skin.rect.height / 3
    hpbar = Sprite.new
    hpbar.z = 602
    hpbar.bitmap = @bar_skin
    hpbar.src_rect = Rect.new(0, @h, @w, @h)
    @sprite_hpbar = hpbar
    @baspace = Sprite.new
    @baspace.z = 599
    @baspace.bitmap = Bitmap.new(128, 128)
    @sprites = [@sprite_hp, @sprite_sp, @sprite_hpbar, @baspace]
    set_actor(actor)
  end
  def set_actor(actor)
    @actor = actor
    @now_hp = @actor.hp
    @now_sp = @actor.sp
    refresh
    @sprite_sp.set(@actor.maxsp)
    @sprite_hp.set(@now_hp)
    @sprite_hpbar.src_rect.width = @w * @now_hp / @actor.maxhp
    @sprite_hpbar.src_rect.y = @h * (@now_hp == @actor.maxhp ? 2 : 1)
  end
  def update
    # HP/SPの変化を判定
    if @now_hp != @desthp
      sign = (@now_hp > @desthp ? -1 : 1)
      @now_hp = @now_hp + sign * [(@desthp - @now_hp).abs / 8, 1].max
      @sprite_hp.set(@now_hp)
      @sprite_hpbar.src_rect.width = @w * @now_hp / @actor.maxhp
      @sprite_hpbar.src_rect.y = @h * (@now_hp == @actor.maxhp ? 2 : 1)
    end
    if @now_sp != @destsp
      sign = (@now_sp > @destsp ? -1 : 1)
      @now_sp = @now_sp + sign * [(@destsp - @now_sp).abs / 8, 1].max
      @sprite_sp.set(@now_sp)
    end
  end
  def refresh
    @desthp = @actor.hp
    @destsp = @actor.sp
    back = RPG::Cache.windowskin(XRXS73::AS_BACK)
    @baspace.bitmap.clear
    @baspace.bitmap.blt(0,   0, back, back.rect)
    @baspace.bitmap.blt(0,  96, @bar_skin, Rect.new(0,0,@w,@h))
    #
    state_icon_names = []
    for state_id in @actor.states.sort
      icon_name = XRXS73::STATE_ICON[state_id]
      if icon_name != nil
        state_icon_names.push(icon_name)
      end
    end
    if not state_icon_names.empty?
      ix = 2
      for icon_name in state_icon_names
        icon = RPG::Cache.icon(icon_name)
        @baspace.bitmap.blt(ix, 36, icon, icon.rect)
        ix += 28
        break if ix >= 102
      end
    end
  end
  def x=(n)
    @baspace.x      = n
    @sprite_hp.x    = n + 50
    @sprite_sp.x    = n + 66
    @sprite_hpbar.x = n
  end
  def y=(n)
    @baspace.y      = n
    @sprite_hp.y    = n +  77
    @sprite_sp.y    = n + 102
    @sprite_hpbar.y = n +  96
  end
  def dispose
    @sprites.each{|sprite| sprite.dispose }
  end
end
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs73_initialize initialize
  def initialize
    @actorstatus_sprites = []
    for actor in $game_party.actors
      @actorstatus_sprites.push(ActorStatus_SpriteSet.new(actor))
    end
    # 呼び戻す
    xrxs73_initialize
    # 背景を消す
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ [再定義]
  #--------------------------------------------------------------------------
  def refresh
    # 最大確保人数の取得
    max = XRXS73::MAX
    @item_max = $game_party.actors.size
    #
    self.contents.clear
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      width = [self.width*3/4 / max, 80].max
      space = self.width / max
      case XRXS73::ALIGN
      when 0
        actor_x = i * space + 4
      when 1
        actor_x = (space * ((max - $game_party.actors.size)/2.0 + i)).floor
      when 2
        actor_x = (i + max - $game_party.actors.size) * space + 4
      end
      actor_x += self.x
      @actorstatus_sprites[i].x = self.x + 16 + actor_x
      @actorstatus_sprites[i].y = self.y + 16
      @actorstatus_sprites[i].refresh
      # バトルステータスの描写
      draw_battlestatus(i, actor_x, width)
    end
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @actorstatus_sprites.each{|spriteset| spriteset.update }
    return
  end
  def dispose
    @actorstatus_sprites.each{|spriteset| spriteset.dispose }
    super
  end
  #--------------------------------------------------------------------------
  # ○ バトルステータスの描写
  #--------------------------------------------------------------------------
  def draw_battlestatus(i, x, width)
    # アクターの取得
    actor = $game_party.actors[i]
  end
end

