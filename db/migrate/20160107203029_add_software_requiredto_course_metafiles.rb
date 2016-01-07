class AddSoftwareRequiredtoCourseMetafiles < ActiveRecord::Migration
  def change
    add_column :course_metafiles, :software_required, :string
  end
end
