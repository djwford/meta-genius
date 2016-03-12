class TagsController < ApplicationController

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tags_params)
    if @tag.save
      response.headers['Content-Type'] = "text/xml; charset=UTF-8"
      response.headers['Content-Disposition'] = "attachment; filename=metafile.xml"
      metaPath = create_xml @tag
      send_file metaPath
    else
      logger.tagged("tags_fatal") { logger.info "Failed to create tags. Params: #{tags_params}" }
      return render html: "#{ENV["ERROR_MESSAGE"]}"
    end
  end


  def create_xml(tags)
    begin
      allTags = [tags.audience_tags]
      allTags = allTags + tags.tools_tags.split(",")
      allTags = allTags + tags.certification_tags.split(",")
      allTags = allTags + tags.topics_list.split(",")
      allTags = allTags.uniq
      downcaseAllTags = []
      allTags.each do |tag|
        downcaseAllTags.push tag.downcase.strip
      end
      allTags = downcaseAllTags.uniq

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.course('xmlns' => "http://pluralsight.com/sapphire/course/2007/11") {
        # topics
        if(!(tags.topics_tags == ""))
          xml.topics{
            tags.topics_tags.split(",").each do |topic|
              xml.topic topic.strip.downcase.gsub(/\s/,"-")
            end
          }
        else
          xml.topics{
            xml.topic nil
          }
        end
        xml.category nil
        # tags
        if(!(allTags.empty?))
          xml.tags{
            allTags.each do |target|
              xml.tag target
            end
          }
        else
          xml.tags{
            xml.tag nil
          }
        end
         # audience tags
        if(tags.audience_tags)
          xml.audienceTags{
            xml.audienceTag tags.audience_tags
          }
        else
          xml.audienceTags{
            xml.audienceTag nil
          }
        end
        # tools tags

        if(!(tags.tools_tags == ""))
          puts "true"
          xml.toolsTags{
            tags.tools_tags.split(",").each do |tool|
              xml.toolsTag tool.strip.downcase.gsub(/\s/,"-")
            end
          }
        else
          xml.toolsTags{
            xml.toolsTag nil
          }
        end

        if(!(tags.topics_list == ""))
           xml.topicTags{
             tags.topics_list.split(",").each do |x|
               xml.topicTag x.strip
             end
           }
        else
           xml.topicTags{
            xml.topicTag nil
           }
        end
          # cert tags
        if(!(tags.certification_tags == ""))
          xml.certificationsTags{
            tags.certification_tags.split(",").each do |tag|
              xml.certificationsTag tag
            end
          }
        else
          xml.certificationsTags{
            xml.certificationsTag nil
          }
        end
      }
    end
    rescue => error
    logger.tagged("tags_metafile_fatal") { logger.debug "Failed to create_xml four course meta. Params: #{tags}. Error: #{error.inspect}" }
    end
    # create the file
  fileName = "#{tags.courseId.strip.gsub(/\s/,"-").downcase}_tags.xml"
  # make the folder
  system 'mkdir', '-p', ENV['METAFILE_PATH']
  full_meta_path = (ENV['METAFILE_PATH'] + "/" + fileName)
  begin
    x = File.new(full_meta_path, "w")
    x.write builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS | Nokogiri::XML::Node::SaveOptions::FORMAT)
    x.close
    logger.tagged("tags_metafile_success") {logger.info "Metafile saved. Full path: #{full_meta_path}"}
  rescue => error
    logger.tagged("tags_metafile_fatal") {logger.info "Failed to save course metafile. Full path: #{full_meta_path}. Metafile: #{tags}. Error: #{error.inspect}"}
  end
    return full_meta_path
  end

  private
  def tags_params
    params.require(:tag).permit(:courseId,
                                :topics_tags,
                                :tools_tags,
                                :audience_tags,
                                :topics_tags,
                                :certification_tags,
                                :topics_list)

  end
end
