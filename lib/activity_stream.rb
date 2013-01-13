require './lib/redis_key'

class ActivityStream

  attr_reader :model
  attr_reader :redis

  def initialize(model, redis)
    @model, @redis = model, redis
  end

  def key
    RedisKey.new(:activitystream, model)
  end

  def add(activity)
    redis.zadd(key.to_s, activity.score, activity.id)
  end

  def page(n=0, limit=10)
    offset = n * limit
    Activity
      .order(:created_at).reverse_order
      .find(redis.zrevrange(key.to_s, offset, offset + limit))
  end

end
