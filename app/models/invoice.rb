class Invoice
  include Mongoid::Document

  embeds_one :payment
end
