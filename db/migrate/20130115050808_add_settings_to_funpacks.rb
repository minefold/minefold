class AddSettingsToFunpacks < ActiveRecord::Migration
  def change
    add_column :funpacks, :settings_manifest, :text
  end
end
