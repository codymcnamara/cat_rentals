class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :password, length: {minimum: 6}, allow_nil: true
  attr_reader :password #needed for validation because validation uses a getter method

  after_initialize :ensure_session_token

  has_many :cats
  has_many :cat_rental_requests

  def ensure_session_token
    @session_token ||= SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    @session_token = SecureRandom::urlsafe_base64(16)
    self.update_attributes(session_token: @session_token)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credientials(username, password)
    user = self.where(username: username) #takes hashes
    return nil unless user

    if user.is_password?(password)
      return user
    else
      errors[:base] << "user not found"
    end
  end

end
