require 'test_helper'

class RecipeInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tom)
  end
  
  test "recipe interface" do
    log_in_as(@user)
    get user_path(@user)
    assert_select 'div.pagination'
    assert_template 'users/show'
    
      #Invalid submission
    assert_no_difference 'Recipe.count' do
      post recipes_path, recipe: { name: "" }
    end
    assert flash.any?
    
      #Valid submission
    name = "Chocolate Chip Cookies"
    picture = fixture_file_upload('test/fixtures/orc.jpg', 'image/jpeg')
    assert_difference 'Recipe.count', 1 do
      post recipes_path, recipe: { name: name, picture: picture }
    end
    
    recipe = assigns(:recipe)
    assert recipe.picture?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_match name, response.body
    
      #Delete a recipe
    assert_select 'a', text: 'delete'
    first_recipe = @user.recipes.paginate(page: 1).first
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(first_recipe)
    end
    
      #Visit a different user
    get user_path(users(:chad))
    assert_select 'a', text: 'delete', count: 0
    
    #Duplicate submission not allowed
    assert_no_difference 'Recipe.count' do
      post recipes_path, recipe: { name: name }
    end
    assert flash.any?
    assert_template 'shared/form'
  end
end
