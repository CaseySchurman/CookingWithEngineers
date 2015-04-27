class DatabaseIngredient < ActiveRecord::Migration
  def change
    create_table :database_ingredients do |t|
      sql = ""
      source = File.new("db/usda_database_trimmed_v1.sql", "r")
      while (line = source.gets)
        sql << line
      end
      source.close
      execute sql
      t.timestamps
    end
  end
end