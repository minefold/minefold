class Payment
  include MongoMapper::EmbeddedDocument

  key :status, String
  key :params

  def complete?
    status == 'Completed'
  end

  def refunded?
    status == 'Refunded'
  end

  def hours
    params['option_selection1'].to_i.hours
  end

  def gross
    Float params['payment_gross']
  end

  def fee
    Float params['payment_fee']
  end

end
