# should be run about once a day
class DeleteOldSnapshotsJob < Job
  @queue = :low

  def perform
    delete_free_servers_older_than(6.months.ago)
    delete_snapshots_for_deleted_servers
  end

  def delete_snapshots_for_deleted_servers
    pc_ids = Server.unscoped.where(
      'party_cloud_id is not null and deleted_at > ? and deleted_at < ?',
      16.days.ago, 14.days.ago
    ).select(:party_cloud_id).map(&:party_cloud_id)

    while pc_id = pc_ids.pop
      PartyCloud::Server.new(pc_id).delete_all_snapshots!
    end
  end

  def delete_free_servers_older_than(time)
    Server.
      joins('left outer join worlds on worlds.server_id = servers.id').
      joins('inner join users on servers.creator_id = users.id').
      joins('left outer join subscriptions on users.subscription_id = subscriptions.id').
      where('servers.party_cloud_id is not null').
      where('servers.updated_at < ? and (worlds.id is null or worlds.updated_at < ?)', time, time).
      where('servers.minutes_played < ?', 10 * 60).
      where('subscriptions.id is null or users.total_trial_time = 0').find_each do |s|
        # puts "#{s.id}   #{s.minutes_played}  #{s.updated_at}"
        s.delete
    end
  end
end
