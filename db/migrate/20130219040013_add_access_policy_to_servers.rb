class AddAccessPolicyToServers < ActiveRecord::Migration
  def change
    add_column :servers, :access_policy_id, :integer
  end
end
