require './lib/redis_key'

class TimeSeries

  attr_reader :key
  attr_reader :period

  def initialize(key, period, redis)
    @key = key
    @period = period
    @redis = redis
  end

  def add(data, timestamp = Time.now.to_f)
    @redis.zadd(tkey(timestamp).to_s, timestamp, data)
  end

  def fetch_range(start_time, end_time)
    start_time = start_time.to_f
    end_time = end_time.to_f

    result = (0..((end_time - start_time) / period)).collect do |i|
      key = tkey(start_time + (i * period))
      @redis.zrangebyscore(key.to_s, start_time.to_f, end_time.to_f)
    end

    result.flatten
  end

  def fetch_timestamp(time)
    time = time.to_f
    @redis.zrangebyscore(tkey(time).to_s, time, time)
  end

# private

  def normalize_time(time)
    time = time.to_i
    time - (time % period)
  end

  def tkey(time)
    RedisKey.new(key, normalize_time(time))
  end

end
