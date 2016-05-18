################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The Ingredients controller is responsible for ingredient objects
#used in the construction of recipe_ingredients
################################################################################
class IngredientsController < ApplicationController
  
    #Ensures that only admins can add ingredients
  #before_action :admin_user
  
  ##############################################################################
  # Builds a new ingredient to store in the database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "New Ingredeient"
    @ingredient = Ingredient.new
    @btnText = "Add Ingredient"
    @obj = @ingredient
    render 'shared/form'
  end
  
  ##############################################################################
  # Saves a new ingredient in the database
  #
  # Entry: :admin_user
  # =>     dirty form
  #
  #  Exit: record saved
  ##############################################################################
  def create
    @ingredient = Ingredient.new(ing_params)
    @obj = @ingredient
    #@counter = 0;
    #search_term = @ingredient.name 
    #@search_term = "sugar"
    #flash.alert = @search_term
    #@res = Amazon::Ecs.item_search(@search_term, :search_index => 'Grocery', :country => 'us')
    #@res.items.each do |item|
    #  @counter += 1;
    #  item_attributes = item.get_element('ItemAttributes')
    #  @item_price += item_attributes.get('Price')
    #  @avg_price = @item_price / @counter
    #end
    #flash.alert = "cost of " + @search_term + " is: " + @avg_price.to_s
    if(@ingredient.save)
      flash.alert = "Ingredient Added"
      redirect_to new_ingredient_path
    else
      flash.now.alert = "Form Error"
      render 'shared/form'
    end
  end

  ##############################################################################
  # Edits an ingredient in the database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def edit
    @page_title = "Edit Ingredeient"
    @ingredient = Ingredient.find(params[:id])
    @btnText = "Update Ingredient"
    @obj = @ingredient
    render 'shared/form'
  end
  
  ##############################################################################
  # Updates an ingredient in the database
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def update
    @ingredient = Ingredient.find(params[:id])
    @obj = @ingredient
    if(@ingredient.update_attributes(ing_params))
      flash.alert = "Ingredient updated"
      redirect_back_or ingredients_path
    else
      flash.now.alert = "Form Error"
      render 'shared/form'
    end
  end

  ##############################################################################
  # Builds list of all ingredients in the database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def index
    @page_title = "All Ingredients"
    @ingredients = Ingredient.all
  end
  
  ##############################################################################
  # Deletes an ingredient from the database
  #
  # Entry: :admin_user
  #
  #  Exit: ingredient deleted
  ##############################################################################
  def destroy
    Ingredient.find(params[:id]).destroy
    redirect_to ingredients_path
  end
  
  ##############################################################################
  # Displays a single ingredient
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def show
    @ingredient = Ingredient.find(params[:id])
    @page_title = "#{@ingredeint.name}"
  end
  
#PRIVATE########################################################################
  private
    ############################################################################
    # Allows only permitted parameters to be submitted and used on the pages
    ############################################################################
    def ing_params
      params.require(:ingredient).permit(:name)
    end
end
