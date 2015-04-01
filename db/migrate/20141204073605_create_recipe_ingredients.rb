class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.float :quantity
      t.string :text
      
      t.timestamps
    end
  end
end
