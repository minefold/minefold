task :invite => :environment do
  include Rails.application.routes.url_helpers
  invite = Invite.create!

  puts user_new_url(invite.token, :host => 'minefold.com')
end
