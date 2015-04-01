require 'test_helper'

class UserControllerTest < ActionController::TestCase

  def setup
    @user = users(:chad)
    @other_user = users(:tom)
    @controller = UsersController.new
  end
  
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { username: @user.username,
                                     email: @user.email   }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { username: @user.username,
                                      email: @user.email        }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destory when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destory when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end
  
  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
  
end
















