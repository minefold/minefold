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

  def skip_map?
    map_queued_at and map_queued_at.today?
  end

  def needs_map?
    not skip_map?
  end

  def to_h
    { last_mapped_at: last_mapped_at,
      map_data: map_data,
      server_id: server.id
    }
  end

end
