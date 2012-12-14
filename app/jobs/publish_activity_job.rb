class PublishActivityJob < Job

  def initialize(klass, id)
    @activity = klass.constantize.find(id)
  end

  def perform!


    # push the activity into the actor's stream
    # @activity.actor.add_activity_to_stream(@activity)
    #
    # # push the activity into the target's stream
    # @activity.target.add_activity_to_stream(@activity)


    # find entities connected to actor
    # publish

    # find entities connected to target
    # publish
  end

end
