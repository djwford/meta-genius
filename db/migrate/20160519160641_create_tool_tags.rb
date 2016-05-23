class CreateToolTags < ActiveRecord::Migration
  def change
    create_table :tool_tags do |t|
      t.timestamps null: false
    end
  end
end
