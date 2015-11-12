class AddCourseIdToModuleMeta < ActiveRecord::Migration
  def change
    add_column :module_metafiles, :course_id, :string
  end
end
