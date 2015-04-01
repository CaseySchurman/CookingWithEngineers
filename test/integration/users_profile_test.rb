require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:chad)
  end
  
  test 'profile_display' do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select "title", "User #{full_title(@user.username)}"
    assert_select 'h2', text: "Recipes for #{@user.username}"
    assert_select 'div.pagination'
    @user.recipes.paginate(page: 1).each do |r|
      assert_match r.name, response.body
    end
  end
  
end
