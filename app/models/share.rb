class Share < ActiveRecord::Base
  
  before_create :assign_token
  
  # Overridden in order to use a token in urls instead of id.
  def to_param
    self.token
  end
  
  private
  
    # Before actions
    
    # Assign the token
    def assign_token
      begin
        self.token = (1..6).map { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join
      end while Share.exists?(token: self.token)
    end
end
