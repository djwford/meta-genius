class ModuleMetafilesController < ApplicationController

  def new
    begin
      @metafile = ModuleMetafile.new
      20.times do |x|
        @metafile.clips.build
      end
    rescue => error
      logger.tagged("module_metafile_fatal") {logger.debug "failed on ModuleMetafilesController::new. Error: #{error.inspect}"}
    end
  end

  def show
    @metafile = ModuleMetafile.find(params[:id])
  end

  def create
    @metafile = ModuleMetafile.new(module_metafile_params)
    @metafile.author = @metafile.author.strip.gsub(/\s/, "-").downcase
    if @metafile.save
      response.headers['Content-Type'] = "text/xml; charset=UTF-8"
      response.headers['Content-Disposition'] = 'attachment; filename=metafile.meta'
      metaPath = create_xml @metafile
      begin
        send_file metaPath
        logger.tagged("module_metafile_success") {logger.info "Created module meta. Params: #{module_metafile_params}"}
      rescue => error
        logger.tagged("module_metafile_fatal") {logger.debug "failed on ModuleMetafilesController::create. Error: #{error.inspect}"}
      end
    else
      logger.tagged("module_metafile_fatal") {logger.debug "failed to save on ModuleMetafilesController::create. Error: #{error.inspect}"}
      return render html: "#{ENV["ERROR_MESSAGE"]}"
    end
  end

  def create_xml(metafile)
    begin
      completeClips = []
      metafile.clips.each do |clip|
        if(clip.title.length > 0)
          completeClips.push clip
        end
      end
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.module('xmlns' => "http://pluralsight.com/sapphire/module/2007/11") {
          xml.author metafile.author.strip.gsub(/\s/, "-").downcase
          xml.title metafile.title.strip
          xml.description metafile.description
          xml.clips {
            completeClips.each do | clipObject |
              xml.clip(:href => clipObject.href, :title => clipObject.title)
            end
            }
        }
      end
    rescue => error
      logger.tagged("module_metafile_fatal") {logger.debug "Failed while creating XML. Metafile: #{metafile}. Error: #{error.inspect}"}
    end
    # create the file
    begin
      courseTitle = metafile.course_id.strip.gsub("\s","-").downcase
      fileName = "#{courseTitle}-m#{metafile.module_number}"
      system 'mkdir', '-p', ENV['METAFILE_PATH']
      puts "filename: #{fileName}"
      x = File.new("#{ENV["METAFILE_PATH"]}/#{fileName}.xml", "w")
      x.write builder.to_xml
      x.close
      return "#{ENV["METAFILE_PATH"]}/#{fileName}.xml"
    rescue => error
logger.tagged("module_metafile_fatal") {logger.debug "failed while saving XML.  Metafile: #{metafile}. Error: #{error.inspect}"}
    end
  end


  private
  def module_metafile_params
    params.require(:module_metafile).permit(:title, :course_title, :author, :module_number, :description, :course_id, clips_attributes: [:href, :title])
  end
end


