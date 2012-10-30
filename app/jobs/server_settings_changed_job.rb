class ServerSettingsChangedJob < Job
  @queue = :high

  def initialize(id, settings)
    @server = Server.find_by_party_cloud_id(id)
    @settings = settings
  end

  def perform!
  end

end
