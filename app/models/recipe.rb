class Recipe < ActiveRecord::Base
    #Relationships
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :checklists, dependent: :destroy
  
  #Show recipes in order of user_id and rating
  default_scope -> { order(user_id: :asc, name: :asc) }
  
  #Add picture uploader
  mount_uploader :picture, PictureUploader
  
  validates :name, presence: true, length: 2..255, uniqueness: { scope: :user }
  #Recipe names are unique per user
  #validates_uniqueness_of :name, scope: :user, on: :create
  validates :user_id, presence: true
  #Ensure picture is under 5MB
  validate :picture_size
  
public
def self.search(query, query2)
  @querytest = query
  @querytest2 = query2
  where("name like :query AND user_id = :query2", {query: "%#{query}%", query2: @querytest2})
end

def self.searchauthor(query)
  where("user_id = ?", "%#{query}%")
end
  
#PRIVATE########################################################################
private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
