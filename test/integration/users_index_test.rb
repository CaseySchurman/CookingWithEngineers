require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:chad)
    @non_admin = users(:tom)
  end
  
  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |u|
      assert_select 'a[href=?]', user_path(u), text: u.username
    end
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    all_users = User.paginate(page: 1)
    all_users.each do |u|
      assert_select 'a[href=?]', user_path(u), text: u.username
      unless u == @admin
        assert_select 'a[href=?]', user_path(u), text: 'delete', method: :delete
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
end
