class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :plan
      
      t.datetime :expires_at
      t.timestamps
    end
  end
end
