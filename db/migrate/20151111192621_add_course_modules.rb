class AddCourseModules < ActiveRecord::Migration
  def change
    create_table :course_modules do |t|
      t.string :author
      t.string :name
      t.integer :course_metafile_id
      t.timestamps null: false
    end
  end
end
