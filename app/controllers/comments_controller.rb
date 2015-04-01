################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The Comments controller allows users to post 1 or many comments
#to an individual recipes.
################################################################################
class CommentsController < ApplicationController
  
    #Ensures only the owner of the object is able to edit and delete
  before_action -> { correct_user Comment.find(params[:id]).user }, 
                   only: [:update, :destroy]
  
    #Ensures only admin users can view index page listing all comments
  before_action :admin_user, only: :index
  
  ##############################################################################
  # Builds a new comment to store in the database
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "New Comment"
    @comment = current_recipe.comments.build
    @btnText = "Add Comment"
    @obj = @comment
    respond_to do |f|
      f.html {render 'shared/form'}
      f.js
    end
  end
  
  ##############################################################################
  # Builds a comment from the allowed page parameters.  If save was successful
  # user is directed back to the recipe they were on otherwise the user is 
  # allowed to fix errors on the comment page and re-submit
  #
  # Entry: dirty form
  #
  #  Exit: form information saved to database
  ##############################################################################
  def create
    @recipe = Recipe.find(current_recipe)
    @comment = current_recipe.comments.build(comment_params)
    @comment.user_id = current_user.id
    @obj = @comment
    if(@comment.save)
      #flash.alert = "New Comment"
      respond_to do |f|
        f.html {redirect_back_or current_recipe}
        f.js {@recipe}
      end
    else
      #flash.now.alert = "Error"
      respond_to do |f|
        f.html {render 'shared/form'}
        f.js {@recipe}
      end
    end
  end
  
  ##############################################################################
  # Finds a users comment from the current recipe to display on view.
  #
  # Entry: :verify_user
  #
  #  Exit: none
  ##############################################################################  
  def edit
    @page_title = "Edit Comment"
    @comment = current_recipe.comments.find(params[:id])
    @btnText = "Update Comment"
    @obj = @comment
    respond_to do |f|
      f.html {render 'shared/form'}
      f.js
    end
  end

  ##############################################################################
  # Updates comment with new page parameters
  #
  # Entry: :verify_user
  #
  #  Exit: returns to current_recipe if successful
  #        or allows user to fix errors on the form
  ##############################################################################
  def update
    @recipe = Recipe.find(current_recipe)
    @comment = current_recipe.comments.find(params[:id])
    @obj = @comment
    if(@comment.update(comment_params))
      respond_to do |f|
        f.html{redirect_back_or current_recipe}
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
  # Deletes a user comment from the current recipe
  #
  # Entry: :verify_user
  #
  #  Exit: comment deleted
  ##############################################################################
  def destroy
    @recipe = Recipe.find(current_recipe)
    current_recipe.comments.find(params[:id]).destroy
    respond_to do |f|
      f.html {redirect_back_or current_recipe}
      f.js {@recipe}
    end
  end
  
  ##############################################################################
  # Builds a list of all comments
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def index
    @comments = Comment.all
  end
  
#PRIVATE########################################################################
  private
    ############################################################################
    # Allows only permitted parameters to be submitted and used on the pages
    ############################################################################
    def comment_params
      params.require(:comment).permit(:text, :user_id, :recipe_id)
    end
end
