class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.references :server_session
      t.string :username

      t.references :user, null: true

      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
