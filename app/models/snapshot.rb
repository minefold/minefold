class Snapshot < ActiveRecord::Base
  attr_accessible :last_mapped_at, :url, :map_data,
                  :party_cloud_id

  belongs_to :server

  serialize :map_data, JSON

  def map?
    last_mapped_at?
  end

  alias_method :mapped?, :map?

  def map_queued?
    map_queued_at?
  end

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

  def download_url
    URI::HTTP.build(
      host:  "dl.partycloud.com",
      # TODO Change to snapshots
      path:  "/worlds/#{server.party_cloud_id}.zip",
      query: "name=#{URI.encode(server.name)}"
    )
  end

end
