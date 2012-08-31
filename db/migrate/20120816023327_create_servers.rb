class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name, :default => ''

      t.references :creator

      t.references :funpack
      t.string :funpack, :default => 'minecraft-vanilla'

      t.references :upload

      t.string :ip
      t.string :host
      t.integer :port

      t.text :settings

      t.text :map_markers
      t.datetime :last_mapped_at

      t.integer :minutes_played, default: 0
      t.integer :world_minutes_played, default: 0
      t.integer :pageviews, default: 0

      t.timestamps
    end

    add_index :servers, :host, :unique => true
    add_index :servers, :upload_id

  end
end
