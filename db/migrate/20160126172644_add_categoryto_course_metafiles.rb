class AddCategorytoCourseMetafiles < ActiveRecord::Migration
  def change
    add_column :course_metafiles, :category, :string
  end
end
