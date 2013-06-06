class Webhooks::AtlasController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    Librato.increment('webhook.atlas.total')

    data = JSON.parse(request.body.read, symbolize_names: true)

    map_rendered(data)

    render nothing: true, :status => :ok
  end

  def map_rendered(data)
    server = Server.unscoped.where(id: data[:id]).first
    return if server.nil? or server.deleted? or server.world.nil?
    world = server.world

    last_mapped_at_was = world.last_mapped_at

    world.last_mapped_at = Time.at(data[:created])

    world.map_data = {
      zoom_levels: data[:map_data][:zoom_levels],
      tile_size:   data[:map_data][:tile_size],
      spawn:       data[:map_data][:markers].find {|m| m[:type] == 'spawn'}
    }
    world.save!

    # Only deliver maps on the first render. Could use AR's dirty tracking for this but it gets reset when save gets called and I want to make sure the email is sent after the map is saved.
    if last_mapped_at_was.nil?
      MapMailer.rendered(server.id).deliver
    end
  end

end
