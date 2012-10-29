class AddLegacyFieldsToUsersAndServers < ActiveRecord::Migration
  def change
    change_table :servers do |t|
      t.string :partycloud_id
      
      t.string :legacy_world_url
    end
    
  end
end
