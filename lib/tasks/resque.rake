require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup => :environment do
    require 'resque'
    if ENV['REDIS_URL']
      uri = URI.parse(ENV['REDIS_URL'])
      Resque.redis = Redis.new(url: ENV['REDIS_URL'])
    else
      Resque.redis = 'localhost:6379'
    end
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'
    Resque::Scheduler.dynamic = true

    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
  end

  task :scheduler => :setup_schedule
end
