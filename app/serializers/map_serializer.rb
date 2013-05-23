class MapSerializer < Serializer

  def payload
    o = super
    o[:object] = 'map'
    o[:server_id] = object.id
    o[:host] = "//d14m45jej91i3z.cloudfront.net"
    o[:zoom_levels] = 7
    o[:tileSize] = 384

    # TODO Legacy
    # o[:created] = object.world.created_at
    # o[:updated] = object.world.updated_at
    # o[:last_mapped_at] = object.world.created_at

    o[:spawn] = {
      x: 0,
      y: 66,
      z: 0
    }

    o
  end

end
