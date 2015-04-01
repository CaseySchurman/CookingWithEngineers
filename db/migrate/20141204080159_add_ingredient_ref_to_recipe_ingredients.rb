class AddIngredientRefToRecipeIngredients < ActiveRecord::Migration
  def change
    add_reference :recipe_ingredients, :ingredient, index: true
  end
end
