class Bonuses::ReferredFriend < Bonus
  extend StateMachine::MacroMethods

  self.coins = 60

  belongs_to :friend, class_name: 'User'

  States = {
    sent:            0,  # email sent. This won't happen for tweets etc
    signed_up:       1,  # from here on in, friend should be set
    confirmed_email: 2,
    played:          3,  # Has actually played on a server with a linked account
    paying:          4   # Is currently a paying customer
  }

  # Hacks:
  #  - invite dave+1@minefold.com, dave+2@minefold.com etc. All of these can be confirmed
  #  - unlink minecraft account, relink, play on new email address, unlink, relink etc.

  validates_presence_of :state

  state_machine :initial => :sent do
    States.each do |name, value|
      state(name, value: value)
    end

    event :signed_up do
      transition :sent => :signed_up
    end

    event :confirmed_email do
      transition :signed_up => :confirmed_email
    end

    event :played do
      transition [:signed_up, :confirmed_email] => :played
    end

    event :paying do
      transition all => :paying
    end

    event :not_paying do
      transition :paying => :confirmed_email
    end
  end

  def coins
    case States.invert[state]
    when :sent
      0
    when :signed_up
      0
    when :confirmed_email
      60
    when :played
      120
    when :paying
      240
    end
  end

  def email
    data['email']
  end

  def email=(email)
    self.data ||= {}
    self.data['email'] = email
  end

  def claimable?
    self.class.where(user_id: user.id).count < LIMIT
  end

  def friend_link
    %Q{<a href="/#{friend.username}">#{friend.username}</a>}
  end

  def description
    case States.invert[state]
    when :sent
      'Sent to ' + email
    when :signed_up
      "#{friend_link} (Signed up, unconfirmed)".html_safe
    when :confirmed_email
      "#{friend_link} (Signed up)".html_safe
    when :played
      "#{friend_link} (Played on servers)".html_safe
    when :paying
      "#{friend_link} (Paying customer)".html_safe
    end
  end
end
