task :fetch_avatars => :environment do
  User.all.each do |u|
    Resque.enqueue FetchAvatarJob, u.id
  end
end
