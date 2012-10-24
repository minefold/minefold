module Mixpanel

  def self.track(event, properties={})
    params = {
      event: event,
      properties: properties.merge(
        token: ENV['MIXPANEL']
      )
    }

    payload = Base64.strict_encode64(params.to_json)

    RestClient.post('http://api.mixpanel.com/track', data: payload)
  end
  
  def self.track_async(event, properties={})
    Resque.enqueue(MixpanelJob, event, properties) unless Rails.env.test?
  end

end
