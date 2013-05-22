class CreatePlanAllocations < ActiveRecord::Migration
  def change
    create_table :plan_allocations do |t|
      t.references :plan
      t.references :funpack

      t.integer :ram
      t.integer :players

      t.timestamps
    end
  end
end
