=begin
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃Full Animated Side View Battle System (CBS) (v3 - Beta)          by cybersam┃
┃                                                                            ┃
┃                                                                            ┃
┃                                                                            ┃
┃  Modified version for the JAP Level Up Script...                           ┃
┃  the level up script is modified too                                       ┃
┃  so be sure to use that one too...                                         ┃
┃  else you wont have a winning pose or you'll get an error...               ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ here we go...                                                              ┃
┃ this makes the script very easy to implement                               ┃
┃ just add a new script above the "Main" script                              ┃
┃ and insert this whole thing in there                                       ┃
┃                                                                            ┃
┃ as you can see the sprite changing code is from the japanese script        ┃
┃ so the credits for the sprite changin goes to them....                     ┃
┃ i edit it a little so it can show more sprites and sprite animations       ┃
┃ and added some other stuff... the next things are player movement...       ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ i got the battler changing script in this script...                        ┃
┃ the credits for this goes to the guy who made this...                      ┃
┃                                                                            ┃
┃ ▼▲▼ XRXS11. 戦闘・バトラーモーション ver.0 ▼▲▼                       ┃
┃                                                                            ┃
┃ since this isnt used anymore... it isnt need for credit anymore...         ┃
┃ but i'll let it here since it helped me a lot...                           ┃
┃                                                                            ┃
┃                                                                            ┃
┃ as for the ideas... missy provided me with realy good ideas                ┃
┃ that helped me alot when i didnt find a way to some of these features...   ┃
┃                                                                            ┃
┃ here one more Credit to place...                                           ┃
┃ its RPG's script...                                                        ┃
┃ not the whole thing here...                                                ┃
┃ but some snipplet you'll know witch one when read the comments             ┃
┃                                                                            ┃
┃                                                                            ┃
┃ if you want some more explaines about this script...                       ┃
┃ the most stuff are commented... but if you still have questions or         ┃
┃ sugestions then you can contact me                                         ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ how or where you can contact me...                                         ┃
┃ at the http://www.rmxp.net forum via pm, email: cybersam@club-anime.de     ┃
┃ or via AIM: cych4n or ICQ: 73130840                                        ┃
┃                                                                            ┃
┃ remember this is still in testing phase...                                 ┃
┃ and i'm trying to work on some other additions... like character movements ┃
┃ but that wont be added now... couse i need to figure it out first...       ┃
┃                                                                            ┃
┃                                                                            ┃
┃                                                                            ┃
┃ oh hehe.... before i forget...                                             ┃
┃ sorry for the bad english... ^-^''''                                       ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ ok... here... since i'm using RPG's movement script...                     ┃
┃ there are a lot of changes...                                              ┃
┃                                                                            ┃
┃ when you look at the script you'll find the line                           ┃
┃ with "pose(n)" or "enemy_pose(n)"                                          ┃
┃ since i want my sprites have different sprites... i added one more option  ┃
┃ to these...                                                                ┃
┃ so now if you add a number after the n                                     ┃
┃ (the n stands for witch sprite is used)                                    ┃
┃ fo example 8...                                                            ┃
┃ ("pose(4, 8)") this will tell the script that the 4th animation            ┃
┃ have 8 frames...                                                           ┃
┃ pose is used for the player... and enemy_pose for the enemy...             ┃
┃ there is nothing more to this...                                           ┃
┃ i used my old sprite numbers... (this time in only one sprite...)          ┃
┃                                                                            ┃
┃ explains about the animation sprites... (the digits)                       ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ 0 = move (during battle)                                                   ┃
┃ 1 = standby                                                                ┃
┃ 2 = defend                                                                 ┃
┃ 3 = hit (being attacked)                                                   ┃
┃ 4 = attack                                                                 ┃
┃ 5 = skill use                                                              ┃
┃ 6 = dead                                                                   ┃
┃ 7 = winning pose... this idea is from RPG....                              ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ of course this is just the begining of the code...                         ┃
┃ so more animations can be implemented...                                   ┃
┃ but for now this should be enough...                                       ┃
┃                                                                            ┃
┃ alot has changed here... and now it looks like it is done...               ┃
┃ of course the fine edit needs to be done so it looks and works great       ┃
┃ with your game too...                                                      ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ 1st   character movement...                             done               ┃
┃ 2rd   character apears at the enemy while attacking...  done               ┃
┃       / replaced with movement animation                                   ┃
┃                                                                            ┃
┃ 3nd   character movement during attack...               done               ┃
┃                                                                            ┃
┃ 4th   enemies movement...                               done               ┃
┃ 5th   enemy apears at the enemy while attacking...      done               ┃
┃       / replaced with movement animation                                   ┃
┃                                                                            ┃
┃ 6th   enemy movement during attack...                   done               ┃
┃                                                                            ┃
┃ 7th   each weapon has its own animation...              done               ┃
┃ 8th   each skill has its own animation...               done               ┃
┃ 9th   different poses for sickness or low hp            done               ┃
┃                                                                            ┃
┃ 10th  automaticly select the sprite...                  done               ┃
┃ 11th  Fullbackground                                    implemented (done) ┃
┃                                                                            ┃
┃ 12th  diagonal movement                                 done               ┃
┃ 12th  diagonal movement                                 done               ┃
┃                                                                            ┃
┃ bugfixes and code cleaning/improvements....             ----               ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ for some customfixes look in the rmxp.net forum...                         ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛




┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃『 Config 』                                                                ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ okay... this is something new...                                           ┃
┃ here in this section you can change the most things for this script...     ┃
┃                                                                            ┃
┃ like where the characters are possitioned                                  ┃
┃ top, right, bottom, left                                                   ┃
┃ these are the default ones... of course you can add more you can find these┃
┃ in the new file right below this script...                                 ┃
┃                                                                            ┃
┃ of course thats not the only thing you can set... ^-^                      ┃
┃                                                                            ┃
┃ you can change the movement stuff... like moving normal                    ┃
┃ (as you know it from the original script)                                  ┃
┃ or move just a little bit forward (like FF6 and such)                      ┃
┃ no moving at all... (with this you'll have to set another point...         ┃
┃ so you can have the character apears near the enemy or just staying there  ┃
┃                                                                            ┃
┃ well there will be to much to list all here, you see them in next few lines┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ character_position =     here you can set the character positions          ┃
┃                          -> top, right, bottom, left                       ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ monster_position   =      here you can set the position for the            ┃
┃                           monsters...                                      ┃
┃                           -> normal (this way you can set the monster      ┃
┃                                      position in the database)             ┃
┃                           -> top, right, bottom, left                      ┃
┃                           i setted these only for 4 characters...          ┃
┃                           so if you have more monsters then it will        ┃
┃                           look very ugly... ^-^'''                         ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ background         =      here you can set the battlebackground            ┃
┃                           to fullscreen or use the default                 ┃
┃                           background size                                  ┃
┃                           -> full, normal                                  ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ fog                =      here is something new to the battle systems      ┃
┃                           this is normaly not to see in the battlefield    ┃
┃                           so i added this... well...                       ┃
┃                           it needs some adjustments couse it doesnt        ┃
┃                           look very good...                                ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ sprite_name        =      here you can set the sprite_name how you         ┃
┃                           want to add it... if you have fixed names        ┃
┃                           for your character (means that you cant change   ┃
┃                           them in game...                                  ┃
┃                           then let it as it is...                          ┃
┃                           if not... change it to "id"                      ┃
┃                           that means the sprite names is selected from     ┃
┃                           their id's                                       ┃
┃                                                                            ┃
┃                           if you select id then you'll have to rename      ┃
┃                           your sprites to this                             ┃
┃                                                                            ┃
┃                           for characters                                   ┃
┃                           actor_#  (# = id number...                       ┃
┃                                     for the id no. look in your database)  ┃
┃                                                                            ┃
┃                           for monsters/enemies                             ┃
┃                           enemy_# (# = id number...                        ┃
┃                                    here again loon in the database)        ┃
┃                                                                            ┃
┃                           here again from what you can select              ┃
┃                           -> name, id, battler                             ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end

  $CHARACTER_POS    = "right"
  $MONSTER_POS      = "left"
  $BACKGROUND       = "normal"
  $FOG              = "on"
  $SPRITE_NAME      = "battler"
  
  
  
  
  
  
  
  
  
  
  
  module RPG
  module Cache
    def self.battler_cbs(filename, hue, battler)
      @battler = battler
      if @battler.is_a?(Game_Enemy)
        if $SPRITE_NAME == "id"
          self.load_bitmap("Graphics/Battlers/enemy/enemy_", filename, hue)
        else
          self.load_bitmap("Graphics/Battlers/enemy/", filename, hue)
        end
      else
        if $SPRITE_NAME == "id"
          self.load_bitmap("Graphics/Battlers/actor/actor_", filename, hue)
        else
          self.load_bitmap("Graphics/Battlers/actor/", filename, hue)
        end
      end
    end
  end
end

  
  
  
  
  
  
  
  
  
  
  
  
  
  
=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Positioning the Characters 』                                            ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end

class Game_Actor < Game_Battler
  
=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ you dont have to change your game actor to let the characters schows       ┃
┃ from the side...                                                           ┃
┃ this will do it for you... ^-^                                             ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end


  def screen_x
    position_x($CHARACTER_POS)
  end

  def screen_y
    position_y($CHARACTER_POS)
  end
  
  def screen_z
    if self.index != nil
      return self.index
    else
      return 0
    end
  end
end


=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Positioning the Monsters 』                                              ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end

class Game_Enemy < Game_Battler
  
=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃well... this is new as well... since you can change the position for        ┃
┃the monsters in the database i didnt add this...                            ┃
┃but now you can set the them here aswell...                                 ┃
┃same as for the charasters only that you have the "normal" option...        ┃
┃this means that you can set the position from the database...               ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end


  def screen_x
    position_x($MONSTER_POS)
  end

  def screen_y
    position_y($MONSTER_POS)
  end
end


=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Spritesets 』                                                            ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end

class Spriteset_Battle

  
  attr_accessor :actor_sprites
  attr_accessor :enemy_sprites


=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃so here we have the sprite set...                                           ┃
┃you might have realized.. we have here more stuff...                        ┃
┃like new viewports and such...                                              ┃
┃                                                                            ┃
┃and i have removed some comments and some names...                          ┃
┃since most of you guys know who they are and what they did for this script  ┃
┃their names will be found in the credit section... and in the introducion   ┃
┃text at the top of this script                                              ┃
┃                                                                            ┃
┃you might also have seen the marked out ".reverse" this is due to a bug...  ┃
┃this is fixed a very long time ago so i realy dont have to let it there...  ┃
┃but so you know what makes trouble if you want to remake this script or if  ┃
┃you want to make your own sideview battle system...                         ┃
┃                                                                            ┃
┃the new viewports (0 and 5)                                                 ┃
┃                                                                            ┃
┃the 0 viewport is for the background so it doesnt interfere with the actual ┃
┃battle now you can do what ever you want with the background...             ┃
┃but remember the number for the background isnt 1 it is 0 (couse most of the┃
┃scripts uses the original settings...)                                      ┃
┃                                                                            ┃
┃the viewport 5 is for the weather...                                        ┃
┃you're probably asking why do i need to set the weather to its own viewport ┃
┃well... as in the default settings it would be behind the characters...     ┃
┃so now it have its own place and it stays on top...                         ┃
┃                                                                            ┃
┃the character viewport (2) is now toned too when you use tone effects...    ┃
┃it wasnt in the default system so the tone effect didnt had any effects     ┃
┃on the character                                                            ┃
┃                                                                            ┃
┃one more thing that is new is the fog... now you can set to have a fog in   ┃
┃in your battlefield... but atm... it doesnt look very good... but you still ┃
┃can play around with it... of course you can just deactivate it if you dont ┃
┃like it ^-^                                                                 ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end
  
  def initialize
    
    @viewport_fog = Viewport.new(0, 0, 640, 480)
    @viewport0    = Viewport.new(0, 0, 640, 480)
    @viewport1    = Viewport.new(0, 0, 640, 480)
    @viewport2    = Viewport.new(0, 0, 640, 480)
    @viewport3    = Viewport.new(0, 0, 640, 480)
    @viewport4    = Viewport.new(0, 0, 640, 480)
    @viewport5    = Viewport.new(0, 0, 640, 480)
    
    @viewport1.z = 50
    @viewport2.z = 50
    @viewport3.z = 200
    @viewport4.z = 5000
    @viewport5.z = 4000
    @viewport_fog.z = 0

    @battleback_sprite = Sprite.new(@viewport0)
    
    @enemy_sprites = []
    for enemy in $game_troop.enemies
      @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
    end
    
    @actor_sprites = []
    for actor in $game_party.actors
      @actor_sprites.push(Sprite_Battler.new(@viewport2, actor))
    end
    #@actor_sprites.push(Sprite_Battler.new(@viewport2))
    #@actor_sprites.push(Sprite_Battler.new(@viewport2))
    #@actor_sprites.push(Sprite_Battler.new(@viewport2))
    #@actor_sprites.push(Sprite_Battler.new(@viewport2))
    
    @weather = RPG::Weather.new(@viewport5)
    @picture_sprites = []
    for i in 51..100
      @picture_sprites.push(Sprite_Picture.new(@viewport3,
        $game_screen.pictures[i]))
    end
    
    if $FOG == "on"
      @fog_e = Plane.new(@viewport_fog)
      @fog_a = Plane.new(@viewport_fog)
      $FOG_E = true
      $FOG_A = true
    end
      
    @timer_sprite = Sprite_Timer.new
    update
  end
  
  def dispose
    
    if @battleback_sprite.bitmap != nil
      @battleback_sprite.bitmap.dispose
    end
    @battleback_sprite.dispose
    for sprite in @enemy_sprites + @actor_sprites
      sprite.dispose
    end
    @weather.dispose
    for sprite in @picture_sprites
      sprite.dispose
    end
    
    if $FOG == "on"
      @fog_e.dispose
      @fog_a.dispose
    end
    
    @timer_sprite.dispose
    @viewport0.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
    @viewport4.dispose
    @viewport5.dispose
    @viewport_fog.dispose
  end
  
  #alias cybersam_CBS_update update
  def update
    #cybersam_CBS_update
    
    @viewport1.z = 50 and @viewport2.z = 51 if $actor_on_top == true
    @viewport1.z = 51 and @viewport2.z = 50 if $actor_on_top == false
    
    #@actor_sprites[0].battler = $game_party.actors[0]
    #@actor_sprites[1].battler = $game_party.actors[1]
    #@actor_sprites[2].battler = $game_party.actors[2]
    #@actor_sprites[3].battler = $game_party.actors[3]
    
    battle_background($BACKGROUND)
    
    for sprite in @enemy_sprites + @actor_sprites
      sprite.update
    end
    
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.update
    
    if $FOG == "on"
      if @fog_name != $game_map.fog_name or @fog_hue != $game_map.fog_hue
        @fog_name = $game_map.fog_name
        @fog_hue = $game_map.fog_hue
        
        if @fog_e.bitmap != nil
          @fog_e.bitmap.dispose
          $FOG_E = false
          @fog_e.bitmap = nil
        end
        if @fog_name != ""
          @fog_e.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
          $FOG_E = true
        end
        
        if @fog_a.bitmap != nil
          @fog_a.bitmap.dispose
          $FOG_E = false
          @fog_a.bitmap = nil
        end
        if @fog_name != ""
          @fog_a.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
          $FOG_A = true
        end
        
        Graphics.frame_reset
      end
      
      @fog_e.zoom_x = $game_map.fog_zoom / 100.0
      @fog_e.zoom_y = $game_map.fog_zoom / 100.0
      @fog_e.opacity = 200 #$game_map.fog_opacity / 2
      @fog_e.blend_type = $game_map.fog_blend_type
      @fog_e.ox = $game_map.display_x / 4 + $game_map.fog_ox
      @fog_e.oy = $game_map.display_y / 4 + $game_map.fog_oy
      @fog_e.tone = $game_map.fog_tone
      @fog_e.blend_type = 1
      
      @fog_a.zoom_x = $game_map.fog_zoom / 100.0
      @fog_a.zoom_y = $game_map.fog_zoom / 100.0
      @fog_a.opacity = 0#$game_map.fog_opacity / 2
      @fog_a.blend_type = $game_map.fog_blend_type
      @fog_a.ox = $game_map.display_x / 4 + $game_map.fog_ox
      @fog_a.oy = $game_map.display_y / 4 + $game_map.fog_oy
      @fog_a.tone = $game_map.fog_tone
      
      
    end
    
    for sprite in @picture_sprites
      sprite.update
    end
    
    @timer_sprite.update
    
    @viewport0.tone     = $game_screen.tone
    @viewport1.tone     = $game_screen.tone
    @viewport2.tone     = $game_screen.tone
    @viewport_fog.tone  = $game_screen.tone
    
    @viewport0.ox = $game_screen.shake
    @viewport1.ox = $game_screen.shake
    @viewport2.ox = $game_screen.shake
    
    @viewport4.color = $game_screen.flash_color
    
    @viewport0.update
    @viewport1.update
    @viewport2.update
    @viewport4.update
    @viewport5.update
    @viewport_fog.update
  end
end





=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Sprites for the Battler (Monsters and Characters 』                      ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛


┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ well... i'll try to rewrite some of these comments from the start...       ┃
┃ it didnt change much here... so there isnt much to write about...          ┃
┃ and why should write much when the most part didnt even bother to read...  ┃
┃ well... anyway... i'll go ahead and change some stuff... ^-^               ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end

class Sprite_Battler < Animated_Sprite

  attr_accessor :battler
  attr_reader   :index
  attr_accessor :frame_width

  
  def initialize(viewport, battler = nil)
    super(viewport)
    @viewport = viewport
    @battler = battler
    @index = 0

    # this small little fix is for the battle animations (effects)
    # here you can set if you want to see these effects while in the 
    # winning pose of not...
    $noanimation = false

    if @battler.is_a?(Game_Enemy)
      @enemy_id = @battler.id
    end
      
    if @battler.is_a?(Game_Actor)
      @actor_id = @battler.id
    end
    
    @frame_width, @frame_height = frame_size(),frame_size()

    @battler.is_a?(Game_Enemy) ? enemy_pose(1) : pose(1)
    
    
    @battler_visible = false
  end
  
  def index=(index) 
    @index = index   
    update           
  end                
  
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end

  
  def frame_size()
    
    if $SPRITE_NAME == "name"
      @sprite_name = @battler.name
    elsif $SPRITE_NAME == "id"
      @sprite_name = @battler.id.to_s
    elsif $SPRITE_NAME == "battler"
      @sprite_name = @battler.battler_name
    end
    
    @battler.is_a?(Game_Enemy) ? name = "enemy_" : name = "actor_"
       
    @battler_hue = @battler.battler_hue
    if $SPRITE_NAME == "id"
      @battler_name = @battler.id.to_s
    elsif $SPRITE_NAME == "name"
      @battler_name = @battler.name
    elsif $SPRITE_NAME == "battler"
      @battler_name = @battler.battler_name
    end
    
    self.bitmap = RPG::Cache.battler_cbs(@battler_name, @battler_hue, @battler)
    frame_size = bitmap.width / 4
    
      self.x = @battler.screen_x
      self.y = @battler.screen_y
      self.z = @battler.screen_z
      
      self.ox = frame_size / 2
      self.oy = frame_size
    return frame_size
  end
    
        

=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃ here you can change or add your sprite pose...                             ┃
┃ if you want a animation not to loop then look at the attack pose and make  ┃
┃ your new pose look the same as the attack pose... you should keep in mind  ┃
┃ that the "4" is for the position of the pose in your sprite                ┃
┃(its the 5th position)                                                      ┃
┃default frameset is 4... but you can change it if you like... as mentioned  ┃
┃in the introducion (in the top of this script) you can make each pose have  ┃
┃its own frameset... for this you'll have to edit the actual command where   ┃
┃the poses are seted... fir that you'll have to scroll down to the actual    ┃
┃battle section...                                                           ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛


┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Character Pose 』                                                        ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end
  def pose(number, frames = 4)
    case number
    when 0  # run
      change(frames, 5, 0, 0, 0)
    when 1  # standby
      change(frames, 5, 0, @frame_height)
    when 2 # defend
      change(frames, 5, 0, @frame_height * 2)
    when 3 # Hurt, loops
      change(frames, 5, 0, @frame_height * 3)
    when 4 # attack no loop
      change(frames, 5, 0, @frame_height * 4, 0, true)
    when 5 # skill
      change(frames, 5, 0, @frame_height * 5)
    when 6 # death
      change(frames, 5, 0, @frame_height * 6)
    when 7 # no sprite
      change(frames, 5, 0, @frame_height * 7)
    #when 8
    # change(frames, 5, 0, @frame_height * 8)
    # ...etc.
    else
      change(frames, 5, 0, 0, 0)
    end
  end
  
=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Monster / Enemy Pose 』                                                  ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛
=end
  def enemy_pose(number ,enemy_frames = 4)
    case number
    when 0  # run
      change(enemy_frames, 5, 0, 0, 0)
    when 1  # standby
      change(enemy_frames, 5, 0, @frame_height)
    when 2 # defend
      change(enemy_frames, 5, 0, @frame_height * 2)
    when 3 # Hurt, loops
      change(enemy_frames, 5, 0, @frame_height * 3)
    when 4 # attack
      change(enemy_frames, 5, 0, @frame_height * 4, 0, true)
    when 5 # skill
      change(enemy_frames, 5, 0, @frame_height * 5)
    when 6 # death
      change(enemy_frames, 5, 0, @frame_height * 6)
    when 7 # no sprite
      change(enemy_frames, 5, 0, @frame_height * 7)
    # ...etc.
    else
      change(enemy_frames, 5, 0, 0, 0)
    end
  end

  
=begin
┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃『 Low HP or differen State Pose 』                                         ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛



┏──────────────────────────────────────┓
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃Low HP                                                                      ┃
┃                                                                            ┃
┃here as you can see below the low hp is set to 4 differen poses...          ┃
┃1st the normal pose (the we already know... the standby pose)               ┃
┃2nd a pose when you hav 75% or less hp                                      ┃
┃3rd the pose for 50% or less hp                                             ┃
┃4th and the last is set to 25% or less hp                                   ┃
┃                                                                            ┃
┃NOTE: the % numbers are setted from low to high ... so it wont stay on one  ┃ 
┃pose...                                                                     ┃
┃when you scroll down you'll see it like this                                ┃
┃100%(normalpose)->25%->50%->75%                                             ┃
┃the normal pose will be always in that place if you change it then          ┃
┃this whole part wont work correctly...                                      ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┣──────────────────────────────────────┫
┃……………………………………………………………………………………………………┃
┃                                                                            ┃
┃Different State                                                             ┃
┃                                                                            ┃
┃here i didnt set new poses couse i dont have these... and i cant draw or    ┃
┃make sprites... so i seted them to normal poses (same goes for the low hp)  ┃
┃here you can add more states if you have more in your database (you dont    ┃
┃have to...) but if you want to use it then you'll have to change/add more   ┃
┃statesi think there is nothing more to say to this...                       ┃
┃only one thing that is... if you want to add more states then look first    ┃
┃in your database and write down the id numbers and the name of those so     ┃
┃you dont forget them and then you can add them easily...                    ┃
┃                                                                            ┃
┃……………………………………………………………………………………………………┃
┗──────────────────────────────────────┛

=end
  def default_pose
    pose(1) # 100% / normal state
    
    if (@battler.hp * 100) /@battler.maxhp  < 25    # 25%
      pose(1)
    elsif (@battler.hp * 100) /@battler.maxhp  < 50 # 50%
      pose(1)
    elsif (@battler.hp * 100) /@battler.maxhp  < 75 # 75%
      pose(1)
    end
    
    
    if @battler.state?(3) # poison
      pose(1)
    elsif @battler.state?(7) #sleep
      pose(1)
    end
    
  end
  
  
  def update
    super
    
    if @battler == nil                                                      
      self.bitmap = nil                                                     
      loop_animation(nil)                                                   
      return                                                                
    end                                                                     
    
    if $SPRITE_NAME == "name"
      @sprite_name = @battler.name
    elsif $SPRITE_NAME == "id"
      @sprite_name = @battler.id.to_s
    elsif $SPRITE_NAME == "battler"
      @sprite_name = @battler.battler_name
    end
    
    if @sprite_name != @battler_name
      @battler.battler_hue != @battler_hue
      @battler.is_a?(Game_Enemy) ? name = "enemy_" : name = "actor_"
       
      @battler_hue = @battler.battler_hue
      if $SPRITE_NAME == "id"
        @battler_name = @battler.id.to_s
      elsif $SPRITE_NAME == "name"
        @battler_name = @battler.name
      elsif $SPRITE_NAME == "battler"
        @battler_name = @battler.battler_name
      end
      
      self.bitmap = RPG::Cache.battler_cbs(@battler_name, @battler_hue, @battler)
      @width = bitmap.width
      @height = bitmap.height
      self.ox = @frame_width / 2
      self.oy = @frame_height

      if @battler.dead? or @battler.hidden
        self.opacity = 0
      end
      self.x = @battler.screen_x
      self.y = @battler.screen_y
      self.z = @battler.screen_z

    end

    if $noanimation == false
      if @battler.damage == nil and
         @battler.state_animation_id != @state_animation_id
        @state_animation_id = @battler.state_animation_id
        loop_animation($data_animations[@state_animation_id])
      end
    else
      dispose_loop_animation
    end

    if @battler.is_a?(Game_Actor) and @battler_visible
      if $game_temp.battle_main_phase
        self.opacity += 3 if self.opacity < 255
      else
        self.opacity -= 3 if self.opacity > 207
      end
    end

    if @battler.blink
      blink_on
    else
      blink_off
    end

    unless @battler_visible
      if not @battler.hidden and not @battler.dead? and
         (@battler.damage == nil or @battler.damage_pop)
        appear
        @battler_visible = true
      end
      if not @battler.hidden and
         (@battler.damage == nil or @battler.damage_pop) and
         @battler.is_a?(Game_Actor)
        appear
        @battler_visible = true
      end
    end
    if @battler_visible
      if @battler.hidden
        $game_system.se_play($data_system.escape_se)
        escape
        @battler_visible = false
      end
      if @battler.white_flash
        whiten
        @battler.white_flash = false
      end
      if @battler.animation_id != 0
        animation = $data_animations[@battler.animation_id]
        animation(animation, @battler.animation_hit)
        @battler.animation_id = 0
      end
      if @battler.damage_pop
        damage(@battler.damage, @battler.critical)
        @battler.damage = nil
        @battler.critical = false
        @battler.damage_pop = false
      end
      if @battler.damage == nil and @battler.dead?
        if @battler.is_a?(Game_Enemy)
          $game_system.se_play($data_system.enemy_collapse_se) unless @dead
          #collapse
          #@battler_visible = false
          @dead = true
          pose(6)
        else
          $game_system.se_play($data_system.actor_collapse_se) unless @dead
          @dead = true
          pose(6)
        end
      else
        @dead = false
      end
    end                                                                #
  end
end


#===============================================================================
# Scene_Battle Costum  Battle System
#===============================================================================

class Scene_Battle
  
  def start_phase1
    @phase = 1
    $game_party.clear_actions
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      @spriteset.actor_sprites[i].default_pose unless actor.dead?
    end
        
    setup_battle_event
  end
  
  
  def update_phase4
    case @phase4_step
    when 1
      update_phase4_step1
    when 2
      update_phase4_step2
    when 3
      update_phase4_step3
    when 4
      update_phase4_step4
    when 5
      update_phase4_step5
    when 6
      update_phase4_step6
    when 7
      update_phase4_step7
    end
  end
  
  
  def update_phase4_step1

    @help_window.visible = false
    if judge
      return
    end
    if $game_temp.forcing_battler == nil
      setup_battle_event
      if $game_system.battle_interpreter.running?
        return
      end
    end
    if $game_temp.forcing_battler != nil
      @action_battlers.delete($game_temp.forcing_battler)
      @action_battlers.unshift($game_temp.forcing_battler)
    end
    if @action_battlers.size == 0
      start_phase2
      return
    end
    @animation1_id = 0
    @animation2_id = 0
    @common_event_id = 0
    @active_battler = @action_battlers.shift
    if @active_battler.index == nil
      return
    end
    if @active_battler.hp > 0 and @active_battler.slip_damage?
      @active_battler.slip_damage_effect
      @active_battler.damage_pop = true
    end
    @active_battler.remove_states_auto
    @status_window.refresh
    @phase4_step = 2
  end
  
  
  def make_basic_action_result
    
    if @active_battler.is_a?(Game_Actor)
      $actor_on_top = true
    elsif @active_battler.is_a?(Game_Enemy)
      $actor_on_top = false
    end
    
    if @active_battler.current_action.basic == 0
#===============================================================================
# WEAPONS START...
#===============================================================================
# 
#================================= Different Weapons with different animations
#
# this is quite simple as you can see...
# if you want to add a weapon to the animation list then look at the script below...
# and i hope you'll find out how this works...
#
#
# if not...
# here is the way...
# first thing... 
# just copy and paste "elseif @active_battler_enemy.weapon_id == ID..." 
# just after the last @weapon_sprite....
# 
# here the ID is you need to look in you game databse the number that stands before 
# your weapon name is the ID you need to input here...
#
# same thing goes for the monster party... ^-^
# monster normaly dont need more sprites for weapons....
#
# if you want to use more... then replace the "@weapon_sprite_enemy = 4"
# with these lines... (but you need to edit them)
#
#        if @active_battler.weapon_id == 1 # <--  weapon ID number
#          @weapon_sprite_enemy = 4 # <-- battle animation
#        elsif @active_battler.weapon_id == 5 # <-- weapon ID number
#          @weapon_sprite_enemy = 2 # <-- battle animation
#        elsif @active_battler.weapon_id == 9 # <-- weapon ID number
#          @weapon_sprite_enemy = 0 # <-- battle animation
#        elsif @active_battler.weapon_id == 13 # <-- weapon ID number
#          @weapon_sprite_enemy = 6 # <-- battle animation
#        else
#          @weapon_sprite_enemy = 4
#        end
# 
#================================= END

      if @active_battler.is_a?(Game_Actor)
        if @active_battler.weapon_id == 1 # <--  weapon ID number
          @weapon_sprite = 4 # <-- battle animation
        elsif @active_battler.weapon_id == 5 # <-- weapon ID number
          @weapon_sprite = 2 # <-- battle animation
        elsif @active_battler.weapon_id == 9 # <-- weapon ID number
          @weapon_sprite = 0 # <-- battle animation
        elsif @active_battler.weapon_id == 13 # <-- weapon ID number
          @weapon_sprite = 6 # <-- battle animation
        else
          @weapon_sprite = 4
        end
        
# monster section is here... ^-^

      else# @active_battler.is_a?(Game_Enemy)
          @weapon_sprite_enemy = 4
      end
        
#
#===============================================================================
# WEAPONS END....
#===============================================================================
      
      
      @animation1_id = @active_battler.animation1_id
      @animation2_id = @active_battler.animation2_id
      if @active_battler.is_a?(Game_Enemy)
        if @active_battler.restriction == 3
          target = $game_troop.random_target_enemy
        elsif @active_battler.restriction == 2
          target = $game_party.random_target_actor
        else
          index = @active_battler.current_action.target_index
          target = $game_party.smooth_target_actor(index)
        end
#======== here is the setting for the movement & animation...
          x = target.screen_x - 32
          @spriteset.enemy_sprites[@active_battler.index].enemy_pose(0)
          @spriteset.enemy_sprites[@active_battler.index]\
          .move(x, target.screen_y, 10)
#========= here if you look at the RPG's movement settings you'll see
#========= that he takes the number 40 for the speed of the animation... 
#========= i thing thats too fast so i settet it down to 10 so looks smoother...
      end
      if @active_battler.is_a?(Game_Actor)
        if @active_battler.restriction == 3
          target = $game_party.random_target_actor
        elsif @active_battler.restriction == 2
          target = $game_troop.random_target_enemy
        else
          index = @active_battler.current_action.target_index
          target = $game_troop.smooth_target_enemy(index)
        end
#======= the same thing for the player... ^-^
        x = target.screen_x + 32
        @spriteset.actor_sprites[@active_battler.index].pose(0)
        @spriteset.actor_sprites[@active_battler.index]\
        .move(x, target.screen_y, 10)
      end
      @target_battlers = [target]
      for target in @target_battlers
        target.attack_effect(@active_battler)
      end
      return
    end
    if @active_battler.current_action.basic == 1
      if @active_battler.is_a?(Game_Actor)
        @spriteset.actor_sprites[@active_battler.index].pose(2) #defence
      else
        @spriteset.enemy_sprites[@active_battler.index].enemy_pose(2) #defence
      end
      @help_window.set_text($data_system.words.guard, 1)
      return
    end
    if @active_battler.is_a?(Game_Enemy) and
       @active_battler.current_action.basic == 2
      @help_window.set_text("Escape", 1)
      @active_battler.escape
      return
    end
    if @active_battler.current_action.basic == 3
      $game_temp.forcing_battler = nil
      @phase4_step = 1
      return
    end
    
    if @active_battler.current_action.basic == 4
      if $game_temp.battle_can_escape == false
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      update_phase2_escape
      return
    end
  end
  #--------------------------------------------------------------------------
  # skill aktion...
  #--------------------------------------------------------------------------
  def make_skill_action_result
    
    @skill = $data_skills[@active_battler.current_action.skill_id]
    unless @active_battler.current_action.forcing
      unless @active_battler.skill_can_use?(@skill.id)
        $game_temp.forcing_battler = nil
        @phase4_step = 1
        return
      end
    end
    @active_battler.sp -= @skill.sp_cost
    @status_window.refresh
    @help_window.set_text(@skill.name, 1)
    
#===============================================================================
# SKILL SPRITES START
#===============================================================================
# this one is the same as the one for the weapons...
# for the one who have this for the first time
# look at the script i hope it is easy to understand...
# 
# the other one that have the earlier versions of this script they dont need explenation
# ... i think....
# the think that changed is the line where the animation ID is given to the sprite...
# the number after the "pose" is the animation ID... it goes for every other animation as well..
# if you have an animation for a skill that have more frames... 
# then just insert the number of frames after the first number...
# so it looks like this.... "pose(5, 8)" <-- 5 is the animation... 
# 8 is the max frame (that means your animation have 8 frames...) ^-^
    
    if @active_battler.is_a?(Game_Actor)
      if @skill.name == "Heal" # <-- first skill name
        @spriteset.actor_sprites[@active_battler.index].pose(5) # <-- sprite number
      elsif @skill.name == "Cross Cut" # <-- secound skill name
        @spriteset.actor_sprites[@active_battler.index].pose(6) # <-- sprite number
      elsif @skill.name == "Fire" # <-- third skill name
        @spriteset.actor_sprites[@active_battler.index].pose(6) # <-- sprite number
      end
    else
      if @skill.name == "Heal" # <-- first skill name
        @spriteset.enemy_sprites[@active_battler.index].enemy_pose(5) # <-- sprite number
      elsif @skill.name == "Cross Cut" # <-- secound skill name
        @spriteset.enemy_sprites[@active_battler.index].enemy_pose(6) # <-- sprite number
      elsif @skill.name == "Fire" # <-- third skill name
        @spriteset.enemy_sprites[@active_battler.index].enemy_pose(6) # <-- sprite number
      end
    end
#===============================================================================
# SKILL SPRITES END
#===============================================================================
    
    @animation1_id = @skill.animation1_id
    @animation2_id = @skill.animation2_id
    @common_event_id = @skill.common_event_id
    set_target_battlers(@skill.scope)
    for target in @target_battlers
      target.skill_effect(@active_battler, @skill)
    end
  end
  #--------------------------------------------------------------------------
  # how here we make the item use aktions
  #--------------------------------------------------------------------------
  def make_item_action_result
   
    # sorry i didnt work on this...
    # couse i dont have a sprite that uses items....
    # so i just added the standby sprite here...
    # when i get more time for this i'll try what i can do for this one... ^-^
    # its the same as the ones above...
    if @active_battler.is_a?(Game_Actor)
      @spriteset.actor_sprites[@active_battler.index].pose(1)
    else
      @spriteset.enemy_sprites[@active_battler.index].enemy_pose(1)
    end
    
    @item = $data_items[@active_battler.current_action.item_id]
    unless $game_party.item_can_use?(@item.id)
      @phase4_step = 1
      return
    end
    if @item.consumable
      $game_party.lose_item(@item.id, 1)
    end
    @help_window.set_text(@item.name, 1)
    @animation1_id = @item.animation1_id
    @animation2_id = @item.animation2_id
    @common_event_id = @item.common_event_id
    index = @active_battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    set_target_battlers(@item.scope)
    for target in @target_battlers
      target.item_effect(@item)
    end
  end
  
#===============================================================================
# here again.... snipplet from RPG's script
#===============================================================================
  
  #--------------------------------------------------------------------------
  # updating the movement
  # since RPG isnt used to comments... i'll comment it again...
  #--------------------------------------------------------------------------
  def update_phase4_step3
    if @active_battler.current_action.kind == 0 and
       @active_battler.current_action.basic == 0
       # in this one... we have our weapon animations... for player and monster
      if @active_battler.is_a?(Game_Actor)
        @spriteset.actor_sprites[@active_battler.index].pose(@weapon_sprite)
      elsif @active_battler.is_a?(Game_Enemy)
        @spriteset.enemy_sprites[@active_battler.index].enemy_pose(@weapon_sprite_enemy)
      end
    end
    if @animation1_id == 0
      @active_battler.white_flash = true
    else
      @active_battler.animation_id = @animation1_id
      @active_battler.animation_hit = true
    end
    @phase4_step = 4
  end

  def update_phase4_step4
    # this here is for the hit animation...
    for target in @target_battlers
      if target.is_a?(Game_Actor) and !@active_battler.is_a?(Game_Actor)
        if target.guarding?
          @spriteset.actor_sprites[target.index].pose(2)
        else
          @spriteset.actor_sprites[target.index].pose(3)
        end
        elsif target.is_a?(Game_Enemy) and !@active_battler.is_a?(Game_Enemy)
        if target.guarding?
          @spriteset.enemy_sprites[target.index].enemy_pose(2)
        else
          @spriteset.enemy_sprites[target.index].enemy_pose(3)
        end
      end
      target.animation_id = @animation2_id
      target.animation_hit = (target.damage != "Miss")
    end
    @wait_count = 8
    @phase4_step = 5
  end

  def update_phase4_step5
    if @active_battler.hp > 0 and @active_battler.slip_damage?
      @active_battler.slip_damage_effect
      @active_battler.damage_pop = true
    end

    @help_window.visible = false
    @status_window.refresh

    if @active_battler.is_a?(Game_Actor)
      @spriteset.actor_sprites[@active_battler.index].pose(1)
    else
      @spriteset.enemy_sprites[@active_battler.index].enemy_pose(1)
    end
    for target in @target_battlers
      if target.damage != nil
        target.damage_pop = true
        if @active_battler.is_a?(Game_Actor)
          @spriteset.actor_sprites[@active_battler.index].pose(1)
        else
          @spriteset.enemy_sprites[@active_battler.index].enemy_pose(1)
        end
      end
    end
    @phase4_step = 6
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 6 : リフレッシュ)
  #--------------------------------------------------------------------------
  def update_phase4_step6
    
    # here we are asking if the player is dead and is a player or an enemy...
    # these lines are for the running back and standby animation....
    if @active_battler.is_a?(Game_Actor) and !@active_battler.dead?
      @spriteset.actor_sprites[@active_battler.index]\
      .move(@active_battler.screen_x, @active_battler.screen_y, 20)
      @spriteset.actor_sprites[@active_battler.index].pose(0)
    elsif !@active_battler.dead?
      @spriteset.enemy_sprites[@active_battler.index]\
      .move(@active_battler.screen_x, @active_battler.screen_y, 20)
      @spriteset.enemy_sprites[@active_battler.index].enemy_pose(0)
    end
    for target in @target_battlers
      if target.is_a?(Game_Actor) and !target.dead?
          @spriteset.actor_sprites[target.index].pose(1)
        elsif !target.dead?
          @spriteset.enemy_sprites[target.index].enemy_pose(1)
      end
    end
    $game_temp.forcing_battler = nil
    if @common_event_id > 0
      common_event = $data_common_events[@common_event_id]
      $game_system.battle_interpreter.setup(common_event.list, 0)
    end
    @phase4_step = 7
  end

  def update_phase4_step7
    
    # here we are asking if the player is dead and is a player or an enemy...
    # these lines are for the running back and standby animation....
    if @active_battler.is_a?(Game_Actor) and !@active_battler.dead?
      @spriteset.actor_sprites[@active_battler.index].pose(1)
    elsif !@active_battler.dead?
      @spriteset.enemy_sprites[@active_battler.index].enemy_pose(1)
    end

    $game_temp.forcing_battler = nil
    if @common_event_id > 0
      common_event = $data_common_events[@common_event_id]
      $game_system.battle_interpreter.setup(common_event.list, 0)
    end
    @phase4_step = 1
  end
  
# this one is an extra... without this the animation whill not work correctly...

  def update
    if $game_system.battle_interpreter.running?
      $game_system.battle_interpreter.update
      if $game_temp.forcing_battler == nil
        unless $game_system.battle_interpreter.running?
          unless judge
            setup_battle_event
          end
        end
        if @phase != 5
          @status_window.refresh
        end
      end
    end
    $game_system.update
    $game_screen.update
    if $game_system.timer_working and $game_system.timer == 0
      $game_temp.battle_abort = true
    end
    @help_window.update
    @party_command_window.update
    @actor_command_window.update
    @status_window.update
    @message_window.update
    @spriteset.update
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    if $game_temp.message_window_showing
      return
    end
    if @spriteset.effect?
      return
    end
    if $game_temp.gameover
      $scene = Scene_Gameover.new
      return
    end
    if $game_temp.to_title
      $scene = Scene_Title.new
      return
    end
    if $game_temp.battle_abort
      $game_system.bgm_play($game_temp.map_bgm)
      battle_end(1)
      return
    end
    if @wait_count > 0
      @wait_count -= 1
      return
    end

    # this one holds the battle while the player moves
    for actor in @spriteset.actor_sprites
      if actor.moving
        if $FOG == "on"
          if $FOG_E or $FOG_A
            if actor.y >= 200
              actor.bush_depth = 12
            else
              actor.bush_depth = 0
            end
          end
        end
        return
      end
      if $FOG == "on"
        if $FOG_E or $FOG_A
          if actor.y >= 200
            actor.bush_depth = 24
          else
            actor.bush_depth = 0
          end
        end
      end
    end
    # and this one is for the enemy... 
    for enemy in @spriteset.enemy_sprites
      if enemy.moving# and $game_system.animated_enemy
        if $FOG == "on"
          if $FOG_E or $FOG_A
            if enemy.y >= 200
              enemy.bush_depth = 24
            else
              enemy.bush_depth = 0
            end
          end
        end
        return
      end
      if $FOG == "on"
        if $FOG_E or $FOG_A
          if enemy.y >= 200
            enemy.bush_depth = 12
          else
            enemy.bush_depth = 0
          end
        end
      end
    end
    
    if $game_temp.forcing_battler == nil and
       $game_system.battle_interpreter.running?
      return
    end
    case @phase
    when 1
      update_phase1
    when 2
      update_phase2
    when 3
      update_phase3
    when 4
      update_phase4
    when 5
      update_phase5
    end
  end
  
#===============================================================================
# end of the snipplet
# if you want the comments that where here just look at the scene_battle 4...
#
# i added some comments since RPG hasnt add any....
#===============================================================================
end