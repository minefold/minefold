class MixpanelTrackedJob < Job

  def initialize(event, properties)
    @event, @properties = event, properties
  end

  def perform
    Mixpanel.track(@event, @properties)
  end

end
