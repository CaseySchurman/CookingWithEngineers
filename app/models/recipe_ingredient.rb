class RecipeIngredient < ActiveRecord::Base
    
    #Relationships
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :measurement
  
  validates :recipe_id, presence: true
  validates :quantity, presence: true, :numericality => {:greater_than => 0}
  validates :measurement_id, presence: true
  validates :ingredient_id, presence: true
end
