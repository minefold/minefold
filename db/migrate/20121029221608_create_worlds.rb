class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.references :server
      
      t.string :party_cloud_id
      
      t.string :legacy_url
      t.datetime :last_mapped_at
      t.text :map_data

      t.timestamps
    end
    
    add_index :worlds, :party_cloud_id, unique: true
    
    remove_column :servers, :upload_id
    remove_column :servers, :last_mapped_at
    remove_column :servers, :map_markers
    remove_column :servers, :legacy_world_url
  end
end
