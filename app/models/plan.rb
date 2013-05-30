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
    if cents - discount < 5
      discount = 0
    else
      discount
    end
  end

  def maps?
    stripe_id != 'micro'
  end
end
