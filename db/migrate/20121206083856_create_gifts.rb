class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.references :coin_pack, null: true

      t.string :token, limit: 12

      t.references :parent, allow_nil: true
      t.references :child, allow_nil: true

      t.string :customer_id
      t.string :charge_id

      t.string :name
      t.string :email, allow_nil: false

      t.string :to

      t.timestamps
    end

    add_index :gifts, :coin_pack_id
    add_index :gifts, :token
    add_index :gifts, :parent_id
    add_index :gifts, :child_id
  end
end
