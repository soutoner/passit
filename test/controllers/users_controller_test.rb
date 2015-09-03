require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  ## == Index
  test "should get index" do
    get :index
    assert_response :success
    assert_equal User.all, assigns(:users)
    assert_select 'title', full_title('Users')
  end

  ## == Show
  test "should get show" do
    get :show, id: users(:one).id
    assert_response :success
    assert_equal users(:one), assigns(:user)
    assert_select 'title', full_title(users(:one).username)
  end
end
