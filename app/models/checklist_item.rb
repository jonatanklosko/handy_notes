class ChecklistItem < ActiveRecord::Base
  belongs_to :checklist, touch: true
end
