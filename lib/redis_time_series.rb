class RedisTimeSeries

  def initialize(prefix, period, redis)
    @prefix = prefix
    @period = period
    @redis = redis
  end

  def normalize_time(time)
    time = time.to_i
    time - (time % @period)
  end

  def getkey(time)
    "#{@prefix}:#{normalize_time(time)}"
  end

  def add(data, timestamp = Time.now.to_f)
    @redis.zadd(getkey(timestamp), timestamp, data)
  end

  def fetch_range(start_time, end_time)
    start_time = start_time.to_f
    end_time = end_time.to_f

    result = (0..((end_time - start_time) / @period)).collect do |i|
      key = getkey(start_time + (i * @period))
      @redis.zrangebyscore(key, start_time.to_f, end_time.to_f)
    end

    result.flatten
  end

  def fetch_timestamp(time)
    time = time.to_f
    @redis.zrangebyscore(getkey(time), time, time)
  end

end
