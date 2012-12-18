class RenameLegacyUrlToJustPlainOlUrl < ActiveRecord::Migration

  def change
    rename_table :worlds, :snapshots
    rename_column :snapshots, :legacy_url, :url
    remove_column :snapshots, :legacy_parent_id
  end

end
