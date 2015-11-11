class ModuleMetafilesController < ApplicationController

  def new
    @metafile = ModuleMetafile.new
    20.times do |x|
      @metafile.clips.build
    end
  end

  def show
    @metafile = ModuleMetafile.find(params[:id])
  end

  def create
    @metafile = ModuleMetafile.new(module_metafile_params)
    @metafile.author = @metafile.author.gsub(/\s/, "-").downcase
    if @metafile.save
      response.headers['Content-Type'] = "text/xml; charset=UTF-8"
      response.headers['Content-Disposition'] = 'attachment; filename=metafile.xml'
      metaPath = create_xml @metafile
      send_file metaPath
    end
  end

  def create_xml(metafile)
    completeClips = []
    metafile.clips.each do |clip|
      if(clip.title.length > 0)
        completeClips.push clip
      end
    end
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.module('xmlns' => "http://pluralsight.com/sapphire/module/2007/11") {
        xml.author metafile.author
        xml.title metafile.title
        xml.description metafile.description
        xml.clips {
          completeClips.each do | clipObject |
            xml.clip(:href => clipObject.href, :title => clipObject.title)
          end
          }
      }
    end
    # create the file
    courseTitle = metafile.title.gsub("\s","-").downcase
    fileName = "#{courseTitle}-m#{metafile.module_number}"
    system 'mkdir', '-p', 'meta-genius/metafile_storage/'    
    puts "filename: #{fileName}"
    x = File.new("/home/nitrous/meta_genius/meta-genius/metafile_storage/#{fileName}.xml", "w")
    x.write builder.to_xml
    x.close
    return "metafile_storage/#{fileName}.xml"
  end


  private
  def module_metafile_params
    params.require(:module_metafile).permit(:title, :course_title, :author, :module_number, :description, clips_attributes: [:href, :title])
  end
end



# <module xmlns="http://pluralsight.com/sapphire/module/2007/11">
#   <author>daryl-moorhouse</author>
#   <title>Introduction and Project Overview</title>
#   <description>Introduction and Project Overview</description>
#   <clips>
#     <clip href="getting-started-2297-m1-1-hq.mp4" title="Introduction and Project Overview" />
#   </clips>
# </module>

