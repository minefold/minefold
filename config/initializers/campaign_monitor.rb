CreateSend.api_key ENV['CAMPAIGN_MONITOR_API_KEY']

class CampaignList
  def self.paid_users
    new('baa78a03c4f61487315f09ac7239dc4a')
  end
  
  def initialize list_id
    @list_id = list_id
  end
  
  def subscribe user
    unless CreateSend.api_key.empty?
      CreateSend::Subscriber.add @list_id, 
        user.email, user.username, [{ :Key => 'Username', :Value => user.username}], true
    else
      puts "Fake subscribe #{user} to #{@list_id}"
    end
  end
end
