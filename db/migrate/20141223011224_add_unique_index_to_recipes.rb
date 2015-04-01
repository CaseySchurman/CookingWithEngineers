class AddUniqueIndexToRecipes < ActiveRecord::Migration
  def change
    add_index :recipes, [:name, :user_id], :unique => true
  end
end
