class AddSubscriptionIdToUser < ActiveRecord::Migration
  def up
    add_column :users, :subscription_id, :integer
  end

  def down
    remove_column :users, :subscriptions_id
  end
end
