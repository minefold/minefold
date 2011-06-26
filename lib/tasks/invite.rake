task :invite => :environment do
  puts User.create.invite
end
