class Plan < ActiveRecord::Base
  attr_accessible :bolts, :cents, :name, :stripe_id

  default_scope order('cents')

  def discounted_cents(options)
    cents - discount_cents(options)
  end

  def discount_cents(options)
    discount = 0
    if (options[:discount] || 0) > 0
      discount += options[:discount]
    else
      discount += 100 if options[:intro]
      if options[:tradein]
        discount += 100 * [(options[:tradein] / 60 / 40), 5].min
      end
    end
    discount
  end
end
