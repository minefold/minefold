class CreateVotes < ActiveRecord::Migration

  def change
    create_table :votes do |t|
      t.references :server
      t.references :user
      t.string :ip
      t.timestamps
    end
  end

end
