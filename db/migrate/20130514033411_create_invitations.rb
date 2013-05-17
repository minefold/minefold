class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :state, default: 0, null: false
      t.references :sender, null: false
      t.references :friend

      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
