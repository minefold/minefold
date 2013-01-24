require './lib/job'
require './lib/mixpanel'

class MixpanelEngageJob < Job

  attr_reader :mixpanel
  attr_reader :distinct_id
  attr_reader :properties

  def initialize(distinct_id, properties)
    @mixpanel = Mixpanel.new
    @distinct_id, @properties = distinct_id, properties
  end

  def perform
    response = mixpanel.engage(distinct_id, properties)

    if response != '1'
      Bugsnag.notify(RuntimeError.new("MixpanelEngageJob failed"), {
        :body => response.to_str,
        :code => response.code,
        :mixpanel => mixpanel,
        :distinct_id => distinct_id,
        :properties => properties
      })
    end
  end

end
