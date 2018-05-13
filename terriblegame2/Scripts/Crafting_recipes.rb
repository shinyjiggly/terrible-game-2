#================================
# Sample master list for crafting script
#----------------------------------------------------------------
#-written by Deke
#----------------------------------------------------------------
#================================

class Game_Temp
  attr_reader :recipe_list
 
  alias crafting_temp_initialize initialize

  def initialize
    crafting_temp_initialize
    @recipe_list=[]
    get_recipe_list
  end
 
  def get_recipe_list
   
    ingredients = [30,31,32]
    ingredient_types = [0,0,0]
    quantities = [1,1,1]
    result = 4
    result_type = 2
    @recipe_list.push(Game_Recipe.new(ingredients,ingredient_types,quantities,result,result_type))
   
    ingredients = [29,30]
    ingredient_types = [0,0]
    quantities = [1,2]
    result = 8
    result_type = 1
    @recipe_list.push(Game_Recipe.new(ingredients,ingredient_types,quantities,result,result_type))
   
    ingredients = [30,31,1]
    ingredient_types = [0,0,1]
    quantities = [1,1,3]
    result = 4
    result_type = 0
    @recipe_list.push(Game_Recipe.new(ingredients,ingredient_types,quantities,result,result_type))
   
  end # of get_recipe_list method
end # of updates to Game_Temp Class