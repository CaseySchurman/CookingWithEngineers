class AddRecipeRefToRecipeIngredients < ActiveRecord::Migration
  def change
    add_reference :recipe_ingredients, :recipe, index: true
  end
end
