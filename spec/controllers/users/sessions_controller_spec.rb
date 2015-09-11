require 'rails_helper'

RSpec.describe Users::SessionsController do

  before :all do
    @user = create(:user)
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  after :all do
    @user.destroy
  end

  describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "should login user with username" do
      post :create, user: {
               login: @user.username,
               password: @user.password,
                  }
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('Signed in successfully.')
    end

    it "should login user with email" do
      post :create, user: {
                      login: @user.email,
                      password: @user.password,
                  }
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('Signed in successfully.')
    end
  end
end