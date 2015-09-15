# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(50)
#  surname                :string(50)
#  username               :string(20)       not null
#  email                  :string(255)      not null
#  photo                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email) UNIQUE
#  index_users_on_username            (username) UNIQUE
#

require 'rails_helper'
require 'support/factory_girl'

RSpec.describe User do
  include UsersHelper

  it { should have_attached_file(:avatar) }
  it { should validate_attachment_content_type(:avatar).
                  allowing('image/png', 'image/jpeg', 'image/gif') }

  before :each do
    @user = build(:user)
  end

  describe "validations" do

    it "should be valid" do
      expect(@user).to be_valid
    end

    ## == Name
    it "name max length (50)" do
      @user.name << 'a' * (51 - @user.name.length)
      expect(@user).not_to be_valid
    end

    it "name should be valid" do
      @user.name << '!'
      expect(@user).not_to be_valid
    end

    ## == Surname
    it "surname max length (50)" do
      @user.surname << 'a' * (51 - @user.surname.length)
      expect(@user).not_to be_valid
    end

    it "surname should be valid" do
      @user.surname << '!'
      expect(@user).not_to be_valid
    end

    ## == Username
    it "should have username" do
      @user.username = ''
      expect(@user).not_to be_valid
    end

    it "username should be unique" do
      create(:user, username: @user.username)
      expect(@user).not_to be_valid
    end

    it "username max length (20)" do
      @user.username << 'a' * (21 - @user.username.length)
      expect(@user).not_to be_valid
    end

    it "username should be valid" do
      @user.username << '.'
      expect(@user).not_to be_valid
    end

    ## == Email
    it "should have email" do
      @user.email = ''
      expect(@user).not_to be_valid
    end

    it "email should be unique" do
      create(:user, email: @user.email)
      expect(@user).not_to be_valid
    end

    it "email should be valid" do
      @user.email << '@'
      expect(@user).not_to be_valid
    end

    ## == Password
    it "should have password" do
      @user.password = ''
      expect(@user).not_to be_valid
    end

    it "should have confirmation" do
      @user.password_confirmation = ''
      expect(@user).not_to be_valid
    end

    it "password confirmation must match" do
      @user.password_confirmation = 'foobar6'
      expect(@user).not_to be_valid
    end

    it "password should have at least 6 char" do
      @user.password = 'abc'
      expect(@user).not_to be_valid
    end

    it "password should have at least 1 number" do
      @user.password = 'foobaryY'
      expect(@user).not_to be_valid
    end

    it "password should have at least 1 uppercase" do
      @user.password = 'foobar6y'
      expect(@user).not_to be_valid
    end

    it "password should have at least 1 lowercase" do
      @user.password = 'FOOBAR6Y'
      expect(@user).not_to be_valid
    end

    # == Avatar
    it "default avatar should be gravatar" do
      gravatar_id = Digest::MD5::hexdigest(@user.email).downcase

      expect(@user.avatar.url).to eq(gravatar_for(@user))
    end
  end

  describe "before save" do

    # == Username
    it "username is saved in lowercase" do
      @user.username = 'FooBarCiTo'
      expect{
        @user.save
      }.to change{@user.username}.from(@user.username).to(@user.username.downcase)
    end

    # == Email
    it "email is saved in lowercase" do
      @user.email = 'foObarCitO@exAmple.com'
      @user.username = 'FooBarCiTo'
      expect{
        @user.save
      }.to change{@user.email}.from(@user.email).to(@user.email.downcase)
    end
  end
end
