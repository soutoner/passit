require 'rails_helper'

RSpec.describe Users::RegistrationsController do

  before :all do
    @user = attributes_for(:user)
    @db_user = create(:user, username: 'dbuser' , email: 'dbuser@example.com')
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  after :all do
    @db_user.destroy
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
      }.to change{User.count}.from(User.count).to(User.count+1)
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

  describe "PUT #update_profile" do
    it "should update avatar if given" do
      sign_in @db_user
      file = fixture_file_upload('spec/fixtures/files/test.jpg', 'image/jpeg')
      expect{
        put :update_profile, user: { avatar: file }
      }.to change{User.find(@db_user.id).avatar}
      expect(flash[:notice]).to eq('Your account has been updated successfully.')
    end

    it "should update name if given" do
      sign_in @db_user
      expect{
        put :update_profile, user: { name: 'Nuevo nombre' }
      }.to change{User.find(@db_user.id).name}.from(@db_user.name).to('Nuevo nombre')
      expect(flash[:notice]).to eq('Your account has been updated successfully.')
    end

    it "should update surname if given" do
      sign_in @db_user
      expect{
        put :update_profile, user: { surname: 'Apellido' }
      }.to change{User.find(@db_user.id).surname}.from(@db_user.surname).to('Apellido')
      expect(flash[:notice]).to eq('Your account has been updated successfully.')
    end

    it "should not update name if not valid" do
      sign_in @db_user
      expect{
        put :update_profile, user: { name: 'Nuevo nombre$$%' }
      }.not_to change{User.find(@db_user.id).name}
    end

    it "should not update surname if not valid" do
      sign_in @db_user
      expect{
        put :update_profile, user: { surname: 'Apellido$$%' }
      }.not_to change{User.find(@db_user.id).surname}
    end
  end

  describe "PUT #password_profile" do
    it "should update password name if given" do
      sign_in @db_user
      expect{
        put :update_password, user: {
                                password: 'newpassword6Y',
                                password_confirmation: 'newpassword6Y',
                                current_password: @db_user.password
                            }
      }.to change{User.find(@db_user.id).encrypted_password}
      expect(flash[:notice]).to eq('Your account has been updated successfully.')
    end

    it "should not update password if given confirmation doesnt match" do
      sign_in @db_user
      expect{
        put :update_password, user: {
                                password: 'newpassword6Y',
                                password_confirmation: 'nesword6Y',
                                current_password: @db_user.password
                            }
      }.not_to change{User.find(@db_user.id).encrypted_password}
    end

    it "should not update password if bad current password" do
      sign_in @db_user
      expect{
        put :update_password, user: {
                                password: 'newpassword6Y',
                                password_confirmation: 'newpassword6Y',
                                current_password: 'foo'
                            }
      }.not_to change{User.find(@db_user.id).encrypted_password}
    end
  end

  # describe "DELETE #avatar" do
  #   it "should delete avatar if requested" do
  #     sign_in @db_user
  #     file = fixture_file_upload('spec/fixtures/files/test.jpg', 'image/jpeg')
  #     put :update_profile, user: { avatar: file }
  #     expect{
  #       delete :destroy_avatar
  #     }.to change(User.find(@db_user.id), 'avatar').to(nil)
  #     expect(flash[:notice]).to eq('Avatar successfully deleted.')
  #   end
  # end
end