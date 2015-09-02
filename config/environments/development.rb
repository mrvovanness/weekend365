Rails.application.configure do

  # Add Rack::LiveReload to the bottom of the middleware stack with the default options.
  config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_controller.asset_host = 'http://localhost:3000'

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.default_options = { from: 'development@mail.com', to: 'ex@mail.com' }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.asset_host = config.action_controller.asset_host

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
  config.assets.digest = false
  config.assets.compile = true
  config.assets.raise_runtime_errors = true
end
