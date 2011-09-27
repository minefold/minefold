class OrderProcessed < TweetJob
  @queue = :high

  def self.perform order_id
    order = Order.find(order_id)

    %W(whatupdave chrislloyd).each do |dude|
      tweet dude, "Ka-ching! #{order.user.username} just paid #{order.total}"
    end
  end
end
