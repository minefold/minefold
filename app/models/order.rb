class Order
  include MongoMapper::Document

  belongs_to :user
  many :payments

  def process_payment(payment)
    if unfulfilled? and payment.complete?
      user.increment_credits(payment.credits)
    end

    self.payments << payment
  end

  def fulfilled?
    payments.any? {|payment| payment.complete?}
  end

  def unfulfilled?
    not fulfilled?
  end

  def status
    payments.empty? ? 'incomplete' : payments.last.status
  end

end
