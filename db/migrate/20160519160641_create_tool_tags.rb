class CreateToolTags < ActiveRecord::Migration
  def change
    create_table :tool_tags do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
