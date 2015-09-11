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

class User < ActiveRecord::Base

  before_save { |user| user.username = user.username.downcase }
  before_save { |user| user.email = user.email.downcase }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :validatable and :trackable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :recoverable,
         :authentication_keys => [:login]

  ## == ATTRIBUTES
  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  ## == PARAMETERS

  # Minimum password length
  @min_password_length = 6

  ## == Validations

  validates :name,
            length: { in: 1..50  },
            format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }
  validates :surname,
            length: { in: 1..50  },
            format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }
  validates :username,
            length: { in: 1..20 },
            presence: true,
            uniqueness: { :case_sensitive => false },
            format: { with: /\A[a-z\-_0-9]+\z/i }
  validates :email,
            presence: true,
            uniqueness: { :case_sensitive => false },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password,
            presence: true,
            confirmation: true,
            format: { with: /\A^(?=.*[A-Z])(?=.*[0-9]).{#{@min_password_length},}$\z/ }

  ## == GETTERS

  def self.min_password_length
    @min_password_length
  end

  def photo
    read_attribute(:photo) || 'http://placehold.it/300?text=' + read_attribute(:username)
  end

  ## == CUSTOM LOGIN

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["username = :value OR email = :value", { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end
end
