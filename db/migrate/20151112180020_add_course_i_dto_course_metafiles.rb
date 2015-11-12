class AddCourseIDtoCourseMetafiles < ActiveRecord::Migration
  def change
    add_column :course_metafiles, :course_id, :string
  end
end
