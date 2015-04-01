class DatabaseIngredient < ActiveRecord::Migration
  def change
    create_table :database_ingredients do |t|
      sql = ""
      source = File.new("db/usda_national_nutrients_no_graves.sql", "r")
      while (line = source.gets)
        sql << line
      end
      source.close
      execute sql
      t.timestamps
    end
  end
end