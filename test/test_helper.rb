ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('../blueprints', __FILE__)

Turn.config.ansi = ENV['ansi'] || true
Turn.config.format = ENV['rpt'] || 'pretty'
Turn.config.trace = ENV['backtrace'] || 5

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit
  fixtures :all

  def self.pending(name, msg='not implemented')
    test(name) { skip(msg) }
  end

end

class ActionController::TestCase
  include Devise::TestHelpers

  def self.setup_devise_mapping(scope)
    setup do
      @request.env["devise.mapping"] = Devise.mappings[scope]
    end
  end

  def assert_unauthenticated_response
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  def assert_unauthorized_response
    assert_response :unauthorized
  end

end
