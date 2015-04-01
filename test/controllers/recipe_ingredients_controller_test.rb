require 'test_helper'

class RecipeIngredientsControllerTest < ActionController::TestCase
  
  def setup
    #log_in_as(users(:tom))
    @recipe = recipes(:ccc)
    @measurement = measurements(:cup)
    @ingredient = ingredients(:flour)
  end
  
  test "should be valid" do
    @ri = @recipe.recipe_ingredients.new( quantity: 2.25, 
                                          measurement_id: @measurement.id,
                                          ingredient_id: @ingredient.id )
    assert @ri.valid?
  end
  
  test "should be invalid" do
    @ri = @recipe.recipe_ingredients.new( quantity: 2.25, 
                                          measurement_id: @measurement.id)
    assert_not @ri.valid?
  end
  
  test "should redirect add when not logged in" do
    session[:recipe_id] = @recipe.id
    assert_no_difference 'RecipeIngredient.count' do
      post :create, recipe_ingredient: { quantity: 2.25,
                                         measurement_id: @measurement.id }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    
  end
  
  
end
