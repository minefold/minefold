module Concerns::Redis
  extend ActiveSupport::Concern

  SEPARATOR = ':'

  module ClassMethods

    def redis_id(id)
      id.to_s
    end

    def redis_key(id, *args)
      [name.downcase, redis_id(id), *args].join(SEPARATOR)
    end

  end

# --

  def redis_key(*args)
    self.class.redis_key(id, *args)
  end

end
