class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :server

      t.string :role

      t.timestamps
    end

    add_index :memberships, :user_id
    add_index :memberships, :server_id

  end
end
