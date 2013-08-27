# should be run about once a day
class DeleteOldSnapshotsJob < Job
  @queue = :low

  def perform
    pc_ids = Server.unscoped.where(
      'party_cloud_id is not null and deleted_at > ? and deleted_at < ?',
      16.days.ago, 14.days.ago
    ).select(:party_cloud_id).map(&:party_cloud_id)

    while pc_id = pc_ids.pop
      PartyCloud::Server.new(pc_id).delete_all_snapshots!
    end
  end
end
