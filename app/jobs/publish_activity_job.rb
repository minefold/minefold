class PublishActivityJob < Job

  def initialize(klass, id)
    @activity = klass.constantize.find(id)
  end

  def perform!
    @activity.publish
  end

end
