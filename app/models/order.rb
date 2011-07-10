class Order
  include MongoMapper::Document

  belongs_to :user
  many :payments

  def receive_payment!(payment)
    self.payments << payment

    user.add_credits payment.credits
    save
  end

  def status
    payments.empty? ? 'incomplete' : payments.last.status
  end

end
