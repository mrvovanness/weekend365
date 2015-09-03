Rails.application.configure do
  config.action_controller.asset_host = 'http://185.22.62.34:4057'
  config.action_mailer.default_url_options = { host: 'http://185.22.62.34:4057' }
  config.action_mailer.default_options = { from: 'development@weekend365.com' }
  config.action_mailer.smtp_settings = {
    address: ENV['smtp_address'],
    port: ENV['smtp_port'],
    user_name: ENV['smtp_username'],
    password: ENV['smtp_password']
  }
  config.action_mailer.asset_host = config.action_controller.asset_host
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
end
