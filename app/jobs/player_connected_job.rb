class PlayerConnectedJob < Job
  @queue = :high

  attr_accessor :time
  attr_accessor :server
  attr_accessor :account

  def initialize(timestamp, party_cloud_id, uid)
    @time = Time.at(timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
    # TODO Find from game auth type
    @account = Accounts::Mojang.find_or_create_by_uid(uid)
  end

  def perform
    server_session = server.sessions.current

    session = server_session.player_sessions.new
    session.started_at = time
    session.account = account

    server_session.save!

    if account.user
      MixpanelAsync.track(account.user.distinct_id, 'Played',
        server: server.name,
        funpack: server.funpack.name
      )
    end
  end

end
