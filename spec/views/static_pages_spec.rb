require 'rails_helper'

RSpec.describe "static_pages/index" do

  it "has the correct title" do
    render :template => "static_pages/index", :layout => "layouts/application"
    expect(rendered).to have_title full_title('Welcome')
  end
end