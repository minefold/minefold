class EventObserver < Mongoid::Observer

  def after_create(event)
    # if event.source.is_a?(User)
    #   $redis.lpush "users/#{event.source.id}/activty", event.id
    # end
  end

end
