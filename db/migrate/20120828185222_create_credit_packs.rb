class CreateCreditPacks < ActiveRecord::Migration
  def change
    create_table :credit_packs do |t|
      t.integer :cents, default: 0, null: false
      t.integer :cr, default: 0, null: false

      t.timestamps
    end
  end
end
