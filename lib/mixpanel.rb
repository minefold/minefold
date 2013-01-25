require 'base64'
require 'json'
require 'restclient'

class Mixpanel

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
    post '/engage?', properties
  end

  [:set, :add, :append].each do |method|
    define_method("#{method}_engagement") do |distinct_id, properties={}|
      engage(distinct_id, "$#{method}" => properties)
    end
  end


# private

  def enabled?
    not token.nil?
  end

  def post(path, data={}, params={})
    if enabled?
      RestClient.post(
        mixpanel_url(path).to_s,
        encode_payload(data),
        params: params.merge(verbose: true)
      )
    end
  end

  def mixpanel_url(path)
    URI::HTTP.build(host: API_BASE, path: path)
  end

  def encode_payload(data)
    Base64.strict_encode64(JSON.generate(data))
  end

end
