ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'turn/autorun'

Turn.config.ansi = true
Turn.config.trace = 3

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end
