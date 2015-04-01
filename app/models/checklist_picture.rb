class ChecklistPicture < ActiveRecord::Base
  belongs_to :checklist
  
  #Add picture uploader
  mount_uploader :picture, PictureUploader

  validate :picture_size
  
#PRIVATE########################################################################
private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
