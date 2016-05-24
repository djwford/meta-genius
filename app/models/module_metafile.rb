class ModuleMetafile < ActiveRecord::Base
  has_many :clips, dependent :destroy

  accepts_nested_attributes_for :clips

  validates :title, :description, :author, :course_title, :module_number,
  presence: true

  scope :old, lambda {
    yesterday = Time.now - 1.day
    where("created_at < ?", yesterday )
  }
end
