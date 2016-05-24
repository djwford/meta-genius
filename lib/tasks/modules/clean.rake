namespace :modules do
  desc 'Clears all ModuleMetafile created before today'
  task :clean :environment do
    ModuleMetafile.old.each {|x| x.destroy}
  end
end