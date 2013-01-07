class CreateStars < ActiveRecord::Migration

  def up
    rename_table :servers_users, :watchers

    create_table :stars, id: false do |t|
      t.references :user
      t.references :server
    end
  end

  def down
    drop_table :stars
    rename_table :watchers, :servers_users
  end

end
