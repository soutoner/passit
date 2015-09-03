require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_equal User.all, assigns(:users)
  end

  test "should get show" do
    get :show, id: users(:one).id
    assert_response :success
    assert_equal users(:one), assigns(:user)
  end
end
