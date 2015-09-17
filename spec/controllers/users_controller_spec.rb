require 'rails_helper'
require 'support/factory_girl'

RSpec.describe UsersController do

  before :all do
    @user = create(:user)
  end

  after :all do
    @user.destroy
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end

    before do
      @users = create_list(:user, 5)
    end

    it "loads all of the users into @users" do
      get :index
      expect(assigns(:users)).to match(User.all)
    end

    after do
      @users.each { |user| user.destroy }
    end
  end

  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do
      get :show, username: @user.username
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :show, username: @user.username
      expect(response).to render_template :show
    end

    it "load current user into @user" do
      get :show, username: @user.username
      expect(assigns(:user)).to match(@user)
    end
  end
end
