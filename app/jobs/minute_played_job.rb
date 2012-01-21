class MinutePlayedJob < TweetJob
  @queue = :high

  def self.perform user_id, world_id, timestamp
    new.increase_world_minutes_played! World.find(world_id)
  end
  
  def increase_world_minutes_played! world
    world.inc :minutes_played, 1
  end
end
