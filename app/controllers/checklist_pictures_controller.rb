class ChecklistPicturesController < ApplicationController
  #Ensure only the recipe owner is allowed to upload pictures
  #before_action :current_user?(current_recipe.user)
  skip_before_action :logged_in_user
  
  def new
    @checklist = Checklist.find(params[:format])
    @checklist_picture = @checklist.checklist_pictures.build
    @page_title = "Add Checklist Picture"
    @btnText = "Add picture to checklist"
    @obj = @checklist_picture
    render 'shared/form'
  end
  
  def create
    @checklist = Checklist.find(params[:format])
    @checklist_picture = @checklist.checklist_pictures.build(clp_params)
    @obj = @checklist_picture
    if(@checklist_picture.save)
      redirect_back_or current_recipe
    else
      flash.now.alert = "Form Error"
      render 'shared/form'
    end
  end
  
  def edit
  end
  def update
  end
  def index
  end
  def destroy
  end
  
#PRIVATE########################################################################
private
  def clp_params
    params.require(:checklist_picture).permit(:picture)
  end
end
