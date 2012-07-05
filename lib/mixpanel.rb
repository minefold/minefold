module Mixpanel
  def self.track event, properties
    params = {"event" => event, "properties" => properties.merge(token: ENV['MIXPANEL_TOKEN'])}
    data = ActiveSupport::Base64.encode64s(JSON.generate(params))
    request = "http://api.mixpanel.com/track/?data=#{data}"
    `curl -s '#{request}'`
  end

  def track(event_name, properties={})
    unless Rails.env.production?
      Resque.enqueue(MixpanelJob, event_name, properties)
    end
  end
end
