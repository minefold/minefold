class AddScoreToServers < ActiveRecord::Migration
  def change
    add_column :servers, :score, :float, default: 0.0
  end
end
