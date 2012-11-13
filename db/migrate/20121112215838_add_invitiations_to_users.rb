class AddInvitiationsToUsers < ActiveRecord::Migration

  def change
    change_table :users do |t|
      t.string     :invitation_token, limit: 12
      t.references :invited_by
    end

    add_index :users, [:deleted_at, :invitation_token], unique: true

    User.find_each do |user|
      user.generate_unique(:invitation_token, length: 12)
      user.save
    end
  end

end
