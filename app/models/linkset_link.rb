class LinksetLink < ActiveRecord::Base
  belongs_to :linkset, touch: true
end
