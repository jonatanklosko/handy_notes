class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :slug

      t.timestamps null: false
    end
    
    add_index :checklists, [:slug, :user_id], unique: true
  end
end
