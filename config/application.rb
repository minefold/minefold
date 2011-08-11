require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require *Rails.groups(:assets) if defined?(Bundler)

module Minefold
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.encoding = 'utf-8'

    %w( app/jobs lib ).each do |path|
      config.autoload_paths << Rails.root.join(path)
    end

    config.filter_parameters += [:password]

    config.assets.enabled = true

    config.buckets = %w( world_import ).each_with_object({}) do |name, buckets|
      buckets[name.to_sym] = "minefold.#{Rails.env}.#{name}"
    end
  end
end
