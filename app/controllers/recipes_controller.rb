################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 02-11-2015(Johnathan Leuthold)
#Description: The Recipe controller allows users to have a collection of 
#             recipes.
################################################################################
class RecipesController < ApplicationController
    #Allow un-registered users access to all recipes
  skip_before_action :logged_in_user, only: :index
  
    #Ensures owner of object is allowed to edit and delete
  before_action -> { correct_user Recipe.find(params[:id]).user}, 
                   only: [:update, :destroy]
  
  ##############################################################################
  # Builds new user recipe
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "New Recipe"
    @recipe = current_user.recipes.build
    @btnText = "Create Recipe"
    @obj = @recipe
    render 'shared/form'
  end
  
  ##############################################################################
  # Saves new recipe for user
  #
  # Entry: dirty form
  #
  #  Exit: form information saved to database
  ##############################################################################
  def create
    @recipe = current_user.recipes.build(recipe_params)
    @btnText = "Create Recipe"
    @obj = @recipe
    if(@recipe.save)
      redirect_to current_user
    else
      flash.now.alert = "Form Error"
      render 'shared/form'
    end
  end
  
  ##############################################################################
  # Removes a user recipe from the database
  #
  # Entry: id is recipe id
  #
  #  Exit: recipe removed from database
  ##############################################################################
  def destroy
    current_user.recipes.find(params[:id]).destroy
    redirect_to current_user
  end
  
  ##############################################################################
  # Allows a user to edit a recipe
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def edit
    @page_title = "Edit Recipe"
    @recipe = current_user.recipes.find(params[:id])
    @btnText = "Create Recipe"
    @obj = @recipe
    render 'shared/form'
  end
  
  ##############################################################################
  # Updates a users recipe
  #
  # Entry: id is recipe id
  #        dirty form
  #
  #  Exit: recipe updated with form information
  ##############################################################################
  def update
    @recipe = current_user.recipes.find(params[:id])
    @obj = @recipe
    if(@recipe.update(recipe_params))
      flash.alert = "Recipe updated"
      redirect_to current_user
    else
      flash.now.alert = "Error"
      render 'shared/form'
    end
  end
  
  ##############################################################################
  # Builds list of all the recipes, or those that match set search criteria.
  #
  # Entry: none
  #
  # Exit: none
  ##############################################################################
  def index
    if params[:searchingredients] != nil && params[:search] != nil && 
    params[:searchauthor] != nil
      #Arrays and page_title are declared to avoid no-method errors if fields
      #that are null get into scope of a find or where clause
      @page_title = "Some Recipes"
      @recipes = []
      @recing = []
      @searchingreed = []
      #Search by recipe name, author,and ingredients.
      if params[:searchingredients].empty? == false && 
      params[:search].empty? == false && params[:searchauthor].empty? == false
        @recipes = authoringredientrecipesearch()
 
      #Search by recipe name and ingredients.
      elsif params[:searchingredients].empty? == false && 
      params[:search].empty? == false && params[:searchauthor].empty? == true
        @recipes = recipeingredientsearch()
        
      #Search by ingredients and author.
      elsif params[:searchingredients].empty? == false && 
      params[:search].empty? == true && params[:searchauthor].empty? == false
      @recipes = authoringredientsearch()
      
      #Search by recipe name and author.
      elsif params[:searchingredients].empty? == true && 
      params[:search].empty? == false && params[:searchauthor].empty? == false
        @query = params[:search]
        @author = User.find_by_username(params[:searchauthor])
        
        Recipe.where("name like :name AND user_id = :author", 
        {name: "%#{@query}%", author: @author}).find_each do |r|
          @recipes.push(r)
        end
      #Search only by ingredients.
      elsif params[:searchingredients].empty? == false && 
      params[:search].empty? == true && params[:searchauthor].empty? == true
        @recipes = ingredientsearch()
        
      #Searching by name.
      elsif params[:searchingredients].empty? == true && 
      params[:search].empty? == false && params[:searchauthor].empty? == true
        @query = params[:search]
        
        Recipe.where("name like :name", {name: "%#{@query}%"}).find_each do |r|
          @recipes.push(r)
        end
      #Find by author alone.
      else
        @author = User.find_by_username(params[:searchauthor])
        
        Recipe.where("user_id = :author", {author: @author}).find_each do |r|
          @recipes.push(r)
        end   
      end
      
      #This sorts the recipes by their recipe title.
      if (params[:order] == "1")
        @recipes.sort! {|a, b| b.name.downcase <=> a.name.downcase}
      else
        @recipes.sort! {|a, b| a.name.downcase <=> b.name.downcase}
      end
      
      #This sorts the recipes by their rating in descending order.
      if (params[:rating] == "1")
        @recipes.sort! do | a, b|
          a.rating == nil ? akey = -1 : akey = a.rating
          b.rating == nil ? bkey = -1 : bkey = b.rating
          bkey <=> akey
        end
      end
      
    else
      
      @page_title = "All Recipes"
      @recipes = Recipe.all 
    end
  end
  ##############################################################################
  # Search helper function for the case of a user searching by author, recipe,
  # and ingredients.
  #
  # Entry: The params from the search form.
  #
  # Exit: Returns an array of recipes as a result set.
  ##############################################################################  
  def authoringredientrecipesearch
    @query = params[:search]
    @searchedingredients = params[:searchingredients].split(/, */)
    @searchtest = []
    @searchedingredients.each do |si|
      @searchtest.push(si.downcase)
    end
    
    Ingredient.where("lower(name) IN (:searching)", 
    {searching: @searchtest}).find_each do |ingredigrab|
      @searchingreed.push(ingredigrab)
    end
    RecipeIngredient.where(ingredient_id: @searchingreed).find_each do |ids|
      @recing.push(ids)
    end
    
    @author = User.find_by_username(params[:searchauthor])
    if params[:exclusive] == "1"
      Recipe.where("name like :name AND user_id = :author", 
      {name: "%#{@query}%", author: @author}).find_each do |r|
        insert = false
        if @recing != nil
          RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
            if @recing.include?(i) == true
              insert = true
            end
          end
          if insert == true
            @recipes.push(r)
          end
        end
      end
    else
      Recipe.where("name like :name AND user_id = :author", 
      {name: "%#{@query}%", author: @author}).find_each do |r|
        insert = true
        if (r.recipe_ingredients.all.empty? == true)
          @recipes.push(r)
        else
          if @recing != nil
            RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
              if @recing.include?(i) == true
              else
                insert = false
              end
            end
            if insert == true
              @recipes.push(r)
            end
          end
        end
      end
    end
    return @recipes
  end
  ##############################################################################
  # Search helper function for the case of a user searching by recipe and
  # ingredients.
  #
  # Entry: The params from the search form.
  #
  # Exit: Returns an array of recipes as a result set.
  ##############################################################################   
  def recipeingredientsearch
    @query = params[:search]
    @searchedingredients = params[:searchingredients].split(/, */)
        @searchtest = []
    @searchedingredients.each do |si|
      @searchtest.push(si.downcase)
    end
    
    Ingredient.where("lower(name) IN (:searching)", 
    {searching: @searchtest}).find_each do |ingredigrab|
      @searchingreed.push(ingredigrab)
    end
    RecipeIngredient.where(ingredient_id: @searchingreed).find_each do |ids|
      @recing.push(ids)
    end
    
    if params[:exclusive] == "1"
      Recipe.where("name like :name", {name: "%#{@query}%"}).find_each do |r|
        insert = false
        if @recing != nil
          RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
            if @recing.include?(i) == true
              insert = true
            end
          end
          if insert == true
            @recipes.push(r)
          end
        end
      end
    else
      Recipe.where("name like :name", {name: "%#{@query}%"}).find_each do |r|
        insert = true
        if (r.recipe_ingredients.all.empty? == true)
          @recipes.push(r)
        else
          if @recing != nil
            RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
              if @recing.include?(i) == true
              else
                insert = false
              end
            end
            if insert == true
              @recipes.push(r)
            end
          end
        end
      end
    end
    return @recipes
  end
  ##############################################################################
  # Search helper function for the case of a user searching by author and
  # ingredients.
  #
  # Entry: The params from the search form.
  #
  # Exit: Returns an array of recipes as a result set.
  ##############################################################################   
  def authoringredientsearch
    @searchedingredients = params[:searchingredients].split(/, */)
    @searchtest = []
    
    @searchedingredients.each do |si|
      @searchtest.push(si.downcase)
    end
    
    Ingredient.where("lower(name) IN (:searching)", 
    {searching: @searchtest}).find_each do |ingredigrab|
      @searchingreed.push(ingredigrab)
    end
    
    RecipeIngredient.where(ingredient_id: @searchingreed).find_each do |ids|
      @recing.push(ids)
    end
    @author = User.find_by_username(params[:searchauthor])
    if params[:exclusive] == "1"
      Recipe.where("user_id = :author", {author: @author}).find_each do |r|
        insert = false
        if @recing != nil
          RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
            if @recing.include?(i) == true
              insert = true
            end
          end
          if insert == true
            @recipes.push(r)
          end
        end
      end
    else
      Recipe.where("user_id = :author", {author: @author}).find_each do |r|
        insert = true
        if (r.recipe_ingredients.all.empty? == true)
          @recipes.push(r)
        else
          if @recing != nil
            RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
              if @recing.include?(i) == true
              else
                insert = false
              end
            end
            if insert == true
              @recipes.push(r)
            end
          end
        end
      end
    end
    return @recipes
  end
  
  ##############################################################################
  # Search helper function for the case of a user searching by ingredients.
  #
  # Entry: The params from the search form.
  #
  # Exit: Returns an array of recipes as a result set.
  ##############################################################################
  def ingredientsearch
    @searchedingredients = params[:searchingredients].split(/, */)
    @searchtest = []
    @searchedingredients.each do |si|
      @searchtest.push(si.downcase)
    end
    
    Ingredient.where("lower(name) IN (:searching)", 
    {searching: @searchtest}).find_each do |ingredigrab|
      @searchingreed.push(ingredigrab)
    end
     RecipeIngredient.where(ingredient_id: @searchingreed).find_each do |ids|
      @recing.push(ids)
    end
    
    if params[:exclusive] == "1"
      Recipe.all.find_each do |r|
        insert = false
        if @recing != nil
          RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
            if @recing.include?(i) == true
              insert = true
            end
          end
          if insert == true
            @recipes.push(r)
          end
        end
      end
    else
      Recipe.all.find_each do |r|
        insert = true
        if (r.recipe_ingredients.all.empty? == true)
          @recipes.push(r)
        else
          if @recing != nil
            RecipeIngredient.where("recipe_id = ?", r.id).find_each do |i|
              if @recing.include?(i) == true
              else
                insert = false
              end
            end
            if insert == true
              @recipes.push(r)
            end
          end
        end
      end
    end 
    return @recipes
  end
  ##############################################################################
  # Displays a single recipe profile
  #
  # Entry: id is recipe_id
  #
  #  Exit: session[:recipe_id] set to recipe id
  ##############################################################################
  def show
    @recipe = Recipe.find(params[:id])
    @page_title = "#{@recipe.name}"
    session[:recipe_id] = @recipe.id
    @rating = @recipe.ratings.find_by(user_id: session[:user_id])
  end
  
#PRIVATE########################################################################  
  private
    ############################################################################
    # Allows only permitted parameters to be submitted and used on the pages
    ############################################################################
    def recipe_params
      params.require(:recipe).permit(:name, :picture)
    end
end