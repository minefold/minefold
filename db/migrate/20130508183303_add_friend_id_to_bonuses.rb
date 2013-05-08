class AddFriendIdToBonuses < ActiveRecord::Migration
  def change
    add_column :bonuses, :friend_id, :integer
  end
end
