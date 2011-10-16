class Invoice
  include MongoMapper::Document

  embeds_one :payment
end
