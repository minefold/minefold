task :fetch_avatars => :environment do
  MinecraftPlayer.all.each do |u|
    Resque.enqueue FetchAvatarJob, u.id
  end
end
