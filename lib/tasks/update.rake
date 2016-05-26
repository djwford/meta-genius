namespace :tags do
  desc "Updates DB with tags from pluralsight API"
  task update: :environment do
    require 'pluralsight_api/adapter'
    Pluralsight_Api::Adapter.update
  end
end
