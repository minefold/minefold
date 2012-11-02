class World < ActiveRecord::Base
  attr_accessible :last_mapped_at, :legacy_url, :map_data,
                  :party_cloud_id
  
  belongs_to :server
  
  def map?
    last_mapped_at?
  end
  
  alias_method :mapped?, :map?
  
end
