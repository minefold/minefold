class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :server
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end

    add_index :sessions, :server_id

    remove_column :servers, :start_at
    remove_column :servers, :stop_at
  end
end
