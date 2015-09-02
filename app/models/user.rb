class User < ActiveRecord::Base

  # == Validations
  validates :name, length: { in: 1..50  }, format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }
  validates :surname, length: { in: 1..50  }, format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }
  validates :username, length: { in: 1..20 }, presence: true, uniqueness: true,
            format: { with: /\A[a-z\-_0-9]+\z/i }
  validates :email, presence: true, uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
