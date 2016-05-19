class ToolTag < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: true }
  
  scope :has_tag, lambda { |query|
    return nil if query.blank?
    # condition query, parse into individual keywords

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = query.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    puts terms.inspect
    where(
      terms.map { |term|
        "(tool_tags.name LIKE '#{term}')"
      }.join(' OR ')
    )
  }  
end
