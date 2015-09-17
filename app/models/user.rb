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

class User < ActiveRecord::Base
  include UsersHelper

  before_save { |user| user.username = user.username.downcase }
  before_save { |user| user.email = user.email.downcase }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :validatable and :trackable
  devise :database_authenticatable,
         :registerable,
         :confirmable,
         :rememberable,
         :recoverable,
         :authentication_keys => [:login]

  ## == ATTRIBUTES
  # Virtual attribute for authenticating by either username or email
  attr_accessor :login
  # Paperclip avatar
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "30x30>" }, default_url: :gravatar, :escape_url => false

  ## == PARAMETERS

  # Minimum password length and constraints
  @min_password_length = 6

  @password_constraints = {
      length: "Must be at least #{@min_password_length} character long.",
      contain: [
          'one number',
          'one lowercase letter',
          'one uppercase letter.'
      ]
  }

  ## == Validations

  # Save
  validates :name,
            length: { maximum: 50  },
            format: { with: /\A[^0-9`!@#\$%\^&*+_=]*\z/ }
  validates :surname,
            length: { maximum: 50  },
            format: { with: /\A[^0-9`!@#\$%\^&*+_=]*\z/ }
  validates :username,
            length: { in: 1..20 },
            presence: true,
            uniqueness: { :case_sensitive => false },
            format: { with: /\A[a-z\-_0-9]+\z/i }
  validates :email,
            presence: true,
            uniqueness: { :case_sensitive => false },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_attachment :avatar,
                       content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] },
                       size: { less_than: 50.kilobytes },
                       :unless => Proc.new {|m| m[:avatar].nil?}

  # Create
  validates :password,
            presence: true,
            confirmation: true,
            format: { with: /\A^(?=.*[A-Z])(?=.*[0-9]).{#{@min_password_length},}$\z/ }, on: :create

  # Update
  validates :password,
            presence: true,
            confirmation: true,
            format: { with: /\A^(?=.*[A-Z])(?=.*[0-9]).{#{@min_password_length},}$\z/ }, on: :update, allow_blank: true

  ## == GETTERS

  def self.min_password_length
    @min_password_length
  end

  def gravatar
    gravatar_for(self)
  end

  def self.password_constraints
    *others, second_last, last = @password_constraints[:contain]
    second_last << " and #{last}" unless last.nil?
    "#{@password_constraints[:length]} Must contain: #{(others << second_last).join(', ')}"
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
