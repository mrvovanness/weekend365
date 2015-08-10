require 'resque'
uri = URI.parse(ENV['REDIS_URL'])
Resque.redis = Redis.new(url: ENV['REDIS_URL'])
