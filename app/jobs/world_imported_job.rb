class WorldUploadJob < Job
  @queue = :low

  def initialize(id)
    @world = World.find_by_party_cloud_id(id)
  end

  def perform!
  end

end
