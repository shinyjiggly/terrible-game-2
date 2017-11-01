=begin script                    ■ Hermes - Hermes Extends RMXP's MEssage System
	Name "Hermes configuration (name box)"
	Configuration for the name box. If you removed the name box tag, you can
	remove this script as well.
=end
class Hermes
	module Name                    # Configuration for name box
		module Text                    # Configuration for the text it contains
			NAME    = :default             # Font's name (case sensitive)
			SIZE    = :default             # Text size in pt
			COLOR   = :default             # Text color (Color.new(r, g, b))
			BOLD    = :default             # Text boldness (true/false)
			ITALIC  = :default             # Text italicness   -"-
		end
		module Box                     # Configuration for the box itself
			POS     = 0                    # Position: 0=top left,    1=top right,
			                               #           3=bottom left, 2=bottom right
			OVERLAP = 16            # Number of pixels overlapping the message box (y)
			OFFSET  = 8             # Number of pixels apart from the corner (x)
			PADDING = 4             # Number of pixels left and right of the content
			SWAP    = true          # Swap position when name box would leave screen
			OPACITY = 200                  # Opacity (255 = fully opaque)
			SKIN    = :default             # Windowskin
		end
	end
end
class Window_Name < Window_Base; end