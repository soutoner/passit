require 'rails_helper'
require 'support/factory_girl'

RSpec.describe 'User tries to sign up' do

  before :all do
    @user = attributes_for(:user)
  end

  describe 'visit sign up page' do

    before do
      visit new_user_registration_path
    end

    it 'should accept valid information' do
      fill_form(@user)

      expect(page).to have_current_path root_path
      expect(page).to have_css '.alert-notice', 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    end

    it 'should not accept invalid information' do
      @user[:username] = '$'
      fill_form(@user)

      expect(page).to have_css '.alert-danger', 'Username is invalid.'
    end
  end

  def fill_form(attributes={})
    fill_in 'Name', with: attributes[:name]
    fill_in 'Surname', with: attributes[:surname]
    fill_in 'Username', with: attributes[:username]
    fill_in 'Email', with: attributes[:email]
    fill_in 'Password', with: attributes[:password]
    fill_in 'user_password_confirmation', with: attributes[:password_confirmation]
    click_button 'Sign up'
  end
end