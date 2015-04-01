require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:chad)
    @other_user = users(:tom)
  end
  
  test "login with invalid info" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { username: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information" do
    #Login user
    get login_path
    post login_path, session: { username: @user.username, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    
    #Ensure logged in links
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", recipes_path
    assert_select "a[href=?]", users_path
    
    #Logout user
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    
    #Simulate user logging out in another window
    delete logout_path
    follow_redirect!
    
    #Ensure logged out links
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", recipes_path
  end
  
  test "login with remember" do
    log_in_as(@user)
    assert assigns(:user).remember_digest, true
  end
  
  test "login without rememeber" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end
