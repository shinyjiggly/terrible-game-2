__END__

# Heretic - These transitions take place when a Battler dies.
# remove __END__ to enable this script.
# ThallionDarkshine didnt include any instructions with this script.
# It does require his rgss_addon.dll and Transitions Module script to work.

module Battler_Trans
  # Animations
  #   parameters: (animation_type, animation_duration, animation_parameters, ease)
  #            or (animation_type, animation_duration, ease)
  #   note - the script no longer uses this set of animations, it is just in the script
  #     to show the different effects
  @trans = [
    # Slicing Animations (Animation #0)
    #   parameters: (amount_movement)
    [0, 40],
    [0, 20],
    [0, 20, [0.6]],
    # Fading Animations (Animation #1)
    #   parameters: none
    [1, 20],
    [1, 30],
    # Zooming Animations (Animation #2)
    #   parameters: (x_zoom, y_zoom) or (zoom)
    [2, 30],
    [2, 20, [1.2]],
    [2, 30, [1, 0]],
    [2, 30, [0, 1]],
    [2, 30, [1.8, 0.2]],
    [2, 30, [0.2, 1.8]],
    [2, 30, [0.2]],
    # Zooming and Spinning Animations (Animation #3)
    #   parameters: (x_zoom, y_zoom, spin_degrees) or (zoom, spin_degrees)
    [3, 20],
    [3, 40, [1.8, 0.2, 720]],
    [3, 40, [0.2, 810]],
    [3, 40, [0.2, 1.8, 720]],
    # 3D Spin Animations (Animation #4)
    #   parameters: (zoom, num_rotations)
    [4, 40],
    [4, 40, [0, 4]],
    [4, 40, [0.5, 6]],
    [4, 30, [0.7, 2]],
    # Slide-In Animations (Animation #5)
    #   parameters: (slide_direction)
    [5, 24],
    [5, 24, [-1]],
    # Fold Animations (Animation #6)
    #   parameters: none
    [6, 30],
    # Shaking Animations (Animation #7)
    #   parameters: (x_strength, x_speed, y_strength, y_speed) or (x_intensity, y_intensity)
    [7, 40],
    [7, 40, [6..9, 4..7]],
    # Ripple/Distort Animations (Animation #8)
    #   parameters: (x_amplitude, x_wavelength, num_x_ripples, y_amplitude, y_wavelength, num_y_ripples) or (x_amount, num_x_ripples, y_amount, num_y_ripples)
    [8, 40],
    [8, 40, [40, 10, 0.5, 10, 10, 2]],
    [8, 40, [10, 10, 2, 40, 10, 0.5]],
    [8, 40, [10, 40, 2, 10, 10, 2]],
    [8, 40, [10, 10, 2, 10, 40, 2]],
    [8, 40, [10, 10, 3, 10, 10, 2]],
    [8, 40, [10, 10, 2, 10, 10, 3]],
    [8, 10, [10, 40, 0.5, 10, 10, 0.5]],
    [8, 10, [10, 10, 0.5, 10, 40, 0.5]],
    # Dissolve to Sprite Animations (Animation #9)
    #   parameters: (fade_duration)
    #            or (fade_duration, x_size, y_size, negative?, tint_amount,
    #                tint_red, tint_green, tint_blue)
    #            or (fade_duration, x_size, y_size, negative?, tint_amount,
    #                tint_red, tint_green, tint_blue, grayscale_amount)
    #   note - use a float for x_size or y_size to specify it as a fraction
    #     example - 1.0 for the width of the sprite, 0.5 for half the width, and so on
    [9, 40],
    [9, 40, [10, 1.0, 1, false, 50, 200, 50, 50]],
    [9, 40, [10, 5, 5, true, 50, 100, 200, 200]],
    [9, 40, [10, 1, 1.0, false, 0, 0, 0, 0, 100]],
    # Dissolve Animations (Animation #10)
    [10, 40],
    [10, 40, [1, 1.0]],
    [10, 40, [5, 5]],
    [10, 20, [10, 10]],
    # Transition Graphic Animations (Animation #11)
    #   parameters: (transition_graphic_name, fade_duration)
    #     fade_duration - how long it takes for each individual pixel of the
    #       sprite to fade out
    [11, 100],
    [11, 40, ['001-Blind01', 5]],
  ]
  
  def self.transitions(enemy_id)
    case enemy_id
    when 0 then return @trans
    else return @trans
    end
  end
  
  def self.trans=(val)
    @trans = val
  end
  
  def self.trans
    @trans
  end
end

unless Object.const_defined?(:Transitions)
  raise 'This script requires ThallionDarkshine\'s Transitions Module'
end

class Sprite_Battler
  attr_accessor :pos
  
  alias tdks_transitions_collapse collapse
  def collapse
    trans = Battler_Trans.transitions(@battler.id)
    if trans.length > 0
      rnd = rand(trans.length)
      rnd = trans[rnd].map { |i| (i.is_a?(Array) ? i.clone : i) }
      Transitions.transition_out(self, *rnd)
      @pos = [self.x, self.y]
    else
      tdks_transitions_collapse
    end
  end
  
  alias tdks_transitions_update update
  def update
    tdks_transitions_update
    if defined?(@pos)
      self.x, self.y = *@pos
    end
  end
end