require 'spec_helper'

describe SubscriptionsController do
  let(:plan) { Plan.make }
  
  current_user { User.make }
  
  context 'unsubscribed user' do
    describe "POST #create" do
      it "subscribes user to plan" do
        Plan.stub(:find).with(plan.id) { plan }

        current_user.should_receive(:subscribe!).with(plan, 'tok_1234', '4242') {
          stub(:charge, id: 'charge_1', amount: 1499)
        }

        post :create, plan_id: plan.id, stripeToken: 'tok_1234', last4: '4242'
      end

    end
  end
end
