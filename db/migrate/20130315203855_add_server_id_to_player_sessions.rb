class AddServerIdToPlayerSessions < ActiveRecord::Migration
  def change
    change_table :player_sessions do |t|
      t.references :server
    end
  end
end
