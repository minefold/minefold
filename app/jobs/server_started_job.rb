class ServerStartedJob < Job
  @queue = :high

  attr_reader :server
  attr_reader :host
  attr_reader :port
  attr_reader :started_at

  def initialize(party_cloud_id, host, port, timestamp=nil)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
    if @server
      @creator = @server.creator
      @host, @port = host, port

      @started_at = if timestamp.nil?
        Time.now
      else
        Time.at(timestamp)
      end
    end
  end

  def perform
    return unless @server

    session = server.sessions.current

    session.started_at ||= started_at
    # In the case where either jobs have been lost or processed out of order, this just continues any open sessions and moves the started_at time *back* if needed. We don't have to be super precise with ServerSessions, they're just for displaying to users (not billing).
    session.started_at = [session.started_at, started_at].min
    session.save!

    server.host = host
    server.port = port
    server.save!

    server.started!

    enforce_bolts! if @creator.active_subscription?

    Pusher.trigger("server-#{server.id}", 'server:started',
      state: server.state_name,
      address: server.address.to_s,
      started_at: started_at
    )

    Analytics.track(
      user_id: server.creator_id,
      event: 'Started server',
      properties: {
        funpack: server.funpack.name
      }
    )
  end

  def enforce_bolts!
    servers = @creator.created_servers

    allocations = PartyCloud.running_server_allocations(servers.map(&:party_cloud_id))

    # we don't know how many 'bolts' are running in partycloud, but we know how much
    # ram each server has. We can work backwards from that

    running_bolts = allocations.inject(0) do |bolts, (server_pc_id, ram_allocated)|
      s = servers.find{|s| s.party_cloud_id == server_pc_id }

      # find the closest allocation. Round up?
      allocation = s.funpack.plan_allocations.sort_by(&:ram).select{|pa| pa.ram <= ram_allocated }.last

      bolts + allocation.plan.bolts
    end

    if running_bolts > @creator.subscription.plan.bolts
      running_servers = servers.select{|s|
        allocations.keys.include?(s.party_cloud_id)
      }.sort_by{|s| s.sessions.current ? s.sessions.current.started_at : s.updated_at }

      Scrolls.log(
        bolts_allowed: @creator.subscription.plan.bolts,
        bolts_running: running_bolts,
        oldest_server: running_servers.first.id,
        action: 'stopping'
      )

      Resque.enqueue StopServerJob, running_servers.first.id
    end
  end

end
