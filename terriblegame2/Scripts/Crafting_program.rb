#================================
# CRAFTING PROGRAM
#----------------------------------------------------------------
#-written by Deke
#-yes_no window code created by Phsylomortis
#----------------------------------------------------------------
#================================

#updates to Game_Party class

class Game_Party
 
 attr_accessor       :recipes
 
 alias crafting_party_initialize initialize
 
 def initialize
   crafting_party_initialize
   @recipes=[]
 end
 
 #----------------------------------------------------------------------
 def know?(recipe, version = 1)
   unless recipe.is_a?(Game_Recipe)
     recipe = get_recipe_from_master_list(recipe, version)
   end
   return $game_party.recipes.include?(recipe)
 end
 
#----------------------------------------------------------------------
 def learn_recipe(recipe , version = 1)
   unless recipe.is_a?(Game_Recipe)
     recipe = get_recipe_from_master_list(recipe, version)
   end
   if recipe.is_a?(Game_Recipe)
     unless know?(recipe)
       @recipes.push(recipe)
     end
   end
 end
 
#----------------------------------------------------------------------
 def forget_recipe(recipe , version = 1)
   if !recipe.is_a?(Game_Recipe)
     recipe = get_recipe_from_master_list(recipe, version)
   end
   if recipe.is_a?(Game_Recipe)
     for i in 0...@recipes.size
       if recipe == @recipes[i]
         index = i
         break
       end
     end
     if index != nil
       @recipes.delete(@recipes[index])
     end
   end
 end
 
#----------------------------------------------------------------------
 def get_recipe_from_master_list(item, version)
   index = nil
   for i in 0...$game_temp.recipe_list.size
     if item[0] == $game_temp.recipe_list[i].result and item[1] ==$game_temp.recipe_list[i].result_type
       version -= 1
       if version == 0
         index = i
         break
       end
     end
   end
   if index.is_a?(Integer)
     return ($game_temp.recipe_list[index])
   else
     return false
   end
 end
 
end # of Game_Party updates

#================================
class Game_Recipe

 attr_reader :ingredients
 attr_reader :quantities
 attr_reader :result
 attr_reader :result_type
 attr_reader :ingredient_types
 
#----------------------------------------------------------------------
 def initialize( ingredients, ingredient_types, quantities, result, result_type)
   @ingredients = ingredients
   @ingredient_types = ingredient_types
   @quantities = quantities
   @result = result
   @result_type = result_type
 end
 
#----------------------------------------------------------------------
 def name
   case @result_type
     when 0
       name = $data_items[@result].name
     when 1
       name = $data_armors[@result].name
     when 2
       name = $data_weapons[@result].name
   end
   return name
 end

#----------------------------------------------------------------------
 def have
   have_all = true
   for i in 0...@ingredients.size
     case @ingredient_types[i]
       when 0
         if $game_party.item_number(@ingredients[i]) < @quantities[i]
           have_all=false
         end
       when 1
         if $game_party.armor_number(@ingredients[i]) < @quantities[i]
           have_all=false
         end
       when 2
         if $game_party.weapon_number(@ingredients[i]) < @quantities[i]
           have_all=false
         end
     end
   end
   return have_all
 end

#----------------------------------------------------------------------
 def decrement
   for i in 0...@ingredients.size
     case @ingredient_types[i]
     when 0
       $game_party.lose_item(@ingredients[i], @quantities[i])
     when 1
       $game_party.lose_armor(@ingredients[i], @quantities[i])
     when 2
       $game_party.lose_weapon(@ingredients[i], @quantities[i])
     end
   end
 end

#----------------------------------------------------------------------
 def make
   if have
     case @result_type
     when 0
       $game_party.gain_item(@result, 1)
     when 1
       $game_party.gain_armor(@result, 1)
     when 2
       $game_party.gain_weapon(@result, 1)
     end
     decrement
   end
 end
 
#----------------------------------------------------------------------
 def == (recipe)
   if recipe.is_a?(Game_Recipe)
     equal = true
     if recipe.ingredients != self.ingredients
       equal = false
     end
     if recipe.ingredient_types != self.ingredient_types
       equal = false
     end
     if recipe.quantities != self.quantities
       equal = false
     end
     if recipe.result != self.result
       equal=false
     end
     if recipe.result_type != self.result_type
       equal = false
     end
   else
     equal = false
   end
   return equal
 end
 
end # of Game_Recipe class

#===================================

class Window_Craft < Window_Selectable

 #--------------------------------------------------------------------------
 def initialize
   super(0, 64, 240, 416)
   @column_max = 1
   refresh
   self.index = 0
 end

 #--------------------------------------------------------------------------
 def recipe
   return @data[self.index]
 end

 #--------------------------------------------------------------------------
 def refresh
   if self.contents != nil
     self.contents.dispose
     self.contents = nil
   end
   @data = []
   for i in 0...$game_party.recipes.size
       @data.push($game_party.recipes[i])
   end
   @item_max = @data.size
   if @item_max > 0
     self.contents = Bitmap.new(width - 32, row_max * 32)
     self.contents.font.name = $fontface.is_a?(String) ? $fontface : $defaultfonttype
     self.contents.font.size = $fontsize.is_a?(Integer) ? $fontsize : $defaultfontsize
     for i in 0...@item_max
       draw_item(i)
     end
   end
 end

 #--------------------------------------------------------------------------
 def draw_item(index)
   recipe = @data[index]
   self.contents.font.color = recipe.have ? normal_color : disabled_color
   x = 16
   y = index * 32
   self.contents.draw_text(x , y, self.width-32, 32, recipe.name, 0)
 end

 #--------------------------------------------------------------------------
 def update_help
   current_recipe = recipe
   if current_recipe.is_a?(Game_Recipe)
   case current_recipe.result_type
     when 0
       description = $data_items[current_recipe.result].description
     when 1
       description = $data_armors[current_recipe.result].description
     when 2
       description = $data_weapons[current_recipe.result].description
     end
   else
     description = ""
   end
   @help_window.set_text(description)
   @help_window.update
 end
 
end # of Window_Craft

#=======================================
class Window_CraftResult < Window_Base

 #--------------------------------------------------------------------------
 def initialize
   super(240, 64, 400, 184)
   self.contents = Bitmap.new(width - 32, height - 32)
   self.contents.font.name = $fontface.is_a?(String) ? $fontface : $defaultfonttype
   self.contents.font.size = 20
   @result = nil
   @type = nil
 end

 #--------------------------------------------------------------------------
 def refresh
   self.contents.clear
   case @type
     when 0
       item = $data_items[@result]
       if item.recover_hp_rate > item.recover_hp
         hp_string = "HP Recovery% :"
         hp_stat = item.recover_hp_rate
       else
         hp_string = "HP Recovery Points:"
         hp_stat = item.recover_hp
       end
       if item.recover_sp_rate > item.recover_sp
         sp_string = "SP Recovery% :"
         sp_stat = item.recover_sp_rate
       else
         sp_string = "SP Recovery Points:"
         sp_stat = item.recover_sp
       end
       @strings = [hp_string, sp_string, "Phy. Def:" , "Mag Def:", "Accuracy:", "Variance:"]
       @stats = [hp_stat, sp_stat, item. pdef_f, item.mdef_f, item.hit, item.variance,
                      $game_party.item_number(@result)]
       @bitmap = RPG::Cache.icon(item.icon_name)
     when 1
       item = $data_armors[@result]
       @strings = ["Phy. Def:", "Mag. Def:", "Evasion plus:", "Strength plus:", "Dex. plus:",
                      "Agility plus:", "Int. plus:"]
       @stats = [item.pdef, item.mdef, item.eva, item.str_plus, item.dex_plus,
                   item.agi_plus, item.int_plus, $game_party.armor_number(@result) ]
       @bitmap = RPG::Cache.icon(item.icon_name)
     when 2
       item = $data_weapons[@result]
       @strings =["Attack Power:", "Phy. Def:", "Mag. Def:", "Strength plus:", "Dex. plus:",
                   "Agility plus:", "Int. plus:"]
       @stats = [item.atk, item.pdef, item.mdef, item.str_plus, item.dex_plus,
                   item.agi_plus, item.int_plus, $game_party.weapon_number(@result) ]
       @bitmap = RPG::Cache.icon(item.icon_name)
   end
   for i in 0...@strings.size
     x = i%2 * 184
     y = i /2 *28 +32
     self.contents.font.color = normal_color
     self.contents.draw_text(x,y,100, 28,@strings[i])
     self.contents.font.color = system_color
     self.contents.draw_text(x + 110, y, 45, 28, @stats[i].to_s)
   end
   self.contents.blt(0, 0, @bitmap, Rect.new(0, 0, 24, 24), 255)
   self.contents.font.color= normal_color
   self.contents.draw_text(40, 0, 300, 28, "Quantity curentley owned:")
   self.contents.font.color = system_color
   count = @stats[@stats.size - 1].to_s
   self.contents.draw_text(294, 0, 45, 28, count )
 end
   
#----------------------------------------------------------------------
 def set_result(result , type)
   @result = result
   @type = type
   refresh
 end

end #of Window_CraftResult

#=======================================
class Window_CraftIngredients < Window_Base

 #--------------------------------------------------------------------------
 def initialize
   super(240, 248, 400, 232)
   self.contents = Bitmap.new(width - 32, height - 32)
   self.contents.font.name = $fontface.is_a?(String) ? $fontface : $defaultfonttype
   self.contents.font.size = 20
   @ingredients = []
   @types = []
   @quantities = []
   @item = nil
   @count = 0
 end

 #--------------------------------------------------------------------------
 def refresh
   self.contents.clear
   for i in 0...@ingredients.size
     case @types[i]
     when 0
       @item = $data_items[@ingredients[i]]
       @count = $game_party.item_number(@ingredients[i])
     when 1
       @item = $data_armors[@ingredients[i]]
       @count = $game_party.armor_number(@ingredients[i])
     when 2
       @item = $data_weapons[@ingredients[i]]
       @count = $game_party.weapon_number(@ingredients[i])
     end
     y = i *26
     self.contents.blt(0, y, RPG::Cache.icon(@item.icon_name), Rect.new(0, 0, 24, 24), 255)
     self.contents.font.color = @count >= @quantities[i] ? normal_color : disabled_color
     self.contents.draw_text(30, y, 280, 28, @item.name)
     self.contents.draw_text(300, y, 45, 28, @quantities[i].to_s)
     self.contents.font.color = system_color
     self.contents.draw_text(245, y, 45, 28, @count.to_s )    
   end
 end
     
 #--------------------------------------------------------------------------
 def set_ingredients(ingredients , types, quantities)
   @ingredients = ingredients
   @types = types
   @quantities = quantities
   refresh
 end

end # of Window_CraftIngredients

#======================================
class Scene_Craft

 #--------------------------------------------------------------------------
 def initialize(craft_index=0, return_scene = "menu")
   @craft_index=craft_index
   @return_scene = return_scene
 end
 
 #--------------------------------------------------------------------------
 def main
   @craft_window = Window_Craft.new
   @craft_window.index=@craft_index
   @confirm_window = Window_Base.new(120, 188, 400, 64)
   @confirm_window.contents = Bitmap.new(368, 32)
   @confirm_window.contents.font.name = $fontface.is_a?(String) ? $fontface : $defaultfonttype
   @confirm_window.contents.font.size = $fontsize.is_a?(Integer) ? $fontsize : $defaultfontsize
   @help_window = Window_Help.new
   @craft_window.help_window = @help_window
   @result_window=Window_CraftResult.new
   @ingredients_window=Window_CraftIngredients.new
   @yes_no_window = Window_Command.new(100, ["Yes", "No"])
   @confirm_window.visible = false
   @confirm_window.z = 1500
   @yes_no_window.visible = false
   @yes_no_window.active = false
   @yes_no_window.index = 1
   @yes_no_window.x = 270
   @yes_no_window.y = 252
   @yes_no_window.z = 1500
   @label_window = Window_Base.new(450,200,190,52)
   @label_window.contents=Bitmap.new(@label_window.width - 32,@label_window.height - 32)
   @label_window.contents.font.size=20
   @label_window.contents.font.color = @label_window.normal_color
   @label_window.contents.font.name = $fontface.is_a?(String) ? $fontface : $defaultfonttype
   @label_window.contents.draw_text(0, 0, @label_window.contents.width, 20, "   Have    Need")
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
   @craft_window.dispose
   @result_window.dispose
   @ingredients_window.dispose
   @confirm_window.dispose
   @yes_no_window.dispose
   @label_window.dispose
 end

 #--------------------------------------------------------------------------
 def update
   @craft_window.update
   @ingredients_window.update
   if $game_party.recipes.size > 0
     @result_window.set_result(@craft_window.recipe.result, @craft_window.recipe.result_type)
     @ingredients_window.set_ingredients(@craft_window.recipe.ingredients,
                                                          @craft_window.recipe.ingredient_types,
                                                          @craft_window.recipe.quantities)
   end
   if @craft_window.active
     update_craft
     return
   end
   if @yes_no_window.active
     confirm_update
     return
   end
 end

 #--------------------------------------------------------------------------
 def update_craft
   if Input.trigger?(Input::B)
     $game_system.se_play($data_system.cancel_se)
     if @return_scene == "menu"
       $scene = Scene_Menu.new(0)
     else
       $scene = Scene_Map.new
     end
     return
   end
   if Input.trigger?(Input::C) and $game_party.recipes.size != 0
     @recipe = @craft_window.recipe
     if @recipe.have
       @yes_no_window.active = true
       @craft_window.active = false
     else
       $game_system.se_play($data_system.buzzer_se)
       return
     end
   end
 end

 #--------------------------------------------------------------------------
 def confirm_update
   @craft_index = @craft_window.index
   @confirm_window.visible = true
   @confirm_window.z = 1500
   @yes_no_window.visible = true
   @yes_no_window.active = true
   @yes_no_window.z = 1500
   @yes_no_window.update
   string = "Create " + @recipe.name + "?"
   cw = @confirm_window.contents.text_size(string).width
   center = @confirm_window.contents.width/2 - cw /2
   unless @drawn
     @confirm_window.contents.draw_text(center, 0, cw, 30, string)
     @drawn = true
   end
   if Input.trigger?(Input::C)
     if @yes_no_window.index == 0
       $game_system.se_play($data_system.decision_se)
       @recipe.make
       $game_system.se_play($data_system.save_se)
       $scene=Scene_Craft.new(@craft_index)
     else
       $game_system.se_play($data_system.cancel_se)
       $scene=Scene_Craft.new(@craft_index)
     end
   end
   if Input.trigger?(Input::B)
     $game_system.se_play($data_system.cancel_se)
     $scene=Scene_Craft.new(@craft_index)
   end
 end

end # of Scene_Craft