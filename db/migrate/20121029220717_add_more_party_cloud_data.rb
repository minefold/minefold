class AddMorePartyCloudData < ActiveRecord::Migration
  
  def change
    remove_column :servers, :ip
    
    rename_column :servers, :partycloud_id, :party_cloud_id
    add_index     :servers, :party_cloud_id, unique: true
    
    
    add_column :funpacks, :party_cloud_id, :string
    add_index  :funpacks, :party_cloud_id, unique: true
    
    add_column :games, :party_cloud_id, :string
    add_index  :games, :party_cloud_id, unique: true
  end

end
