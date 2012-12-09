class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :server

  after_create :update_redis_vote

  def update_redis_vote

    s = server.votes.count
    order = Math.log([s.abs, 1].max, 10)
    sign = if s > 0
      1
    elsif s < 0
      -1
    else
      0
    end

    seconds = self.class.epoch_seconds(created_at) - 1134028003

    score = (order + sign * seconds / 45000).round(7)

    $redis.zincrby 'serverlist', score, server.id
  end

  def self.epoch_seconds(date)
    td = date - Time.at(0)

    td.days * 86400 + td.seconds + (td.to_f / 1_000_000)
  end


end
