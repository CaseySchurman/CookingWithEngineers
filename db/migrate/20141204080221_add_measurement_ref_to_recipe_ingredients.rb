class AddMeasurementRefToRecipeIngredients < ActiveRecord::Migration
  def change
    add_reference :recipe_ingredients, :measurement, index: true
  end
end
