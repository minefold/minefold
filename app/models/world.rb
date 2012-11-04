class World < ActiveRecord::Base
  attr_accessible :last_mapped_at, :legacy_url, :map_data,
                  :party_cloud_id

  belongs_to :server

  belongs_to :legacy_parent, class_name: self.name

  def map?
    last_mapped_at?
  end

  alias_method :mapped?, :map?

  serialize :map_data, JSON

  def to_h
    { last_mapped_at: last_mapped_at,
      legacy_url: legacy_url,
      map_data: map_data,
      party_cloud_id: party_cloud_id
    }
  end

end
