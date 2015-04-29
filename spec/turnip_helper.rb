require 'rails_helper'
require 'turnip/capybara'

Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }
