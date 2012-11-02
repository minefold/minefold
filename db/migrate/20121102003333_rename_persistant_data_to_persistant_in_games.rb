class RenamePersistantDataToPersistantInGames < ActiveRecord::Migration

  def change
    rename_column :games, :persistant_data, :persistant
  end

end
