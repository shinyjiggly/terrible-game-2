#==============================================================================
# ** Tilemap (Flash Data)
#------------------------------------------------------------------------------
# SephirothSpawn
# Version 1.0 a
# 2007-05-30
# SDK Compatible with Version 2.2 + : Parts I & II
#==============================================================================


#==============================================================================
# ** Tilemap
#==============================================================================

class Tilemap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :update_flashtiles
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias_method :seph_tilemapflashdata_tilemap_setup,   :setup
  alias_method :seph_tilemapflashdata_tilemap_dispose, :dispose
  alias_method :seph_tilemapflashdata_tilemap_update,  :update
  #--------------------------------------------------------------------------
  # * Update Flashtiles
  #--------------------------------------------------------------------------
  def update_flashtiles=(bool)
    # Set Instance
    @update_flashtiles = bool
    # If True and Nil Flash Tiles
    if bool && @flash_sprites.nil?
      # Setup Flash Sprites
      setup_flash_sprites
    end
    # If False and Flash Tiles Exist
    if bool == false && @flash_sprites != nil
      # Turn Tiles Invisible
      @flash_sprites.each { |sprite| sprite.visible = false }
    end
  end
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup
    # Original Setup
    seph_tilemapflashdata_tilemap_setup
    # Turn Update Flashtiles Off
    self.update_flashtiles = Tilemap_Options::Default_Update_Flashtiles
  end
  #--------------------------------------------------------------------------
  # * Setup Flash Sprites
  #--------------------------------------------------------------------------
  def setup_flash_sprites
    # Creates Flash Data Sprites
    @flash_sprites = []
    @flashing_sprites = []
    @flash_sprite_size = @tilesize
    for x in 0...@map_data.xsize
      for y in 0...@map_data.ysize
        sprite = Sprite.new(@viewport)
        sprite.x, sprite.y, sprite.z = x * @tilesize, y * @tilesize, 151
        sprite.bitmap = Bitmap.new(@tilesize, @tilesize)
        @flash_sprites << sprite
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # Original Dispose
    seph_tilemapflashdata_tilemap_dispose
    # Dispose Layers (Sprites)
    unless @flash_sprites.nil?
      @flash_sprites.each { |sprite| sprite.dispose }
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Original Update
    seph_tilemapflashdata_tilemap_update
    # If Update Flashtiles and Sizes don't Match
    if @update_flashtiles && @flash_sprite_size != @tilesize
      # Setup Flash Sprites
      setup_flash_sprites
    end
    # If Update Flashtiles and Flash Data isn't Nil
    if @update_flashtiles && @flash_data != nil
      # Get X Tiles
      x1 = [@ox / @tilesize - Autotile_Padding, 0].max
      x2 = [@viewport.rect.width / @tilesize + Autotile_Padding, 
                 @map_data.xsize].min
      # Get Y Tiles
      y1 = [@oy / @tilesize - Autotile_Padding, 0].max
      y2 = [@viewport.rect.height / @tilesize + Autotile_Padding, 
                 @map_data.ysize].min
      # Update Flash Data Sprites
      for sprite in @flash_sprites
        sprite.ox, sprite.oy = @ox, @oy
        sprite.update
        # Gets RGB Value
        x, y = sprite.x / @tilesize, sprite.y / @tilesize
        # Skip If Not On Screen (or without padding)
        next unless x.between?(x1, x2) && y.between?(y1, y2)
        rgb = @flash_data.nil? ? nil : @flash_data[x, y]
        if rgb.nil? || rgb == 0
          # If Sprite Flashing
          if @flashing_sprites.include?([x, y])
            sprite.bitmap.clear
            @flashing_sprites.delete([x, y])
          end
        else
          # If Sprite Not Already Flashing
          unless @flashing_sprites.include?([x, y])
            @flashing_sprites << [x, y]
            sprite.bitmap.fill_rect(0, 0, 32, 32, 
              Tilemap_Options::Flash_Bitmap_C)
          end
          if Graphics.frame_count % Tilemap_Options::Flash_Duration == 0
            r, g, b = rgb / 0x010000, rgb / 0x100 % 0x100, rgb % 0x100
            sprite.flash((c = Color.new(r, g, b)), Tilemap_Options::Flash_Duration)
          end
        end
      end
    end
  end
end