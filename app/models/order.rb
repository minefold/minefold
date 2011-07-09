class Order
  include MongoMapper::Document

  many :payments
end
