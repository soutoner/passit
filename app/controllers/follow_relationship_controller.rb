class FollowRelationshipController < ApplicationController

  def create
    profile = User.find(strong_params)
    current_user.follow(profile)
    respond_to do |format|
      format.html { redirect_to user_path(profile.username) }
      format.js   {
        render :json => {
                   :success   => :true,
                   :followers => profile.followers.count
               }
      }
    end
  end

  def destroy
    profile = User.find(strong_params)
    current_user.unfollow(profile)
    respond_to do |format|
      format.html { redirect_to user_path(profile.username) }
      format.js   {
        render :json => {
                   :success   => :true,
                   :followers => profile.followers.count
               }
      }
    end
  end

  private

    def strong_params
      params.require(:id)
    end
end
