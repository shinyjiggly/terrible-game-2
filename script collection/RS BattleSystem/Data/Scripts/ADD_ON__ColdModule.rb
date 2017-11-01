################################################################################
################################################################################
########################### Cold Module ########################################
################################################################################
################################################################################
#===============================================================================
# By Cold Strong
#===============================================================================
# Cold Module
#-------------------------------------------------------------------------------
# This script count some functions used by my scripts
# Obs: It is some imcomplete...
#===============================================================================

class Customs_Data
  
  attr_accessor  :actors        
  attr_accessor  :classes      
  attr_accessor  :skills        
  attr_accessor  :items        
  attr_accessor  :weapons      
  attr_accessor  :armors        
  attr_accessor  :enemies      
  attr_accessor  :troops        
  attr_accessor  :states      
  attr_accessor  :animations    
  attr_accessor  :tilesets      
  attr_accessor  :common_events 
  attr_accessor  :system
  attr_accessor  :map_infos
  attr_accessor  :maps
  
  def initialize
    @actors        = load_data("Data/Actors.rxdata")
    @classes      = load_data("Data/Classes.rxdata")
    @skills        = load_data("Data/Skills.rxdata")
    @items        = load_data("Data/Items.rxdata")
    @weapons      = load_data("Data/Weapons.rxdata")
    @armors        = load_data("Data/Armors.rxdata")
    @enemies      = load_data("Data/Enemies.rxdata")
    @troops        = load_data("Data/Troops.rxdata")
    @states        = load_data("Data/States.rxdata")
    @animations    = load_data("Data/Animations.rxdata")
    @tilesets      = load_data("Data/Tilesets.rxdata")
    @common_events = load_data("Data/CommonEvents.rxdata")
    @system        = load_data("Data/System.rxdata")
    @maps = {}
    for i in 1..999
      number = sprintf("%03d", i)
      if FileTest.exist?("Data/Map#{number}.rxdata")
        @maps[i] = load_data("Data/Map#{number}.rxdata")
      else
        break
      end
    end
    @map_infos    = load_data("Data/MapInfos.rxdata")
  end
  
  def [](str)
    return @customs_data[str]
  end
  
end

module Cold
  
  $data = Customs_Data.new
  
end

class Window_Base < Window
  
  
  #--------------------------------------------------------------------------
  # - Desenhar GrÃ¡fico
  #
  #    t    : Texto a ser feita as linhas
  #    width : Largura mÃ¡xima da linha
  #    
  #    - Ele retorna uma array, em que cada elemento Ã© uma string
  #      com a largura desejada.
  #--------------------------------------------------------------------------
  
  def lines(t, width)
    text = t.clone
    x = self.contents.text_size(text).width / width
    x += 1 if self.contents.text_size(text).width % width > 0 
    texts = [] 
    for i in 0...x
      texts.push("")
    end
    for i in 0...texts.size
      words = text.split(" ")
      return_text = ""
      for w in 0...words.size
        word = words[w]
        x = "!@$%Â¨&*()"
        return_text += word + x + " "
        return_text2 = return_text.gsub(x,"")
        t_width = self.contents.text_size(return_text2).width
        if t_width > width
          texts[i] = return_text.gsub(" "+word+x, "")
          text.gsub!(texts[i], "")
          break
        elsif w == words.size - 1
          texts[i] = return_text.gsub(x+" ", "")
          text.gsub!(texts[i], "")
          break
        else
          return_text.gsub!(word+x, word)
        end
      end
    end
    return texts
  end
  
  def draw_text_in_lines(x, y_initial, width, height, text)
    lines = lines(text, width)
    y = y_initial
    for text_line in lines
      self.contents.draw_text(x, y, width, height, text_line)
      y += height
    end
  end
    
end