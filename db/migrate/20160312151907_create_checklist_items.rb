class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.references :checklist, index: true, foreign_key: true
      t.string :description
      t.boolean :checked, default: false
      
      t.timestamps null: false
    end
  end
end
