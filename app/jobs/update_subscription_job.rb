class UpdateSubscriptionJob < Job
  @queue = :low

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def process?
    @user.email? and ENV['CAMPAIGN_MONITOR_USER_LIST_ID']
  end

  def process!
    subscriber = CreateSend::Subscriber.new(
      ENV['CAMPAIGN_MONITOR_USER_LIST_ID'],
      @user.email
    )

    subscriber.update(@user.email, @user.username, [{
        Key: 'Username',
        Value: @user.username
      }], false
    )
  end
end
