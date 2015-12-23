class CourseMetafilesController < ApplicationController

  def new
    @metafile = CourseMetafile.new
  end

  def create
    @metafile = CourseMetafile.new(course_metafile_params)
    if @metafile.save
      response.headers['Content-Type'] = "text/xml; charset=UTF-8"
      response.headers['Content-Disposition'] = "attachment; filename=metafile.xml"
      metaPath = create_xml @metafile
      send_file metaPath
    else
      logger.tagged("course_metafile_fatal") { logger.info "Failed to create Course metafile. Params: #{course_metafile_params}" }
      return render html: "#{ENV["ERROR_MESSAGE"]}"
    end
  end


  def create_xml(metafile)
    begin
      allTags = [metafile.audience_tags]
      allTags = allTags + metafile.tools_tags.split(",")
      allTags = allTags + metafile.certification_tags.split(",")
      allTags = allTags + metafile.topics_list.split(",")
      allTags = allTags.uniq
      downcaseAllTags = []
      allTags.each do |tag|
        downcaseAllTags.push tag.downcase.strip
      end
      allTags = downcaseAllTags.uniq

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.course('xmlns' => "http://pluralsight.com/sapphire/course/2007/11") {
          xml.title metafile.title
          xml.shortDescription metafile.short_description
          xml.description metafile.description
          xml.modules {
            metafile.module_count.times do |x|
              xml.module(:author => (metafile.author.gsub(/\s/, "-").downcase), :name => "#{metafile.course_id.strip.gsub(/\s/, "-").downcase}-m#{(x + 1)}")
            end
          }

          # topics/search keywords
          xml.topics{
            metafile.topics_tags.split(",").each do |topic|
              xml.topic topic.strip.downcase.gsub(/\s/,"-")
            end
          }
        if(metafile.topics_tags)
           xml.topicsTags{
             metafile.topics_list.split(",").each do |x|
               xml.topicTag x
             end
           }
        end
        # tags
        xml.tags{
          allTags.each do |target|
            xml.tag target
          end
        }

        # audience tags
        if(metafile.audience_tags)
          xml.audienceTags{
            xml.audienceTag metafile.audience_tags
          }
        else
          xml.audienceTags{
            xml.audienceTag "foo"
          }
        end
        # tools tags
        if(metafile.tools_tags)
          xml.toolsTags{
            metafile.tools_tags.split(",").each do |tool|
              xml.toolsTag tool.strip.downcase.gsub(/\s/,"-")
            end
          }
        else
          xml.toolsTags{
            xml.toolsTag "foo"
            }
        end
          # cert tags
        if(metafile.certification_tags)
          xml.certificationsTags{
            metafile.certification_tags.split(",").each do |tag|
              xml.certificationsTag tag
            end
          }
        end
      }
    end
    rescue => error
    logger.tagged("course_metafile_fatal") { logger.debug "Failed to create_xml four course meta. Params: #{metafile}. Error: #{error.inspect}" }
    end
    # create the file
  fileName = "#{metafile.course_id.strip.gsub(/\s/,"-").downcase}.meta"
  # make the folder
  system 'mkdir', '-p', ENV['METAFILE_PATH']
  full_meta_path = (ENV['METAFILE_PATH'] + "/" + fileName)
  begin
    x = File.new(full_meta_path, "w")
    x.write builder.to_xml
    x.close
    logger.tagged("course_metafile_success") {logger.info "Metafile saved. Full path: #{full_meta_path}"}
  rescue => error
    logger.tagged("course_metafile_fatal") {logger.info "Failed to save course metafile. Full path: #{full_meta_path}. Metafile: #{metafile}. Error: #{error.inspect}"}
  end
    return full_meta_path
  end

  private
  def course_metafile_params
    params.require(:course_metafile).permit(:title,
                                            :short_description,
                                            :description,
                                            :author,
                                            :module_count,
                                            :course_id,
                                            :topics_list,
                                            :tools_tags,
                                            :audience_tags,
                                            :topics_tags,
                                            :certification_tags)

  end
end

