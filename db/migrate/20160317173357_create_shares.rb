class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :destination_path

      t.timestamps null: false
    end
    
    add_index :shares, :destination_path, unique: true
  end
end
