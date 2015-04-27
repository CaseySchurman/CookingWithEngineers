################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The Checklists controller allows users to post 1 or many 
# checklist items to an individual recipe.
################################################################################
class ChecklistsController < ApplicationController
  before_filter :fix_params, :only => [:create, :update]
  
  ##############################################################################
  # Builds a new checklist to store in the database
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "New Checklist Item"
    @checklist = current_recipe.checklists.build
    @btnText = "Add Step"
    @obj = @checklist
    @images = @checklist.checklist_pictures.all
    respond_to do |f|
      f.html {render 'shared/form'}
      f.js
    end
  end
  
  ##############################################################################
  # Builds a checklist from the allowed page parameters.  If save was successful
  # user is directed back to the recipe they were on otherwise the user is 
  # allowed to fix errors on the checklist page and re-submit
  #
  # Entry: dirty form
  #
  #  Exit: form information saved to database
  ##############################################################################
  def create
    @checklist = current_recipe.checklists.build(checklist_params)
    #If the time fields are empty set them to 0 so baketime has predictable
    #behavior.
    if params[:baketimeseconds] == nil
      @seconds = 0
    else
      @seconds = params[:baketimeseconds].to_i
    end
    if params[:baketimeminutes] == nil
      @minutes = 0
     else
      @minutes = params[:baketimeminutes].to_i 
    end
    @totalseconds = (@minutes * 60) + @seconds
    
    @checklist.baketime = @totalseconds
    @recipe = current_recipe
    @obj = @checklist
    if(@checklist.save)
      #flash.alert = "Added Checklist Item"
      respond_to do |f|
        f.html {redirect_back_or current_recipe}
        f.js {@recipe}
      end
    else
      #flash.now.alert = "Form Error"
      respond_to do |f|
        f.html {render 'shared/form'}
        f.js {@recipe}
      end
    end
  end
  
  ##############################################################################
  # Finds a users checklist from the current recipe to display on view.
  #
  # Entry: :verify_user
  #
  #  Exit: none
  ##############################################################################  
  def edit
    @page_title = "Edit Checklist Item"
    @checklist = current_recipe.checklists.find(params[:id])
    @btnText = "Update Checklist Item"
    @obj = @checklist
    @images = @checklist.checklist_pictures.all
    respond_to do |f|
      f.html {render 'shared/form'}
      f.js
    end
  end

  ##############################################################################
  # Updates checklist with new page parameters
  #
  # Entry: :verify_user
  #
  #  Exit: returns to current_recipe if successful
  #        or allows user to fix errors on the form
  ##############################################################################
  def update
    @recipe = Recipe.find(current_recipe)
    @checklist = current_recipe.checklists.find(params[:id])
    if params[:baketimeseconds] == nil
      @seconds = 0
    else
      @seconds = params[:baketimeseconds].to_i
    end
    if params[:baketimeminutes] == nil
      @minutes = 0
     else
      @minutes = params[:baketimeminutes].to_i 
    end
    @totalseconds = (@minutes * 60) + @seconds
    
    @checklist.baketime = @totalseconds
    @obj = @checklist
    if(@checklist.update(checklist_params))
      respond_to do |f|
        f.html {redirect_back_or current_recipe}
        f.js {@recipe}
      end
    else
      respond_to do |f|
        f.html {render 'shared/form'}
        f.js {@recipe}
      end
    end
  end
  
  ##############################################################################
  # Deletes a user checklist from the current recipe
  #
  # Entry: :verify_user
  #
  #  Exit: checklist deleted
  ##############################################################################
  def destroy
    @recipe = Recipe.find(current_recipe);
    current_recipe.checklists.find(params[:id]).destroy
    respond_to do |f|
      f.html {redirect_back_or current_recipe}
      f.js {@recipe}
    end
  end
  
  ##############################################################################
  # Builds a list of all checklists
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def index
    redirect_to root_url unless admin
    @page_title = "All checklist items"
    @checklists = Checklist.all
  end
  
#PRIVATE########################################################################
  private
    def fix_params 
    end
  
    ############################################################################
    # Allows only permitted parameters to be submitted and used on the pages
    ############################################################################
    def checklist_params
      params.require(:checklist).permit(:steptype, :baketemp, :baketime, :description, :order, :recipe_id)
    end
end
