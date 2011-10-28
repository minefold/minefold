ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.include Mongoid::Matchers
  config.include Factory::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  
  config.before(:each) do
    DatabaseCleaner.start
    Stripe::Customer.stub(:create) { Struct.new(:id).new('stripe_id') }
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  Fog.mock!
end


