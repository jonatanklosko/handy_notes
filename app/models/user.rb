class User < ActiveRecord::Base
  attr_accessor :activation_token, :remember_token
  
  # Validations
  
  validates :username, presence: true, format: { with: /\A[\w\-]+\z/i },
                       length: { in: 6..20 }, uniqueness: { case_sensitive: false }
                       
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i },
                    uniqueness: { case_sensitive: false }
                    
  has_secure_password
  
  validates :password, presence: true, allow_nil: true, length: { minimum: 6 }
  
  # Before filters
  
  before_create :create_activation_token
  
  # Methods
  
  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                  : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a new token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Returns true if the user is activated.
  def activated?
    !self.activated_at.nil?
  end
  
  # Sends an email to the user with account activation link.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Activates the user.
  def activate
    update_attribute :activated_at, Time.now
  end
  
  # Returns true if the given token meets the digest in database.
  def correct_token?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Sets a new value for remember token and corresponding digest in database.
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(self.remember_token)
  end
  
  # Sets remembet digest in database to nil.
  def forget
    update_attribute :remember_digest, nil
  end
  
  private
  
    # Before filters implementations
    
    def create_activation_token
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end
end
