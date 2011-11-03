require 'spec_helper'

describe User do
  # context 'Plan free -> casual' do
  #   before do
  #     user.plan = Plan.free.stripe_id
  #     user.save!
  #   end
  # 
  #   it "should create a stripe customer" do
  #     Stripe::Customer.should_receive(:create).with(
  #       description: user.customer_description,
  #       email: user.email,
  #       plan: Plan.casual.stripe_id,
  #       coupon: nil) { Struct.new(:id).new('stripe_id') }
  # 
  #     user.plan = Plan.casual.stripe_id
  #     user.save!
  #   end
  # end

end