# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string(255)
#  email           :string(255)
#

class User < ActiveRecord::Base

  validates :user_name, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 8, allow_nil: true }

  after_initialize :require_session_token

  attr_reader :password

  has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat

  has_many :cat_requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def require_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    passobj = BCrypt::Password.new(self.password_digest)
    passobj.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

end
