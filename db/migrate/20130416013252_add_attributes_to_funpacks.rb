class AddAttributesToFunpacks < ActiveRecord::Migration
  def change
    change_table :funpacks do |t|
      t.string  :steam_id, null: true
      t.boolean :maps, default: false, null: false
      t.boolean :persistent, default: false, null: false
      t.integer :default_access_policy_id
      t.integer :access_policy_ids, array: true
    end
  end
end
