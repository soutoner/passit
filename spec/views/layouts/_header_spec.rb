require 'rails_helper'

RSpec.describe "layouts/_header" do

  context "guest user" do
    it "navbar render links to register and login" do
      allow(controller).to receive(:signed_in?).and_return(false)

      render :partial => 'layouts/header'

      expect(rendered).to have_link('Register', href: new_user_registration_path)
      expect(rendered).to have_link('Login', href: new_user_session_path)
    end
  end

  context "authenticated user" do
    it "navbar render links to profile and logout" do
      user = build_stubbed(:user)
      allow(controller).to receive(:signed_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)

      render :partial => 'layouts/header'

      expect(rendered).to have_content user.username
      expect(rendered).to have_link('Profile', href: user_path(user))
      expect(rendered).to have_link('Settings', href: edit_user_registration_path)
      expect(rendered).to have_link('Logout', href: destroy_user_session_path)
    end
  end
end