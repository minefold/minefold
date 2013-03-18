class CreateSnapshotsAndMaps < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.references :server
      t.string :party_cloud_id
    end

    create_table :maps do |t|
      t.references :server
      t.datetime :rendered_at
      t.hstore :data
    end
  end
end
