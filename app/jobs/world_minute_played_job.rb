class WorldMinutePlayedJob < Job
  @queue = :high

  MAP_INTERVAL = 60

  def initialize(world_id, timestamp)
    @world = World.unscoped.where(_id: world_id).first
    @timestamp = timestamp
  end

  def perform!
    @world.inc :world_minutes_played, 1

    if @world.world_minutes_played % MAP_INTERVAL == 0
      Resque.push 'maps_low', class: 'Job::MapWorld', args: [@world.id.to_s]
    end
  end

end
