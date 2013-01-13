class RemoveCreditFairyInfoFromUsers < ActiveRecord::Migration

  def up
    remove_column :users, :last_coin_fairy_visit_at
  end

  def down
    add_column :users, :last_coin_fairy_visit_at, :datetime
  end

end
