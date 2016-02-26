class AddIndicesToUsersUsernameAndEmail < ActiveRecord::Migration
  def change
    change_column :users, :username, :citext
    change_column :users, :email, :citext
    
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
