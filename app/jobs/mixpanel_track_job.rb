require './lib/job'
require './lib/mixpanel'

class MixpanelTrackJob < Job

  attr_reader :mixpanel
  attr_reader :event
  attr_reader :properties

  def initialize(event, properties)
    @mixpanel = Mixpanel.new
    @event, @properties = event, properties
  end

  def perform
    mixpanel.track(event, properties)
  end

end
