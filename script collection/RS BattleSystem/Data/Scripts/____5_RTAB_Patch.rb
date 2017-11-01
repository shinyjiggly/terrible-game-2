#==============================================================================
# ** Animated Battlers - Enhanced   ver. 13.7                      (01-03-2012)
#
#------------------------------------------------------------------------------
#  * (5) RTAB PATCH:  To allow specialized pausing system (unlike other AT's)
#============================================================================== 

=begin

                                W A R N I N G

This section of the script should be used exclusively with RTAB.  Though it is
part of the  Animated Battlers system,  this is merely a patch  to allow it to
perform the AT Delay feature for the RTAB system... and RTAB system only.   If
you intend to use this patch on any other battlesystem, your project may crash,
your computer may blow up,  the Eiffel Tower may melt,  dogs and cats may start
to live together... 

You have been warned...

=end

=begin
#==============================================================================
# ** Scene_Battle 
#------------------------------------------------------------------------------ 
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #-------------------------------------------------------------------------- 
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :rtab_wait_flag
  #-------------------------------------------------------------------------- 
  # * Main Processing
  #--------------------------------------------------------------------------
  alias mnk_main main    
  def main
    @rtab_wait_flag = false
    mnk_main
  end  
  #--------------------------------------------------------------------------
  # * Frame renewal (AT gauge renewal phase)
  #--------------------------------------------------------------------------
  alias mnk_up0 update_phase0
  def update_phase0  
    mnk_up0 unless @rtab_wait_flag
  end
  #-------------------------------------------------------------------------- 
  # * Frame Update (main phase step 1 : action preparation)
  #--------------------------------------------------------------------------
  alias mnk_awr anime_wait_return
  def anime_wait_return
    return true if @rtab_wait_flag
    mnk_awr
  end
end
=end