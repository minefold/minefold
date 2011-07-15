class Order
  include MongoMapper::Document

  belongs_to :user
  many :payments

  def process_payment(payment)
    self.payments << payment
    user.credit(payment.credits.hours) if payment.complete?
  end

  def status
    payments.empty? ? 'incomplete' : payments.last.status
  end

end
