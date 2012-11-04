class AddLastCreditFairyVisitAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_credit_fairy_visit_at, :datetime
  end
end
