class String

  def sanitize_input
    sanitized = self.strip
    curlies_and_straights = { '“' => '"',
                              '”' => '"',
                              '‘' => '\'',
                              '’' => '\'',
                              "&#x2018;" => '\'',
                              "&#x2019;" => '\'',
                              "&#x201C;" => '"',
                              "&#x201D;" => '"',
                              "&#x2013;" => "-",
                              "&#x2014;" => "-",
                              "&quot;" => '"'
                            }
    curlies_and_straights.each do |curly, straight|
      sanitized.gsub!(curly, straight)
    end
    return sanitized
  end

end
