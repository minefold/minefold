module WorldsHelper

  def party_cloud_world_download_url(world)
    "http://dl.partycloud.com/worlds/#{world.party_cloud_id}.zip?name=#{world.server.name}.zip"
  end

end
