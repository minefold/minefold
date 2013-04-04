class Bonuses::ReferredFriend < Bonus
  extend StateMachine::MacroMethods

  States = {
    sent:            0,  # email sent. This won't happen for tweets etc
    signed_up:       1,
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

  self.coins = 60

  LIMIT = 16

  def self.coin_limit
    coins * LIMIT
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

  def description
    'Sent to ' + email
  end
end
