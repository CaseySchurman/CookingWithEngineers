class CreateUsdaIngredients < ActiveRecord::Migration
  def change
    create_table :usda_ingredients do |t|
      t.string :ndb
      t.string :name

      t.timestamps
    end
  end
end
