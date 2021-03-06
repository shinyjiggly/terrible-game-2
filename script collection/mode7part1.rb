#============================================================================ 
# This script adds a kind of depth for the maps. 
# Written by MGCaladtogel 
# English version (21/05/07) 
#---------------------------------------------------------------------------- 
# Instructions : 
# You must add to the map's name : 
#- [M7] : to activate Mode7 
#- [#XX] : XX is the slant angle (in degree). Default value is 0 (normal maps) 
#- [Y] : Y-map looping 
#- [X] : X-map looping. This option needs resources (lower fps). 
#- [A] : animated autotiles (with 4 patterns). This option increases 
# significantly the loading time, so it may crash for large maps 
# (SystemStackError) 
#- [C] : to center the map on the hero (even for small maps) 
#- [P] : to have a fixed panorama 
#- [H] : to have a white horizon 
#- [OV] : Overworld Sprite Resize (a Mewsterus's script feature) 
# 
# OR : 
# see the "$mode7_maps_settings" below (l.48) to prapare your settings 
#---------------------------------------------------------------------------- 
# Other commands (for events) : 
#- $scene.spriteset.tilemap.mode7_set(new_angle) 
# To redraw the map with the new_angle 
#- $scene.spriteset.tilemap.mode7_set_p(new_angle) 
# To redraw progressively the map from the current angle to the new 
#- $scene.spriteset.tilemap.mode7_redraw 
# To redraw the map (useful with the following commands) 
#- $game_system.map_opacity = value 
# To define the opacity for Mode7 maps (it needs to redraw) 
#- $game_system.map_gradual_opacity = value 
# To define a gradual opacity for Mode7 maps (it needs to redraw) 
# (it bugs with horizontal looping) 
#- $game_system.map_tone = Color.new(Red, Green, Blue) 
# To define the tone for Mode7 maps (it needs to redraw) 
#- $game_system.map_gradual_tone = Tone.new(Red, Green, Blue, Gray) 
# To define a gradual tone for Mode7 maps (it needs to redraw) 
#- $game_system.horizon = value 
# To define the view's distance (default : 960) (it needs to redraw) 
#- $game_system.reset 
# To initialize the previous options 
# 
#- To obtain flat events : 
# just add a comment in the event's commands list with : "Flat" 
# 
#- To handle the height of a vertical event : 
# add a comment in the event's commands list with : "Heigth X", where X is the 
# height value ("Heigth 2" will draw the event 64 pixels above its original 
# position - you can use floats) 
#============================================================================ 
# The map is drawn from all the tiles of the three layers that do not have a 
# terrain_tag's value of 1 or 2. 
# The other tiles (terrain_tag = 1 or 2) form elements that are drawn vertically, 
# like the 3rd-layer elements in the old version. 
# The 2 terrains ID used to form vertical elements 
$terrain_tags_vertical_tiles = [1,2] # You can modify these values 
# To access maps names 
$data_maps = load_data("Data/MapInfos.rxdata") 
$mode7_maps_settings = {} 
# Prepare your own settings for mode7 maps 
# Just put the first parameter in a map's name 
# For example : 
$mode7_maps_settings["Worldmap"] = ["#60", "X", "Y", "A", "H", "OV"] 
# -> will be called when "Worldmap" is included in the name 
$mode7_maps_settings["Smallslant"] = ["#20", "A", "S"] 
# Add any number of settings you want 


#============================================================================ 
# �  Game_System 
#---------------------------------------------------------------------------- 
# Add attributes to this class 
#============================================================================ 

class Game_System 
attr_accessor :mode7 # false : normal map / true : mode 7 
attr_accessor :loop_x # true : horizontal-looping map 
attr_accessor :loop_y # true : vertical-looping map 
attr_accessor :always_scroll # true : to center the camera around the hero 
attr_accessor :map_tone # mode7 map's tone (Color) 
attr_accessor :map_opacity # mode7 map's opacity (0..255) 
attr_accessor :animated # true : animated autotiles for mode7 maps 
attr_accessor :white_horizon # true : white line horizon for mode7 maps 
attr_accessor :angle # mode7 map's slant angle (in degree) 
attr_accessor :horizon # horizon's distance 
attr_accessor :fixed_panorama # true : to fix the panorama (no scrolling any more) 
attr_accessor :ov # true : Overworld Sprite Resize (smaller hero's sprite) 
attr_accessor :ov_zoom # resize's value with ov 
attr_accessor :map_gradual_opacity # mode7 map's gradual opacity (0..255) 
attr_accessor :map_gradual_tone # mode7 map's gradual tone (Color) 
#-------------------------------------------------------------------------- 
# * Object Initialization 
#-------------------------------------------------------------------------- 
alias initialize_mode7_game_system initialize 
def initialize 
initialize_mode7_game_system 
self.mode7 = false 
self.loop_x = false 
self.loop_y = false 
self.always_scroll = false 
self.animated = false 
self.white_horizon = false 
self.angle = 0 
self.fixed_panorama = false 
self.ov = false 
self.ov_zoom = 0.6 
reset 
end 
#-------------------------------------------------------------------------- 
# * Reset the values for opacity, tone and horizon's distance 
#-------------------------------------------------------------------------- 
def reset 
self.map_opacity = 255 
self.map_tone = Color.new(0,0,0,0) 
self.horizon = 960 # default value, equivalent to 30 tiles 
self.map_gradual_opacity = 0 
self.map_gradual_tone = Tone.new(0,0,0,0) 
end 
end 

#============================================================================ 
# �  Tilemap_mode7 
#---------------------------------------------------------------------------- 
# This new Tilemap class handles the drawing of a mode7 map 
#============================================================================ 

class Tilemap_mode7 
attr_accessor :maps_list # contains map's graphics 
attr_accessor :map_ground # original map's graphic to handle flat events 
attr_accessor :tone_values # tone values for each line (Hash) 
attr_accessor :opacity_values # opacity values for each line (Hash) 
#-------------------------------------------------------------------------- 
# * Object Initialization 
# viewport : viewport 
#-------------------------------------------------------------------------- 
def initialize(viewport) 
@id = $game_map.map_id # map's ID : to load or save the map in Cache 
@maps_list = [] # contains map's drawings (Bitmap) 
@disp_y = $game_map.display_y # @disp_y : tilemap's display_y 
@disp_x = $game_map.display_x # @disp_x : tilemap's display_x 
@height = 32 * $game_map.height # @height : map's height (in pixel) 
@width = 32 * $game_map.width # @width : map's width (in pixel) 
$game_temp.height = @height 
# map's drawings are loaded if already in Cache 
if RPG::Cache_Carte.in_cache(@id) 
@map = RPG::Cache_Carte.load(@id) 
@maps_list.push(@map) 
@map_ground = RPG::Cache_Carte.load(@id, 4) # to handle flat events 
if $game_system.animated 
@map_2 = RPG::Cache_Carte.load(@id, 1) 
@map_3 = RPG::Cache_Carte.load(@id, 2) 
@map_4 = RPG::Cache_Carte.load(@id, 3) 
@maps_list.push(@map_2) 
@maps_list.push(@map_3) 
@maps_list.push(@map_4) 
end 
else # draw the map and save it in the Cache 
draw_map 
end 
# create vertical elements from tiles 
data_V = Data_Vertical_Sprites.new(viewport) 
# @sprites_V : list of vertical sprites (Sprite_V) 
@sprites_V = data_V.list_sprites_V 
# @sprites_V_animated : list of animated vertical sprites (Sprite_V) 
@sprites_V_animated = data_V.list_sprites_V_animated 
@angle = $game_system.angle # map's slant angle (in degree) 
@distance_h = 480 # distance between the map's center and the vanishing point 
@pivot = 256 # screenline's number of the slant's pivot 
@index_animated = 0 # 0..3 : index of animated tiles pattern 
@viewport = viewport 
@tone_values = {} # list of the tone values for each line 
@opacity_values = {} # list of the opacity values for each line 
init_sprites(@angle) # initialize screenlines sprites 
end 
#-------------------------------------------------------------------------- 
# * Dispose 
#-------------------------------------------------------------------------- 
def dispose 
# dispose of @sprites (scanlines), @sprites_V (vertical_sprites), and 
# @sprites_loop_x (additional scanlines for horizontal looping) 
for sprite in @sprites + @sprites_V + @sprites_loop_x 
sprite.dispose 
end 
@sprites.clear 
@sprites_loop_x.clear 
@sprites_V.clear 
@sprites_V_animated.clear 
@maps_list.clear 
$game_system.angle = @angle 
end 
#-------------------------------------------------------------------------- 
# * Increase slant's angle 
#-------------------------------------------------------------------------- 
def increase_angle 
return if @angle == 88 
@angle = [@angle + 2, 88].min # angle's value between 0 and 88 degrees 
@sprites.clear 
@sprites_loop_x.clear 
init_sprites(@angle) # reinitialize screenlines sprites 
end 
#-------------------------------------------------------------------------- 
# * Decrease slant's angle 
#-------------------------------------------------------------------------- 
def decrease_angle 
return if @angle == 0 
@angle = [@angle - 2, 0].max # angle's value between 0 and 88 degrees 
@sprites.clear 
@sprites_loop_x.clear 
init_sprites(@angle) # reinitialize screenlines sprites 
end 
#-------------------------------------------------------------------------- 
# * Slide from the current angle into the target value 
# value : target angle's value (in degree) 
#-------------------------------------------------------------------------- 
def mode7_set_p(value) 
while value > @angle 
increase_angle 
update 
Graphics.update 
end 
while value < @angle 
decrease_angle 
update 
Graphics.update 
end 
end 
#-------------------------------------------------------------------------- 
# * Redraw the map instantaneously with the new slant angle's value 
# value : target angle's value (in degree) 
#-------------------------------------------------------------------------- 
def mode7_set(value) 
@angle = [[value, 0].max, 89].min 
@sprites.clear 
@sprites_loop_x.clear 
init_sprites(@angle) # reinitialize screenlines sprites 
update 
Graphics.update 
end 
#-------------------------------------------------------------------------- 
# * Reinitialize screenlines sprites 
#-------------------------------------------------------------------------- 
def mode7_redraw 
@sprites.clear 
@sprites_loop_x.clear 
init_sprites(@angle) # reinitialize scanlines 
update 
Graphics.update 
end 
#-------------------------------------------------------------------------- 
# * Create sprites equivalent to scanlines 
# value : target angle's value (in degree) 
#-------------------------------------------------------------------------- 
def init_sprites(angle) 
@horizon = $game_system.horizon 
angle_rad = (Math::PI * angle) / 180 # angle in radian 
@sprites = [] # list of the scanlines sprites (Sprite) 
@sprites_loop_x = [] # list of the additionnal sprites (for X-looping) 
cos_angle = Math.cos(angle_rad) 
sin_angle = Math.sin(angle_rad) 
# save values in $game_temp 
$game_temp.distance_h = @distance_h 
$game_temp.pivot = @pivot 
$game_temp.cos_angle = cos_angle 
$game_temp.sin_angle = sin_angle 
# h0, z0 : intermediate values 
h0 = (- @distance_h * @pivot * cos_angle).to_f / 
(@distance_h + @pivot * sin_angle) + @pivot 
z0 = @distance_h.to_f / (@distance_h + @pivot * sin_angle) 
$game_temp.slope_value = (1.0 - z0) / (@pivot - h0) 
$game_temp.corrective_value = 1.0 - @pivot * $game_temp.slope_value 
last_line = - @pivot - @horizon # last_line : the highest line that is drawn 
height_limit = (@distance_h * last_line * cos_angle).to_f / 
(@distance_h - last_line * sin_angle) + @pivot # the line corresponding to 
# the last_line in the warped reference = horizon's line 
$game_temp.height_limit = height_limit 
# constant to handle gradual opacity 
k2lim = ((@distance_h * last_line).to_f / 
(@distance_h * cos_angle + last_line * sin_angle)).to_i 
# one sprite is created for each screenline 
for j in 0..479 
next if j < height_limit # if the line is further than the horizon's line, 
# no sprite is created 
i = j - @pivot # y-reference is the pivot's line 
sprite = Sprite.new(@viewport) 
sprite.x = 320 # x-reference is the vertical line in the middle of the screen 
sprite.y = j 
sprite.z = - 99999 # map must not mask vertical elements 
sprite.y_origin_bitmap = (@distance_h * i).to_f / 
(@distance_h * cos_angle + i * sin_angle) + @pivot 
sprite.y_origin_bitmap_i = (sprite.y_origin_bitmap + 0.5).to_i 
sprite.y_origin_bitmap_i %= @height if $game_system.loop_y 
sprite.zoom_x = $game_temp.slope_value * j + $game_temp.corrective_value 
sprite.length = 2 + (640.to_f / sprite.zoom_x).to_i 
sprite.x_origin_bitmap_i = ((642 - sprite.length) / 2) 
sprite.x_origin_bitmap_i %= @width if $game_system.loop_x 
sprite.x_origin_bitmap = (sprite.x_origin_bitmap_i).to_f 
sprite.ox = sprite.length / 2 
sprite.bitmap = @map 
# horizontal translation to center around the hero 
if @disp_x != 0 
sprite.x_origin_bitmap += @disp_x / 4 
sprite.x_origin_bitmap_i = (sprite.x_origin_bitmap).to_i 
sprite.x_origin_bitmap_i %= @width if $game_system.loop_x 
end 
# vertical translation to center around the hero 
if @disp_y != 0 
sprite.y_origin_bitmap += @disp_y / 4 
sprite.y_origin_bitmap_i = (sprite.y_origin_bitmap + 0.5).to_i 
sprite.y_origin_bitmap_i %= @height if $game_system.loop_y 
end 
# handle opacity and tone 
k2 = ((@distance_h * i).to_f / 
(@distance_h * cos_angle + i * sin_angle)).to_i 
k2 = 0 if k2 > 0 
k_red = (- k2.to_f/k2lim * $game_system.map_gradual_tone.red).to_i 
k_green = (- k2.to_f/k2lim * $game_system.map_gradual_tone.green).to_i 
k_blue = (- k2.to_f/k2lim * $game_system.map_gradual_tone.blue).to_i 
k_gray = (- k2.to_f/k2lim * $game_system.map_gradual_tone.gray).to_i 
k2 = (- k2.to_f/k2lim * $game_system.map_gradual_opacity).to_i 
sprite.tone = Tone.new(k_red, k_green, k_blue, k_gray) 
sprite.opacity = 255 - k2 
sprite.opacity *= ($game_system.map_opacity).to_f / 255 
sprite.color = $game_system.map_tone 
# white horizon's line 
k = j - height_limit 
k = 500 / k 
if $game_system.white_horizon 
tone_red = sprite.tone.red + k 
tone_green = sprite.tone.green + k 
tone_blue = sprite.tone.blue + k 
tone_gray = sprite.tone.gray + k 
sprite.tone = Tone.new(tone_red, tone_green, tone_blue, tone_gray) 
end 
@tone_values[j] = sprite.tone 
@opacity_values[j] = sprite.opacity 
# set sprite's graphics 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
@sprites.push(sprite) 
if $game_system.loop_x and j < @pivot 
# additional sprite to handle horizontal looping 
sprite2 = Sprite.new(@viewport) 
sprite2.x = 320 
sprite2.y = j 
sprite2.z = - 99999 
sprite2.y_origin_bitmap = sprite.y_origin_bitmap 
sprite2.y_origin_bitmap_i = sprite.y_origin_bitmap_i 
sprite2.zoom_x = sprite.zoom_x 
sprite2.length = sprite.length 
sprite2.x_origin_bitmap_i = sprite.x_origin_bitmap_i - @width 
sprite2.x_origin_bitmap = sprite.x_origin_bitmap_i - @width 
sprite2.ox = sprite.ox 
sprite2.bitmap = @map 
sprite2.opacity = sprite.opacity 
sprite2.color = sprite.color 
sprite2.tone = sprite.tone 
sprite2.src_rect.set(sprite2.x_origin_bitmap_i, sprite2.y_origin_bitmap_i, 
sprite2.length, 1) 
@sprites_loop_x.push(sprite2) 
end 
end 
end 
#-------------------------------------------------------------------------- 
# * Update the screenlines sprites and the vertical sprites 
# compare tilemap's display with map's display 
#-------------------------------------------------------------------------- 
def update 
# update screenlines sprites 
if @disp_y < $game_map.display_y 
difference = $game_map.display_y - @disp_y 
@disp_y += difference 
for sprite in @sprites + @sprites_loop_x 
sprite.y_origin_bitmap += difference.to_f / 4 
sprite.y_origin_bitmap_i = (sprite.y_origin_bitmap+0.5).to_i 
sprite.y_origin_bitmap_i %= @height if $game_system.loop_y 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
end 
if @disp_y > $game_map.display_y 
difference = @disp_y - $game_map.display_y 
@disp_y -= difference 
for sprite in @sprites + @sprites_loop_x 
sprite.y_origin_bitmap -= difference.to_f / 4 
sprite.y_origin_bitmap_i = (sprite.y_origin_bitmap+0.5).to_i 
sprite.y_origin_bitmap_i %= @height if $game_system.loop_y 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
end 
if @disp_x < $game_map.display_x 
difference = $game_map.display_x - @disp_x 
@disp_x += difference 
for sprite in @sprites 
sprite.x_origin_bitmap += difference.to_f / 4 
sprite.x_origin_bitmap_i = (sprite.x_origin_bitmap).to_i 
sprite.x_origin_bitmap_i %= @width if $game_system.loop_x 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
for sprite in @sprites_loop_x 
sprite.x_origin_bitmap += difference.to_f / 4 
sprite.x_origin_bitmap_i = (sprite.x_origin_bitmap).to_i 
sprite.x_origin_bitmap_i %= @width 
sprite.x_origin_bitmap_i -= @width 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
end 
if @disp_x > $game_map.display_x 
difference = @disp_x - $game_map.display_x 
@disp_x -= difference 
for sprite in @sprites 
sprite.x_origin_bitmap -= difference.to_f / 4 
sprite.x_origin_bitmap_i = (sprite.x_origin_bitmap).to_i 
sprite.x_origin_bitmap_i %= @width if $game_system.loop_x 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
for sprite in @sprites_loop_x 
sprite.x_origin_bitmap -= difference.to_f / 4 
sprite.x_origin_bitmap_i = (sprite.x_origin_bitmap).to_i 
sprite.x_origin_bitmap_i %= @width 
sprite.x_origin_bitmap_i -= @width 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
end 
# update vertical sprites 
for sprite in @sprites_V 
sprite.update 
end 
end 
#-------------------------------------------------------------------------- 
# * Update animation for animated tiles 
#-------------------------------------------------------------------------- 
def update_animated 
@index_animated += 1 
@index_animated %= 4 
map = @maps_list[@index_animated] 
# update screenlines sprites 
for sprite in @sprites + @sprites_loop_x 
sprite.bitmap = map 
sprite.src_rect.set(sprite.x_origin_bitmap_i, sprite.y_origin_bitmap_i, 
sprite.length, 1) 
end 
# update vertical sprites 
for sprite in @sprites_V_animated 
sprite.update_animated(@index_animated) 
end 
end 
#-------------------------------------------------------------------------- 
# * Create bitmaps representing the map 
#-------------------------------------------------------------------------- 
def draw_map 
data = $game_map.data 
# Table where animated tiles are flagged 
data_animated = Table.new($game_map.width, $game_map.height) 
# bigger maps to handle horizontal looping 
offset = ($game_system.loop_x ? 640 : 0) 
@map = Bitmap.new(@width + offset, @height) 
@maps_list.push(@map) 
rect = Rect.new(0, 0, 32, 32) 
# create autotiles graphics 
RPG::Cache.clear 
@autotiles = [] 
for i in 0..6 
autotile_name = $game_map.autotile_names[i] 
fichier = RPG::Cache.autotile(autotile_name) 
for l in 0..3 
data_autotile = Data_Autotiles.new(fichier,l) 
data_autotile.number = 4*i + l 
RPG::Cache.save_autotile(data_autotile, data_autotile.number) 
@autotiles.push(data_autotile) 
end 
end 
# scan map's data to draw it 
for i in 0...$game_map.height 
for j in 0...$game_map.width 
data_animated[j, i] = 0 
# tile's ID for the first layer 
value1 = data[j, i, 0].to_i 
# prevent from drawing a vertical tile 
value1 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value1]) ? 
0 : value1) 
# value1 != 0 
if value1 != 0 
# tile's ID for the second layer 
value2 = data[j, i, 1].to_i 
# prevent from drawing a vertical tile 
value2 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value2]) ? 
0 : value2) 
# tile's ID for the third layer 
value3 = data[j, i, 2].to_i 
# prevent from drawing a vertical tile 
value3 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value3]) ? 
0 : value3) 
# value1 != 0, value2 = 0 
if value2 == 0 
# value1 != 0, value2 = 0, value3 = 0 
if value3 == 0 
# value1 associated with a normal autotile 
if value1 > 383 
bitmap = RPG::Cache.tile($game_map.tileset_name, value1, 0) 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
# value1 associated with an autotile 
else 
num = 4*((value1 / 48) - 1) 
bitmap = RPG::Cache.autotile_base(num, value1) 
if @autotiles[num].animated 
data_animated[j, i] = 1 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
end 
# value1 != 0, value2 = 0, value3 != 0 
else 
bitmap = RPG::Cache_Tile.load(value1, value3) 
# value1 associated with an autotile 
if value1 < 384 
num = 4*((value1 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
# value3 associated with an autotile 
if value3 < 384 
num = 4*((value3 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
end 
# value1 != 0, value2 != 0 
else 
# value1 != 0, value2 != 0, value3 = 0 
if value3 == 0 
bitmap = RPG::Cache_Tile.load(value1, value2) 
# value1 associated with an autotile 
if value1 < 384 
num = 4*((value1 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
# value2 associated with an autotile 
if value2 < 384 
num = 4*((value2 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
# value1 != 0, value2 != 0, value3 != 0 
else 
bitmap = RPG::Cache_Tile.load2(value1, value2, value3) 
# value1 associated with an autotile 
if value1 < 384 
num = 4*((value1 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
# value2 associated with an autotile 
if value2 < 384 
num = 4*((value2 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
# value3 associated with an autotile 
if value3 < 384 
num = 4*((value3 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
end 
end 
# value1 = 0 
else 
value2 = data[j, i, 1].to_i 
value2 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value2]) ? 
0 : value2) 
value3 = data[j, i, 2].to_i 
value3 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value3]) ? 
0 : value3) 
# value1 = 0, value2 = 0 
if value2 == 0 
# value1 = 0, value2 = 0, value3 != 0 
if value3 != 0 
# value3 associated with a normal tile 
if value3 > 383 
bitmap = RPG::Cache.tile($game_map.tileset_name, value3, 0) 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
# value3 associated with an autotile 
else 
num = 4*((value3 / 48) - 1) 
bitmap = RPG::Cache.autotile_base(num, value3) 
if @autotiles[num].animated 
data_animated[j, i] = 1 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
end 
end 
# value1 = 0, value2 != 0 
else 
# value1 = 0, value2 != 0, value3 = 0 
if value3 == 0 
# value2 associated with a normal tile 
if value2 > 383 
bitmap = RPG::Cache.tile($game_map.tileset_name, value2, 0) 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
# value2 associated with an autotile 
else 
num = 4*((value2 / 48) - 1) 
bitmap = RPG::Cache.autotile_base(num, value2) 
if @autotiles[num].animated 
data_animated[j, i] = 1 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
end 
# value1 = 0, value2 != 0, value3 != 0 
else 
bitmap = RPG::Cache_Tile.load(value2, value3) 
# value2 associated with an autotile 
if value2 < 384 
num = 4*((value2 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
# value3 associated with an autotile 
if value3 < 384 
num = 4*((value3 / 48) - 1) 
data_animated[j, i] = 1 if @autotiles[num].animated 
end 
@map.blt(32*j, 32*i, bitmap, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map.blt(32*(j+$game_map.width), 32*i, bitmap, rect) 
end 
end 
end 
end 
end 
end 
# save the map's drawing in the Cache 
RPG::Cache_Carte.save(@id, @map) 
@map_ground = @map.clone 
# save a copy of the map to handle flat events 
RPG::Cache_Carte.save(@id, @map_ground, 4) 
return if !$game_system.animated 
# create 3 other maps in case of animated tiles 
@map_2 = @map.clone 
@map_3 = @map.clone 
@map_4 = @map.clone 
@maps_list.push(@map_2) 
@maps_list.push(@map_3) 
@maps_list.push(@map_4) 
for i in 0...$game_map.height 
for j in 0...$game_map.width 
next if data_animated[j, i].to_i == 0 
# modify the tile if it is flagged as animated 
value1 = data[j, i, 0].to_i 
value2 = data[j, i, 1].to_i 
value3 = data[j, i, 2].to_i 
# prevent from drawing a vertical tile 
value1 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value3]) ? 
0 : value3) 
value2 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value3]) ? 
0 : value3) 
value3 = ($terrain_tags_vertical_tiles.include?($game_map.terrain_tags[value3]) ? 
0 : value3) 
if value1 != 0 
if value2 == 0 
if value3 == 0 
num = 4*((value1 / 48) - 1) 
bitmap_2 = RPG::Cache.autotile_base(num+1, value1) 
bitmap_3 = RPG::Cache.autotile_base(num+2, value1) 
bitmap_4 = RPG::Cache.autotile_base(num+3, value1) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
else 
bitmap_2 = RPG::Cache_Tile.load(value1, value3, 1) 
bitmap_3 = RPG::Cache_Tile.load(value1, value3, 2) 
bitmap_4 = RPG::Cache_Tile.load(value1, value3, 3) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
end 
else 
if value3 == 0 
bitmap_2 = RPG::Cache_Tile.load(value1, value2, 1) 
bitmap_3 = RPG::Cache_Tile.load(value1, value2, 2) 
bitmap_4 = RPG::Cache_Tile.load(value1, value2, 3) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
else 
bitmap_2 = RPG::Cache_Tile.load2(value1, value2, value3, 1) 
bitmap_3 = RPG::Cache_Tile.load2(value1, value2, value3, 2) 
bitmap_4 = RPG::Cache_Tile.load2(value1, value2, value3, 3) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
end 
end 
else 
if value2 != 0 
if value3 == 0 
num = 4*((value2 / 48) - 1) 
bitmap_2 = RPG::Cache.autotile_base(num+1, value2) 
bitmap_3 = RPG::Cache.autotile_base(num+2, value2) 
bitmap_4 = RPG::Cache.autotile_base(num+3, value2) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
else 
bitmap_2 = RPG::Cache_Tile.load(value2, value3, 1) 
bitmap_3 = RPG::Cache_Tile.load(value2, value3, 2) 
bitmap_4 = RPG::Cache_Tile.load(value2, value3, 3) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
end 
else 
if value3 != 0 
num = 4*((value3 / 48) - 1) 
bitmap_2 = RPG::Cache.autotile_base(num+1, value3) 
bitmap_3 = RPG::Cache.autotile_base(num+2, value3) 
bitmap_4 = RPG::Cache.autotile_base(num+3, value3) 
@map_2.blt(32*j, 32*i, bitmap_2, rect) 
@map_3.blt(32*j, 32*i, bitmap_3, rect) 
@map_4.blt(32*j, 32*i, bitmap_4, rect) 
if $game_system.loop_x and j.between?(0, 19) 
@map_2.blt(32*(j+$game_map.width), 32*i, bitmap_2, rect) 
@map_3.blt(32*(j+$game_map.width), 32*i, bitmap_3, rect) 
@map_4.blt(32*(j+$game_map.width), 32*i, bitmap_4, rect) 
end 
end 
end 
end 
end 
end 
# save the three additional maps in the Cache 
RPG::Cache_Carte.save(@id, @map_2, 1) 
RPG::Cache_Carte.save(@id, @map_3, 2) 
RPG::Cache_Carte.save(@id, @map_4, 3) 
end 
end 

#============================================================================ 
# �  Game_Map 
#---------------------------------------------------------------------------- 
# Methods modifications to handle map looping 
#============================================================================ 

class Game_Map 
#-------------------------------------------------------------------------- 
# * Scroll Down 
# distance : scroll distance 
#-------------------------------------------------------------------------- 
alias scroll_down_mode7_game_map scroll_down 
def scroll_down(distance) 
if !$game_system.mode7 
scroll_down_mode7_game_map(distance) 
return 
end 
if $game_system.loop_y or $game_system.always_scroll 
@display_y = @display_y + distance # always scroll 
else 
@display_y = [@display_y + distance, (self.height - 15) * 128].min 
end 
end 
#-------------------------------------------------------------------------- 
# * Scroll Left 
# distance : scroll distance 
#-------------------------------------------------------------------------- 
alias scroll_left_mode7_game_map scroll_left 
def scroll_left(distance) 
if !$game_system.mode7 
scroll_left_mode7_game_map(distance) 
return 
end 
if $game_system.loop_x or $game_system.always_scroll 
@display_x = @display_x - distance # always scroll 
else 
@display_x = [@display_x - distance, 0].max 
end 
end 
#-------------------------------------------------------------------------- 
# * Scroll Right 
# distance : scroll distance 
#-------------------------------------------------------------------------- 
alias scroll_right_mode7_game_map scroll_right 
def scroll_right(distance) 
if !$game_system.mode7 
scroll_right_mode7_game_map(distance) 
return 
end 
if $game_system.loop_x or $game_system.always_scroll 
@display_x = @display_x + distance # always scroll 
else 
@display_x = [@display_x + distance, (self.width - 20) * 128].min 
end 
end 
#-------------------------------------------------------------------------- 
# * Scroll Up 
# distance : scroll distance 
#-------------------------------------------------------------------------- 
alias scroll_up_mode7_game_map scroll_up 
def scroll_up(distance) 
if !$game_system.mode7 
scroll_up_mode7_game_map(distance) 
return 
end 
if $game_system.loop_y or $game_system.always_scroll 
@display_y = @display_y - distance # always scroll 
else 
@display_y = [@display_y - distance, 0].max 
end 
end 
#-------------------------------------------------------------------------- 
# * Determine Valid Coordinates 
# x : x-coordinate 
# y : y-coordinate 
# Allow the hero to go out of the map when map looping 
#-------------------------------------------------------------------------- 
alias valid_mode7_game_map? valid? 
def valid?(x, y) 
if !$game_system.mode7 
return (valid_mode7_game_map?(x, y)) 
end 
if $game_system.loop_x 
if $game_system.loop_y 
return true 
else 
return (y >= 0 and y < height) 
end 
elsif $game_system.loop_y 
return (x >= 0 and x < width) 
end 
return (x >= 0 and x < width and y >= 0 and y < height) 
end 
#-------------------------------------------------------------------------- 
# * Determine if Passable 
# x : x-coordinate 
# y : y-coordinate 
# d : direction (0,2,4,6,8,10) 
# * 0,10 = determine if all directions are impassable 
# self_event : Self (If event is determined passable) 
#-------------------------------------------------------------------------- 
alias passable_mode7_game_map? passable? 
def passable?(x, y, d, self_event = nil) 
if !$game_system.mode7 
passable_mode7_game_map?(x, y, d, self_event) 
return(passable_mode7_game_map?(x, y, d, self_event)) 
end 
unless valid?(x, y) 
return false 
end 
bit = (1 << (d / 2 - 1)) & 0x0f 
for event in events.values 
if event.tile_id >= 0 and event != self_event and 
event.x == x and event.y == y and not event.through 
if @passages[event.tile_id] & bit != 0 
return false 
elsif @passages[event.tile_id] & 0x0f == 0x0f 
return false 
elsif @priorities[event.tile_id] == 0 
return true 
end 
end 
end 
for i in [2, 1, 0] 
tile_id = data[x % width, y % height, i] # handle map looping 
if tile_id == nil 
return false 
elsif @passages[tile_id] & bit != 0 
return false 
elsif @passages[tile_id] & 0x0f == 0x0f 
return false 
elsif @priorities[tile_id] == 0 
return true 
end 
end 
return true 
end 
end 

#============================================================================ 
# �  Game_Character 
#---------------------------------------------------------------------------- 
# "update" method modifications to handle map looping 
#============================================================================ 

class Game_Character 
attr_accessor :x 
attr_accessor :y 
attr_accessor :real_x 
attr_accessor :real_y 
attr_reader :flat 
attr_reader :height 
#-------------------------------------------------------------------------- 
# * Object Initialization 
#-------------------------------------------------------------------------- 
alias initialize_mode7_game_character initialize 
def initialize 
initialize_mode7_game_character 
@flat = false 
@height = 0.0 
end 
#-------------------------------------------------------------------------- 
# * Update 
#-------------------------------------------------------------------------- 
alias update_mode7_game_character update 
def update 
if !$game_system.mode7 
update_mode7_game_character 
return 
end 
# if x-coordinate is out of the map 
if !(x.between?(0, $game_map.width - 1)) 
difference = 128 * x - real_x 
if self.is_a?(Game_Player) 
# increase or decrease map's number 
self.map_number_x += difference / (difference.abs) 
end 
# x-coordinate is equal to its equivalent in the map 
self.x %= $game_map.width 
self.real_x = 128 * x - difference 
end 
# if y-coordinate is out of the map 
if !(y.between?(0, $game_map.height - 1)) 
difference = 128 * y - real_y 
if self.is_a?(Game_Player) 
# increase or decrease map's number 
self.map_number_y += difference / (difference.abs) 
end 
# y-coordinate is equal to its equivalent in the map 
self.y %= $game_map.height 
self.real_y = 128 * y - difference 
end 
update_mode7_game_character 
end 
end 

#============================================================================== 
# �  Game_Event 
#---------------------------------------------------------------------------- 
# Add methods to handle flat events and altitude for vertical event 
#============================================================================ 

class Game_Event < Game_Character 
#-------------------------------------------------------------------------- 
# * scan the event's commands list 
# page : the scanned page (RPG::Event::Page) 
#-------------------------------------------------------------------------- 
def check_commands(page) 
@height = 0.0 
command_list = page.list 
for k in 0..command_list.length - 2 
command = command_list[k] 
if (command.parameters[0].to_s).include?("Height") 
@height = (command.parameters[0][7,command.parameters[0].length-1]).to_f 
end 
@flat = (command.parameters[0].to_s).include?("Flat") 
end 
end 
#-------------------------------------------------------------------------- 
# * scan the event's commands list of the current page when refreshed 
#-------------------------------------------------------------------------- 
alias refresh_mode7_game_character refresh 
def refresh 
refresh_mode7_game_character 
check_commands(@page) if @page != nil 
end 
end 

#============================================================================ 
# �  Game_Player 
#---------------------------------------------------------------------------- 
# Add attributes to have a well-working panorama's scrolling 
#============================================================================ 

class Game_Player < Game_Character 
attr_accessor :map_number_x # map's number with X-looping 
attr_accessor :map_number_y # map's number with Y-looping 
#-------------------------------------------------------------------------- 
# * Object Initialization 
#-------------------------------------------------------------------------- 
alias initialize_mode7_game_player initialize 
def initialize 
initialize_mode7_game_player 
self.map_number_x = 0 
self.map_number_y = 0 
end 
#-------------------------------------------------------------------------- 
# * Handle the option : center around the hero 
#-------------------------------------------------------------------------- 
alias center_mode7_game_player center 
def center(x, y) 
if !$game_system.mode7 
center_mode7_game_player(x, y) 
return 
end 
$game_map.display_x = x * 128 - CENTER_X 
$game_map.display_y = y * 128 - CENTER_Y 
end 
end 

#============================================================================ 
# �  Sprite 
#---------------------------------------------------------------------------- 
# Add attributes to work efficiently with scanlines sprites 
#============================================================================ 

class Sprite 
attr_accessor :y_origin_bitmap # bitmap's y-coordinate for the "src_rect.set" 
#method (float) 
attr_accessor :x_origin_bitmap # bitmap's x-coordinate for the "src_rect.set" 
#method (float) 
attr_accessor :y_origin_bitmap_i # bitmap's y-coordinate for the 
#"src_rect.set" method (integer) 
attr_accessor :x_origin_bitmap_i # bitmap's x-coordinate for the 
#"src_rect.set" method (integer) 
attr_accessor :length # sprite's width 
end 

#============================================================================ 
# �  Sprite_Character 
#---------------------------------------------------------------------------- 
# Calculate x-coordinate and y-coordinate for a mode7 map 
#============================================================================ 

class Sprite_Character < RPG::Sprite 
attr_reader :flat_indicator # true if the event is flat-drawn 
#-------------------------------------------------------------------------- 
# * Object Initialization 
#-------------------------------------------------------------------------- 
alias initialize_mode7_sprite_character initialize 
def initialize(viewport, character = nil) 
@flat_indicator = false 
initialize_mode7_sprite_character(viewport, character) 
end 
#-------------------------------------------------------------------------- 
# * Update 
#-------------------------------------------------------------------------- 
alias update_mode7_sprite_character update 
def update 
if !$game_system.mode7 
update_mode7_sprite_character 
return 
end 
if @flat_indicator 
if (!@character.flat or @character.moving? or 
@tile_id != @character.tile_id or 
@character_name != @character.character_name or 
@character_hue != @character.character_hue) 
@flat_indicator = @character.flat 
# redraw the original ground 
maps_list = $scene.spriteset.tilemap.maps_list 
map_ground = $scene.spriteset.tilemap.map_ground 
rect = Rect.new(@flat_x_map, @flat_y_map, @flat_width, @flat_height) 
for map in maps_list 
map.blt(@flat_x_map, @flat_y_map, map_ground, rect) 
if $game_system.loop_x and @flat_x_map.between?(0, 19 * 32) 
map.blt(@flat_x_map + 32 * $game_map.width, @flat_y_map, map_ground, 
rect) 
end 
end 
else 
return 
end 
end 
super 
if @tile_id != @character.tile_id or 
@character_name != @character.character_name or 
@character_hue != @character.character_hue 
@tile_id = @character.tile_id 
@character_name = @character.character_name 
@character_hue = @character.character_hue 
if @tile_id >= 384 
self.bitmap = RPG::Cache.tile($game_map.tileset_name, 
@tile_id, @character.character_hue) 
self.src_rect.set(0, 0, 32, 32) 
self.ox = 16 
self.oy = 32 
else 
self.bitmap = RPG::Cache.character(@character.character_name, 
@character.character_hue) 
@cw = bitmap.width / 4 
@ch = bitmap.height / 4 
self.ox = @cw / 2 
self.oy = @ch 
# pivot correction (intersection between the map and this sprite) 
self.oy -= 4 
end 
end 
self.visible = (not @character.transparent) 
if @tile_id == 0 
sx = @character.pattern * @cw 
sy = (@character.direction - 2) / 2 * @ch 
self.src_rect.set(sx, sy, @cw, @ch) 
end 
if @character.flat # event must be flat drawn 
return if $scene.spriteset == nil 
if @tile_id == 0 
@flat_x_map = @character.real_x / 4 - (@cw - 32) / 2 
@flat_y_map = @character.real_y / 4 - @ch + 32 
@flat_x0 = sx 
@flat_y0 = sy 
@flat_width = @cw 
@flat_height = @ch 
else 
@flat_x_map = @character.real_x / 4 
@flat_y_map = @character.real_y / 4 
@flat_x0 = 0 
@flat_y0 = 0 
@flat_width = 32 
@flat_height = 32 
end 
# modify the maps graphics 
maps_list = $scene.spriteset.tilemap.maps_list 
rect = Rect.new(@flat_x0, @flat_y0, @flat_width, @flat_height) 
for map in maps_list 
map.blt(@flat_x_map, @flat_y_map, bitmap, rect, @character.opacity) 
if $game_system.loop_x and @flat_x_map.between?(0, 19 * 32) 
map.blt(@flat_x_map + 32 * $game_map.width, @flat_y_map, bitmap, rect, 
@character.opacity) 
end 
end 
@flat_indicator = true 
self.opacity = 0 
return 
end 
x_intermediate = @character.screen_x 
y_intermediate = @character.screen_y 
y_intermediate -= $game_temp.pivot + 4 if $game_system.mode7 
# if vertical looping 
if $game_system.loop_y 
h = 32 * $game_map.height 
y_intermediate = (y_intermediate + h / 2) % h - h / 2 
end 
# coordinates in a mode7 map 
self.y = (($game_temp.distance_h * y_intermediate * 
$game_temp.cos_angle).to_f / ($game_temp.distance_h - y_intermediate * 
$game_temp.sin_angle) + $game_temp.pivot) 
self.zoom_x = $game_temp.slope_value * y + $game_temp.corrective_value 
self.zoom_y = zoom_x 
self.x = 320 + zoom_x * (x_intermediate - 320) 
# if horizontal looping 
if $game_system.loop_x 
offset = ($game_map.width >= 24 ? 64 * zoom_x : 0) 
l = 32 * $game_map.width * zoom_x 
self.x = (x + offset) % l - offset 
end 
if @character.is_a?(Game_Player) 
# Overworld Sprite Resize 
if $game_system.ov 
self.zoom_x *= $game_system.ov_zoom 
self.zoom_y *= $game_system.ov_zoom 
end 
end 
self.z = @character.screen_z(@ch) 
# hide the sprite if it is beyond the horizon's line 
self.opacity = (y < $game_temp.height_limit ? 0 : @character.opacity) 
self.y -= 32 * @character.height * zoom_y # height correction 
self.blend_type = @character.blend_type 
self.bush_depth = @character.bush_depth 
if @character.animation_id != 0 
animation = $data_animations[@character.animation_id] 
animation(animation, true) 
@character.animation_id = 0 
end 
end 
end 

#============================================================================ 
# �  Sprite_V (Vertical Sprites) 
#---------------------------------------------------------------------------- 
# Sprites corresponding to the vertical elements formed by tiles 
#============================================================================ 

class Sprite_V < Sprite 
attr_accessor :x_map # sprite's x_coordinates (in squares) (Float) 
attr_accessor :y_map # sprite's y_coordinates (in squares) (Float) 
attr_accessor :square_y # sprite's y_coordinates (in squares) (Integer) 
attr_accessor :priority # sprite's priority 
attr_accessor :animated # True if animated 
attr_accessor :list_bitmap # list of sprite's bitmaps (Bitmap) 
#-------------------------------------------------------------------------- 
# * Update 
#-------------------------------------------------------------------------- 
def update 
square_y_corrected = square_y 
y_intermediate = 32 * y_map - $game_temp.pivot - $game_map.display_y / 4 
y_intermediate_reference = y_intermediate 
# if vertical looping 
if $game_system.loop_y 
y_intermediate = (y_intermediate + $game_temp.height / 2) % 
$game_temp.height - $game_temp.height / 2 
if y_intermediate_reference < y_intermediate 
square_y_corrected = square_y + $game_map.height 
elsif y_intermediate_reference > y_intermediate 
square_y_corrected = square_y - $game_map.height 
end 
end 
self.y = ($game_temp.distance_h * y_intermediate * 
$game_temp.cos_angle).to_f / ($game_temp.distance_h - y_intermediate * 
$game_temp.sin_angle) + $game_temp.pivot 
if y < $game_temp.height_limit 
# hide the sprite if it is beyond the horizon's line 
self.opacity = 0 
return 
end 
self.opacity = 255 
if $scene.spriteset != nil 
opacity_values = $scene.spriteset.tilemap.opacity_values 
tone_values = $scene.spriteset.tilemap.tone_values 
if opacity_values.has_key?(y) 
self.opacity = opacity_values[y] 
self.tone = tone_values[y] 
end 
end 
self.zoom_x = $game_temp.slope_value * y + $game_temp.corrective_value 
self.zoom_y = zoom_x 
x_intermediate = 32 * x_map - $game_map.display_x / 4 
self.x = 320 + (zoom_x * (x_intermediate - 320)) 
# if horizontal looping 
if $game_system.loop_x 
offset = ($game_map.width >= 24 ? 64 * zoom_x : 0) 
l = 32 * $game_map.width * self.zoom_x 
self.x = (self.x + offset) % l - offset 
end 
self.z = (128 * square_y_corrected - $game_map.display_y + 3) / 4 + 
32 + 32 * priority 
return 
end 
#-------------------------------------------------------------------------- 
# * Update bitmap for animation 
# index : 0..3 : animation's index 
#-------------------------------------------------------------------------- 
def update_animated(index) 
self.bitmap = @list_bitmap[index] 
end 
end 

#============================================================================ 
# �  Spriteset_Map 
#---------------------------------------------------------------------------- 
# Modifications to call a mode7 map 
#============================================================================ 

class Spriteset_Map 
attr_accessor :tilemap # just to be able to access the tilemap 
#-------------------------------------------------------------------------- 
# * Defines map's options from its name 
# Refer to Game_System class 
#-------------------------------------------------------------------------- 
def init_options 
map_data = $data_maps[$game_map.map_id] 
for keyword in $mode7_maps_settings.keys 
if map_data.name2.include?(keyword) 
command_list = $mode7_maps_settings[keyword] 
$game_system.mode7 = true 
$game_system.loop_x = command_list.include?("X") 
$game_system.loop_y = command_list.include?("Y") 
$game_system.always_scroll = command_list.include?("C") 
$game_system.animated = command_list.include?("A") 
$game_system.white_horizon = command_list.include?("H") 
$game_system.fixed_panorama = command_list.include?("P") 
$game_system.ov = command_list.include?("OV") 
for command in command_list 
if command.include?("#") 
$game_system.angle = (command.slice(1, 2)).to_i 
$game_system.angle = [[$game_system.angle, 0].max, 89].min 
break 
end 
end 
return 
end 
end 
$game_system.mode7 = map_data.name2.include?("[M7]") 
$game_system.loop_x = map_data.name2.include?("[X]") 
$game_system.loop_y = map_data.name2.include?("[Y]") 
$game_system.always_scroll = map_data.name2.include?("[C]") 
$game_system.animated = map_data.name2.include?("[A]") 
$game_system.white_horizon = map_data.name2.include?("[H]") 
$game_system.fixed_panorama = map_data.name2.include?("[P]") 
$game_system.ov = map_data.name2.include?("[OV]") 
if $game_system.mode7 
map_data.name2 =~ /\[#[ ]*([00-99]+)\]/i 
$game_system.angle = $1.to_i 
$game_system.angle = [[$game_system.angle, 0].max, 89].min 
end 
end 
#-------------------------------------------------------------------------- 
# * Initialize Object 
# Rewritten to call a map with mode7 
#-------------------------------------------------------------------------- 
alias initialize_mode7_spriteset_map initialize 
def initialize 
init_options 
if !$game_system.mode7 
initialize_mode7_spriteset_map 
return 
end 
@viewport1 = Viewport.new(0, 0, 640, 480) 
@viewport2 = Viewport.new(0, 0, 640, 480) 
@viewport3 = Viewport.new(0, 0, 640, 480) 
@viewport2.z = 200 
@viewport3.z = 5000 
# mode7 map 
@tilemap = Tilemap_mode7.new(@viewport1) 
@panorama = Plane.new(@viewport1) 
# sprites drawn at the horizon's level have a negative z, and with a z value 
# of -100000 the panorama is still below 
@panorama.z = ($game_system.mode7 ? -100000 : -1000) 
@fog = Plane.new(@viewport1) 
@fog.z = 3000 
@character_sprites = [] 
for i in $game_map.events.keys.sort 
sprite = Sprite_Character.new(@viewport1, $game_map.events[i]) 
@character_sprites.push(sprite) 
end 
@character_sprites.push(Sprite_Character.new(@viewport1, $game_player)) 
@weather = RPG::Weather.new(@viewport1) 
@picture_sprites = [] 
for i in 1..50 
@picture_sprites.push(Sprite_Picture.new(@viewport2, 
$game_screen.pictures[i])) 
end 
@timer_sprite = Sprite_Timer.new 
update 
end 
#-------------------------------------------------------------------------- 
# * Dispose 
#-------------------------------------------------------------------------- 
alias dispose_mode7_spriteset_map dispose 
def dispose 
if !$game_system.mode7 
dispose_mode7_spriteset_map 
return 
end 
@tilemap.dispose 
@panorama.dispose 
@fog.dispose 
for sprite in @character_sprites 
sprite.dispose 
end 
@weather.dispose 
for sprite in @picture_sprites 
sprite.dispose 
end 
@timer_sprite.dispose 
@viewport1.dispose 
@viewport2.dispose 
@viewport3.dispose 
end 
#-------------------------------------------------------------------------- 
# * Update 
#-------------------------------------------------------------------------- 
alias update_mode7_spriteset_map update 
def update 
if !$game_system.mode7 
update_mode7_spriteset_map 
return 
end 
if @panorama_name != $game_map.panorama_name or 
@panorama_hue != $game_map.panorama_hue 
@panorama_name = $game_map.panorama_name 
@panorama_hue = $game_map.panorama_hue 
if @panorama.bitmap != nil 
@panorama.bitmap.dispose 
@panorama.bitmap = nil 
end 
if @panorama_name != "" 
@panorama.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue) 
end 
Graphics.frame_reset 
end 
if @fog_name != $game_map.fog_name or @fog_hue != $game_map.fog_hue 
@fog_name = $game_map.fog_name 
@fog_hue = $game_map.fog_hue 
if @fog.bitmap != nil 
@fog.bitmap.dispose 
@fog.bitmap = nil 
end 
if @fog_name != "" 
@fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue) 
end 
Graphics.frame_reset 
end 
# update animated tiles each 20 frames 
if Graphics.frame_count % 20 == 0 and $game_system.animated 
@tilemap.update_animated 
end 
@tilemap.update 
# if the panorama is fixed 
if $game_system.fixed_panorama 
@panorama.ox = 0 
@panorama.oy = 0 
# if it is a mode7 map 
else 
# to have a fluent panorama scrolling 
@panorama.ox = (128 * $game_map.width * $game_player.map_number_x + 
$game_player.real_x) / 8 
@panorama.oy = - (128 * $game_map.height * $game_player.map_number_y + 
$game_player.real_y) / 32 
end 
@fog.zoom_x = $game_map.fog_zoom / 100.0 
@fog.zoom_y = $game_map.fog_zoom / 100.0 
@fog.opacity = $game_map.fog_opacity 
@fog.blend_type = $game_map.fog_blend_type 
@fog.ox = $game_map.display_x / 4 + $game_map.fog_ox 
@fog.oy = $game_map.display_y / 4 + $game_map.fog_oy 
@fog.tone = $game_map.fog_tone 
for sprite in @character_sprites 
sprite.update 
end 
@weather.type = $game_screen.weather_type 
@weather.max = $game_screen.weather_max 
@weather.ox = $game_map.display_x / 4 
@weather.oy = $game_map.display_y / 4 
@weather.update 
for sprite in @picture_sprites 
sprite.update 
end 
@timer_sprite.update 
@viewport1.tone = $game_screen.tone 
@viewport1.ox = $game_screen.shake 
@viewport3.color = $game_screen.flash_color 
@viewport1.update 
@viewport3.update 
end 
end 

#============================================================================ 
# �  Scene_Map 
#============================================================================ 
class Scene_Map 
attr_accessor :spriteset # just need to access the spriteset 
end 

#============================================================================ 
# �  Data_Autotiles 
#---------------------------------------------------------------------------- 
# Creates the set of tiles from an autotile's file 
#============================================================================ 

class Data_Autotiles < Bitmap 
# data list to form tiles from an atotiles file 
Data_creation = [[27,28,33,34],[5,28,33,34],[27,6,33,34],[5,6,33,34], 
[27,28,33,12],[5,28,33,12],[27,6,33,12],[5,6,33,12],[27,28,11,34], 
[5,28,11,34],[27,6,11,34],[5,6,11,34],[27,28,11,12],[5,28,11,12], 
[27,6,11,12],[5,6,11,12],[25,26,31,32],[25,6,31,32],[25,26,31,12], 
[25,6,31,12],[15,16,21,22],[15,16,21,12],[15,16,11,22],[15,16,11,12], 
[29,30,35,36],[29,30,11,36],[5,30,35,36],[5,30,11,36],[39,40,45,46], 
[5,40,45,46],[39,6,45,46],[5,6,45,46],[25,30,31,36],[15,16,45,46], 
[13,14,19,20],[13,14,19,12],[17,18,23,24],[17,18,11,24],[41,42,47,48], 
[5,42,47,48],[37,38,43,44],[37,6,43,44],[13,18,19,24],[13,14,43,44], 
[37,42,43,48],[17,18,47,48],[13,18,43,48],[13,18,43,48]] 
attr_accessor :number # autotile's number to identify it 
attr_accessor :animated # TRUE if the autotile is animated 
#-------------------------------------------------------------------------- 
# * Initialize Object 
# file : autotiles file's bitmap (Bitmap) 
# l : 0..3 : pattern's number for animated autotiles 
#-------------------------------------------------------------------------- 
def initialize(file, l) 
super(8*32, 6*32) 
create(file, l) 
end 
#-------------------------------------------------------------------------- 
# * Create the tiles set 
# file : autotiles file's bitmap (Bitmap) 
# l : 0..3 : pattern's number for animated autotiles 
#-------------