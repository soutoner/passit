require 'rails_helper'
require 'support/factory_girl'

RSpec.describe 'User tries to log in' do

  before :all do
    @user = create(:user)
  end

  before :each do
    visit new_user_session_path
  end

  after :all do
    @user.destroy
  end

  describe "correct credentials" do
    it 'with username must log in user' do
      login(@user.username, @user.password)

      expect(page).to have_current_path root_path
      expect(page).to have_css '.alert-notice', 'Signed in successfully.'
    end

    it 'with email must log in user' do
      login(@user.email, @user.password)

      expect(page).to have_current_path root_path
      expect(page).to have_css '.alert-notice', 'Signed in successfully.'
    end
  end

  describe "incorrect credentials" do
    it 'must not log in user' do
      login(@user.name, @user.password)

      expect(page).to have_current_path new_user_session_path
      expect(page).to have_css '.alert-warning', 'Invalid login or password.'
    end
  end

  def login(login, password)
    fill_in 'Login', with: login
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end