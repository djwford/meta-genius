class CourseMetafilesController < ApplicationController

  def new
    @metafile = CourseMetafile.new
  end

  def create
    @metafile = CourseMetafile.new(course_metafile_params)

    if @metafile.save
      response.headers['Content-Type'] = "text/xml; charset=UTF-8"
      response.headers['Content-Disposition'] = "attachment; filename=#{@metafile.title}.meta"
      metaPath = create_xml @metafile
      send_file metaPath
    end
  end


  def create_xml(metafile)

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.course('xmlns' => "http://pluralsight.com/sapphire/course/2007/11") {
        xml.title metafile.title.gsub(/\s/, "-").downcase
        xml.shortDescription metafile.short_description
        xml.description metafile.description
        xml.modules {
          metafile.module_count.times do |x|
            xml.module(:author => (metafile.author.gsub(/\s/, "-").downcase), :name => "#{metafile.title}-m#{(x + 1)}")
          end
        }
        xml.topics{
          metafile.topics_list.split(",").each do |topic|
            xml.topic topic
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
    # create the file
    fileName = "#{metafile.title}.meta"
    puts "filename: #{fileName}"
    # make the folder
  logger.debug "trying to make folder"

    system 'mkdir', '-p', ENV['METAFILE_PATH']
  full_meta_path = "#{ENV['METAFILE_PATH'] + fileName}.meta"
  x = File.new(full_meta_path, "w")
    x.write builder.to_xml
    x.close
    rescue
  logger.debug "caught an error"
    return full_meta_path
  end

  private
  def course_metafile_params
    params.require(:course_metafile).permit(:title,
                                            :short_description,
                                            :description,
                                            :author,
                                            :module_count,
                                            :topics_list)

  end
end

