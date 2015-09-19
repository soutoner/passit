require 'rails_helper'

RSpec.describe FollowRelationshipController do
  login_user

  before :all do
    @profile = create(:user)
  end

  after :all do
    @profile.destroy
  end

  describe "POST #create" do
    describe "html response" do
      it "loged user must follow given user (by id)" do
        expect{
          post :create, id: @profile.id
        }.to change{controller.current_user.following?(@profile)}.from(false).to(true)
        expect(response).to redirect_to(user_path(@profile))
      end
    end

    describe "AJAX request" do
      it "loged user must follow given user (by id)" do
        expect{
          xhr :post, :create, id: @profile.id
        }.to change{controller.current_user.following?(@profile)}.from(false).to(true)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['success']).to eq('true')
        expect(JSON.parse(response.body)['followers']).to eq(@profile.followers.count)
      end
    end
  end

  describe "DELETE #destroy" do
    describe "html response" do
      it "loged user must unfollow given user (by id)" do
        controller.current_user.follow(@profile)
        expect{
          delete :destroy, id: @profile.id
        }.to change{controller.current_user.following?(@profile)}.from(true).to(false)
        expect(response).to redirect_to(user_path(@profile))
      end
    end

    describe "AJAX request" do
      it "loged user must unfollow given user (by id)" do
        controller.current_user.follow(@profile)
        expect{
          xhr :delete, :destroy, id: @profile.id
        }.to change{controller.current_user.following?(@profile)}.from(true).to(false)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['success']).to eq('true')
        expect(JSON.parse(response.body)['followers']).to eq(@profile.followers.count)
      end
    end
  end
end
