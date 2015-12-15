class AddFacetedTagstoCourseMetafiles < ActiveRecord::Migration
  def change
    add_column :course_metafiles, :audience_tags, :text
    add_column :course_metafiles, :topics_tags, :text
    add_column :course_metafiles, :tools_tags, :text
    add_column :course_metafiles, :certification_tags, :text
  end
end
