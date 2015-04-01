require 'test_helper'

class MainPagesControllerTest < ActionController::TestCase
  
  
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", full_title("Home")
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", full_title("Help")
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", full_title("About")
  end
end
