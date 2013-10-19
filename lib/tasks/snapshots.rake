namespace :snapshots do
  task :delete_old do
    Resque.enqueue(DeleteOldSnapshotsJob)
  end

  task :compact_all do
    pc_ids = Server.where('party_cloud_id is not null').select(:party_cloud_id).map(&:party_cloud_id)
    q = Queue.new
    pc_ids.each {|id| q << id }

    5.times do
      Thread.new do
        begin
          while pc_id = q.pop(non_block=true)
            puts "#{q.size} compacting:  #{pc_id}"
            PartyCloud::Server.new(pc_id).compact_snapshots!
          end
        rescue
        end
      end
    end
  end
end