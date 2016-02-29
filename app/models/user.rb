class User < ActiveRecord::Base
  
  # Validations
  validates :username, presence: true, format: { with: /\A[\w\-]+\z/i },
                       length: { in: 6..20 }, uniqueness: { case_sensitive: false }
                       
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i },
                    uniqueness: { case_sensitive: false }
                    
  has_secure_password
  
  validates :password, presence: true, allow_nil: true, length: { minimum: 6 }
  
  # Methods
  
  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                  : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
