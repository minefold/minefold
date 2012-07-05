class MixpanelJob < Job

  def initialize(event, options)
    @event, @options = event, options
  end

  def perform?
    Rails.env.production?
  end

  def perform!
    Mixpanel.track(@event, @options)
  end

end
