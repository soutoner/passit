class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_username!(params[:username])
    # If guest tries to follow somebody and is redirected to login page
    store_location_for(:user, user_path(@user))
  end
end
