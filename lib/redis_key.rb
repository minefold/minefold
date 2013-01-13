require 'active_support/core_ext/string/inflections'

class RedisKey

  SEPARATOR = ':'

  def self.key_for(obj)
    case obj
    when String, Symbol, RedisKey
      obj.to_s
    when Class
      class_key(obj)
    else
      instance_key(obj)
    end
  end

  def self.class_key(klass)
    klass.name.underscore
  end

  def self.instance_key(obj)
    [class_key(obj.class), obj.id.to_s].join(SEPARATOR)
  end

  def initialize(*keys)
    @keys = keys
  end

  def to_s
    @keys.map {|key| self.class.key_for(key) }.join(SEPARATOR)
  end

end
