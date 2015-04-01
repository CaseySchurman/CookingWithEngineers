class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.text :description
      t.integer :order
      t.references :recipe, index: true
      t.string :recipe_id

      t.timestamps
    end
  end
end
