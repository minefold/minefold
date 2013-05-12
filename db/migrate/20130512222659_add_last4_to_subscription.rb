class AddLast4ToSubscription < ActiveRecord::Migration
  def change
    change_table :subscriptions do |t|
      t.string :last4, limit: 4
    end
  end
end
