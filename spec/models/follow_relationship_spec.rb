require 'rails_helper'
require 'support/factory_girl'

RSpec.describe 'Follow relationship' do

  before :all do
    @user = create(:user)
    @follower = create(:user)
  end

  after :all do
    @user.destroy
    @follower.destroy
  end

  describe "must work with user or ids" do
    it "follower follows user" do
      expect{
        @follower.follow(@user)
      }.to change{@user.followers.count}.from(0).to(1) &
               change{@follower.following.count}.from(0).to(1)

      expect(@follower.following?(@user)).to be(true)
      expect(@user.followed?(@follower)).to be(true)
    end

    it "follower follows user with id" do
      expect{
        @follower.follow(@user.id)
      }.to change{@user.followers.count}.from(0).to(1) &
               change{@follower.following.count}.from(0).to(1)

      expect(@follower.following?(@user.id)).to be(true)
      expect(@user.followed?(@follower.id)).to be(true)
    end

    it "follower unfollows user" do
      @follower.follow(@user)

      expect{
        @follower.unfollow(@user)
      }.to change{@user.followers.count}.from(1).to(0) &
               change{@follower.following.count}.from(1).to(0)

      expect(@follower.following?(@user)).to be(false)
      expect(@user.followed?(@follower)).to be(false)
    end

    it "follower unfollows user with id" do
      @follower.follow(@user.id)

      expect{
        @follower.unfollow(@user.id)
      }.to change{@user.followers.count}.from(1).to(0) &
               change{@follower.following.count}.from(1).to(0)

      expect(@follower.following?(@user.id)).to be(false)
      expect(@user.followed?(@follower.id)).to be(false)
    end
  end

  it "no follow relationship" do
    expect(@follower.following?(@user)).to be(false)
    expect(@follower.followed?(@user)).to be(false)
    expect(@user.followed?(@follower)).to be(false)
    expect(@user.following?(@follower)).to be(false)
  end
end
