class AddModuleCountToCourseMetafiles < ActiveRecord::Migration
  def change
    add_column :course_metafiles, :module_count, :integer
  end
end
