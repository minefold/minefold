class BroadcastActivityJob < Job

  attr_reader :activity

  def initialize(klass, id)
    @activity = klass.constantize.find(id)
  end

  def perform
    activity.broadcast
  end

end
