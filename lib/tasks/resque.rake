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
    require 'resque_scheduler'
    Resque::Scheduler.dynamic = true
  end

  task :scheduler => :setup_schedule
  task 'jobs:work' => 'resque:work'
end
