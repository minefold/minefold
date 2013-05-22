class PusherJob < Job

  attr_reader :channels
  attr_reader :event
  attr_reader :payload

  def initialize(channels, event, payload)
    @channels = channels
    @event = event
    @payload = payload
  end

  def perform
    Pusher.trigger(channels, event, payload)
  end

end
