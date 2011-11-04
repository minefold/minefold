require 'spec_helper'

describe User do
  let(:user) { build :user }

  def expect_stripe_create plan, next_charge_date = '2011-12-04'
    Stripe::Customer.should_receive(:create).with(
      description: user.customer_description,
            email: user.email,
             plan: plan.stripe_id,
           coupon: nil,
             card: 'tok_12345'
    ) { Struct.new(:id, :next_recurring_charge).new('stripe_id', Struct.new(:date, :amount).new(next_charge_date, plan.price)) }
  end

  def expect_stripe_update plan, next_charge_date = '2011-12-04'
    customer = double("Stripe::Customer")
    customer.stub(:next_recurring_charge) { Struct.new(:date, :amount).new(next_charge_date, plan.price) }
    
    Stripe::Customer.should_receive(:retrieve).with(user.stripe_id) { customer }
    
    customer.should_receive(:update_subscription).with(
          plan: plan.stripe_id,
        coupon: user.coupon,
          card: user.stripe_token,
       prorate: false
    )
  end
  
  def expect_stripe_charge amount 
    Stripe::Charge.should_receive(:create).with(
      :amount => amount,
      :currency => "usd",
      :customer => user.stripe_id,
      :description => "Minefold.com Fun plan"
    )
  end
  
  context 'Free plan' do
    before { user.save! }
    subject { user }
    its (:credits) { should == Plan.free.credits }
  end
  
  context 'Plan changed from free to paid' do
    
    before do
      user.plan = Plan.free.stripe_id
      user.save!

      user.stripe_token = 'tok_12345'
    end
  
    it "should create a stripe customer" do
      expect_stripe_create Plan.casual
      user.plan = Plan.casual.stripe_id
      user.save!
    end
        
    it "should adjust credits" do
      expect_stripe_create Plan.casual
      user.plan = Plan.casual.stripe_id
      user.save!
      user.reload.credits.should == Plan.casual.credits
    end
    
    it "should set next recurring charge info" do
      expect_stripe_create Plan.casual, '2011-12-04'
      user.plan = Plan.casual.stripe_id
      user.save!
      user.next_recurring_charge_date.to_date.should == Time.parse('2011-12-04').to_date
      user.next_recurring_charge_amount.should == Plan.casual.price
    end
  end
  
  context 'Plan upgraded from paid to paid mid cycle' do
    before do
      expect_stripe_create Plan.casual
      user.plan = Plan.casual.stripe_id
      user.credits = user.credits / 2
      user.stripe_token = 'tok_12345'
      user.save!

      Timecop.freeze(Date.parse('2011-11-15')) do
        expect_stripe_update Plan.fun, '2011-11-30'
        expect_stripe_charge (Plan.fun.price - Plan.casual.price) / 2
        user.plan = Plan.fun.stripe_id
        user.save!
      end
    end
    
    it "should replace credits with new amount" do
      user.credits.should == Plan.fun.credits
    end
  end

  context 'Plan downgraded from paid to paid mid cycle' do
    before do
      expect_stripe_create Plan.pro
      user.plan = Plan.pro.stripe_id
      user.stripe_token = 'tok_12345'
      user.save!
      
      user.credits = 200
      
      Timecop.freeze(Date.parse('2011-11-15')) do
        expect_stripe_update Plan.fun, '2011-11-30'
        user.plan = Plan.fun.stripe_id
        user.save!
      end
    end
    
    it "should not change credits" do
      user.credits.should == 200
    end
  end
end
