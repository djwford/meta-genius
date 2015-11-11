class ModuleMetafile < ActiveRecord::Base
  has_many :clips
  accepts_nested_attributes_for :clips

  validates :title, :description, :author, :course_title, :module_number,
  presence: true

end
