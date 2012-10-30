class World < ActiveRecord::Base
  attr_accessible :last_mapped_at, :legacy_download_url, :map_markers,
                  :party_cloud_id
  
  def map?
    last_mapped_at?
  end
  
  alias_method :mapped?, :map?
  
end
