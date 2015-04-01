class Comment < ActiveRecord::Base
    #Relationships
  belongs_to :recipe
  belongs_to :user
    #Set comments to display most recent first
  default_scope -> { order(created_at: :desc) }
  
    #Sets uploader for pictures
  #mount_uploader :picture, PictureUploader
  
    #Validations
  validates :user_id, presence: true
  validates :text, presence: true, length: 10..250
  #validate :picture_size

#PRIVATE########################################################################
private
  ##############################################################################
  # Sets a limit on file size
  ##############################################################################
  def picture_size
    if(picture.size > 5.megabytes)
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
