class AddTokenToShares < ActiveRecord::Migration
  def change
    add_column :shares, :token, :string
    
    add_index :shares, :token, unique: true
  end
end
