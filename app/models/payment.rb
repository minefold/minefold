class Payment
  include MongoMapper::EmbeddedDocument

  key :params
  key :status, String
  key :txn_id, String

  def complete?
    status == 'Completed'
  end

  def credits
    params['option_selection1'].to_i
  end
end
