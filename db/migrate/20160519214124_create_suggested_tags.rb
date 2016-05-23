class CreateSuggestedTags < ActiveRecord::Migration
  def change
    create_table :suggested_tags do |t|
      t.string :tag_type
      t.integer :course_metafile_id
      t.string :description
      t.string :name
      t.timestamps null: false
    end
  end
end
