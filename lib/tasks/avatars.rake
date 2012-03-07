task :fetch_avatars => :environment do
  User.all.each do |u|
    puts "Fetching avatar for #{u.safe_username}"
    u.fetch_avatar!
  end
end
