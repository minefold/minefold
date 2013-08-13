class Invitation < ActiveRecord::Base
  extend StateMachine::MacroMethods

  belongs_to :sender, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  validates :state, presence: true,
                    numericality: { only_integer: true }
  validates :sender, presence: true
  validates :email, length: {minimum: 3, maximum: 255},
                    allow_nil: true

  States = {
    sent:      0, # Email sent. This won't happen for tweets etc
    accepted:  1, # From here on in, friend should be set
    confirmed: 2, # Confirmed their email address
  }

  state_machine :initial => :sent do
    States.each do |name, value|
      state(name, value: value)
    end

    event :accept do
      transition :sent => :accepted
    end

    event :confirm do
      transition :accepted => :confirmed
    end

    after_transition any => :confirmed do |invitation, transition|
      invitation.reward_friends!
    end
  end

  def reward_friends!
    Bonuses::ReferredFriend.give_to(sender)
    Bonuses::Referred.give_to(friend)
  end
  
  def display_state_name
    if state_name == 'accepted'
      'waiting for email confirmation'
    else
      state_name
    end
  end

end
