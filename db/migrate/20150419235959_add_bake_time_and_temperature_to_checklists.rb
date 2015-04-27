class AddBakeTimeAndTemperatureToChecklists < ActiveRecord::Migration
  def change
    change_table :checklists do |t|
      t.integer :baketime
      t.integer :baketemp
      t.integer :steptype
    end
  end
end
