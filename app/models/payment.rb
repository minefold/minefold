class Payment
  include MongoMapper::Document

  key :params
  key :status, String
  key :txn_id, String

  key :order_id, ObjectId

  belongs_to :order

  def complete?
    status == 'Completed'
  end

  def credits
    params['option_selection1'].to_i
  end

end
