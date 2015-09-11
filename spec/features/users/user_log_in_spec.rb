require 'rails_helper'

RSpec.describe 'User tries to log in' do

  before :all do
    @user = create(:user)
  end

  after :all do
    @user.destroy
  end

  it 'should log in user' do
    visit 'users/sign_in'

    fill_in 'Login', with: @user.username
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    expect(page).to have_current_path root_path
    expect(page).to have_css '.alert', 'Signed in successfully.'
  end
end