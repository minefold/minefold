class TimeSeries

  def initialize(obj, name, period, redis)
    @obj = obj
    @period = period
    @redis = redis
  end

  def normalize_time(time)
    time = time.to_i
    time - (time % @period)
  end

  def tkey(time)
    @obj.redis_key(normalize_time(time))
  end

  def add(data, timestamp = Time.now.to_f)
    @redis.zadd(tkey(timestamp), timestamp, data)
  end

  def fetch_range(start_time, end_time)
    start_time = start_time.to_f
    end_time = end_time.to_f

    result = (0..((end_time - start_time) / @period)).collect do |i|
      key = key(start_time + (i * @period))
      @redis.zrangebyscore(tkey, start_time.to_f, end_time.to_f)
    end

    result.flatten
  end

  def fetch_timestamp(time)
    time = time.to_f
    @redis.zrangebyscore(tkey(time), time, time)
  end

end
