class AddEmailPrefsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_prefs, :text
  end
end
