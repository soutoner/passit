require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  ## == New
  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  ## == Create
  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
                      name: 'John Newman',
                      surname: 'Lastest user',
                      username: 'johnny',
                      email: 'john@example.com',
                      password: 'foobar6Y',
                      password_confirmation: 'foobar6Y',
                  }
    end
    assert_redirected_to user_path(assigns(:user))
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
  end

  test "should not create user if invalid" do
    assert_no_difference('User.count') do
      post :create, user: {
                      name: 'John Newman',
                      surname: 'Lastest user',
                      username: '',
                      email: 'john@example.com',
                      password: 'foobar6Y',
                      password_confirmation: 'foobar6Y',
                  }
    end
    assert_template :new
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user).errors
  end
end