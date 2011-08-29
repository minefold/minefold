class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  belongs_to :user
  embeds_many :transactions

  # TODO: Store credits / cost etc. Needs seperate billing step.

  def fulfill!(n)
    user.increment_credits!(n.hours)
  end

  def status
    transactions.last.try(:status) || :pending
  end

  def gross
    transactions.sum(:gross)
  end

  def fee
    transactions.sum(:fee)
  end

end
