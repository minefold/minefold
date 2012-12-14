class ActivityStream

  attr_reader :model
  attr_reader :redis

  def initialize(model, redis)
    @model, @redis = model, redis
  end

  def key
    ['activitystream', model.redis_key].join(':')
  end

  def add(activity)
    redis.zadd(key, activity.score, activity.id)
  end

end
