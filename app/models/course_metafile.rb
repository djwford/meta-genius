class CourseMetafile < ActiveRecord::Base
  has_many :course_modules
  accepts_nested_attributes_for :course_modules, :topic
  has_one :topic
end
