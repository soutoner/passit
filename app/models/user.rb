# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(50)
#  surname                :string(50)
#  username               :string(20)       not null
#  email                  :string(255)      not null
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

  ## == RELATIONSHIPS
  has_and_belongs_to_many :followers, class_name: 'User', join_table: 'user_follows', foreign_key: 'user_id',
                          association_foreign_key: 'follower_id'
  has_and_belongs_to_many :following, class_name: 'User', join_table: 'user_follows', foreign_key: 'follower_id',
                          association_foreign_key: 'user_id'

  ## == BEFORE SAVE

  before_save { |user| user.username = user.username.downcase }
  before_save { |user| user.email = user.email.downcase }

  ## == DEVISE

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

  class << self; attr_reader :max_name_length, :max_surname_length, :max_username_length, :min_password_length,
                :max_avatar_size end

  @max_name_length = 50
  @max_surname_length = 50
  @max_username_length = 20
  @min_password_length = 6
  @max_avatar_size = 50 # in kilobytes

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
            length: { maximum: @max_name_length  },
            format: { with: /\A[^0-9`!@#\$%\^&*+_=]*\z/ }
  validates :surname,
            length: { maximum: @max_surname_length   },
            format: { with: /\A[^0-9`!@#\$%\^&*+_=]*\z/ }
  validates :username,
            length: { in: 1..@max_username_length  },
            presence: true,
            uniqueness: { :case_sensitive => false },
            format: { with: /\A[a-z\-_0-9]+\z/i }
  validates :email,
            presence: true,
            uniqueness: { :case_sensitive => false },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_attachment :avatar,
                       content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] },
                       size: { less_than: @max_avatar_size.kilobytes },
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

  def to_param
    username
  end

  def gravatar
    gravatar_for(self)
  end

  def self.password_constraints
    *others, second_last, last = @password_constraints[:contain]
    second_last << " and #{last}" unless last.nil?
    "#{@password_constraints[:length]} Must contain: #{(others << second_last).join(', ')}"
  end

  ## == METHODS

  def follow(other_user)
    other_user = User.find(other_user) if !other_user.respond_to?(:id)
    following << other_user
  end

  # Unfollows an user
  def unfollow(other_user)
    other_user = User.find(other_user) if !other_user.respond_to?(:id)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    other_user = User.find(other_user) if !other_user.respond_to?(:id)
    following.include?(other_user)
  end

  # Returns true if the current user is followed by other user.
  def followed?(other_user)
    other_user = User.find(other_user) if !other_user.respond_to?(:id)
    followers.include?(other_user)
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
