class Stripe::Plan #Struct.new(:name, :stripe_id, :price, :hours, :worlds)
  include Mongoid::Fields::Serializable

  extend ActiveSupport::Memoizable

  # class << self
  #   memoize :all
  # end
  # self.memoize :all

  def deserialize(object)
    {id: object['id']}
  end

  def serialize(object)
    object.id
    # { "x" => object[0], "y" => object[1] }
  end

  def self.where(options={})
    all.find {|plan| plan.id == options.id}
  end

  # def self.fetch
  #   @plans = Stripe::Plan.all.data
  # end
  #
  # def self.all
  #   @plans
  # end

  # def self.casual
  #   Plan.new('Small', 'casual', 395, 40, 5)
  # end
  #
  # def self.fun
  #   Plan.new('Fun', 'fun', 795, 80, 10)
  # end
  #
  # def self.pro
  #   Plan.new('Pro', 'pro', 1195, 160, 40)
  # end
  #
  # def self.all
  #   [free, casual, fun, pro]
  # end
  #
  # def self.stripe_ids
  #   all.map(&:stripe_id)
  # end
  #
  # def self.find stripe_id
  #   all.find{|p| p.stripe_id == stripe_id}
  # end
  #
  # DEFAULT = free
  #
  # def credits
  #   hours.hours / User::BILLING_PERIOD
  # end
  #
  # def free?
  #   price == 0
  # end

end

