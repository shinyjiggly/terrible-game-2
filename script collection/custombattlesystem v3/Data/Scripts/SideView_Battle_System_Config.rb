=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Side View Battle System Config File 』                                   ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ as you might thought... this is a new file... it will help you to set      ┃
┃ the script even easier as before.. but it wont do everything for you ^-^   ┃
┃ one more thing... you shouldnt change stuff here...unless you want to add  ┃
┃ something... but you'll have to figure the most part on you own...         ┃
┃ so if you want to change something here you should ask in the forum...     ┃
┃ since i wont support this couse you can mess this script up when you change┃ 
┃ stuff rundomly...                                                          ┃
┃ so be warned...                                                            ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛


    @spriteset.actor_sprites[$game_party.actors[0].id].x = $game_player.screen_x
    @spriteset.actor_sprites[$game_party.actors[0].id].y = $game_player.screen_y
    
    @spriteset.actor_sprites[$game_party.actors[1].id].x = rand(100)+640
    @spriteset.actor_sprites[$game_party.actors[1].id].y = rand(100)+320
#    @spriteset.actor_sprites[$game_party.actors[2].id].x = rand(100)+640
#    @spriteset.actor_sprites[$game_party.actors[2].id].y = rand(100)+320
#    @spriteset.actor_sprites[$game_party.actors[3].id].x = rand(100)+640
#    @spriteset.actor_sprites[$game_party.actors[3].id].y = rand(100)+320
    
    @spriteset.actor_sprites[$game_party.actors[0].id]\
        .move($game_party.actors[0].screen_x,$game_party.actors[0].screen_y,10)
    
    @spriteset.actor_sprites[$game_party.actors[1].id]\
        .move($game_party.actors[1].screen_x,$game_party.actors[1].screen_y,10)
#    @spriteset.actor_sprites[$game_party.actors[2].id]\
#        .move($game_party.actors[2].screen_x,$game_party.actors[2].screen_y,10)
#    @spriteset.actor_sprites[$game_party.actors[3].id]\
#        .move($game_party.actors[3].screen_x,$game_party.actors[3].screen_y,10)




┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Character Positioning... 』                                              ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end


class Game_Actor < Game_Battler
  
  def position_x(position)
    
    # right side of the screen
    if position == "right"
      if self.index != nil
        return self.index * 40 + 460
      else
        return 0
      end
      
    # left side of the screen
    elsif position == "left"
      if self.index != nil
        if self.index == 0
          n = 4
        elsif self.index == 1
          n = 3
        elsif self.index == 2
          n = 2
        elsif self.index == 3
          n = 1
        end
        if n != nil
          return n * 23 + 60
        else
          return 0
        end
      else
        return 0
      end
      
    # top
    elsif position == "top"
      if self.index != nil
        return self.index * 64 + 225
      else
        return 0
      end
      
    # bottom
    elsif position == "bottom"
      if self.index != nil
        return self.index * 96 + 200
      else
        return 0
      end
    end 
  end
  

  def position_y(position)
    # right side of the screen
    if position == "right"
      return self.index * 20 + 260
    # left side of the screen
    elsif position == "left"
      return self.index * 30 + 230
    # top
    elsif position == "top"
      if self.index == 0
        n = 2
      elsif self.index == 1
        n = 1
      elsif self.index == 2
        n = 1
      elsif self.index == 3
        n = 2
      end
      if n != nil
        return n * 32 + 64
      end
    # bottom
    elsif position == "bottom"
      if self.index == 0
        n = 1
      elsif self.index == 1
        n = 2
      elsif self.index == 2
        n = 2
      elsif self.index == 3
        n = 1
      end
      if n != nil
        return n * 32 + 380
      end
    end    
  end
end


=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Monster Positioning... 』                                                ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end

class Game_Enemy < Game_Battler

  def position_x(position)
    # right side of the screen
    if position == "right"
      if self.index != nil
        return self.index * 40 + 460
      else
        return 0
      end
      
    # left side of the screen
    elsif position == "left"
      if self.index != nil
        if self.index == 0
          n = 4
        elsif self.index == 1
          n = 3
        elsif self.index == 2
          n = 2
        elsif self.index == 3
          n = 1
        end
        if n != nil
          return n * 23 + 60
        else
          return 0
        end
      else
        return 0
      end
      
    # top
    elsif position == "top"
      if self.index != nil
        return self.index * 64 + 225
      else
        return 0
      end
      
    # bottom
    elsif position == "bottom"
      if self.index != nil
        return self.index * 96 + 200
      else
        return 0
      end
    elsif position == "normal"
      return $data_troops[@troop_id].members[@member_index].x
    end 
  end

  def position_y(position)
    # right side of the screen
    if position == "right"
      return self.index * 20 + 260
    # left side of the screen
    elsif position == "left"
      return self.index * 30 + 230
    # top
    elsif position == "top"
      if self.index == 0
        n = 2
      elsif self.index == 1
        n = 1
      elsif self.index == 2
        n = 1
      elsif self.index == 3
        n = 2
      end
      if n != nil
        return n * 32 + 64
      end
    # bottom
    elsif position == "bottom"
      if self.index == 0
        n = 1
      elsif self.index == 1
        n = 2
      elsif self.index == 2
        n = 2
      elsif self.index == 3
        n = 1
      end
      if n != nil
        return n * 32 + 380
      end
    elsif position == "normal"
      return $data_troops[@troop_id].members[@member_index].y
    end 
  end
end


=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Spriteset Config...for the battlefield 』                                ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end
class Spriteset_Battle
  
  def battle_background(background)
    if background == "full"
      if @battleback_name != $game_temp.battleback_name
        @battleback_name = $game_temp.battleback_name
        if @battleback_sprite.bitmap != nil
          @battleback_sprite.bitmap.dispose
        end
        @battleback_sprite.bitmap = RPG::Cache.battleback(@battleback_name)
        @battleback_sprite.src_rect.set(0, 0, 640, 480)
        
        if $FOG_E or $FOG_A
          @battleback_sprite.bush_depth = 150
        end
        
        if @battleback_sprite.bitmap.height == 320
          @battleback_sprite.zoom_x = 1.5
          @battleback_sprite.zoom_y = 1.5
          @battleback_sprite.x = 320
          @battleback_sprite.y = 480
          @battleback_sprite.ox = @battleback_sprite.bitmap.width / 2
          @battleback_sprite.oy = @battleback_sprite.bitmap.height
        else
          
          if $FOG_E or $FOG_A
            @battleback_sprite.bush_depth = 150
          end
          #@battleback_sprite.blend_type = 1
          
          @battleback_sprite.x = 0
          @battleback_sprite.y = 0
          @battleback_sprite.ox = 0
          @battleback_sprite.oy = 0
          @battleback_sprite.zoom_x = 1
          @battleback_sprite.zoom_y = 1
        end
      end
    elsif background == "normal"
      if @battleback_name != $game_temp.battleback_name
        @battleback_name = $game_temp.battleback_name
        if @battleback_sprite.bitmap != nil
          @battleback_sprite.bitmap.dispose
        end
        @battleback_sprite.bitmap = RPG::Cache.battleback(@battleback_name)
        @battleback_sprite.src_rect.set(0, 0, 640, 320)
        #if $FOG_E or $FOG_A
          @battleback_sprite.bush_depth = 150
          @battleback_sprite.blend_type = 0
        #end
        
      end
    end

  end
end

=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Spriteset Config...for the Characters and Monsters 』                    ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end
class Sprite_Battler < Animated_Sprite

end
