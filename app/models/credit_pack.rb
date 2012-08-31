class CreditPack < ActiveRecord::Base

  def amount
    cents
  end

end
