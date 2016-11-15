ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../dummy/config/environment", __FILE__)
require "rspec/rails"
require "shoulda-matchers"

Dir[Rails.root.join("..", "support", "**", "*.rb")].each &method(:require)

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
end
