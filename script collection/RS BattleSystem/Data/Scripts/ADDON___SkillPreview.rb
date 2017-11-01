#==============================================================================
# Skill Preview
# by Pokepik (and a little fix by Orochii :P)
#==============================================================================
# Adds a nice extra touch to the skill scene. A window where you can check 
# the selected skill animation.
# This version was "fixed" by me, giving the affected battler sprite a viewport,
# just a visual issue it had before...

#==============================================================================
# Window_Skill
#==============================================================================
  #Configure here image names!
  #All inside Graphics of course!
MONSTER_IMAGE = "mole" #This one is on Battlers folder
BACK_IMAGE = "backimage" #And this one, inside Pictures folder

class Window_Skill < Window_Selectable
  
  def initialize(actor)
    super(0, 128, 256, 352)
    @actor = actor
    @column_max = 1
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 64
      self.height = 256
      self.back_opacity = 160
    end
  end
  def draw_item(index)
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4
    y = index * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    self.contents.draw_text(x, y, (self.width/@column_max)-40, 32, skill.sp_cost.to_s, 2)
  end
end

#==============================================================================
# Window_SkillShow
#==============================================================================

class Window_SkillShow < Window_Base
  attr_reader :backimage
  def initialize(index, actor)
    super(320, 128, 640-256, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    if $game_temp.in_battle
      self.y = 64
      self.height = 256
      self.back_opacity = 160
    end
    @skill_index = index
    refresh(index)
  end
  def refresh(index)
    self.contents.clear
    @data = []
    for i in 0...@actor.skills.size
      skill = $data_skills[@actor.skills[i]]
      if skill != nil
        @data.push(skill)
      end
    end
    
    @index = index
    if @data.size == 0
      return
    end
    skill = $data_skills[@actor.skills[@index]]
    
    @backimage = RPG::Cache.picture(BACK_IMAGE)
    src_rect = Rect.new(0, 0, 256, 256)
    self.contents.blt(16 , 32, @backimage, src_rect)
    
    if skill.scope >= 3
      @battlerimage = RPG::Cache.battler(@actor.character_name.to_s, 0)
    else
      @battlerimage = RPG::Cache.battler(MONSTER_IMAGE, 0)
    end
    @battlerimage_x = 16 + (256/2) - @battlerimage.width/2
    @battlerimage_y = 32 + (256/2) - @battlerimage.height/2
    self.contents.blt(@battlerimage_x,@battlerimage_y, @battlerimage, src_rect)
  end
end

#==============================================================================
# Scene_Skill
#==============================================================================

class Scene_Skill
  def main
    @actor = $game_party.actors[@actor_index]
    @help_window = Window_Help.new
    @status_window = Window_SkillStatus.new(@actor)
    
    @skill_window = Window_Skill.new(@actor)
    @skill_index = -1
    @skillshow_window = Window_SkillShow.new(@skill_window.index, @actor)
    
    @skill_window.help_window = @help_window
    
    @target_window = Window_Target.new
    @target_window.visible = false
    @target_window.active = false
    
    @vx,@vy=@skillshow_window.x+32, @skillshow_window.y+48
    @vw,@vh=256,256
    @vport = Viewport.new(@vx,@vy,@vw,@vh)
    @vport.z = 5000
    @spr = RPG::Sprite.new(@vport)
    @spr.z = 5000
    
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @help_window.dispose
    @spr.dispose
    @vport.dispose
    @status_window.dispose
    @skill_window.dispose
    @skillshow_window.dispose
    @target_window.dispose
  end

  def update
    if @skill_index != @skill_window.index
      if @skill_window.skill != nil
      @skillshow_window.refresh(@skill_window.index)
      @animskill = @skill_window.skill
      anim = $data_animations[@animskill.animation2_id]
      @spr.x = 480-@vx
      case anim.position
      when 0
        @spr.y = 250
      when 1
        @spr.y = 300
      when 2
        @spr.y = 350
      else
        @spr.y = 300
      end
      @spr.y -= @vy
      @spr.animation(anim, true)
      @skill_index = @skill_window.index
      end
    end
    @help_window.update
    @status_window.update
    @spr.update
    @vport.update
    @skill_window.update
    @skillshow_window.update
    @target_window.update
    if @skill_window.active
      update_skill
      return
    end
    if @target_window.active
      update_target
      return
    end
  end
end