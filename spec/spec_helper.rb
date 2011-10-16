ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.include Mongoid::Matchers
  config.include Factory::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller

  Fog.mock!
end


