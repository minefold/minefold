require './lib/job'
require './lib/mixpanel'

class MixpanelTrackJob < Job

  attr_reader :mixpanel
  attr_reader :distinct_id
  attr_reader :event
  attr_reader :properties

  def initialize(distinct_id, event, properties)
    @mixpanel = Mixpanel.new
    @distinct_id, @event, @properties = distinct_id, event, properties
  end

  def perform
    mixpanel.track(distinct_id, event, properties)
  end

end
