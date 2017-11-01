#=============================================================================
# * SFonts
#=============================================================================
# Trickster
# Version 1.0
# 12.19.07
#=============================================================================
# Introduction
#  - This script adds SFont support for rmxp. An sfont is a image file with
#    characters already drawn onto it. The top row of pixels in this image shows
#    where the characters are and where the breaks are.
# Setting up images
#  - The top left hand pixel (0, 0) is the skip color and tells if a column
#    of pixels is empty or contain data
#  - Images should be placed in Graphics/SFonts
#  - For more reference see the example image Arial_Red
# To Use
#  - You can use this script in one of two ways
#    - 1) Set <Bitmap>.sfont to an SFont object then call <Bitmap>.draw_text
#    - 2) Call <SFont>.render(<String>) and then blt it to a Bitmap object
# Documentation
#  - SFont.new(<String/Bitmap>, <Array>, <Integer/String>)
#  - Where the first parameter is a filename (in Graphics/SFonts) or a Bitmap 
#     object containing the Font data
#  - the second parameter is an Array of all of the characters in order in the
#    file the default is specified in @@glyphs below you
#  - the last parameter is either the width that should be used for the space 
#    character or the character whose width you want to use for the space 
#    character the default is " which is the width of the " character if "
#    character is not in the glyph then the height of the bitmap will be used
# Credits
#  - John Croisant for the original code for Rubygame which I used as a base for
#    this script
#  - Adam Bedore for the example sfont image more of his sfont work is given
#    here - http://www.zlurp.com/irq/download.html
# Websites
#  - Official SFont Page with sample fonts - http://www.linux-games.com/sfont
#  - SFont generator utility - http://www.nostatic.org/sfont
#  - SFont generator script for GIMP by Roger Feese
#       http://www.nostatic.org/sfont/render-sfont22.scm
#=============================================================================

module RPG
module Cache
  #--------------------------------------------------------------------------
  # * SFont Load
  #--------------------------------------------------------------------------
  def self.sfont(file)
    self.load_bitmap("Graphics/SFonts/", file)
  end
end
end

class SFont
  #--------------------------------------------------------------------------
  # * Class Variables
  #--------------------------------------------------------------------------
  @@glyphs = [
    "!",'"',"#","$","%","&","'","(",")","*","+",",","-",".","/","0",
    "1","2","3","4","5","6","7","8","9",":",";","<","=",">","?","@",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
    "Q","R","S","T","U","V","W","X","Y","Z","[","\\","]","^","_","`",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p",
    "q","r","s","t","u","v","w","x","y","z","{","|","}","~"
    ]
  #--------------------------------------------------------------------------
  # * Get Glyphs
  #--------------------------------------------------------------------------
  def SFont.glyphs
    return @@glyphs
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(file, glyphs = @@glyphs, space = '"')
    if file.is_a?(String)
      bitmap = RPG::Cache.sfont(file)
    elsif file.is_a?(Bitmap)
      bitmap = file
    else
      raise(ArgumentError, "File Must be a String or Bitmap")
    end
    
    @height = bitmap.height
    @skip = bitmap.get_pixel(0, 0)
    @glyphs = {}
    
    x = 2
    glyphs.each {|char| x = load_glyph(bitmap, char, x)}
    
    unless glyphs.include?(' ')
      if space.ia_a?(Numeric)
        space = space.to_i
      elsif space.is_a?(String)
        if glyphs.include?(space)
          space = @glyphs[space].width
        elsif !@glyphs['"'].nil?
          space = @glyphs['"'].width
        else
          space = bitmap.height
        end
      else
        raise(ArgumentError, "Space must be either a String or Numeric")
      end
      @glyphs[" "] = Bitmap.new(space, @height)
    end
    @glyphs.default = @glyphs[" "]
  end
  #--------------------------------------------------------------------------
  # * Text Size
  #--------------------------------------------------------------------------
  def text_size(text)
    width = 0
    text.each_byte {|byte| width += @glyphs["%c" % byte].width}
    return width
  end
  #--------------------------------------------------------------------------
  # * Render
  #--------------------------------------------------------------------------
  def render(text)
    width = text_size(text)
    bitmap = Bitmap.new(width, @height)
    x = 0
    text.each_byte do |byte|
      glyph = @glyphs["%c" % byte]
      bitmap.blt(x, 0, glyph, glyph.rect)
      x += glyph.width
    end
    return bitmap
  end
  #--------------------------------------------------------------------------
  # * Private: Load glyph
  #--------------------------------------------------------------------------
  private
  def load_glyph(bitmap, char, xi)
    while bitmap.get_pixel(xi, 0) == @skip && xi < bitmap.width
      xi += 1
    end
    return -1 if xi >= bitmap.width
    xf = xi
    while bitmap.get_pixel(xf, 0) != @skip && xf < bitmap.width
      xf += 1
    end
    return -1 if xf >= bitmap.width
    
    rect = Rect.new(xi, 0, xf - xi, bitmap.height)
    @glyphs[char] = Bitmap.new(xf - xi, bitmap.height)
    @glyphs[char].blt(0, 0, bitmap, rect)
    
    return xf+1
  end
end