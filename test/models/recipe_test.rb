require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @user = users(:chad)
    @recipe = @user.recipes.build(name: "Chocolate Chip Cookies")
  end
  
  test "reference should match" do
    assert_equal @recipe.user_id, @user.id
  end
  
  test "should be valid" do
    @recipe.valid?
  end
  
  test "user_id should not be blank" do
    @recipe.user_id = nil
    assert_not @recipe.valid?
  end
  
  test "name should be more than 1 character" do
    @recipe.name = "a"
    assert_not @recipe.valid?
  end
  
  test "name should not be too long" do
    @recipe.name = "a" * 256
    assert_not @recipe.valid?
  end
  
  test "name should be present" do
    @recipe.name = "    "
    assert_not @recipe.valid?
  end

  
end
