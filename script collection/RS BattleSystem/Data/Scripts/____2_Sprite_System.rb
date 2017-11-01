#==============================================================================
# ** Animated Battlers - Enhanced   ver. 13.8                      (01-07-2012)
#
#------------------------------------------------------------------------------
#  * (2) Sprite System:  The Sprite Battler Class
#============================================================================== 

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battler_offset         # Degree of action forcing  
  attr_accessor :skill_used             # Degree of action forcing  
  attr_accessor :item_used              # Degree of action forcing  
  attr_accessor :width
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias mnk_init initialize 
  def initialize(viewport, battler = nil)
    # --Initialize poses
    @frame, @pose, @last_time, @last_move_time        = 0, 0, 0, 0
    # --Initialize Battler placement and pose types
    @battler_offset, @width, @skill_used, @item_used  = 0, 0, 0, 0
    # --Initialize Boolean values
    @dying                = true
    @s_pose               = false
    $game_system.victory  = false
    $game_system.defeat   = false
    @winning              = true
    # ORIGINAL Initialize call
    mnk_init(viewport, battler)
    # EVENT VALUE CALLS
    # --Obtain the Sideview switch
    $game_system.sv_angle = $sideview_mirror
    $game_system.sv_angle = 0 if $sideview_mirror == nil
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias mnk_update update
  def update
    # Only perform sprite edit for valid battlers
    return unless @battler
    @started = false if @battler.battler_name != @battler_name
    # Regular Update
    mnk_update
    # Create Ccoa Flag
    ccoa_flag = false
    if @battler.is_a?(Game_Enemy) 
      # If Ccoa Spritestrips in use
      ccoa_flag = true if CCOA_ENEMY or CCOA_ENEMY_ID.include?(@battler.id)
    else
      ccoa_flag = true if CCOA_ACTOR or CCOA_ACTOR_ID.include?(@battler.id)
    end
    # Set Translucency  
    if @battler.is_a?(Game_Enemy)
      battler_translucency(@battler, MNK_TRANSLUCENT_ENEMY)
    else
      battler_translucency(@battler, MNK_TRANSLUCENT_ACTOR)
    end
    # Reset hash for Advanced Pose/Frames
    pose_temp = {}
    # Start Routine (Performed at startup for each battler)
    unless @started
      # Opacity fadein feature
      self.opacity = 0 if MNK_FADE_IN      
      # Set the pose based on battler's state
      @pose = state
      # Turn off Casting pose
      @battler.casted  = false
      @battler.casting = false
      # Configure Ccoa Sprite Strip
      if ccoa_flag
        @battler_file = @battler.battler_name
        @battler_hue  = @battler.battler_hue
        string        = ccoa_pose_string(@pose)
        @battler_file += string
        @battler_file = @battler.battler_name unless RPG::Cache.test_2('battler', @battler_file)
        self.bitmap = RPG::Cache.battler(@battler_file, @battler_hue)
        @height = bitmap.height        
        @width  = bitmap.width        
        poseframe = @width / @height
        poseframe = 1 if poseframe < 1
      # Configure Enemy Spritesheet
      else
        if @battler.is_a?(Game_Enemy) 
          # Use spritesheet unless specified
          unless DEFAULT_ENEMY or DEFAULT_ENEMY_ID.include?(@battler.id)
            @width  = @width  / cell_divider(MNK_FRAMES_ENEMY,  MNK_FRAMES) 
            @height = @height / cell_divider(MNK_POSES_ENEMY,   MNK_POSES)
          end
        # Or Configure Actor Spritesheet
        else  
          # Use spritesheet unless specified
          unless DEFAULT_ACTOR or DEFAULT_ACTOR_ID.include?(@battler.id)
            @width  = @width  / cell_divider(MNK_FRAMES_ACTOR,  MNK_FRAMES)
            @height = @height / cell_divider(MNK_POSES_ACTOR,   MNK_POSES)
          end
        end        
      end
      # Distance the battlers
      @battler_offset = @width * 0.75
      # Obtain battler position (simulating 3-Dness)
      @destination_x = @display_x = @battler.screen_x
      @destination_y = @display_y = @battler.screen_y
      @destination_z = @display_z = @battler.screen_z
      # Make invisible if dead at battle start
      self.visible = false if @battler.dead?
      # Set the started flag
      @started = true
    # End of Start Routine (for each battler)  
    end
    # Again, ensure a pose is set
    @pose = state if @pose == nil
    if ccoa_flag
      @battler_file = @battler.battler_name
      @battler_hue  = @battler.battler_hue
      string        = ccoa_pose_string(@pose)
      @battler_file += string
      @battler_file = @battler.battler_name unless RPG::Cache.test_2('battler', @battler_file)
      self.bitmap = RPG::Cache.battler(@battler_file, @battler_hue)
      @height = bitmap.height        
      @width  = bitmap.width        
      poseframe = @width / @height
      poseframe = 1 if poseframe < 1
      frame_obtain
    else
      if @battler.is_a?(Game_Enemy) 
        # Use spritesheet cell unless specified
        unless DEFAULT_ENEMY or DEFAULT_ENEMY_ID.include?(@battler.id)
          cell_obtain
        else
          self.src_rect.set(0, 0, @width, @height)
        end
      else
        # Use spritesheet cell unless specified
        unless DEFAULT_ACTOR or DEFAULT_ACTOR_ID.include?(@battler.id)
          cell_obtain
        else
          self.src_rect.set(0, 0, @width, @height)
        end
      end
    end
    # Position Sprite 
    self.x  = @display_x
    self.y  = @display_y
    self.z  = @display_z
    self.ox = @width / 2             unless ccoa_flag
    self.ox = @width / (2*poseframe) if ccoa_flag
    self.oy = @height
    
    # Adjust sprite direction if facing the other way...
    if $game_system.sv_angle == 1
      if @battler.is_a?(Game_Actor)
        mirror_pose_unless(6)
      else
        MNK_MIRROR_ENEMIES ? mirror_pose_if(5) : mirror_pose_unless(5)
      end
    else
      if @battler.is_a?(Game_Actor)
        mirror_pose_if(6)
      else
        MNK_MIRROR_ENEMIES ? mirror_pose_unless(5) : mirror_pose_if(5)
      end
    end
    # Setup Frames per Pose
    # If a Spritestrip
    unless ccoa_flag
      # Normal
      poseframe = MNK_FRAMES_STANDARD
      if @battler.is_a?(Game_Actor)
        poseframe = cell_divider(MNK_FRAMES_ACTOR,  MNK_FRAMES_STANDARD) if cell_divider(MNK_FRAMES_ACTOR,  MNK_FRAMES_STANDARD) != nil
      else
        poseframe = cell_divider(MNK_FRAMES_ENEMY,  MNK_FRAMES_STANDARD) if cell_divider(MNK_FRAMES_ENEMY,  MNK_FRAMES_STANDARD) != nil
      end 
      pose_chk = 0
      pose_chk = @pose+1 if @pose != nil
      poseframe = MNK_FRAMES_PER_POSE[pose_chk] if MNK_FRAMES_PER_POSE.include?(pose_chk)
      # Set Advanced Poses for Actors
      if @battler.is_a?(Game_Actor)
        pose_temp = MNK_POSES_FR_ACTOR[@battler.id] if MNK_POSES_FR_ACTOR.include?(@battler.id)
        poseframe = pose_temp[pose_chk] if pose_temp.include?(pose_chk)
      end    
      # Set Advanced Poses for Enemies
      if @battler.is_a?(Game_Enemy)
        pose_temp = MNK_POSES_FR_ENEMY[@battler.id] if MNK_POSES_FR_ENEMY.include?(@battler.id)
        poseframe = pose_temp[pose_chk] if pose_temp.include?(pose_chk)
      end
    end
    # Make visible if returned to life
    unless @battler.dead?
      self.visible = true if @pose == pose_obtain(MNK_POSE1, MNK_APOSE1, MNK_EPOSE1)
      @freeze = false unless $game_system.victory
    end
    # Setup Animation 
    time = Graphics.frame_count / (Graphics.frame_rate / MNK_SPEED)
    if @last_time < time 
      @frame = (@frame + 1) % poseframe
      if @frame == 0
        if @freeze
          @frame = poseframe - 1
          return
        end
        @pose = state
      end
    end
    @last_time = time
    # Setup Dying Animation
    if @battler.dead?
      if @dying == true
        @pose = state
        @dying = false
      end
    # Otherwise, all non-dead actions...  
    else
      # Setup/Ready for Battle (Let's get ready to RUMBLE!)
      if @s_pose == false
        tmp_pose = pose_obtain(MNK_POSES_SETUP, MNK_POSES_SETUP_A, MNK_POSES_SETUP_E)
        if tmp_pose != nil
          @pose = tmp_pose
          @s_pose = true            
        end
      end
      # If Victory pose (Who's your daddy?) 
      if @battler.is_a?(Game_Actor) && $game_system.victory == true && @winning == true
        @pose = state
        @winning = false
      end
    end
    # Move It
    move if moving
  end
  #--------------------------------------------------------------------------
  # * Obtain suffix of Ccoa Pose Strip
  #     pose : pose
  #--------------------------------------------------------------------------
  def ccoa_pose_string(pose) 
    return CCOA_POSES[pose] if CCOA_POSES[pose] != nil
    return CCOA_POSES[0]
  end
  #--------------------------------------------------------------------------
  # * Obtain Individual Frame from Spritestrip
  #--------------------------------------------------------------------------
  def frame_obtain
    # Only permit for valid poses & frames
    if @frame != nil
      self.src_rect.set(@height * @frame, 0 , @height, @height)
    end
  end  
  #-------------------------------------------------------------------------- 
  # * Current State
  #--------------------------------------------------------------------------
  def state
    # Set Translucency if not dead
    if @battler.is_a?(Game_Actor)
      battler_translucency(@battler, MNK_TRANSLUCENT_ACTOR)
    else
      battler_translucency(@battler, MNK_TRANSLUCENT_ENEMY)
    end
    # Battler Fine
    state = pose_obtain(MNK_POSE1, MNK_APOSE1, MNK_EPOSE1)
    # Set sprite to 'Block' pose
    state = pose_obtain(MNK_POSE4, MNK_APOSE4, MNK_EPOSE4) if @battler.guarding?
    # Damaged states
    if [nil,{}].include?(@battler.damage)
      # Battler Wounded (and damage inflicted)
      state = state_woozy     if state_woozy != nil
      # Set sprite to 'Status Ailment' pose (and damage inflicted)
      state = state_status    if state_status != nil
      # Set sprite to 'Dead' pose (and damage inflicted)
      state = state_dead      if state_dead != nil
    end
    # Casting State 
    if @battler.casted
      state = casting_pose if $game_system.mnk_det_para_spell and @battler.spelling?
      state = casting_pose if $game_system.mnk_det_sd_casting and @battler.sd_casting
      state = casting_pose if $game_system.mnk_det_rtab_systm and @battler.rtp != 0
      state = casting_pose if $game_system.mnk_det_cfc_detect and @battler.cf_casting
      state = casting_pose if $game_system.mnk_det_abs_detect and @battler.wait > 0
    end
    # Victory States
    if @battler.is_a?(Game_Actor) && $game_system.victory
      if @winning == true
        state = winning_pose unless @battler.dead? && winning_pose == nil
      else
        state = victory_pose unless @battler.dead?
      end
    end   
    # Defeat States
    if @battler.is_a?(Game_Enemy) && $game_system.defeat
      if @winning == true
        state = winning_pose unless @battler.dead? && winning_pose == nil
      else
        state = victory_pose unless @battler.dead?
      end
    end       
    # Moving state
    state = sprite_move if sprite_move != nil
    # Return State
    
    return state
  end
  #-------------------------------------------------------------------------- 
  # * Move
  #--------------------------------------------------------------------------
  def move
    time = Graphics.frame_count / (Graphics.frame_rate.to_f / (MNK_SPEED * 5))
    if @last_move_time < time
      # Pause for Animation
      return if @pose != state
        # The standard 'full' opacity
        opa = 255
        if @battler.is_a?(Game_Enemy) and MNK_TRANSLUCENT_ENEMY.include?(@battler.id)
          opa = MNK_TRANSLUCENCY
        end
        if @battler.is_a?(Game_Actor) and MNK_TRANSLUCENT_ACTOR.include?(@battler.id)
          opa = MNK_TRANSLUCENCY
        end
      # Phasing
      self.opacity = phasing(opa)   if MNK_PHASING
      if @battler.is_a?(Game_Actor)
        self.opacity = phasing(opa) if MNK_PHASING_ACTOR.include?(@battler.id)
      else      
        self.opacity = phasing(opa) if MNK_PHASING_ENEMY.include?(@battler.id)
      end
      # Calculate Difference
      difference_x = (@display_x - @destination_x).abs
      difference_y = (@display_y - @destination_y).abs
      difference_z = (@display_z - @destination_z).abs  
      # Done? Reset, Stop
      if [difference_x, difference_y].max.between?(0, 8)
        @display_x = @destination_x
        @display_y = @destination_y
        @display_z = @destination_z
        @pose = state
        return
      end
      # Calculate Movement Increments
      increment_x = increment_y = 1
      if difference_x < difference_y
        increment_x = 1.0 / (difference_y.to_f / difference_x)
      elsif difference_y < difference_x
        increment_y = 1.0 / (difference_x.to_f / difference_y)
      end
      increment_z = increment_y
      # Calculate Movement Speed 
      if MNK_CALC_SPEED
        total = 0; $game_party.actors.each{ |actor| total += actor.agi }
        speed = @battler.agi.to_f / (total / $game_party.actors.size)
        increment_x *= speed
        increment_y *= speed
        increment_z *= speed
      end
      # Multiply and Move
      multiplier_x = MNK_RUSH_SPEED * (@destination_x - @display_x > 0 ? 8 : -8)
      multiplier_y = MNK_RUSH_SPEED * (@destination_y - @display_y > 0 ? 8 : -8)
      multiplier_z = MNK_RUSH_SPEED * (@destination_z - @display_z > 0 ? 8 : -8)      
      @display_x += (increment_x * multiplier_x).to_i
      if @battler.jump != nil
        if multiplier_x < 0
          middle_ground = (((@destination_x - @original_x)/2).abs)+ @destination_x
          if @display_x > middle_ground #320
            @display_y -= 24 * MNK_RUSH_SPEED
          else
            multiplier_y = MNK_RUSH_SPEED * (@destination_y - @display_y > 0 ? 24 : -24)
            @display_y += (increment_y * multiplier_y).to_i
          end
        end
        if multiplier_x > 0
          middle_ground = (((@destination_x - @original_x)/2).abs)+ @original_x
          if @display_x < middle_ground #320
            @display_y -= 24 * MNK_RUSH_SPEED
          else
            multiplier_y = MNK_RUSH_SPEED * (@destination_y - @display_y > 0 ? 24 : -24)
            @display_y += (increment_y * multiplier_y).to_i
          end
        end
      else
        @display_y += (increment_y * multiplier_y).to_i
      end
      @display_z += (increment_z * multiplier_z).to_i
    end
    @last_move_time = time
  end
  #--------------------------------------------------------------------------
  # * Set Movement
  #--------------------------------------------------------------------------
  def setmove(destination_x, destination_y, destination_z)
    movekind = @battler.current_action.kind
    unless (@battler.is_a?(Game_Enemy) and MNK_STATIONARY_ENEMIES) or
           (@battler.is_a?(Game_Actor) and MNK_STATIONARY_ACTORS)
      unless (MNK_STATIONARY_WEAPONS.include?(@battler.weapon_id) && movekind == 0) or
             (MNK_STATIONARY_SKILLS.include?(@battler.skill_used) && movekind == 1) or
             (MNK_STATIONARY_ITEMS.include?(@battler.item_used) && movekind == 2)
        @original_x = @display_x
        @original_y = @display_y
        @original_z = @display_z          
        @destination_x = destination_x
        @destination_y = destination_y
        @destination_z = destination_z
      end
    end
  end
  #-------------------------------------------------------------------------- 
  # * Movement Check
  #--------------------------------------------------------------------------
  def moving
    if (@display_x != @destination_x and @display_y != @destination_y and !@battler.dead?)
      return (@display_x > @destination_x ? 0 : 1)
    end
  end
  #-------------------------------------------------------------------------- 
  # * Fallen Pose
  #--------------------------------------------------------------------------
  if @derv_anim_bat_stack.nil?
    @derv_anim_bat_stack = true
    alias mnk_collapse collapse
    def collapse
      if @battler.is_a?(Game_Actor)
        mnk_collapse if DEFAULT_ACTOR
        mnk_collapse if DEFAULT_COLLAPSE_ACTOR
        if DEFAULT_ACTOR_ID != nil
          mnk_collapse if DEFAULT_ACTOR_ID.include?(@battler.id)
        end
      else
        mnk_collapse if DEFAULT_ENEMY
        mnk_collapse if DEFAULT_COLLAPSE_ENEMY
        if DEFAULT_ENEMY_ID != nil
          mnk_collapse if DEFAULT_ENEMY_ID.include?(@battler.id)
        end
      end
    end
  end
  #-------------------------------------------------------------------------- 
  # * Mirror Pose If...
  #--------------------------------------------------------------------------
  def mirror_pose_if(adv_value)
    if $game_temp.advantage_set == adv_value
      self.mirror = true
    else
      self.mirror = false
    end
  end
  #-------------------------------------------------------------------------- 
  # * Mirror Pose Unless...
  #--------------------------------------------------------------------------
  def mirror_pose_unless(adv_value)
    unless $game_temp.advantage_set == adv_value
      self.mirror = true
    else
      self.mirror = false
    end
  end
  #--------------------------------------------------------------------------
  # * State:  Dying/Dead/Collapse
  #--------------------------------------------------------------------------  
  def state_dead
    # Reset state return
    state_return = nil
    if @battler.dead?
      # If using default battlers or default collapse
      if (DEFAULT_COLLAPSE_ACTOR and @battler.is_a?(Game_Actor)) or
         (DEFAULT_COLLAPSE_ENEMY and @battler.is_a?(Game_Enemy)) or
         (DEFAULT_ACTOR and @battler.is_a?(Game_Actor)) or
         (DEFAULT_ENEMY and @battler.is_a?(Game_Enemy)) or
         (DEFAULT_ENEMY_ID.include?(@battler.id) and @battler.is_a?(Game_Enemy)) or
         (DEFAULT_ACTOR_ID.include?(@battler.id) and @battler.is_a?(Game_Actor))
        # Do absolutely nothing :)
      else    
        if @dying == true
          tmp_pose = pose_obtain(MNK_POSES_DYING, MNK_POSES_DYING_A, MNK_POSES_DYING_E)
          state_return = tmp_pose if tmp_pose != nil
        else  
          state_return = dying_pose
        end
      end
    end
    return state_return
  end  
  #-------------------------------------------------------------------------- 
  # * State:  Defeat
  #--------------------------------------------------------------------------
  def dying_pose
    state_return = nil
    state_return = pose_obtain(MNK_POSE11, MNK_APOSE11, MNK_EPOSE11)
    if @battler.is_a?(Game_Actor)
      @freeze = true if not MNK_LOOPS_DEFEATED_ACTOR.include?(@battler.id)
    else
      @freeze = true if not MNK_LOOPS_DEFEATED_ENEMY.include?(@battler.id)
    end
    return state_return
  end
  #--------------------------------------------------------------------------
  # * State:  Movement
  #--------------------------------------------------------------------------  
  def sprite_move
    state_return = nil
    # Moving State 
    if moving
    # Adjust sprite direction if facing the other way...
      if $game_system.sv_angle == 1
        # If enemy battler moving
        if @battler.is_a?(Game_Enemy) 
          # Battler Moving Left
          if moving.eql?(0)
            skill_return = nil
            state_return = pose_obtain(MNK_POSE5, MNK_APOSE5, MNK_EPOSE5) if moving.eql?(0)
            if @battler.current_action.kind == 1 
              skill_return = pose_array_obtain(MNK_POSES_S_CHARGE, MNK_POSES_S_CHARGE_A, MNK_POSES_S_CHARGE_E, @battler.skill_used)
            end
            if @battler.current_action.kind == 2
              skill_return = pose_array_obtain(MNK_POSES_I_CHARGE, MNK_POSES_I_CHARGE_A, MNK_POSES_I_CHARGE_E, @battler.item_used)
            end
            state_return = skill_return if skill_return != nil
          end
          # Battler Moving Right
          state_return = pose_obtain(MNK_POSE6, MNK_APOSE6, MNK_EPOSE6) if moving.eql?(1)
        # Else actor battler moving
        else
          # Battler Moving Left
          state_return = pose_obtain(MNK_POSE6, MNK_APOSE6, MNK_EPOSE6) if moving.eql?(0)
          # Battler Moving Right
          if moving.eql?(1)
            skill_return = nil
            state_return = pose_obtain(MNK_POSE5, MNK_APOSE5, MNK_EPOSE5)
            if @battler.current_action.kind == 0
              skill_return = pose_array_obtain(MNK_POSES_W_CHARGE, MNK_POSES_W_CHARGE_A, MNK_POSES_W_CHARGE_E, @battler.weapon_id)
            end
            if @battler.current_action.kind == 1
              skill_return = pose_array_obtain(MNK_POSES_S_CHARGE, MNK_POSES_S_CHARGE_A, MNK_POSES_S_CHARGE_E, @battler.skill_used)
            end
            if @battler.current_action.kind == 2
              skill_return = pose_array_obtain(MNK_POSES_I_CHARGE, MNK_POSES_I_CHARGE_A, MNK_POSES_I_CHARGE_E, @battler.item_used)
            end
            state_return = skill_return if skill_return != nil
          end
          
        end
      else      
        # If enemy battler moving
        if @battler.is_a?(Game_Enemy) 
          # Battler Moving Left
          state_return = pose_obtain(MNK_POSE6, MNK_APOSE6, MNK_EPOSE6) if moving.eql?(0)
          # Battler Moving Right
          if moving.eql?(1)
            skill_return = nil
            state_return = pose_obtain(MNK_POSE5, MNK_APOSE5, MNK_EPOSE5)
            if @battler.current_action.kind == 1
              skill_return = pose_array_obtain(MNK_POSES_S_CHARGE, MNK_POSES_S_CHARGE_A, MNK_POSES_S_CHARGE_E, @battler.skill_used)
            end
            if @battler.current_action.kind == 2
              skill_return = pose_array_obtain(MNK_POSES_I_CHARGE, MNK_POSES_I_CHARGE_A, MNK_POSES_I_CHARGE_E, @battler.item_used)
            end
            state_return = skill_return if skill_return != nil
          end
        # Else actor battler moving
        else
          # Battler Moving Left
          if moving.eql?(0)
            skill_return = nil
            state_return = pose_obtain(MNK_POSE5, MNK_APOSE5, MNK_EPOSE5)
            if @battler.current_action.kind == 0
              skill_return = pose_array_obtain(MNK_POSES_W_CHARGE, MNK_POSES_W_CHARGE_A, MNK_POSES_W_CHARGE_E, @battler.weapon_id)
            end
            if @battler.current_action.kind == 1
              skill_return = pose_array_obtain(MNK_POSES_S_CHARGE, MNK_POSES_S_CHARGE_A, MNK_POSES_S_CHARGE_E, @battler.skill_used)
            end
            if @battler.current_action.kind == 2
              skill_return = pose_array_obtain(MNK_POSES_I_CHARGE, MNK_POSES_I_CHARGE_A, MNK_POSES_I_CHARGE_E, @battler.item_used)
            end
            state_return = skill_return if skill_return != nil
          end
          # Battler Moving Right
          state_return = pose_obtain(MNK_POSE6, MNK_APOSE6, MNK_EPOSE6) if moving.eql?(1)
        end
      end
    end
    return state_return
  end  
  #--------------------------------------------------------------------------
  # * State:  Status Ailments
  #--------------------------------------------------------------------------    
  def state_status
    state_return = nil
    # Battler Status-Effect
    for i in @battler.states
      temp_pose = pose_array_obtain(MNK_POSES_STATUS, MNK_POSES_STAT_A, MNK_POSES_STAT_E, i)
      state_return = temp_pose if temp_pose != nil
    end
    return state_return  
  end    
  #-------------------------------------------------------------------------- 
  # * State:  Winning
  #--------------------------------------------------------------------------
  def winning_pose
    state_return = nil
    temp_pose = pose_obtain(MNK_POSES_WINNING, MNK_POSES_WINNING_A, MNK_POSES_WINNING_E)
    state_return = temp_pose if temp_pose != nil
    return state_return
  end    
  #--------------------------------------------------------------------------
  # * State:  Woozy
  #--------------------------------------------------------------------------  
  def state_woozy
    # Reset state return    
    state_return = nil
    # Battler Wounded
    temp_pose = MNK_LOW_HP_PERCENTAGE
    if @battler.is_a?(Game_Actor)
      temp_pose = MNK_LOW_HP_ACTOR[@battler.id] if MNK_LOW_HP_ACTOR[@battler.id] != nil
    else
      temp_pose = MNK_LOW_HP_ENEMY[@battler.id] if MNK_LOW_HP_ENEMY[@battler.id] != nil
    end
    # If Set to Flat Rate
    if MNK_LOW_HP_FLAT 
      state_return = pose_obtain(MNK_POSE3, MNK_APOSE3, MNK_EPOSE3) if @battler.hp < temp_pose
    # Otherwise, use percentage of battler's health
    else
      state_return = pose_obtain(MNK_POSE3, MNK_APOSE3, MNK_EPOSE3) if @battler.hp < @battler.maxhp * temp_pose
    end
    return state_return
  end
  #-------------------------------------------------------------------------- 
  # * State:  Victory
  #--------------------------------------------------------------------------
  def victory_pose
    state_return = nil
    state_return = pose_obtain(MNK_POSE10, MNK_APOSE10, MNK_EPOSE10)
    if @battler.is_a?(Game_Actor)
      @freeze = true unless MNK_LOOPS_WINNING_ACTOR.include?(@battler.id)
    else
      @freeze = true unless MNK_LOOPS_WINNING_ENEMY.include?(@battler.id)
    end
    return state_return
  end
  #-------------------------------------------------------------------------- 
  # * State:  Casting
  #--------------------------------------------------------------------------
  def casting_pose
    tmp_pose = pose_obtain(MNK_POSES_CASTPREP, MNK_POSES_CASTPREP_A, MNK_POSES_CASTPREP_E)
    tmp_pose2 = pose_array_obtain(MNK_POSES_CASTED, MNK_POSES_CASTED_A, MNK_POSES_CASTED_E, @battler.skill_casted)
    tmp_pose = tmp_pose2 if tmp_pose2 != nil
    state = tmp_pose if tmp_pose != nil
    return state
  end
  #-------------------------------------------------------------------------- 
  # * Phasing / Vanishing
  #--------------------------------------------------------------------------
  def phasing(opa)
    d1 = (@display_x - @original_x).abs
    d2 = (@display_y - @original_y).abs
    d3 = (@display_x - @destination_x).abs
    d4 = (@display_y - @destination_y).abs
    return [opa - ([d1 + d2, d3 + d4].min * 1.75).to_i, 0].max
  end  
  #--------------------------------------------------------------------------
  # * Battler Translucency
  #     battler            : actor or enemy battler
  #     battler_trans      : translucency array for battler
  #--------------------------------------------------------------------------
  def battler_translucency(battler, battler_trans)
    tcheck = {}
    tcheck = battler_trans
    # Set transparent dead flag
    battler_dead_trans = true
    # If battler is dead
    if battler.dead?
      if battler.is_a?(Game_Enemy)
        # Turn off transparent dead flag for default enemies
        battler_dead_trans = false if DEFAULT_ENEMY
        battler_dead_trans = false if DEFAULT_COLLAPSE_ENEMY
        if DEFAULT_ENEMY_ID != nil
          battler_dead_trans = false if DEFAULT_ENEMY_ID.include?(battler.id)
        end
      else
        # Turn off transparent dead flag for default Actors
        battler_dead_trans = false if DEFAULT_ACTOR
        battler_dead_trans = false if DEFAULT_COLLAPSE_ACTOR
        if DEFAULT_ACTOR_ID != nil
          battler_dead_trans = false if DEFAULT_ACTOR_ID.include?(battler.id)
        end      
      end
    end    
    # If transparent dead is true
    if battler_dead_trans
      # Ensure transparency for transparent battlers
      set_translucency(battler, MNK_TRANSLUCENCY) if tcheck.include?(battler.id)
    end
  end
  #--------------------------------------------------------------------------
  # * Set Translucency
  #     battler            : actor or enemy battler
  #     trans_level        : translucency level
  #--------------------------------------------------------------------------
  def set_translucency(battler, trans_level)
    # Check for default RTP battler type
    default_flag = false
    if (DEFAULT_COLLAPSE_ACTOR and battler.is_a?(Game_Actor)) or
         (DEFAULT_COLLAPSE_ENEMY and battler.is_a?(Game_Enemy)) or
         (DEFAULT_ACTOR and battler.is_a?(Game_Actor)) or
         (DEFAULT_ENEMY and @battler.is_a?(Game_Enemy)) or
         (DEFAULT_ENEMY_ID.include?(battler.id) and battler.is_a?(Game_Enemy)) or
         (DEFAULT_ACTOR_ID.include?(battler.id) and battler.is_a?(Game_Actor))
      default_flag = true
    end    
    self.opacity = (battler.hidden ? 0 : MNK_TRANSLUCENCY)
    # Perform translucency check
    if battler.hidden 
      self.opacity = 0
    elsif battler.dead? && default_flag == true
      self.opacity = 0 if @collapsing = false
    else
      self.opacity  = trans_level
    end    
  end
  #--------------------------------------------------------------------------
  # * Set Pose
  #--------------------------------------------------------------------------
  def pose=(pose)
    @pose = pose
    @frame = 0
  end
  #--------------------------------------------------------------------------
  # * Freeze
  #--------------------------------------------------------------------------
  def freeze
    @freeze = true
  end  
  #--------------------------------------------------------------------------
  # * Cell Divider
  #     divider_check      : array to divide cells by custom actor or enemy
  #     divider_standard   : standard number to divide by
  #--------------------------------------------------------------------------
  def cell_divider(divider_check, divider_standard)
    dcheck = {}
    divided_cell = divider_standard
    dcheck = divider_check
    if dcheck != nil
      if dcheck.include?(@battler.id)
        divided_cell = dcheck[@battler.id] if dcheck[@battler.id] != nil
      end
    end
    return divided_cell        
  end
  #--------------------------------------------------------------------------
  # * Obtain Individual Cell
  #--------------------------------------------------------------------------
  def cell_obtain
    # Only permit for valid poses & frames
    if @pose != nil
      if @frame != nil
        self.src_rect.set(@width * @frame, @height * @pose, @width, @height)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Obtain Pose
  #     pose_base   : default pose to return
  #     pose_actor  : list of poses for actors
  #     pose_enemy  : list of poses for enemies
  #--------------------------------------------------------------------------
  def pose_obtain(pose_base, pose_actor, pose_enemy)
    # create Arrays
    pos_a = {}
    pos_e = {}
    # fill created Arrays & Set pose
    pos_a = pose_actor
    pos_e = pose_enemy
    pose_now = pose_base
    # Obtain pose if not a standard pose
    if @battler.is_a?(Game_Actor)
      pose_now = pos_a[@battler.id] if pos_a[@battler.id] != nil
    else
      pose_now = pos_e[@battler.id] if pos_e[@battler.id] != nil
    end
    # Return the final pose (minus 1 for neceties)
    pose_now -= 1 if pose_now != nil
    return pose_now
  end
  #--------------------------------------------------------------------------
  # * Obtain Pose from hashes
  #     hash_base   : hash with default poses
  #     hash_actor  : advanced list of poses for actors
  #     hash_enemy  : advanced list of poses for enemies
  #     condition   : value determining where to get the final pose
  #--------------------------------------------------------------------------
  def pose_array_obtain(hash_base, hash_actor, hash_enemy, condition)
    # create Arrays
    hash_b    = {}
    hash_a    = {}
    hash_e    = {}
    pose_temp = {}
    # fill created Arrays & Set pose
    hash_b = hash_base
    hash_a = hash_actor
    hash_e = hash_enemy
    # Setup the temp Array
    if @battler.is_a?(Game_Actor)
      pose_temp = hash_a[@battler.id] if hash_a.include?(@battler.id)
    else
      pose_temp = hash_e[@battler.id] if hash_e.include?(@battler.id)
    end
    # Obtain the base pose based on condition (or nil)
    pose_now = hash_b[condition] if hash_b.include?(condition)
    # Obtain the optional actor/enemy pose based on condition (unless nil)
    pose_now = pose_temp[condition] if pose_temp.include?(condition)
    # Return the final pose (minus 1 for neceties)
    pose_now -= 1 if pose_now != nil
    return pose_now
  end
end
