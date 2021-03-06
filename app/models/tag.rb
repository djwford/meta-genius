class Tag < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: true }

  scope :has_tag, lambda { |query|
    return nil if query.blank?
    # condition query, parse into individual keywords

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = query.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.

    where(
      terms.map { |term|
        "(LOWER(tags.name) LIKE '#{term}')"
      }.join(' OR ')
    )
  }
end
