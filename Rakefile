require File.join(File.dirname(__FILE__), 'lib/jess.rb')
require 'platform-api'

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new

  task :default => [:cucumber]
end

namespace :jess do
  task :set_sha do
    heroku = ::PlatformAPI.connect_oauth(ENV['HEROKU_TOKEN'])
    slug_id = heroku.release.list('oa-jess').last["slug"]["id"]
    current_sha = heroku.slug.info('oa-jess', slug_id)["commit"]
    heroku.config_var.update('oa-jess', {"CURRENT_SHA" => current_sha})
  end
end
