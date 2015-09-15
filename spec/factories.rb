# This will guess the User class
FactoryGirl.define do

  factory :user do
    name 'Anthony'
    surname  'Santos'
    sequence(:username) { |n| "romeosantos#{n}" }
    sequence(:email) { |n| "theking#{n}@staysking.com" }
    password 'foobar6Y'
    password_confirmation { password }
    confirmed_at Time.now
  end
end