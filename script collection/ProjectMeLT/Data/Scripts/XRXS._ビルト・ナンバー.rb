# ▼▲▼ XRXS. ビルト・ナンバー ▼▲▼
# by 桜雅 在土
#
#==============================================================================
# □ Bitmapライブラリ --- blt_number ---
#==============================================================================
class Bitmap
  def blt_number(x, y, skin, number, place = 4, opacity = 224)
    a_width = skin.rect.width / 10
    rect = Rect.new(0, 0, a_width, skin.rect.height)
    #
    numbers = [number/1000%10, number/100%10, number/10%10, number%10]
    display = false
    for i in 0...numbers.size
      n = numbers[i]
      display |= (n != 0 or i == numbers.size - 1)
      if display
        rect.x = n * a_width
        self.blt(x, y, skin, rect, opacity)
      end
      x += a_width
    end
  end
end
