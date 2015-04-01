class Rating < ActiveRecord::Base
    #Relationships
  belongs_to :user
  belongs_to :recipe
  
  validates :vote, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
end
