class RenameStoppedAtToStopAt < ActiveRecord::Migration

  def change
    rename_column :servers, :stopped_at, :stop_at
  end

end
