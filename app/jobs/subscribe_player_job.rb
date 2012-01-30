class SubscribePlayerJob
  @queue = :low

  def self.perform user_id
    new.process! User.find(user_id)
  end
  
  def process! user
    CreateSend::Subscriber.add ENV['CAMPAIGN_MONITOR_USER_LIST_ID'], 
      user.email, user.username, [{ :Key => 'Username', :Value => user.username}], true
    puts "subscribed #{user.id} #{user.username} #{user.email}"
  end
end