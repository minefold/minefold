class PlayerDisconnectedJob < Job
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

  def perform!
    session = account.sessions.current
    session.finish(time)
    session.save!
  end

end
