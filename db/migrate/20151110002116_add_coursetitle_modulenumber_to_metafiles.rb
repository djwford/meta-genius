class AddCoursetitleModulenumberToMetafiles < ActiveRecord::Migration
  def change
    add_column :metafiles, :course_title, :string
    add_column :metafiles, :module_number, :integer
  end
end
