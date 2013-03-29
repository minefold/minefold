class AddToMailingListJob < Job
  @queue = :low

  attr_reader :user, :list

  def initialize(user_id, list)
    @user = User.unscoped.find(user_id)
    @list = list
  end

  def perform
    add_to_mailgun_list(list, user.email, 
      (user.name.blank? ? user.username : user.name))
  end

  def add_to_mailgun_list(list, email, name)
    list = "newsletters"
    endpoint = "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v2"
    url = "#{endpoint}/lists/#{list}@#{ENV['MAILGUN_DOMAIN']}/members"

    RestClient.post(url, address: email, name: name)
  end
end
