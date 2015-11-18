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
          xml.topics{
            metafile.topics_list.split(",").each do |topic|
              xml.topic topic.strip.downcase.gsub(/\s/,"-")
            end
          }
          xml.tags{
            xml.tag "foo"
          }
          xml.audienceTags{
            xml.audienceTag "foo"
          }
          xml.toolsTags{
            xml.toolsTag "foo"
          }
          xml.topicTags{
            xml.topicTag "foo"
          }
          xml.certificationsTags{
            xml.certificationsTag "foo"
          }
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
                                            :topics_list)

  end
end

