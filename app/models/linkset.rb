class Linkset < ActiveRecord::Base
  include UserDocument
  
  has_many :links, -> { order :created_at }, class_name: "LinksetLink",
                 dependent: :destroy
end
