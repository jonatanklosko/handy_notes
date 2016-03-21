require 'rails_helper'

RSpec.describe LinksetsController, type: :controller do
  it_behaves_like "UserDocumentsController", Linkset, :linkset
end
