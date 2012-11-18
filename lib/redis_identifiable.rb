module RedisIdentifiable
  extend ActiveSupport::Concern

  module ClassMethods

    def redis_key(id)
      id.to_s
    end

    def typed_redis_key(id)
      [name.downcase, redis_key(id)].join(':')
    end

  end

  def redis_key
    self.class.redis_key(id)
  end

  def typed_redis_key
    self.class.typed_redis_key(id)
  end

end
