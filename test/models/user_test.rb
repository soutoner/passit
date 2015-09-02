require 'test_helper'

# TODO: write intensive test for regex validations

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  # == Name
  test "name max length (50)" do
    @user.name << 'a' * (51 - @user.username.length)
    assert_not @user.valid?
  end

  test "name should be valid" do
    @user.name << '!'
    assert_not @user.valid?
  end

  # == Surname
  test "surname max length (50)" do
    @user.surname << 'a' * (51 - @user.username.length)
    assert_not @user.valid?
  end

  test "surname should be valid" do
    @user.surname << '!'
    assert_not @user.valid?
  end

  # == Username
  test "should have username" do
    @user.username = ''
    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.username = users(:two)
    assert_not @user.valid?
  end

  test "username max length (20)" do
    @user.username << 'a' * (21 - @user.username.length)
    assert_not @user.valid?
  end

  test "username should be valid" do
    @user.username << '.'
    assert_not @user.valid?
  end

  # == Email
  test "should have email" do
    assert @user.valid?
  end

  test "email should be unique" do
    @user.email = users(:two)
    assert_not @user.valid?
  end

  test "email should be valid" do
    @user.email << '@'
    assert_not @user.valid?
  end

end
