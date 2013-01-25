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
    mixpanel.engage! distinct_id, properties
  end

end
