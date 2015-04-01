class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :vote
      t.references :user, index: true
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
