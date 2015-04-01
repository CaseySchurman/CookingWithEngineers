require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:chad)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'shared/form'
    patch user_path(@user), user: { userame: "",
                                    email: "user@invalid",
                                    password: "one",
                                    password_confirmation: "two" }
    assert_template 'shared/form'
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'shared/form'
    username = "Roger"
    email = "roger@edit.com"
    patch user_path(@user), user: { username: username,
                                    email: email,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.username, username
    assert_equal @user.email, email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    uname = 'Roger'
    email = 'roger@edit.com'
    pass = 'foobar'
    patch user_path(@user), user: { username: uname,
                                    email: email,
                                    password: pass,
                                    password_confirmation: pass }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.username, uname
    assert_equal @user.email, email
  end
end










