require 'rails_helper'

RSpec.describe Users::RegistrationsController do

  before :all do
    @user = attributes_for(:user)
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
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

    it "assigns an empty user to @user" do
      get :new
      expect(assigns(:user)).not_to be_nil
    end
  end

  describe "POST #create" do
    it "should create user" do
      expect{
        post :create, user: @user
      }.to change{User.count}.from(0).to(1)
      expect(response).to redirect_to user_path(assigns(:user))
      expect(flash[:notice]).to eq('Welcome! You have signed up successfully.')
    end

    it "should not create user if invalid" do
      @user[:username] = ''
      expect{
        post :create, user: @user
      }.not_to change{User.count}
      expect(response).to render_template(:new)
      expect(assigns(:user)).not_to be_nil
      expect(assigns(:user).errors).not_to be_nil
    end
  end
end