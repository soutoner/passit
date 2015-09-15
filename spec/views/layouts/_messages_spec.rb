require 'rails_helper'

RSpec.describe "layouts/_messages" do

  before :all do
    @messages = {
        altura: 'Eres demasiado bajo para esta atracción.',
        peso: 'Pesas demasiado poco para jugar a la cometa.'
    }
  end

  context "valid flash" do

    it "all the messages are displayed" do
      flash[:info] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_content(@messages[:altura])
      expect(rendered).to have_content(@messages[:peso])
    end

    it "info blue message is displayed" do
      flash[:info] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_css('div.alert-info')
    end

    it "success green message is displayed" do
      flash[:success] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_css('div.alert-success')
    end

    it "danger red message is displayed" do
      flash[:danger] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_css('div.alert-danger')
    end

    it "warning yellow message is displayed" do
      flash[:warning] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_css('div.alert-warning')
    end

    it "notice blue message is displayed" do
      flash[:notice] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_css('div.alert-notice')
    end

    it "error red message is displayed" do
      flash[:error] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).to have_css('div.alert-error')
    end
  end

  context "invalid flash" do

    it "it's not displayed" do
      flash[:something] = @messages

      render :partial => 'layouts/messages'

      expect(rendered).not_to have_css('div.alert-something')
    end
  end
end