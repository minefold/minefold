module Concerns::Redis
  extend ActiveSupport::Concern

  SEPARATOR = ':'

  module ClassMethods

    def redis_id(id)
      id.to_s
    end

    def redis_key(id)
      [name.downcase, redis_id(id)].join(SEPARATOR)
    end

  end

# --

  def redis_key
    self.class.redis_key(id)
  end

end
