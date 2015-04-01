require 'test_helper'

class UserRegisterTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  
  test "should be invalid register information" do
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, user: { username: "",
                               email: "user@example.com",
                               password: "peanut",
                               password_confirmation: "peanut" }
    end
    assert_template 'shared/form'
  end
  
  test "valid register information" do
    get new_user_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { username: "abcdef",
                                           email: "abc@def.com",
                                           password: 'password',
                                           password_confirmation: 'password' }
    end
    assert_template 'main_pages/home'
    assert_not flash.empty?
  end
  
  test "valid register and activation" do
    get register_path
    assert_difference 'User.count', 1 do
      post users_path, user: { username: 'Example2',
                               email: 'user@example2.com',
                               password: 'peanut',
                               password_confirmation: 'peanut' }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
      #user not activated
    assert_not user.activated?
      #try logging in without acctivation
    log_in_as(user)
    assert_not flash.empty?
      #Activate account with invalid token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
      #Actiavte account with invalid email
    get edit_account_activation_path(user.activation_token, email: 'wrong@email.com')
    assert_not is_logged_in?
      #Activate account with valid information
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end