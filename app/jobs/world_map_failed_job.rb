class WorldMapFailedJob < Job

  def initialize(id, timestamp, error)
    @server = Server.unscoped.find(id)
    @timestamp, @error = timestamp, error
  end

  def perform
    # TODO update and email
  end

end
