class AddIndividualOptionToServers < ActiveRecord::Migration
  def change
    add_column :servers, :individual, :boolean, default: false, null: false
    add_column :games, :individual, :boolean, default: false, null: false
  end
end
