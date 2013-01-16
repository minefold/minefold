class AddSettingsToFunpacks < ActiveRecord::Migration
  def change
    add_column :funpacks, :settings_schema, :text
  end
end
