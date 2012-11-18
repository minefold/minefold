class ServerTickedJob < Job
  @queue = :high

  def initialize(id, timestamp, state)
    @server = Server.find_by_party_cloud_id(id)
    @timestamp = Time.at(timestamp)
    @state = state
  end

  def perform!
    # TODO Increment stats!

    if @server.normal?
      creator = @server.creator
      credit_timeseries =
        RedisTimeSeries.new("user:#{@server.creator.id}:credits", 3600, $redis)

      creator.increment_credits!(5)
      # Have to remember that increment_credits doesn't update the models internal credit count. We could reload it, but it's faster to just approximate.
      creidt_ts.add(creator.credits - 5, timestamp)
    end


    if @server.shared?
      players = state['players']
        .map {|uid| Player.minecraft.find_by_uid(uid) }

      users = players.map {|player| player.user }

      # Kick users who've gone over their time
      users.each {|user| user.kick! unless user.credits_available? }

      # Deduct credits from players on Super Servers
      users.each {|user| user.tick! }
    end
  end

end
