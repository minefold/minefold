class RenameEmailPrefsToMailPrefs < ActiveRecord::Migration
  
  def change
    rename_column :users, :email_prefs, :mail_prefs
  end

end
