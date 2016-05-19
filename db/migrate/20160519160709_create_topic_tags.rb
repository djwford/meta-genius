class CreateTopicTags < ActiveRecord::Migration
  def change
    create_table :topic_tags do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
