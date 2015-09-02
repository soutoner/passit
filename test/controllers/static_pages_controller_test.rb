require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  # == Index
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should see 'Welcome'" do
    get :index
    assert_select 'h1', "Welcome to PassIt"
  end

end
