class ServerStoppedJob < Job
  @queue = :low

  attr_reader :time
  attr_reader :server

  def initialize(timestamp=nil, party_cloud_id)
    @time = Time.at(timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
  end

  def perform!
    # TODO Add error checking for when the session doesn't exist
    session = server.sessions.current
    session.finish(time)
    session.save!
  end

end
