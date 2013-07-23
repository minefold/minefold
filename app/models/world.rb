class World < ActiveRecord::Base
  attr_accessible :last_mapped_at, :legacy_url, :map_data,
                  :party_cloud_id

  belongs_to :server

  belongs_to :legacy_parent, class_name: self.name

  serialize :map_data, JSON

  def map?
    last_mapped_at?
  end

  alias_method :mapped?, :map?

  def recently_mapped?
    map_queued_at and map_queued_at.today?
  end

  def map_in_progress?
    map_queued_at and map_queued_at > 3.days.ago and
      (last_mapped_at.nil? || map_queued_at > last_mapped_at)
  end

  def needs_map?
    not (recently_mapped? or map_in_progress?)
  end

  def to_h
    { last_mapped_at: last_mapped_at,
      map_data: map_data,
      server_id: server.id
    }
  end

  def zoom_levels
    map_data && map_data['zoom_levels'] || 8
  end

  def tile_size
    map_data && map_data['tile_size'] || 256
  end

  def host
    "//d14m45jej91i3z.cloudfront.net"
  end

end
