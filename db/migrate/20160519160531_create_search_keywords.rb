class CreateSearchKeywords < ActiveRecord::Migration
  def change
    create_table :search_keywords do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
