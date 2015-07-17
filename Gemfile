source 'https://rails-assets.org'
source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'activeadmin', github: 'activeadmin'
gem 'rolify'
gem 'responders'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :default do
  gem 'active_decorator'
  gem 'devise'
  gem 'ffaker'
  gem 'newrelic_rpm'
  gem 'simple_form'
  gem 'country_select'
  gem 'slim-rails'
  gem 'rails-assets-bootstrap-sass-official'
  gem 'rails-assets-fontawesome'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'html2slim'
  gem 'meta_request'
end

group :development, :test do
  gem 'awesome_print', require: 'ap'
  gem 'factory_girl_rails'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'sqlite3'
  gem 'turnip'
end

group :test do
  gem 'capybara'
  gem 'database_rewinder'
  gem 'webmock'
  gem 'vcr'
end

group :production do
  gem 'pg'
  gem 'rollbar'
  gem 'rails_12factor'
end
