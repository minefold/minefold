Minefold::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Log to stdout
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  config.action_mailer.default_url_options = {
    host: 'minefold-staging.herokuapp.com',
    protocol: 'https'
  }

  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
      :api_key  => ENV['MAILGUN_API_KEY'],
      :api_host => ENV['MAILGUN_DOMAIN']
  }

  ActionMailer::Base.default from: 'Minefold <support@minefold-staging.herokuapp.com>'

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  config.assets.digest = true

  config.assets.precompile += %w( tumblr.css )

  # Compress both stylesheets and JavaScripts
  # config.assets.js_compressor  = :uglifier

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  config.action_dispatch.x_sendfile_header = nil

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :dalli_store
  #
  # memcached_uri = URI::Generic.build scheme: 'memcached',
  #                                      host: ENV['MEMCACHE_SERVERS']
  #
  # config.middleware.use Rack::Cache,
  #     metastore: memcached_uri.merge('/meta').to_s,
  #   entitystore: memcached_uri.merge('/body').to_s,
  #       verbose: true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = ENV['ASSET_HOST']
  config.action_mailer.asset_host = ENV['ASSET_HOST']

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end


