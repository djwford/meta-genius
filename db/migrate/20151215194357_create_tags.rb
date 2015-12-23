class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.text :audience_tags
      t.text :topics_tags
      t.text :tools_tags
      t.text :certification_tags
      t.string :courseId
      t.timestamps null: false
    end
  end
end
