require 'rails_helper'

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
      expect(response).to render_template('index')
    end

    it "loads all of the users into @users" do
      get :index
      expect(assigns(:users)).to match(User.all)
    end
  end

  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do
      get :show, id: @user.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :show, id: @user.id
      expect(response).to render_template('show')
    end

    it "loads all of the users into @users" do
      get :show, id: @user.id
      expect(assigns(:user)).to match(@user)
    end
  end
end
