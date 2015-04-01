################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The Ratings controller allows users a single rating per recipe.
################################################################################
class RatingsController < ApplicationController
  
    #Ensures only the owner of the object is able to edit or delete
  before_action -> { correct_user Rating.find(params[:id]).user}, 
                   only: [:update, :destroy]
                   
    #Ensures the overall recipe rating is always up to date
  after_action :update_recipe, only: [:create, :update, :destroy]
  
  ##############################################################################
  # New ratings form for recipe
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "New Rating"
    @rating = current_recipe.ratings.build
    @btnText = "Add Rating"
    @obj = @rating
    
    respond_to do |f|
      f.html{render 'shared/form'}
      f.js
    end
  end
  
  ##############################################################################
  # Creates a new user rating for a recipe and saves to db
  #
  # Entry: dirty form
  #
  #  Exit: rating saved to db
  ##############################################################################
  def create
    @rating = current_recipe.ratings.build(rating_params)
    @rating.user_id = current_user.id
    @obj = @rating
    if(@rating.save)
      #flash.alert = "Rating added"
      respond_to do |f|
        f.html{redirect_back_or current_recipe}
        f.js {@rating}
      end
    end
    else
      #flash.now.alert = "Error"
      respond_to do |f|
      f.html{render 'shared/form'}
      f.js {@rating}
    end
  end
  
  ##############################################################################
  # Builds a list of all ratings in db
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def index
    @page_title = "All Ratings"
    @ratings = Rating.all
  end

  ##############################################################################
  # Edits a users rating for a recipe
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def edit
    @page_title = "Edit Rating"
    @rating = current_recipe.ratings.find(params[:id])
    @btnText = "Update Rating"
    @obj = @rating
    respond_to do |f|
      f.html {render 'shared/form'}
      f.js {@rating}
    end
  end
  
  ##############################################################################
  # Updates a users rating for a recipe
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def update
    @rating = current_recipe.ratings.find(params[:id])
    @obj = @rating
    if(@rating.update_attributes(rating_params) )
      respond_to do |f|
        f.html{redirect_back_or current_recipe}
        f.js {@rating}
      end
    else
      #flash.now.alert = "Form Error"
      respond_to do |f|
        f.html{render 'shared/form'}
        f.js {@rating}
      end
    end
  end

#PRIVATE########################################################################
  private
    ############################################################################
    # Allows only permitted parameters to be submitted and used on the pages
    ############################################################################
    def rating_params
      params.require(:rating).permit(:vote, :user_id, :recipe_id)
    end
    
    ############################################################################
    # Updates the overall rating of a recipe when rating is added or edited
    ############################################################################
    def update_recipe
      @ratings = current_recipe.ratings.all
      current_recipe.update_attribute(:rating, 
                                      @ratings.sum(:vote)/@ratings.count)
    end
    
end

