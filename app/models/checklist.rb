class Checklist < ActiveRecord::Base
  include UserDocument
  
  has_many :items, -> { order :created_at }, class_name: "ChecklistItem",
                   dependent: :destroy
end
