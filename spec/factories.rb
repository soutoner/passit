# This will guess the User class
FactoryGirl.define do
  factory :user do
    name Faker::Name.first_name
    surname  Faker::Name.last_name
    sequence(:username) { |n| "#{Faker::Internet.user_name(nil, %w(_ -))[0..(User.max_username_length-1)]}#{n}"  }
    email { "#{username}@example.com" }
    password 'foobar6Y'
    password_confirmation { password }
    confirmed_at Time.now
  end
end