class MinutePlayedJob < TweetJob
  @queue = :high

  def self.perform user_id, world_id, timestamp
  end
end
