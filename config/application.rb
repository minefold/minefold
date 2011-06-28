require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Minefold
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.encoding = 'utf-8'

    config.filter_parameters += [:password]

    config.assets.enabled = true

    config.generators do |g|
      g.fixture_replacement :machinist
    end
  end
end
