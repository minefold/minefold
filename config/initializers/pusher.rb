if ENV['PUSHER_URL']
  Pusher.url = ENV['PUSHER_URL']
  Pusher.encrypted = Rails.env.production?
end
