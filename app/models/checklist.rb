class Checklist < ActiveRecord::Base
  belongs_to :recipe
  has_many :checklist_pictures
  
  default_scope -> { order(recipe_id: :asc, order: :asc) }
  
  validates :description, presence: true, length: 10..250
  validates :order, presence: true, :numericality => {:greater_than => 0}
  
end