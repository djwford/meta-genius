class CourseMetafile < ActiveRecord::Base
  has_many :suggested_tags
  accepts_nested_attributes_for :suggested_tags, :reject_if => proc {|x| x['name'].blank?}
  serialize :certification_tags
  serialize :tools_tags
  serialize :topics_tags
  serialize :topics_list
end
