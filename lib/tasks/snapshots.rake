namespace :snapshots do
  task :delete_old do
    Resque.enqueue(DeleteOldSnapshotsJob)
  end
end