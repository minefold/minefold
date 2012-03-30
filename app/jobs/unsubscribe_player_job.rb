class UnsubscribePlayerJob < Job
  @queue = :low

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def perform?
    @user.email? and ENV['CAMPAIGN_MONITOR_USER_LIST_ID']
  end

  def perform!
    begin
      CreateSend::Subscriber.new(
        ENV['CAMPAIGN_MONITOR_USER_LIST_ID'],
        @user.email
      ).unsubscribe
    rescue
      puts "player already unsubscribed"
    end
  end
end