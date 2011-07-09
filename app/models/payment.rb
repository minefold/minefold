class Payment
  include MongoMapper::Document

  key :params
  key :status, String
  key :txn_id, String

  key :purchase_id, ObjectId

  belongs_to :order

  before_validation on: :create do
    self.status = params[:status]
    self.txn_id = params[:txn_id]
    self.purchase_id = params[:invoice]
  end

  def new_from_params(params)
    self.params = params

    self.status = params[:status]
    self.txn_id = params[:txn_id]
    self.purchase_id = params[:invoic]
  end


  after_create do
    order.receive_payment(self) if completed?
  end

  def completed?
    status == 'Completed'
  end

end
