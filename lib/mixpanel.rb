# TODO: move to resque

module Mixpanel
  def self.track event, properties
    return unless Rails.env.production?
    
    params = {"event" => event, "properties" => properties.merge(token: ENV['MIXPANEL_TOKEN'])}
    data = ActiveSupport::Base64.encode64s(JSON.generate(params))
    request = "http://api.mixpanel.com/track/?data=#{data}"
    `curl -s '#{request}'`
  end

  def mixpanel
    @mixpanel ||= EM::Mixpanel.new(ENV['MIXPANEL_TOKEN'], ip: request.ip)
  end

  def track(event_name, properties={})
    return unless Rails.env.production?
    
    if properties[:distinct_id].nil? and signed_in?
      properties[:distinct_id] = current_user.id.to_s
      properties[:mp_name_tag] = current_user.email
    end

    mixpanel.track(event_name, properties)
  end

end
