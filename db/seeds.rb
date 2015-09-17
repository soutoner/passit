#encoding: utf-8

User.destroy_all
User.new(
    name: 'Adrián',
    surname: 'González',
    username: 'soutoner',
    email: 'adrigonle@gmail.com',
    password: 'foobar6Y',
    password_confirmation: 'foobar6Y',
    confirmed_at: Time.now
).save

10.times do
  FactoryGirl.create(:user)
end