class Order
  include MongoMapper::Document

  belongs_to :user
  many :payments

  def process_payment(payment)
    user.add_credits(payment.hours) if payment.complete?
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

  def credits
    payments.inject(0) {|total, payment| total + payment.hours} / User::BILLING_PERIOD
  end

end
