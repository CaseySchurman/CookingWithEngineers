class CreateChecklistPictures < ActiveRecord::Migration
  def change
    create_table :checklist_pictures do |t|
      t.string :picture
      t.references :checklist, index: true

      t.timestamps
    end
  end
end
