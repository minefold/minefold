class Bonuses::ReferredFriend < Bonus
  extend StateMachine::MacroMethods
  
  States = {
    sent: 0,
    signed_up: 1,
    confirmed_email: 2,
    paying: 3
  }

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
