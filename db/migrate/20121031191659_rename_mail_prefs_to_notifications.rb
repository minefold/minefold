class RenameMailPrefsToNotifications < ActiveRecord::Migration
  def change
    rename_column :users, :mail_prefs, :notifications
  end
end
