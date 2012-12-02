ENV["RAILS_ENV"] = "test"
require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Jobs', 'app/jobs'
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('../blueprints', __FILE__)

Turn.config.ansi = ENV['ansi'] || true
Turn.config.format = ENV['rpt'] || 'pretty'
# Turn.config.trace = ENV['backtrace'] || 5

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
    # This is so hacky but there doesn't seem to be a cleaner way.
    assert @request.env['action_controller.instance'].is_a?(Devise::FailureApp),
      "Unauthenticated #{@request.method} #{@request.path} wasn't a FailureApp"
  end

  def assert_unauthorized_response
    assert_response :unauthorized
  end

end

# From https://stripe.com/docs/testing

StripeCards = {
  default: '4242424242424242',

  # Successful transactions
  visa:             '4242424242424242',
  master_card:      '5555555555554444',
  american_express: '378282246310005',
  discover:         '6011111111111117',
  diners_club:      '30569309025904',
  jcb:              '3530111333300000',

  # Failure transactions
  address_fail:       '4000000000000010',
  address_line1_fail: '4000000000000028',
  address_zip_fail:   '4000000000000036',
  cvc_fail:           '4000000000000101',
  charge_fail:        '4000000000000341',
  decline_fail:       '4000000000000002',
  expired_fail:       '4000000000000069',
  processing_fail:    '4000000000000119'
}
