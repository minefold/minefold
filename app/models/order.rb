class Order
  include MongoMapper::Document

  belongs_to :user
  many :payments

  def self.total_revenue
    Order.all.inject(0) {|t, o| t + o.total}
  end

  def self.total_fees
    Order.all.inject(0) {|t, o| t + o.fee}
  end

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
    payments.inject(0) {|t, p| t + p.hours} / User::BILLING_PERIOD
  end

  def gross
    payments.inject(0) {|t, p| t + p.gross}
  end

  def fee
    payments.inject(0) {|t, p| t + p.fee}
  end

  def total
    gross - fee
  end

end
