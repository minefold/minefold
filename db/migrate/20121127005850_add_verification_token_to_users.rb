class AddVerificationTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string     :verification_token, limit: 12
    end

    add_index :users, [:deleted_at, :verification_token], unique: true

    User.find_each do |user|
      user.generate_unique(:verification_token, length: 12)
      user.save
    end
  end
end
