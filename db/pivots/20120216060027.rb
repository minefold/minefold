# Convert Photo world_ids to server_urls

include Rails.application.routes.url_helpers

Photo.all.each do |photo|
  if photo[:world_id]
    world = World.find(photo[:world_id])
    url = user_world_url(world.creator, world, host: 'minefold.com', protocol: 'https')
    photo.set :server_url, url
    photo.unset :world_id
  end
end
