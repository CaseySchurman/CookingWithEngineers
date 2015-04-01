class Measurement < ActiveRecord::Base
    #Relationships
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
end
