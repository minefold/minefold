module Mixpanel
  def mixpanel
    @mixpanel ||= EM::Mixpanel.new(ENV['MIXPANEL_TOKEN'], ip: request.ip)
  end
  
  def track(event_name, properties={})
    if Rails.env.production?
      if signed_in?
        properties[:distinct_id] = current_user.id.to_s
        properties[:mp_name_tag] = current_user.safe_username
      end

      mixpanel.track(event_name, properties)
    else
      Rails.logger.info "[Mixpanel] #{event_name}"
    end
  end
end