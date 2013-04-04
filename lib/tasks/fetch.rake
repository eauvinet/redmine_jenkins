desc 'Fetch buildresults from the Jenkins'

namespace :redmine_jenkins do
  task :fetch => :environment do
    Jenkins.fetch
  end
end
