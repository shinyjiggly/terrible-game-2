#==============================================================================
# ** Animated Battlers - Enhanced   ver. 13.8                      (01-07-2012)
#
#------------------------------------------------------------------------------
#  * (3) Battle System:  The Scene Battle class
#==============================================================================    

#==============================================================================
# ** Scene_Battle 
#------------------------------------------------------------------------------ 
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias mnkmain main
  def main
    # Initialize wait count
    @delay_count = 0
    # Perform the original call
    mnkmain
  end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase)
  #--------------------------------------------------------------------------
  alias mnk_anim_sp3 start_phase3
  def start_phase3
    # Remove flag after set number of turns
    if $game_temp.battle_turn >= MNK_ADV_OFF_TURN
      # Turn sideview advantage mirror flag off
      $game_temp.advantage_set = 0
    end
    # Perform the original call
    mnk_anim_sp3
  end  
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  alias mnk_p3na phase3_next_actor
  def phase3_next_actor(flag = true)
    if $game_system.mnk_det_cfc_detect == true
      if @active_battler.is_a?(Game_Enemy)
        @active_battler.casted = true if @active_battler.cf_casting
      end
    end  
    if $game_system.mnk_det_abs_detect
      mnk_p3na(flag)
    else
      mnk_p3na
    end
  end  
  #--------------------------------------------------------------------------
  # * Frame Update (main phase step 1 : action preparation)
  #--------------------------------------------------------------------------
  alias mkf_up4s1 update_phase4_step1
  def update_phase4_step1(battler = @active_battler)
    if $game_system.mnk_det_rtab_systm == true
      mkf_up4s1(battler)
    else
      mkf_up4s1
    end
    if battler != nil
      if $game_system.mnk_det_sd_casting == true
        battler.casted = true if battler.sd_casting
      end
    end
  end  
  #--------------------------------------------------------------------------
  # *  End Skill Selection
  #--------------------------------------------------------------------------  
  alias mkf_endss end_skill_select
  def end_skill_select
    mkf_endss
    if $game_system.mnk_det_rtab_systm
      @active_actor.skill_casted = @skill.id
    else
      @active_battler.skill_casted = @skill.id
    end
    if $game_system.mnk_det_cfc_detect == true
      @active_battler.casted = true if @active_battler.cf_casting
    end
    if $game_system.mnk_det_abs_detect == true
      if @active_battler.current_action.kind == 1
        @active_battler.casted = true if @active_battler.wait
      end
    end

  end  
  #--------------------------------------------------------------------------
  # * Make Skill Action Results (alias used to determine skill used)
  #--------------------------------------------------------------------------
  alias make_skill_action_result_anim make_skill_action_result
  def make_skill_action_result(battler = @active_battler, plus_id = 0)
    @rtab = !@target_battlers
    if $game_system.mnk_det_rtab_attck
      make_skill_action_result_anim(battler, plus_id)
    else
      @rtab ? make_skill_action_result_anim(battler) : make_skill_action_result_anim
    end
    battler.skill_used    = @skill.id
    battler.strike_skill  = @skill.id
    battler.casted = true if $game_system.mnk_det_para_spell == true
    for target in (@rtab ? battler.target : @target_battlers)
      target.struck_skill = @skill.id
    end
  end
  #--------------------------------------------------------------------------
  # * Make Item Action Results (alias used to determine item used)
  #--------------------------------------------------------------------------
  alias make_item_action_result_anim make_item_action_result
  def make_item_action_result(battler = @active_battler)
    @rtab = !@target_battlers
    @rtab ? make_item_action_result_anim(battler) : make_item_action_result_anim
    battler.item_used     = @item.id
    @item_usage           = @item.scope
    battler.strike_item   = @item.id
    for target in (@rtab ? battler.target : @target_battlers)
      target.struck_item  = @item.id
    end
  end  
  #-------------------------------------------------------------------------- 
  # * Frame Update (main phase step 1 : action preparation) (Casting Routine)
  #--------------------------------------------------------------------------
  alias update_phase4_step1_anim update_phase4_step1
  def update_phase4_step1(battler = @active_battler) 
    @rtab = !@target_battlers
    if $game_system.mnk_det_rtab_systm == true
      update_phase4_step1_anim(battler)
      if battler.current_action.kind == 1 and
        (not battler.current_action.forcing or @force != 2)
        if battler.rtp != 0    
          battler.casted = true
        end
      end
    else
      update_phase4_step1_anim
    end
  end
  #-------------------------------------------------------------------------- 
  # * Action Animation, Movement
  #--------------------------------------------------------------------------
  alias mnk_update_phase4_step3 update_phase4_step3
  def update_phase4_step3(battler = @active_battler)
    @rtab = !@target_battlers
    target = (@rtab ? battler.target : @target_battlers)[0]
    # Battle Delay System
    minkoff_delay_on
    # Flash system
    minkoff_flash(battler)
    # Reset the 'Do Nothing' flag
    dn_flag = false
    # Set values and poses based on Action 
    case battler.current_action.kind
    when 0  # Attack
      # if Do Nothing, just return
      dn_flag = true if battler.current_action.basic == 3
      if dn_flag != true
        unless JUMPING_WEAPONS.nil?
          if battler.is_a?(Game_Actor)
            battler.jump = JUMPING_WEAPONS[battler.weapon_id] if JUMPING_WEAPONS[battler.weapon_id] != nil
          end
        end
        unless JUMPING_ENEMY.nil?
          if battler.is_a?(Game_Enemy)
            battler.jump = JUMPING_ENEMY[battler.id] if JUMPING_ENEMY[battler.id] != nil
          end
        end
        rush_type = MNK_STEP_ATTACK
        full_moving = true ; if rush_type; full_moving = false; end
        if MNK_MOVE2CENTER_ATK.include?(battler.weapon_id); center_move=true ; end
        if MNK_STATIONARY_ENEMY_IDS.include?(battler.id) and battler.is_a?(Game_Enemy)
          full_moving = false
          center_move = false
          rush_type = false
        end
        # Select Attack Pose
        base_pose   = motion_pose_attack(battler)  
        base_pose2  = motion_pose_attack_random(battler)
        base_pose   = base_pose2 unless base_pose2 == nil
        if battler.current_action.basic == 2
          # If escaping, disable all movement
          full_moving = false
          center_move = false
          rush_type   = false    
          # Select Escape Pose
          base_pose = motion_pose_escape(battler)
        end
      end
    when 1  # Skill
      @spriteset.battler(battler).skill_used = battler.skill_used
      unless JUMPING_SKILLS.nil?
        battler.jump = JUMPING_SKILLS[battler.skill_used] if JUMPING_SKILLS[battler.skill_used] != nil
      end
      rush_type = MNK_STEP_SKILL
      if MNK_MOVING_SKILL.include?(battler.skill_used) ; full_moving = true ; end
      # Charlie Fleed's CTB Detection
      if $game_system.mnk_det_cfc_detect
        # For Charlie Fleed's Select All System
        if MNK_MOVING_SKILL.include?(battler.skill_used) and
          ($game_temp.selecting_all_enemies==true or $game_temp.selecting_all_allies==true); full_moving = false ; center_move = true ; end
      end        
      if MNK_MOVE2CENTER_SKILL.include?(battler.skill_used) ; center_move = true ; end        
      # Select Skill Pose        
      base_pose = motion_pose_skill(battler)        
    when 2  # Item
      @spriteset.battler(battler).item_used = battler.item_used
      unless JUMPING_ITEMS.nil?
        battler.jump = JUMPING_ITEMS[battler.item_used] if JUMPING_ITEMS[battler.item_used] != nil
      end
      rush_type = MNK_STEP_ITEM
      if MNK_MOVING_ITEM.include?(battler.item_used) or @item_scope == 1..2 ; full_moving = true ; end
      if MNK_MOVE2CENTER_ITEM.include?(battler.item_used); center_move = true; end
      # Select Item Pose  
      base_pose = motion_pose_item(battler)
    end
    # Only perform action if 'Do Nothing' flag is off, ie... doing something...
    if dn_flag != true
      # Control Movement and use current pose 
      @moved = {} unless @moved
      return if @spriteset.battler(battler).moving
      if not (@moved[battler] or battler.guarding?)
        offset = offset_value(target, battler)
        if rush_type        # Steps forward
          @spriteset.battler(battler).setmove(battler.screen_x - offset, battler.screen_y + 1, battler.screen_z)
        end
        if full_moving      # Runs to target
          @spriteset.battler(battler).setmove(target.screen_x + offset, target.screen_y - 1, target.screen_z + 10)
        end
        if center_move      # Runs to center
          @spriteset.battler(battler).setmove(320+(offset/4), battler.screen_y-1, battler.screen_z)
        end
        @moved[battler] = true
        return
        @spriteset.battler(battler).pose = base_pose
      elsif not battler.guarding?
        @spriteset.battler(battler).pose = base_pose
        @spriteset.battler(battler).setmove(battler.screen_x, battler.screen_y, battler.screen_z)
      end     
      # Finish Up Skill and Item Use
      case battler.current_action.kind
      when 1
        # Flag system that skill was used
        battler.casted = false
        battler.casting = false
        @spriteset.battler(battler).skill_used = 0
      when 2
        # Flag system that item was used
        @spriteset.battler(battler).item_used = 0
      end      
      # Battle_Charge value for BattleCry script
      $battle_charge = true
    end  
    # Battle Delay System (off)
    minkoff_delay_off    
    # Prevent 'removed battler' moved state
    @moved[battler] = false unless @moved.nil?
    # Start attack, do not move from spot
    battler.attacking = true
    # Erase Battler Jumping value
    battler.jump = nil
    # Perform the original call
    @rtab ? mnk_update_phase4_step3(battler) : mnk_update_phase4_step3
  end
  #--------------------------------------------------------------------------
  # * Battle Delay System (turned on)
  #--------------------------------------------------------------------------
  def minkoff_delay_on
    if MNK_AT_DELAY    
      # Fomar's Action Cost Detection
      if $game_system.mnk_det_acb_detect
        for actor in $game_party.actors
          actor.vitality= 0
        end
        for enemy in $game_troop.enemies
          enemy.vitality= 0
        end
      end
      # Trickster's AT Detection
      if $game_system.mnk_det_abs_detect
        for actor in $game_party.actors
          actor.at_bonus= [0,0]
        end
        for enemy in $game_troop.enemies
          enemy.at_bonus= [0,0]
        end
      end
      # Cogwheel RTAB Detection
      @rtab_wait_flag = true if $game_system.mnk_det_rtab_systm
    end    
  end
  #--------------------------------------------------------------------------
  # * Battle Delay System (turned off)
  #--------------------------------------------------------------------------
  def minkoff_delay_off
    if MNK_AT_DELAY    
      # Fomar's Action Cost Detection
      if $game_system.mnk_det_acb_detect
        for actor in $game_party.actors
          actor.vitality = 1
        end
        for enemy in $game_troop.enemies
          enemy.vitality = 1
        end
      end
      # Trickster's AT Detection
      if $game_system.mnk_det_abs_detect
        for actor in $game_party.actors
          actor.at_bonus = [1,0]
        end
        for enemy in $game_troop.enemies
          enemy.at_bonus = [1,0]
        end
      end
      # Cogwheel RTAB Detection
      @rtab_wait_flag = false if $game_system.mnk_det_rtab_systm
    end
  end  
  #--------------------------------------------------------------------------
  # * Minkoff Flash system
  #--------------------------------------------------------------------------
  def minkoff_flash(battler)
    # If enemy is a default battler
    if battler.is_a?(Game_Enemy)
      if DEFAULT_ENEMY
        if @rtab then battler.white_flash = true end
        if @rtab then battler.wait = 10 end
      end
      if DEFAULT_ENEMY_ID != nil
        if DEFAULT_ENEMY_ID.include?(battler.id)
          if @rtab then battler.white_flash = true end
          if @rtab then battler.wait = 10 end
        end 
      end        
    end
    # If actor is a default battler
    if battler.is_a?(Game_Actor)
      if DEFAULT_ACTOR
        if @rtab then battler.white_flash = true end
        if @rtab then battler.wait = 10 end
      end
      if DEFAULT_ACTOR_ID != nil
        if DEFAULT_ACTOR_ID.include?(battler.id)
          if @rtab then battler.white_flash = true end
          if @rtab then battler.wait = 10 end
        end 
      end                
    end
  end
  #--------------------------------------------------------------------------
  # * Select Attack Pose
  #--------------------------------------------------------------------------  
  def motion_pose_attack(battler)
    base_pose = pose_obtain(battler, MNK_POSE7, MNK_APOSE7, MNK_EPOSE7)
    base_pose2 = pose_array_obtain(battler, MNK_POSES_WEAPONS, MNK_POSES_WEAPS_A, MNK_POSES_WEAPS_E, battler.weapon_id)
    base_pose = base_pose2 if base_pose2 != nil    
    return base_pose
  end
  #--------------------------------------------------------------------------
  # * Select Random Attack Pose
  #--------------------------------------------------------------------------  
  def motion_pose_attack_random(battler)
    base_pose   = nil
    # Create Random pose if a set exists.
    unless MNK_RANDOM_ATTACKS == nil
      base_pose2  = rand((MNK_RANDOM_ATTACKS.size)+1 )
      base_pose   = MNK_RANDOM_ATTACKS[base_pose2 - 1] unless base_pose2 == 0
    end
    # Determine if there's an existing actor/enemy specific random pose
    pose_temp   = nil
    if battler.is_a?(Game_Actor)
      unless MNK_RANDOM_ATTACKS_A.nil?
        pose_temp = MNK_RANDOM_ATTACKS_A[battler.id] if MNK_RANDOM_ATTACKS_A.include?(battler.id)
      end
    else
      unless MNK_RANDOM_ATTACKS_E.nil?
        pose_temp = MNK_RANDOM_ATTACKS_E[battler.id] if MNK_RANDOM_ATTACKS_E.include?(battler.id)
      end
    end
    # Replace Random Pose with new actor/enemy based random pose
    unless pose_temp.nil?
      base_pose2  = rand((pose_temp.size)+1 )
      base_pose   = pose_temp[base_pose2 - 1] - 1 unless base_pose2 == 0
    end
    return base_pose
  end
  #--------------------------------------------------------------------------
  # * Select Escape Pose
  #--------------------------------------------------------------------------  
  def motion_pose_escape(battler)
    temp_pose = pose_obtain(battler, MNK_POSES_ESCAPE, MNK_POSES_ESCAPE_A, MNK_POSES_ESCAPE_E)
    base_pose = temp_pose if temp_pose != nil  
    return base_pose
  end
  #--------------------------------------------------------------------------
  # * Select Skill Pose
  #--------------------------------------------------------------------------  
  def motion_pose_skill(battler)
    base_pose = pose_obtain(battler, MNK_POSE9, MNK_APOSE9, MNK_EPOSE9)
    base_pose2 = pose_array_obtain(battler, MNK_POSES_SKILLS, MNK_POSES_SKILLS_A, MNK_POSES_SKILLS_E, battler.skill_used)
    base_pose = base_pose2 if base_pose2 != nil    
    return base_pose
  end
  #--------------------------------------------------------------------------
  # * Select Item Pose
  #--------------------------------------------------------------------------  
  def motion_pose_item(battler)
    base_pose = pose_obtain(battler, MNK_POSE8, MNK_APOSE8, MNK_EPOSE8)
    base_pose2 = pose_array_obtain(battler, MNK_POSES_ITEMS, MNK_POSES_ITEMS_A, MNK_POSES_ITEMS_E, battler.item_used)
    base_pose = base_pose2 if base_pose2 != nil
    return base_pose
  end
  #--------------------------------------------------------------------------
  # * Offset Calculation
  #--------------------------------------------------------------------------
  def offset_value(target, battler = @active_battler)
    # Obtain attacking battler width
    ww = @spriteset.battler(battler).width / 2
    # Set current attack offset    
    offst = @spriteset.battler(battler).battler_offset
    offst += MNK_OFFSET
    # Oversized or special Battler offsets
    if target.is_a?(Game_Enemy) && battler.is_a?(Game_Actor)
      unless MNK_OFFSET_ATK_A.nil?
        offst -= MNK_OFFSET_ATK_A[battler.id] if MNK_OFFSET_ATK_A.include?(battler.id)
      end
      unless MNK_OFFSET_DEF_E.nil?
        offst += MNK_OFFSET_DEF_E[target.id]  if MNK_OFFSET_DEF_E.include?(target.id)
      end
    end
    if target.is_a?(Game_Actor) && battler.is_a?(Game_Enemy)
      unless MNK_OFFSET_ATK_E.nil?
        offst -= MNK_OFFSET_ATK_E[battler.id] if MNK_OFFSET_ATK_E.include?(battler.id)
      end
      unless MNK_OFFSET_DEF_A.nil?
        offst += MNK_OFFSET_DEF_A[target.id]  if MNK_OFFSET_DEF_A.include?(target.id)
      end
    end
    # Offset calc dependant on sideview
    if $game_system.sv_angle == 1
      offset = (battler.is_a?(Game_Actor) ? -(offst-ww) : offst-ww)
    else
      offset = (battler.is_a?(Game_Actor) ? offst-ww : -(offst-ww))
    end
    return offset
  end
  #--------------------------------------------------------------------------
  # * Hit Animation
  #--------------------------------------------------------------------------
  alias mnk_update_phase4_step4 update_phase4_step4
  def update_phase4_step4(battler = @active_battler)
    # Cycle through the targets
    for target in (@rtab ? battler.target : @target_battlers)
      damage = (@rtab ? target.damage[battler] : target.damage)
      critical = (@rtab ? target.critical[battler] : target.critical)
      if damage.is_a?(Numeric) and damage > 0
        base_pose = pose_obtain(target, MNK_POSE2, MNK_APOSE2, MNK_EPOSE2)
        weapon_used = battler.weapon_id
        weapon_used = 0 if weapon_used == nil
        base_pose2 = pose_array_obtain(target, MNK_STRUCK_WEAPS, MNK_STRUCK_WEAPS_A, MNK_STRUCK_WEAPS_E, weapon_used)
        base_pose = base_pose2 if base_pose2 != nil
        if battler.strike_skill != 0
          if battler.strike_skill == target.struck_skill
            base_pose2 = pose_array_obtain(target, MNK_STRUCK_SKILLS, MNK_STRUCK_SKILLS_A, MNK_STRUCK_SKILLS_E, target.struck_skill)
            base_pose = base_pose2 if base_pose2 != nil
          end
        end
        if battler.strike_item != 0
          if battler.strike_item == target.struck_item
            base_pose2 = pose_array_obtain(target, MNK_STRUCK_ITEMS, MNK_STRUCK_ITEMS_A, MNK_STRUCK_ITEMS_E, target.struck_item)
            base_pose = base_pose2 if base_pose2 != nil
          end
        end
        @spriteset.battler(target).pose = base_pose
        if critical == true
          temp_pose = pose_obtain(target, MNK_POSES_CRITICAL, MNK_POSES_CRIT_A, MNK_POSES_CRIT_E)
          weapon_used = battler.weapon_id
          weapon_used = 0 if weapon_used == nil
          base_pose2 = pose_array_obtain(target, MNK_CRIT_WEAPS, MNK_CRIT_WEAPS_A, MNK_CRIT_WEAPS_E, weapon_used)
          base_pose = base_pose2 if base_pose2 != nil
          if battler.skill_used != 0
            if battler.skill_used == target.struck_skill
              base_pose2 = pose_array_obtain(target, MNK_CRIT_SKILLS, MNK_CRIT_SKILLS_A, MNK_CRIT_SKILLS_E, target.struck_skill)
              base_pose = base_pose2 if base_pose2 != nil
            end
          end
          if battler.item_used != 0
            if battler.item_used == target.struck_item
              base_pose2 = pose_array_obtain(target, MNK_CRIT_ITEMS, MNK_CRIT_ITEMS_A, MNK_CRIT_ITEMS_E, target.struck_item)
              base_pose = base_pose2 if base_pose2 != nil
            end
          end
          @spriteset.battler(target).pose = temp_pose if temp_pose != nil
        end
      else
        base_pose = pose_obtain(target, MNK_DODGE, MNK_ADODGE, MNK_EDODGE)
        weapon_used = battler.weapon_id
        weapon_used = 0 if weapon_used == nil
        base_pose2 = pose_array_obtain(target, MNK_DODGE_WEAPS, MNK_DODGE_WEAPS_A, MNK_DODGE_WEAPS_E, weapon_used)
        base_pose = base_pose2 if base_pose2 != nil
        if battler.strike_skill != 0
          if battler.strike_skill == target.struck_skill
            base_pose2 = pose_array_obtain(target, MNK_DODGE_SKILLS, MNK_DODGE_SKILLS_A, MNK_DODGE_SKILLS_E, target.struck_skill)
            base_pose = base_pose2 if base_pose2 != nil
          end
        end
        if battler.strike_item != 0
          if battler.strike_item == target.struck_item
            base_pose2 = pose_array_obtain(target, MNK_DODGE_ITEMS, MNK_DODGE_ITEMS_A, MNK_DODGE_ITEMS_E, target.struck_item)
            base_pose = base_pose2 if base_pose2 != nil
          end
        end
        @spriteset.battler(target).pose = base_pose
      end
    end
    # Reset/zero out the battler's skill & item
    battler.strike_skill  = 0
    battler.strike_item   = 0
    # Perform the original call
    @rtab ? mnk_update_phase4_step4(battler) : mnk_update_phase4_step4
    # Finish attack n battle animation, free to move
    battler.attacking = false
  end  
  #-------------------------------------------------------------------------- 
  # * Victory Animation
  #--------------------------------------------------------------------------
  alias mnk_start_phase5 start_phase5
  def start_phase5
    unless $game_system.mnk_det_trtab_syst == true
      for actor in $game_party.actors
        return if @spriteset.battler(actor).moving
      end
    end
    # See if an actor remains alive
    for actor in $game_party.actors
      $game_system.victory = true unless actor.dead?
    end
    # See if an enemy remains alive
    for enemy in $game_troop.enemies.reverse
      $game_system.defeat = true unless enemy.dead?
    end
    # Perform the original call    
    mnk_start_phase5
  end
  #--------------------------------------------------------------------------
  # * Change Arrow Viewport
  #--------------------------------------------------------------------------
  alias mnk_start_enemy_select start_enemy_select
  def start_enemy_select
    # Perform the original call
    mnk_start_enemy_select
    # Arrow manipulation
    @enemy_arrow.dispose
    @enemy_arrow = Arrow_Enemy.new(@spriteset.viewport2)
    @enemy_arrow.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  # * Obtain Pose (Scene Battle version)
  #     battler     : battler performing attack
  #     pose_base   : default pose to return
  #     pose_actor  : list of poses for actors
  #     pose_enemy  : list of poses for enemies
  #--------------------------------------------------------------------------
  def pose_obtain(battler, pose_base, pose_actor, pose_enemy)
    # create Arrays
    pos_a = {}
    pos_e = {}
    # fill created Arrays & Set pose
    pos_a = pose_actor
    pos_e = pose_enemy
    pose_now = pose_base
    # Obtain pose if not a standard pose
    if battler.is_a?(Game_Actor)
      pose_now = pos_a[battler.id] if pos_a[battler.id] != nil
    else
      pose_now = pos_e[battler.id] if pos_e[battler.id] != nil
    end
    # Return the final pose (minus 1 for niceties)
    pose_now -= 1 if pose_now != nil
    return pose_now
  end
  #--------------------------------------------------------------------------
  # * Obtain Pose from hashes (Scene Battle version)
  #     battler     : battler performing attack
  #     hash_base   : hash with default poses
  #     hash_actor  : advanced list of poses for actors
  #     hash_enemy  : advanced list of poses for enemies
  #     condition   : value determining where to get the final pose
  #--------------------------------------------------------------------------
  def pose_array_obtain(battler, hash_base, hash_actor, hash_enemy, condition)
    # create Arrays
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
    if battler.is_a?(Game_Actor)
      pose_temp = hash_a[battler.id] if hash_a.include?(battler.id)
    else
      pose_temp = hash_e[battler.id] if hash_e.include?(battler.id)
    end
    # Obtain the base pose based on condition (or nil)
    pose_now = hash_b[condition] if hash_b.include?(condition)
    # Obtain the optional actor/enemy pose based on condition (unless nil)
    pose_now = pose_temp[condition] if pose_temp.include?(condition)
    # Return the final pose (minus 1 for niceties)
    pose_now -= 1 if pose_now != nil
    return pose_now
  end
end
