class UpdateSubscriptionJob < Job
  @queue = :low

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def perform?
    @user.email? and ENV['CAMPAIGN_MONITOR_USER_LIST_ID']
  end

  def perform!
    begin
      subscriber = CreateSend::Subscriber.new(
        ENV['CAMPAIGN_MONITOR_USER_LIST_ID'],
        @user.email
      )

      subscriber.update(@user.email, @user.username, [{
          Key: 'Username',
          Value: @user.username
        }], false
      )
    rescue CreateSend::BadRequest => e
      puts "#{e}"
    end
    
  end
end
