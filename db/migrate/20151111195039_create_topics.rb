class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :course_metafile_id
      t.text :topics_list
      t.timestamps null: false
    end
  end
end
