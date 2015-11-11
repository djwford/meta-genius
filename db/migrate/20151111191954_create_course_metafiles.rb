class CreateCourseMetafiles < ActiveRecord::Migration
  def change
    create_table :course_metafiles do |t|
      t.string :title
      t.text :short_description
      t.text :description
      t.string :author
      t.timestamps null: false
    end
  end
end
