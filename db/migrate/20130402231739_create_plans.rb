class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :stripe_id
      t.string :name
      t.integer :cents
      t.integer :bolts

      t.timestamps
    end
  end
end
