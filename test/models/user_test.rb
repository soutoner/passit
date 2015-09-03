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
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#

require 'test_helper'

# TODO: write intensive test for regex validations

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @user.password = 'foobar6Y'
    @user.password_confirmation = 'foobar6Y'
  end

  test "should be valid" do
    assert @user.valid?, @user.errors.full_messages.inspect
  end

  ## == Name
  test "name max length (50)" do
    @user.name << 'a' * (51 - @user.username.length)
    assert_not @user.valid?
  end

  test "name should be valid" do
    @user.name << '!'
    assert_not @user.valid?
  end

  ## == Surname
  test "surname max length (50)" do
    @user.surname << 'a' * (51 - @user.username.length)
    assert_not @user.valid?
  end

  test "surname should be valid" do
    @user.surname << '!'
    assert_not @user.valid?
  end

  ## == Username
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

  ## == Email
  test "should have email" do
    @user.email = ''
    assert_not @user.valid?
  end

  test "email should be unique" do
    @user.email = users(:two)
    assert_not @user.valid?
  end

  test "email should be valid" do
    @user.email << '@'
    assert_not @user.valid?
  end

  ## == Password
  test "should have password" do
    @user.password = ''
    assert_not @user.valid?
  end

  test "should have confirmation" do
    @user.password_confirmation = ''
    assert_not @user.valid?
  end

  test "password confirmation must match" do
    @user.password_confirmation = 'foobar6'
    assert_not @user.valid?
  end

  test "password should have at least 6 char" do
    @user.password = 'abc'
    assert_not @user.valid?
  end

  test "password should have at least 1 number" do
    @user.password = 'foobaryY'
    assert_not @user.valid?
  end

  test "password should have at least 1 uppercase" do
    @user.password = 'foobar6y'
    assert_not @user.valid?
  end

  test "password should have at least 1 lowercase" do
    @user.password = 'FOOBAR6Y'
    assert_not @user.valid?
  end

end
