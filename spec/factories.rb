# This will guess the User class
FactoryGirl.define do

  factory :user do
    name 'Anthony'
    surname  'Santos'
    username 'romeosantos'
    email 'theking@staysking.com'
    photo 'http://placehold.it/350x150'
    password 'foobar6Y'
    password_confirmation { password }
  end
end