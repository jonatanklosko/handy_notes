class CreateLinksetLinks < ActiveRecord::Migration
  def change
    create_table :linkset_links do |t|
      t.references :linkset, index: true, foreign_key: true
      t.string :name
      t.string :url
      t.string :description

      t.timestamps null: false
    end
  end
end
