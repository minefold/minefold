class UpdateSubscriptionJob
  @queue = :low

  def self.perform user_id
    new.process! User.find(user_id)
  end
  
  def process! user
    subscriber = CreateSend::Subscriber.new ENV['CAMPAIGN_MONITOR_USER_LIST_ID'], user.email
    subscriber.update user.email, user.username, [{
        Key: 'Username', 
        Value: user.username
      }],
      false
    puts "updated subscription #{user.id} #{user.username} #{user.email}"
  end
end