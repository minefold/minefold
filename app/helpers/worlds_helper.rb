module WorldsHelper

  def party_cloud_world_download_url(world)
    URI::HTTP.build(
      host:  "dl.partycloud.com",
      path:  "/worlds/#{world.party_cloud_id}.zip",
      query: "name=#{URI.encode(world.server.name)}"
    ).to_s
  end

end
