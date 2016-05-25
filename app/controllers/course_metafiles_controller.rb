class CourseMetafilesController < ApplicationController
  require 'json'
  helper CourseMetafilesHelper

  def new
    @metafile = CourseMetafile.new
    @topics = TopicTag.all.order("name asc").map {|x| x.name}
    @tools = ToolTag.all.order("name asc").map {|x| x.name}
    @certifications = CertificationTag.all.order("name asc").map {|x| x.name}
    30.times { @metafile.suggested_tags.build }
  end

  def create
    @metafile = CourseMetafile.new(course_metafile_params)

    puts "tools tags! \n"
    puts course_metafile_params.inspect
    @metafile.topics_list = params['course_metafile']['topics_list']
    @metafile.tools_tags = params['course_metafile']['tools_tags']
    @metafile.certification_tags = params['course_metafile']['certification_tags']
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
    puts "params: \n"
    puts metafile.inspect
    begin
      allTags = [metafile.audience_tags] + metafile.tools_tags + metafile.certification_tags
      metafile.topics_tags.split(',').each {|y| allTags << y }
      allTags.uniq!

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.course('xmlns' => "http://pluralsight.com/sapphire/course/2007/11") {
          xml.comment metafile.software_required
          xml.title metafile.title
          xml.shortDescription metafile.short_description
          xml.description metafile.description
          xml.modules {
            metafile.module_count.times do |x|
              xml.module(:author => (metafile.author.gsub(/\s/, "-").downcase),
                :name => "#{metafile.course_id.strip.gsub(/\s/, "-").downcase}-m#{(x + 1)}")
            end
          }
        # topics
        if(metafile.topics_tags.length > 1)
          xml.topics{
            metafile.topics_tags.split(',').each do |topic|
              xml.topic topic.strip.downcase.gsub(/\s/,"-")
            end
          }
        else
          xml.topics{
            xml.topic "_"
          }
        end
        xml.category " "
        if(allTags and !(allTags.empty?))
          xml.tags{
            allTags.each do |target|
              unless target.blank? then xml.tag target end
            end
          }
        else
          xml.tags{
            xml.tag "_"
          }
        end
         # audience tags
        if(metafile.audience_tags)
          xml.audienceTags{
            xml.audienceTag metafile.audience_tags
          }
        else
          xml.audienceTags{
            xml.audienceTag "_"
          }
        end
        # tools tags
        if(metafile.tools_tags.length > 1)
          xml.toolsTags{
            metafile.tools_tags.each do |tool|
              unless tool.blank?
                xml.toolsTag tool.strip.downcase.gsub(/\s/,"-")
              end
            end
          }
        else
          xml.toolsTags{
            xml.toolsTag "_"
          }
        end
        if(metafile.topics_list.length > 1)
          puts "yup!\n"
          topics = metafile.topics_list.reject {|x| x.empty?}
          xml.topicTags{
             topics.each do |x|
               xml.topicTag x.strip
             end
           }
        else
           xml.topicTags{
            xml.topicTag "_"
           }
        end
          # cert tags
        if(metafile.certification_tags.length > 1)
          xml.certificationsTags{
            metafile.certification_tags.each do |tag|
              unless tag.blank?
                xml.certificationsTag tag
              end
            end
          }
        else
          xml.certificationsTags{
            xml.certificationsTag "_"
          }
        end
        # process suggested_tags, add as notes
        if metafile.suggested_tags
          metafile.suggested_tags.each do |tag|
            xml.comment "suggested #{tag.tag_type}: '#{tag.name}' | \"#{tag.description}\""
          end
        end
      }
    end
    rescue => error
    logger.tagged("course_metafile_fatal") { logger.debug "Failed to create_xml for course meta. Params: #{metafile}. Error: #{error.inspect}, #{error.backtrace}" }
    end
    # create the file
    fileName = "#{metafile.course_id.strip.gsub(/\s/,"-").downcase}.meta"
    # make the folder
    system 'mkdir', '-p', ENV['METAFILE_PATH']
    full_meta_path = (ENV['METAFILE_PATH'] + "/" + fileName)
    begin
      x = File.new(full_meta_path, "w")
      x.write builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::FORMAT)
      x.close
      logger.tagged("course_metafile_success") {logger.info "Metafile saved. Full path: #{full_meta_path}"}
    rescue => error
      logger.tagged("course_metafile_fatal") {
        logger.info "Failed to save course metafile. "\
          "Full path: #{full_meta_path}. Metafile: #{metafile}. Error: #{error.inspect}"}
    end
    return full_meta_path
  end

  private
  def course_metafile_params
    params.require(:course_metafile).permit(:title,
                                            :software_required,
                                            :short_description,
                                            :description,
                                            :author,
                                            :module_count,
                                            :course_id,
                                            :audience_tags,
                                            :topics_tags,
                                            :category,
                                            :suggested_tag,
                                            suggested_tags_attributes: [:name, :description, :tag_type])

  end
end
