require 'spec_helper'

describe User do
  let(:user) { build :user }

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
      expect_stripe_create user, Plan.casual
      user.plan = Plan.casual.stripe_id
      user.save!
    end
        
    it "should adjust credits" do
      expect_stripe_create user, Plan.casual
      user.plan = Plan.casual.stripe_id
      user.save!
      user.reload.credits.should == Plan.casual.credits
    end
    
    it "should set next recurring charge info" do
      expect_stripe_create user, Plan.casual, '2011-12-04'
      user.plan = Plan.casual.stripe_id
      user.save!
      user.next_recurring_charge_date.to_date.should == Time.parse('2011-12-04').to_date
      user.next_recurring_charge_amount.should == Plan.casual.price
    end
  end
  
  context 'Plan upgraded from paid to paid mid cycle' do
    before do
      expect_stripe_create user, Plan.casual
      user.plan = Plan.casual.stripe_id
      user.credits = user.credits / 2
      user.stripe_token = 'tok_12345'
      user.save!

      Timecop.freeze(Date.parse('2011-11-15')) do
        expect_stripe_update user, Plan.fun, '2011-11-30'
        expect_stripe_charge user, (Plan.fun.price - Plan.casual.price) / 2
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
      set_plan user, Plan.pro 
      user.save!
      
      user.credits = 200
      
      Timecop.freeze(Date.parse('2011-11-15')) do
        expect_stripe_update user, Plan.fun, '2011-11-30'
        user.plan = Plan.fun.stripe_id
        user.save!
      end
    end
    
    it "should not change credits" do
      user.credits.should == 200
    end
  end
  
  context 'Plan subscription renewed' do
    it "should reset credits" do
      set_plan user, Plan.pro 
      user.save!
      
      user.credits = 200
      user.save!
      
      user.renew_subscription!
      
      user.reload.credits.should == Plan.pro.credits
    end
  end
end
