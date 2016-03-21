require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  it_behaves_like "UserDocumentsController", Note, :note
end
