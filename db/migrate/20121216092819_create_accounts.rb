class CreateAccounts < ActiveRecord::Migration

  def up
    rename_table :players, :accounts
    rename_column :accounts, :game_id, :type
    change_column :accounts, :type, :string

    Account.update_all(type: Accounts::Mojang.name)

    User.where('facebook_uid IS NOT NULL').find_each do |user|
      acc = Accounts::Facebook.new(
        uid: user[:facebook_uid]
      )
      acc.user_id = user.id
      acc.save!
    end

    remove_column :users, :facebook_uid
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
