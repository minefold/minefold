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
    if not Rails.env.test?
      Resque.enqueue(MixpanelTrackJob, event, properties)
    end
  end
  
  
  # People Analytics 
  # https://mixpanel.com/docs/people-analytics/people-http-specification-insert-data
  
  def self.engage(distinct_id, properties={})
    params = {
      distinct_id: distinct_id:,
      token: ENV['MIXPANEL']
      }.merge(properties)

    payload = Base64.strict_encode64(params.to_json)

    RestClient.post('http://api.mixpanel.com/engage', data: payload)
  end
  
  def self.engage_async(distinct_id, properties={})
    if not Rails.env.test?
      Resque.enqueue(MixpanelEngageJob, distinct_id, properties)
    end
  end

end
