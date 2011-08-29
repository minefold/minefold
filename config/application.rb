require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

module Minefold
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.encoding = 'utf-8'

    %w( app/jobs lib ).each do |path|
      config.autoload_paths << Rails.root.join(path)
    end

    config.filter_parameters += [:password]

    config.assets.enabled = true
  end
end
