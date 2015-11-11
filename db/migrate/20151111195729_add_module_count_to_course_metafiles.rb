class AddModuleCountToCourseMetafiles < ActiveRecord::Migration
  def change
    add_column :course_metafiles, :module_count, :integer
    add_column :course_metafiles, :topics_list, :text
  end
end
