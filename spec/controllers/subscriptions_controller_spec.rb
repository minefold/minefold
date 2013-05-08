require 'spec_helper'

describe SubscriptionsController do
  let(:plan) { Plan.make(id: 11) }

  current_user { User.make(id: 12) }

  context 'unsubscribed user' do
    describe "POST #create" do
      it "subscribes user to plan" do
        Plan.stub(:find) { plan }

        subscription = stub(:subscription)
        subscription.stub(:plan) { plan }

        current_user.should_receive(:subscribe!).with(plan, 'tok_1234', '4242', nil) {
          subscription
        }

        post :create, plan_id: plan.id, stripeToken: 'tok_1234', last4: '4242'
      end

    end
  end
end
