require 'spec_helper'

describe User do
  let(:user) { build :user }

  context 'Free plan' do
    before { user.save! }
    subject { user }
    its (:credits) { should == Plan.free.credits }
  end
  
  context 'Stripe token set' do
    it "should create stripe customer" do
      user.stripe_token = 'tok_12345'
      
      expect_stripe_create user, 'tok_12345'
      
      user.save!
    end
  end
  
  context 'with stripe customer' do
    context 'Plan changed from free to paid' do
      it "should update stripe subscription" do
        user.stub(:customer) { fake_customer }
        expect_stripe_update user, Plan.small
        
        user.plan_id = Plan.small.id
        user.save!
      end
        
      it "should add credits" do
        starting_credits = user.credits
        set_initial_plan user, Plan.small
        user.save!
        user.reload.credits.should == starting_credits + Plan.small.credits
      end
      
      it "should set next_recurring_charge_date" do
        starting_credits = user.credits
        set_initial_plan user, Plan.small
        user.save!
        user.reload.next_recurring_charge_date.to_date.should == Date.parse('2011-12-04')
      end
    end
  
    context 'Plan upgraded from paid to paid mid cycle' do
      before do
        set_initial_plan user, Plan.small
        user.save!
      
        user.credits = Plan.small.credits / 2
    
        Timecop.freeze(Date.parse('2011-11-15')) do
          expect_stripe_update user, Plan.medium, '2011-11-30'
          user.plan_id = Plan.medium.id
          user.save!
        end
      end
    
      it "should leave credits with current amount" do
        user.credits.should == Plan.small.credits / 2
      end
    end

    context 'Plan downgraded from paid to paid mid cycle' do
      before do
        set_initial_plan user, Plan.large 
        user.save!
      
        user.credits = 200
      
        Timecop.freeze(Date.parse('2011-11-15')) do
          expect_stripe_update user, Plan.small, '2011-11-30'
          user.plan_id = Plan.small.id
          user.save!
        end
      end
    
      it "should not change credits" do
        user.credits.should == 200
      end
    end

    context 'Plan subscription renewed' do
      it "should add new credits" do
        set_initial_plan user, Plan.large 
        user.save!
      
        user.credits = 200
        user.save!
      
        user.recurring_payment_succeeded! Plan.large.id
      
        user.reload.credits.should == 200 + Plan.large.credits
      end
    end
  end
end
