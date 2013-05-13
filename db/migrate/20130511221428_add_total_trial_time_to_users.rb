class AddTotalTrialTimeToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.integer :total_trial_time, default: 0, null: false
    end
  end
end
