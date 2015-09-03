require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  # == Index
  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', full_title('Welcome')
  end
end
