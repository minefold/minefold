module Mixpanel

  def mixpanel
    @mixpanel ||= EM::Mixpanel.new(ENV['MIXPANEL_TOKEN'], ip: request.ip)
  end

  def track(event_name, properties={})
    if Rails.env.production?
      if properties[:distinct_id].nil? and signed_in?
        properties[:distinct_id] = current_user.id.to_s
        properties[:mp_name_tag] = current_user.safe_username
      end

      mixpanel.track(event_name, properties)
    else
      Rails.logger.info "[Mixpanel] <#{event_name}> #{properties}"
    end
  end

end
