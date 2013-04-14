class AddDiscountToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :discount, :integer, null: false, default: 0
  end
end
