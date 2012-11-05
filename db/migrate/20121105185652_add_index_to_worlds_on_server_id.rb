class AddIndexToWorldsOnServerId < ActiveRecord::Migration
  def change
    add_index :worlds, :server_id
    add_index :servers, [:deleted_at, :creator_id]
  end
end
