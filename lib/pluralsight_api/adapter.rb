module Pluralsight_Api
  require 'net/http'

  COURSES_URI = URI('https://authortools-api.pluralsight.com/public/v1/courses')

  TAG_TYPES = {
    "audienceTags" => "audience_tags",
    "toolsTags" => "tool_tags",
    "certificationTags" => "certification_tags",
    "searchKeywords" => "search_keywords",
    "topicTags" => "topic_tags",
    "tags" => "tags"
  }
  
  class Adapter
    def self.update
      results = fetch_courses
      length = results.count
      results.each_with_index do |course_hash,index|
        
        TAG_TYPES.each do |api_name, local_name|
          course_hash[api_name].each do |new_tag|
          
            const = local_name.capitalize.gsub("_","").gsub(/tags\Z/,"Tag").gsub("Tags","Tag").gsub("keywords","Keyword").constantize
            if api_name != 'searchKeywords'
              const.find_or_create_by name: new_tag['name']
            else
              const.find_or_create_by name: new_tag
            end
          end
        end
        
        
      end
     # RemoteUpdateLog.create
    end

    # polls COURSES_URI, returns JSON response
    def self.fetch_courses
      response = Net::HTTP.get(COURSES_URI)
      JSON.load response
    end
  end
end
