require 'base64'
require 'json'
require 'restclient'

class Mixpanel

  class ApiError < StandardError
  end

  API_BASE = 'api.mixpanel.com'

  attr_reader :token

  def initialize(token=ENV['MIXPANEL'])
    @token = token
  end

  def track(distinct_id, event, properties={})
    params = {
      event: event,
      properties: properties.merge(
        distinct_id: distinct_id,
        token: token
      )
    }
    post '/track', params
  end

  def engage(distinct_id, properties={})
    properties.merge!('$distinct_id' => distinct_id, '$token' => token)
    post '/engage', properties
  end

  # Engagement convenience methods
  [:set, :add, :append].each do |method|
    define_method("#{method}_engagement") do |distinct_id, properties={}|
      engage(distinct_id, "$#{method}" => properties)
    end
  end

  # Bang methods raise an error
  [ :track,
    :engage,
    :set_engagement, :add_engagement, :append_engagement
  ].each do |method|
    define_method("#{method}!") do |*args|
      send(method, *args) || raise(ApiError)
    end
  end


# private

  def enabled?
    not token.nil?
  end

  def post(path, data, params={})
    if enabled?
      params[:data] = encode_payload(data)
      RestClient.post(mixpanel_url(path).to_s, params) == '1'
    end
  end

  def mixpanel_url(path)
    URI::HTTP.build(host: API_BASE, path: path)
  end

  def encode_payload(data)
    Base64.strict_encode64(JSON.generate(data))
  end

end
