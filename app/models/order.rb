class Order
  include MongoMapper::Document

  belongs_to :user
  many :payments

  def process_payment(payment)
    self.payments << payment
    user.increment_credits(payment.credits) if payment.complete?
  end

  def status
    payments.empty? ? 'incomplete' : payments.last.status
  end

end
