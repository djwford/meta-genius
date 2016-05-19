class TopicTag < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: true }  
end
