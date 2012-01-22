class MinutePlayedJob < TweetJob
  @queue = :high

  def self.perform user_id, world_id, timestamp
    new.process! User.find(user_id), World.find(world_id), timestamp
  end

  def process! user, world, timestamp
    world.minute_played!
  end
end
