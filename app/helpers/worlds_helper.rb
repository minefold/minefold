module WorldsHelper

  def party_cloud_world_download_url(server)
    URI::HTTP.build(
      host:  "dl.partycloud.com",
      path:  "/worlds/#{server.party_cloud_id}.zip",
      query: "name=#{URI.encode(server.name)}"
    ).to_s
  end

end
