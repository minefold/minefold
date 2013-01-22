class AddStateToServers < ActiveRecord::Migration
  def change
    add_column :servers, :state, :integer
  end
end
