#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# [Xp] DRG - Flip Animation
# Version: 1.10
# Author : LiTTleDRAgo
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#
# How to use
#
# Type in the script call
#
#     $game_temp.animation_flip = true/false
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
class RPG::Sprite < ::Sprite
  alias drg_anim3_23 animation_set_sprites if !method_defined?(:drg_anim3_23)
  def animation_set_sprites(s, c, p)
    drg_anim3_23(s, c, p)
    a = $game_temp.animation_flip
    (0..15).each {|i| s[i].mirror = (a ? (c[i,5] != 1) : (c[i,5] == 1))
      s[i].x += -(c[i,1] * 2) if a && c[i,1] != nil }
  end
end
  
class Game_Temp; attr_accessor :animation_flip end