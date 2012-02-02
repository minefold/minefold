class MinutePlayedJob < TweetJob
  @queue = :high

  def self.perform(user_id, world_id, timestamp)
    user = User.find(user_id)
    world = World.find(world_id)

    new.process!(user, world, timestamp)
  end

  def process!(user, world, timestamp)
    world.inc :minutes_played, 1
  end
end
