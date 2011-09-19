class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  PAYMENT_STATUSES = %W(
    Canceled_Reversal Completed Created Denied Expired Failed Pending Refunded
    Reversed Processed Voided )

  field :status, type: String, default: 'pending'
  embedded_in :order


  PAYMENT_STATUSES.each do |status|
    define_method("#{status.downcase}?") {self[:payment_status] == status}
  end

  def status
    super.to_sym
  end

  def payment_status=(status)
    self.status = status.downcase
    self[:payment_status] = status
  end

  def credits
    self[:option_selection1].to_i.hours / User::BILLING_PERIOD
  end

  def hours
    credits / User::BILLING_PERIOD
  end

  def gross
    Float self[:payment_gross]
  end

  def fee
    Float self[:payment_fee]
  end

  def total
    gross - fee
  end

end
