class Payment
  include MongoMapper::EmbeddedDocument

  key :status, String
  key :params

  def complete?
    status == 'Completed'
  end

  def hours
    params['option_selection1'].to_i.hours
  end
end
