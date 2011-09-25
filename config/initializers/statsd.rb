if ENV['STATSD_SERVER']
  StatsD.server = ENV['STATSD_SERVER']
  StatsD.logger = Rails.logger
end
