module Mixpanel

  # Tracking API:
  # https://mixpanel.com/docs/api-documentation/http-specification-insert-data

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

  def self.async_track(event, properties={})
    if not Rails.env.test?
      Resque.enqueue(MixpanelTrackedJob, event, properties)
    end
  end


  # People Analytics:
  # https://mixpanel.com/docs/people-analytics/people-http-specification-insert-data

  def self.person(distinct_id, properties={})
    params = {
      '$distinct_id' => distinct_id,
      '$token' => ENV['MIXPANEL']
    }.merge(properties)

    payload = Base64.strict_encode64(params.to_json)

    RestClient.post('http://api.mixpanel.com/engage', data: payload)
  end

  def self.async_person(distinct_id, properties={})
    if not Rails.env.test?
      Resque.enqueue(MixpanelPersonJob, distinct_id, properties)
    end
  end

  def self.async_person_set(distinct_id, properties={})
    async_person(distinct_id, '$set' => properties)
  end

  def self.async_person_add(distinct_id, properties={})
    async_person(distinct_id, '$add' => properties)
  end

end
